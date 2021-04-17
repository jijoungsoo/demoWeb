package com.example.demo.cm.ctrl;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.example.demo.security.login.CustomUrlAuthenticationSuccessHandler;
import com.example.demo.user.domain.UserInfoDto;
import com.example.demo.user.domain.UserService;
import com.example.demo.utils.PjtUtil;
import com.fasterxml.jackson.core.JsonProcessingException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class LoginPageController {
	  @Autowired
	  private UserService userService;

	  @Autowired
	PjtUtil pjtU;

		@GetMapping("/login")
	    public String login(
	    		HttpServletRequest request
	    		,HttpSession session
	    		, Model model
	    		){
			//Cookie[] arrCookie =request.getCookies();
			//모든 키를 문자열로
			//String tmp =Arrays.stream(arrCookie).map(c -> c.getName()+"="+c.getValue()).collect(Collectors.joining(","));
			long start = System.currentTimeMillis();
			//이거 없었으면 겁나 for문 돌렸을 텐데.
			String v_userId="";
			String v_userPwd="";
			String v_autoLoginYn="";
			///Cookie myCookie = WebUtils.getCookie(request, k_userId);
			//이걸쓰지 못했다. 왜냐하면 암호가 될때마다 값이 달라진다 복호화는 같은데!!!
			Cookie[] arrCookie =request.getCookies();
			try {
				
				if(arrCookie!=null){
					for(int i=0;i<arrCookie.length;i++) {
						Cookie ck =arrCookie[i];
						String cookieName = ck.getName();
						//암호화된 문자열이 82자리였다. 
						//여유있게 이름이 40자가 넘으면 대상이라고 보면 되겠다.
						//생각해보니 key값이 똑같으니까 82개로 하면 되겠다.
						//82가 아니네.. 대략 60으로 하자.
						log.info("cookieName.length()=>"+cookieName.length());
						if(cookieName.length()>60) {
							String tmp =pjtU.decAES256AndUrl(cookieName);
							if(tmp.equals(CustomUrlAuthenticationSuccessHandler.userId)) {
								v_userId=ck.getValue();
								v_userId =pjtU.decAES256AndUrl(v_userId);
							}
							if(tmp.equals(CustomUrlAuthenticationSuccessHandler.userPwd)) {
								v_userPwd=ck.getValue();
								v_userPwd =pjtU.decAES256AndUrl(v_userPwd);
							}
							if(tmp.equals(CustomUrlAuthenticationSuccessHandler.autoLoginYn)) {
								v_autoLoginYn=ck.getValue();
								v_autoLoginYn =pjtU.decAES256AndUrl(v_autoLoginYn);
							}
						}
					}
				}
				

				
				
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			log.info("v_userId=>"+v_userId);
			log.info("v_userPwd=>"+v_userPwd);
			log.info("v_autoLoginYn=>"+v_autoLoginYn);
			log.info("v_autoLoginYn=>"+v_autoLoginYn);

			long end = System.currentTimeMillis();
			System.out.println("쿠키출력 속도 실행시간 : " + (end - start)/1000.0);
						
			model.addAttribute(CustomUrlAuthenticationSuccessHandler.userId, v_userId);
			model.addAttribute(CustomUrlAuthenticationSuccessHandler.userPwd, v_userPwd);
			model.addAttribute(CustomUrlAuthenticationSuccessHandler.autoLoginYn, v_autoLoginYn);
	        return "login"; 
	    }

		@PostMapping("/kakaoLogin")
		public String kakaoLogin(UserInfoDto infoDto) { // 회원 추가
		    try {
				userService.save(infoDto);
			} catch (JsonProcessingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		  return "redirect:/login";
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
