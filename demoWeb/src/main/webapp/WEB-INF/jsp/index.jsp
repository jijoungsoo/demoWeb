<%@ include file="/WEB-INF/jsp/include/top.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ page import="java.util.*"%>
<sec:authentication var="user" property="principal" />
<sec:authorize access="isAuthenticated()">
<login class="login">
	
	${user.username}<br />
	${user.email}<br />
	${user.userNm}<br />

		
	<input type="submit" name="logOut" id="logOut" value="로그아웃" />
	
	<script>
	$( "#logOut" ).on( "click", function( event ) {
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
	});
	</script>
</login>
</sec:authorize>
<nav class="sidebar-nav">
	<ul class="metismenu" id="menu1">
<%
	ArrayList<HashMap<String, Object>> cmMenuList = (ArrayList<HashMap<String, Object>>) request.getAttribute("cmMenuList");
	for (int i = 0; i < cmMenuList.size(); i++) {
		HashMap<String,Object> hm = cmMenuList.get(i);
%>
		<li  <% if (i==0) { %> class="mm-active" <% } %> >
			<a class="has-arrow" href="#" aria-expanded="true">
				<span class="fa fa-fw fa-github fa-lg"></span>
				<%=hm.get("menu_nm") %>
			</a>
			<ul class="mm-collapse">
				<% 	ArrayList<HashMap<String, Object>> subMenuList= (ArrayList<HashMap<String, Object>>) hm.get("child");
				 	for(int j=0;j<subMenuList.size();j++){
				 		HashMap<String,Object> subHm = subMenuList.get(j);
				%>
				<li><a href="#" 
						class="js-open-target" 
						data-target="<%=subHm.get("pgm_id") %>" 
						data-title="<%=subHm.get("menu_nm") %>"><%=subHm.get("menu_nm") %></a>
				</li>
				<% 		
				 	}
				%>
			</ul>
		</li>
<%	} %>		
	</ul>
</nav>
<div id="layoutContainer"></div>
<script>
$(function () {
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
			showMaximiseIcon: false /*우측 상단 최대화 의미 없음 */,
			showCloseIcon: false /*우측 상단 닫기표시 */,
		},
		content: [
			{
				width: 100,
				type: "stack",
				id: "stack_window",
				/*
				content: [
					{
						type: "component",
						title: "Market",
						componentName: "html",
						id: "html",
					},
					{
						type: "component",
						title: "Performance",
						componentName: "html2",
						id: "html2",
					},
				],*/
			},
		],
	};
	
	//window.myLayout = new GoldenLayout( config,  );
	/*특정영역에 붙이기 */
	/*https://golden-layout.com/tutorials/dynamically-adding-components.html */
	/*이렇게 했을때 문제점 layoutContainer에 높이를 몰라서 height 0으로 잡혀 컨텐츠 영역이 안나타난다. */
	window.myLayout = new GoldenLayout(config, $("#layoutContainer"));
	/*
	myLayout.registerComponent("pgm_mngr", function (container, state) {
		container.getElement().load(container._config.pg);
	});
	*/
	
	<%	ArrayList<HashMap<String, Object>> cmPgmList = (ArrayList<HashMap<String, Object>>) request.getAttribute("cmPgmList");
		for (int i = 0; i < cmPgmList.size(); i++) {
			HashMap<String,Object> hm = cmPgmList.get(i);
	%>
	PgmPageMngr.addPgmPageMap("<%=hm.get("PGM_ID")%>","<%=hm.get("PGM_NM")%>");
	myLayout.registerComponent("<%=hm.get("PGM_ID")%>", function (container, state) {
		var p_param = {
			uuid : container._config.id
		}
		//container.getElement().load(container._config.pg);
		//파라미터를 고정해서 던져야 하는데.. 
		AjaxMngr.get_page_ajax(container.getElement(),container._config.pg,p_param);
		
		container.on("open",function() {
			/*
			console.log("-open--:start");
			console.log("-open--container._config.componentName=>"+container._config.componentName);
			console.log("-open--container._config.pg=>"+container._config.pg);
			console.log("-open--container._config.id=>"+container._config.id);
			console.log("-open--reqMap=>");
			console.log(reqMap);
			console.log("-open--pgmMap=>");
			console.log(pgmMap);
			console.log("-open--:end");
			*/
		});
	
	});
	<%	} %>
	
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
	
	$(".js-open-target").on("click", function (e) {
		e.preventDefault();
		var target = $(this).data("target");
		//var title = $(this).data("title");
		PgmPageMngr.goOnePage(target);
	});
});

document.addEventListener("DOMContentLoaded", function (event) {
	new MetisMenu('#menu1',{expand:true/*한번 열리면 모두 펼치기 */});
});
</script>	
<%@ include file="/WEB-INF/jsp/include/bottom.jsp" %>