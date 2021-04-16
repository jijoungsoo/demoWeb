package com.example.demo;

import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

import org.springframework.stereotype.Component;

//https://sdragoon.tistory.com/24
@Component
public class CustomHttpSessionListner  implements HttpSessionListener {
    @Override
    public void sessionCreated(HttpSessionEvent se) {
        se.getSession().setMaxInactiveInterval(60*60); //세션만료60분
    }


    @Override
    public void sessionDestroyed(HttpSessionEvent se) {

    }
}