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
         config.enableSimpleBroker("/topic","/queue");
         /*http://minjoon.com/spring-stomp
          * topic
          * queue 는 기능적인 의미가 없다.
          * “/topic”와 “/queue”로 시작하는 심플(simple) 브로커는 어떤한 특별한 의미도 없다. 
          * 그것들은 단지 pub-sub 대 point-to-point 메시징(즉, 많은 가입자 대 하나의 소비자)을 
          * 구별하기 위한 컨벤션일 뿐이다. 외부 브로커를 사용할 때, STOMP 페이지를 확인해서 
          * 어떤 종류의 STOMP 목적지와 접두사를 지원하는지 확인하자.
          * */
         
         
 
 
        //메세지를 수신하는 handler의 메세지 prefix 설정 
         // 컨텍스트가 있다면  컨텍스트를 쓰자.
        config.setApplicationDestinationPrefixes("/");
 
    };
 
    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        /*엔드 포인트 받는 주소 */
       //registry.addEndpoint("/stompMethod").setAllowedOrigins("*").withSockJS();
        //아래와 같은 이유로 주소로 써주어야한다.
       //registry.addEndpoint("/ws-stomp").setAllowedOrigins("http://localhost:8090").setHandshakeHandler(new CustomHandshakeHandler()).withSockJS();
       registry.addEndpoint("/ws-stomp").setAllowedOrigins("http://localhost:8090","http://st.com","http://www.st.com").setHandshakeHandler(new CustomHandshakeHandler()).withSockJS();
       
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
 
