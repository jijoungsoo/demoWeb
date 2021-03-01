'use strict';
class PjtUtil{
	static isEmpty(param) {
		if(null===param){
			return true; 
		}
		if(undefined===param){
			return true; 
		}
		if(typeof param == "number"){
			
		}
		if(param.length==0){
			return true;
		}
		return false;
	}
	static isNumeric(num, opt){
		//출처: https://sometimes-n.tistory.com/34 [종종 올리는 블로그]
	  // 좌우 trim(공백제거)을 해준다.
	  num = String(num).replace(/^\s+|\s+$/g, "");
	 
	  if(typeof opt == "undefined" || opt == "1"){
	    // 모든 10진수 (부호 선택, 자릿수구분기호 선택, 소수점 선택)
	    var regex = /^[+\-]?(([1-9][0-9]{0,2}(,[0-9]{3})*)|[0-9]+){1}(\.[0-9]+)?$/g;
	  }else if(opt == "2"){
	    // 부호 미사용, 자릿수구분기호 선택, 소수점 선택
	    var regex = /^(([1-9][0-9]{0,2}(,[0-9]{3})*)|[0-9]+){1}(\.[0-9]+)?$/g;
	  }else if(opt == "3"){
	    // 부호 미사용, 자릿수구분기호 미사용, 소수점 선택
	    var regex = /^[0-9]+(\.[0-9]+)?$/g;
	  }else{
	    // only 숫자만(부호 미사용, 자릿수구분기호 미사용, 소수점 미사용)
	    var regex = /^[0-9]$/g;
	  }
	 
	  if( regex.test(num) ){
	    num = num.replace(/,/g, "");
	    return isNaN(num) ? false : true;
	  }else{ return false;  }
	}

	static numberComma(tmp){
	  if(PjtUtil.isNumeric(tmp)) {
	  	tmp = String(tmp);
	  	var tmp2 = tmp.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	  	return tmp2;	
	  } else {
	  	return tmp2;
	  }
	}
	

	static addEvent(el, event_name, el_sel, func) {
		var w = el;
		if (w.querySelectorAll(el_sel)) {
			w.querySelectorAll(el_sel).forEach(function(el) {
				el.addEventListener(event_name, func);
			});
		}
	}
	
	static removeComma(str)
	{
		var str = String(str);
		var n = parseInt(str.replace(/,/g,""));
		return n;
	}

	static isTelNo(strTelNum){
		var regExp = /^(01[016789]{1}|02|0[3-9]{1}[0-9]{1})-?[0-9]{3,4}-?[0-9]{4}$/;
		if( !regExp.test(strTelNum)) {
			return false;
	   	} else {
			return true;
		}
	}

	static isEmail(strEmail){
		var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
		if (strEmail == '' || !re.test(strEmail)) {
			
			return false;
		} else {
			return true;
		}

	}


}