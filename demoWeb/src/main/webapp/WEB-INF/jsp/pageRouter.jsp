<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/include/inner_top.jsp" %>
<%	String pgmId = (String) request.getAttribute("pgmId");
	String uuid = (String) request.getAttribute("uuid");
	String pgmLink = (String) request.getAttribute("pgmLink");
%>
<%
//이방식은 정적으로 컴파일 되기 때문에 가변적으로 변할수없음.
//@ include file="/WEB-INF/jsp/CM_0100(프로그램관리).html" 
%>
<%
/*원래의 JSP 에 다른 JSP 를 포함. 전환되는 것이 아니고 포함되는 것.
: 원래의 JSP 가 가지고 있던 request 와 response 개체를 사용하지 않고 null 값으로 새로 생성.
  만약 원래의 JSP 에 파라미터가 있었다면 request.getParameter("변수명") 으로 호출하면 그 값이 null 이 됨
  출처: https://jsp-making.tistory.com/166 [JSP 요리]
  
  이방식도 파라미터를 전달할 방법이 없어 제외
*/
// pageContext.include("/cities/" + (String) request.getAttribute("country_code") + ".jsp"); 

//html파일이 안잃혀진다.  include file은 되었는데.. 가변이 안되고....
//html 확장자를 빼버리고 ui.jsp로 파일명을 바꾸자.!!
%>
<div id="<%=uuid%>">
	<jsp:include page="/WEB-INF/jsp/${pgmLink}.ui.jsp" flush="true" >
	  <jsp:param name="pgmId" value="<%=pgmId%>"/>
	  <jsp:param name="uuid" value="<%=uuid%>"/>
	  <jsp:param name="pgmLink" value="<%=pgmLink%>"/>
	</jsp:include>
	<jsp:include page="/WEB-INF/jsp/${pgmLink}.jsp" flush="true" >
	  <jsp:param name="pgmId" value="<%=pgmId%>"/>
	  <jsp:param name="uuid" value="<%=uuid%>"/>
	  <jsp:param name="pgmLink" value="<%=pgmLink%>"/>
	</jsp:include>
</div>
<%@ include file="/WEB-INF/jsp/include/inner_bottom.jsp" %>