package com.example.demo.security.oauth2;

import java.util.Map;

import lombok.Builder;
import lombok.Getter;

@Getter
public class OAuthAttributes {
   private Map<String, Object> attributes;   // 필수
   private String name; //필수  키 id 
   private String nameAttributeKey; //키명


   private String snsGubun; //kakao, google, 
   private String snsId ; // 회원번호 --registrationId마다 다름


   private String nickname; 
   private String birthday;
   private String gender;
   private String ageRange;
   private String email;
   private String prfImg;
   private String thumbImg;

   @Builder
   public OAuthAttributes(Map<String, Object> attributes,
                          String nameAttributeKey, 
                          String name,
                          
                          String nickname, 
                          String birthday,
                          String gender,
                          String ageRange,
                          String email,
                          String prfImg,
                          String thumbImg,
                          String snsGubun,
                          String snsId
                          
                          ) {
       this.attributes = attributes;
       this.nameAttributeKey= nameAttributeKey;
       this.name = name;


       this.nickname = nickname;
       this.birthday = birthday;
       this.gender = gender;
       this.ageRange = ageRange;
       this.email = email;
       this.prfImg = prfImg;
       this.thumbImg = thumbImg;

       this.snsGubun = snsGubun;
       this.snsId = snsId;
   }

   public static OAuthAttributes of(String registrationId,String userNameAttributeName, Map<String, Object>  userAttributes){
    


        if(registrationId.equals("kakao")){
            return ofKakao(userNameAttributeName,registrationId, userAttributes);     
        } else if(registrationId.equals("naver")){
            return ofNaver(userNameAttributeName,registrationId, userAttributes);   
        } else if(registrationId.equals("facebook")) {
            return ofFacebook(userNameAttributeName,registrationId, userAttributes);   
        } else if(registrationId.equals("google")) {            
            return ofGoogle(userNameAttributeName,registrationId, userAttributes);   
        } else {
            return null;
        }
   }
   
   private static OAuthAttributes ofKakao(String userNameAttributeName,String SNS_GUBUN,Map<String, Object> attributes) {
        //https://kapi.kakao.com/v2/user/me

        Map<String, Object>  prop = (Map<String, Object>)attributes.get("properties");
        Map<String, Object>  account = (Map<String, Object>)attributes.get("kakao_account");
        

        return OAuthAttributes.builder()
        .attributes(attributes)
        .nameAttributeKey(userNameAttributeName)
        .name((String) prop.get("nickname"))

        .nickname((String) prop.get("nickname"))
        .snsGubun(SNS_GUBUN)
        .snsId(String.valueOf(attributes.get("id")))

        .birthday((String) account.get("birthday"))
        .gender((String) account.get("gender"))
        .ageRange((String) account.get("age_range"))
        .email((String) account.get("email"))
        .prfImg((String) prop.get("profile_image"))
        .thumbImg((String) prop.get("thumbnail_image"))
        .build();
    }

    private static OAuthAttributes ofNaver(String userNameAttributeName,String SNS_GUBUN,Map<String, Object> attributes) {
        //https://openapi.naver.com/v1/nid/me      

        return OAuthAttributes.builder()
        .attributes(attributes)
        .nameAttributeKey(userNameAttributeName)
        .name((String) attributes.get("nickname"))

        .nickname((String) attributes.get("nickname"))
        .snsGubun(SNS_GUBUN)
        .snsId(String.valueOf(attributes.get("id")))

        .birthday("")
        .gender((String) attributes.get("gender"))
        .ageRange((String) attributes.get("age"))
        .email((String) attributes.get("email"))
        .prfImg("")
        .thumbImg("")
        .build();
    }

    private static OAuthAttributes ofFacebook(String userNameAttributeName,String SNS_GUBUN,Map<String, Object> attributes) {
        //https://openapi.naver.com/v1/nid/me      

        return OAuthAttributes.builder()
        .attributes(attributes)
        .nameAttributeKey(userNameAttributeName)
        .name((String) attributes.get("name"))

        .nickname((String) attributes.get("name"))
        .snsGubun(SNS_GUBUN)
        .snsId(String.valueOf(attributes.get("id")))

        .birthday("")
        .gender("")
        .ageRange("")
        .email((String) attributes.get("email"))
        .prfImg("")
        .thumbImg("")
        .build();
    }

    private static OAuthAttributes ofGoogle(String userNameAttributeName,String SNS_GUBUN,Map<String, Object> attributes) {
        //https://openapi.naver.com/v1/nid/me      

        return OAuthAttributes.builder()
        .attributes(attributes)
        .nameAttributeKey(userNameAttributeName)
        .name((String) attributes.get("name"))

        .nickname((String) attributes.get("name"))
        .snsGubun(SNS_GUBUN)
        .snsId(String.valueOf(attributes.get("sub")))

        .birthday("")
        .gender("")
        .ageRange("")
        .email((String) attributes.get("email"))
        .prfImg((String) attributes.get("picture"))
        .thumbImg("")
        .build();
    }
}