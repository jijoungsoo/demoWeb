<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><!doctype html>
<html lang="en">

<head>
	<meta charset="UTF-8">
	<title>Layout Manager</title>
  	<script>
    /*이건 공통적용인데 spring security로 보낼때 모두 체크해야하므로 !! 넣어준다.*/
    var csrf_headerName = '${_csrf.headerName}'; 
	var csrf_token = '${_csrf.token}';
	/*이거 ajax쪽에 넣었다.*/
	</script>
	<script type="text/javascript" src="/src/js/jquery-3.5.1/jquery-3.5.1.min.js"></script>
	<script src="/src/js/util/ajax_mngr.js"></script>
	<script type="text/javascript" src="https://cdn.rawgit.com/ax5ui/ax5core/master/dist/ax5core.min.js"></script>
	<!-- http://ax5ui.axisj.com/     form 바인더 -->
	<script type="text/javascript" src="https://cdn.rawgit.com/ax5ui/ax5ui-binder/master/dist/ax5binder.min.js"></script>
	
	<!-- 로딩시에 페이지를 로딩할것이다. -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css">
	<link rel="stylesheet" type="text/css" href="https://cdn.rawgit.com/ax5ui/ax5ui-mask/master/dist/ax5mask.css" />
	<script type="text/javascript" src="https://cdn.rawgit.com/ax5ui/ax5ui-mask/master/dist/ax5mask.min.js"></script>
	
	<!-- axjs의 dialog 구현체 -->
	<link rel="stylesheet" type="text/css" href="https://cdn.rawgit.com/ax5ui/ax5ui-dialog/master/dist/ax5dialog.css" />
	<script type="text/javascript" src="https://cdn.rawgit.com/ax5ui/ax5ui-dialog/master/dist/ax5dialog.min.js"></script>
	<!-- Message 박스 (axjs 렙퍼) -->
	<script src="/src/js/util/Message.js"></script>
	
	
	</head>
<body>