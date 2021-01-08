'use strict';
class AjaxMngr {
	static send_post_ajax(p_url, p_param, p_function) {
	    var hash = window.location.hash;
	   
	    var req=$.ajax({
	        type: "POST",
	        url: p_url,
	        contentType: "application/json; charset=utf-8",
	        accept: "application/json",
	         beforeSend : function(xhr)   /*이거 동작한다.  -- https://hyunsangwon93.tistory.com/28*/
	        { 
				xhr.setRequestHeader(csrf_headerName, csrf_token);
	        },
	        data: JSON.stringify(p_param), //이게 포인트 였다
	        dataType: "json",
	    });
	
	    req.done(function (data, status) {
	        if (hash.indexOf("#debug=Y") >= 0) {
	            console.log("result:");
	            console.log(JSON.stringify(data));
	            
	        }
	        	        
	        if(p_function){
	        	p_function(data);
	        }
	        
	    });
	
	    req.fail(function (jqXHR, textStatus) {
	        console.log(jqXHR)
	        console.log(textStatus)
	        if (textStatus == "error") {
	            var msg = "Sorry but there was an error: ";
	            console.log(msg + jqXHR.status + ",statusText: " + jqXHR.statusText+ ",responseText: " + jqXHR.responseText);
	            Message.alert(msg + jqXHR.status + "<br />statusText: " + jqXHR.statusText+ "<br />responseText: " + jqXHR.responseText);
	        }
	        
	        if(p_function){
	        	p_function();
	        }
	    });   
	}
	
	static send_api_post_ajax(p_url, p_param, p_function,uuid) {
	    var hash = window.location.hash;
	    var br = p_url;
	    p_url = "/api/"+p_url;
	     if (AppMngr.debug_console=="Y") {
	        //클라이언트 세션을 넣으려고 했는데
	        //그게 아니다 서버 세션에 넣자.-- 왜냐면 사용자 정보를 클라이언트는 모르니
	        //사용자 정보를 알려면 저장되어야 하는 부분은 서버세션이다.
	        //페이지에서 그 정보를 저장하려면 키가 있어야한다.
	        //클라이언트 세션에 페이지에 관한 uuid와 
	        //시퀀스에 대한  seq를 생성해서 넣자 uuid에 시퀀스한 seq
	        //실제로는 서버에 저장할수도 있겠지만. 
	        //나는 로그 서버 저장소가 없으므로  서버사이드 세션에 저장한다.
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
		        var run_fun = "javascript:void AppMngr.openLog('"+uuid+"','"+seq+"');";
		        console.log(run_fun);
		        var tmp ="<li><a href=\""+run_fun+"\">["+now_time+"]["+seq+"]"+br+"</a></li>";
		        console.log(tmp);
	          	uuid_debug_log_ul.append(tmp);
	        }
	    }
	    var req=$.ajax({
	        type: "POST",
	        url: p_url,
	        contentType: "application/json; charset=utf-8",
	        accept: "application/json",
	         beforeSend : function(xhr)   /*이거 동작한다.  -- https://hyunsangwon93.tistory.com/28*/
	        { 
				xhr.setRequestHeader(csrf_headerName, csrf_token);
	        },
	        data: JSON.stringify(p_param), //이게 포인트 였다
	        dataType: "json",
	    });
	
	    req.done(function (data, status) {
	        if (hash.indexOf("#debug=Y") >= 0) {
	            console.log("result:");
	            console.log(JSON.stringify(data));
	            
	        }
	        	        
	        if(p_function){
	        	p_function(data);
	        }
	        
	    });
	
	    req.fail(function (jqXHR, textStatus) {
	        console.log(jqXHR)
	        console.log(textStatus)
	        if (textStatus == "error") {
	            var msg = "Sorry but there was an error: ";
	            console.log(msg + jqXHR.status + ",statusText: " + jqXHR.statusText+ ",responseText: " + jqXHR.responseText);
	            Message.alert(msg + jqXHR.status + "<br />statusText: " + jqXHR.statusText+ "<br />responseText: " + jqXHR.responseText);
	        }
	        
	        if(p_function){
	        	p_function();
	        }
	    });   
	}

	static send_api_post_ajax_sync(p_url, p_param, p_funtion) {
	    var hash = window.location.hash;
	    p_url = "/api/"+p_url;
	    if (hash.indexOf("#debug=Y") >= 0) {
	        console.log('hash');
	        console.log(hash);
	        console.log("p_url=>"+ p_url);
	        console.log("p_param:");
	        console.log(JSON.stringify(p_param));
	    }
	    var req=$.ajax({
	        type: "POST",
	        url: p_url,
	        async: false,
	        contentType: "application/json; charset=utf-8",
	        accept: "application/json",
	         beforeSend : function(xhr)   /*이거 동작한다.  -- https://hyunsangwon93.tistory.com/28*/
	        { 
				xhr.setRequestHeader(csrf_headerName, csrf_token);
	        },
	        data: JSON.stringify(p_param), //이게 포인트 였다
	        dataType: "json",
	    });
	
	    req.done(function (data, status) {
	        if (hash.indexOf("#debug=Y") >= 0) {
	            console.log("result:");
	            console.log(JSON.stringify(data));
	        }
	        p_funtion(data);
	    });
	
	    req.fail(function (jqXHR, textStatus) {
	        console.log(jqXHR)
	        console.log(textStatus)
	        if (textStatus == "error") {
	            var msg = "Sorry but there was an error: ";
	            console.log(msg + jqXHR.status + " " + jqXHR.statusText);
	        }
	        p_funtion(null);
	    });   
	}

	static get_page_ajax(el,p_url, p_param) {
		p_url='/page/'+p_url
	    var hash = window.location.hash;
	    if (hash.indexOf("#debug=Y") >= 0) {
	        console.log('hash');
	        console.log(hash);
	        console.log("p_url=>" + p_url);
	        console.log("p_param:");
	        console.log(JSON.stringify(p_param));
	    }
	/* 이거 안먹음
	        $.ajaxPrefilter(function (options) { 
	 
		      	if (options.method === 'POST') { 
			      options.headers = options.headers || {}; 
			      options.headers[csrf_headerName] = csrf_token; 
			    } 
		      });
	*/	      
	    var req=$.ajax({
	        type: "POST",     /*POST 전송이 안된다.  csrf를끄면 된다. */
	        url: p_url,
	        beforeSend : function(xhr)   /*이거 동작한다.  -- https://hyunsangwon93.tistory.com/28*/
	        { 
				xhr.setRequestHeader(csrf_headerName, csrf_token);
	        },
	        contentType: "application/json; charset=utf-8",
	        accept: "application/json",
	        data: JSON.stringify(p_param),     
	        dataType: "html"
	    });
	
	    req.done(function (data, status) {
	        if (hash.indexOf("#debug=Y") >= 0) {
	            console.log("result:");
	            console.log(JSON.stringify(data));
	        }
	        el.html(data);
	    });
	
	    req.fail(function (jqXHR, textStatus) {
	        console.log(jqXHR)
	        console.log(textStatus)
	        if (textStatus == "error") {
	            var msg = "Sorry but there was an error: ";
	            console.log(msg + jqXHR.status + " " + jqXHR.statusText);
	        }
	    });   
	}

	static bind_one_ajax(area_mngr, p_url, p_param ,p_function) {
	    send_post_ajax(p_url, p_param, function (data) {
	        if (data.length > 0) {
	            for (var key in data[0]) {
	                var tmp = area_mngr.get( key)
	                if (tmp.length > 0) {
	                    tmp.val(data[0][key]);
	                }
	            }
	        }
	        if(typeof p_function == "function") {
	            p_function(data);
	        }
	        
	    });
	}
}

