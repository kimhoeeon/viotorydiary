package com.viotory.diary.config;

import com.viotory.diary.service.MemberService;
import com.viotory.diary.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.util.WebUtils;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@Slf4j
@Component
public class AutoLoginInterceptor implements HandlerInterceptor {

    @Autowired
    private MemberService memberService;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession();

        // 1. 이미 로그인된 상태라면 통과
        if (session.getAttribute("loginMember") != null) {
            return true;
        }

        // 2. 로그인 안 된 상태라면 'remember_me' 쿠키 확인
        Cookie loginCookie = WebUtils.getCookie(request, "remember_me");
        if (loginCookie != null) {
            String userEmail = loginCookie.getValue();

            // 3. 쿠키에 저장된 이메일로 회원 정보 조회 (DB)
            // (주의: MemberMapper에 selectMemberByEmail 메소드가 있어야 함. MemberService의 login 로직 일부 활용)
            try {
                // MemberService에 getMemberByEmail 같은 메소드를 추가하거나,
                // 기존 login 메소드는 비밀번호가 필요하므로, 이메일로만 조회하는 로직 필요.
                // 여기서는 예시로 MemberService에 새로 만들거나 Mapper를 직접 호출한다고 가정
                // 하지만 Service를 거치는게 정석이므로 Service에 메소드 추가를 권장합니다.

                // 임시: MemberMapper를 직접 쓸 수 없으니 Service에 메소드를 추가해야 함.
                // MemberService.java에 public MemberVO findByEmail(String email) 추가 필요
                MemberVO member = memberService.getMemberByEmail(userEmail);

                if (member != null && !"WITHDRAWN".equals(member.getStatus())) {
                    // 4. 세션 생성 (자동 로그인 성공)
                    session.setAttribute("loginMember", member);
                    log.info("자동 로그인 성공: {}", userEmail);
                }
            } catch (Exception e) {
                log.warn("자동 로그인 처리 중 오류: {}", e.getMessage());
                // 쿠키가 오염되었거나 회원이 없을 수 있으므로 쿠키 삭제
                loginCookie.setMaxAge(0);
                loginCookie.setPath("/");
                response.addCookie(loginCookie);
            }
        }

        return true; // 로그인 여부와 관계없이 컨트롤러 진행
    }
}