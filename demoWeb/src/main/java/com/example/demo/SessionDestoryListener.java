package com.example.demo;

import java.util.List;

import com.example.demo.user.domain.UserInfo;

import org.springframework.context.ApplicationListener;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.session.SessionDestroyedEvent;
import org.springframework.stereotype.Component;

@Component
public class SessionDestoryListener implements ApplicationListener<SessionDestroyedEvent>{

    ///세션 만료 이력 남기기
    ///https://gigas-blog.tistory.com/135
    @Override
    public void onApplicationEvent(SessionDestroyedEvent event) {
        //세션이 종료될때 실행됨-로그를 남길수 있음
        List<SecurityContext> al_sc= event.getSecurityContexts();
        for(SecurityContext sc : al_sc){
            UserInfo u = (UserInfo) sc.getAuthentication().getPrincipal();
            //u 정보를 가지고 db에 로그를 남기자!!
        }
        
    
        
    }

}
