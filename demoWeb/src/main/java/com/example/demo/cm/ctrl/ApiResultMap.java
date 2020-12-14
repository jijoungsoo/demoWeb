package com.example.demo.cm.ctrl;

import java.io.IOException;
import java.lang.reflect.Method;
import java.lang.reflect.Parameter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.core.type.ClassMetadata;
import org.springframework.core.type.MethodMetadata;
import org.springframework.core.type.classreading.MetadataReader;
import org.springframework.core.type.classreading.SimpleMetadataReaderFactory;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.exception.BizException;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.google.common.base.Throwables;





public class ApiResultMap {
	public ApiResultMethod rm =null;
	public String jsonInString ="";
	public String jsonOutString = "";
	public String success ="";
	public String errorMessage ="";
	public String brId ="";
	public String brRq ="";
	public String brRs ="";
	public String uuid ="";  /*json 문자열에 붙여서 넘길 값--- 프로그램 uuid */
	public String pgmId  ="";  /*json 문자열에 붙여서 넘길 값--- 프로그램 pgmId */
	public IN_DS IN_DS= new IN_DS(); 
	public OUT_DS OUT_DS= new OUT_DS();
	public HashMap<String,Object> MY_SESSION  = new HashMap<String,Object>();
	//세션데이터도 하나가지고 있어야한다.
}
