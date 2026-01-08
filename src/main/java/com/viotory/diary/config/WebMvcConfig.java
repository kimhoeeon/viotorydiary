package com.viotory.diary.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Autowired
    private AdminInterceptor adminInterceptor;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        // 관리자 페이지 경로에 인터셉터 적용
        registry.addInterceptor(adminInterceptor)
                .addPathPatterns("/mng/**")
                .excludePathPatterns("/mng/assets/**", "/mng/css/**", "/mng/js/**", "/mng/img/**"); // 정적 자원 제외
    }

}