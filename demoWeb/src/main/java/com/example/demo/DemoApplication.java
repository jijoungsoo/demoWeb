package com.example.demo;

import javax.servlet.http.HttpSession;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.session.data.redis.config.annotation.web.http.EnableRedisHttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.zalando.logbook.HttpLogFormatter;
import org.zalando.logbook.json.JsonHttpLogFormatter;

@Controller
@SpringBootApplication
@EnableRedisHttpSession(maxInactiveIntervalInSeconds = 60)
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
	
	@GetMapping("/")
    @ResponseBody
    public String session(HttpSession session){
	 	session.setAttribute("name", "sup2is");
        return session.getId() + "\nHello " + session.getAttribute("name");
       //return "index"; 
    }
	
	 @RequestMapping("/index")  
	 public String jsp(){
	     return "index"; 
	 }
	 
	 /*외부세션 관련  redis
	  * 설명 http://wiki.plateer.com/pages/viewpage.action?pageId=8552454
	  * 레디스 구동
	  * docker run -it  --name redis -p 6379:6379 -d redis
	  * docker exec -it redis bash
	  * redis-cli
	  * KEYS *
	  * keys spring:session *
	  * 
	  * 다른데 
	  * 설명 : https://sup2is.github.io/2020/07/15/session-clustering-with-redis.html
	  * 소스 : https://github.com/sup2is/study/tree/master/db/redis/session-clustering-with-redis
	  * 
	  * 3개의 spring boot 를 띄우는 방법 8080, 8081 , 8082  port 
	  * mvn spring-boot:run -Dspring-boot.run.arguments=--server.port={port}
	  * 
	  * gradle의 경우는 어떻게 해야하지 ??
	  * 
	  *  https://spring.io/guides/gs/spring-boot/
	  *  
	  * ./gradlew bootRun -Dspring-boot.run.arguments=--server.port={port}
	  * 
	  * https://stackoverflow.com/questions/51968308/how-to-add-command-line-properties-with-gradle-bootrun
	  * gradle bootRun --args='--spring.config.name=myproject'    [gradle 4.9에서 동작]
	  * gradle bootRun --args '--spring.config.name=myproject'    [gradle 5.5에서 동작]
	  * 
	  * 
	  * gradlew bootRun --args='--server.port=8091'
	  * gradlew bootRun --args='--server.port=8092'
	  * gradlew bootRun --args='--server.port=8093'
	  * server.port: 8090
	  * 
	  * 
	  * 
	  * 엠베디드 레디스  로컬 테스트용
	  * https://jojoldu.tistory.com/297
	  * 
	  * 
	  * 결국 해결은 https://www.youtube.com/watch?v=mg1UNyLXRqY 
	  * 위 유투브 보고 application.yml  변경
	  * 
	  * 이것도 아니였다. gradle에  주소를 잘못 씀.
	  * */

}
