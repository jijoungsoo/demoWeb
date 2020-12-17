<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><!doctype html>
<html lang="en">

<head>
	<meta charset="UTF-8">
	<title>Layout Manager</title>
	<script type="text/javascript" src="/src/js/jquery-3.5.1/jquery-3.5.1.min.js"></script>
	<script>
    /*이건 공통적용인데 spring security로 보낼때 모두 체크해야하므로 !! 넣어준다.*/
    var csrf_headerName = '${_csrf.headerName}'; 
	var csrf_token = '${_csrf.token}';
	/*이거 ajax쪽에 넣었다.*/
	</script>
	<script type="text/javascript">
		window.lm = { "config": {}, "container": {}, "controls": {}, "errors": {}, "items": {}, "utils": {} };
	</script>
	<link rel="stylesheet" type="text/css" href="/src/goldenlayout-1.5.9/goldenlayout-base.css" />
	<!--link rel="stylesheet" type="text/css" href="/src/goldenlayout-1.5.9/goldenlayout-light-theme.css"-->
	<link rel="stylesheet" type="text/css" href="/src/goldenlayout-1.5.9/goldenlayout-dark-theme.css" />
	<script type="text/javascript" src="/src/goldenlayout-1.5.9/goldenlayout.js"></script>

	<!-- jQuery popup -->
	<script src="http://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
	<link rel="stylesheet" href="http://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
	<!--https://jqueryui.com/dialog/#modal-confirmation-->
	<!--https://api.jqueryui.com/dialog/#method-open-->

	<!--select box js component-->
	<link href="https://cdn.jsdelivr.net/npm/select2@4.0.13/dist/css/select2.min.css" rel="stylesheet" />
	<script src="https://cdn.jsdelivr.net/npm/select2@4.0.13/dist/js/select2.min.js"></script>

	<!--axisjs  http://ax5.io/ax5ui-formatter/-->
	<link rel="stylesheet" type="text/css"
		href="https://cdn.rawgit.com/ax5ui/ax5ui-formatter/master/dist/ax5formatter.css" />
	<script type="text/javascript" src="https://cdn.rawgit.com/ax5ui/ax5core/master/dist/ax5core.min.js"></script>
	<script type="text/javascript"
		src="https://cdn.rawgit.com/ax5ui/ax5ui-formatter/master/dist/ax5formatter.min.js"></script>


	
	<!--좌측 메뉴-->
	<link rel="stylesheet" type="text/css" href="src/metismenujs/metismenujs.css" />
	<script src="src/metismenujs/metismenujs.js"></script>

	<script src="/src/js/util/popup_mngr.js"></script>
	<script src="/src/js/util/ajax_mngr.js"></script>
	<script src="/src/js/util/tui_grid_mngr.js"></script>
	<script src="/src/js/util/progress_mngr.js"></script>
	<script src="/src/js/util/selectbox_mngr.js"></script>

	
	<script src="/src/js/util/form_mngr.js"></script>
	<script src="/src/js/util/app_mngr.js"></script>
	<script src="/src/js/util/pgmPage_mngr.js"></script>

	<link rel="stylesheet" type="text/css" href="/src/common.css" />
	<link rel="stylesheet" type="text/css" href="/src/test.css" />
	<link rel="stylesheet" type="text/css" href="/src/metismenujs/mm-vertical.css" />
	
	<script src="https://unpkg.com/axios/dist/axios.min.js"></script>
	
	<!-- 기본 ui 는 axjs 를 쓰자. -->
	<!--  데모페이지가 바로 연결 안되는 데..  http://ax5ui.axisj.com/ax5ui-dialog/
	여기에 http://ax5ui.axisj.com/ax5ui-dialog/demo 이렇게 demo 를 붙여주면 된다.
	    -->
<link rel="stylesheet" type="text/css" href="https://cdn.rawgit.com/ax5ui/ax5ui-dialog/master/dist/ax5dialog.css" />
<script type="text/javascript" src="https://cdn.rawgit.com/ax5ui/ax5core/master/dist/ax5core.min.js"></script>
<script type="text/javascript" src="https://cdn.rawgit.com/ax5ui/ax5ui-dialog/master/dist/ax5dialog.min.js"></script>
<script src="/src/js/util/Message.js"></script>


<!-- 로딩시에 페이지를 로딩할것이다. -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css">
<link rel="stylesheet" type="text/css" href="https://cdn.rawgit.com/ax5ui/ax5ui-mask/master/dist/ax5mask.css" />
<script type="text/javascript" src="https://cdn.rawgit.com/ax5ui/ax5ui-mask/master/dist/ax5mask.min.js"></script>



<link rel="stylesheet" href="https://uicdn.toast.com/tui.date-picker/latest/tui-date-picker.css">
<script src="https://uicdn.toast.com/tui.date-picker/latest/tui-date-picker.js"></script>


<link rel="stylesheet" href="https://uicdn.toast.com/tui.pagination/latest/tui-pagination.css" />
<script src="https://uicdn.toast.com/tui.pagination/latest/tui-pagination.js"></script>


<link rel="stylesheet" href="https://uicdn.toast.com/tui-grid/latest/tui-grid.css" />
<script src="https://uicdn.toast.com/tui-grid/latest/tui-grid.js"></script>

<!-- 시간관련 함수 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js" integrity="sha512-qTXRIMyZIFb8iQcfjXWCO8+M5Tbc38Qi5WzdPOYZHIlZpzBHG3L3by84BBBOiRGiEb7KKtAOAs5qYdUiZiQNNQ==" crossorigin="anonymous"></script>

<script src="/src/js/tui-grid-renderer/dateRenderer.js"></script>
<script src="/src/js/tui-grid-renderer/datetimeRenderer.js"></script>
	

	</head>
<body>