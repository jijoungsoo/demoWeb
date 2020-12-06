package com.example.demo.controller;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.example.demo.user.domain.UserInfoDto;
import com.example.demo.user.domain.UserService;
import com.fasterxml.jackson.core.JsonProcessingException;

@Controller
public class LoginPageController {
	  @Autowired
	  private UserService userService;

		@GetMapping("/login")
	    public String login(HttpSession session){
	        return "login"; 
	    }
		
		  // 추가
		  @GetMapping(value = "/logout")
		  public String logoutPage(HttpServletRequest request, HttpServletResponse response) {
		    new SecurityContextLogoutHandler().logout(request, response, SecurityContextHolder.getContext().getAuthentication());
		    return "redirect:/login";
		  }

 	    @PostMapping("/user")
		public String signup(UserInfoDto infoDto) { // 회원 추가
		    try {
				userService.save(infoDto);
			} catch (JsonProcessingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		  return "redirect:/login";
		}
}
