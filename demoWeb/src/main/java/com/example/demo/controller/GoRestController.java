package com.example.demo.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.HttpServerErrorException;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponents;
import org.springframework.web.util.UriComponentsBuilder;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

@RestController
public class GoRestController {
	 @RequestMapping("/movie")  
	    public String jsp(){ 
	       return "movie"; 
	    }
	 
	 private static Logger logger = LoggerFactory.getLogger("MLS_LOGGER");  
	 
	
		/*
		 @RequestMapping("/index")  
		 public String jsp(){
		     return "index"; 
		 }
		 */
		 
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
	 
	    /*https://vmpo.tistory.com/27*/
	 /*내가 너무 복잡하게 생각했나보다..   여기에만 로그가 생기면 된다. 
	  *  logbook-spring-boot-starter 이거 쓰고 application.yml 사용해서 이미 로그는 남겼다.
	  * 문제는 logbook  으로 남근것만   loback-spring.xml에서 어떻게 가져올수 있는가 이다.
	  * 답은   https://github.com/zalando/logbook/issues/559
	  * */
	 @PostMapping(path= "/api/{br}", consumes = "application/json", produces = "application/json")
	    public String callAPI(@PathVariable("br") String br
				, @RequestBody String body) throws JsonProcessingException {
	        HashMap<String, Object> result = new HashMap<String, Object>();
	 
	        String jsonInString = "";
	 
	        try {
	 
	            HttpComponentsClientHttpRequestFactory factory = new HttpComponentsClientHttpRequestFactory();
	            factory.setConnectTimeout(5000); //타임아웃 설정 5초
	            factory.setReadTimeout(5000);//타임아웃 설정 5초
	            RestTemplate restTemplate = new RestTemplate(factory);
	 
	            HttpHeaders headers = new HttpHeaders();
	            headers.setContentType(MediaType.APPLICATION_JSON);
	            
	            HttpEntity<?> entity = new HttpEntity<>(body,headers);
	 
	            String url = "http://localhost:8091/"+br;
	 
	            UriComponents uri = UriComponentsBuilder.fromHttpUrl(url).build();
	 
	            //이 한줄의 코드로 API를 호출해 MAP타입으로 전달 받는다.
	            ResponseEntity<String> resultMap = restTemplate.exchange(uri.toString(), HttpMethod.POST, entity, String.class);
	            result.put("statusCode", resultMap.getStatusCodeValue()); //http status code를 확인
	            result.put("header", resultMap.getHeaders()); //헤더 정보 확인
	            result.put("body", resultMap.getBody()); //실제 데이터 정보 확인
	            //데이터를 제대로 전달 받았는지 확인 string형태로 파싱해줌
	            ObjectMapper mapper = new ObjectMapper();
	            jsonInString = mapper.writeValueAsString(resultMap.getBody());
	            
	        } catch (HttpClientErrorException | HttpServerErrorException e) {
	            result.put("statusCode", e.getRawStatusCode());
	            result.put("body"  , e.getStatusText());
	            System.out.println("dfdfdfdf");
	            System.out.println(e.toString());
	 
	        } catch (Exception e) {
	            result.put("statusCode", "999");
	            result.put("body"  , "excpetion오류");
	            System.out.println(e.toString());
	        }
	        /*호출화면 유일id
	         *br명
	         *input 
	         *output
	         *time
	         *
	         *시간 형식으로 문자열을 만든다.
	         **/
	        String logMsg =br+"/"+body+"/"+jsonInString;
	        logger.debug(logMsg);
	        logger.debug(result.toString());
	 
	        return jsonInString;
	 
	 }
}
