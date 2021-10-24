package com.example.demo.cm.ctrl;

import java.security.Principal;
import java.util.HashMap;
import java.util.Map;

import com.example.demo.WebSocketEventListener;
import com.example.demo.exception.BizException;
import com.example.demo.service.GoRestService;
import com.example.demo.utils.PjtUtil;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.HttpServerErrorException;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
public class ApiSocketStompRestController {

    @Autowired
    PjtUtil pjtU;
    @Autowired
    WebSocketEventListener wsel;

    @Autowired
    GoRestService goS;

    /*
     * https://tech.osci.kr/2019/12/23/86033468/ 이아저씨 예제가 좋다.
     */
    @Autowired
    SimpMessagingTemplate smt;

    /* 소켓 */
    @MessageMapping("/socketApi") /* 보내는 이름 */
    @SendTo("/topic/message") /* 받는 이름 */
    public String callSocketAPI(SimpMessageHeaderAccessor simpMessageHeaderAccessor, String jsonInString, Principal p)
            throws Exception {
        log.info("simpMessageHeaderAccessor=>" + simpMessageHeaderAccessor);
        Map nativeHeaders = (Map) simpMessageHeaderAccessor.getHeader("nativeHeaders");
        String UUID = nativeHeaders.get("UUID").toString();// 클라이언트가 보낸 값
        log.info("Uuid=>" + nativeHeaders.get("UUID"));
        log.info("p.getName()=>" + p.getName());
        String SessionId = simpMessageHeaderAccessor.getSessionId();
        int cnt = wsel.getSessionCnt();
        // String msg ="["+cnt+"]["+SessionId+"]"+jsonInString;
        // log.info("msg=>"+msg);
        // String jsonOutString="aaa";
        log.info("jsonInString=>" + jsonInString);
        System.out.println(jsonInString);
        String jsonOutString = null;
        HashMap<String, Object> inDs = pjtU.JsonStringToObject(jsonInString, HashMap.class);
        String br = inDs.get("br").toString();
        HashMap<String, Object> result = new HashMap<String, Object>();
        try {
            jsonOutString = goS.callAPI(br, jsonInString);
        } catch (HttpClientErrorException e) {
            e.printStackTrace();
        } catch (HttpServerErrorException e) {
            e.printStackTrace();
        }
        // https://withseungryu.tistory.com/136
        smt.convertAndSendToUser(p.getName(), "/topic/message", jsonOutString);// 동작을 안함.
        System.out.println(jsonOutString);
        return jsonOutString;
    }

    @MessageMapping("/socketApiToMe") /* 보내는 이름 */
    public void callSocketAPIToMe(SimpMessageHeaderAccessor simpMessageHeaderAccessor, String jsonInString, Principal p)
            throws Exception {
        log.info("simpMessageHeaderAccessor=>" + simpMessageHeaderAccessor);
        Map nativeHeaders = (Map) simpMessageHeaderAccessor.getHeader("nativeHeaders");
        String UUID = nativeHeaders.get("UUID").toString();// 클라이언트가 보낸 값
        log.info("Uuid=>" + nativeHeaders.get("UUID"));
        log.info("p.getName()=>" + p.getName());
        String SessionId = simpMessageHeaderAccessor.getSessionId();
        int cnt = wsel.getSessionCnt();
        // String msg ="["+cnt+"]["+SessionId+"]"+jsonInString;
        // log.info("msg=>"+msg);
        // String jsonOutString="aaa";
        log.info("jsonInString=>" + jsonInString);
        String jsonOutString = null;
        HashMap<String, Object> inDs = pjtU.JsonStringToObject(jsonInString, HashMap.class);
        String br = inDs.get("br").toString();
        jsonOutString = goS.callAPIMap(br, inDs);

        /*
         * status ==> true status ==> false
         * 
         * 
         */

        // https://withseungryu.tistory.com/136
        //System.out.println(jsonOutString);
        //System.out.println("ddddddddddddddddddddddd");
        smt.convertAndSendToUser(p.getName(), "/topic/message", jsonOutString);// 동작을 안함.
    }

}
