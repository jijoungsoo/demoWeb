package com.example.demo.utils;

import java.nio.ByteBuffer;
import java.security.AlgorithmParameters;
import java.security.SecureRandom;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Base64;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.Queue;
import java.util.UUID;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.PBEKeySpec;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.example.demo.cm.ctrl.MsgDebugInfo;
import com.example.demo.user.domain.UserInfo;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;

import org.apache.commons.codec.net.URLCodec;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;

@Service
public class PjtUtil {
	public static String key = "demo exmaple key";
	static DateFormat dateformat1 = new SimpleDateFormat("yyyyMMddHHmmss");
    static DateFormat dateformat2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    
    public static String getYyyy_MM_dd_HHMMSS(java.util.Date inDate) {
        return dateformat2.format(inDate);
    }
    
    
    
    public  String getYyyyMMddHHMMSS(java.util.Date inDate) {
        return dateformat1.format(inDate);
    }

    
    public  String getBrowser(HttpServletRequest request) {
        String header = request.getHeader("User-Agent");
        if (header != null) {
         if (header.indexOf("Trident") > -1) {
          return "MSIE";
         } else if (header.indexOf("Chrome") > -1) {
          return "Chrome";
         } else if (header.indexOf("Opera") > -1) {
          return "Opera";
         } else if (header.indexOf("iPhone") > -1
           && header.indexOf("Mobile") > -1) {
          return "iPhone";
         } else if (header.indexOf("Android") > -1
           && header.indexOf("Mobile") > -1) {
          return "Android";
         }
        }
        return null;
    }

    public  boolean isEmpty(String tmp) {
        if (tmp == null) {
            return true;
        }
        if (tmp.length() == 0) {
            return true;
        }
        return false;
    }

    public  String str(Object tmp) {
        if (tmp == null) {
            return "";
        }
        String tmp2 = tmp.toString();
        return tmp2;
    }

    public  String nvl(String first, String second) {
        if (isEmpty(first)) {
            return second;
        }

        return first;
    }

	public   <T> T JsonStringToObject(String JsonInString, Class<T> valueType) throws JsonMappingException, JsonProcessingException {
		ObjectMapper omOut = new ObjectMapper();
    	//omOut.enable(SerializationFeature.INDENT_OUTPUT); 느려짐
		return omOut.readValue(JsonInString,valueType);		
	}
	
	public  String ObjectToJsonString(Object value) throws JsonProcessingException {
		ObjectMapper om = new ObjectMapper();
		//om.enable(SerializationFeature.INDENT_OUTPUT); 느려짐
		return om.writeValueAsString(value);
	}
	
	public  String jsonBeautifier(String InJsonString) {
        try {
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.configure(SerializationFeature.INDENT_OUTPUT, true); //느려짐 --- 이뻐지게 하려면 이거 넣어야한다.
            JsonNode tree;
            tree = objectMapper.readTree(InJsonString);
            String formattedJson = objectMapper.writeValueAsString(tree);
            return formattedJson;
        } catch (JsonProcessingException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
            return InJsonString; 
        }
	}
	
	public  String encAES256AndUrl(String msg) throws Exception {
		/*https://aaboo.home.blog/2019/11/29/aes-256-%EC%95%94%EB%B3%B5%ED%98%B8%ED%99%94/
		 * url Encode를 하지 않으면 문자열이  cookie에 valid 하지 않다고 나온다.
		 * 
		 * */
		String tmp = encryptAES256( msg,  PjtUtil.key);
		URLCodec codec = new URLCodec();
		return codec.encode(tmp);
	}
	
	public  String decAES256AndUrl(String msg) throws Exception {
		URLCodec codec = new URLCodec();
		String tmp =codec.decode(msg);
		return decryptAES256( tmp,  PjtUtil.key);
	}
	
	public  String encryptAES256(String msg, String key) throws Exception {
		/*출처: https://offbyone.tistory.com/286 [쉬고 싶은 개발자]*/
	    SecureRandom random = new SecureRandom();
	    byte bytes[] = new byte[20];
	    random.nextBytes(bytes);
	    byte[] saltBytes = bytes;
	    // Password-Based Key Derivation function 2
	    SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA1");
	    // 70000번 해시하여 256 bit 길이의 키를 만든다.
	    PBEKeySpec spec = new PBEKeySpec(key.toCharArray(), saltBytes, 100, 256); //첫번째 100 기존에 70000이었는데 너무 느려서 1000으로 변경
	    SecretKey secretKey = factory.generateSecret(spec);
	    SecretKeySpec secret = new SecretKeySpec(secretKey.getEncoded(), "AES");
	    // 알고리즘/모드/패딩
	    // CBC : Cipher Block Chaining Mode
	    Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
	    cipher.init(Cipher.ENCRYPT_MODE, secret);
	    AlgorithmParameters params = cipher.getParameters();
	    // Initial Vector(1단계 암호화 블록용)
	    byte[] ivBytes = params.getParameterSpec(IvParameterSpec.class).getIV();
	    byte[] encryptedTextBytes = cipher.doFinal(msg.getBytes("UTF-8"));
	    byte[] buffer = new byte[saltBytes.length + ivBytes.length + encryptedTextBytes.length];
	    System.arraycopy(saltBytes, 0, buffer, 0, saltBytes.length);
	    System.arraycopy(ivBytes, 0, buffer, saltBytes.length, ivBytes.length);
	    System.arraycopy(encryptedTextBytes, 0, buffer, saltBytes.length + ivBytes.length, encryptedTextBytes.length);
	    return Base64.getEncoder().encodeToString(buffer);
	}
	
	public  String decryptAES256(String msg, String key) throws Exception {
		/*	출처: https://offbyone.tistory.com/286 [쉬고 싶은 개발자]*/
	    Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
	    ByteBuffer buffer = ByteBuffer.wrap(Base64.getDecoder().decode(msg));
	    byte[] saltBytes = new byte[20];
	    buffer.get(saltBytes, 0, saltBytes.length);
	    byte[] ivBytes = new byte[cipher.getBlockSize()];
	    buffer.get(ivBytes, 0, ivBytes.length);
	    byte[] encryoptedTextBytes = new byte[buffer.capacity() - saltBytes.length - ivBytes.length];
	    buffer.get(encryoptedTextBytes);
	    SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA1");
	    PBEKeySpec spec = new PBEKeySpec(key.toCharArray(), saltBytes, 100, 256); //첫번째 100 기존에 70000이었는데 너무 느려서 1000으로 변경 보통 너무 적은 숫자면 해킹에 위험이 있다고 한다.  0.2초에 맞추는게 좋다고 한다.
	    SecretKey secretKey = factory.generateSecret(spec);
	    SecretKeySpec secret = new SecretKeySpec(secretKey.getEncoded(), "AES");
	    cipher.init(Cipher.DECRYPT_MODE, secret, new IvParameterSpec(ivBytes));
	    byte[] decryptedTextBytes = cipher.doFinal(encryoptedTextBytes);
	    return new String(decryptedTextBytes);
	}
	

    public  JSONObject convertExceptionToJSON(Throwable e) throws Exception {
        JSONObject responseBody = new JSONObject();
        JSONObject errorTag = new JSONObject();
        responseBody.put("error", errorTag);

        JSONArray detailList = new JSONArray();
        errorTag.put("details", detailList);

        Throwable nextRunner = e;
        while (nextRunner!=null) {
            Throwable runner = nextRunner;
            nextRunner = runner.getCause();

            HashMap detailObj = new HashMap();
            detailObj.put("code", runner.getClass().getName());
            String msg =  runner.toString();
            detailObj.put("message",msg);

            detailList.put(detailObj);
        }

        JSONArray stackList = new JSONArray();
        for (StackTraceElement ste : e.getStackTrace()) {
            stackList.put(ste.getFileName() + ": " + ste.getMethodName()
                   + ": " + ste.getLineNumber());
        }
        errorTag.put("stack", stackList);

        return responseBody;
    }
    
    public  MsgDebugInfo makeLSession(String br, String jsonInString,Authentication authentication) throws JsonMappingException, JsonProcessingException {
        /*
        출처: https://itstory.tk/entry/Spring-Security-현재-로그인한-사용자-정보-가져오기 [덕's IT Story]
       */
        UserInfo userInfo = (UserInfo) authentication.getPrincipal();
        long USER_NO=userInfo.getUserNo();
        String USER_ID=userInfo.getUserNm();
        String EMAIL=userInfo.getEmail();

        System.out.println("-----------makeLSession--------------");
        System.out.println("USER_NO=>"+USER_NO);
        System.out.println("USER_ID=>"+USER_ID);
        System.out.println("EMAIL=>"+EMAIL);


        


        HashMap<String,Object>  inDs= this.JsonStringToObject(jsonInString, HashMap.class );

        UUID one = UUID.randomUUID();//난수 생성
        inDs.put("_id", one.toString()); 

        /*세션은 하나이지만... 약속때문에..  list 에 담는다.*/
        ArrayList<HashMap<String,String>>  arr_sess = new ArrayList<HashMap<String,String>>();
        HashMap<String,String>  sess = new HashMap<String,String>();
        sess.put("USER_NO", String.valueOf(USER_NO));
        sess.put("USER_ID", USER_ID);
        String UUID = (String) inDs.get("UUID");
        String brRq=(String) inDs.get("brRq");
        if(this.isEmpty(brRq)){
            brRq = "LSESSION";
        } else {
            brRq = brRq+",LSESSION";
        }        
        inDs.put("UUID", UUID);
        inDs.put("brRq", brRq);
        arr_sess.add(sess);
        inDs.put("LSESSION", arr_sess);
        
        
        

        
        String sessionJsonInString  = this.ObjectToJsonString(inDs);

        System.out.println("sessionJsonInString=>"+sessionJsonInString);
        System.out.println("-----------makeLSession--------------");
        
        MsgDebugInfo  m = new MsgDebugInfo();
        m.setBr(br);
        m.setIN_DATA_JSON(sessionJsonInString);
        
        if(UUID!=null) {
            int SEQ = (int) inDs.get("SEQ");
            m.setUUID(UUID);
            m.setSEQ(SEQ);
        }
        return m;
      }
    
    

    
    public  void saveSesstionDebugMsg(MsgDebugInfo msg,String jsonOutString,HttpSession session ) {
        if(msg.getUUID()!=null) {
               msg.setOUT_DATA_JSON(jsonOutString);
               Queue<MsgDebugInfo> que = (LinkedList<MsgDebugInfo>) session.getAttribute("UUID_DEBUG_LOG");
               if(que==null) {
                   que = new LinkedList<MsgDebugInfo>();
               }
               while(que.size()>10) {
                   que.poll();
               }
               que.add(msg);
               session.setAttribute("UUID_DEBUG_LOG",que);             
           } 
    }
}
