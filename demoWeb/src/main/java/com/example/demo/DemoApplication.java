package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.stereotype.Controller;

@Controller
@EnableAspectJAutoProxy
@SpringBootApplication
//@EnableRedisHttpSession(maxInactiveIntervalInSeconds = (60*60*3))
@EnableCaching    /*캐싱한다.*/
/*https://java2020.com/q/kmpcswsk   
 * sesstion time out 변경 값 
 * 기분 30분 (1800)
 * @EnableRedisHttpSession(maxInactiveIntervalInSeconds = 60)
 * 스프링 부트 2.0에서 아래와 같이 할수도 있다. [application.yml]
 * 과거 느낌으로 하면 아래에 -1 입력하면 무제한이라고 한다.
 * server.servlet.session.timeout   
 * server.servlet.session.timeout=30m   (30분)
 * server.servlet.session.timeout=30s   (30초)
 * 
 * */
@EnableScheduling  //스케줄실행
public class DemoApplication {

	public static void main(String[] args) {
		/*https://haviyj.tistory.com/11 라이브 리로딩*/
		//System.setProperty("spring.devtools.restart.enabled","false");  // 나는 spa여서 쓸일이 없는데..
		//System.setProperty("spring.devtools.livereload.enabled","true");
		/*https://haviyj.tistory.com/11 라이브 리로딩*/
		
		SpringApplication.run(DemoApplication.class, args);
		
	}
	


}
