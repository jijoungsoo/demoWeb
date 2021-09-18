package com.example.demo.cm.ctrl;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import com.example.demo.exception.BizException;
import com.example.demo.service.GoRestService;
import com.example.demo.utils.PjtUtil;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.HttpServerErrorException;
import org.springframework.web.client.ResourceAccessException;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
public class ProxyRestController {
	@Autowired
	PjtUtil pjtU;

	@PostMapping(path = "/proxy", consumes = "application/json", produces = "application/json")
	public ResponseEntity<Object> callApiRest(@RequestBody String jsonInString) throws Exception {
		log.info("jsonInString=>" + jsonInString);

		HashMap<String, Object> input_tmp = pjtU.JsonStringToObject(jsonInString, HashMap.class);

		String url = input_tmp.get("url").toString();
		HashMap<String, Object> param = (HashMap<String, Object>) input_tmp.get("param");
		String jsonParam = pjtU.ObjectToJsonString(param);

		HashMap<String, Object> result = new HashMap<String, Object>();
		HttpComponentsClientHttpRequestFactory factory = new HttpComponentsClientHttpRequestFactory();
		RestTemplate restTemplate = new RestTemplate(factory);

		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_JSON);

		HttpEntity<?> entity = new HttpEntity<>(jsonParam, headers);
		UriComponentsBuilder uriBuilder = UriComponentsBuilder.fromHttpUrl(url);

		try {
			ResponseEntity<String> resultMap = restTemplate.exchange(uriBuilder.build().toString(), HttpMethod.POST,
					entity, String.class);
			result.put("statusCode", resultMap.getStatusCodeValue()); // http status code를 확인
			// result.put("header", resultMap.getHeaders()); // 헤더 정보 확인

			result.put("body", pjtU.readTree(resultMap.getBody())); // 실제 데이터 정보 확인
			return ResponseEntity.ok(result);
		} catch (ResourceAccessException e) {
			e.printStackTrace();
			result.put("statusCode", "999");
			result.put("body", e.getMessage());
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.NOT_FOUND).body(result);
			// 이렇게 에러를 던지는게 아니라 결과셋을 보내야한다.
		} catch (HttpClientErrorException e) {
			e.printStackTrace();
			result.put("statusCode", "999");
			result.put("body", e.getMessage());
			return ResponseEntity.status(HttpStatus.NOT_FOUND).body(result);
		} catch (HttpServerErrorException e) {
			e.printStackTrace();
			result.put("statusCode", e.getRawStatusCode());
			result.put("body", e.getStatusText());
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(result);
		}
	}
}