package com.viotory.diary.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.nio.file.Paths;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Autowired
    private AdminInterceptor adminInterceptor;

    @Autowired
    private HttpsRedirectInterceptor httpsRedirectInterceptor;

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

        // 관리자 권한 체크
        registry.addInterceptor(adminInterceptor)
                .addPathPatterns("/mng/**")
                .excludePathPatterns("/mng/login", "/mng/loginAction");
    }

    // 정적 리소스(이미지) 경로 매핑
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 1. 업로드 경로 설정 (OS에 따라 유동적)
        // 리눅스/맥: /home/사용자/viotory/upload/
        // 윈도우: C:/Users/사용자/viotory/upload/
        String uploadPath = Paths.get(System.getProperty("user.home"), "viotory", "upload").toUri().toString();

        // 2. URL 매핑: /uploads/파일명 -> 실제 파일 경로
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations(uploadPath);
    }

}