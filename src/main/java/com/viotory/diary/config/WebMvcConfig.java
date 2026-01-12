package com.viotory.diary.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Autowired
    private AdminInterceptor adminInterceptor;

    @Autowired
    private HttpsRedirectInterceptor httpsRedirectInterceptor; // [추가]

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        // 1. HTTPS 리다이렉트 (모든 경로에 적용)
        // 정적 자원(css, js 등)은 성능을 위해 제외할 수도 있지만, 보안상 전체 적용을 권장합니다.
        registry.addInterceptor(httpsRedirectInterceptor)
                .addPathPatterns("/**")
                .excludePathPatterns("/.well-known/**"); // [중요] SSL 인증 파일 경로는 무한 루프 방지를 위해 제외

        // 2. 기존 관리자 권한 체크 인터셉터 (관리자 경로만 적용)
        registry.addInterceptor(adminInterceptor)
                .addPathPatterns("/mng/**")
                .excludePathPatterns("/mng/assets/**", "/mng/css/**", "/mng/js/**", "/mng/img/**");
    }

}