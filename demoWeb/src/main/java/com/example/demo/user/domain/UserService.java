package com.example.demo.user.domain;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Objects;

import com.example.demo.exception.BizException;
import com.example.demo.service.GoRestService;
import com.example.demo.utils.PjtUtil;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.client.ResourceAccessException;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequiredArgsConstructor
@Service
public class UserService implements UserDetailsService {
	
	@Autowired
	GoRestService goS;

	@Autowired
	PjtUtil pjtU;


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
			
			String jsonInString=pjtU.ObjectToJsonString(IN_DS);
			String jsonOutString=null;
			try {
				jsonOutString = goS.callAPI("BR_CM_LOGIN_LOAD_USER_BY_USER_NAME",jsonInString);
			} catch (ResourceAccessException | BizException e) {
				// TODO Auto-generated catch block
				log.error(e.getMessage(),e);
				throw new UsernameNotFoundException(e.getMessage());
				
			}
			HashMap<String, Object> rs= pjtU.JsonStringToObject(jsonOutString, HashMap.class);
			ArrayList<HashMap<String,Object>> OUT_DATA = (ArrayList<HashMap<String,Object>>) rs.get("OUT_DATA");
			System.out.println("jsonOutString->"+jsonOutString);
/*
 {
                    "OUT_DATA":[
                    {
                        "USER_NO":"0","USER_NM":null,"AUTH":"ROLE_ADMIN,ROLE_ADULT,ROLE_ADMIN,ROLE_ADULT","USER_ID":"jijs","EMAIL":"admin@ji.co.kr","USER_PWD":"$2a$10$bZugwrD3UkZ5dqdmJW4NCOLGG4gse.uyXYmPxneTsO5P4rRodSY22"
                    }
                        
                    ]
                },
*/


			System.out.println("aaaaa1");
			System.out.println(OUT_DATA);
			System.out.println("aaaaa2");
			

			if(OUT_DATA.size()==1) {
				HashMap<String,Object> OUT_DATA_ROW=OUT_DATA.get(0);
				//String tmp2  =pjtU.ObjectToJsonString(OUT_DATA_ROW);   
				//UserInfo tmp3 = pjtU.JsonStringToObject(tmp2,UserInfo.class);
				/* 대소문자가 맞지 않아서 변환작업이 있어야한다.
				*/
				UserInfo tmp3= new UserInfo(
					Long.parseLong(OUT_DATA_ROW.get("USER_NO").toString())
					,Objects.toString(OUT_DATA_ROW.get("USER_ID"),"")
					,Objects.toString(OUT_DATA_ROW.get("USER_PWD"),"")
					,Objects.toString(OUT_DATA_ROW.get("AUTH"),"")
					,Objects.toString(OUT_DATA_ROW.get("USER_NM"),"")
					,Objects.toString(OUT_DATA_ROW.get("EMAIL"),"")
				);
				

				
				userInfo.add(tmp3);
			}
			if(OUT_DATA.size()>1) {
				throw new UsernameNotFoundException("사용자정보가 2개이상입니다. 관리자에게 문의하세요");
			}
		} catch (JsonMappingException e) {
			// TODO Auto-generated catch block
			log.error(e.getMessage(),e);
		} catch (JsonProcessingException e) {
			// TODO Auto-generated catch block
			log.error(e.getMessage(),e);
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
		//하다가 말았네
		String tmp = goS.callAPI("saveUser", jsonString);
	} catch (ResourceAccessException | BizException e) {
		// TODO Auto-generated catch block
        log.error(e.getMessage(),e);
	}
	
  }	
	   
}
