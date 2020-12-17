package com.example.demo;


import org.junit.jupiter.api.Test; 
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.annotation.Rollback;
import org.springframework.test.web.servlet.MockMvc;

import com.example.demo.user.domain.UserInfo;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.databind.node.ArrayNode;

import java.util.ArrayList;
@SpringBootTest(properties = "classpath:/application.yml"
,webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT
)  /*https://velog.io/@hellozin/Spring-Boot-Test에서-Yaml-프로퍼티-적용하기*/

@AutoConfigureMockMvc
@Rollback(false)  /*롤백하지 않게 하자. */
class DemoApplicationTests2 {

	@Autowired 
	MockMvc mvc;

	        
	        
    @Test
	void contextLoads() throws Exception {
		String jsonInString ="{\"outData\":[{\"userId\":\"admin\""
				+ ",\"userPwd\":\"$2a$10$2P231VUsRE/i22dWgX.yxuvDyLODSN/tAX9grzjxRm/AtY3ThPdli\""
				+ ",\"auth\":\"USER\" }"
				+ "]}";
		ArrayList<UserInfo> userInfo = null;
		ObjectMapper om = new ObjectMapper();
		om.enable(SerializationFeature.INDENT_OUTPUT);
		JsonNode rootNode;
		
			rootNode = om.readValue(jsonInString,JsonNode.class);
			ArrayNode arrayNode = (ArrayNode) rootNode.get("outData");
			for(int i=0;i<arrayNode.size();i++){
	
				JsonNode tmp = arrayNode.get(i);
				String tmp2  =om.writeValueAsString(tmp);   /*이렇게 까지 했는데 엄ㅊ어나게 에러가 많이 나서
				
				
				https://blog.benelog.net/jackson-with-constructor.html
				com.fasterxml.jackson.databind.exc.InvalidDefinitionException: Cannot construct instance of `com.example.demo.user.domain.UserInfo` (no Creators, like default constructor, exist): cannot deserialize from Object value (no delegate- or property-based Creator)
				
				
				UserInfo에다가  어노테이션을 달아주었다.
				  @ConstructorProperties({"userId", "userPwd", "auth"})
				
				*/
				System.out.println(tmp2);
				UserInfo tmp3 = om.readValue(tmp2,UserInfo.class);
			}
		
	}
		
	
	


}
