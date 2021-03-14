<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.*"%>
<%	ArrayList<HashMap<String, Object>> cmMenuList = (ArrayList<HashMap<String, Object>>)  request.getAttribute("cmMenuList");	%>
<%
	String debug = (String) session.getAttribute("debug");	
%>
<script>
AppMngr.debug_console="N";
if("<%=debug%>"=="Y"){
	AppMngr.debug_console="Y";
}
$(document).ready(function(){
	var auth_list=[];
	<sec:authentication var="user" property="principal" />
	<sec:authorize access="isAuthenticated()">
	<c:forEach var="tmp" items="${user.authorities}">
	var tmp = '${tmp}';
	auth_list.push(tmp);
	</c:forEach>
	//auth_list  = '${user.authorities}';
	//console.log(auth_list);
	</sec:authorize>	

	/*상단 메뉴*/
	var left_menu_3depth_list=[];
    var top_menu_item = [] 
    <%	for (int i = 0; i < cmMenuList.size(); i++) {
		HashMap<String,Object> hm = cmMenuList.get(i);	
	%>	top_menu_item.push({MENU_CD : 'MENU_<%=hm.get("MENU_CD") %>' ,MENU_NM : '<%=hm.get("MENU_NM") %>' });
	<%}	%>
	var top_menu = { cmMenuList : top_menu_item };

    var top_menu_template_html = $("#top_menu-template").html();
    var top_menu_template = Handlebars.compile(top_menu_template_html);
	var tmp =top_menu_template(top_menu);
    $("#top_menu").append(tmp);

    /*좌측 메뉴 */
    var left_menu_item = []
    <%	for (int i = 0; i < cmMenuList.size(); i++) {
        HashMap<String,Object> ONE_DATA_ROW = cmMenuList.get(i);
	%>	var one_menu_item = {<%
					%>MENU_CD: 'MENU_<%=ONE_DATA_ROW.get("MENU_CD") %>'<%
					%> ,MENU_NM: '<%=ONE_DATA_ROW.get("MENU_NM") %>',TWO_DATA: [] };
		<%	ArrayList<HashMap<String, Object>> TWO_DATA = (ArrayList<HashMap<String, Object>>)ONE_DATA_ROW.get("_children");
			if(TWO_DATA!=null) {
				for(int j=0;j<TWO_DATA.size();j++){	
		    	HashMap<String,Object>  TWO_DATA_ROW = TWO_DATA.get(j);
		%>var two_menu_item = {<%
		        	%>MENU_CD: '<%=TWO_DATA_ROW.get("MENU_CD") %>'<%
					%> ,MENU_NM: '<%=TWO_DATA_ROW.get("MENU_NM") %>' ,THREE_DATA: [] };
			one_menu_item['TWO_DATA'].push(two_menu_item);<%	
			ArrayList<HashMap<String, Object>> THREE_DATA = (ArrayList<HashMap<String, Object>>)TWO_DATA_ROW.get("_children");
				if(THREE_DATA!=null) {
				    for(int k=0;k<THREE_DATA.size();k++){
				        HashMap<String,Object>  THREE_DATA_ROW = THREE_DATA.get(k);
			%>
			left_menu_3depth_list.push()
			var tmp ={	MENU_CD: '<%=THREE_DATA_ROW.get("MENU_CD") %>' ,MENU_NM: '<%=THREE_DATA_ROW.get("MENU_NM") %>' ,PGM_ID: '<%=THREE_DATA_ROW.get("PGM_ID") %>' ,MENU_NO: '<%=THREE_DATA_ROW.get("MENU_NO") %>' };
			two_menu_item['THREE_DATA'].push(tmp);
			left_menu_3depth_list.push(tmp);
			<%		}
				} 
			}
		}
		%>	left_menu_item.push(one_menu_item);
	<%	}	%>
	var left_menu_template_html = $("#left_menu-template").html();
    var left_menu_template = Handlebars.compile(left_menu_template_html);
	var left_menu = { cmMenuList : left_menu_item };
	//console.log(left_menu);
    var tmp =left_menu_template(left_menu);
	//console.log(tmp);
    $("#left_menu").append(tmp);

    
    var menu_root =[];
    <% 	for (int i = 0; i < cmMenuList.size(); i++) {
    	HashMap<String,Object> ONE_DATA_ROW = cmMenuList.get(i); 
    %> 	
    	menu_root.push('MENU_<%=ONE_DATA_ROW.get("MENU_CD") %>');
    	<% if(i==0) { 
    		%>$('#MENU_<%=ONE_DATA_ROW.get("MENU_CD") %>').show();  //첫번째 것은 display='block' 
    	<% } else { 
    		%>$('#MENU_<%=ONE_DATA_ROW.get("MENU_CD") %>').hide();	//그다음것은 display='none'
    	<% } 
    	}	
    %>
	new MetismenuMngr(menu_root,left_menu_item,left_menu_3depth_list);
	
	//golden layout 자동조절
	$(window).resize(function () {
		myLayout.updateSize($(window).width()-200, $(window).height());
	});
	//doc 너비 자동맞춤	
	jQuery('[data-ax5layout="ax1"]').ax5layout({
	    onResize: function () {
	    }
	});


	var w=document.getElementById("form_top_buttons");
	console.log(w)
	PjtUtil.addEvent(w,"click","input[type=button]",function(el) {
		console.log(w);
		console.log(el);
		switch (el.target.name) {
		case 'stockdataloader':
			Message.confirm("stockdataloader github를 열겠습니까?",function(data){
			  	window.open('https://github.com/jijoungsoo/stockdataloader','stockdataloader');
			}); 
			break;
		case 'marcap':
			Message.confirm("marcap github를 열겠습니까?",function(data){
			  	window.open('https://github.com/FinanceData/marcap','marcap');
			}); 
			break;
			
			
			
		case 'swagger-ui':
			Message.confirm("stockdataloader github를 열겠습니까?",function(data){
			  	window.open('http://localhost:8091/swagger-ui/index.html','swagger-ui');
			}); 
			break;
		
		case 'erd':
			Message.confirm("ERD를 열겠습니까?",function(data){
			  	window.open('https://www.erdcloud.com/','erd');
			}); 
			break;
		case 'actuator':
			Message.confirm("actuator를 열겠습니까?",function(data){
				window.open('/actuator','actuator');
			}); 
			break;
		case 'logOut':
			Message.confirm("로그아웃하시겠습니까?",function(data){
				//WebSecurityConfiguration 여기에 로그아웃 주소
				var param =null;
				AjaxMngr.send_post_ajax('/user/logout', param, function(data2){
					//console.log(data2);
					Message.alert("로그아웃되었습니다.",function(){
						window.location.href="/login";
					});
					  
				});
			}); 
			break;
		
		}
	});

	/*골든레이아웃을 하단으로 내림*/
	var queryParams = getQueryParams();
	var layout = queryParams.layout || "";
	var config = null;
	config = {
		settings: {
			tabOverlapAllowance: 25,
			reorderOnTabMenuClick: false,
			tabControlOffset: 5,
	
			hasHeaders: true /* true인 경우만 위에 텝형태로 보인다. */,
			constrainDragToContainer: false,
			reorderEnabled: true /* true면 탭을 끌고 마우스로 이동 */,
			selectionEnabled: false /*모름*/,
			popoutWholeStack: false /*모름*/,
			blockedPopoutsThrowError: true /*모름*/,
			closePopoutsOnUnload: true /*모름*/,
			showPopoutIcon: true /*새창팝업 */,
			showMaximiseIcon: true /*우측 상단 최대화 의미 없음 */,
			showCloseIcon: false /*우측 상단 닫기표시 */,
		},
		content: [],
	};
	window.myLayout = new GoldenLayout(config, $("#layoutContainer"));
	<%	ArrayList<HashMap<String, Object>> cmPgmList = (ArrayList<HashMap<String, Object>>) request.getAttribute("cmPgmList");
		if(cmPgmList!=null){
			for (int i = 0; i < cmPgmList.size(); i++) {
				HashMap<String,Object> hm = cmPgmList.get(i);
	%>
	PgmPageMngr.addPgmPageMap("<%=hm.get("PGM_ID")%>","<%=hm.get("PGM_NM")%>");
	myLayout.registerComponent("<%=hm.get("PGM_ID")%>", function (container, state) {
		var p_param = {		uuid : container._config.id	}
		AjaxMngr.get_page_ajax(container.getElement(),container._config.pg,p_param);
	});
	<%		}
		}
	%>
	myLayout.init();

	function getQueryParams() {
		var params = {};
		window.location.search
			.replace(/^\?/, "")
			.split("&")
			.forEach(function (pair) {
				var parts = pair.split("=");
				if (parts.length > 1) {
					params[decodeURIComponent(parts[0]).toLowerCase()] = decodeURIComponent(parts[1]);
				}
			});
	
		return params;
	}

});
</script> 