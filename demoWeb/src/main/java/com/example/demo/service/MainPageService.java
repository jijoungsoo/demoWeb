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

import com.example.demo.cm.utils.PjtUtil;
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
	
	@Cacheable(value = "menuCache")
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
			IN_DS.put("brRs","OUT_DATA,OUT_CHILD_DATA");
			String jsonInString=PjtUtil.ObjectToJsonString(IN_DS);
			String jsonOutString = goRestS.callAPI("findMainMenu", jsonInString);
			outDs=PjtUtil.JsonStringToObject(jsonOutString, HashMap.class);
			
			OUT_DATA= outDs.get("OUT_DATA");
			ArrayList<HashMap<String,Object>> OUT_CHILD_DATA= outDs.get("OUT_CHILD_DATA");
			log.info("OUT_DATA.size()=>"+OUT_DATA.size());
			log.info("OUT_CHILD_DATA.size()=>"+OUT_CHILD_DATA.size());
			
			for(int i=0;i<OUT_DATA.size();i++) {
				HashMap<String,Object> OUT_DATA_ROW = OUT_DATA.get(i);
				ArrayList<HashMap<String,Object>> childAl = new ArrayList<HashMap<String,Object>>(); 
				OUT_DATA_ROW.put("child", childAl);
				for(int j=0;j<OUT_CHILD_DATA.size();j++) {
					HashMap<String,Object> OUT_CHILD_DATA_ROW  = OUT_CHILD_DATA.get(j);
					String prnt_menu_cd =OUT_CHILD_DATA.get(j).get("prnt_menu_cd").toString();
					String menu_cd = OUT_DATA_ROW.get("menu_cd").toString();
					if(prnt_menu_cd.equals(menu_cd)) {
						childAl.add(OUT_CHILD_DATA_ROW);
					}
				}
			}
		} catch (BizException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (JsonProcessingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return OUT_DATA; 
    }
	
	@Cacheable(value = "pgmCache")
    public ArrayList<HashMap<String, Object>>  findMainPgm(){
		HashMap<String,ArrayList<HashMap<String,Object>>> outDs = new HashMap<String,ArrayList<HashMap<String,Object>>>();
		try {
			HashMap<String,Object> IN_DS = new HashMap<String,Object>();
			IN_DS.put("brRq","");
			IN_DS.put("brRs","OUT_DATA,OUT_CHILD_DATA");

			String jsonInString=PjtUtil.ObjectToJsonString(IN_DS);
			String jsonOutString = goRestS.callAPI("findMainPgm", jsonInString);
			outDs=PjtUtil.JsonStringToObject(jsonOutString, HashMap.class);
		} catch (BizException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (JsonProcessingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		ArrayList<HashMap<String,Object>> OUT_DATA= outDs.get("OUT_DATA");
		return OUT_DATA; 
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
