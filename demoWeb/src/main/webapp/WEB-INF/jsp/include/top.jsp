﻿<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><!doctype html>
<html lang="en">

<head>
	<meta charset="UTF-8">
	<title>Layout Manager</title>
	<script>
    /*이건 공통적용인데 spring security로 보낼때 모두 체크해야하므로 !! 넣어준다.*/
    var csrf_headerName = '${_csrf.headerName}'; 
    var csrf_parameterName = '${_csrf.parameterName}';
	var csrf_token = '${_csrf.token}';
	/*이거 ajax쪽에 넣었다.*/
	</script>
	<script src="/webjars/jquery/3.5.1/jquery.min.js"></script>
	<script src="/webjars/jquery-ui/1.12.1/jquery-ui.min.js"></script>
	<link   href="/webjars/jquery-ui/1.12.1/jquery-ui.min.css" rel="stylesheet" >
	<script src="/webjars/bootstrap/5.0.0-beta1/js/bootstrap.min.js"></script>
	<link   href="/webjars/bootstrap/5.0.0-beta1/css/bootstrap.min.css" rel="stylesheet">
	<!-- 깉은 복사를 하려고 사용한 라이브러리   https://www.jsdelivr.com/package/npm/lodash  -->
	<script src="/webjars/lodash/4.17.15/lodash.js"></script>
	
		<!--select box js component-->
	<link   href="/webjars/font-awesome/5.15.1/css/all.min.css" rel="stylesheet" >
	<script src="/webjars/font-awesome/5.15.1/js/all.min.js"></script>
	
	<script src="/webjars/sockjs-client/dist/sockjs.min.js"></script>
	<script src="/webjars/stomp-websocket/2.3.3-1/stomp.min.js"></script>
	
	<script src="/webjars/handlebars/4.7.6/handlebars.min.js"></script>

	<script type="text/javascript">
		window.lm = { "config": {}, "container": {}, "controls": {}, "errors": {}, "items": {}, "utils": {} };
	</script>
	<link rel="stylesheet" type="text/css" href="/src/goldenlayout-1.5.9/goldenlayout-base.css" />
	<!--link rel="stylesheet" type="text/css" href="/src/goldenlayout-1.5.9/goldenlayout-light-theme.css"-->
	<link rel="stylesheet" type="text/css" href="/src/goldenlayout-1.5.9/goldenlayout-dark-theme.css" />
	<script type="text/javascript" src="/src/goldenlayout-1.5.9/goldenlayout.js"></script>

<!--axisjs  http://ax5.io/ax5ui-formatter/-->
<script type="text/javascript" src="/src/ax5core/ax5core.min.js"></script>
<link rel="stylesheet" type="text/css" href="/src/ax5dialog/ax5dialog.css" />
<script type="text/javascript" src="/src/ax5dialog/ax5dialog.min.js"></script>
<!-- 로딩시에 페이지를 로딩할것이다. -->

<link rel="stylesheet" type="text/css" href="/src/ax5mask/ax5mask.css" />
<script type="text/javascript" src="/src/ax5mask/ax5mask.min.js"></script>	
<!-- data input  -->
<link rel="stylesheet" type="text/css" href="/src/ax5formatter/ax5formatter.css" />
<script type="text/javascript" src="/src/ax5formatter/ax5formatter.min.js"></script>
<script type="text/javascript" src="/src/ax5binder/ax5binder.min.js"></script>
<!-- layout 설정 -->
<link rel="stylesheet" type="text/css" href="/src/ax5layout/ax5layout.css" />
<script type="text/javascript" src="/src/ax5layout/ax5layout.min.js"></script>

<link rel="stylesheet" href="/src/tui.time-picker-2.0.3/dist/tui-time-picker.css">
<script src="/src/tui.time-picker-2.0.3/dist/tui-time-picker.js"></script>

<link rel="stylesheet" href="/src/tui.context-menu-2.1.8/dist/tui-context-menu.css">
<script src="/src/tui.context-menu-2.1.8/dist/tui-context-menu.js"></script>


<link rel="stylesheet" href="/src/tui.date-picker-4.1.0/dist/tui-date-picker.css">
<script src="/src/tui.date-picker-4.1.0/dist/tui-date-picker.js"></script>

<link rel="stylesheet" href="https://uicdn.toast.com/tui.pagination/latest/tui-pagination.css" />
<script src="https://uicdn.toast.com/tui.pagination/latest/tui-pagination.js"></script>
<link rel="stylesheet" href="https://uicdn.toast.com/grid/v4.16.1/tui-grid.css" />
<script src="https://uicdn.toast.com/grid/v4.16.1/tui-grid.js"></script>
<!-- 시간관련 함수 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js" integrity="sha512-qTXRIMyZIFb8iQcfjXWCO8+M5Tbc38Qi5WzdPOYZHIlZpzBHG3L3by84BBBOiRGiEb7KKtAOAs5qYdUiZiQNNQ==" crossorigin="anonymous"></script>

<link rel="stylesheet" href="/src/metismenujs-3.0.6/metisMenu.css">
<script src="/src/metismenujs-3.0.6/metisMenu.js"></script>




<link rel="stylesheet" type="text/css" href="/src/common.css" />
<link rel="stylesheet" type="text/css" href="/src/test.css" />
<link rel="stylesheet" type="text/css" href="/src/mm-vertical.css" />
<script src="/src/js/util/ax_grid_mngr.js"></script>
<script src="/src/js/util/timepicker_mngr.js"></script>

<script src="/src/js/tui-grid-renderer/imageRenderer.js"></script>
<script src="/src/js/tui-grid-renderer/commaRenderer.js"></script>
<script src="/src/js/tui-grid-renderer/commaStRenderer.js"></script>
<script src="/src/js/tui-grid-renderer/dateRenderer.js"></script>
<script src="/src/js/tui-grid-renderer/datetimeRenderer.js"></script>
<script src="/src/js/tui-grid-renderer/buttonRenderer.js"></script>
<script src="/src/js/tui-grid-renderer/colorCellRenderer.js"></script>


<!--upload https://github.com/danielm/uploader -->
<!--https://danielmg.org/demo/java-script/uploader/basic -->
<link href="/src/uploader-1.0.2/dist/css/jquery.dm-uploader.min.css" rel="stylesheet">
<script src="/src/uploader-1.0.2/dist/js/jquery.dm-uploader.min.js"></script>
<script src="/src/uploader-1.0.2/dist/js/ui-main.js"></script>
<script src="/src/uploader-1.0.2/dist/js/ui-multiple.js"></script>
<script src="/src/uploader-1.0.2/dist/js/ui-single.js"></script>

<!-- https://github.com/fengyuanchen/viewerjs  -->
<link href="/src/viewerjs-1.9.0/dist/viewer.min.css" rel="stylesheet">
<script src="/src/viewerjs-1.9.0/dist/viewer.min.js"></script>



<script src="/src/js/util/Message.js"></script>
<script src="/src/js/util/popup_mngr.js"></script>
<script src="/src/js/util/inline_popup_mngr.js"></script>
<script src="/src/js/util/ajax_mngr.js"></script>
<script src="/src/js/util/tui_grid_mngr.js"></script>
<script src="/src/js/util/progress_mngr.js"></script>
<script src="/src/js/util/selectbox_mngr.js"></script>
<script src="/src/js/util/form_mngr.js"></script>
<script src="/src/js/util/file_mngr.js"></script>
<script src="/src/js/util/app_mngr.js"></script>
<script src="/src/js/util/pgmPage_mngr.js"></script>
<script src="/src/js/util/pjtutil_mngr.js"></script>
<script src="/src/js/util/metismenu_mngr.js"></script>
<script src="/src/js/util/excel_mngr.js"></script>
<script src="/src/js/util/tab_mngr.js"></script>
<script src="/src/js/util/child_mngr.js"></script>




<!--script src="https://cdn.ckeditor.com/ckeditor5/25.0.0/classic/ckeditor.js"></script-->
<script src="https://cdn.ckeditor.com/ckeditor5/25.0.0/decoupled-document/ckeditor.js"></script>
  <link rel="stylesheet" href="/src/chosen_v1.8.7/chosen.css">
  <script src="/src/chosen_v1.8.7/chosen.jquery.js" type="text/javascript" charset="utf-8"></script>
</head>
<body>
