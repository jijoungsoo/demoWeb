package com.example.demo;

import com.example.demo.user.domain.UserInfo;

import org.springframework.context.ApplicationListener;
import org.springframework.security.core.session.SessionCreationEvent;
import org.springframework.stereotype.Component;

@Component
public class SessionCreateListener implements ApplicationListener<SessionCreationEvent>{

    //참고자료
    //https://okky.kr/article/342715
    @Override
    public void onApplicationEvent(SessionCreationEvent event) {
         //세션이 종료될때 실행됨-로그를 남길수 있음
         Object o= event.getSource();
         UserInfo u = (UserInfo)o;
         
        
    }


}
