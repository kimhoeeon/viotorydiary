package com.viotory.diary.controller;

import com.viotory.diary.dto.WinYoAnalysisDTO;
import com.viotory.diary.mapper.AdminMngMapper;
import com.viotory.diary.service.DiaryService;
import com.viotory.diary.service.GameService;
import com.viotory.diary.service.LockerService;
import com.viotory.diary.service.WinYoService;
import com.viotory.diary.vo.DiaryVO;
import com.viotory.diary.vo.GameVO;
import com.viotory.diary.vo.LockerVO;
import com.viotory.diary.vo.MemberVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import javax.servlet.http.HttpSession;
import java.io.File;
import java.util.List;

@Slf4j
@Controller
@RequiredArgsConstructor
public class MainController {

    private final GameService gameService;
    private final WinYoService winYoService;
    private final DiaryService diaryService;
    private final LockerService lockerService;

    private final AdminMngMapper adminMngMapper;

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
            // 2. [경기 일정] 내 팀 경기 정보 조회 (오늘 날짜 기준)
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

            // 5. [이벤트] 라커룸 'EVENT' 카테고리 최신글 1개 조회 (배너용)
            // (getPostList는 category, page, size를 받음)
            List<LockerVO> events = lockerService.getPostList("EVENT", 1, 1);
            if (!events.isEmpty()) {
                model.addAttribute("latestEvent", events.get(0));
            }

            // 6. [우리 팀 새 소식] 라커룸 'CONTENT' 카테고리 최신글 1개 조회
            List<LockerVO> contents = lockerService.getPostList("CONTENT", 1, 1);
            if (!contents.isEmpty()) {
                model.addAttribute("latestContent", contents.get(0));
            }

            // [신규] 시스템 상태 정보 수집
            addSystemStatus(model);

        } catch (Exception e) {
            log.error("메인 화면 데이터 로딩 중 오류 발생", e);
        }

        return "main"; // /WEB-INF/views/main.jsp

        // 서비스 준비중 페이지로 연결
        //return "maintenance";
    }

    // --- 시스템 상태 정보 수집 메소드 ---
    private void addSystemStatus(Model model) {
        // 1. DB 연결 상태 체크
        boolean dbStatus = false;
        try {
            // [요청사항 반영] adminMngMapper를 이용한 테스트 쿼리 실행
            // "admin"이라는 ID가 존재하는지 체크하는 가벼운 쿼리
            adminMngMapper.checkLoginId("admin");
            dbStatus = true;
        } catch (Exception e) {
            log.error("DB Connection Check Failed", e);
            dbStatus = false;
        }
        model.addAttribute("sysDbStatus", dbStatus);

        // 2. JVM 메모리 상태 (MB)
        Runtime runtime = Runtime.getRuntime();
        long totalMemory = runtime.totalMemory() / (1024 * 1024);
        long freeMemory = runtime.freeMemory() / (1024 * 1024);
        long usedMemory = totalMemory - freeMemory;

        // 0으로 나누기 방지
        int memoryUsage = 0;
        if (totalMemory > 0) {
            memoryUsage = (int) ((double) usedMemory / totalMemory * 100);
        }

        model.addAttribute("sysMemoryUsed", usedMemory);
        model.addAttribute("sysMemoryTotal", totalMemory);
        model.addAttribute("sysMemoryUsage", memoryUsage);

        // 3. 디스크 공간 (GB)
        File root = new File("/");
        long totalSpace = root.getTotalSpace() / (1024 * 1024 * 1024);
        long freeSpace = root.getUsableSpace() / (1024 * 1024 * 1024);
        long usedSpace = totalSpace - freeSpace;

        int diskUsage = 0;
        if (totalSpace > 0) {
            diskUsage = (int) ((double) usedSpace / totalSpace * 100);
        }

        model.addAttribute("sysDiskUsed", usedSpace);
        model.addAttribute("sysDiskTotal", totalSpace);
        model.addAttribute("sysDiskUsage", diskUsage);

        // 4. 기타 정보
        model.addAttribute("sysOsName", System.getProperty("os.name"));
        model.addAttribute("sysJavaVer", System.getProperty("java.version"));
    }

}