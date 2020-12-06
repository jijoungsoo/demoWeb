package com.example.demo.user.domain;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.controller.GoRestController;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.databind.node.ArrayNode;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class UserService implements UserDetailsService {
	
	@Autowired
	private GoRestController goRestApi;

  /**
   * Spring Security 필수 메소드 구현
   *
   * @param email 이메일
   * @return UserDetails
   * @throws UsernameNotFoundException 유저가 없을 때 예외 발생
   */
  @Override // 기본적인 반환 타입은 UserDetails, UserDetails를 상속받은 UserInfo로 반환 타입 지정 (자동으로 다운 캐스팅됨)
  public UserInfo loadUserByUsername(String userId) throws UsernameNotFoundException { // 시큐리티에서 지정한 서비스이기 때문에 이 메소드를 필수로 구현
	  String userJson = "{\"inData\": [{\"userId\":\""+userId+"\"}]}";   //이건 나중에 json 객체 만드는걸로 바꾸자.
	  ArrayList<UserInfo> userInfo = new ArrayList<UserInfo>(); 
		String jsonOutString = goRestApi.callAPI("loadUserByusername", userJson);
		ObjectMapper om = new ObjectMapper();
		om.enable(SerializationFeature.INDENT_OUTPUT);
		JsonNode rootNode;
		try {
			rootNode = om.readValue(jsonOutString,JsonNode.class);
			ArrayNode arrayNode = (ArrayNode) rootNode.get("outData");
			//userInfo =   om.convertValue(arrayNode,new TypeReference<ArrayList<UserInfo>>() {});
			//위에꺼랑 아래꺼랑 결과는 같다.
			for(int i=0;i<arrayNode.size();i++){
				JsonNode tmp = (JsonNode)arrayNode.get(i);
				String tmp2  =om.writeValueAsString(tmp);   
				UserInfo tmp3 = om.readValue(tmp2,UserInfo.class);
				userInfo.add(tmp3);
			}
		} catch (JsonMappingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (JsonProcessingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		  if(userInfo==null) {
			  throw new UsernameNotFoundException(userId);
		  }
	return  userInfo.get(0);
  }
  

  /**
   * 회원정보 저장
   *
   * @param infoDto 회원정보가 들어있는 DTO
   * @return 저장되는 회원의 PK
 * @throws JsonProcessingException 
   */
  public void save(UserInfoDto userInfoDto) throws JsonProcessingException {
	  /*이거 자체가 jpa 등록하는게 이슈이므로 내가 크게 할게 없다.
	   * 여기서 암호화 해서 보내지니까.
	   * jpa에서 스프링 security를 빼도 될것 같다. 
	   * */
    BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
    userInfoDto.setPassword(encoder.encode(userInfoDto.getPassword()));
    
    ObjectMapper om = new ObjectMapper();
    String jsonString = om.writeValueAsString(userInfoDto);

	String tmp = goRestApi.callAPI("saveUser", jsonString);
  }	
	   
}
