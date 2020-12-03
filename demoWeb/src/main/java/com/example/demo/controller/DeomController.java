package com.example.demo.controller;

import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.stereotype.Controller;
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
public class DeomController {
	 @RequestMapping("/movie")  
	    public String jsp(){ 
	       return "movie"; 
	    }
	 
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
	 
	            HttpHeaders header = new HttpHeaders();
	            HttpEntity<?> entity = new HttpEntity<>(header);
	 
	            String url = "http://localhost:8091/"+br;
	 
	            UriComponents uri = UriComponentsBuilder.fromHttpUrl(url).build();
	 
	            //이 한줄의 코드로 API를 호출해 MAP타입으로 전달 받는다.
	            ResponseEntity<Map> resultMap = restTemplate.exchange(uri.toString(), HttpMethod.POST, entity, Map.class);
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
	 
	        return jsonInString;
	 
	 }
}
