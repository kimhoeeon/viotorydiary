package com.viotory.diary.controller;

import com.viotory.diary.dto.MenuItem;
import com.viotory.diary.service.*;
import com.viotory.diary.vo.AdminVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;

@Slf4j
@Controller
@RequestMapping("/mng")
@RequiredArgsConstructor
public class AdminController {

    private final AdminService adminService;     // DB 로그인용
    private final GameService gameService;
    private final MemberService memberService;
    private final DiaryService diaryService;

    // --- 1. 로그인 및 메인 ---

    @GetMapping("/index.do")
    public String loginPage(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("adminId") != null) {
            return "redirect:/mng/main.do";
        }
        return "mng/index";
    }

    @PostMapping("/login")
    public String loginAction(@RequestParam("adminId") String id,
                              @RequestParam("adminPw") String pw,
                              HttpServletRequest request,
                              Model model) {
        try {
            // 접속자 IP 추출 (개별 IP 제한 체크용)
            String clientIp = getClientIp(request);

            HttpSession session = request.getSession();

            // 1. 로그인 서비스 호출 (다중 IP 체크 포함된 버전)
            AdminVO admin = adminService.login(id, pw, clientIp);

            if (admin != null) {
                // 2. 세션에 AdminVO 객체 저장 (Key: "admin")
                session.setAttribute("admin", admin);

                // 기존 호환성 유지 (필요하다면)
                session.setAttribute("adminId", admin.getLoginId());
                session.setAttribute("status", "logon");

                return "redirect:/mng/main"; // 또는 "redirect:/mng/main.do"
            } else {
                model.addAttribute("msg", "아이디 또는 비밀번호를 확인해주세요.");
                return "mng/index";
            }

        } catch (Exception e) {
            log.warn("관리자 로그인 실패: {}", e.getMessage());
            model.addAttribute("msg", e.getMessage()); // 예: "접속이 허용되지 않은 IP입니다."
            return "mng/index";
        }
    }

    /**
     * 관리자 메인 대시보드
     */
    @GetMapping("/main.do")
    public String mainPage(Model model) {

        // [대시보드 통계 데이터 조회]

        // 1. 회원 현황
        int totalMembers = memberService.countMembers("", "");
        int todayMembers = memberService.countTodayMembers();

        // 2. 일기 현황
        int totalDiaries = diaryService.countTotalDiaries();
        int todayDiaries = diaryService.countTodayDiaries();

        // 3. 오늘 경기 수
        int todayGames = gameService.countTodayGames();

        model.addAttribute("totalMembers", totalMembers);
        model.addAttribute("todayMembers", todayMembers);
        model.addAttribute("totalDiaries", totalDiaries);
        model.addAttribute("todayDiaries", todayDiaries);
        model.addAttribute("todayGames", todayGames);

        return "mng/main";
    }

    /**
     * 로그아웃
     */
    @GetMapping("/logout.do")
    public String logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        return "redirect:/mng/index.do";
    }

    @PostMapping("/mng/profile/change-password")
    @ResponseBody
    public String changePassword(@RequestParam String currentPassword,
                                 @RequestParam String newPassword,
                                 HttpSession session) {

        // 1. 세션에서 로그인된 관리자 정보 가져오기
        AdminVO admin = (AdminVO) session.getAttribute("admin");

        if (admin == null) {
            return "로그인 정보가 없습니다 (세션 만료).";
        }

        // 2. 서비스 호출 (이메일 대신 ID 전달)
        // AdminVO에 getId() 메서드가 있다고 가정합니다.
        return adminService.changePassword(admin.getLoginId(), currentPassword, newPassword);
    }

    // IP 추출 유틸 메서드
    private String getClientIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        return ip;
    }

    /************************************************************
     * **********************************************************
     * KBO 데이터 수집 관련
     * **********************************************************
     * **********************************************************/

    // 수동 업데이트 API
    // 사용법: /admin/game/update-rapid?date=2025-05-05
    /*@GetMapping("/update-rapid")
    public String updateFromRapid(@RequestParam(required = false) String date) {
        LocalDate targetDate = (date != null)
                ? LocalDate.parse(date, DateTimeFormatter.ISO_DATE)
                : LocalDate.now();

        gameDataService.fetchFromRapid(targetDate);
        return targetDate + " 경기 데이터 업데이트 요청 완료!";
    }*/

}