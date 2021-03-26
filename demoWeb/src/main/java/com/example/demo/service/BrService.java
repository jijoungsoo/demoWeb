package com.example.demo.service;

import java.util.ArrayList;
import java.util.HashMap;

import com.example.demo.cm.ctrl.MsgDebugInfo;
import com.example.demo.utils.PjtUtil;
import com.fasterxml.jackson.core.JsonProcessingException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class BrService {

	  
	  /*
	   * 캐싱처리 참고
	   * http://dveamer.github.io/backend/SpringCacheable.html
	   * 
	   * */
	
	//@Cacheable(value = "menuCache")
    public static ArrayList<HashMap<String, Object>>  BR_CM_ROLE_CD_MENU_FIND_TREE_BY_USER_NO(Authentication authentication){
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
			MsgDebugInfo msg = PjtUtil.makeLSession("BR_CM_MAIN_FIND_TREE_BY_USER_NO",jsonInString,authentication);
			String jsonOutString = GoRestService.callAPI("BR_CM_MAIN_FIND_TREE_BY_USER_NO", msg.getIN_DATA_JSON());
			outDs=PjtUtil.JsonStringToObject(jsonOutString, HashMap.class);
			OUT_DATA= outDs.get("OUT_DATA");
		} catch (JsonProcessingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return OUT_DATA; 
    }
	
	//@Cacheable(value = "pgmCache")
    public static ArrayList<HashMap<String, Object>>  findMainPgm(){
		HashMap<String,ArrayList<HashMap<String,Object>>> outDs = new HashMap<String,ArrayList<HashMap<String,Object>>>();
		try {
			HashMap<String,Object> IN_DS = new HashMap<String,Object>();
			IN_DS.put("brRq","");
			IN_DS.put("brRs","OUT_DATA");

			String jsonInString=PjtUtil.ObjectToJsonString(IN_DS);
			String jsonOutString = GoRestService.callAPI("BR_CM_MAIN_PGM_FIND", jsonInString);
			outDs=PjtUtil.JsonStringToObject(jsonOutString, HashMap.class);
		} catch (JsonProcessingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		ArrayList<HashMap<String,Object>> OUT_DATA= outDs.get("OUT_DATA");
		return OUT_DATA; 
    }

    public static HashMap<String, Object> findPgmList(String PGM_ID){
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
            String jsonOutString = GoRestService.callAPI("BR_CM_MAIN_PGM_FIND_BY_PGM_ID", jsonInString);
            outDs=PjtUtil.JsonStringToObject(jsonOutString, HashMap.class);
        } catch (JsonProcessingException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        HashMap<String, Object> pgmLink =new HashMap<String, Object>();
        ArrayList<HashMap<String,Object>> OUT_DATA= outDs.get("OUT_DATA");
		if(OUT_DATA.size()>0){
			return OUT_DATA.get(0); 
		}
		return null;
        
    }


	  

		//@Cacheable(value = "menuCache")
		public static ArrayList<HashMap<String, Object>>  BR_CM_LOGIN_SNS(HashMap<String,Object>  IN_DATA_ROW){
			HashMap<String,ArrayList<HashMap<String,Object>>> outDs = new HashMap<String,ArrayList<HashMap<String,Object>>>();
			ArrayList<HashMap<String,Object>> OUT_DATA = new ArrayList<HashMap<String,Object>>(); 
			try {
				/*
				 * JsonInString
				 * IN_DS는 필수이므로 설정해줘야한다.
				 * */
	
				HashMap<String,Object> IN_DS = new HashMap<String,Object>();
				IN_DS.put("brRq","IN_DATA");
				IN_DS.put("brRs","OUT_DATA");
				
				ArrayList<HashMap<String,Object>> al  = new ArrayList<HashMap<String,Object>>();
				al.add(IN_DATA_ROW);
				IN_DS.put("IN_DATA",al);
				
				String jsonInString=PjtUtil.ObjectToJsonString(IN_DS);
				String jsonOutString = GoRestService.callAPI("BR_CM_LOGIN_SNS",jsonInString);
				outDs=PjtUtil.JsonStringToObject(jsonOutString, HashMap.class);
				OUT_DATA= outDs.get("OUT_DATA");
			} catch (JsonProcessingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			return OUT_DATA; 
		}

}
