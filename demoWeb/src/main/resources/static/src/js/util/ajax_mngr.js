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
			console.log('data');
			console.log(data);
			console.log('status');
			console.log(status);
	        	        
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

			/*
			textStatus가 		 	parsererror  
			넘어오는 경우가 있다.
			이런경우는 ajax 에서 dataType 이 json으로 지정했는데
			결과가 text로 넘어온 경우라고 한다.
			https://vvh-avv.tistory.com/159

			에러일때 text로 익셉션을 넘겼는데 그것이 문제였다.
			에러도 json 형식으로 넘겨 보아야겠다.
		   */

			
	        
	        if(p_function){
	        	p_function();
	        }
	    });   
	}

	
	
	static send_api_post_ajax(p_url, p_param, p_function,uuid) {
	    var hash = window.location.hash;
	    var br = p_url;
	    p_url = "/api/"+p_url;
		p_param = PjtUtil.saveApiLog(br,p_param,uuid);
		console.log(p_param);
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
			//console.log("result:");
	            //console.log(JSON.stringify(data));
	        if (hash.indexOf("#debug=Y") >= 0) {
	            console.log("result:");
	            console.log(JSON.stringify(data));
	            
	        }

			console.log('data');
			console.log(data);
			console.log('status');
			console.log(status);
	        	//console.log(p_function)        
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
           /*
			textStatus가 		 	parsererror  
			넘어오는 경우가 있다.
			이런경우는 ajax 에서 dataType 이 json으로 지정했는데
			결과가 text로 넘어온 경우라고 한다.
			https://vvh-avv.tistory.com/159

			에러일때 text로 익셉션을 넘겼는데 그것이 문제였다.
			에러도 json 형식으로 넘겨 보아야겠다.
		   */
				        
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

	static get_page_ajax(el,p_url, p_param,func) {
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

			if(func){
				func();
			}
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


	static send_proxy(p_param, p_function) {
	    var hash = window.location.hash;
	   
	    var req=$.ajax({
	        type: "POST",
	        url: "/proxy",
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
			console.log('data');
			console.log(data);
			console.log('status');
			console.log(status);
	        	        
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

			/*
			textStatus가 		 	parsererror  
			넘어오는 경우가 있다.
			이런경우는 ajax 에서 dataType 이 json으로 지정했는데
			결과가 text로 넘어온 경우라고 한다.
			https://vvh-avv.tistory.com/159

			에러일때 text로 익셉션을 넘겼는데 그것이 문제였다.
			에러도 json 형식으로 넘겨 보아야겠다.
		   */

			
	        
	        if(p_function){
	        	p_function();
	        }
	    });   
	}
	static send_socket(p_url, p_param, p_funtion,uuid){
		console.log('send_socket');
		p_param.br=p_url;
		var ws_stomp  = new SockJS("/ws-stomp");
		var stomp_client = Stomp.over(ws_stomp)
		var header = {UUID : uuid}			
		p_param = PjtUtil.saveApiLog(p_param.br,p_param,uuid);
		function send(){
				//전송
				var p_p=JSON.stringify(p_param) ; //json을 string 으로 변환
				//stomp_client.send('/socketApi',header,p_p);
				stomp_client.send('/socketApiToMe',header,p_p);
				
				//받기
				//stomp_client.subscribe('/topic/message',function (msg){  --전체 구독시
				stomp_client.subscribe('/user/topic/message',function (msg){   //user 구독시
					console.log('aaa',msg);
					/*
					성공,실패를 알고 보내줘야 하는데 일단 무시하자
					안나오면 프로그래머가 보면되지..
					*/

					if(p_funtion){
						var tmp = JSON.parse(msg.body);
						console.log(tmp);
						p_funtion(tmp);
					}

					stomp_client.disconnect()
					ws_stomp.close();
				});
		}	
		stomp_client.connect(header,function(frame){
			console.log("Info: connected stomp.");
			console.log(frame)
			send();
		})

		ws_stomp.onclose = function(event) {
			console.log('Info: connection closed.');
		}

		ws_stomp.onerror = function(err) {
			console.log('Info: Error.', err);
		}
    }
	

}

