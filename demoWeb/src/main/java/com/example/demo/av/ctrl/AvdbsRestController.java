package com.example.demo.av.ctrl;

import java.util.ArrayList;
import java.util.HashMap;

import com.example.demo.utils.PjtUtil;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

@RestController
public class AvdbsRestController {

  @Autowired
  PjtUtil pjtU;

    @GetMapping(value = "/ACTOR_LIST")
    public  ResponseEntity<Object> actor_list() throws Exception {
      ArrayList<String> al_yymmdd= getActordebutYYMM();
      for(var i=0;i<al_yymmdd.size();i++){
          String yymmdd=al_yymmdd.get(i);

      }
      ArrayList<HashMap<String, Object>>  al = getActorList("210301");
      return ResponseEntity.ok(al);

    }

    
    public ArrayList<String> getActordebutYYMM(){
      HttpComponentsClientHttpRequestFactory factory = new HttpComponentsClientHttpRequestFactory();
      factory.setConnectTimeout(10000); // 타임아웃 설정 5초
      factory.setReadTimeout(10000);// 타임아웃 설정 5초
      RestTemplate restTemplate = new RestTemplate(factory);
      HttpHeaders headers = new HttpHeaders();
      headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
      String url = "https://www.avdbs.com/menu/actor_list.php";
      String set_cookie = "adult_chk=1; user_nickname=dd; member_idx= 11;";
      headers.add("Cookie", set_cookie);
      UriComponentsBuilder uriBuilder = UriComponentsBuilder.fromHttpUrl(url);
      HttpEntity<?> entity = new HttpEntity<>(headers);
      ResponseEntity<String> resultMap = restTemplate.exchange(uriBuilder.build().toString(), HttpMethod.GET,entity, String.class);
      String tmp = resultMap.getBody();
      Document doc =     Jsoup.parseBodyFragment(tmp);
      Elements els =     doc.getElementsByClass("selectbox for_pc").select("option");
      ArrayList<String> al = new ArrayList<String>();
      for(Element el : els) {
           String yymmdd = el.attr("value");
           if(yymmdd.equals("all")==false){
               al.add(yymmdd);
           }
       }
       return al;
   }

   public ArrayList<HashMap<String, Object>>  getActorList(String YYMMDD){
       //https://www.avdbs.com/menu/actor_list.php
        HttpComponentsClientHttpRequestFactory factory = new HttpComponentsClientHttpRequestFactory();
        factory.setConnectTimeout(10000); // 타임아웃 설정 5초
        factory.setReadTimeout(10000);// 타임아웃 설정 5초
        RestTemplate restTemplate = new RestTemplate(factory);
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
        String url = "https://www.avdbs.com/menu/actor_list.php?ymd="+YYMMDD+"&_page=1&_pjax=%23container";
 
        String set_cookie = "adult_chk=1; user_nickname=dd; member_idx= 11;";
        headers.add("Cookie", set_cookie);
        UriComponentsBuilder uriBuilder = UriComponentsBuilder.fromHttpUrl(url);
        headers.add("x-pjax", "true");
    headers.add("x-requested-with", "XMLHttpRequest");
 
        HttpEntity<?> entity = new HttpEntity<>(headers);
        ResponseEntity<String> resultMap = restTemplate.exchange(uriBuilder.build().toString(), HttpMethod.GET,entity, String.class);
        String tmp = resultMap.getBody();
        Document doc = Jsoup.parseBodyFragment(tmp);
        Elements lst =     doc.getElementsByClass("lst").select("li");
 
        ArrayList<HashMap<String, Object>>  actor_lst = new ArrayList<HashMap<String, Object>>();
        int page_size = lst.size();
        for(Element p : lst) {
            HashMap<String, Object>  actor = new HashMap<String, Object>();
            String actor_idx = p.attr("data-idx");
            String k_name = p.select(".k_name").text();
            String e_name  = p.select(".e_name").text();
            String open_dt  = p.select(".highlight").text();
            open_dt=open_dt.replaceAll("데뷔","");
            open_dt=open_dt.replaceAll("-","");
            open_dt=open_dt.trim();
            String prf_Img = p.getElementsByClass("photo").select("img").attr("src");
            
            actor.put("ACTOR_IDX", actor_idx);
            actor.put("K_NAME", k_name);
            actor.put("E_NAME", e_name);
            actor.put("OPEN_DT", "20"+open_dt);
            actor.put("PRF_IMG", prf_Img);
            actor_lst.add(actor);
        }
        String tot_cnt =     doc.getElementsByClass("page_navi").select(".cnt").text();
        tot_cnt=tot_cnt.replaceAll("건 조회","");
        tot_cnt=tot_cnt.replaceAll(",","");
        tot_cnt=tot_cnt.trim();
        //page_count=total_cnt/page_size
        int page_count = Integer.parseInt(tot_cnt)/page_size;
        if (Integer.parseInt(tot_cnt) % page_size > 0) {
          page_count++;	// 나머지가 있다면 1을 더해줌
        }
        for(int i=2 ;i<=page_count;i++){
           System.out.println(i);
           /*페이지 호출을 해서 작품리스트를 가져오자. */
 
 
           HttpHeaders headers2 = new HttpHeaders();
           headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
           String url2 = "https://www.avdbs.com/menu/actor_list.php?ymd="+YYMMDD+"&_page="+i+"&_pjax=%23container";
           UriComponentsBuilder uriBuilder2 = UriComponentsBuilder.fromHttpUrl(url2);
           headers2.add("x-pjax", "true");
           headers2.add("x-requested-with", "XMLHttpRequest");
    
           HttpEntity<?> entity2 = new HttpEntity<>(headers2);
           ResponseEntity<String> resultMap2 = restTemplate.exchange(uriBuilder2.build().toString(), HttpMethod.GET,entity2, String.class);
           String tmp2 = resultMap2.getBody();
           Document doc2 = Jsoup.parseBodyFragment(tmp2);
 
           Elements lst2 =     doc2.getElementsByClass("lst").select("li");
           System.out.println(lst2.size());
           for(Element p : lst2) {
               HashMap<String, Object>  actor = new HashMap<String, Object>();
               String actor_idx = p.attr("data-idx");
               String k_name = p.select(".k_name").text();
               String e_name  = p.select(".e_name").text();
               String open_dt  = p.select(".highlight").text();
               open_dt=open_dt.replaceAll("데뷔","");
               open_dt=open_dt.replaceAll("-","");
               open_dt=open_dt.trim();
               String prf_Img = p.getElementsByClass("photo").select("img").attr("src");
               
               actor.put("ACTOR_IDX", actor_idx);
               actor.put("K_NAME", k_name);
               actor.put("E_NAME", e_name);
               actor.put("OPEN_DT", "20"+open_dt);
               actor.put("PRF_IMG", prf_Img);
               actor_lst.add(actor);
           }            
       }
     return actor_lst;
   }

    
    @GetMapping(value = "/ACTOR/{ACTOR_IDX}")
    public  ResponseEntity<Object> actor(@PathVariable("ACTOR_IDX") String ACTOR_IDX) throws Exception {
        //   https://www.avdbs.com/menu/actor.php?actor_idx=6830
        HashMap<String, Object> result = new HashMap<String, Object>();
       HttpComponentsClientHttpRequestFactory factory = new HttpComponentsClientHttpRequestFactory();
       factory.setConnectTimeout(10000); // 타임아웃 설정 5초
       factory.setReadTimeout(10000);// 타임아웃 설정 5초
       RestTemplate restTemplate = new RestTemplate(factory);

       HttpHeaders headers = new HttpHeaders();
       headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
       String url = "https://www.avdbs.com/menu/actor.php?actor_idx="+ACTOR_IDX;
       UriComponentsBuilder uriBuilder = UriComponentsBuilder.fromHttpUrl(url);

       String set_cookie = "adult_chk=1; user_nickname=dd; member_idx= 11;";
       headers.add("Cookie", set_cookie);

       HttpEntity<?> entity = new HttpEntity<>(headers);
       ResponseEntity<String> resultMap = restTemplate.exchange(uriBuilder.build().toString(), HttpMethod.GET,entity, String.class);
       //https://offbyone.tistory.com/116
       //result.put("statusCode", resultMap.getStatusCodeValue()); // http status code를 확인
       //result.put("header", resultMap.getHeaders()); // 헤더 정보 확인
       //result.put("body", resultMap.getBody()); // 실제 데이터 정보 확인
       String tmp = resultMap.getBody();
       //Document doc = Jsoup.parse(tmp);
       Document doc = Jsoup.parseBodyFragment(tmp);
       //출처: https://offbyone.tistory.com/116 [쉬고 싶은 개발자]
       String prf_img  = doc.getElementsByClass("profile_img_view").attr("src");
       String inner_name_kr  = doc.getElementsByClass("inner_name_kr").text();
       String inner_name_en  = doc.getElementsByClass("inner_name_en").text();
       String inner_name_cn  = doc.getElementsByClass("inner_name_cn").text();
       String profile_birth  = doc.getElementsByClass("profile_birth").text();
       String profile_height  = doc.getElementsByClass("profile_height").text();
       String profile_size    = doc.getElementsByClass("profile_size").text();
       String profile_bra_size    = doc.getElementsByClass("profile_bra_size").text();
       String actor_onm    = doc.getElementsByClass("actor_onm").text();
       Elements other_photo_list =     doc.getElementsByClass("other_photo_list").select("img");
       Elements photo_boxs =     doc.getElementsByClass("photo_box");
       String  actor_dscr_title =     doc.getElementsByClass("actor-dscr").select(".title").text();
       String  actor_dscr_dscr =     doc.getElementsByClass("actor-dscr").select(".dscr").text();


       

       result.put("PRF_IMG", prf_img);  //프로필 이미지
       result.put("INNER_NAME_KR", inner_name_kr);  //한국어이름
       result.put("INNER_NAME_EN", inner_name_en);  //영어
       result.put("INNER_NAME_CN", inner_name_cn);  //중국어
       profile_birth=profile_birth.replaceAll("생년월일 :", "").trim();
       if(profile_birth.length()>10){
        profile_birth=profile_birth.substring(0,10);
       }
       result.put("PROFILE_BIRTH", profile_birth);  //생년월
       result.put("PROFILE_HEIGHT", profile_height.replaceAll("신장 :", "").replaceAll("cm", "").trim());  //키
       result.put("PROFILE_SIZE", profile_size.replaceAll("신체사이즈 :", "").trim());       //사이즈
       result.put("PROFILE_BRA_SIZE", profile_bra_size.replaceAll("컵사이즈 :", "").replaceAll("컵", "").trim());   //가슴 사이즈
       result.put("ACTOR_ONM", actor_onm);   //다른이름
       result.put("ACTOR_DSCR_TITLE", actor_dscr_title);   //다른이름
       result.put("ACTOR_DSCR_DSCR", actor_dscr_dscr);   //다른이름
       //다른 사진
       ArrayList<String> arr_img = new ArrayList<String>();
       for(Element img : other_photo_list) {
           arr_img.add(img.attr("src"));            
       }
       result.put("OTHER_PHOTO", arr_img);
       ArrayList<HashMap<String, Object>> best_dvd = new ArrayList<HashMap<String, Object>>();
       for(Element photo_box : photo_boxs) {
           HashMap<String, Object>  best = new HashMap<String, Object>();
           String href = photo_box.select("a").attr("href");
           String dvd_idx=href.replaceAll("/menu/dvd.php\\?dvd_idx=","");
           best.put("DVD_IDX", dvd_idx.trim());
           best_dvd.add(best);
       }
       result.put("BEST_DVD", best_dvd);

       /*
       해더에 
       x-pjax : true
       x-requested-with : XMLHttpRequest
       이걸 주면 부분적으로 넘어옴

       첫페이지는 그냥 읽고 
       마지막 페이지를 찾아서 그 후로는 
       리퀘스트를 보내 이 배우 작품들을 찾아서 뿌려준다.
       chrome-extension://coohjcphdfgbiolnekdpbcijmhambjff/index.html
       확장 프로그램 찾아서 확인했다.
       */

       //118건 
       //10개 
       //page_navi shw-800-over
       Elements lst =     doc.getElementsByClass("album_vw").select("ul.lst").select("li");
       int page_size = lst.size();

       String tot_cnt =     doc.getElementsByClass("page_navi shw-800-over").select(".cnt").text();
       tot_cnt=tot_cnt.replaceAll("건 조회","");
       tot_cnt=tot_cnt.replaceAll(",","");
       tot_cnt=tot_cnt.trim();

       int page_count = Integer.parseInt(tot_cnt)/page_size;
        if (Integer.parseInt(tot_cnt) % page_size > 0) {
          page_count++;	// 나머지가 있다면 1을 더해줌
        }
      
      ArrayList<HashMap<String, Object>> dvd_info = new ArrayList<HashMap<String, Object>>();
      for(Element p : lst) {
          String dvd_idx  = p.select(".photo").select(".detail").attr("href");
          HashMap<String, Object>  dvd = new HashMap<String, Object>();
          dvd_idx=dvd_idx.replaceAll("/menu/dvd.php\\?dvd_idx=","");

          dvd.put("DVD_IDX", dvd_idx);
          dvd_info.add(dvd);
      }
      for(int i=2 ;i<=page_count;i++){
          System.out.println(i);
          /*페이지 호출을 해서 작품리스트를 가져오자. */

          Thread.sleep(1000);


          HttpHeaders headers2 = new HttpHeaders();
          headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
          String url2 = "https://www.avdbs.com/menu/actor.php?actor_idx="+ACTOR_IDX+"&_page="+i;
          UriComponentsBuilder uriBuilder2 = UriComponentsBuilder.fromHttpUrl(url2);
          headers2.add("x-pjax", "true");
          headers2.add("x-requested-with", "XMLHttpRequest");
  
          HttpEntity<?> entity2 = new HttpEntity<>(headers2);
          ResponseEntity<String> resultMap2 = restTemplate.exchange(uriBuilder2.build().toString(), HttpMethod.GET,entity2, String.class);
          String tmp2 = resultMap2.getBody();
          Document doc2 = Jsoup.parseBodyFragment(tmp2);

          Elements albums_li2 =     doc2.getElementsByClass("album_vw").select("ul.lst").select("li");
          System.out.println(albums_li2.size());
          for(Element p : albums_li2) {
            String dvd_idx  = p.select(".photo").select(".detail").attr("href");
            HashMap<String, Object>  dvd = new HashMap<String, Object>();
            dvd_idx=dvd_idx.replaceAll("/menu/dvd.php\\?dvd_idx=","");
            dvd.put("DVD_IDX", dvd_idx);            
            dvd_info.add(dvd);
        }
      }
      result.put("DVD_INFO", dvd_info);
        
        
        //출처: https://offbyone.tistory.com/116 [쉬고 싶은 개발자]
        return ResponseEntity.ok(result);
    }



    @GetMapping(value = "/DVD/{DVD_IDX}")
    public  ResponseEntity<Object> dvd(@PathVariable("DVD_IDX") String DVD_IDX) throws Exception {
                  //쿠키에서
      //adult_chk=1 로 넣으면 성인인증한것처럼 나온다.
      //user_nickname=ddd   로 넣으면 로그인 한것 처럼나온다.
      //member_idx=111      의미 없어보이지만 회원시퀀스로 보여진다.

      //성인인증을 해야 모자이크 없는 이미지가 보인다.
      //

       //   https://www.avdbs.com/menu/dvd.php?dvd_idx=788417
       HashMap<String, Object> result = new HashMap<String, Object>();
       HttpComponentsClientHttpRequestFactory factory = new HttpComponentsClientHttpRequestFactory();
       factory.setConnectTimeout(10000); // 타임아웃 설정 5초
       factory.setReadTimeout(10000);// 타임아웃 설정 5초
       RestTemplate restTemplate = new RestTemplate(factory);

       String dvd_idx = DVD_IDX;

       HttpHeaders headers = new HttpHeaders();
       headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
       String url = "https://www.avdbs.com/menu/dvd.php?dvd_idx="+dvd_idx;
       UriComponentsBuilder uriBuilder = UriComponentsBuilder.fromHttpUrl(url);

       String set_cookie = "adult_chk=1; user_nickname=dd; member_idx= 11;";
       headers.add("Cookie", set_cookie);

       HttpEntity<?> entity = new HttpEntity<>(headers);
       ResponseEntity<String> resultMap = restTemplate.exchange(uriBuilder.build().toString(), HttpMethod.GET,entity, String.class);
       String tmp = resultMap.getBody();
       Document doc = Jsoup.parseBodyFragment(tmp);
       String mv_nm =  doc.getElementsByClass("profile_view_top").select(".tomato").text(); //작품번호
       String title  = doc.getElementsByClass("profile_view_top").select(".title").text();  //타이틀
       String dvd_img_src  = doc.getElementById("dvd_img_src").attr("src");  
      
       String title_kr  = doc.getElementById("title_kr").text();
       String main_actr_idx  = doc.getElementsByClass("inner_name_cn").select("a").attr("href");
       Elements profile_detail  = doc.getElementsByClass("profile_detail").select("p");

       result.put("MV_NM", mv_nm);  //품번
       result.put("TITLE", title);  //타이틀
       result.put("DVD_IMG_SRC", dvd_img_src);  //이미지
        //모자이크 이미지가 나올지  아닐지 알수 없음.
        //일반이미지   https://s3.ap-northeast-2.amazonaws.com/img.avdbs.com/av/v0788/n_1412rebd535_a.jpg
        //작은일반이미지   https://s3.ap-northeast-2.amazonaws.com/img.avdbs.com/av/v0788/n_1412rebd535_as.jpg
        //모자이크이미지   https://s3.ap-northeast-2.amazonaws.com/img.avdbs.com/av/v0788/n_1412rebd535_n.jpg
        //작은모자이크이미지   https://s3.ap-northeast-2.amazonaws.com/img.avdbs.com/av/v0788/n_1412rebd535_ns.jpg
        result.put("TITLE_KR", title_kr);  //작품하단 설명
        result.put("MAIN_ACTR_IDX", main_actr_idx);  //메인 배우 idx
        
        ArrayList<String>  arr_actr = new ArrayList<String>();
       for(Element pf : profile_detail) {

          String tmp2 =pf.text();
          System.out.println(tmp2);
          if(tmp2.indexOf("출시")>=0){
            result.put("OPEN_DT", tmp2);  //출시일
          }
          if(tmp2.indexOf("출연")>=0){
            result.put("ACTR_NM", tmp2);  //배우
            Elements actrs =  pf.select("a");
            for(Element actr : actrs) {
              //테이블을 따로 둬서 저장하자.
              String actor_idx = actr.attr("href");
              arr_actr.add(actor_idx);
            }
          }
          if(tmp2.indexOf("제작사")>=0){
            result.put("COMP_NM", tmp2);  //제작사
          }
          if(tmp2.indexOf("레이블")>=0){
            result.put("LABLE", tmp2);  //레이블
          }
          if(tmp2.indexOf("시리즈")>=0){
            result.put("SERIES", tmp2);  //시리즈
          }
          if(tmp2.indexOf("감독")>=0){
            result.put("DIRECTOR", tmp2);  //감독
          }

          if(tmp2.indexOf("재생시간")>=0){
            result.put("RUN_TIME", tmp2);  //재생시간
          }
      }
      result.put("ACTOR_IDX", arr_actr);  //출연배우

      String story_kr  = doc.getElementById("story_kr").text();
      result.put("STORY_KR", story_kr);  //작품상세

      ArrayList<HashMap<String, Object>> arr_gen = new ArrayList<HashMap<String, Object>>();
      Elements gen_list  = doc.getElementsByClass("gen_list");
      for(Element gen : gen_list) {
        HashMap<String, Object>  gem_map = new HashMap<String, Object>();
        String menu=gen.attr("data-menu");
        String cate=gen.attr("data-cate");
        String gen_nm=gen.text();
        gem_map.put("cate",cate);
        gem_map.put("menu",menu);
        gem_map.put("gen_nm",gen_nm);
        arr_gen.add(gem_map);
      }
      result.put("GEN_LIST", arr_gen);  //장르정보
        return ResponseEntity.ok(result);        
    }

    @GetMapping(value = "/MV_CMT/{ACTOR_IDX}")
    public  ResponseEntity<Object> cmt(@PathVariable("ACTOR_IDX") String ACTOR_IDX) throws Exception {
          //https://www.avdbs.com/w2017/page/dvd/dvd_mention.php?actor_idx=2583&page=1
          HashMap<String, Object> result = new HashMap<String, Object>();
          HttpComponentsClientHttpRequestFactory factory = new HttpComponentsClientHttpRequestFactory();
          factory.setConnectTimeout(10000); // 타임아웃 설정 5초
          factory.setReadTimeout(10000);// 타임아웃 설정 5초
          RestTemplate restTemplate = new RestTemplate(factory);
          
          //5195
          String actor_idx = ACTOR_IDX;

          HttpHeaders headers = new HttpHeaders();
          headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
          String url = "https://www.avdbs.com/w2017/page/dvd/dvd_mention.php?actor_idx="+actor_idx;
          String set_cookie = "adult_chk=1; user_nickname=dd; member_idx= 11;";
          headers.add("Cookie", set_cookie);
          UriComponentsBuilder uriBuilder = UriComponentsBuilder.fromHttpUrl(url);

          HttpEntity<?> entity = new HttpEntity<>(headers);
          ResponseEntity<String> resultMap = restTemplate.exchange(uriBuilder.build().toString(), HttpMethod.GET,entity, String.class);
          String tmp = resultMap.getBody();
          Document doc = Jsoup.parseBodyFragment(tmp);
          ArrayList<HashMap<String, Object>> cmt_info = new ArrayList<HashMap<String, Object>>();
          Elements rows =     doc.getElementsByClass("row");
          for(Element r : rows) {
              HashMap<String, Object>  cmt = new HashMap<String, Object>();
              String cmt_idx=r.attr("data-idx");
              if(pjtU.isEmpty(cmt_idx)==false) {
                String cmt_dvd_idx =r.getElementsByClass("comment").select("a").attr("href");
                String cmt_txt =r.getElementsByClass("comment").text();
                String writer =r.getElementsByClass("writer").text();
                String blue_cnt =r.getElementsByClass("blue").text();
                String red_cnt =r.getElementsByClass("red").text();
  
                cmt.put("PAGE", 1);
                cmt.put("ACTOR_IDX", ACTOR_IDX);
                cmt.put("CMT_IDX", cmt_idx);
                cmt.put("CMT_DVD_IDX", cmt_dvd_idx);
                cmt.put("CMT_TXT", cmt_txt);
                cmt.put("WRITER", writer);
                cmt.put("BLUE_CNT", blue_cnt);
                cmt.put("RED_CNT", red_cnt);
                cmt_info.add(cmt);
              }
            
          }
          Elements last_page =     doc.getElementsByClass("page_navi shw-640-over").select("strong");
          String page_cnt = last_page.text();
          String[] arr_page_cnt = page_cnt.split("/");

          int cnt =Integer.parseInt(arr_page_cnt[arr_page_cnt.length-1].trim());
          for(int i=2;i<=cnt;i++){
            HttpHeaders headers2 = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
            String url2 = "https://www.avdbs.com/w2017/page/dvd/dvd_mention.php?actor_idx="+actor_idx+"&page="+i;
            UriComponentsBuilder uriBuilder2 = UriComponentsBuilder.fromHttpUrl(url2);
            headers2.add("x-pjax", "true");
            headers2.add("x-requested-with", "XMLHttpRequest");
            
            HttpEntity<?> entity2 = new HttpEntity<>(headers2);
            ResponseEntity<String> resultMap2 = restTemplate.exchange(uriBuilder2.build().toString(), HttpMethod.GET,entity2, String.class);
            String tmp2 = resultMap2.getBody();
            Document doc2 = Jsoup.parseBodyFragment(tmp2);
            Elements rows2 =     doc2.getElementsByClass("row");
            for(Element r : rows2) {
              HashMap<String, Object>  cmt = new HashMap<String, Object>();
              String cmt_idx=r.attr("data-idx");
              if(pjtU.isEmpty(cmt_idx)==false) {
                String cmt_dvd_idx =r.getElementsByClass("comment").select("a").attr("href");
                String cmt_txt =r.getElementsByClass("comment").text();
                String writer =r.getElementsByClass("writer").text();
                String blue_cnt =r.getElementsByClass("blue").text();
                String red_cnt =r.getElementsByClass("red").text();
  
                cmt.put("PAGE", i);
                cmt.put("ACTOR_IDX", ACTOR_IDX);
                cmt.put("CMT_IDX", cmt_idx);
                cmt.put("CMT_DVD_IDX", cmt_dvd_idx);
                cmt.put("CMT_TXT", cmt_txt);
                cmt.put("WRITER", writer);
                cmt.put("BLUE_CNT", blue_cnt);
                cmt.put("RED_CNT", red_cnt);
                cmt_info.add(cmt);
              }
            
            }
          }
          result.put("CMT_INFO",cmt_info);

          return ResponseEntity.ok(result);
    }

    @GetMapping(value = "/ACTR_CMT/{ACTOR_IDX}")
    public  ResponseEntity<Object> actr_cmt(@PathVariable("ACTOR_IDX") String ACTOR_IDX) throws Exception {
          //https://www.avdbs.com/w2017/page/dvd/dvd_mention.php?actor_idx=2583&page=1
          HashMap<String, Object> result = new HashMap<String, Object>();
          HttpComponentsClientHttpRequestFactory factory = new HttpComponentsClientHttpRequestFactory();
          factory.setConnectTimeout(10000); // 타임아웃 설정 5초
          factory.setReadTimeout(10000);// 타임아웃 설정 5초
          RestTemplate restTemplate = new RestTemplate(factory);
          
          //5195
          String actor_idx = ACTOR_IDX;

          HttpHeaders headers = new HttpHeaders();
          headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
          String url = "https://www.avdbs.com/w2017/page/actor/actor_mention.php?actor_idx="+actor_idx;
          String set_cookie = "adult_chk=1; user_nickname=dd; member_idx= 11;";
          headers.add("Cookie", set_cookie);
          UriComponentsBuilder uriBuilder = UriComponentsBuilder.fromHttpUrl(url);

          HttpEntity<?> entity = new HttpEntity<>(headers);
          ResponseEntity<String> resultMap = restTemplate.exchange(uriBuilder.build().toString(), HttpMethod.GET,entity, String.class);
          String tmp = resultMap.getBody();
          Document doc = Jsoup.parseBodyFragment(tmp);
          ArrayList<HashMap<String, Object>> cmt_info = new ArrayList<HashMap<String, Object>>();
          Elements rows =     doc.getElementsByClass("row");
          for(Element r : rows) {
              HashMap<String, Object>  cmt = new HashMap<String, Object>();
              String cmt_idx=r.attr("data-idx");
              if(pjtU.isEmpty(cmt_idx)==false) {
                String cmt_txt =r.getElementsByClass("comment").text();
                String writer =r.getElementsByClass("writer").text();
                String blue_cnt =r.getElementsByClass("blue").text();
                String red_cnt =r.getElementsByClass("red").text();
  
                cmt.put("PAGE", 1);
                cmt.put("ACTOR_IDX", ACTOR_IDX);
                cmt.put("CMT_IDX", cmt_idx);
                cmt.put("CMT_TXT", cmt_txt);
                cmt.put("WRITER", writer);
                cmt.put("BLUE_CNT", blue_cnt);
                cmt.put("RED_CNT", red_cnt);
                cmt_info.add(cmt);
              }
            
          }
          Elements last_page =     doc.getElementsByClass("page_navi shw-640-over").select("strong");
          String page_cnt = last_page.text();
          String[] arr_page_cnt = page_cnt.split("/");

          int cnt =Integer.parseInt(arr_page_cnt[arr_page_cnt.length-1].trim());
          for(int i=2;i<=cnt;i++){
            HttpHeaders headers2 = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
            String url2 = "https://www.avdbs.com/w2017/page/actor/actor_mention.php?actor_idx="+actor_idx+"&page="+i;
            UriComponentsBuilder uriBuilder2 = UriComponentsBuilder.fromHttpUrl(url2);
            headers2.add("x-pjax", "true");
            headers2.add("x-requested-with", "XMLHttpRequest");
            
            HttpEntity<?> entity2 = new HttpEntity<>(headers2);
            ResponseEntity<String> resultMap2 = restTemplate.exchange(uriBuilder2.build().toString(), HttpMethod.GET,entity2, String.class);
            String tmp2 = resultMap2.getBody();
            Document doc2 = Jsoup.parseBodyFragment(tmp2);
            Elements rows2 =     doc2.getElementsByClass("row");
            for(Element r : rows2) {
              HashMap<String, Object>  cmt = new HashMap<String, Object>();
              String cmt_idx=r.attr("data-idx");
              if(pjtU.isEmpty(cmt_idx)==false) {
                String cmt_txt =r.getElementsByClass("comment").text();
                String writer =r.getElementsByClass("writer").text();
                String blue_cnt =r.getElementsByClass("cnt blue").text();
                String red_cnt =r.getElementsByClass("cnt red").text();
  
                cmt.put("PAGE", i);
                cmt.put("ACTOR_IDX", ACTOR_IDX);
                cmt.put("CMT_IDX", cmt_idx);
                cmt.put("CMT_TXT", cmt_txt);
                cmt.put("WRITER", writer);
                cmt.put("BLUE_CNT", blue_cnt);
                cmt.put("RED_CNT", red_cnt);
                cmt_info.add(cmt);
              }
            }
          }
          result.put("CMT_INFO",cmt_info);

          return ResponseEntity.ok(result);
    }
}
