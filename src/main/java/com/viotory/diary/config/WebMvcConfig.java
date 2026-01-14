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
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 1. 업로드 경로 설정 (운영체제 상관없이 '사용자 홈/viotory/upload/' 경로 사용)
        String uploadPath = Paths.get(System.getProperty("user.home"), "viotory", "upload").toUri().toString();

        // 2. 리소스 핸들러 매핑
        // 웹에서 '/uploads/**' 로 접근하면 -> 실제 서버의 upload 폴더 내용을 보여줌
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations(uploadPath);
    }

}