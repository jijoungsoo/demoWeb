<%@ include file="/WEB-INF/jsp/include/simple_top.jsp" %>
<!--  include 참고
https://yongblog.tistory.com/26
 -->
 <%
 	String userId 	= request.getAttribute("userId").toString();
 	String userPwd  = request.getAttribute("userPwd").toString();
 	String autoLoginYn  = request.getAttribute("autoLoginYn").toString();
 %>
 <div id="app">
	 <form class name="binder-form" onsubmit="return false;" style="border: 1px solid #ccc;padding: 10px;border-radius: 10px;width:300px;margin:100px auto 0 auto">
	    <div class="form-group">
	        <label>아이디</label>
	        <input type="text" class="form-control" data-ax-path="userId">
	    </div>
	    <div class="form-group">
	        <label>PWD</label>
	        <input type="password" class="form-control" data-ax-path="userPwd">
	    </div>
	    <div class="checkbox">
	        <label>
	            <input type="checkbox" data-ax-path="autoLoginYn" value="Y">
	            자동로그인
	        </label>
	        <button class="btn btn-default" data-btn="login">로그인</button>
	    </div>
	</form>
</div>

<script type="text/javascript">
$(function () {
	var myModel = new ax5.ui.binder();
    myModel.setModel({
        userId      : "<%=userId%>",
        userPwd     : "<%=userPwd%>",
        autoLoginYn : "<%=autoLoginYn%>",
    }, $(document["binder-form"]));
    
    $('[data-btn]').click(function () {
		var act = this.getAttribute("data-btn");
        switch (act) {
            case "login":
				var data = myModel.get();
				console.log(data);
				//var param =JSON.stringify(data);
				  var param = {
			    	      userId		: data.userId,
			    	      userPwd		: data.userPwd,
			    	      autoLoginYn	: data.autoLoginYn,
			    	      ${_csrf.parameterName}:'${_csrf.token}'
				  };
                Message.confirm("로그인하시겠습니까?", function(data){
					$.ajax({
						type: "post",
					    url: "/doLogin", /*이게 로그인 처리로 이동이 안되었다. */
					    contentType: "application/x-www-form-urlencoded; charset=UTF-8",
					    data: param,    
					    /*이거 동작한다.  -- https://hyunsangwon93.tistory.com/28*/
						beforeSend : function(xhr) { 
							xhr.setRequestHeader(csrf_headerName, csrf_token);
					    },
					    success: function(data) {
					    	console.log(data);
					        if(data) {
						    	if(data.code==="999"  /*실패*/)  {
							    	Message.alert(data.message);
							    	return;
							    } else {
							    	Message.alert("로그인 되었습니다.",function (data){
							    		window.location.href="/";
								    });
							    	return;
							    }
					        }
					    },
					    error: function(e){
					    	Message.alert("로그인에 실패하였습니다.");
					    }
					});
			  	});
				break;
        }
    });
});
</script>
<%
  /*
  		자동로그인이 내가 생각했던 과거에 쿠키로 사용자ID와 비밀번호를 남겨서 로그인을 시도하는 그런것이 아니라 패턴이 있었다.
  		
  		참고는 https://codevang.tistory.com/274 이사이트다.
  		스프링에서 제공해주는 remember me 라는 기능을 익혀보자.
  		이거 좋다.
  		천천히 해보자. 깉다.
  		스프링에 있는걸 내가 다시 구현할 필요는 없고 설명을 보았을때 나보다 훨씬 깊다.
  
  		하지만 일단 쿠키로 한거 먼저 해놓자.
  
  */

%>
<%@ include file="/WEB-INF/jsp/include/simple_bottom.jsp" %>