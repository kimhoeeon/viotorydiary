package com.viotory.diary.config;

import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Component
public class AdminInterceptor implements HandlerInterceptor {

    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    // application.properties에서 설정값 주입
    @Value("${admin.allowed.ips}")
    private String allowedIpsString;

    private List<String> allowedIpList;

    /**
     * Bean 초기화 시점에 설정된 IP 문자열을 리스트로 변환
     */
    @PostConstruct
    public void init() {
        if (allowedIpsString != null && !allowedIpsString.isEmpty()) {
            // 쉼표(,) 기준으로 분리하고 공백 제거
            String[] ips = allowedIpsString.split(",");
            allowedIpList = new ArrayList<>();
            for (String ip : ips) {
                allowedIpList.add(ip.trim());
            }
            logger.info("관리자 접근 허용 IP 로드 완료: {}", allowedIpList);
        } else {
            allowedIpList = new ArrayList<>();
            logger.warn("관리자 접근 허용 IP가 설정되지 않았습니다. (admin.allowed.ips)");
        }
    }

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String requestURI = request.getRequestURI();

        // 정적 자원(assets, css, js, img)은 통과 (WebMvcConfig에서 처리하지만 이중 안전장치)
        if (isStaticResource(requestURI)) {
            return true;
        }

        // 1. IP 체크
        String clientIp = getClientIp(request);
        boolean isAllowedIp = allowedIpList.contains(clientIp);

        if (!isAllowedIp) {
            logger.warn("관리자 페이지 비정상 IP 접근 차단: {} (URI: {})", clientIp, requestURI);
            // 403 Forbidden 에러 전송 또는 메인으로 리다이렉트
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return false;
        }

        // 2. 로그인 세션 체크
        // 로그인 페이지 및 로그인 처리 URL은 세션 체크 제외
        if (requestURI.equals("/mng/index.do") || requestURI.equals("/mng/login")) {
            return true;
        }

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            logger.info("관리자 세션 만료 또는 미로그인 접근: {}", clientIp);
            response.sendRedirect("/mng/index.do");
            return false;
        }

        return true;
    }

    // 클라이언트 IP 추출 유틸
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

    // 정적 자원 체크 헬퍼
    private boolean isStaticResource(String uri) {
        return uri.startsWith("/mng/assets/") || uri.startsWith("/mng/css/")
                || uri.startsWith("/mng/js/") || uri.startsWith("/mng/img/");
    }

}