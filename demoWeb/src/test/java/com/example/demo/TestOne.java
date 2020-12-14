package com.example.demo;


import org.junit.jupiter.api.Test; 
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.configurationprocessor.json.JSONObject;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType; 
import org.springframework.test.annotation.Rollback;
import org.springframework.test.web.servlet.MockMvc;

import com.example.demo.cm.utils.PjtUtil;
import com.example.demo.user.domain.UserInfo;
import com.fasterxml.jackson.core.JsonFactory;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.databind.node.ArrayNode;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print; 
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

import java.beans.ConstructorProperties;
import java.io.IOException;
import java.io.StringWriter;
import java.util.ArrayList;

public class TestOne {

	@Autowired 
	MockMvc mvc;

	        
	        
    @Test
	void contextLoads() throws Exception {
    	String bbb="kI6fIzbTC%2FG0Uazde0EOwjudaaKeDlgiPuStDus7Fh%2BOx5H6mv58gxYCOrckxN6A%2BB2pWg%3D%3D";
		String tmp=PjtUtil.decAES256AndUrl(bbb);
		System.out.println(tmp);
		System.out.println(bbb.length());
		
		bbb="2rzMfJ0sli4cS9esAS6fL7%2BPnT%2BMzUABj8ybcq0SVpV1%2FljQkCsgF3oxjCcEprjEFUKJLw%3D%3D";
		tmp=PjtUtil.decAES256AndUrl(bbb);
		System.out.println(tmp);
		System.out.println(bbb.length());
		
		bbb="NDAxNjNlNGUtMTA4Mi00MjQwLTk2MTAtOTUzYzg5OGU4ODQz";
		System.out.println(bbb.length());
		
		
	}
}
