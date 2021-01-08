<%@ page import="java.util.HashMap "%>
<%
	HashMap<String, String> hm = HashMap<String, String> request.getAttribute("req_hm");
	String UUID = (hashMap) hm.get("UUID");
	String SEQ = (String) hm.get("SEQ");
%>	
<div>
	ddd<%=UUID %>//<%=SEQ %>ccc
</div>
