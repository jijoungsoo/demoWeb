<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/include/top.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ page import="java.util.*"%>
<%
	ArrayList<HashMap<String, Object>> cmMenuList = (ArrayList<HashMap<String, Object>>) request.getAttribute("cmMenuList");
	ArrayList<HashMap<String, Object>> cmPgmList = (ArrayList<HashMap<String, Object>>) request.getAttribute("cmPgmList");
%>
<jsp:include page="/WEB-INF/jsp/index.ui.jsp" flush="true" />
<jsp:include page="/WEB-INF/jsp/index.jsp" flush="true" >
	<jsp:param name="cmMenuList" value="<%=cmMenuList %>"/>
	<jsp:param name="cmPgmList" value="<%=cmPgmList %>"/>
</jsp:include>
<%@ include file="/WEB-INF/jsp/include/bottom.jsp" %>