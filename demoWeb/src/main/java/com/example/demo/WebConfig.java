package com.example.demo;

import java.util.ArrayList;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import com.example.demo.controller.GoRestController;


@Configuration
public class WebConfig  implements WebMvcConfigurer {
	 @Autowired
	private GoRestController goRestApi;
		
    
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
		
		/*
		 *
		바보같았다. controller를 생성할수없으니까 의미 없다. 
		url router를 써야한느데 있는지 모르겠다.
		ObjectMapper om = new ObjectMapper();		 
		ArrayList<HashMap<String, Object>> cmPgmList = new ArrayList<HashMap<String,Object>>();
		String jsonPgmOutString = goRestApi.callAPI("findMainPgm", null);
		try {
			cmPgmList=om.readValue(jsonPgmOutString,ArrayList.class);
		} catch (JsonProcessingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		for (int i = 0; i < cmPgmList.size(); i++) {
			HashMap<String,Object> hm = cmPgmList.get(i);
			System.out.print(hm.get("pgmId"));
			System.out.print(hm.get("pgmLink"));
			registry.addViewController("/"+hm.get("pgmId")).setViewName(hm.get("pgmLink").toString());	
		}
		*/
    }
 
}