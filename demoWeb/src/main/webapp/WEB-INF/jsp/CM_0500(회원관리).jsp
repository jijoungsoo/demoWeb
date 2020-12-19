<%
    String pgmId = (String) request.getAttribute("pgmId");
	String uuid = (String) request.getAttribute("uuid");
%>
<script>
$(document).ready(function(){
	var CM_0500 = new PgmPageMngr ('<%=pgmId%>', '<%=uuid%>');
		CM_0500.init(function(p_param) {
			var _this = CM_0500;
			var searchForm = new FormMngr(_this, "search_area");
			var userForm = new FormMngr(_this, "user_area");
		    $('[data-ax5formatter]').ax5formatter();
			var columns = [ {
				header : '사용자번호',
				name : 'USER_NO',
				width : 100,
				resizable : false,
				sortable : true,
				sortingType : 'desc', /*내림차순   ctrl 키를 누르고 정렬키를 여러개 누르면 이어서 정렬이 된다.*/
				filter : {
					type : 'text',
					showApplyBtn : true,
					showClearBtn : true
				}
			}, {
				header : '사용자명',
				name : 'USER_NM',
				width : 'auto', /*너비 자동조절*/
				sortable : true
			},
			{
				header : '사용자ID',
				name : 'USER_ID',
				width : 100,
				sortable : true,
				align : "center",
				filter : 'select'
			}, {
				header : '이메일',
				name : 'EMAIL'
			}, {
			header : '사용여부',
			name : 'USE_YN'
		}, {
			header : '비고',
			name : 'RMK'
		}, {
			header : '마지막접속일',
			name : 'LST_ACC_DTM',
		}
		, {
				header : '생성일',
				name : 'CRT_DTM',
				renderer : {
					type : datetimeRenderer,
					options : {
						format : 'yyyy-MM-DD HH:mm' /*YYYYMMDDHHmmss    이게 풀양식이다.*/
						,
						source : 'YYYYMMDDHHmmss' /*TIME 초, YYYYMMDD , YYYYMMDDHHmm,  YYYYMMDDHHmmss  */
					}
				},
				width : 120,
				sortable : true,
				align : "center",
				filter : {
					type : 'date',
					format : 'yyyy-MM-DD'
				}
			}, {
				header : '수정일',
				name : 'UPDT_DTM',
				renderer : {
					type : datetimeRenderer,
					options : {
						format : 'yyyy-MM-DD HH:mm' /*YYYYMMDDHHmmss    이게 풀양식이다.*/
						,
						source : 'YYYYMMDDHHmmss' /*TIME 초, YYYYMMDD , YYYYMMDDHHmm,  YYYYMMDDHHmmss  */
					}
				},
				width : 120,
				sortable : true,
				align : "center"
			} ];

			const grid = new TuiGridMngr(_this, 'grid', columns, {
				editable : true,
				showRowStatus : true,
				rowNum : true,
				checkbox : true,
				bodyHeight: 300
			});
			grid.build();

			grid.on('click', (ev) => {
				if (ev.rowKey >=0) {
					var row_data=grid.getRow(ev.rowKey);
					console.log(row_data);
					userForm.setDataAll(row_data);
				}
			});

			searchForm.addEvent("click", "input[type=button]", function(el) {
				//console.log(el);
				switch (el.target.name) {
				case 'search':
					var param = {
						brRq : 'IN_DATA',
						brRs : 'OUT_DATA',
						IN_DATA : [ {} ]
					}
					grid.loadData('findCmUser', param, function(data) {
						console.log(data);
						//gridLoadData에서 자동으로 로드됨..

					});
					break;
				case "del":
					var data = grid.getCheckedData();
					console.log(data);
					if (data.length <= 0) {
						Message.alert('선택된 항목이 없습니다.');
						return;
					}

					Message.confirm('삭제하시겠습니까?', function() {
						var param = {
							brRq : 'IN_DATA',
							brRs : '',
							IN_DATA : data
						}
						_this.showProgress();
						_this.send('rmCmUser', param, function(data) {
							_this.hideProgress();
							if (data) {
								Message.alert('삭제되었습니다.', function() {
									searchForm.get("search").trigger("click");
									userForm.clearData();
								});
							}

						});
					});
					break;
				}
			});

			userForm.addEvent("click", "input[type=button]", function(el) {
				//console.log(el);
				switch (el.target.name) {
				case 'new':
					userForm.clearData();
					break;
				case "save":
					var data = userForm.getData();
					console.log(data);

					Message.confirm('저장하시겠습니까?', function() {
						var param = {
							brRq : 'IN_DATA',
							brRs : '',
							IN_DATA : [ data ],
						}
						_this.send('saveCmUser', param, function(data) {
							if(data){
								Message.alert('저장되었습니다.', function() {
									searchForm.get("search").trigger("click");
									userForm.clearData();
								});
							}
						});
					});
					
					break;
				}
			});
		});
	});
</script>