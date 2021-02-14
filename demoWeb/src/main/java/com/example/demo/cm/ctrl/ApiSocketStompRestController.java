package com.example.demo.cm.ctrl;

import java.util.Map;

import com.example.demo.WebSocketEventListener;
import com.example.demo.service.GoRestService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.web.bind.annotation.RestController;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
public class ApiSocketStompRestController {
	
    @Autowired
    WebSocketEventListener wsel;
    
    /*https://tech.osci.kr/2019/12/23/86033468/ 
     * 이아저씨 예제가 좋다. 
     * */
    @Autowired
    SimpMessagingTemplate smt;
    
	@Autowired
	 private GoRestService goService;
	 private static Logger logger = LoggerFactory.getLogger("MLS_LOGGER"); 
	/*소켓*/
    @MessageMapping("/socketApi")   /*보내는 이름*/
    @SendTo("/topic/message")  /*받는 이름*/
    public String callSocketAPI(SimpMessageHeaderAccessor simpMessageHeaderAccessor, 
            String inputMsg
            ) throws Exception  {
        log.info("simpMessageHeaderAccessor=>"+simpMessageHeaderAccessor);
        Map nativeHeaders = (Map) simpMessageHeaderAccessor.getHeader("nativeHeaders");
        String UUID = nativeHeaders.get("UUID").toString();// 클라이언트가 보낸 값 
        log.info("Uuid=>"+nativeHeaders.get("UUID"));
        String SessionId = simpMessageHeaderAccessor.getSessionId();
        int cnt = wsel.getSessionCnt();
        String msg ="["+cnt+"]["+SessionId+"]"+inputMsg; 
        log.info("msg=>"+msg);
        //String jsonOutString="aaa";

       return msg;
    }
    
    @MessageMapping("/socketApiToMe")   /*보내는 이름*/
    public void callSocketAPIToMe(SimpMessageHeaderAccessor headerAccessor, 
            String inputMsg
            ) throws Exception  {
        log.info("headerAccessor=>"+headerAccessor);
        String SessionId = headerAccessor.getSessionId();
        int cnt = wsel.getSessionCnt();
        String msg ="["+cnt+"]["+SessionId+"]"+inputMsg; 
        log.info("msg=>"+msg);
        
        //내꺼 구분은 SessionId로 가능한데
        //내꺼 내에서 프로그램 구분을 하기위해서 UUID를 사용
        
        Map nativeHeaders = (Map) headerAccessor.getHeader("nativeHeaders");
        String UUID = nativeHeaders.get("UUID").toString();// 클라이언트가 보낸 값
        
        //String jsonOutString="aaa";
        /*
         * user는 나하고 동일하게 보내면 되고
         * detination 주소를 만들때 
         * /topic/message  에다가 /  client에서 만든 uuid 를 넣어서 보내면
         * 그사람만 구독하게 된다. 
         * */
        ///smt.convertAndSendToUser(user, destination, payload);
        //그러면 아래만 써도 특정이만 보낼수있게 할수있다.
        //smt.convertAndSend(destination, payload);
    }
 
}
