package com.example.demo.utils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class SessionUtil {
    public static boolean isLogin(HttpServletRequest request) {
        HttpSession session = request.getSession();
        if (session == null) {
            return false;
        } else {
            return true;
        }
    }

    public static HttpSession getSession(HttpServletRequest request) {
        HttpSession session = request.getSession();
        return session;
    }

    public static HttpSession getSession() {
        ServletRequestAttributes sra = (ServletRequestAttributes) RequestContextHolder.currentRequestAttributes();
        HttpServletRequest hsr = sra.getRequest();
        return hsr.getSession();
    }

}
