package com.example.demo;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.event.EventListener;
import org.springframework.messaging.simp.SimpMessageSendingOperations;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.messaging.SessionConnectedEvent;
import org.springframework.web.socket.messaging.SessionDisconnectEvent;

import com.example.demo.cm.utils.PjtUtil;
import com.fasterxml.jackson.core.JsonProcessingException;

@Component
public class WebSocketEventListener {
/*https://ratseno.tistory.com/71
 * 여기서 펍 하고 싶었던 것은 stomp 의 접속 세션수를 알고 싶었다.
 * */
    private static final Logger logger = LoggerFactory.getLogger(WebSocketEventListener.class);

    @Autowired
    private SimpMessageSendingOperations messagingTemplate;
    
    public int getSessionCnt() {
        return sessions.size();
    }
    HashMap<String,StompHeaderAccessor> sessions = new HashMap<String,StompHeaderAccessor>();
    @EventListener
    public void handleWebSocketConnectListener(SessionConnectedEvent event) {
        logger.info("Received a new web socket connection");
        StompHeaderAccessor headerAccessor = StompHeaderAccessor.wrap(event.getMessage());
        logger.info("Received a new web socket connection. Session ID : [{}]", headerAccessor.getSessionId());
        logger.info("event",event);

        String sessionId  = headerAccessor.getSessionId();
        sessions.put(sessionId, headerAccessor);
    }

    @EventListener
    public void handleWebSocketDisconnectListener(SessionDisconnectEvent event) throws JsonProcessingException {
        
        StompHeaderAccessor headerAccessor = StompHeaderAccessor.wrap(event.getMessage());
        String sessionId = headerAccessor.getSessionId();
        sessions.remove(sessionId);
        logger.info("Received web socket disconnected");
        logger.info(PjtUtil.ObjectToJsonString(headerAccessor.getSessionAttributes()));
        String username = (String) headerAccessor.getSessionAttributes().get("username");
        if(username != null) {
            logger.info("User Disconnected : " + username);

            //ChatMessage chatMessage = new ChatMessage();
            //chatMessage.setType(MessageType.LEAVE);
            //chatMessage.setSender(username);
            
            //messagingTemplate.convertAndSend("/topic/public", chatMessage);
        } else {
            String msg ="["+sessionId+"]disconnect";
            messagingTemplate.convertAndSend("/topic/message",msg);
        }
        
    }
}
