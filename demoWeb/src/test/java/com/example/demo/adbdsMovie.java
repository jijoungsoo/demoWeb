package com.example.demo;

import java.util.ArrayList;
import java.util.HashMap;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.junit.jupiter.api.Test;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class adbdsMovie {

    @Test
    public void testMv(){
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

       int dvd_idx = 788417;

     
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
            
            Elements actrs =  pf.select("a");
            for(Element actr : actrs) {
              //테이블을 따로 둬서 저장하자.
              String actor_idx = actr.attr("href");
              arr_actr.add(actor_idx);
            }

            result.put("ACTR_NM", tmp2);  //배우
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

    
      System.out.print(result);
    }

   
    
}
