package com.viotory.diary.controller;

import com.viotory.diary.dto.WinYoAnalysisDTO;
import com.viotory.diary.mapper.ContentMngMapper;
import com.viotory.diary.service.DiaryService;
import com.viotory.diary.service.GameService;
import com.viotory.diary.service.WinYoService;
import com.viotory.diary.vo.DiaryVO;
import com.viotory.diary.vo.EventVO;
import com.viotory.diary.vo.GameVO;
import com.viotory.diary.vo.MemberVO;
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

    // 1. 처음 접속 시 스플래시 화면 노출
    @GetMapping("/")
    public String splashPage(HttpSession session) {
        // 이미 로그인된 상태라면 바로 메인으로 (선택 사항)
        if (session.getAttribute("loginMember") != null) {
            return "redirect:/main";
        }
        return "splash"; // /WEB-INF/views/splash.jsp
    }

    @GetMapping("/main")
    public String mainPage(Model model, HttpSession session) {

        // 1. 세션에서 로그인 정보 가져오기
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");

        // 비로그인 접근 차단
        if (loginMember == null) return "redirect:/member/login";

        try {
            // 1) 내 팀 경기 정보 조회 (오늘 날짜 기준)
            String myTeamCode = loginMember.getMyTeamCode();
            if (myTeamCode != null && !"NONE".equals(myTeamCode)) {
                GameVO todayGame = gameService.getTodayGame(myTeamCode);
                model.addAttribute("todayGame", todayGame);
            }

            // 3. [승요력] 나의 직관 승률 분석 데이터
            WinYoAnalysisDTO winYoStats = winYoService.analyzeWinYoPower(loginMember.getMemberId());
            model.addAttribute("winYo", winYoStats);

            // 4. [직관 일기] 최근 작성한 일기 (최대 3개)
            List<DiaryVO> recentDiaries = diaryService.getRecentDiaries(loginMember.getMemberId()); // Service에 메서드 추가 필요
            model.addAttribute("diaries", recentDiaries);

            // 5. [이벤트/팀뉴스] (추후 관리자 기능 연동 시 추가)
            // List<EventVO> events = contentService.getActiveEvents();
            // model.addAttribute("events", events);

        } catch (Exception e) {
            log.error("메인 화면 데이터 로딩 중 오류 발생", e);
            // 오류 발생 시에도 메인 화면은 떠야 함 (빈 데이터로 처리)
        }

        return "main"; // /WEB-INF/views/main.jsp

        // 서비스 준비중 페이지로 연결
        //return "maintenance";
    }

}