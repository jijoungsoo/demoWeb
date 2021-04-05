package com.example.demo.service;

import java.util.HashMap;

import com.example.demo.YmlConfig;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.client.ResourceAccessException;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class GoRestService {
    public String callAPI(String br, String jsonInString) throws ResourceAccessException {
        log.info("br=>" + br);
        log.info("jsonInString=>" + jsonInString);
        String jsonOutString = null;
        HashMap<String, Object> result = new HashMap<String, Object>();
        HttpComponentsClientHttpRequestFactory factory = new HttpComponentsClientHttpRequestFactory();
        //factory.setConnectTimeout(100000); // 타임아웃 설정 5초
        //factory.setReadTimeout(100000);// 타임아웃 설정 5초
        RestTemplate restTemplate = new RestTemplate(factory);

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        HttpEntity<?> entity = new HttpEntity<>(jsonInString, headers);
        YmlConfig y = new YmlConfig();
        String url = y.getApiurl() + br;
        UriComponentsBuilder uriBuilder = UriComponentsBuilder.fromHttpUrl(url);

        try {
            ResponseEntity<String> resultMap = restTemplate.exchange(uriBuilder.build().toString(), HttpMethod.POST,
                    entity, String.class);
            result.put("statusCode", resultMap.getStatusCodeValue()); // http status code를 확인
            result.put("header", resultMap.getHeaders()); // 헤더 정보 확인
            result.put("body", resultMap.getBody()); // 실제 데이터 정보 확인
            jsonOutString = resultMap.getBody();
            return jsonOutString;
        } catch (ResourceAccessException e) {
            e.printStackTrace();
            throw new ResourceAccessException("제한시간이 100초가 초과되었습니다.");
            // 이렇게 에러를 던지는게 아니라 결과셋을 보내야한다.
        }
    }
}
