package com.viotory.diary.controller;

import com.viotory.diary.dto.CommentDTO;
import com.viotory.diary.dto.WinYoAnalysisDTO;
import com.viotory.diary.service.*;
import com.viotory.diary.util.DistanceUtil;
import com.viotory.diary.util.FileUtil;
import com.viotory.diary.vo.DiaryVO;
import com.viotory.diary.vo.GameVO;
import com.viotory.diary.vo.MemberVO;
import com.viotory.diary.vo.StadiumVO;
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
                diary.setImageUrl(FileUtil.uploadFile(file, "diary")); // DB에는 웹 접근 경로 저장
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
        if (diary == null) return "redirect:/diary/list";

        // 2. 권한 확인 (본인 글이 아니면 튕겨냄)
        if (!diary.getMemberId().equals(loginMember.getMemberId())) {
            return "redirect:/diary/detail?diaryId=" + diaryId;
        }

        // 3. 경기 정보 조회 (화면에 "LG vs 두산" 등을 보여주기 위함)
        GameVO game = gameService.getGameById(diary.getGameId());

        model.addAttribute("diary", diary);
        model.addAttribute("game", game);

        return "diary/diary_update";
    }

    // --- [2] 일기 수정 처리 (POST) ---
    @PostMapping("/update")
    @ResponseBody
    public String updateAction(@ModelAttribute DiaryVO diary,
                               @RequestParam(value = "file", required = false) MultipartFile file,
                               HttpSession session) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) {
            return "<script>alert('로그인이 필요합니다.'); location.href='/member/login';</script>";
        }

        try {

            // 1. 기존 일기 정보 조회 (GameId 확보용)
            DiaryVO originalDiary = diaryService.getDiary(diary.getDiaryId());
            if (originalDiary == null) {
                return "<script>alert('존재하지 않는 일기입니다.'); history.back();</script>";
            }

            // 2. 작성자 본인 확인
            if (!originalDiary.getMemberId().equals(loginMember.getMemberId())) {
                return "<script>alert('수정 권한이 없습니다.'); history.back();</script>";
            }

            // 3. [핵심] 경기 시작 1시간 전 체크
            // 원본 일기의 경기 정보를 가져옴
            GameVO game = gameService.getGameById(originalDiary.getGameId());
            if (game != null) {
                String dateTimeStr = game.getGameDate() + " " + game.getGameTime();
                LocalDateTime gameStart = LocalDateTime.parse(dateTimeStr, DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")); // 초 단위 포맷 주의

                // 현재 시간이 (경기시작 - 1시간) 이후라면 수정 불가
                if (LocalDateTime.now().isAfter(gameStart.minusHours(1))) {
                    return "<script>alert('경기 시작 1시간 전까지만 수정할 수 있습니다.'); history.back();</script>";
                }
            }

            // [이미지 처리 로직]
            if (file != null && !file.isEmpty()) {
                // 1. 새 파일이 업로드된 경우 -> 저장 후 경로 교체
                diary.setImageUrl(FileUtil.uploadFile(file, "diary"));
            }

            // 작성자 ID 세팅 (보안)
            diary.setMemberId(loginMember.getMemberId());

            // 3. DB 업데이트
            diaryService.modifyDiary(diary);

            return "<script>alert('수정되었습니다.'); location.href='/diary/detail?diaryId=" + diary.getDiaryId() + "';</script>";

        } catch (Exception e) {
            log.error("일기 수정 실패", e);
            return "<script>alert('수정 중 오류가 발생했습니다.'); history.back();</script>";
        }
    }

    // --- [파일 저장 유틸 메소드] ---
    private String saveFile(MultipartFile file) throws Exception {
        if (file.isEmpty()) return null;

        // 1. 기본 업로드 루트 경로
        String rootPath = "/usr/local/tomcat/webapps/upload";

        // 2. [수정] 기능별 하위 폴더 지정 ("diary")
        // 결과 경로: /usr/local/tomcat/webapps/upload/diary
        File uploadDir = new File(rootPath, "diary");

        // 3. 폴더가 없으면 생성 (diary 폴더가 자동 생성됨)
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        String uuid = UUID.randomUUID().toString();
        String originalName = file.getOriginalFilename();
        String savedName = uuid + "_" + originalName;

        // 4. 파일 저장
        File dest = new File(uploadDir, savedName);
        file.transferTo(dest);

        // 5. DB 저장용 URL (웹 접근 경로)
        // 중요: URL에도 /upload/diary/ 가 포함되어야 함
        return "/upload/diary/" + savedName;
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
        List<CommentDTO> comments = commentService.getCommentsByDiaryId(diaryId);

        // 3. 권한 및 상태 체크
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        boolean isOwner = (loginMember != null && loginMember.getMemberId().equals(diary.getMemberId()));

        // 수정 가능 여부 체크 (경기 시작 1시간 전까지만 수정 가능)
        // diary.gameDate(yyyy-MM-dd)와 diary.gameTime(HH:mm)을 합쳐서 비교
        boolean isEditable = true;
        String lockReason = ""; // JSP에서 멘트 구분을 위해 사용

        // 정확한 상태 판단을 위해 Game 정보 조회
        GameVO game = gameService.getGameById(diary.getGameId());

        if (game != null) {
            try {
                // 1. 경기 종료/취소 여부 확인
                if ("FINISHED".equals(game.getStatus()) || "CANCELLED".equals(game.getStatus())) {
                    isEditable = false;
                    lockReason = "FINISHED"; // 이미 종료됨
                } else {
                    // 2. 경기 시작 1시간 전 체크 (초 단위 포함 포맷으로 수정)
                    String dateTimeStr = game.getGameDate() + " " + game.getGameTime(); // "2024-03-09 13:00:00"
                    LocalDateTime gameStart = LocalDateTime.parse(dateTimeStr, DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));

                    if (LocalDateTime.now().isAfter(gameStart.minusHours(1))) {
                        isEditable = false;
                        lockReason = "IMMINENT"; // 임박함
                    }
                }
            } catch (Exception e) {
                log.error("경기 상태 체크 중 오류: {}", e.getMessage());
            }
        }

        model.addAttribute("diary", diary);
        model.addAttribute("comments", comments);
        model.addAttribute("isOwner", isOwner);
        model.addAttribute("isEditable", isEditable);
        model.addAttribute("lockReason", lockReason);

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
        if (loginMember == null) return "fail:login"; // 로그인 필요

        try {
            // 1. 일기 정보 조회 (존재 여부 확인)
            DiaryVO diary = diaryService.getDiary(diaryId);
            if (diary == null) {
                return "fail:not_found"; // 일기가 없음
            }

            // 2. 권한 체크 (작성자 본인만 공유 링크 생성 가능)
            if (!diary.getMemberId().equals(loginMember.getMemberId())) {
                return "fail:permission"; // 권한 없음 (남의 글)
            }

            // 3. 비공개 글인지 체크 (선택 사항: 비공개 글은 공유 불가 정책이라면 추가)
            if ("PRIVATE".equals(diary.getIsPublic())) {
                return "fail:private"; // 비공개 글은 공유 불가
            }

            // 4. 공유 UUID 생성 및 반환
            return diaryService.generateShareLink(diaryId);

        } catch (Exception e) {
            log.error("공유 링크 생성 실패", e);
            return "fail:error";
        }
    }

    // GPS 직관 인증 API
    @PostMapping("/verify/gps")
    @ResponseBody
    public String verifyGps(@RequestParam("gameId") Long gameId,
                            @RequestParam("lat") Double userLat,
                            @RequestParam("lon") Double userLon) {
        try {
            // 1. 경기 정보 조회
            GameVO game = gameService.getGameById(gameId);
            if (game == null) return "fail:game_not_found";

            // 2. 구장 정보 및 좌표 조회
            StadiumVO stadium = gameService.getStadium(game.getStadiumId());
            if (stadium == null || stadium.getLat() == null || stadium.getLon() == null) {
                // 구장 좌표 데이터가 DB에 없는 경우
                return "fail:stadium_info_missing";
            }

            // 3. 거리 계산 (반경 2km 이내 인정)
            double distance = DistanceUtil.distance(userLat, userLon, stadium.getLat(), stadium.getLon());

            log.info("GPS 인증 시도 - 경기: {}, 유저위치: ({}, {}), 구장: {}, 거리: {}km",
                    gameId, userLat, userLon, stadium.getName(), String.format("%.2f", distance));

            if (distance <= 2.0) { // 2km 이내
                return "ok"; // 인증 성공
            } else {
                return "fail:distance"; // 거리가 멉니다
            }

        } catch (Exception e) {
            log.error("GPS 인증 처리 중 오류", e);
            return "fail:error";
        }
    }

}