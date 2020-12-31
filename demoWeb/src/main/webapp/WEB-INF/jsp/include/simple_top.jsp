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
	<script src="/webjars/jquery/3.5.1/jquery.min.js"></script>
	
	<script type="text/javascript" src="/src/ax5core/ax5core.min.js"></script>
	<script type="text/javascript" src="/src/ax5binder/ax5binder.min.js"></script>
	<link   href="/webjars/font-awesome/5.15.1/css/all.min.css" rel="stylesheet" >
	<script src="/webjars/font-awesome/5.15.1/js/all.min.js"></script>
	<link rel="stylesheet" type="text/css" href="/src/ax5mask/ax5mask.css" />
	<script type="text/javascript" src="/src/ax5mask/ax5mask.min.js"></script>	
	<link rel="stylesheet" type="text/css" href="/src/ax5dialog/ax5dialog.css" />
	<script type="text/javascript" src="/src/ax5dialog/ax5dialog.min.js"></script>
	<script src="/src/js/util/ajax_mngr.js"></script>
	<script src="/src/js/util/Message.js"></script>
	</head>
<body>