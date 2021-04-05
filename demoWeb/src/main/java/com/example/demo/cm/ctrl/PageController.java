package com.example.demo.cm.ctrl;

import java.io.File;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;

import javax.servlet.http.HttpServletRequest;

import com.example.demo.service.BrService;

import org.springframework.beans.factory.annotation.Autowired;
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
			
	@PostMapping(path= "/page/{pageId}")
	public String pagePost(@PathVariable("pageId") String pageId
			, @RequestBody Map<String,String> hm
			, Model model
			, HttpServletRequest request
			){
	    String uuid ="";
		String parentUuid ="ROOT";
	    if(hm.get("uuid")!=null) {
	        uuid = hm.get("uuid").toString();
	    }
		if(hm.get("parent_uuid")!=null) {
	        parentUuid = hm.get("parent_uuid").toString();
	    }
		
		//pageId를 가지고 하는 것도 문제가 있다.
		//pageId를 가지고 PgmLink를 가져오도록 해야한다.
		//login 페이지 가져올때 pgmList를 가져오니가 그걸 cache에 넣자.
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

		
		//====>C:\Users\jijsx\git\demoWeb\demoWeb\src\main\webapp\
		//====>/WEB-INF/jsp/${dirLink}/${pgmLink}.ui.jsp
		String filePath =  "/WEB-INF/jsp/"+dirLink+"/"+pgmLink+".ui.jsp";
		String filePullPath =	request.getSession().getServletContext().getRealPath(filePath);
		String oFilePullPath = filePullPath.replaceAll("/", Matcher.quoteReplacement(File.separator));
		String reverseSlashPath  = oFilePullPath.replaceAll(Matcher.quoteReplacement(File.separator), "/");
		System.out.println(filePullPath);
		System.out.println(reverseSlashPath);

		File f = new File(reverseSlashPath);
		if(f.isFile()) {
			System.out.println("[파일 존재]"+reverseSlashPath);
		} else {
			System.out.println("[파일 없음]"+reverseSlashPath);     

			model.addAttribute("parentUuid", parentUuid);
			model.addAttribute("pgmId", pageId);
			model.addAttribute("uuid", hm.get("uuid").toString());
			model.addAttribute("result", "no-file-"+dirLink+"/"+pgmLink+".ui.jsp");
			return  "pageRouter"; 
		}

		filePath =  "/WEB-INF/jsp/"+dirLink+"/"+pgmLink+".jsp";
		filePullPath =	request.getSession().getServletContext().getRealPath(filePath);
		oFilePullPath = filePullPath.replaceAll("/", Matcher.quoteReplacement(File.separator));
		reverseSlashPath  = oFilePullPath.replaceAll(Matcher.quoteReplacement(File.separator), "/");
		System.out.println(reverseSlashPath);

		f = new File(reverseSlashPath);
		if(f.isFile()) {
			System.out.println("[파일 존재]"+reverseSlashPath);
		} else {
			System.out.println("[파일 없음]"+reverseSlashPath);            

			model.addAttribute("parentUuid", parentUuid);
			model.addAttribute("pgmId", pageId);
			model.addAttribute("uuid", hm.get("uuid").toString());
			model.addAttribute("result", "no-file-"+dirLink+"/"+pgmLink+".jsp");
			return  "pageRouter"; 
		}

		

		
		model.addAttribute("parentUuid", parentUuid);
		model.addAttribute("pgmId", pageId);
		model.addAttribute("dirLink", dirLink);
        model.addAttribute("pgmLink", pgmLink);
		model.addAttribute("uuid", hm.get("uuid").toString());
		model.addAttribute("result", "ok");
		model.addAttribute("debug", debug);
        model.addAttribute("req_hm", hm);
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
