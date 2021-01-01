﻿<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
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
				      <ul class="navbar-nav me-auto mb-2 mb-lg-0" id="top_menu">
<script id="top_menu-template" type="text/x-handlebars-template">
{{#cmMenuList}}
<li class="nav-item">
	<a class="nav-link" href="#" name="top_menu_cd" menu_cd="{{MENU_CD}}">{{MENU_NM}}</a>
</li>
{{/cmMenuList}}
</script>
				      </ul>
				      <form class="d-flex">
				      	<input type="button" name="actuator" id="actuator" value="actuator"  class="btn btn-outline-success" />
				        <input type="button" name="logOut" id="logOut" value="로그아웃"  class="btn btn-outline-success" />
					  </form>
				    </div>
				  </div>
				</nav>
			</div>
        </div>
    </div>
    <div data-dock-panel='{dock:"left", split:true, width: 200, minWidth: 50}' style="background-color:#212529">
	<nav class="sidebar-nav">
		<ul class="metismenu" id='metismenu_fav'>		
				<li><div class="has-arrow" ><a href="#"><span class="fa fa-fw fa-star"></span>줄겨찾기</a></div>
				<ul id='fav_menu'>
				</ul>
		<script id="fav_menu-template" type="text/x-handlebars-template">
{{#favMenuList}}
<li>
	<div>
		<a href="#" class="fav_depth_left"
					fav_no="{{FAV_NO}}"><span class="fa fa-fw fa-star"></span></a>
		<a href="#" class="js-open-target fav_depth_right"
					data-target="{{PGM_ID}}" 
					data-title="{{MENU_NM}}">{{MENU_NM}}</a>
	</div>
</li>
{{/favMenuList}}
	</script>
			</li/>
		</ul>	
		<div id="left_menu">
		</div>
<script id="left_menu-template" type="text/x-handlebars-template">
{{#cmMenuList}}
<ul class="metismenu"  id="{{MENU_CD}}">

	{{#if TWO_DATA}}
	{{#each TWO_DATA}}
	<li  {{#if @flist }} class="mm-active" {{/if }}>
	<div class="has-arrow" ><a href="#" aria-expanded="true">{{MENU_NM}}</a></div>
	<ul class="mm-collapse">
		{{#each THREE_DATA}}
		<li class="THREE_DATA">
		<div>
			<a href="#" 
				class="js-open-target three_depth_left" 
				data-target="{{PGM_ID}}" 
				data-title="{{MENU_NM}}"
				
				>{{MENU_NM}}</a>
			<a href="#"
			class="three_depth_right"
			menu_no="{{MENU_NO}}"
			><i class="fa fa-fw fa-star"></i></a>
		</div>						
		</li>
		{{/each}}
	</ul>
</li>
	{{/each}}
	{{/if }}
</ul>
{{/cmMenuList}}
</script>	
	</nav>
	<div id="footer_search">
		<ul id="footer_menu"></ul>
		<input type="text" id="mySearch" placeholder="Search.." title="Type in a category">
	</div>	
</div>
<div data-dock-panel='{dock:"center"}' style="padding: 0px;background-color:#222222">
	<div id="layoutContainer"></div>
	</div>
</div>
