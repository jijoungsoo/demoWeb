package com.example.demo.cm.ctrl;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.example.demo.service.BrService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MainPageController {
	@Autowired
	BrService brS;
	  
	   
	   @CacheEvict(value = {"pgmLinkCache","pgmCache","menuCache"},allEntries=true)
      private void cacheRefresh() {
          System.out.print("캐시삭제");
      }
	
	@GetMapping("/")
    public String main(HttpSession session , Model model,
            HttpServletRequest request, HttpServletResponse response,
			 Authentication authentication
            ){
	    String debug = request.getParameter("debug");
	    if(debug==null) {
	        session.setAttribute("debug", "N");
	    } else {
	        if(debug.equals("Y")) {
	            session.setAttribute("debug", "Y");    
	        } else {
	            session.setAttribute("debug", "N");
	        }
	        
	    }
	    //디버그 모드 항상 on
	    session.setAttribute("debug", "Y");
	    
	    ArrayList<HashMap<String, Object>>  cmMenuList = brS.BR_CM_ROLE_CD_MENU_FIND_TREE_BY_USER_NO(authentication);
	    if(cmMenuList==null) {
	        cacheRefresh();
	        cmMenuList = brS.BR_CM_ROLE_CD_MENU_FIND_TREE_BY_USER_NO(authentication);
	    }
	    ArrayList<HashMap<String, Object>>  cmPgmList = brS.findMainPgm();
	    if(cmPgmList==null) {
            cacheRefresh();
            cmPgmList = brS.findMainPgm();
        }
		model.addAttribute("cmMenuList", cmMenuList);
		model.addAttribute("cmPgmList", cmPgmList);
		return "MainPage"; 
    }
}
