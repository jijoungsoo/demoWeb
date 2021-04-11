package com.example.demo.cm.ctrl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.example.demo.utils.PjtUtil;

import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;


public class ReplyEchoHandler extends TextWebSocketHandler {
	List<WebSocketSession> sessions = new ArrayList<WebSocketSession>();
	
	/*http 세션에 저장된 정보를 가져와 쓴다고 하다면 */
	Map<String,WebSocketSession> userSessions = new HashMap<String,WebSocketSession>(); 
	
    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        /* socket 연결이 된 후   동작*/
        System.out.println("afterConnectionEstablished:"+session);
        sessions.add(session);
        String senderId = session.getId();
        //String senderId =   getHttpSessionId(session); 
        //userSessions.put(senderId, session);
        
        for(WebSocketSession s : sessions) {
            //모두에게 보냄
            if(s!=null) {
                String tmp ="["+sessions.size()+"]["+senderId+"]가 방에 들어왔어요.";
                s.sendMessage(new TextMessage(tmp));    
            }
        }
    }

    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        /*  메시지가 들어왔을때 */
        System.out.println("handleTextMessage:"+session+",message:"+message.getPayload());
        String senderId = session.getId();
        
        String msg = message.getPayload();
        
        if(PjtUtil.isEmpty(msg))
            return;
        
        //나한테만 에코로 전달됨
        //String tmp ="["+sessions.size()+"]["+senderId+"]"+msg;
        //session.sendMessage(new TextMessage(tmp));
        for(WebSocketSession s : sessions) {
            //모두에게 보냄
            String tmp ="["+sessions.size()+"]["+senderId+"]"+msg;
            s.sendMessage(new TextMessage(tmp));  
        }
    }

    private String getHttpSessionId(WebSocketSession session) {
        Map<String,Object> httpSession = session.getAttributes();
        //서버 세션에 개체를 담았다고 생각한다.
        /*
        User loginUser = httpSession.get("사용자 정보를 가지고 있는 키");
        if(null == loginUser) {
            return session.getId();
        } else {
            return loginUser.getUid();
        }
        */
        
        return null;
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        /* socket이 꺼진 후 동작 */
        String senderId = session.getId();
        sessions.remove(session);
        for(WebSocketSession s : sessions) {
            //모두에게 보냄
            if(s!=null) {
                String tmp ="["+sessions.size()+"]["+senderId+"]가 방을 나갔어요.";
                s.sendMessage(new TextMessage(tmp));    
            }
        }
    }

}
