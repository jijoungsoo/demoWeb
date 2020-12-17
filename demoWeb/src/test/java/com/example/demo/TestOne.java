package com.example.demo;


import org.junit.jupiter.api.Test; 
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.web.servlet.MockMvc;

import com.example.demo.cm.utils.PjtUtil;

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
