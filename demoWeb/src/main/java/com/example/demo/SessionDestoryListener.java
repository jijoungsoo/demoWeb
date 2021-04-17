package com.example.demo;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.example.demo.service.GoRestService;
import com.example.demo.user.domain.UserInfo;
import com.example.demo.utils.PjtUtil;
import com.fasterxml.jackson.core.JsonProcessingException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationListener;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.session.SessionDestroyedEvent;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

@Component
public class SessionDestoryListener implements ApplicationListener<SessionDestroyedEvent>{

    
    @Autowired
	GoRestService goS;

    @Autowired
	PjtUtil ptjU;
    
    ///세션 만료 이력 남기기
    ///https://gigas-blog.tistory.com/135
    @Override
    public void onApplicationEvent(SessionDestroyedEvent event) {
        System.out.println("bbbbbbbbbbbbbbbbbbb----2");
        HashMap<String, Object> IN_DS = new HashMap<String, Object>();
        IN_DS.put("brRq", "IN_DATA");
        IN_DS.put("brRs", "OUT_DATA");
        ArrayList<HashMap<String, Object>> in_date = new ArrayList<HashMap<String, Object>>();

        //세션이 종료될때 실행됨-로그를 남길수 있음
        List<SecurityContext> al_sc= event.getSecurityContexts();
        for(SecurityContext sc : al_sc){
            UserInfo u = (UserInfo)  sc.getAuthentication().getPrincipal();
            HashMap<String, Object> tmp = new HashMap<String, Object>();
            tmp.put("USER_NO", u.getUserNo());
            tmp.put("USER_ID", u.getUsername());
            tmp.put("LOG_TYPE", "LOGOUT");
            tmp.put("IPADDR", "");
            in_date.add(tmp);
        }

        
        
        IN_DS.put("IN_DATA", in_date);

        String jsonInString;
        try {
            jsonInString = ptjU.ObjectToJsonString(IN_DS);
            String jsonOutString = goS.callAPI("BR_CM_SESSION_LOG_CRT", jsonInString);
            //OUT_DS = ptjU.JsonStringToObject(jsonOutString, HashMap.class);
        } catch (JsonProcessingException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

}
