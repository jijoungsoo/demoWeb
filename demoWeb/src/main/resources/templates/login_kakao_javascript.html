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
		<div class="checkbox">
			<a href="javascript:void kakaoLogin();">
				<img src="/src/kakao_login/ko/kakao_login_medium_wide.png" />
				</a>
        
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
<script src="http://developers.kakao.com/sdk/js/kakao.js"></script>
<script type='text/javascript'>

console.log(Kakao);
Kakao.init('d65481c09c9c5304fcc317474dd07991');
//자바스크립트 키를 입력해야한다.

/* 이게 있어서 자꾸 페이지가 이동이되었다.  아래는 입력되면 안된다.
로그인 되어있으면 이동하려고 해서 무한 반복이동이 된다.
Kakao.Auth.authorize({
  redirectUri: 'http://localhost:8090/login'
});
*/
/*
프로필 정보(닉네임/프로필 사진)     ==>profile				 [필수동의]
카카오톡 채널 추가 상태 및 내역     ==>plusfriends           [권한없음]
카카오계정(이메일)                 ==>account_email			[선택동의]
성별                              ==>gender				   [선택동의]
연령대                            ==>age_range			   [선택동의]
카카오 서비스내 친구목록(즐겨찾기 친구포함)	==>friends		  [선택동의]
생일							  ==>birthday		       [선택동의]--MMDD
출생 연도 						  ==>birthyear		        [권한없음]
카카오계정(전화번호)               ==>phone_number		     [권한없음]
CI(연계정보)		              ==>account_ci		        [권한없음]
배송지정보(수령인명, 배송지 주소, 전화번호) ==>shipping_address [권한없음]


카카오스토리 글 목록				==>story_read			[선택동의]
카카오스토리 글 작성				==>story_publish		[선택동의]
카카오톡 메시지 전송				==>talk_message			[선택동의]


*/
function kakaoLogin(){
	window.Kakao.Auth.login({
		scope:'profile, account_email,gender,age_range,birthday',
		success: function(authObj){
			console.log('authObj');
			console.log(authObj);

			window.Kakao.API.request({
				url: '/v2/user/me',
				success: res=>{
					console.log('res');
					console.log(res);
					const k = res.kakao_account;
					console.log('k');
					console.log(k);

					var param= [{
					id : res.id,
					connected_at : res.connected_at,
					age_range : k.age_range,
					birthday : k.birthday,
					birthday_type : k.birthday_type,
					email : k.email,
					birthday : k.birthday,
					nickname : k.profile.nickname,
					profile_image_url : k.profile.profile_image_url,
					thumbnail_image_url : k.profile.thumbnail_image_url,
					}];

					console.log(param);

					/*카카오 로그인이 되었으면 이정보를 가지고 회원정보도 갱신해야할것 같다.
				      회원정보가 계속 바뀔수 있으므로!!

					  와 이정도면 rest로  인증하는게 더 낫겠다.
					*/

					$.ajax({
						type: "post",
					    url: "/kakaoLogin", /*이게 로그인 처리로 이동이 안되었다. */
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



				},
				fail: function(err){
					console.log('fail',err);
				}
			});
		},
		fail: function(err){
			console.log('fail',err);
		}
	});
}
</script>  
<%@ include file="/WEB-INF/jsp/include/simple_bottom.jsp" %>