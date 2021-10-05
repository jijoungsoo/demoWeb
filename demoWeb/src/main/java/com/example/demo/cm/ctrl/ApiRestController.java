package com.example.demo.cm.ctrl;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import com.example.demo.exception.BizException;
import com.example.demo.service.GoRestService;
import com.example.demo.utils.PjtUtil;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.HttpServerErrorException;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
public class ApiRestController {
	@Autowired
	PjtUtil pjtU;
	@Autowired
	GoRestService goS;

	/*
	 * @RequestMapping("/index") public String jsp(){ return "index"; }
	 */

	/*
	 * 외부세션 관련 redis 설명 http://wiki.plateer.com/pages/viewpage.action?pageId=8552454
	 * 레디스 구동 docker run -it --name redis -p 6379:6379 -d redis docker exec -it
	 * redis bash redis-cli KEYS * keys spring:session *
	 * 
	 * 다른데 설명 :
	 * https://sup2is.github.io/2020/07/15/session-clustering-with-redis.html 소스 :
	 * https://github.com/sup2is/study/tree/master/db/redis/session-clustering-with-
	 * redis
	 * 
	 * 3개의 spring boot 를 띄우는 방법 8080, 8081 , 8082 port mvn spring-boot:run
	 * -Dspring-boot.run.arguments=--server.port={port}
	 * 
	 * gradle의 경우는 어떻게 해야하지 ??
	 * 
	 * https://spring.io/guides/gs/spring-boot/
	 * 
	 * ./gradlew bootRun -Dspring-boot.run.arguments=--server.port={port}
	 * 
	 * https://stackoverflow.com/questions/51968308/how-to-add-command-line-
	 * properties-with-gradle-bootrun gradle bootRun
	 * --args='--spring.config.name=myproject' [gradle 4.9에서 동작] gradle bootRun
	 * --args '--spring.config.name=myproject' [gradle 5.5에서 동작]
	 * 
	 * 
	 * gradlew bootRun --args='--server.port=8091' gradlew bootRun
	 * --args='--server.port=8092' gradlew bootRun --args='--server.port=8093'
	 * server.port: 8090
	 * 
	 * 
	 * 
	 * 엠베디드 레디스 로컬 테스트용 https://jojoldu.tistory.com/297
	 * 
	 * 
	 * 결국 해결은 https://www.youtube.com/watch?v=mg1UNyLXRqY 위 유투브 보고 application.yml
	 * 변경
	 * 
	 * 이것도 아니였다. gradle에 주소를 잘못 씀.
	 */

	/* https://vmpo.tistory.com/27 */
	/*
	 * 내가 너무 복잡하게 생각했나보다.. 여기에만 로그가 생기면 된다. logbook-spring-boot-starter 이거 쓰고
	 * application.yml 사용해서 이미 로그는 남겼다. 문제는 logbook 으로 남근것만 loback-spring.xml에서 어떻게
	 * 가져올수 있는가 이다. 답은 https://github.com/zalando/logbook/issues/559
	 */
	@PostMapping(path = "/api_rest/{br}", consumes = "application/json", produces = "application/json")
	public ResponseEntity<Object> callApiRest(@PathVariable("br") String br, @RequestBody String jsonInString,
			Authentication authentication, HttpSession session) throws Exception {
		log.info("br=>" + br);

		log.info("jsonInString=>" + jsonInString);
		String jsonOutString = null;

		String JsonInStringWithSesstion = pjtU.makeLSession(br, jsonInString, authentication);

		HashMap<String, Object> result = new HashMap<String, Object>();
		try {
			jsonOutString = goS.callApiRest(br, JsonInStringWithSesstion);
		} catch (HttpClientErrorException e) {
			result.put("statusCode", "999");
			result.put("body", e.getMessage());
			e.printStackTrace();
			// https://owin2828.github.io/devlog/2019/12/30/spring-16.html
			return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());

		} catch (HttpServerErrorException e) {
			result.put("statusCode", e.getRawStatusCode());
			result.put("body", e.getStatusText());
			e.printStackTrace();
			// https://owin2828.github.io/devlog/2019/12/30/spring-16.html
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.getMessage());
		}
		return ResponseEntity.ok(jsonOutString);
	}

	@PostMapping(path = "/api/{br}", consumes = "application/json", produces = "application/json")
	public ResponseEntity<Object> callAPI(@PathVariable("br") String br, @RequestBody Map<String, Object> jsonInString,
			Authentication authentication, HttpSession session) throws Exception {
		log.info("br=>" + br);

		log.info("jsonInString=>" + jsonInString);
		String jsonOutString = null;

		Map<String, Object> inDS = pjtU.makeLSessionMap(br, jsonInString, authentication);
		HashMap<String, Object> result = new HashMap<String, Object>();
		try {
			jsonOutString = goS.callApiBizActorMap(br, inDS);
		} catch (HttpClientErrorException e) {
			result.put("statusCode", "999");
			result.put("body", e.getMessage());
			e.printStackTrace();
			// https://owin2828.github.io/devlog/2019/12/30/spring-16.html
			return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());

		} catch (HttpServerErrorException e) {
			result.put("statusCode", e.getRawStatusCode());
			result.put("body", e.getStatusText());
			e.printStackTrace();
			// https://owin2828.github.io/devlog/2019/12/30/spring-16.html
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.getMessage());
		} catch (BizException e) {
			result.put("statusCode", "500");
			result.put("body", e.getMessage());
			e.printStackTrace();
			// https://owin2828.github.io/devlog/2019/12/30/spring-16.html
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.getMessage());
		}

		return ResponseEntity.ok(jsonOutString);
	}

	@PostMapping("/refresh")

	@CacheEvict(value = { "pgmLinkCache", "pgmCache", "menuCache" }, allEntries = true)
	private ResponseEntity<Object> cacheRefresh() {
		return ResponseEntity.ok("[]");
	}

}
