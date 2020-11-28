<!doctype html>
<html lang="en">

<head>
	<meta charset="UTF-8">
	<title>Layout Manager</title>

	<link rel="stylesheet" type="text/css" href="src/css/goldenlayout-base.css" />
	<link rel="stylesheet" type="text/css" href="src/css/goldenlayout-light-theme.css" />
	<script type="text/javascript" src="src/slickgrid/lib/jquery-3.5.0.js"></script>

	<script type="text/javascript">
		window.lm = { "config": {}, "container": {}, "controls": {}, "errors": {}, "items": {}, "utils": {} };
	</script>
	<script type="text/javascript" src="src/js/utils/utils.js"></script>
	<script type="text/javascript" src="src/js/items/AbstractContentItem.js"></script>
	<script type="text/javascript" src="src/js/LayoutManager.js"></script>
	<script type="text/javascript" src="src/js/config/ItemDefaultConfig.js"></script>
	<script type="text/javascript" src="src/js/config/defaultConfig.js"></script>
	<script type="text/javascript" src="src/js/container/ItemContainer.js"></script>
	<script type="text/javascript" src="src/js/controls/BrowserPopout.js"></script>
	<script type="text/javascript" src="src/js/controls/DragProxy.js"></script>
	<script type="text/javascript" src="src/js/controls/DragSource.js"></script>
	<script type="text/javascript" src="src/js/controls/DropTargetIndicator.js"></script>
	<script type="text/javascript" src="src/js/controls/Header.js"></script>
	<script type="text/javascript" src="src/js/controls/HeaderButton.js"></script>
	<script type="text/javascript" src="src/js/controls/Splitter.js"></script>
	<script type="text/javascript" src="src/js/controls/Tab.js"></script>
	<script type="text/javascript" src="src/js/controls/TransitionIndicator.js"></script>
	<script type="text/javascript" src="src/js/errors/ConfigurationError.js"></script>
	<script type="text/javascript" src="src/js/items/Component.js"></script>
	<script type="text/javascript" src="src/js/items/Root.js"></script>
	<script type="text/javascript" src="src/js/items/RowOrColumn.js"></script>
	<script type="text/javascript" src="src/js/items/Stack.js"></script>
	<script type="text/javascript" src="src/js/utils/BubblingEvent.js"></script>
	<script type="text/javascript" src="src/js/utils/ConfigMinifier.js"></script>
	<script type="text/javascript" src="src/js/utils/DragListener.js"></script>
	<script type="text/javascript" src="src/js/utils/EventEmitter.js"></script>
	<script type="text/javascript" src="src/js/utils/EventHub.js"></script>
	<script type="text/javascript" src="src/js/utils/ReactComponentHandler.js"></script>


	<!--slick formatter-->
	<script src="src/slickgrid/lib/firebugx.js"></script>
	<!--slick grid-->
	<script type="text/javascript" src="src/slickgrid/lib/jquery.event.drag-2.3.0.js"></script>
	<script type="text/javascript" src="src/slickgrid/lib/jquery-ui.min.js"></script>
	<link rel="stylesheet" type="text/css" href="src/slickgrid/slick.grid.css" />
	<link rel="stylesheet" type="text/css" href="src/slickgrid/slick-default-theme.css" />
	<link rel="stylesheet" href="src/slickgrid/smoothness/jquery-ui.css" type="text/css" />
	<link rel="stylesheet" href="src/slickgrid/examples.css" type="text/css" />
	<script type="text/javascript" src="src/slickgrid/slick.core.js"></script>

	<!--slick formatter-->
	<script type="text/javascript" src="src/slickgrid/slick.editors.js"></script>
	<script type="text/javascript" src="src/slickgrid/slick.formatters.js"></script>

	<!--grid resize-->
	<script src="src/slickgrid/plugins/slick.resizer.js"></script>


	<!--slick checkbox -->
	<link rel="stylesheet" type="text/css" href="src/slickgrid/controls/slick.columnpicker.css" />
	<script src="src/slickgrid/plugins/slick.checkboxselectcolumn.js"></script>
	<script src="src/slickgrid/plugins/slick.autotooltips.js"></script>
	<script src="src/slickgrid/plugins/slick.cellcopymanager.js"></script>

	<!--tooltip-->

	<script src="src/slickgrid/plugins/slick.autotooltips.js"></script>

	<script src="src/slickgrid/controls/slick.columnpicker.js"></script>


	<!--slick checkbox -->
	<!---->
	<script src="src/slickgrid/slick.editors.js"></script>

	<!--셀클릭시 한줄 선택되도록 -->
	<script src="src/slickgrid/plugins/slick.rowselectionmodel.js"></script>

	<!--curd가 되도록 row add  -->
	<script src="src/slickgrid/plugins/slick.cellrangedecorator.js"></script>
	<script src="src/slickgrid/plugins/slick.cellrangeselector.js"></script>
	<script src="src/slickgrid/plugins/slick.cellselectionmodel.js"></script>
	<!--curd가 되도록 row add  -->

	<script type="text/javascript" src="src/slickgrid/slick.grid.js"></script>

	<!--dataView 필터사용을 위해서 -->
	<script type="text/javascript" src="src/slickgrid/slick.dataview.js"></script>
	<link rel="stylesheet" href="src/slickgrid/controls/slick.pager.css" type="text/css" />
	<script src="src/slickgrid/controls/slick.pager.js"></script>

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

	<script src="src/js/util/popup_mngr.js"></script>
	<script src="src/js/util/custom_ajax.js"></script>
	<script src="src/js/util/grid_mngr.js"></script>
	<script src="src/js/util/progress_mngr.js"></script>
	<script src="src/js/util/selectbox_mngr.js"></script>


	<script src="src/js/util/pgm_mngr.js"></script>
	<script src="src/js/util/form_mngr.js"></script>
	<script src="src/js/util/app_mngr.js"></script>

	<link rel="stylesheet" type="text/css" href="src/common.css" />
	<link rel="stylesheet" type="text/css" href="src/test.css" />
	<link rel="stylesheet" type="text/css" href="src/metismenujs/mm-vertical.css" />
	<script>
		$(function () {
			

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

						content: [
							/*
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
							*/
						],
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


			{{ range $key, $value := .pgm_map_info }}
			pgmNmMap.add("{{ $value.pgm_id }}","{{ $value.pgm_nm }}");
			myLayout.registerComponent("{{ $value.pgm_id }}", function (container, state) {
				var p_param = {
					uuid : container._config.id
				}

				//container.getElement().load(container._config.pg);
				//파라미터를 고정해서 던져야 하는데.. 
				get_page_ajax(container.getElement(),container._config.pg,p_param);
				
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
			{{ end }}
			
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
				goOnePage(target);
			});
			

			$("#frm_login").submit(function (e) {
				//alert("Handler for .submit() called.");
				
				send_post_ajax("post_logout", null, function(data){
					location.href="/login";
				});
				e.preventDefault();
			});

		});

		document.addEventListener("DOMContentLoaded", function (event) {
			new MetisMenu('#menu1',{expand:true/*한번 열리면 모두 펼치기 */});
		});
	</script>
</head>

<body>
	<login class="login">
		<form method="post" name="frm_login" id="frm_login">
			<label>{{.id}}</label>
			<input type="submit" value="로그아웃" />
        </form>
	</login>
	<nav class="sidebar-nav">
		<ul class="metismenu" id="menu1">
			{{ range $key, $value := .menu_json }}
			<li  {{if eq  $key 0 }} class="mm-active" {{end}}>
			<!--<li class="mm-active">-->				
				<a class="has-arrow" href="#" aria-expanded="true">
					<span class="fa fa-fw fa-github fa-lg"></span>
					{{ $value.MenuNm }}
				</a>
				<ul class="mm-collapse">
					{{ range $key2, $value2 :=  $value.Child }}
					<li><a href="#" class="js-open-target" data-target="{{ $value2.PgmId }}" data-title="{{ $value2.MenuNm }}">{{ $value2.MenuNm }}</a></li>
					{{ end }}
				</ul>
			</li>
			{{ end }}
		</ul>
<!--
		<ul class="metismenu" id="menu1">
			<li class="mm-active">
				<a class="has-arrow" href="#" aria-expanded="true">
					<span class="fa fa-fw fa-github fa-lg"></span>
					metisMenu
				</a>
				<ul class="mm-collapse">
					<li><a href="#" class="js-open-target" data-target="send_order" data-title="주문">주문</a></li>
					<li><a href="#">item 0.1</a></li>
					<li><a href="#">item 0.1</a></li>
				</ul>
			</li>
			<li>
				<a class="has-arrow" href="#" aria-expanded="true">Menu 0</a>
				<ul class="mm-collapse">
					<li><a href="#">item 0.1</a></li>
					<li><a href="#">item 0.2</a></li>
					<li><a href="http://onokumus.com">onokumus</a></li>
					<li><a href="#">item 0.4</a></li>
				</ul>
			</li>
		</ul>
-->		
	</nav>
	<div id="layoutContainer"></div>

</body>

</html>