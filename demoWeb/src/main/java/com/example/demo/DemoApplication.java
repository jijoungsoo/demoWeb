package com.example.demo;

import javax.servlet.http.HttpSession;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.session.data.redis.config.annotation.web.http.EnableRedisHttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.zalando.logbook.HttpLogFormatter;
import org.zalando.logbook.json.JsonHttpLogFormatter;

@Controller
@EnableAspectJAutoProxy
@SpringBootApplication
@EnableRedisHttpSession(maxInactiveIntervalInSeconds = (60*60*3))
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
public class DemoApplication {

	public static void main(String[] args) {
		SpringApplication.run(DemoApplication.class, args);
		
	}
	


}
