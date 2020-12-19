<%
    String pgmId = (String) request.getAttribute("pgmId");
	String uuid = (String) request.getAttribute("uuid");
%>
<script>
$(document).ready(function(){
	var CM_0400 = new PgmPageMngr ('<%=pgmId%>', '<%=uuid%>');
		CM_0400.init(function(p_param) {
			var _this = CM_0400;
			var cmGrpCdSearchForm 	= new FormMngr(_this, "cm_grp_cd_search_area");
			var cmCdSearchForm = new FormMngr(_this, "cm_cd_search_area");

			
		
			var columns = [ {
				header : '공통그룹코드',
				name : 'GRP_CD',
				width : 200,
				resizable : false,
				sortable : true,
				sortingType : 'desc', /*내림차순   ctrl 키를 누르고 정렬키를 여러개 누르면 이어서 정렬이 된다.*/
				filter : {
					type : 'text',
					showApplyBtn : true,
					showClearBtn : true
				}, /*text, number, select, date 4가지가 있다.*/
				validation : {
					dataType : 'string', /*string ,number*/
					required : true, /*  true 필수, false 필수아님  */
				},
				editor : 'text'
			},
			{
				header : '공통그룹명',
				name : 'GRP_NM',
				width : 200,
				sortable : true,
				align : "center",
				sortingType : 'desc', /*내림차순   ctrl 키를 누르고 정렬키를 여러개 누르면 이어서 정렬이 된다.*/
				filter : {
					type : 'text',
					showApplyBtn : true,
					showClearBtn : true
				}, /*text, number, select, date 4가지가 있다.*/
				validation : {
					dataType : 'string', /*string ,number*/
					required : true, /*  true 필수, false 필수아님  */
					unique : true
				/*true 데이터가 중복되면 빨간색 표시 */
				},
				editor : 'text'
			},

			{
				header : '사용여부',
				name : 'USE_YN',
				width : 100,
				sortable : true,
				align : "center",
				sortingType : 'desc', /*내림차순   ctrl 키를 누르고 정렬키를 여러개 누르면 이어서 정렬이 된다.*/
				filter : {
					type : 'text',
					showApplyBtn : true,
					showClearBtn : true
				}, /*text, number, select, date 4가지가 있다.*/
				editor : 'text'
			}, {
				header : '정렬',
				name : 'ORD',
				width : 200,
				sortable : true,
				align : "center",
				sortingType : 'desc', /*내림차순   ctrl 키를 누르고 정렬키를 여러개 누르면 이어서 정렬이 된다.*/
				filter : {
					type : 'text',
					showApplyBtn : true,
					showClearBtn : true
				}, /*text, number, select, date 4가지가 있다.*/
				validation : {
					dataType : 'number', /*string ,number*/
					required : true /*  true 필수, false 필수아님  */
				},
				editor : 'text'
			}, {
				header : '비고',
				name : 'RMK',
				width : 100,
				sortable : true,
				align : "center",
				sortingType : 'desc', /*내림차순   ctrl 키를 누르고 정렬키를 여러개 누르면 이어서 정렬이 된다.*/
				filter : {
					type : 'text',
					showApplyBtn : true,
					showClearBtn : true
				}, /*text, number, select, date 4가지가 있다.*/
				editor : 'text'
			}, {
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
				/*'yyyy-MM-dd HH:mm A'*/
				/*실제 데이터랑 비교하나보다 .. 비교가 안된다. */
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
			/*,  filter: 'number'  숫자일경우 비교 */
			} ];

			const grid_cm_grp_cd = new TuiGridMngr(_this, 'grid_cm_grp_cd', columns, {
				editable : true,
				showRowStatus : true,
				rowNum : true,
				checkbox : true,
				bodyHeight : 300 /*그리드 높이지정 */
				,
				showDummyRows : false
			});
			grid_cm_grp_cd.build();

			grid_cm_grp_cd.on('click', (ev) => {
				//ev.rowKey === 3 
				//ev.columnName === 'col1'
				if (ev.rowKey >=0) {
					var row_data=grid_cm_grp_cd.getRow(ev.rowKey);
					console.log(row_data);
					//row_data.GRP_CD;
					//공통코드상세조회
					var param = {
						brRq : 'IN_DATA',
						brRs : 'OUT_DATA',
						IN_DATA : [ { GRP_CD : row_data.GRP_CD } ]
					}
					grid_cm_cd.loadData('findCmCd', param, function(data) {
						console.log(data);
						//gridLoadData에서 자동으로 로드됨..

					});
				}
			});


			
			var columns = [ {
				header : '공통그룹코드',
				name : 'GRP_CD',
				width : 200,
				resizable : false,
				sortable : true,
				sortingType : 'desc', /*내림차순   ctrl 키를 누르고 정렬키를 여러개 누르면 이어서 정렬이 된다.*/
				filter : {
					type : 'text',
					showApplyBtn : true,
					showClearBtn : true
				}, /*text, number, select, date 4가지가 있다.*/
				validation : {
					dataType : 'string', /*string ,number*/
					required : true, /*  true 필수, false 필수아님  */
				},
				editor : 'text'
			},
			{
				header : '공통코드',
				name : 'CD',
				width : 200,
				sortable : true,
				align : "center",
				sortingType : 'desc', /*내림차순   ctrl 키를 누르고 정렬키를 여러개 누르면 이어서 정렬이 된다.*/
				filter : {
					type : 'text',
					showApplyBtn : true,
					showClearBtn : true
				}, /*text, number, select, date 4가지가 있다.*/
				validation : {
					dataType : 'string', /*string ,number*/
					required : true, /*  true 필수, false 필수아님  */
					unique : true
				/*true 데이터가 중복되면 빨간색 표시 */
				},
				editor : 'text'
			},
			{
				header : '공통코드명',
				name : 'CD_NM',
				width : 200,
				sortable : true,
				align : "center",
				sortingType : 'desc', /*내림차순   ctrl 키를 누르고 정렬키를 여러개 누르면 이어서 정렬이 된다.*/
				filter : {
					type : 'text',
					showApplyBtn : true,
					showClearBtn : true
				}, /*text, number, select, date 4가지가 있다.*/
				validation : {
					dataType : 'string', /*string ,number*/
					required : true, /*  true 필수, false 필수아님  */
					unique : true
				/*true 데이터가 중복되면 빨간색 표시 */
				},
				editor : 'text'
			},

			{
				header : '사용여부',
				name : 'USE_YN',
				width : 100,
				sortable : true,
				align : "center",
				sortingType : 'desc', /*내림차순   ctrl 키를 누르고 정렬키를 여러개 누르면 이어서 정렬이 된다.*/
				filter : {
					type : 'text',
					showApplyBtn : true,
					showClearBtn : true
				}, /*text, number, select, date 4가지가 있다.*/
				editor : 'text'
			}, {
				header : '정렬',
				name : 'ORD',
				width : 200,
				sortable : true,
				align : "center",
				sortingType : 'desc', /*내림차순   ctrl 키를 누르고 정렬키를 여러개 누르면 이어서 정렬이 된다.*/
				filter : {
					type : 'text',
					showApplyBtn : true,
					showClearBtn : true
				}, /*text, number, select, date 4가지가 있다.*/
				validation : {
					dataType : 'string', /*string ,number*/
					required : true /*  true 필수, false 필수아님  */
				},
				editor : 'text'
			}, {
				header : '비고',
				name : 'RMK',
				width : 100,
				sortable : true,
				align : "center",
				sortingType : 'desc', /*내림차순   ctrl 키를 누르고 정렬키를 여러개 누르면 이어서 정렬이 된다.*/
				filter : {
					type : 'text',
					showApplyBtn : true,
					showClearBtn : true
				}, /*text, number, select, date 4가지가 있다.*/
				editor : 'text'
			}, {
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
				/*'yyyy-MM-dd HH:mm A'*/
				/*실제 데이터랑 비교하나보다 .. 비교가 안된다. */
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
			/*,  filter: 'number'  숫자일경우 비교 */
			} ];

			const grid_cm_cd = new TuiGridMngr(_this, 'grid_cm_cd', columns, {
				editable : true,
				showRowStatus : true,
				rowNum : true,
				checkbox : true,
				bodyHeight : 300 /*그리드 높이지정 */
				,
				showDummyRows : false
			});
			grid_cm_cd.build();


			cmGrpCdSearchForm.addEvent("click","input[type=button]", function(el) {
				switch (el.target.name) {
				case 'cm_grp_cd_search':
					var param = {
						brRq : 'IN_DATA',
						brRs : 'OUT_DATA',
						IN_DATA : [ {} ]
					}
					grid_cm_grp_cd.loadData('findCmGrpCd', param, function(data) {
						console.log(data);
						grid_cm_cd.clear();
						//gridLoadData에서 자동으로 로드됨..

					});
					break;
				case 'cm_grp_cd_add_row':
					Message.confirm('행을 추가하시겠습니까?', function() {
						grid_cm_grp_cd.appendRow();
					});
					break;

				case 'cm_grp_cd_save':
					var data = grid_cm_grp_cd.getModifiedRows();
					console.log(data);
					var crt_cnt = data.createdRows.length;
					var updt_cnt = data.updatedRows.length;

					if ((crt_cnt + updt_cnt) == 0) {
						Message.alert("저장할 내용이 존재하지 않습니다.");
						return;
					}
					if (grid_cm_grp_cd.isValid() == false) {
						grid_cm_grp_cd.validMsg();
						return;
					}

					Message.confirm('공통그룹을 저장하시겠습니까?', function() {
						var param = {
							brRq : 'IN_DATA,UPDT_DATA',
							brRs : '',
							IN_DATA : data.createdRows,
							UPDT_DATA : data.updatedRows
						}
						_this.send('saveCmGrpCd', param, function(data) {
							if(data){
								Message.alert('공통그룹이 저장되었습니다.', function() {
									cmGrpCdSearchForm.get("cm_grp_cd_search").trigger("click");
								});
							}
						});
					});
					break;
				case "cm_grp_cd_del":
					var data = grid_cm_grp.getCheckedData();
					console.log(data);
					if (data.length <= 0) {
						Message.alert('선택된 항목이 없습니다.');
						return;
					}

					Message.confirm('공통그룹을 삭제하시겠습니까?', function() {
						var param = {
							brRq : 'IN_DATA',
							brRs : '',
							IN_DATA : data
						}
						_this.send('rmCmGrpCd', param, function(data) {
							if(data) {
								Message.alert('공통그룹이 삭제되었습니다.', function() {
									cmGrpSearchForm.get("cm_grp_cd_search").trigger("click");
								});
							}
						});
					});
					//실제로 서버에서 삭제하는로직 필요.
					//grid.removeRow(0); 
					break;
				}
			});

			cmCdSearchForm.addEvent("click","input[type=button]", function(el) {
				switch (el.target.name) {
				case 'cm_cd_add_row':
					Message.confirm('행을 추가하시겠습니까?', function() {
						grid_cm_cd.appendRow();
					});
					break;

				case 'cm_cd_save':
					var data = grid_cm_cd.getModifiedRows();
					console.log(data);
					var crt_cnt = data.createdRows.length;
					var updt_cnt = data.updatedRows.length;

					if ((crt_cnt + updt_cnt) == 0) {
						Message.alert("공통코드 상세에 저장할 내용이 존재하지 않습니다.");
						return;
					}
					if (grid_cm_cd.isValid() == false) {
						grid_cm_cd.validMsg();
						return;
					}
					
					Message.confirm('공통코드상세를 저장하시겠습니까?', function() {
						var param = {
							brRq : 'IN_DATA,UPDT_DATA',
							brRs : '',
							IN_DATA : data.createdRows,
							UPDT_DATA : data.updatedRows
						}
						_this.send('saveCmCd', param, function(data) {
							if(data){
								Message.alert('저장되었습니다.', function() {
									cmCdSearchForm.get("cm_cd_search").trigger("click");
								});
							}
						});
					});
					break;
				case "cm_cd_del":
					var data = grid_cm_cd.getCheckedData();
					console.log(data);
					if (data.length <= 0) {
						Message.alert('선택된 항목이 없습니다.');
						return;
					}
					Message.confirm('코드상세를 삭제하시겠습니까?', function() {
						var param = {
							brRq : 'IN_DATA',
							brRs : '',
							IN_DATA : data
						}
						_this.send('rmCmCd', param, function(data) {
							if(data) {
								Message.alert('삭제되었습니다.', function() {
									cmCdSearchForm.get("cm_cd_search").trigger("click");
								});
							}
						});
					});
					//실제로 서버에서 삭제하는로직 필요.
					//grid.removeRow(0); 
					break;
				}
			});
			cmGrpCdSearchForm.get("cm_grp_cd_search").trigger("click");
		});
	});
</script>