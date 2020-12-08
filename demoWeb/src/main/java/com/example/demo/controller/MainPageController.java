package com.example.demo.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
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
	
	@GetMapping("/")
    public String main(HttpSession session , Model model){
		model.addAttribute("cmMenuList", mps.findMainMenu());
		model.addAttribute("cmPgmList", mps.findMainPgm());
		return "index"; 
    }
	
	@PostMapping(path= "/page/{pageId}")
	public String page(@PathVariable("pageId") String pageId
			, @RequestBody Map<String,String> hm
			, Model model
			){
		
		//pageId를 가지고 하는 것도 문제가 있다.
		//pageId를 가지고 PgmLink를 가져오도록 해야한다.
		//login 페이지 가져올때 pgmList를 가져오니가 그걸 cache에 넣자.
		System.out.println(pageId);
		System.out.println(hm.get("uuid"));
		
		HashMap<String, String> cmPgmLink=findPgmList();
		String pgmLink = cmPgmLink.get(pageId);
		model.addAttribute("pgmId", pageId);
		model.addAttribute("uuid", hm.get("uuid").toString());
		return pgmLink; 
    }
	
	
	
	//@CachePut(value = "pgmLinkCache", key = "T(com.dveamer.sample.KeyGen).generate(#pgmId)")
	@CachePut(value = "pgmLinkCache")
	private HashMap<String, String> findPgmList(){
		HashMap<String, String> pgmLink =new HashMap<String, String>();
		
		ArrayList<HashMap<String, Object>> cmPgmList=mps.findMainPgm();
		for(int i=0;i<cmPgmList.size();i++) {
			HashMap<String, Object> tmp =cmPgmList.get(i);
			pgmLink.put(tmp.get("pgmId").toString(), tmp.get("pgmLink").toString());
		}
		return pgmLink;
	}
}
