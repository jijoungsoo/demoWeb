package com.example.demo.cm.ctrl;

import java.util.HashMap;





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
