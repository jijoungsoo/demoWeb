<%
    String pgmId = (String) request.getAttribute("pgmId");
	String uuid = (String) request.getAttribute("uuid");
%>
<script>
	$(document).ready(function () {
		var CM_2300 = new PgmPageMngr('<%=pgmId%>', '<%=uuid%>');
		CM_2300.init(function (p_param) {
			var _this = CM_2300;
			var searchForm = new FormMngr(_this, "search_area");

			const grid = new TuiGridMngr(_this, 'grid', {
					editable: false,
					showRowStatus: false,
					rowNum: true,
					checkbox: false,
					bodyHeight: 300
				},
				[	{
						header: '사용자번호',
						name: 'USER_NO',
						width: 100,
						resizable: false,
						sortable: true,
						sortingType: 'desc',
						/*내림차순   ctrl 키를 누르고 정렬키를 여러개 누르면 이어서 정렬이 된다.*/
						filter: {
							type: 'text',
							showApplyBtn: true,
							showClearBtn: true
						}
					}, {
						header: '사용자명',
						name: 'USER_NM',
						width: 'auto',
						/*너비 자동조절*/
						width: 200,
						sortable: true
					}, {
						header: '사용자ID',
						name: 'USER_ID',
						width: 100,
						sortable: true,
						align: "center",
						filter: 'select'
					}, {
						header: '사용여부',
						name: 'USE_YN',
						width: 80
					},
					{
						header: '비고',
						name: 'RMK',
						width: 100
					}, {
						header: '마지막접속일',
						name: 'LST_ACC_DTM',
						width: 140
					}, {
						header: '생성일',
						name: 'CRT_DTM',
						width: 140,
						sortable: true,
						align: "center"
					}, {
						header: '수정일',
						name: 'UPDT_DTM',
						width: 140,
						sortable: true,
						align: "center"
					}
				]
			);
			grid.build();

			grid.on('dblclick', (ev) => {
				if (ev.rowKey >=0) {
					var row_data=grid.getRow(ev.rowKey);
					console.log(row_data);
					_this.close(row_data);
				}
			});

			searchForm.addEvent("click", "input[type=button]", function (el) {
				//console.log(el);
				switch (el.target.name) {
					case 'grid_search':
						var param = {
							brRq: 'IN_DATA',
							brRs: 'OUT_DATA',
							IN_DATA: [{}]
						}
						grid.loadData('BR_CM_USER_FIND', param, function (data) {
							console.log(data);
							//gridLoadData에서 자동으로 로드됨..

						});
						break;
				};

			});
			searchForm.get("grid_search").trigger("click");
		});
	});
</script>