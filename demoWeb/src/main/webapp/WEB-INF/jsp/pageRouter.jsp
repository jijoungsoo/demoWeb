<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ include file="/WEB-INF/jsp/include/inner_top.jsp" %>
<%	
	String parentUuid = (String) request.getAttribute("parentUuid");
    String pgmId = (String) request.getAttribute("pgmId");
	String uuid = (String) request.getAttribute("uuid");
	String dirLink = (String) request.getAttribute("dirLink");
	String pgmLink = (String) request.getAttribute("pgmLink");
	String result = (String) request.getAttribute("result");
	String debug = (String) session.getAttribute("debug");
	HashMap<String, String> hm = (HashMap<String, String>) request.getAttribute("req_hm");

	if(result.equals("ok"))  {
		System.out.println(pgmLink);
		System.out.println(pgmLink);

%>
<div id="<%=uuid%>" parent_uuid='<%=parentUuid%>' pgm_id="<%=pgmId%>" uuid="<%=uuid%>" >
	<jsp:include page="/WEB-INF/jsp/${dirLink}/${pgmLink}.ui.jsp" flush="true" >
	  <jsp:param name="uuid" value="<%=uuid%>"/>
	  <jsp:param name="dirLink" value="<%=dirLink%>"/>
	  <jsp:param name="pgmLink" value="<%=pgmLink%>"/>
	  <jsp:param name="hm" value="<%=hm%>"/>
	</jsp:include>
	<jsp:include page="/WEB-INF/jsp/${dirLink}/${pgmLink}.jsp" flush="true" >
	  <jsp:param name="uuid" value="<%=uuid%>"/>
	  <jsp:param name="dirLink" value="<%=dirLink%>"/>
	  <jsp:param name="hm" value="<%=hm%>"/>
	</jsp:include>
	<%	if(debug.equals("Y") && !pgmId.equals("CM_1800") ) {  %>
		<div id="<%=uuid%>_debug_log" style="width:300px;height:200px;border: solid 2px red;z-index:999;background:#efefef;color:#000;margin-bottom:10px;overflow:auto;text-align:left;">
			<ul id="<%=uuid%>_debug_log_ul"><%=pgmLink%>
			</ul>
		</div>
		<div id="<%=uuid%>_draggable" style="width:80px;height:30px;border:solid 2px red;position: relative;z-index:999;background:#efefef;color:#000;">
			<div style="position: absolute;bottom: 0;width: 80px;">
			<a href="#" id="<%=uuid%>_debug_bottom_a"><i class="fas fa-eye"></i></a>
			</div>
		</div>
	<%	} %>
</div>

<%	} else { %>
	<div id="<%=uuid%>"><%=result %></div>		
<%	}  %>
<%@ include file="/WEB-INF/jsp/include/inner_bottom.jsp" %>