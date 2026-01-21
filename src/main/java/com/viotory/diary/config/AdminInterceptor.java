package com.viotory.diary.config;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.PrintWriter;

@Slf4j
@Component
public class AdminInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String requestURI = request.getRequestURI();

        // 1. 로그인 페이지 및 리소스는 검사 제외 (WebMvcConfig에서도 제외하지만 이중 체크)
        if (requestURI.equals("/mng/index.do") || requestURI.equals("/mng/index") || requestURI.equals("/mng/login")) {
            return true;
        }

        // 2. 세션 체크 (로그인 여부 확인)
        HttpSession session = request.getSession(false);

        // AdminController에서 session.setAttribute("admin", admin); 로 저장된 객체 확인
        if (session == null || session.getAttribute("admin") == null) {
            String clientIp = getClientIp(request);
            log.info("관리자 비로그인 접근 차단: IP={} / URI={}", clientIp, requestURI);

            // 바로 리다이렉트 하지 않고, 알림창을 띄운 후 이동하도록 스크립트 전송
            response.setContentType("text/html; charset=UTF-8");
            PrintWriter out = response.getWriter();

            out.println("<script>");
            out.println("alert('로그인이 필요한 서비스입니다.');");
            out.println("location.href='/mng/index.do';"); // 로그인 페이지로 이동
            out.println("</script>");

            out.flush();
            out.close(); // 더 이상 컨트롤러로 진행하지 않음

            return false; // 컨트롤러 실행 차단
        }

        return true; // 통과
    }

    // 클라이언트 IP 추출 유틸 (로그용으로만 남겨둠)
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
}