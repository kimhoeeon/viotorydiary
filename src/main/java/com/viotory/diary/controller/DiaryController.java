package com.viotory.diary.controller;

import com.viotory.diary.dto.CommentDTO;
import com.viotory.diary.dto.WinYoAnalysisDTO;
import com.viotory.diary.service.CommentService;
import com.viotory.diary.service.DiaryService;
import com.viotory.diary.service.GameService;
import com.viotory.diary.service.WinYoService;
import com.viotory.diary.vo.DiaryVO;
import com.viotory.diary.vo.GameVO;
import com.viotory.diary.vo.MemberVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Slf4j
@Controller
@RequestMapping("/diary")
@RequiredArgsConstructor
public class DiaryController {

    private final DiaryService diaryService;
    private final GameService gameService;
    private final CommentService commentService;
    private final WinYoService winYoService;

    // 1. 일기 작성 페이지 이동
    @GetMapping("/write")
    public String writePage(@RequestParam(value = "gameId", required = false) Long gameId,
                            HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        // 메인에서 '오늘의 경기 기록하기'로 넘어온 경우, 해당 경기 정보를 미리 세팅
        if (gameId != null) {
            GameVO game = gameService.getGameById(gameId);

            // 경기 정보가 유효하다면 모델에 추가
            if (game != null) {
                model.addAttribute("selectedGame", game);
                model.addAttribute("targetGameId", gameId);
            }
        }

        return "diary/diary_write"; // views/diary/diary_write.jsp
    }

    // 2. 일기 저장 처리
    @PostMapping("/write")
    public String writeAction(DiaryVO diary, HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        try {
            // 세션 정보 주입
            diary.setMemberId(loginMember.getMemberId());
            diary.setSnapshotTeamCode(loginMember.getMyTeamCode());

            Long diaryId = diaryService.writeDiary(diary);

            return "redirect:/diary/complete?diaryId=" + diaryId;
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("diary", diary); // 입력값 유지
            return "diary/diary_write";
        }
    }

    // 3. 작성 완료 페이지
    @GetMapping("/complete")
    public String completePage(@RequestParam("diaryId") Long diaryId, Model model) {
        // 방금 쓴 일기 정보 조회 (한줄평 등 표시용)
        DiaryVO diary = diaryService.getDiary(diaryId);
        model.addAttribute("diary", diary);
        return "diary/diary_comp";
    }

    // 4. 저장 실패 페이지
    @GetMapping("/fail")
    public String failPage() {
        return "diary/diary_fail";
    }

    // [AJAX] 경기 검색/목록 조회 (팝업용)
    @GetMapping("/api/games")
    @ResponseBody
    public List<GameVO> getGameList(HttpSession session) {
        // 이번 달 또는 최근 경기 리스트를 반환
        // 여기서는 간단히 '오늘 전체 경기' 또는 '최근 7일 경기' 등을 조회하도록 구현
        return gameService.getAllGamesToday(); // 실제로는 날짜 범위 조회 필요
    }

    // 5. 일기 상세 페이지
    @GetMapping("/detail")
    public String detailPage(@RequestParam("diaryId") Long diaryId,
                             HttpSession session, Model model) {
        // 1. 일기 정보 조회
        DiaryVO diary = diaryService.getDiary(diaryId);
        if (diary == null) return "redirect:/diary/list";

        // 2. 댓글 목록 조회
        List<com.viotory.diary.dto.CommentDTO> comments = commentService.getCommentsByDiaryId(diaryId);

        // 3. 권한 및 상태 체크
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        boolean isOwner = (loginMember != null && loginMember.getMemberId().equals(diary.getMemberId()));

        // 수정 가능 여부 체크 (경기 시작 1시간 전까지만 수정 가능)
        // diary.gameDate(yyyy-MM-dd)와 diary.gameTime(HH:mm)을 합쳐서 비교
        boolean isEditable = true;
        if (diary.getGameDate() != null && diary.getGameTime() != null) {
            try {
                String dateTimeStr = diary.getGameDate() + " " + diary.getGameTime(); // "2024-05-01 18:30"
                LocalDateTime gameStart = LocalDateTime.parse(dateTimeStr, DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));

                // 현재 시간이 (경기시작 - 1시간) 이후라면 수정 불가
                if (LocalDateTime.now().isAfter(gameStart.minusHours(1))) {
                    isEditable = false;
                }
            } catch (Exception e) {
                log.error("날짜 파싱 오류", e);
            }
        }

        model.addAttribute("diary", diary);
        model.addAttribute("comments", comments);
        model.addAttribute("isOwner", isOwner);
        model.addAttribute("isEditable", isEditable);

        return "diary/diary_detail";
    }

    // 댓글 삭제 (AJAX)
    @PostMapping("/comment/delete")
    @ResponseBody
    public String deleteCommentAction(@RequestParam("commentId") Long commentId,
                                      HttpSession session) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "fail:login";

        try {
            // 본인 확인은 Service/Mapper 레벨에서 처리 (requestMemberId 전달)
            commentService.deleteComment(commentId, loginMember.getMemberId());
            return "ok";
        } catch (Exception e) {
            log.error("댓글 삭제 오류", e);
            return "fail";
        }
    }

    // 댓글 작성 처리 (AJAX)
    @PostMapping("/comment/write")
    @ResponseBody
    public String writeCommentAction(@RequestParam("diaryId") Long diaryId,
                                     @RequestParam("content") String content,
                                     HttpSession session) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "fail:login";

        try {
            com.viotory.diary.dto.CommentDTO comment = new com.viotory.diary.dto.CommentDTO();
            comment.setDiaryId(diaryId);
            comment.setMemberId(loginMember.getMemberId());
            comment.setContent(content);

            commentService.writeComment(comment);

            return "ok";
        } catch (Exception e) {
            log.error("댓글 작성 실패", e);
            return "fail";
        }
    }

    // 일기 목록 페이지
    @GetMapping("/list")
    public String listPage(HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        // 1. 일기 목록 조회
        List<DiaryVO> list = diaryService.getMyDiaryList(loginMember.getMemberId());
        model.addAttribute("list", list);

        // 2. 승요력 분석 데이터 조회
        com.viotory.diary.dto.WinYoAnalysisDTO winYo = winYoService.analyzeWinYoPower(loginMember.getMemberId());
        model.addAttribute("winYo", winYo);

        return "diary/diary_list";
    }

    // 일기 삭제 처리 (AJAX)
    @PostMapping("/delete")
    @ResponseBody
    public String deleteDiaryAction(@RequestParam("diaryId") Long diaryId,
                                    HttpSession session) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "fail:login";

        try {
            diaryService.deleteDiary(diaryId, loginMember.getMemberId());
            return "ok";
        } catch (Exception e) {
            log.error("일기 삭제 실패", e);
            return "fail";
        }
    }

}