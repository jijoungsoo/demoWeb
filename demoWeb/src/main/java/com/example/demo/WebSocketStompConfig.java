package com.example.demo;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

@Configuration
@EnableWebSocketMessageBroker
public class WebSocketStompConfig implements WebSocketMessageBrokerConfigurer {
 
    //messageBroker config
    @Override
    public void configureMessageBroker(MessageBrokerRegistry config) {
 
        //in-memory message-broker, topic에 대한 prefix 설정
         config.enableSimpleBroker("/topic");
 
 
        //메세지를 수신하는 handler의 메세지 prefix 설정 
         // 컨텍스트가 있다면  컨텍스트를 쓰자.
        config.setApplicationDestinationPrefixes("/");
 
    };
 
    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        /*엔드 포인트 받는 주소 */
       //registry.addEndpoint("/stompMethod").setAllowedOrigins("*").withSockJS();
        //아래와 같은 이유로 주소로 써주어야한다.
       registry.addEndpoint("/ws-stomp").setAllowedOrigins("http://localhost:8090").withSockJS();
       
       /*
       Servlet.service() for servlet 
       [dispatcherServlet] in context with path [] threw exception [Request processing 
                                                                    failed; 
nested exception is java.lang.IllegalArgumentException: 
When allowCredentials is true, 
allowedOrigins cannot contain the special value "*"
since that cannot be set on the "Access-Control-Allow-Origin" response header. 
To allow credentials to a set of origins, 
list them explicitly or consider using "allowedOriginPatterns" instead.]
 with root cause
*/
    }
}
 
