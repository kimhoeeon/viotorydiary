package com.viotory.diary.controller;

import com.viotory.diary.dto.MenuItem;
import com.viotory.diary.service.AdminService;
import com.viotory.diary.service.GameDataService;
import com.viotory.diary.service.MenuService;
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
    private final GameDataService gameDataService; // 경기 데이터 관리용

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

            // DB 로그인 시도
            AdminVO admin = adminService.login(id, pw, clientIp);

            // 세션 생성 및 정보 저장
            HttpSession session = request.getSession();
            session.setAttribute("adminId", admin.getLoginId());
            session.setAttribute("adminName", admin.getName());
            session.setAttribute("status", "logon");
            session.setAttribute("gbn", admin.getRole()); // 'SUPER' or 'MANAGER'

            log.info("관리자 로그인 성공: {} ({})", admin.getLoginId(), admin.getName());
            return "redirect:/mng/main.do";

        } catch (Exception e) {
            log.warn("관리자 로그인 실패: {}", e.getMessage());
            model.addAttribute("error", e.getMessage());
            return "mng/index";
        }
    }

    /**
     * 관리자 메인 대시보드
     */
    @GetMapping("/main.do")
    public String mainPage(Model model) {

        // TODO: 대시보드 통계 데이터 추가 가능
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

    /**
     * 관리자가 직접 특정 년/월 데이터를 업데이트 하는 API
     * 예: /admin/game/sync?year=2025&month=05
     */
    @GetMapping("/game/sync")
    @ResponseBody
    public String manualSync(@RequestParam String year, @RequestParam String month) {
        gameDataService.syncMonthlyData(year, month);
        return String.format("%s년 %s월 데이터 동기화 요청이 처리되었습니다.", year, month);
    }

    /**
     * 특정 연도 전체(3월~11월) 데이터 동기화
     * 예: /admin/game/sync-year?year=2025
     */
    @GetMapping("/game/sync-year")
    @ResponseBody
    public String syncYearlyData(@RequestParam String year) {
        // 비동기로 실행하고 싶다면 Thread를 사용하거나 @Async를 사용해야 하지만,
        // 우선은 로그를 확인하며 기다리는 방식으로 구현합니다.
        gameDataService.syncYearlyData(year);
        return String.format("%s년도 시즌 전체 데이터 수집이 완료되었습니다. (로그 확인 요망)", year);
    }

    // 기존 월별 동기화 API
    @GetMapping("/sync-month")
    @ResponseBody
    public String syncMonthlyData(@RequestParam String year, @RequestParam String month) {
        gameDataService.syncMonthlyData(year, month);
        return String.format("%s년 %s월 시즌 데이터 수집이 완료되었습니다. (로그 확인 요망)", year, month);
    }

}