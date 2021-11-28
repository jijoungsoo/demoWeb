package com.example.demo.security.login;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.example.demo.exception.BizException;
import com.example.demo.service.GoRestService;
import com.example.demo.user.domain.UserInfo;
import com.example.demo.utils.PjtUtil;
import com.fasterxml.jackson.core.JsonProcessingException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.stereotype.Component;
import org.springframework.web.client.ResourceAccessException;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class CustomAuthenticationSuccessHandler  extends SimpleUrlAuthenticationSuccessHandler {


    @Autowired
	GoRestService goS;

    @Autowired
	PjtUtil ptjU;
	
	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication) throws IOException, ServletException {
		UserInfo u = (UserInfo)  authentication.getPrincipal();
		String ipaddr = getRemoteAddr(request);

        HashMap<String, Object> IN_DS = new HashMap<String, Object>();
        IN_DS.put("brRq", "IN_DATA");
        IN_DS.put("brRs", "");
        ArrayList<HashMap<String, Object>> in_date = new ArrayList<HashMap<String, Object>>();
        HashMap<String, Object> tmp = new HashMap<String, Object>();
        tmp.put("USER_NO", u.getUserNo());
        tmp.put("USER_ID", u.getUsername());
        tmp.put("LOG_TYPE", "LOGIN");
		tmp.put("IPADDR", ipaddr);
        in_date.add(tmp);
        IN_DS.put("IN_DATA", in_date);


        System.out.println("cccccccccccccccccccccccccccccccccccccccc");
		

        String jsonInString;
        try {
            jsonInString = ptjU.ObjectToJsonString(IN_DS);
            try {
                String jsonOutString = goS.callAPI("BR_CM_SESSION_LOG_CRT", jsonInString);
/*
                jsonInString last =>
            {"inDTName":"IN_DATA"
                ,"refDS":{"IN_DATA":[{"USER_NO":0,"USER_ID":"jijs","LOG_TYPE":"LOGIN","IPADDR":"0:0:0:0:0:0:0:1"}]}
                ,"actID":"BR_CM_SESSION_LOG_CRT"
                ,"outDTName":"OUT_DATA"
            }
*/                


            } catch (ResourceAccessException | BizException e) {
                log.error(e.getMessage(),e);
                new BizException(e.getMessage());
            }
            //OUT_DS = ptjU.JsonStringToObject(jsonOutString, HashMap.class);
        } catch (JsonProcessingException e) {
            log.error(e.getMessage(),e);
            new BizException(e.getMessage());
        }
		handle(request, response, authentication);
		clearAuthenticationAttributes(request);
      
	}

	protected String getRemoteAddr(HttpServletRequest request){
		System.out.println("ddddddddddddddddddd");
		System.out.println(request.getRemoteAddr());
		//아이피가 0:0:0:0:0:0:0:1 이라는건 ipv6의 주소를 가져온것으로 ipv4로 봤을때 127.0.0.1 이 맞다.
		//  톰캣설치경로 /bin/catalina.bat 의 "set JAVA_OPTS" 라는 키워드로 검색하면 두개가 나오는데 두군데 다  -Djava.net.preferIPv4Stack=true 추가
		///출처: https://rainny.tistory.com/177 [긍정적 사고방식^^]
		return (null != request.getHeader("X-FORWARDED-FOR")) ? request.getHeader("X-FORWARDED-FOR") : request.getRemoteAddr();
	}
	

}
