package com.example.demo.security.login;


import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.logout.LogoutSuccessHandler;
import org.springframework.stereotype.Component;

import lombok.extern.slf4j.Slf4j;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException; 

@Slf4j
@Component
public class CustomLogoutSuccessHandler implements LogoutSuccessHandler{	

    @Override
    public void onLogoutSuccess(HttpServletRequest request, HttpServletResponse response,
                             Authentication authentication) throws IOException, ServletException {
        if (authentication != null && authentication.getDetails() != null) {
            try {
                 request.getSession().invalidate();
            } catch (Exception e) {
                log.error(e.getMessage(),e);
            }
        } 
        

    	response.setCharacterEncoding("UTF-8");
    	response.setContentType("application/json;charset=UTF-8");  //된다 한글
    	response.getWriter().print("로그아웃 고고!!");
        response.setStatus(HttpServletResponse.SC_OK); 
        response.getWriter().flush();
    }
}