<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><!doctype html>
<html lang="en">

<head>
	<meta charset="UTF-8">
	<title>Layout Manager</title>
	<script type="text/javascript" src="/src/slickgrid/lib/jquery-3.5.0.js"></script>
		<script>
    /*이건 공통적용인데 spring security로 보낼때 모두 체크해야하므로 !! 넣어준다.*/
    var csrf_headerName = '${_csrf.headerName}'; 
	var csrf_token = '${_csrf.token}';
	/* 이거 동작 안함 동작하는건 custom_ajax.js 에 있다.   https://hyunsangwon93.tistory.com/28 이게 동작함
    $.ajaxPrefilter(function (options) { 
 
	      	if (options.method === 'POST') { 
		      options.headers = options.headers || {}; 
		      options.headers[csrf_headerName] = csrf_token; 
		    } 
	      });
	 */
	</script>

	
	

	<script type="text/javascript">
		window.lm = { "config": {}, "container": {}, "controls": {}, "errors": {}, "items": {}, "utils": {} };
	</script>
<% if (false) { %>
	<link rel="stylesheet" type="text/css" href="/src/css/goldenlayout-base.css" />
	<link rel="stylesheet" type="text/css" href="/src/css/goldenlayout-light-theme.css" />
	<script type="text/javascript" src="/src/js/utils/utils.js"></script>
	<script type="text/javascript" src="/src/js/items/AbstractContentItem.js"></script>
	<script type="text/javascript" src="/src/js/LayoutManager.js"></script>
	<script type="text/javascript" src="/src/js/config/ItemDefaultConfig.js"></script>
	<script type="text/javascript" src="/src/js/config/defaultConfig.js"></script>
	<script type="text/javascript" src="/src/js/container/ItemContainer.js"></script>
	<script type="text/javascript" src="/src/js/controls/BrowserPopout.js"></script>
	<script type="text/javascript" src="/src/js/controls/DragProxy.js"></script>
	<script type="text/javascript" src="/src/js/controls/DragSource.js"></script>
	<script type="text/javascript" src="/src/js/controls/DropTargetIndicator.js"></script>
	<script type="text/javascript" src="/src/js/controls/Header.js"></script>
	<script type="text/javascript" src="/src/js/controls/HeaderButton.js"></script>
	<script type="text/javascript" src="/src/js/controls/Splitter.js"></script>
	<script type="text/javascript" src="/src/js/controls/Tab.js"></script>
	<script type="text/javascript" src="/src/js/controls/TransitionIndicator.js"></script>
	<script type="text/javascript" src="/src/js/errors/ConfigurationError.js"></script>
	<script type="text/javascript" src="/src/js/items/Component.js"></script>
	<script type="text/javascript" src="/src/js/items/Root.js"></script>
	<script type="text/javascript" src="/src/js/items/RowOrColumn.js"></script>
	<script type="text/javascript" src="/src/js/items/Stack.js"></script>
	<script type="text/javascript" src="/src/js/utils/BubblingEvent.js"></script>
	<script type="text/javascript" src="/src/js/utils/ConfigMinifier.js"></script>
	<script type="text/javascript" src="/src/js/utils/DragListener.js"></script>
	<script type="text/javascript" src="/src/js/utils/EventEmitter.js"></script>
	<script type="text/javascript" src="/src/js/utils/EventHub.js"></script>
	<script type="text/javascript" src="/src/js/utils/ReactComponentHandler.js"></script>
<% } else {  %>
<link rel="stylesheet" type="text/css" href="/src/goldenlayout-1.5.9/goldenlayout-base.css" />
<link rel="stylesheet" type="text/css" href="/src/goldenlayout-1.5.9/goldenlayout-light-theme.css" />
<!-- link rel="stylesheet" type="text/css" href="/src/goldenlayout-1.5.9/goldenlayout-dark-theme.css"  -->
<script type="text/javascript" src="/src/goldenlayout-1.5.9/goldenlayout.js"></script>
<% } %>

	<!--slick formatter-->
	<script src="/src/slickgrid/lib/firebugx.js"></script>
	<!--slick grid-->
	<script type="text/javascript" src="/src/slickgrid/lib/jquery.event.drag-2.3.0.js"></script>
	<script type="text/javascript" src="/src/slickgrid/lib/jquery-ui.min.js"></script>
	<link rel="stylesheet" type="text/css" href="/src/slickgrid/slick.grid.css" />
	<link rel="stylesheet" type="text/css" href="/src/slickgrid/slick-default-theme.css" />
	<link rel="stylesheet" href="/src/slickgrid/smoothness/jquery-ui.css" type="text/css" />
	<link rel="stylesheet" href="/src/slickgrid/examples.css" type="text/css" />
	<script type="text/javascript" src="/src/slickgrid/slick.core.js"></script>

	<!--slick formatter-->
	<script type="text/javascript" src="/src/slickgrid/slick.editors.js"></script>
	<script type="text/javascript" src="/src/slickgrid/slick.formatters.js"></script>

	<!--grid resize-->
	<script src="/src/slickgrid/plugins/slick.resizer.js"></script>


	<!--slick checkbox -->
	<link rel="stylesheet" type="text/css" href="/src/slickgrid/controls/slick.columnpicker.css" />
	<script src="/src/slickgrid/plugins/slick.checkboxselectcolumn.js"></script>
	<script src="/src/slickgrid/plugins/slick.autotooltips.js"></script>
	<script src="/src/slickgrid/plugins/slick.cellcopymanager.js"></script>

	<!--tooltip-->

	<script src="/src/slickgrid/plugins/slick.autotooltips.js"></script>

	<script src="/src/slickgrid/controls/slick.columnpicker.js"></script>


	<!--slick checkbox -->
	<!---->
	<script src="/src/slickgrid/slick.editors.js"></script>

	<!--셀클릭시 한줄 선택되도록 -->
	<script src="/src/slickgrid/plugins/slick.rowselectionmodel.js"></script>

	<!--curd가 되도록 row add  -->
	<script src="/src/slickgrid/plugins/slick.cellrangedecorator.js"></script>
	<script src="/src/slickgrid/plugins/slick.cellrangeselector.js"></script>
	<script src="/src/slickgrid/plugins/slick.cellselectionmodel.js"></script>
	<!--curd가 되도록 row add  -->

	<script type="text/javascript" src="src/slickgrid/slick.grid.js"></script>

	<!--dataView 필터사용을 위해서 -->
	<script type="text/javascript" src="/src/slickgrid/slick.dataview.js"></script>
	<link rel="stylesheet" href="/src/slickgrid/controls/slick.pager.css" type="text/css" />
	<script src="/src/slickgrid/controls/slick.pager.js"></script>

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
	<script src="/src/js/util/custom_ajax.js"></script>
	<script src="/src/js/util/grid_mngr.js"></script>
	<script src="/src/js/util/progress_mngr.js"></script>
	<script src="/src/js/util/selectbox_mngr.js"></script>

	
	<script src="/src/js/util/form_mngr.js"></script>
	<script src="/src/js/util/app_mngr.js"></script>

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



<!-- vue 못씀 -->
<link rel="stylesheet" href="https://uicdn.toast.com/tui.date-picker/latest/tui-date-picker.css">
<script src="https://uicdn.toast.com/tui.date-picker/latest/tui-date-picker.js"></script>


<link rel="stylesheet" href="https://uicdn.toast.com/tui.pagination/latest/tui-pagination.css" />
<script src="https://uicdn.toast.com/tui.pagination/latest/tui-pagination.js"></script>


<link rel="stylesheet" href="https://uicdn.toast.com/tui-grid/latest/tui-grid.css" />
<script src="https://uicdn.toast.com/tui-grid/latest/tui-grid.js"></script>




<script src="/src/js/tui-grid-renderer/dateRenderer.js"></script>
<script src="/src/js/tui-grid-renderer/datetimeRenderer.js"></script>
	

	</head>
<body>