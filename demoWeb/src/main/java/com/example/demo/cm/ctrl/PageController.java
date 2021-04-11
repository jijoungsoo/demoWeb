package com.example.demo.cm.ctrl;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.example.demo.service.BrService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@Controller
public class PageController {
	@Autowired
	BrService brS;

	@Autowired
	ResourceLoader resourceLoader;  
			
	@PostMapping(path= "/page/{pageId}")
	public String pagePost(@PathVariable("pageId") String pageId
			, @RequestBody Map<String,String> hm
			, Model model
			, HttpServletRequest request
			){
		long start = System.currentTimeMillis();
	    String uuid ="";
		String parentUuid ="ROOT";
	    if(hm.get("uuid")!=null) {
	        uuid = hm.get("uuid").toString();
	    }
		if(hm.get("parent_uuid")!=null) {
	        parentUuid = hm.get("parent_uuid").toString();
	    }

		String debug = hm.get("debug");
		HashMap<String, Object> pgmLinkMap = brS.findPgmList(pageId);
		
		if(pgmLinkMap==null) {
            //pageRouter로 값을 전달해서 페이지 없음 화면이 나와야한다.
		  model.addAttribute("parentUuid", parentUuid);
		  model.addAttribute("pgmId", pageId);
		  model.addAttribute("uuid", hm.get("uuid").toString());
		  model.addAttribute("result", "no-program-"+pageId);
		  return  "pageRouter"; 
        }

		String dirLink =pgmLinkMap.get("DIR_LINK").toString();
		String pgmLink =pgmLinkMap.get("PGM_LINK").toString();

		String filePath =  "classpath:/templates/"+dirLink+"/"+pgmLink+".ui.html";
		Resource resource = resourceLoader.getResource(filePath);
		
		if(!resource.exists()) {
			System.out.println("[파일 없음]"+filePath);     
			model.addAttribute("parentUuid", parentUuid);
			model.addAttribute("pgmId", pageId);
			model.addAttribute("uuid", hm.get("uuid").toString());
			model.addAttribute("result", "no-file-"+dirLink+"/"+pgmLink+".ui.html");
			return  "pageRouter"; 
		} else {
			System.out.println("[파일 존재]"+filePath);
		}
		
		model.addAttribute("parentUuid", parentUuid);
		model.addAttribute("pgmId", pageId);
		model.addAttribute("dirLink", dirLink);
        model.addAttribute("pgmLink", pgmLink);
		model.addAttribute("uuid", hm.get("uuid").toString());
		model.addAttribute("result", "ok");
		model.addAttribute("debug", debug);
        model.addAttribute("req_hm", hm);
		long end = System.currentTimeMillis();
		System.out.println("start=>"+start);
		System.out.println("end=>"+end);
		System.out.println("걸린시간=>"+((end-start)/1000));

		
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
        HashMap<String, Object> pgmLinkMap = brS.findPgmList(pageId);
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
