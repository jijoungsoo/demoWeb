package com.example.demo;


import org.junit.jupiter.api.Test; 
import org.springframework.beans.factory.annotation.Autowired; 
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType; 
import org.springframework.test.annotation.Rollback;
import org.springframework.test.web.servlet.MockMvc; 
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print; 
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
@SpringBootTest(properties = "classpath:/application.yml"
,webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT
)  /*https://velog.io/@hellozin/Spring-Boot-Test에서-Yaml-프로퍼티-적용하기*/

@AutoConfigureMockMvc
@Rollback(false)  /*롤백하지 않게 하자. */
class DemoApplicationTests {

	@Autowired 
	MockMvc mvc;
	
	@Test
	void contextLoads() throws Exception {
		
		//출처: https://engkimbs.tistory.com/770 [새로비]
				String userJson = "{\"userId\":\"admin\", \"userPwd\":\"admin\"}";
				mvc.perform(post("/api/restTest6")
									.contentType(MediaType.APPLICATION_JSON)
									.accept(MediaType.APPLICATION_JSON)
									.content(userJson)		
						)		
				.andExpect(status().isOk()) 
				.andExpect(content().contentType(MediaType.APPLICATION_JSON)) 
				//.andExpect(jsonPath("$.id", is("goddaehee"))) 
				.andDo(print());
	}

}
