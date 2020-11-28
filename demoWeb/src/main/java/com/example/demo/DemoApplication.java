package com.example.demo;

import javax.servlet.http.HttpSession;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.session.data.redis.config.annotation.web.http.EnableRedisHttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@SpringBootApplication
@EnableRedisHttpSession
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
