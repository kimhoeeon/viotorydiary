package com.viotory.diary.controller;

import com.viotory.diary.dto.WinYoAnalysisDTO;
import com.viotory.diary.service.*;
import com.viotory.diary.vo.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import javax.servlet.http.HttpSession;
import java.util.List;

@Slf4j
@Controller
@RequiredArgsConstructor
public class MainController {

    private final GameService gameService;
    private final WinYoService winYoService;
    private final DiaryService diaryService;
    private final LockerService lockerService;
    private final ContentMngService contentMngService;

    // 1. 처음 접속 시 스플래시 화면 노출
    @GetMapping("/")
    public String splashPage(HttpSession session) {
        // 이미 로그인된 상태라면 바로 메인으로 (선택 사항)
        if (session.getAttribute("loginMember") != null) {
            return "redirect:/main";
        }
        return "splash"; // /WEB-INF/views/splash.jsp
    }

    // [추가] 점검 페이지 매핑
    @GetMapping("/maintenance")
    public String maintenance() {
        return "maintenance"; // /WEB-INF/views/maintenance.jsp 연결
    }

    @GetMapping("/main")
    public String mainPage(Model model, HttpSession session) {

        // 1. 세션에서 로그인 정보 가져오기
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");

        // 비로그인 접근 차단
        if (loginMember == null) return "redirect:/member/login";

        try {

            String myTeamCode = loginMember.getMyTeamCode();

            // 1. [오늘 경기]
            if (myTeamCode != null && !"NONE".equals(myTeamCode)) {
                GameVO todayGame = gameService.getTodayGame(myTeamCode);
                if (todayGame != null) {
                    model.addAttribute("todayGame", todayGame);
                }
            }

            // 2. [승요력]
            WinYoAnalysisDTO winYoStats = winYoService.analyzeWinYoPower(loginMember.getMemberId());
            model.addAttribute("winYo", winYoStats);

            // 3. [구단 콘텐츠] 랜덤 배너
            TeamContentVO randomBanner = contentMngService.getRandomTeamContent(myTeamCode);
            if (randomBanner != null) {
                model.addAttribute("teamBannerItem", randomBanner);
            }

            // 4. [이벤트] 최신글 1개
            List<LockerVO> events = lockerService.getPostList("EVENT", 1, 1);
            if (!events.isEmpty()) {
                model.addAttribute("latestEvent", events.get(0));
            }

            // 5. [직관 일기] 최근 일기 3개
            List<DiaryVO> recentDiaries = diaryService.getRecentDiaries(loginMember.getMemberId()); // Service에 메서드 추가 필요
            model.addAttribute("diaries", recentDiaries);

            // 6. [새 소식] 최신글 리스트
            List<LockerVO> contents = lockerService.getPostList("CONTENT", 1, 3);
            if (!contents.isEmpty()) {
                model.addAttribute("latestContent", contents.get(0));
            }

        } catch (Exception e) {
            log.error("메인 화면 데이터 로딩 중 오류 발생", e);
        }

        return "main"; // /WEB-INF/views/main.jsp

        // 서비스 준비중 페이지로 연결
        //return "maintenance";
    }

}