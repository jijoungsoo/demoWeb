<%@ page import="java.util.* "%>
<%@ page import="com.example.demo.cm.ctrl.*" %>
<%@ page import="com.example.demo.utils.*" %>

<%
	HashMap<String, String> hm = (HashMap<String, String>) request.getAttribute("req_hm");
	String UUID = (String) hm.get("UUID");
	String SEQ = (String) hm.get("SEQ");
	
	//uuid하고 seq로  서버 세션에 있는 값가지고 온다.
	Queue<MsgDebugInfo> que=(Queue<MsgDebugInfo>)session.getAttribute("UUID_DEBUG_LOG");
	MsgDebugInfo gl_tmp=null;
    Iterator<MsgDebugInfo> it= que.iterator();
    while(it.hasNext()) {
        MsgDebugInfo tmp = it.next();
        if(tmp.getUUID().equals(UUID) && String.valueOf(tmp.getSEQ()).equals(SEQ)) {
            gl_tmp=tmp;
            break;
        }
    }
%>	
<div class="border border-primary">
 	<div class="mb-3 row">
    <label for="staticEmail" class="col-sm-2 col-form-label">UUID</label>
    <div class="col-sm-10" style="text-align:left;">
      <%=UUID %>
    </div>
  </div>
  <div class="mb-3 row">
    <label for="staticEmail" class="col-sm-2 col-form-label">SEQ</label>
    <div class="col-sm-10" style="text-align:left;">
      <%=SEQ %>
    </div>
  </div>
  <div class="mb-3 row">
    <label for="inputPassword" class="col-sm-2 col-form-label">Br</label>
    <div class="col-sm-10" style="text-align:left;">
      <%=gl_tmp.getBr() %>
    </div>
  </div>
  <div class="mb-3 row">
    <label for="inputPassword" class="col-sm-2 col-form-label">InPut</label>
    <div class="col-sm-10">
    	<pre style="text-align:left;"><%=PjtUtil.jsonBeautifier(gl_tmp.getIN_DATA_JSON()) %></pre>
    </div>
  </div>
  <div class="mb-3 row">
    <label for="inputPassword" class="col-sm-2 col-form-label">OutPut</label>
    <div class="col-sm-10">
    	<pre style="text-align:left;"><%=PjtUtil.jsonBeautifier(gl_tmp.getOUT_DATA_JSON()) %></pre>
    </div>
  </div>
      
</div>
