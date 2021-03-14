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
public class adbdsActor {

    @Test
    public void testActor(){
      //   https://www.avdbs.com/menu/actor.php?actor_idx=2309
       HashMap<String, Object> result = new HashMap<String, Object>();
       HttpComponentsClientHttpRequestFactory factory = new HttpComponentsClientHttpRequestFactory();
       factory.setConnectTimeout(10000); // 타임아웃 설정 5초
       factory.setReadTimeout(10000);// 타임아웃 설정 5초
       RestTemplate restTemplate = new RestTemplate(factory);
       

       int actor_idx = 6830;

       HttpHeaders headers = new HttpHeaders();
       headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
       String url = "https://www.avdbs.com/menu/actor.php?actor_idx="+actor_idx;


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
       String k_name =  doc.getElementsByClass("k_name").text();
       String j_name  = doc.getElementsByClass("j_name").text();
       String prf_img  = doc.getElementsByClass("profile_img_view").attr("src");
       String inner_name_kr  = doc.getElementsByClass("inner_name_kr").text();
       String inner_name_en  = doc.getElementsByClass("inner_name_en").text();
       String inner_name_ch  = doc.getElementsByClass("inner_name_ch").text();
       String profile_birth  = doc.getElementsByClass("profile_birth").text();
       String profile_height  = doc.getElementsByClass("profile_height").text();
       String profile_size    = doc.getElementsByClass("profile_size").text();
       String profile_bra_size    = doc.getElementsByClass("profile_bra_size").text();
       String profile_debut_date    = doc.getElementsByClass("profile_debut_date").text();
       Elements other_photo_list =     doc.getElementsByClass("other_photo_list").select("img");
       Elements photo_boxs =     doc.getElementsByClass("photo_box");

       result.put("K_NAME", k_name);  //한국어이름
       result.put("J_NAME", j_name);  //일본어/ 중국어
       result.put("PRF_IMG", prf_img);  //프로필 이미지
       result.put("INNER_NAME_KR", inner_name_kr);  //한국어이름
       result.put("INNER_NAME_EN", inner_name_en);  //영어
       result.put("INNER_NAME_CH", inner_name_ch);  //중국어
       result.put("PROFILE_BIRTH", profile_birth);  //생년월
       result.put("PROFILE_HEIGHT", profile_height);  //키
       result.put("PROFILE_SIZE", profile_size);       //사이즈
       result.put("PROFILE_BRA_SIZE", profile_bra_size);   //가슴 사이즈
       result.put("PROFILE_DEBUT_DATE", profile_debut_date);   //생년월일
       //다른 사진
       ArrayList<String> arr_img = new ArrayList<String>();
       for(Element img : other_photo_list) {
           arr_img.add(img.attr("src"));            
       }
       result.put("OTHER_PHOTO", arr_img);
       ArrayList<HashMap<String, Object>> best_dvd = new ArrayList<HashMap<String, Object>>();
       for(Element photo_box : photo_boxs) {
           HashMap<String, Object>  best = new HashMap<String, Object>();
           String src = photo_box.select(".dvd_rank_img").attr("src");
           String dscr = photo_box.select(".dscr").text();
           String story = photo_box.select(".story").text();
           best.put("DVD_IMG_S", src);
           best.put("AV_NM", dscr);
           best.put("TITLE", story);
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

      Elements paging_sel =     doc.getElementsByClass("album_vw").select(".paging").select("span").select(".sel");
      int last_page=0;
      for(Element p : paging_sel) {
        last_page=Integer.parseInt(p.text());
      }
      Elements paging_no =     doc.getElementsByClass("album_vw").select(".paging").select("span").select(".no");
      for(Element p : paging_no) {     
        last_page=Integer.parseInt(p.text());
      }
      result.put("LAST_PAGE", last_page);

      Elements cnt =     doc.getElementsByClass("album_vw").select(".cnt");
      result.put("CNT", cnt.text());


      
      ArrayList<HashMap<String, Object>> dvd_info = new ArrayList<HashMap<String, Object>>();
      Elements albums_li =     doc.getElementsByClass("album_vw").select("ul.lst").select("li");
      System.out.println(albums_li.size());
      for(Element p : albums_li) {
          String title = p.select(".title").text();
          String av_nm = p.select(".snum").text();
          String date  = p.select(".date").text();
          String src  = p.select(".photo").select("img").attr("src");
          String dvd_idx  = p.select(".photo").select(".detail").attr("href");
          
          HashMap<String, Object>  dvd = new HashMap<String, Object>();
          dvd.put("TITLE", title);
          dvd.put("AV_NM", av_nm);
          dvd.put("DATE", date);
          dvd.put("SRC", src);
          dvd.put("DVD_IDX", dvd_idx);
          
          dvd_info.add(dvd);
      }
      for(int i=2 ;i<=last_page;i++){
          System.out.println(i);
          /*페이지 호출을 해서 작품리스트를 가져오자. */
          try {
            Thread.sleep(3000);
          } catch(Exception e){
            e.printStackTrace();
          }
          

          HttpHeaders headers2 = new HttpHeaders();
          headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
          String url2 = "https://www.avdbs.com/menu/actor.php?actor_idx="+actor_idx+"&_page="+i;
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
            String title = p.select(".title").text();
            String av_nm = p.select(".snum").text();
            String date  = p.select(".date").text();
            String src  = p.select(".photo").select("img").attr("src");
            String dvd_idx  = p.select(".photo").select(".detail").attr("href");
            
            HashMap<String, Object>  dvd = new HashMap<String, Object>();
            dvd.put("TITLE", title);
            dvd.put("AV_NM", av_nm);
            dvd.put("DATE", date);
            dvd.put("SRC", src);
            dvd.put("DVD_IDX", dvd_idx);            
            dvd_info.add(dvd);
        }
      }
      result.put("DVD_INFO", dvd_info);

      

       //https://i2.avdbs.com/av/v0763/1fsdss003_a.jpg
       //https://i2.avdbs.com/av/v0763/1fsdss003_as.jpg
       
       //출처: https://offbyone.tistory.com/116 [쉬고 싶은 개발자]


       //배우에 대한 댓글도 넣자.
       //https://www.avdbs.com/w2017/page/dvd/dvd_mention.php?actor_idx=2583&page=1



       System.out.print(result);
    }

   
    
}
