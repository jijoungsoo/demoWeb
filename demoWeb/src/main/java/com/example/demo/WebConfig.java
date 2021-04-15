package com.example.demo;

import com.example.demo.cm.ctrl.ApiRestController;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;




@Configuration
public class WebConfig  implements WebMvcConfigurer {
	 @Override
    public void addCorsMappings(CorsRegistry registry) {
        // TODO Auto-generated method stub
        WebMvcConfigurer.super.addCorsMappings(registry);
        //registry.addMapping("/**").allowedOriginPatterns("http://localhost:8090");
        registry.addMapping("/**").allowedOriginPatterns("*");
        
    }




    @Autowired
	private ApiRestController goRestApi;
		
    
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
    
 
 
}