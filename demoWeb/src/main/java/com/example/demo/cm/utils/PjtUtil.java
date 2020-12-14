package com.example.demo.cm.utils;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.cm.ctrl.ApiResultMap;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;


public class PjtUtil {
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
}
