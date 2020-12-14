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

import com.example.demo.exception.BizException;
import com.example.demo.service.GoRestService;
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
	private GoRestService goRestS;

  /**
   * Spring Security 필수 메소드 구현
   *
   * @param email 이메일
   * @return UserDetails
   * @throws UsernameNotFoundException 유저가 없을 때 예외 발생
   */
  @Override // 기본적인 반환 타입은 UserDetails, UserDetails를 상속받은 UserInfo로 반환 타입 지정 (자동으로 다운 캐스팅됨)
  public UserInfo loadUserByUsername(String userId) throws UsernameNotFoundException { // 시큐리티에서 지정한 서비스이기 때문에 이 메소드를 필수로 구현
	  ArrayList<UserInfo> userInfo = new ArrayList<UserInfo>();
	  try {
			HashMap<String,Object> IN_DS = new HashMap<String,Object>();
			IN_DS.put("brRq","IN_DATA");
			IN_DS.put("brRs","OUT_DATA");
			ArrayList<HashMap<String,String>> IN_DATA  = new ArrayList<HashMap<String,String>>();
			  
			HashMap<String,String> IN_DATA_ROW = new HashMap<String,String>();
			IN_DATA_ROW.put("USER_ID", userId);
			IN_DATA.add(IN_DATA_ROW);
			IN_DS.put("IN_DATA", IN_DATA);
				  
			ObjectMapper om = new ObjectMapper();
			om.enable(SerializationFeature.INDENT_OUTPUT);
			String jsonInString=om.writeValueAsString(IN_DS);
				  
			  
			String jsonOutString = goRestS.callAPI("loadUserByusername",jsonInString);
			ObjectMapper omOut = new ObjectMapper();
			omOut.enable(SerializationFeature.INDENT_OUTPUT);
			HashMap<String, Object> rs= omOut.readValue(jsonOutString,HashMap.class);
			
			ArrayList<HashMap<String,String>> OUT_DATA = (ArrayList<HashMap<String,String>>) rs.get("OUT_DATA");
			//userInfo =   om.convertValue(arrayNode,new TypeReference<ArrayList<UserInfo>>() {});
			//위에꺼랑 아래꺼랑 결과는 같다.
			if(OUT_DATA.size()==1) {
				HashMap<String,String> OUT_DATA_ROW=OUT_DATA.get(0);
				String tmp2  =om.writeValueAsString(OUT_DATA_ROW);   
				UserInfo tmp3 = om.readValue(tmp2,UserInfo.class);
				userInfo.add(tmp3);
			}
			if(OUT_DATA.size()>1) {
				throw new UsernameNotFoundException("사용자정보가 2개이상입니다. 관리자에게 문의하세요");
			}
		} catch (JsonMappingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (JsonProcessingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (BizException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			
			throw  new UsernameNotFoundException(e.getMessage());
		}
		if(userInfo==null) {
			throw new UsernameNotFoundException(userId+"사용자가 없거나 비밀번호가 다릅니다.[1]");
		}
		if(userInfo.size()==0) {
			throw new UsernameNotFoundException(userId+"사용자가 없거나 비밀번호가 다릅니다.[2]");
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

	try {
		String tmp = goRestS.callAPI("saveUser", jsonString);
	} catch (BizException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
  }	
	   
}
