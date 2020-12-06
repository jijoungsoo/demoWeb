
<!doctype html>
<html lang="en">

<head>
	<meta charset="UTF-8">
	<title>Layout Manager</title>

	<link rel="stylesheet" type="text/css" href="/src/css/goldenlayout-base.css" />
	<link rel="stylesheet" type="text/css" href="/src/css/goldenlayout-light-theme.css" />
	<script type="text/javascript" src="/src/slickgrid/lib/jquery-3.5.0.js"></script>

	<script type="text/javascript">
		window.lm = { "config": {}, "container": {}, "controls": {}, "errors": {}, "items": {}, "utils": {} };
	</script>
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


	<script src="/src/js/util/pgm_mngr.js"></script>
	<script src="/src/js/util/form_mngr.js"></script>
	<script src="/src/js/util/app_mngr.js"></script>

	<link rel="stylesheet" type="text/css" href="/src/common.css" />
	<link rel="stylesheet" type="text/css" href="/src/test.css" />
	<link rel="stylesheet" type="text/css" href="/src/metismenujs/mm-vertical.css" />
	
	
	
	
	</head>
<!-- 붙일만한  view js 모듈
https://buefy.org/documentation/tooltip

https://vuesax.com/docs/components/Loading.html#default   -- 로딩이 쓸만하다. 이것만 쓸만함

/*유료네..*/
https://primefaces.org/primevue/showcase/#/multiselect    -- 마스크가 쓸만하다.
https://primefaces.org/primevue/showcase/#/datatable/responsive    테이블이 쓸만하다.


https://element.eleme.io/#/en-US/component/table   테이블이 쓸많다 , 로딩도 전체 로딩이 있다.  MIT 다 무료다 마음에 든다. 이걸로 고고
https://josephuspaye.github.io/Keen-UI/#/ui-tooltip  좋은데........... 로딩이 없다. 테이블도 빈약하다.



크롬에서 es6 지원하기
https://v8.dev/features/modules


 -->
<body>