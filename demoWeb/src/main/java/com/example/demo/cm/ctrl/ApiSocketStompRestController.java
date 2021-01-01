package com.example.demo.cm.ctrl;

import java.util.HashMap;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.HttpServerErrorException;

import com.example.demo.exception.BizException;
import com.example.demo.service.GoRestService;
import com.fasterxml.jackson.core.JsonProcessingException;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
public class ApiSocketStompRestController {
	
	@Autowired
	 private GoRestService goService;
	 private static Logger logger = LoggerFactory.getLogger("MLS_LOGGER"); 
	/*소켓*/
    @MessageMapping("/socketApi")   /*보내는 이름*/
    @SendTo("/topic/message")  /*받는 이름*/
    public ResponseEntity<Object> callSocketAPI(@PathVariable("br") String br
               , @RequestBody String jsonInString
            ) throws Exception  {
        log.info("br=>"+br);
        log.info("jsonInString=>"+jsonInString);
        String jsonOutString="aaa";

       return ResponseEntity.ok(jsonOutString);
    }
 
}
