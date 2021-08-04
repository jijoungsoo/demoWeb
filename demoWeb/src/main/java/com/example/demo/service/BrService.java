package com.example.demo.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Objects;

import com.example.demo.cm.ctrl.MsgDebugInfo;
import com.example.demo.exception.BizException;
import com.example.demo.utils.PjtUtil;
import com.fasterxml.jackson.core.JsonProcessingException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;
import org.springframework.web.client.ResourceAccessException;

@Service
public class BrService {

	@Autowired
	GoRestService goS;

	@Autowired
	PjtUtil pjtU;
	  
	  /*
	   * 캐싱처리 참고
	   * http://dveamer.github.io/backend/SpringCacheable.html
	   * 
	   * */
	
	//@Cacheable(value = "menuCache")
    public  ArrayList<HashMap<String, Object>>  BR_CM_ROLE_CD_MENU_FIND_TREE_BY_USER_NO(Authentication authentication){
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
			String jsonInString=pjtU.ObjectToJsonString(IN_DS);
			MsgDebugInfo msg = pjtU.makeLSession("",jsonInString,authentication);
			String jsonOutString =null;
			try {
				jsonOutString = goS.callAPI("BR_CM_MAIN_FIND_TREE_BY_USER_NO", msg.getIN_DATA_JSON());
			} catch (ResourceAccessException | BizException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			outDs=pjtU.JsonStringToObject(jsonOutString, HashMap.class);

			/*   이거 제조합해야한다. 
			변경전 비즈니스 로직에서는   트리형태로 나타나는데
			변경후 비즈니스 로직에서는 1개의 테이블 형태로 나타난다.
			1개의 테이블형태로 받아서 기존의 트리형태로 변환시켜줘야한다.
			*/

			ArrayList<HashMap<String,Object>> al = new  ArrayList<HashMap<String,Object>>();
			ArrayList<HashMap<String,Object>> TMP_DATA = outDs.get("OUT_DATA");
			for(int i=0;i<TMP_DATA.size();i++){
				HashMap<String,Object>  c =TMP_DATA.get(i);
				if(Integer.parseInt(c.get("MENU_LVL").toString())==0){
					al.add(c);
					HashMap<String,Object> tmp = new HashMap<String,Object>();
					tmp.put("expanded", true);
					c.put("_attributes", tmp);
					this.findSubMenuRoot(TMP_DATA,c,c.get("MENU_CD").toString());
				}
			}

			OUT_DATA= al;
		} catch (JsonProcessingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return OUT_DATA; 
    }

	private void findSubMenuRoot(ArrayList<HashMap<String, Object>> al, HashMap<String, Object> c, String MENU_CD) {
		ArrayList<HashMap<String,Object>> al_sub = new  ArrayList<HashMap<String,Object>>();
		for(int i=0;i<al.size();i++){
			HashMap<String,Object>  c1 =al.get(i);
			if(Objects.toString(c1.get("PRNT_MENU_CD"),"").equals(MENU_CD)){
				al_sub.add(c1);
				HashMap<String,Object> tmp = new HashMap<String,Object>();
				tmp.put("expanded", true);
				c1.put("_attributes", tmp);
				this.findSubMenuRoot(al,c1,c1.get("MENU_CD").toString());
			}
		}
		if(al_sub.size()>0){
			c.put("_children",al_sub);
		}
	}
	
	//@Cacheable(value = "pgmCache")
    public  ArrayList<HashMap<String, Object>>  findMainPgm(){
		HashMap<String,ArrayList<HashMap<String,Object>>> outDs = new HashMap<String,ArrayList<HashMap<String,Object>>>();
		try {
			HashMap<String,Object> IN_DS = new HashMap<String,Object>();
			IN_DS.put("brRq","");
			IN_DS.put("brRs","OUT_DATA");

			String jsonInString=pjtU.ObjectToJsonString(IN_DS);
			String jsonOutString =null;
			try {
				jsonOutString = goS.callAPI("BR_CM_MAIN_PGM_FIND", jsonInString);
			} catch (ResourceAccessException | BizException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			outDs=pjtU.JsonStringToObject(jsonOutString, HashMap.class);
		} catch (JsonProcessingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		ArrayList<HashMap<String,Object>> OUT_DATA= outDs.get("OUT_DATA");
		return OUT_DATA; 
    }

    public  HashMap<String, Object> findPgmList(String PGM_ID){
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

            String jsonInString=pjtU.ObjectToJsonString(IN_DS);
            String jsonOutString =null;
			try {
				jsonOutString = goS.callAPI("BR_CM_MAIN_PGM_FIND_BY_PGM_ID", jsonInString);
			} catch (ResourceAccessException | BizException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
            outDs=pjtU.JsonStringToObject(jsonOutString, HashMap.class);
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
		public  ArrayList<HashMap<String, Object>>  BR_CM_LOGIN_SNS(HashMap<String,Object>  IN_DATA_ROW){
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
				
				String jsonInString=pjtU.ObjectToJsonString(IN_DS);
				String jsonOutString =null;
				try {
					jsonOutString = goS.callAPI("BR_CM_LOGIN_SNS",jsonInString);
				} catch (ResourceAccessException | BizException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				outDs=pjtU.JsonStringToObject(jsonOutString, HashMap.class);
				OUT_DATA= outDs.get("OUT_DATA");
			} catch (JsonProcessingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			return OUT_DATA; 
		}

}
