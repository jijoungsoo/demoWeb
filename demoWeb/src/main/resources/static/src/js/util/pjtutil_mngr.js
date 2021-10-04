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
	  	//tmp = String(tmp);
	  	//var tmp2 = tmp.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
		var parts = tmp.toString().split("."); 
		return parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",") + (parts[1] ? "." + parts[1] : ""); 
	  } else {
	  	return tmp;
	  }
	}

	static numberCommaRemoveDot(tmp){
		if(PjtUtil.isNumeric(tmp)) {
			//tmp = String(tmp);
			//var tmp2 = tmp.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
		  var parts = tmp.toString().split("."); 
		  return parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ","); 
		} else {
			return tmp;
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

	static makeUUID() { // UUID v4 generator in JavaScript (RFC4122 compliant)
	    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
	      var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 3 | 8);
	      return v.toString(16);
	    });
	}

	static saveApiLog(br,p_param,uuid){
		 var api_uuid= PjtUtil.makeUUID();
		if (AppMngr.debug_console=="Y") {
	        if(uuid!=undefined){
		        var seq = sessionStorage.getItem(uuid);
		        if(seq==null){
		        	seq =1;
		        	sessionStorage.setItem(uuid,1);
		        } else {
		        	seq = Number(seq);
		        	seq = seq+1;
		        	sessionStorage.setItem(uuid,seq);
		        }
		        /**/
		        p_param['UUID'] = uuid;
		        p_param['SEQ'] = seq;
		        //자 이걸 등록한다.
		        var uuid_debug_log_ul = $("#"+uuid+"_debug_log_ul");
		        //입력할 창은 정해져있다.
		        var now_time = moment(new Date()).format('HH:mm:ss');
		        var run_fun = "javascript:void AppMngr.openLog('"+uuid+"','"+seq+"','"+api_uuid+"');";
		        console.log(run_fun);
		        var tmp ="<li><a href=\""+run_fun+"\">["+now_time+"]["+seq+"]"+br+"</a></li>";
		        console.log(tmp);
	          	uuid_debug_log_ul.append(tmp);
	        }
	    }
		return p_param;
	}
}