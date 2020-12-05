package com.example.demo.controller;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class LoginPageController {

		@GetMapping("/")
	    public void index(HttpServletRequest request, HttpServletResponse response, Object handler) throws IOException{
			response.sendRedirect("/login/login");
	    }
		@GetMapping("/login/login")
	    public String login(HttpSession session){
	        return "login"; 
	    }
		
		@GetMapping("/login/logout")
	    public String logout(HttpSession session){
	        return "logout"; 
	    }
}
