﻿<%@ include file="/WEB-INF/jsp/include/top.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ page import="java.util.*"%>


<style>
    html, body {
        padding: 0;
        height: 100%;
        overflow: hidden;
    }
</style>


<div data-ax5layout="ax1" data-config='{layout:"dock-panel"}' style="height: 100%;border:0px solid #ccc;background-color:#212529">
    <div data-dock-panel='{dock:"top", split:true, height: 60, maxHeight: 300}'>
        <div style="height:100%;">
			<div style="width:100%;height:60px;">
				          	<sec:authentication var="user" property="principal" />
							<sec:authorize access="isAuthenticated()">
							<login class="login" style="color:000">
								<br />
								${user.username}(${user.userNm})님
								
							</login>
							</sec:authorize>			
				<nav class="navbar navbar-expand-lg navbar-dark bg-dark" style="float:left;width: calc(100% - 200px);">
				  <div class="container-fluid">
				    <div class="collapse navbar-collapse" id="navbarSupportedContent">
				      <ul class="navbar-nav me-auto mb-2 mb-lg-0">
<%						ArrayList<HashMap<String, Object>> cmMenuList = (ArrayList<HashMap<String, Object>>) request.getAttribute("cmMenuList");
						for (int i = 0; i < cmMenuList.size(); i++) {
							HashMap<String,Object> hm = cmMenuList.get(i); %>
				        <li class="nav-item">
				          <a class="nav-link" href="javascript:void top_menu_click('MENU_<%=hm.get("MENU_CD") %>')"><%=hm.get("MENU_NM") %></a>
				        </li>
<%						}	%>
				        
				      </ul>
				      <form class="d-flex">
				        <input type="button" name="logOut" id="logOut" value="로그아웃"  class="btn btn-outline-success" />
						<input type="button" name="clearCache" id="clearCache" value="캐시갱신" class="btn btn-outline-success"  />
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
						$( "#clearCache" ).on( "click", function( event ) {
							Message.confirm("캐시를 갱신하겠습니까?",function(data){
								//WebSecurityConfiguration 여기에 로그아웃 주소
								var param =null;
								AjaxMngr.send_post_ajax('/refresh', param, function(data2){
									//console.log(data2);
									Message.alert("캐시가 갱신되었습니다.",function(){
										window.location.href="/";
									});
									  
								});
							}); 
						});
						</script>
				      </form>
				    </div>
				  </div>
				</nav>
			</div>
        </div>
    </div>
    <div data-dock-panel='{dock:"left", split:true, width: 200, minWidth: 50}' style="background-color:#212529">
    	<div id="lnb">
    	<% 
		    /*이 메뉴로 가자!! 고고 
		    https://webclub.tistory.com/368
		    */
		
		
			for (int i = 0; i < cmMenuList.size(); i++) {
				HashMap<String,Object> ONE_DATA_ROW = cmMenuList.get(i);
		%>
		<ul style="margin:0">
			<li ><a href="#none"  id="MENU_<%=ONE_DATA_ROW.get("MENU_CD") %>" ><%=ONE_DATA_ROW.get("MENU_NM") %></a>
			<ul >
				<%   ArrayList<HashMap<String, Object>> TWO_DATA = (ArrayList<HashMap<String, Object>>)ONE_DATA_ROW.get("child");
					 for(int j=0;j<TWO_DATA.size();j++){
					     HashMap<String, Object> TWO_DATA_ROW = TWO_DATA.get(j);
				%>
				<li>
					<a href="#" >
						<%=TWO_DATA_ROW.get("MENU_NM") %>
					</a>
					<ul>
						<%   ArrayList<HashMap<String, Object>> THREE_DATA = (ArrayList<HashMap<String, Object>>)TWO_DATA_ROW.get("child");
							 for(int k=0;k<THREE_DATA.size();k++){
							     HashMap<String, Object> THREE_DATA_ROW = THREE_DATA.get(k);
						%>
						<li class="THREE_DATA"><a href="#" 
								class="js-open-target" 
								data-target="<%=THREE_DATA_ROW.get("PGM_ID") %>" 
								data-title="<%=THREE_DATA_ROW.get("MENU_NM") %>"><%=THREE_DATA_ROW.get("MENU_NM") %></a>
						</li>
						<%	} %>
					</ul>
				</li>
				<%	}	%>
			</ul>
			</li>
		</ul> 
		<%	} %>
		
		</div>
		<div id="footer_search">
			<ul id="footer_menu"></ul>
			<input type="text" id="mySearch" onkeyup="myFunction()" placeholder="Search.." title="Type in a category">
		</div>	
    </div>
    <div data-dock-panel='{dock:"center"}' style="padding: 0px;background-color:#222222">
		<div id="layoutContainer"></div>

    </div>
</div>
<style>
  #lnb li {list-style: none;} a {} 
  #lnb {position: relative;width: 200px;} 
  #lnb > ul {
  maring:0 !important; 
  padding:0;
  } 
  #lnb > ul > li { 
  maring:0 ; 
  padding:0;
  list-style: none;
  } 
  #lnb > ul > li > a {
  display: block;
  padding: 10px 0 10px 14px;				/*1뎁스 패딩*/
  color: #f8f9fa; 
  font-size: 120%;
  background:#000;							/*1단뎁스 색깔*/
  } 
    #lnb > ul > li a:hover {
    color: #f8f9fa;
    background-color: #0b7285;
    } 
    #lnb > ul > li ul {
    	/*display: none;*/
  		padding:0;
  		margin:0;
    }
    #lnb > ul > li > ul > li > a {			/*2단뎁스 색깔*/
    display: block;
    padding: 0 0 14px 14px;				/*2단뎁스 패딩*/
    color: #inherit; 
    font-size: 110%;
    background: #f5f2ec ;
    } #lnb > ul > li > ul > li > a {		/*2단뎁스 색깔*/
    color: #f8f9fa; 
    background-color: #212529; 
    } 
    #lnb > ul > li > ul li ul {
    display: block;
    padding-bottom: 8px;
    background-color: #343a40;
    } 
    #lnb > ul > li > ul li li a {			/*3단뎁스 색깔*/
    display: block;
    padding: 0 0 10px 14px; 
    color: rgba(255,255,255,.75); 
    background-color: #343a40;
    } 
    #lnb > ul > li > ul > li li a:hover {	/*3단뎁스 색깔*/
    color: #f8f9fa;
    background-color: #0b7285;
    } 
    
    /*출처: https://juve.tistory.com/157 [Forza Juve!]*/
    #footer_search { 
    position: fixed; 
    bottom: 0; 
    width: 200px; 
    }
    
  #footer_search > ul {
  maring:0 !important; 
  padding:0;
  } 
  #footer_search > ul > li { 
  maring:0 ; 
  padding:0;
  list-style: none;
  } 
/*하단 박스 */
  #footer_search > ul > li > a {
  display: block;
  padding: 0 0 10px 14px;				/*1뎁스 패딩*/
  color: #f8f9fa; 
  background:#6610f2;							/*1단뎁스 색깔*/
  } 
  #footer_search > ul > li a:hover {
    color: #f8f9fa;
    background-color: #6610f2;
  } 
  
  ol, ul {
    margin-bottom: 0;
  }
</style>
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
	//new MetisMenu('#menu1',{expand:true/*한번 열리면 모두 펼치기 */});
});
$(window).resize(function () {
	//console.log(myLayout);
	//console.log($(window).width());
	//console.log($(window).height());
	myLayout.updateSize($(window).width()-200, $(window).height());
});
    jQuery(document.body).ready(function () {
        jQuery('[data-ax5layout="ax1"]').ax5layout({
            onResize: function () {
                //console.log(this.$target);
                //console.log(this);
            }
        });
        return;
    });



/*출처: https://webclub.tistory.com/368 [Web Club]*/

(function($){ 
var lnbUI  = { 
		click : function (target, speed) { 
			var _self = this, 
			$target = $(target); 
			_self.speed = speed || 300; 

			$target.each(function(){ 
				if(findChildren($(this))) {
					return; 
				} 
			}); 

			function findChildren(obj) { 
				return obj.find('> ul').length > 0; 
			} 

			$target.on('click','a', function(e){ 
				e.stopPropagation(); 
				var $this = $(this), 
				$depthTarget = $this.next(), 
				$siblings = $this.parent().siblings(); 

				$this.parent('li').find('ul li')
				$siblings.removeClass('on'); $siblings.find('ul').slideUp(250); 
				if($depthTarget.css('display') == 'none') { 
					$depthTarget.slideDown(_self.speed); 
				} else { 
					$depthTarget.slideUp(_self.speed);
				} 
			}) 
		}, 
	}; // Call lnbUI 
	$(function(){ 
		lnbUI.click('#lnb li', 300) 
	}); 
}(jQuery));

function top_menu_click(el_id){
	$('#'+el_id).trigger('click');
}
/*https://www.w3schools.com/howto/tryit.asp?filename=tryhow_js_search_menu*  */
function myFunction() {
  var input, filter, ul, li, a, i;
  input = document.getElementById("mySearch");
  filter = input.value.toUpperCase();
  ul = document.getElementById("lnb");
  li = ul.querySelectorAll('[class="THREE_DATA"]');
  //li = ul.getElementsByTagName("li");

  footer_menu  = document.getElementById("footer_menu");
  //console.log(li)
   
  if(filter==''){
	  $("#footer_menu").empty();  //전체를 지우고
	  return;
  }
  $("#footer_menu").empty();  //전체를 지우고
  for (i = 0; i < li.length; i++) {
    a = li[i].getElementsByTagName("a")[0];
    if(a!=undefined){
    	if (a.innerHTML.toUpperCase().indexOf(filter) > -1) {
     	    var tmp = li[i].cloneNode(true);
     		footer_menu.appendChild(tmp)
     	}
    }
  }
}
</script>
<%@ include file="/WEB-INF/jsp/include/bottom.jsp" %>