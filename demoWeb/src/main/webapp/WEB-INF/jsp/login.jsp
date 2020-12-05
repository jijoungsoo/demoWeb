<%@ include file="/WEB-INF/jsp/include/simple_top.jsp" %>
<!--  include 참고
https://yongblog.tistory.com/26
 -->
<login class="login">
	<form method="post" name="frm_login" id="frm_login">
	
		<label>id : <input type="text" name="userId" /></label><br />
		<label>pwd : <input type="password" name="userPwd" /></label><br />
		<input type="submit" value="로그인" />
       </form>
</login>
<%@ include file="/WEB-INF/jsp/include/simple_bottom.jsp" %>