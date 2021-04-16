package com.example.demo;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.security.authentication.event.AuthenticationSuccessEvent;
import org.springframework.security.web.session.HttpSessionCreatedEvent;
import org.springframework.security.web.session.HttpSessionDestroyedEvent;
import org.springframework.stereotype.Component;

import lombok.extern.slf4j.Slf4j;



@Slf4j
@Component
public class SessionListener implements ApplicationListener<ApplicationEvent>{
    
	@Autowired
	HttpSession httpSession;

    //참고자료
    //https://okky.kr/article/342715

    @Override
    public void onApplicationEvent(ApplicationEvent applicationEvent) {
        if(applicationEvent instanceof HttpSessionCreatedEvent){ //If event is a session created event
            log.debug("  HttpSessionCreatedEvent  :" ); //log data
        }else if(applicationEvent instanceof HttpSessionDestroyedEvent){ //If event is a session destroy event
           // handler.expireCart();
            log.debug(""+(Long)httpSession.getAttribute("userId"));
            log.debug(" Session is destory  :" ); //log data
        }else if(applicationEvent instanceof AuthenticationSuccessEvent){ //If event is a session destroy event
            log.debug("  athentication is success  :" ); //log data
        }else{
        }  
        
    }

    /*
<sec:session-management invalid-session-url="/?invalid" session-authentication-error-url="/?authentication" session-fixation-protection="newSession">
<sec:concurrency-control max-sessions="1" expired-url="/?expired" session-registry-ref="sessionRegistry" />
</sec:session-management>
Invalid-session-url : 세션 타임아웃떨어졌을 때
expired-url : 동시로그인 됐을대.
Session Fixation Attack 방지
악의적인 사용자가 사이트에 접근하기 위한 세션을 만들고, 그 세션을 통해 다른 사용자로 로그인 하려고 하는 경우
(예를 들어, 세션에 ID를 파라미터로 포함하여 전송하는 경우) 
Session fixation attack의 잠재적인 위험이 존재하게 된다. 
스프링 시큐리티는 이러한 공격을 자동으로 막기 위하여 사용자 로그인 때마다 새로운 세션을 생성한다. 
이러한 방지 기능이 필요하지 않거나, 다른 기능들과 충돌이 발생할 경우에는, 
<session-management>의 session-fixation-protection 속성값으로 동작을 제어할 수 있다. 
속성은 다음과 같은 세가지 옵션값들을 가진다.
migrateSession - 새로운 세션을 생성하고 기존의 세션 값들을 새 세션에 복사해준다. 기본값으로 설정되어 있다.
none - 아무것도 수행하지 않는다. 원래의 세션이 유지된다.
newSession - "깨끗한" 새로운 세션을 생성한다. 기존의 세션데이터는 복사하지 않는다.
ex> 
<session-management session-fixation-protection="none" />
Sewoo 톰캣 박세우 Park, [18.07.16 16:07]
error-if-maximum-exceeded="true"속성  주면 두번째 인증 아예 못들어가게 하는거고
Sewoo 톰캣 박세우 Park, [18.07.16 16:07]
session-management의 속성에 session-fixation-protection이란 속성이 있는데
이 부분은 Session Fixation( 악성 사용자 가 사이트에 접속하여 세션 ID 를 획득 후 획득 한 세션 ID를 사용하여 다른 사용자가 사이트에 접속하도록 유도하여 다른 사용자가 해당 세션 ID로 사이트 접속시악성 사용자도 같은 세션으로 함께 로그인이 되는 방법 )을 이용한 악성 사용자를 막기 위해 security에서 매번 인증 요청시마다 session을 재생성 하는데 이를 제어하기 위한 속성이다.
*/
}
