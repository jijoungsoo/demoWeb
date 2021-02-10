package com.example.demo.service;

import java.util.ArrayList;
import java.util.Collection;
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

import com.example.demo.utils.PjtUtil;
import com.example.demo.exception.BizException;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class MainPageService {
	  @Autowired
	  private GoRestService goRestS;
	  
	  /*
	   * 캐싱처리 참고
	   * http://dveamer.github.io/backend/SpringCacheable.html
	   * 
	   * */
	
	//@Cacheable(value = "menuCache")
    public ArrayList<HashMap<String, Object>>  findMainMenu(){
		HashMap<String,ArrayList<HashMap<String,Object>>> outDs = new HashMap<String,ArrayList<HashMap<String,Object>>>();
		ArrayList<HashMap<String,Object>> OUT_DATA = new ArrayList<HashMap<String,Object>>(); 
		try {
			/*
			 * JsonInString
			 * IN_DS는 필수이므로 설정해줘야한다.
			 * */
			
			HashMap<String,Object> IN_DS = new HashMap<String,Object>();
			IN_DS.put("brRq","");
			IN_DS.put("brRs","OUT_DATA");
			String jsonInString=PjtUtil.ObjectToJsonString(IN_DS);
			String jsonOutString = goRestS.callAPI("BR_CM_MAIN_FIND_TREE", jsonInString);
			outDs=PjtUtil.JsonStringToObject(jsonOutString, HashMap.class);
			OUT_DATA= outDs.get("OUT_DATA");
		} catch (JsonProcessingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return OUT_DATA; 
    }
	
	//@Cacheable(value = "pgmCache")
    public ArrayList<HashMap<String, Object>>  findMainPgm(){
		HashMap<String,ArrayList<HashMap<String,Object>>> outDs = new HashMap<String,ArrayList<HashMap<String,Object>>>();
		try {
			HashMap<String,Object> IN_DS = new HashMap<String,Object>();
			IN_DS.put("brRq","");
			IN_DS.put("brRs","OUT_DATA");

			String jsonInString=PjtUtil.ObjectToJsonString(IN_DS);
			String jsonOutString = goRestS.callAPI("BR_CM_MAIN_PGM_FIND", jsonInString);
			outDs=PjtUtil.JsonStringToObject(jsonOutString, HashMap.class);
		} catch (JsonProcessingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		ArrayList<HashMap<String,Object>> OUT_DATA= outDs.get("OUT_DATA");
		return OUT_DATA; 
    }

    public HashMap<String, Object> findPgmList(String PGM_ID){
        HashMap<String,ArrayList<HashMap<String,Object>>> outDs = new HashMap<String,ArrayList<HashMap<String,Object>>>();
        try {
            HashMap<String,Object> IN_DS = new HashMap<String,Object>();
            IN_DS.put("brRq","IN_DATA");
            IN_DS.put("brRs","OUT_DATA");
            
            ArrayList<HashMap<String,Object>> al  = new ArrayList<HashMap<String,Object>>();
            HashMap<String,Object> IN_DATA_ROW = new HashMap<String,Object>();
            IN_DATA_ROW.put("PGM_ID", PGM_ID);
            al.add(IN_DATA_ROW);
            IN_DS.put("IN_DATA",al);

            String jsonInString=PjtUtil.ObjectToJsonString(IN_DS);
            String jsonOutString = goRestS.callAPI("BR_CM_MAIN_PGM_FIND_BY_PGM_ID", jsonInString);
            outDs=PjtUtil.JsonStringToObject(jsonOutString, HashMap.class);
        } catch (JsonProcessingException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        HashMap<String, Object> pgmLink =new HashMap<String, Object>();
        ArrayList<HashMap<String,Object>> OUT_DATA= outDs.get("OUT_DATA");
        return OUT_DATA.get(0); 
    }
}
