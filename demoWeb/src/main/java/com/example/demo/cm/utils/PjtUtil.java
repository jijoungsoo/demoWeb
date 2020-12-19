package com.example.demo.cm.utils;

import java.nio.ByteBuffer;
import java.security.AlgorithmParameters;
import java.security.SecureRandom;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.PBEKeySpec;
import javax.crypto.spec.SecretKeySpec;

import org.apache.commons.codec.net.URLCodec;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.configurationprocessor.json.JSONArray;
import org.springframework.boot.configurationprocessor.json.JSONObject;
import org.springframework.stereotype.Service;

import com.example.demo.cm.ctrl.ApiResultMap;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;


public class PjtUtil {
	public static String key = "demo exmaple key";
	public static String getYyyyMMddHHMMSS(java.util.Date inDate) {
		DateFormat dateformat = new SimpleDateFormat("yyyyMMddHHMMSS");
		return dateformat.format(inDate);
	}

	public static  <T> T JsonStringToObject(String JsonInString, Class<T> valueType) throws JsonMappingException, JsonProcessingException {
		ObjectMapper omOut = new ObjectMapper();
    	omOut.enable(SerializationFeature.INDENT_OUTPUT);
		return omOut.readValue(JsonInString,valueType);		
	}
	
	public static String ObjectToJsonString(Object value) throws JsonProcessingException {
		ObjectMapper om = new ObjectMapper();
		om.enable(SerializationFeature.INDENT_OUTPUT);
		return om.writeValueAsString(value);
	}
	
	public static String encAES256AndUrl(String msg) throws Exception {
		/*https://aaboo.home.blog/2019/11/29/aes-256-%EC%95%94%EB%B3%B5%ED%98%B8%ED%99%94/
		 * url Encode를 하지 않으면 문자열이  cookie에 valid 하지 않다고 나온다.
		 * 
		 * */
		String tmp = encryptAES256( msg,  PjtUtil.key);
		URLCodec codec = new URLCodec();
		return codec.encode(tmp);
	}
	
	public static String decAES256AndUrl(String msg) throws Exception {
		URLCodec codec = new URLCodec();
		String tmp =codec.decode(msg);
		return decryptAES256( tmp,  PjtUtil.key);
	}
	
	public static String encryptAES256(String msg, String key) throws Exception {
		/*출처: https://offbyone.tistory.com/286 [쉬고 싶은 개발자]*/
	    SecureRandom random = new SecureRandom();
	    byte bytes[] = new byte[20];
	    random.nextBytes(bytes);
	    byte[] saltBytes = bytes;
	    // Password-Based Key Derivation function 2
	    SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA1");
	    // 70000번 해시하여 256 bit 길이의 키를 만든다.
	    PBEKeySpec spec = new PBEKeySpec(key.toCharArray(), saltBytes, 70000, 256);
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
	
	public static String decryptAES256(String msg, String key) throws Exception {
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
	    PBEKeySpec spec = new PBEKeySpec(key.toCharArray(), saltBytes, 70000, 256);
	    SecretKey secretKey = factory.generateSecret(spec);
	    SecretKeySpec secret = new SecretKeySpec(secretKey.getEncoded(), "AES");
	    cipher.init(Cipher.DECRYPT_MODE, secret, new IvParameterSpec(ivBytes));
	    byte[] decryptedTextBytes = cipher.doFinal(encryoptedTextBytes);
	    return new String(decryptedTextBytes);
	}
	

    public static JSONObject convertExceptionToJSON(Throwable e) throws Exception {
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
}
