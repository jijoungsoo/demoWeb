<%@ include file="/WEB-INF/jsp/include/simple_top.jsp" %>
<!--  include 참고
https://yongblog.tistory.com/26
 -->
<div id="app">
	<el-container>
	  <el-main>
		<el-form ref="form" :model="form" label-width="120px">
		  <el-form-item label="아이디">
	        <el-input v-model="form.userId"></el-input>
	      </el-form-item>
	      <el-form-item label="PWD">
	        <el-input v-model="form.userPwd" placeholder="Please input password" show-password></el-input>
	      </el-form-item>
		  <el-form-item>
		    <el-button type="primary" @click="onSubmit"
		     v-loading.fullscreen.lock="fullscreenLoading"
		    >로그인</el-button>
		  </el-form-item>
		</el-form>
	  </el-main>
	</el-container>
	
</div>
<style>
  .el-main {
    
    color: #333;
    text-align: center;
    line-height: 160px;
    width: 400px;
  }
  .el-container {
    width: 402px;
    margin: 100px auto;
    border: solid 1px #000
  }
</style>    
<script>
var app = new Vue({
	  el: '#app',
	  data: function() {
	    return { 
	      visible: false,
	      form: {
	        userId: '',
	        userPwd: ''        
	      },
	      fullscreenLoading: false 
	    }
	  },
	  methods: {
	    onSubmit() {
	      this.fullscreenLoading = true;
	      console.log('submit!');
		  let tmp=this;
	      var param = {
	    	      userId: this.form.userId,
	    	      userPwd: this.form.userPwd,
	    	      ${_csrf.parameterName}:'${_csrf.token}'
		  };
		  
		  /*jpa호출이아니고  web에 프로젝트 내부 호출이기에 일반 ajax를 써야한다.
	      send_post_ajax('login', param, function (data) {
		      alert('11');
		      tmp.fullscreenLoading = false;  프로그래스 제거
		      alert('22');
		      if(data){
		    	  
		      }
	        });
	        */
	      

	      /*이건 공통적용인데 spring security로 보낼때 모두 체크해야하므로 !! 넣어준다.*/
	      $.ajaxPrefilter(function (options) { 
		      var headerName = '${_csrf.headerName}'; 
		      var token = '${_csrf.token}'; 
		      	if (options.method === 'POST') { 
			      options.headers = options.headers || {}; 
			      options.headers[headerName] = token; 
			    } 
		      });

	        $.ajax({
	          type: "post",
	          url: "/doLogin", /*이게 로그인 처리로 이동이 안되었다. */
	          data: param,    
	          /*json 전송하면 안되고 post전송이어야한다. 
		      post 방식으로 보낼때 주의할점은 content-type을 application-json으로 보내면 안된다는 점이다.
			  파라미터 이름도 따로 설정하지 않으면 username, password로 맞춰주어야한다.	      
		      https://csy7792.tistory.com/265

		      이게 문제가 되었다 api 서버를 호출할때 CSRF가 또 문제가 된다.
			  */
	          success: function(data) {
	        	  console.log(data);
	        	  tmp.fullscreenLoading = false; // 프로그래스 제거
		          if(data) {
			          if(data.code==="999"  /*실패*/)  {
			        	  app.$alert(data.message, {
			                  confirmButtonText: 'OK'
			                  /*
			                  ,callback: action => {
			                    this.$message({
			                      type: 'info',
			                      message: `action: ${ action }`
			                    });
			                  */
			        	  });
				      } else {
					      app.$alert("로그인 되었습니다.", {
			                  confirmButtonText: 'OK'
			                  ,callback: action => {
			                    window.location.href="/";
			                  }
					      });				                  
				      }
		          }
	          },
	          error: function(e){
	        	  tmp.fullscreenLoading = false; // 프로그래스 제거
	              alert('error!!');
	          }
	      });
	    }
	  }
	})






</script>
<%@ include file="/WEB-INF/jsp/include/simple_bottom.jsp" %>