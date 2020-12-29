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
public class PageController {
	@Autowired
	private MainPageService mps;
			
	@PostMapping(path= "/page/{pageId}")
	public String pagePost(@PathVariable("pageId") String pageId
			, @RequestBody Map<String,String> hm
			, Model model
			){
	    String uuid ="";
	    if(hm.get("uuid")!=null) {
	        uuid = hm.get("uuid").toString();
	    }
		
		//pageId를 가지고 하는 것도 문제가 있다.
		//pageId를 가지고 PgmLink를 가져오도록 해야한다.
		//login 페이지 가져올때 pgmList를 가져오니가 그걸 cache에 넣자.
		System.out.println(pageId);
		System.out.println(hm.get("uuid"));
		
		HashMap<String, Object> cmPgmLink=mps.findPgmList();
		HashMap<String, Object> pgmLinkMap = (HashMap<String, Object>) cmPgmLink.get(pageId);
		
		if(pgmLinkMap==null) {
            //pageRouter로 값을 전달해서 페이지 없음 화면이 나와야한다.
		  model.addAttribute("pgmId", pageId);
		  model.addAttribute("uuid", hm.get("uuid").toString());
		  model.addAttribute("result", "no-program");
		  return  "pageRouter"; 
        }
		
		model.addAttribute("pgmId", pageId);
		model.addAttribute("dirLink", pgmLinkMap.get("DIR_LINK"));
        model.addAttribute("pgmLink", pgmLinkMap.get("PGM_LINK"));
		model.addAttribute("uuid", hm.get("uuid").toString());
		model.addAttribute("result", "ok");
		return "pageRouter"; 
    }
	
	@GetMapping(path= "/page/{pageId}")
    public String pageGet(@PathVariable("pageId") String pageId
            , Model model
            ){
        String uuid ="";
   
        //pageId를 가지고 하는 것도 문제가 있다.
        //pageId를 가지고 PgmLink를 가져오도록 해야한다.
        //login 페이지 가져올때 pgmList를 가져오니가 그걸 cache에 넣자.
        System.out.println(pageId);
        
        HashMap<String, Object> cmPgmLink=mps.findPgmList();
        HashMap<String, Object> pgmLinkMap = (HashMap<String, Object>) cmPgmLink.get(pageId);
        
        if(pgmLinkMap==null) {
            //pageRouter로 값을 전달해서 페이지 없음 화면이 나와야한다.
            model.addAttribute("pgmId", pageId);
            model.addAttribute("result", "no-program");
            return  "pageRouter"; 
        }
        
        
        model.addAttribute("pgmId", pageId);
        model.addAttribute("dirLink", pgmLinkMap.get("DIR_LINK"));
        model.addAttribute("pgmLink", pgmLinkMap.get("PGM_LINK"));
        model.addAttribute("result", "ok");
        return "pageRouter"; 
    }
	
	
}
