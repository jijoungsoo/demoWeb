package com.example.demo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;


@Configuration
public class WebConfig  implements WebMvcConfigurer {
    
    /*
     * 로그인 인증 Interceptor 설정
     * */
    @Autowired
    CertificationInterceptor certificationInterceptor;
    
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
    	/* 사용안함 security 로 대체 
        registry.addInterceptor(certificationInterceptor)
                .addPathPatterns("/main/*")        //폴더구분으로 로그인이 접근할수있는 페이지를 걸어주자.
                .addPathPatterns("/api/*")         //api호출을 위한 곳에 로그인 필터를 건다.
                .excludePathPatterns("/login/*")   //login 밑에 모든 곳은 접근 가능하다.
                .excludePathPatterns("/api/login") 
                .excludePathPatterns("/out")
                .excludePathPatterns("/*.js")
                .excludePathPatterns("/*.css")
                .excludePathPatterns("/*.jpg")
                .excludePathPatterns("/*.png");
        
        */
    }
    
    // 요청 - 뷰 연결
    public void addViewControllers(ViewControllerRegistry registry) {
    	/*
      registry.addViewController("/").setViewName("main");
      registry.addViewController("/login").setViewName("login");
      registry.addViewController("/admin").setViewName("admin");
      registry.addViewController("/signup").setViewName("signup");
      */
    }
 
}