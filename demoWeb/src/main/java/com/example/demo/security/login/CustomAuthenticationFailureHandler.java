package com.example.demo.security.login;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.web.authentication.SimpleUrlAuthenticationFailureHandler;
import org.springframework.stereotype.Component;
import org.springframework.security.authentication.InternalAuthenticationServiceException;
import org.springframework.security.core.AuthenticationException;

import com.fasterxml.jackson.databind.ObjectMapper;
@Component
public class CustomAuthenticationFailureHandler  extends SimpleUrlAuthenticationFailureHandler {
	    /**
		 * 로그인이 로그인 실패시 로직
		 * https://programmer93.tistory.com/42
		 */
	@Override
	public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
			AuthenticationException exception) throws IOException, ServletException {


			ObjectMapper mapper = new ObjectMapper();	//JSON 변경용
	    	
	    	ResponseDataDTO responseDataDTO = new ResponseDataDTO();
	    	responseDataDTO.setCode(ResponseDataCode.ERROR);
	    	responseDataDTO.setStatus(ResponseDataStatus.ERROR);
	    	responseDataDTO.setMessage(exception.getMessage());
	    	//responseDataDTO.setMessage("아이디 혹은 비밀번호가 일치하지 않습니다.");

	    	
	    	response.setCharacterEncoding("UTF-8");
	    	response.setContentType("application/json;charset=UTF-8");  //된다 한글  
	        response.setStatus(HttpServletResponse.SC_OK); 
	        response.getWriter().print(mapper.writeValueAsString(responseDataDTO));
	        response.getWriter().flush();

	        
	    }

}
