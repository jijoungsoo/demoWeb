package com.example.demo.cm.ctrl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.CachePut;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.example.demo.service.MainPageService;

@Controller
public class MainPageController {
	  @Autowired
	  private MainPageService mps;
	  
	@CacheEvict(value = {"pgmLinkCache","pgmCache","menuCache"})
	private String cacheRefresh() {
        return "{OK}";
    }
	
	@GetMapping("/")
    public String main(HttpSession session , Model model){
	    ArrayList<HashMap<String, Object>>  cmMenuList = mps.findMainMenu();
	    if(cmMenuList==null) {
	        cacheRefresh();
	        cmMenuList = mps.findMainMenu();
	    }
	    ArrayList<HashMap<String, Object>>  cmPgmList = mps.findMainPgm();
	    if(cmPgmList==null) {
            cacheRefresh();
            cmPgmList = mps.findMainPgm();
        }
		model.addAttribute("cmMenuList", cmMenuList);
		model.addAttribute("cmPgmList", cmPgmList);
		return "index"; 
    }
}
