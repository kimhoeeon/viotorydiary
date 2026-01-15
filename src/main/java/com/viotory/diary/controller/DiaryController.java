package com.viotory.diary.controller;

import com.viotory.diary.dto.CommentDTO;
import com.viotory.diary.dto.WinYoAnalysisDTO;
import com.viotory.diary.service.*;
import com.viotory.diary.vo.DiaryVO;
import com.viotory.diary.vo.GameVO;
import com.viotory.diary.vo.MemberVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpSession;
import java.io.File;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.UUID;

@Slf4j
@Controller
@RequestMapping("/diary")
@RequiredArgsConstructor
public class DiaryController {

    private final DiaryService diaryService;
    private final GameService gameService;
    private final CommentService commentService;
    private final WinYoService winYoService;
    private final MemberService memberService;

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
    public String writeAction(DiaryVO diary,
                              @RequestParam(value = "file", required = false) MultipartFile file,
                              HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        try {
            // 파일 업로드
            if (file != null && !file.isEmpty()) {
                String savedFileName = saveFile(file);
                diary.setImageUrl("/uploads/" + savedFileName); // DB에는 웹 접근 경로 저장
            }

            diary.setMemberId(loginMember.getMemberId());
            diary.setSnapshotTeamCode(loginMember.getMyTeamCode());

            Long diaryId = diaryService.writeDiary(diary);
            return "redirect:/diary/complete?diaryId=" + diaryId;
        } catch (Exception e) {
            log.error("일기 작성 실패", e);
            model.addAttribute("error", e.getMessage());
            model.addAttribute("diary", diary);
            return "diary/diary_write";
        }
    }

    // --- [1] 일기 수정 페이지 이동 (GET) ---
    @GetMapping("/update")
    public String updatePage(@RequestParam("diaryId") Long diaryId,
                             HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        // 1. 기존 일기 정보 조회
        DiaryVO diary = diaryService.getDiary(diaryId);

        // 2. 권한 확인 (본인 글이 아니면 튕겨냄)
        if (diary == null || !diary.getMemberId().equals(loginMember.getMemberId())) {
            return "redirect:/diary/list";
        }

        // 3. 경기 정보 조회 (화면에 "LG vs 두산" 등을 보여주기 위함)
        GameVO game = gameService.getGameById(diary.getGameId());

        model.addAttribute("diary", diary);
        model.addAttribute("selectedGame", game);

        return "diary/diary_update";
    }

    // --- [2] 일기 수정 처리 (POST) ---
    @PostMapping("/update")
    public String updateAction(DiaryVO diary,
                               @RequestParam(value = "file", required = false) MultipartFile file,
                               HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        try {
            diary.setMemberId(loginMember.getMemberId());

            // [이미지 처리 로직]
            if (file != null && !file.isEmpty()) {
                // 1. 새 파일이 업로드된 경우 -> 저장 후 경로 교체
                String savedFileName = saveFile(file);
                diary.setImageUrl("/uploads/" + savedFileName);
            }
            // 2. 새 파일이 없는 경우
            // -> JSP의 <input type="hidden" name="imageUrl" value="...">에 의해
            //    기존 diary.imageUrl 값이 그대로 넘어오므로 별도 처리 불필요.

            // 3. DB 업데이트
            diaryService.modifyDiary(diary);

            return "redirect:/diary/detail?diaryId=" + diary.getDiaryId();

        } catch (Exception e) {
            log.error("일기 수정 실패", e);
            model.addAttribute("error", e.getMessage());
            // 에러 발생 시 수정 페이지로 되돌아가기 (ID 유지)
            return "redirect:/diary/update?diaryId=" + diary.getDiaryId();
        }
    }

    // --- [파일 저장 유틸 메소드] ---
    // 사용자 홈 디렉터리(user.home) 밑에 저장하여 배포 시에도 유지됨
    private String saveFile(MultipartFile file) throws Exception {
        if (file.isEmpty()) return null;

        String uploadDir = getUploadDir();

        File dir = new File(uploadDir);
        if (!dir.exists()) dir.mkdirs();

        // 파일명 중복 방지 (UUID 사용)
        String uuid = UUID.randomUUID().toString();
        String originalName = file.getOriginalFilename();
        String savedName = uuid + "_" + originalName;

        // 실제 파일 저장
        File dest = new File(dir, savedName);
        file.transferTo(dest);

        log.info("파일 업로드 완료: {}", dest.getAbsolutePath());
        return savedName;
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

    // [변경] 저장 경로 가져오기 (OS 독립적)
    private String getUploadDir() {
        return Paths.get(System.getProperty("user.home"), "viotory", "upload").toString();
    }

    // 친구 일기 상세 페이지
    @GetMapping("/friend/detail")
    public String friendDetailPage(@RequestParam("diaryId") Long diaryId,
                                   HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        // 1. 일기 정보 조회
        DiaryVO diary = diaryService.getDiary(diaryId);
        if (diary == null) return "redirect:/diary/friend/list";

        // 2. 작성자(친구) 정보 조회
        Long writerId = diary.getMemberId();
        MemberVO writer = memberService.getMemberInfo(writerId);

        // 3. 작성자의 승요력(승률) 조회
        WinYoAnalysisDTO writerWinYo = winYoService.analyzeWinYoPower(writerId);

        // 4. 팔로우 여부 확인
        boolean isFollowing = memberService.isFollowing(loginMember.getMemberId(), writerId);

        // 5. 댓글 조회
        List<CommentDTO> comments = commentService.getCommentsByDiaryId(diaryId);

        model.addAttribute("diary", diary);
        model.addAttribute("writer", writer);
        model.addAttribute("writerWinYo", writerWinYo);
        model.addAttribute("isFollowing", isFollowing);
        model.addAttribute("comments", comments);

        return "diary/friend_detail";
    }

    // 친구 일기 목록 (피드)
    @GetMapping("/friend/list")
    public String friendDiaryList(HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        List<DiaryVO> list = diaryService.getAllFriendDiaries(loginMember.getMemberId());
        model.addAttribute("list", list);

        return "diary/friend_list"; // views/diary/friend_list.jsp
    }

    // 공유 링크 발급 (AJAX)
    @PostMapping("/share/create")
    @ResponseBody
    public String createShareLink(@RequestParam("diaryId") Long diaryId, HttpSession session) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "fail:login";

        try {
            // 본인 확인 로직 필요 (Service에서 처리 권장)
            // 여기서는 간단히 UUID 생성 호출
            return diaryService.generateShareLink(diaryId); // 클라이언트에 UUID 반환 -> URL 완성
        } catch (Exception e) {
            log.error("공유 링크 생성 실패", e);
            return "fail";
        }
    }

}