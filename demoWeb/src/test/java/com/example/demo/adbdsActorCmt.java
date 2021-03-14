package com.example.demo;

import java.util.ArrayList;
import java.util.HashMap;

import com.example.demo.utils.PjtUtil;

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
public class adbdsActorCmt {

    @Test
    public void testActor(){
      //https://www.avdbs.com/w2017/page/dvd/dvd_mention.php?actor_idx=2583&page=1
       HashMap<String, Object> result = new HashMap<String, Object>();
       HttpComponentsClientHttpRequestFactory factory = new HttpComponentsClientHttpRequestFactory();
       factory.setConnectTimeout(10000); // 타임아웃 설정 5초
       factory.setReadTimeout(10000);// 타임아웃 설정 5초
       RestTemplate restTemplate = new RestTemplate(factory);
       

       int actor_idx = 5195;

       HttpHeaders headers = new HttpHeaders();
       headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
       String url = "https://www.avdbs.com/w2017/page/actor/actor_mention.php?actor_idx="+actor_idx;


      //adult_chk=1 로 넣으면 성인인증한것처럼 나온다.
      //user_nickname=ddd   로 넣으면 로그인 한것 처럼나온다.
      //member_idx=111      의미 없어보이지만 회원시퀀스로 보여진다.
      //이게 있어야 밑에 모자이크이미지가 아닌 이미지가 보인다.
      //지금 분석한것으로 보았을때는 약속은 있는것 같은데 컬럼을 각각 가지고 있는것으로 보인다.
      //어차피 배우 정보에는 관계없음.

       String set_cookie = "adult_chk=1; user_nickname=dd; member_idx= 11;";
       headers.add("Cookie", set_cookie);
       UriComponentsBuilder uriBuilder = UriComponentsBuilder.fromHttpUrl(url);

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

       ArrayList<HashMap<String, Object>> cmt_info = new ArrayList<HashMap<String, Object>>();
       Elements rows =     doc.getElementsByClass("row");
       for(Element r : rows) {
          HashMap<String, Object>  cmt = new HashMap<String, Object>();
          String cmt_idx=rows.attr("data-idx");
          if(PjtUtil.isEmpty(cmt_idx)==false) {
            String cmt_actor_idx =r.getElementsByClass("comment").select("a").attr("href");
            String cmt_txt =r.getElementsByClass("comment").text();
            String writer =r.getElementsByClass("writer").text();
            String blue_cnt =r.getElementsByClass("blue").text();
            String red_cnt =r.getElementsByClass("red").text();

            cmt.put("CMT_IDX", cmt_idx);
            cmt.put("CMT_ACTOR_IDX", cmt_actor_idx);
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

           if(PjtUtil.isEmpty(cmt_idx)==false) {
            String cmt_actor_idx =r.getElementsByClass("comment").select("a").attr("href");
            String cmt_txt =r.getElementsByClass("comment").text();
            String writer =r.getElementsByClass("writer").text();
            String blue_cnt =r.getElementsByClass("blue").text();
            String red_cnt =r.getElementsByClass("red").text();
  
            cmt.put("CMT_IDX", cmt_idx);
            cmt.put("CMT_ACTOR_IDX", cmt_actor_idx);
            cmt.put("CMT_TXT", cmt_txt);
            cmt.put("WRITER", writer);
            cmt.put("BLUE_CNT", blue_cnt);
            cmt.put("RED_CNT", red_cnt);
            cmt_info.add(cmt);
           }
           
       }
      }
      result.put("CMT_INFO",cmt_info);
      

       System.out.print(result);
    }
}
