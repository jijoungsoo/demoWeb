class AjaxMngr {
	static send_post_ajax(p_url, p_param, p_function) {
	    var hash = window.location.hash;
	    p_url = "/api/"+p_url;
	    if (hash.indexOf("#debug=Y") >= 0) {
	        console.log('hash');
	        console.log(hash);
	        console.log("p_url=>"+ p_url);
	        console.log("p_param:");
	        console.log(JSON.stringify(p_param));
	        console.log("p_function=>"+p_function);
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

	static send_post_sync(p_url, p_param, p_funtion) {
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

