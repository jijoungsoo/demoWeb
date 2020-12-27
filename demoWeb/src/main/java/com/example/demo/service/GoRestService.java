package com.example.demo.service;

import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.BasicResponseHandler;
import org.apache.http.impl.client.HttpClientBuilder;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.HttpServerErrorException;
import org.springframework.web.client.ResourceAccessException;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponents;
import org.springframework.web.util.UriComponentsBuilder;

import com.example.demo.cm.ctrl.ApiResultMap;
import com.example.demo.cm.utils.PjtUtil;
import com.example.demo.exception.BizException;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class GoRestService {
	 private static Logger logger = LoggerFactory.getLogger("MLS_LOGGER");  
	 public String callAPI(String br
				, String jsonInString
				) throws BizException {
		 log.info("br=>"+br);
		 log.info("jsonInString=>"+jsonInString);
		 String jsonOutString=null;
	        HashMap<String, Object> result = new HashMap<String, Object>();
            HttpComponentsClientHttpRequestFactory factory = new HttpComponentsClientHttpRequestFactory();
            factory.setConnectTimeout(10000); //타임아웃 설정 5초
            factory.setReadTimeout(10000);//타임아웃 설정 5초
            RestTemplate restTemplate = new RestTemplate(factory);
 
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            
            HttpEntity<?> entity = new HttpEntity<>(jsonInString,headers);
 
            String url = "http://localhost:8091/api/"+br;
            
            UriComponentsBuilder  uriBuilder = UriComponentsBuilder.fromHttpUrl(url);
            //uriBuilder.queryParam("uuid", pgmId);
            //uriBuilder.queryParam("pgmId", uuid);
    		
            //이 한줄의 코드로 API를 호출해 MAP타입으로 전달 받는다.
            try {
            ResponseEntity<String> resultMap = restTemplate.exchange(uriBuilder.build().toString(), HttpMethod.POST, entity, String.class);
            result.put("statusCode", resultMap.getStatusCodeValue()); //http status code를 확인
            result.put("header", resultMap.getHeaders()); //헤더 정보 확인
            result.put("body", resultMap.getBody()); //실제 데이터 정보 확인
            jsonOutString =resultMap.getBody();
            
            //속도문제로 제거 
            //log.info(jsonOutString);
            
            } catch(ResourceAccessException e) {
            	e.printStackTrace();
            	throw new BizException("제한시간이 10초가 초과되었습니다.");	
            	//이렇게 에러를 던지는게 아니라 결과셋을 보내야한다.
            }
            try {
            	ApiResultMap resMap=PjtUtil.JsonStringToObject(jsonOutString,ApiResultMap.class);
				//String logMsg =br+"/"+jsonInString+"/"+resMap.jsonOutString;
    	        //logger.debug(logMsg);
    	        //logger.debug(resMap.jsonOutString);
    	        if(resMap.success.equals("false")) {
    	        	throw new BizException(resMap.errorMessage);	
    	        }
    	        
    	        
    	        
    	        return resMap.jsonOutString;
				
			} catch (JsonProcessingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				throw new BizException("시스템오류가 발생하였습니다.(관리자에게 문의하세요.)");
			}
	 }

}
