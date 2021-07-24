package com.example.demo;

import java.text.NumberFormat;

import org.springframework.beans.factory.InitializingBean;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.stereotype.Controller;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
//https://www.baeldung.com/httpsessionlistener_with_metrics
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
public class DemoApplication extends SpringBootServletInitializer {


	@Override
	protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) {
		return builder.sources(DemoApplication.class);
	}
   
	public static void main(String[] args) {
		/*https://haviyj.tistory.com/11 라이브 리로딩*/
		//System.setProperty("spring.devtools.restart.enabled","false");  // 나는 spa여서 쓸일이 없는데..
		//System.setProperty("spring.devtools.livereload.enabled","true");
		/*https://haviyj.tistory.com/11 라이브 리로딩*/
		SpringApplication application = new SpringApplication(DemoApplication.class);
		application.run(args);
		
	}

	@Bean
	InitializingBean sendDatabase() {
	    return () -> {
	    	
	    	//t.loadData();
	    	/*
	        userRepository.save(new User("John"));
	        userRepository.save(new User("Rambo"));
	        */

			Runtime runtime = Runtime.getRuntime();
			final NumberFormat format = NumberFormat.getInstance();

			final long maxMemory = runtime.maxMemory();
			final long allocatedMemory = runtime.totalMemory();
			final long freeMemory = runtime.freeMemory();
			final long mb = 1024 * 1024;
			final String mega = " MB";

			log.info("========================== Memory Info ==========================");
			log.info("Free memory: " + format.format(freeMemory / mb) + mega);
			log.info("Allocated memory: " + format.format(allocatedMemory / mb) + mega);
			log.info("Max memory: " + format.format(maxMemory / mb) + mega);
			log.info("Total free memory: " + format.format((freeMemory + (maxMemory - allocatedMemory)) / mb) + mega);
			log.info("=================================================================\n");
	   };
	}
	


}
