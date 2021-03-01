package com.example.demo.security.oauth2;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

import com.example.demo.service.BrService;
import com.example.demo.user.domain.UserInfo;
import com.example.demo.utils.PjtUtil;
import com.fasterxml.jackson.core.JsonProcessingException;

import org.springframework.core.ParameterizedTypeReference;
import org.springframework.core.convert.converter.Converter;
import org.springframework.http.RequestEntity;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.oauth2.client.http.OAuth2ErrorResponseErrorHandler;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequestEntityConverter;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.OAuth2AuthorizationException;
import org.springframework.security.oauth2.core.OAuth2Error;
import org.springframework.stereotype.Service;
import org.springframework.util.Assert;
import org.springframework.util.StringUtils;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestOperations;
import org.springframework.web.client.RestTemplate;

@Service
public class CustomOAuth2UserService extends DefaultOAuth2UserService {
    // https://github.com/engkimbs/spring-boot-oauth2
    // https://engkimbs.tistory.com/849
    private static final String MISSING_USER_INFO_URI_ERROR_CODE = "missing_user_info_uri";

    private static final String MISSING_USER_NAME_ATTRIBUTE_ERROR_CODE = "missing_user_name_attribute";

    private static final String INVALID_USER_INFO_RESPONSE_ERROR_CODE = "invalid_user_info_response";

    private static final ParameterizedTypeReference<Map<String, Object>> PARAMETERIZED_RESPONSE_TYPE = new ParameterizedTypeReference<Map<String, Object>>() {
    };

    private Converter<OAuth2UserRequest, RequestEntity<?>> requestEntityConverter = new OAuth2UserRequestEntityConverter();

    private RestOperations restOperations;

    public CustomOAuth2UserService() {
        RestTemplate restTemplate = new RestTemplate();
        restTemplate.setErrorHandler(new OAuth2ErrorResponseErrorHandler());
        this.restOperations = restTemplate;
    }

    @Override
    public UserInfo loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        Assert.notNull(userRequest, "userRequest cannot be null");
        if (!StringUtils
                .hasText(userRequest.getClientRegistration().getProviderDetails().getUserInfoEndpoint().getUri())) {
            OAuth2Error oauth2Error = new OAuth2Error(MISSING_USER_INFO_URI_ERROR_CODE,
                    "Missing required UserInfo Uri in UserInfoEndpoint for Client Registration: "
                            + userRequest.getClientRegistration().getRegistrationId(),
                    null);
            throw new OAuth2AuthenticationException(oauth2Error, oauth2Error.toString());
        }

        String userNameAttributeName = userRequest.getClientRegistration().getProviderDetails().getUserInfoEndpoint()
                .getUserNameAttributeName();
        if (!StringUtils.hasText(userNameAttributeName)) {
            OAuth2Error oauth2Error = new OAuth2Error(MISSING_USER_NAME_ATTRIBUTE_ERROR_CODE,
                    "Missing required \"user name\" attribute name in UserInfoEndpoint for Client Registration: "
                            + userRequest.getClientRegistration().getRegistrationId(),
                    null);
            throw new OAuth2AuthenticationException(oauth2Error, oauth2Error.toString());
        }
        RequestEntity<?> request = this.requestEntityConverter.convert(userRequest);

        ResponseEntity<Map<String, Object>> response;
        try {
            response = this.restOperations.exchange(request, PARAMETERIZED_RESPONSE_TYPE);
        } catch (OAuth2AuthorizationException ex) {
            OAuth2Error oauth2Error = ex.getError();
            StringBuilder errorDetails = new StringBuilder();
            errorDetails.append("Error details: [");
            errorDetails.append("UserInfo Uri: ")
                    .append(userRequest.getClientRegistration().getProviderDetails().getUserInfoEndpoint().getUri());
            errorDetails.append(", Error Code: ").append(oauth2Error.getErrorCode());
            if (oauth2Error.getDescription() != null) {
                errorDetails.append(", Error Description: ").append(oauth2Error.getDescription());
            }
            errorDetails.append("]");
            oauth2Error = new OAuth2Error(INVALID_USER_INFO_RESPONSE_ERROR_CODE,
                    "An error occurred while attempting to retrieve the UserInfo Resource: " + errorDetails.toString(),
                    null);
            throw new OAuth2AuthenticationException(oauth2Error, oauth2Error.toString(), ex);
        } catch (RestClientException ex) {
            OAuth2Error oauth2Error = new OAuth2Error(INVALID_USER_INFO_RESPONSE_ERROR_CODE,
                    "An error occurred while attempting to retrieve the UserInfo Resource: " + ex.getMessage(), null);
            throw new OAuth2AuthenticationException(oauth2Error, oauth2Error.toString(), ex);
        }
        // https://velog.io/@swchoi0329/%EC%8A%A4%ED%94%84%EB%A7%81-%EC%8B%9C%ED%81%90%EB%A6%AC%ED%8B%B0%EC%99%80-OAuth-2.0%EC%9C%BC%EB%A1%9C-%EB%A1%9C%EA%B7%B8%EC%9D%B8-%EA%B8%B0%EB%8A%A5-%EA%B5%AC%ED%98%84

        Map<String, Object> userAttributes = getUserAttributes(response);

        System.out.println(userAttributes);
    
        String registrationId = userRequest.getClientRegistration().getRegistrationId();
        System.out.println("registrationId");
        System.out.println(registrationId);

        String uri =userRequest.getClientRegistration().getProviderDetails().getUserInfoEndpoint().getUri();
        System.out.println("uri");
        System.out.println(uri);
      
        OAuthAttributes attributes = OAuthAttributes.of(registrationId,userNameAttributeName, userAttributes);
    
        UserInfo ud=null;
        try {
            ud = saveOrUpdate(attributes);
        } catch (JsonProcessingException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

        // return new DefaultOAuth2User(authorities, attributes.getAttributes(),
        // userNameAttributeName);
        return ud;
    }

    //네이버는 HTTP response body에 response 안에 id 값을 포함한 유저정보를 넣어주므로 유저정보를 빼내기 위한 작업을 함 
    private Map<String, Object> getUserAttributes(ResponseEntity<Map<String, Object>> response) { 
        Map<String, Object> userAttributes = response.getBody(); 
        if(userAttributes.containsKey("response")) { 
            LinkedHashMap responseData = (LinkedHashMap)userAttributes.get("response"); 
            userAttributes.putAll(responseData); userAttributes.remove("response"); 
        } 
        return userAttributes; 
    }



   
    private UserInfo saveOrUpdate(OAuthAttributes attr) throws JsonProcessingException {
        UserInfo tmp3=null;
        HashMap<String,Object> IN_DATA_ROW = new HashMap<String,Object>();
        IN_DATA_ROW.put("SNS_GUBUN", attr.getSnsGubun());
        IN_DATA_ROW.put("SNS_ID", attr.getSnsId());
        IN_DATA_ROW.put("USER_NM", attr.getNickname());
        IN_DATA_ROW.put("USER_ID", attr.getSnsGubun() +"_"+attr.getSnsId());
        IN_DATA_ROW.put("PRF_IMG", attr.getPrfImg());
        IN_DATA_ROW.put("THMB_IMG", attr.getThumbImg());
        IN_DATA_ROW.put("EMAIL", attr.getEmail());
        IN_DATA_ROW.put("BRTHDAY", attr.getBirthday());
        IN_DATA_ROW.put("GNDR", attr.getGender());

        ArrayList<HashMap<String,Object>> OUT_DATA = BrService.BR_CM_LOGIN_SNS(IN_DATA_ROW);

        if(OUT_DATA.size()>1) {
            throw new UsernameNotFoundException("사용자정보가 2개이상입니다. 관리자에게 문의하세요");
        }

        if(OUT_DATA.size()==0) {
			throw new UsernameNotFoundException("사용자가 없습니다.");
		}

        if(OUT_DATA.size()==1) {
            HashMap<String,Object> OUT_DATA_ROW=OUT_DATA.get(0);
            String tmp2  =PjtUtil.ObjectToJsonString(OUT_DATA_ROW);   
            tmp3 = PjtUtil.JsonStringToObject(tmp2,UserInfo.class);            
        }

        return tmp3;
    }

  
}