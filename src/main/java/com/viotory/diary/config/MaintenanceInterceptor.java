package com.viotory.diary.config;

import org.springframework.web.servlet.HandlerInterceptor;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class MaintenanceInterceptor implements HandlerInterceptor {

    // [설정] 백도어 비밀번호 (원하는 값으로 변경하세요)
    private static final String BACKDOOR_KEY = "open_viotory";

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession();
        String requestURI = request.getRequestURI();

        // 1. 이미 승인된 세션인지 확인
        Boolean isPass = (Boolean) session.getAttribute("maintenance_pass");
        if (isPass != null && isPass) {
            return true; // 통과
        }

        // 2. 백도어 키 확인 (URL 파라미터 체크)
        // 예: https://도메인/?pass=open_viotory
        String paramKey = request.getParameter("pass");
        if (BACKDOOR_KEY.equals(paramKey)) {
            session.setAttribute("maintenance_pass", true); // 세션 승인 처리
            session.setMaxInactiveInterval(60 * 60); // 1시간 유지
            return true; // 통과
        }

        // 3. 위 조건에 해당하지 않으면 점검 페이지로 리다이렉트
        response.sendRedirect("/maintenance");
        return false;
    }
}