<%@ include file="/WEB-INF/jsp/include/top.jsp" %>
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
<%@ include file="/WEB-INF/jsp/include/bottom.jsp" %>