package com.example.demo.security.login;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import com.example.demo.cm.ctrl.ApiRestController;
import com.example.demo.cm.utils.PjtUtil;
import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class CustomUrlAuthenticationSuccessHandler extends SimpleUrlAuthenticationSuccessHandler {
	public static String userId="userId";
	public static String userPwd="userPwd";
	public static String autoLoginYn="autoLoginYn";
	
	    /**
		 * 로그인이 성공하고나서 로직
		 * https://programmer93.tistory.com/42
		 */
	    @Override
	    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
	                                        Authentication authentication) throws ServletException, IOException {

	    	ObjectMapper mapper = new ObjectMapper();	//JSON 변경용
	    	
	    	ResponseDataDTO responseDataDTO = new ResponseDataDTO();
	    	responseDataDTO.setCode(ResponseDataCode.SUCCESS);
	    	responseDataDTO.setStatus(ResponseDataStatus.SUCCESS);
	    	
	    	Map<String, String> items = new HashMap<String,String>();	
	    	if(request.getSession().getAttribute("prevPage")!=null) {
	    		String prevPage = request.getSession().getAttribute("prevPage").toString();	//이전 페이지 가져오기
	    		items.put("url", prevPage);	// 이전 페이지 저장
	    	}
	    	/*
	    	 * 로그인 하고 나면 쿠키로 저장한다.
	    	 * 
	    	 * 
	    	 * 
	    	 * 
	    	 * */
	    	
	    	String userId=request.getParameter(CustomUrlAuthenticationSuccessHandler.userId);
	    	String userPwd=request.getParameter(CustomUrlAuthenticationSuccessHandler.userPwd);
	    	String autoLoginYn=request.getParameter(CustomUrlAuthenticationSuccessHandler.autoLoginYn);
	    	
	    	log.info("BBBBB");
	    	log.info(autoLoginYn);
	    	 
	    	String k_userId			= CustomUrlAuthenticationSuccessHandler.userId;
	    	String k_userPwd		= CustomUrlAuthenticationSuccessHandler.userPwd;
	    	String k_autoLoginYn	= CustomUrlAuthenticationSuccessHandler.autoLoginYn;
	    	
	    	String v_userId			= userId;
	    	String v_userPwd		= userPwd;
	    	String v_autoLoginYn	= autoLoginYn;
	    	try {
	    		k_userId			= PjtUtil.encAES256AndUrl("userId");
	    		k_userPwd			= PjtUtil.encAES256AndUrl("userPwd");
	    		k_autoLoginYn		= PjtUtil.encAES256AndUrl("autoLoginYn");
	    		
	    		v_userId			= PjtUtil.encAES256AndUrl(v_userId);
	    		v_userPwd			= PjtUtil.encAES256AndUrl(v_userPwd);
	    		v_autoLoginYn		= PjtUtil.encAES256AndUrl(v_autoLoginYn);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	    	
	    	/*로그인을 할때마다 세션을 다 날리자.!!*/
	    	Cookie[] arrCookie =request.getCookies();
			for(int i=0;i<arrCookie.length;i++) {
				Cookie ck =arrCookie[i];
				if(ck.getName().length()>60) {
					ck.setPath("/"); // 모든 경로에서 접근 가능 하도록 설정
					ck.setMaxAge( (0 /*지우기*/)  );
					ck.setHttpOnly(true);
					response.addCookie(ck);	
				}
				
			}
	    	
		    	

	    	if(autoLoginYn.equals("Y")) {
	    	   //원래 쿠키의 이름이 userInfo 이었다면, value를 null로 처리.
	    	   //나중에 키도 암호화하고  값도 암호화 하자 
	    	   Cookie myCookie = new Cookie(k_userId, v_userId);
	    	   myCookie.setMaxAge( (365*(24 * 60 * 60 * 1000 /*하루*/))  );
	    	   myCookie.setPath("/"); // 모든 경로에서 접근 가능 하도록 설정
	    	   myCookie.setHttpOnly(true);  /*이 설정을 하면 XSS 보안이된다    javascript에서 쿠키에 접근 못한다.
	    	   https://dzone.com/articles/how-to-use-cookies-in-spring-boot
	    	   */ 
	    	   response.addCookie(myCookie);
	    	   
	    	   Cookie myCookie1 = new Cookie(k_userPwd, v_userPwd);
	    	   myCookie1.setPath("/"); // 모든 경로에서 접근 가능 하도록 설정
	    	   myCookie1.setMaxAge( (365*(24 * 60 * 60 * 1000 /*하루*/))  );
	    	   myCookie1.setHttpOnly(true); 
	    	   response.addCookie(myCookie1);
	    	   
	    	   Cookie myCookie2 = new Cookie(k_autoLoginYn, v_autoLoginYn);
	    	   myCookie2.setPath("/"); // 모든 경로에서 접근 가능 하도록 설정
	    	   myCookie2.setMaxAge( (365*(24 * 60 * 60 * 1000 /*하루*/))  );
	    	   myCookie2.setHttpOnly(true);
	    	   response.addCookie(myCookie2);
	    	} 
	        
	    	responseDataDTO.setItem(items);
	    	response.setCharacterEncoding("UTF-8");
	    	response.setContentType("application/json;charset=UTF-8");  //된다 한글  
	        response.setStatus(HttpServletResponse.SC_OK);
	        response.getWriter().print(mapper.writeValueAsString(responseDataDTO));
	        response.getWriter().flush();
	    }

}
