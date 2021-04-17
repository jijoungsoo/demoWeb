package com.example.demo;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

import javax.servlet.annotation.WebListener;

import com.example.demo.service.GoRestService;
import com.example.demo.user.domain.UserInfo;
import com.example.demo.utils.PjtUtil;
import com.fasterxml.jackson.core.JsonProcessingException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationListener;
import org.springframework.security.core.session.SessionCreationEvent;
import org.springframework.stereotype.Component;

import io.undertow.servlet.spec.HttpSessionImpl;

@WebListener
@Component
public class SessionCreateListener implements ApplicationListener<SessionCreationEvent>{

    @Autowired
	GoRestService goS;

    @Autowired
	PjtUtil ptjU;

    @Autowired
    YmlConfig yc;
    
    
    //참고자료
    //https://okky.kr/article/342715
    @Override
    public void onApplicationEvent(SessionCreationEvent event) {
        System.out.println("bbbbbbbbbbbbbbbbbbb----1");

         //세션이 종료될때 실행됨-로그를 남길수 있음
         Object o= event.getSource();
         HttpSessionImpl t= (HttpSessionImpl)o;
         t.setMaxInactiveInterval(yc.getTimeout());//10초

         System.out.println(t.getAttributeNames());
         System.out.println(t.getId());
         System.out.println(t.getCreationTime());
         System.out.println(t.getLastAccessedTime());
         Iterator<String> it= t.getAttributeNames().asIterator();
         while(it.hasNext()){
             String key = it.next();
            String tmp =(String) t.getAttribute(key);
            System.out.println(tmp);

         }
         //CustomAuthenticationSuccessHandler  쪽으로 세션 log  옮김
         //이쪽은 일반 로그인 전 settion도 가지고 있어 사용하지 못함      
    }
}
