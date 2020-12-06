package com.example.demo.service;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CachePut;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

import com.example.demo.controller.GoRestController;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class MainPageService {
	  @Autowired
	  private GoRestController goRestApi;
	  
	  /*
	   * 캐싱처리 참고
	   * http://dveamer.github.io/backend/SpringCacheable.html
	   * 
	   * */
	
	@Cacheable(value = "menuCache")
    public ArrayList<HashMap<String, Object>>  findMainMenu(){
		ArrayList<HashMap<String, Object>> cmMenuList = new ArrayList<HashMap<String,Object>>();
		String jsonMenuOutString = goRestApi.callAPI("findMainMenu", null);
		
		ObjectMapper om = new ObjectMapper();		 
		try {
			cmMenuList=om.readValue(jsonMenuOutString,ArrayList.class);
		} catch (JsonProcessingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return cmMenuList; 
    }
	
	@Cacheable(value = "pgmCache")
    public ArrayList<HashMap<String, Object>>  findMainPgm(){
		ArrayList<HashMap<String, Object>> cmPgmList = new ArrayList<HashMap<String,Object>>();
		String jsonPgmOutString = goRestApi.callAPI("findMainPgm", null);
		ObjectMapper om = new ObjectMapper();		 
		try {
			cmPgmList=om.readValue(jsonPgmOutString,ArrayList.class);
		} catch (JsonProcessingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return cmPgmList; 
    }
	@CachePut(value = "menuCache")
	public ArrayList<HashMap<String, Object>>  reFindMainMenu() {
		ArrayList<HashMap<String, Object>> cmMenuList=this.findMainMenu();
		return cmMenuList; 
	}
	
	@CachePut(value = "pgmCache")
	public ArrayList<HashMap<String, Object>>  reFindMainPgm() {
		ArrayList<HashMap<String, Object>> cmPgmList=this.findMainPgm();
		return cmPgmList; 
	}
}
