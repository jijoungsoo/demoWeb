<%
    String pgmId = (String) request.getAttribute("pgmId");
	String uuid = (String) request.getAttribute("uuid");
%>
<script>
$(document).ready(function(){
	var CM_2200 = new PgmPageMngr ('<%=pgmId%>', '<%=uuid%>');
		CM_2200.init(function(p_param) {
			var _this = CM_2200;
			var cmRoleCdSearchForm 	= new FormMngr(_this, "cm_role_cd_search_area");
			var cmUserRoleCdSearchForm = new FormMngr(_this, "cm_user_role_cd_search_area");

			const grid_cm_role_cd = new TuiGridMngr(_this, 'grid_cm_role_cd',  {
				editable : true,
				showRowStatus : true,
				rowNum : true,
				checkbox : true,
				bodyHeight : 300 /*그리드 높이지정 */
				,
				showDummyRows : false
			},
			[ {
				header : '역할코드',
				name : 'ROLE_CD',
				width : 200,
				resizable : false,
				sortable : true,
				sortingType : 'desc',
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
				header : '역할명',
				name : 'ROLE_NM',
				width : 200,
				sortable : true,
				align : "center",
				sortingType : 'desc', 
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
				sortingType : 'desc', 
				filter : {
					type : 'text',
					showApplyBtn : true,
					showClearBtn : true
				}, /*text, number, select, date 4가지가 있다.*/
				formatter: 'listItemText',
				editor: {
		            type: 'select',
		            options: {
		              listItems: [
		                { text: 'Y', value: 'Y' },
		                { text: 'N', value: 'N' }
		              ]
		            }
				}
			}, {
				header : '정렬',
				name : 'ORD',
				width : 200,
				sortable : true,
				align : "center",
				sortingType : 'desc',
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
				width : 140,
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
				width : 140,
				sortable : true,
				align : "center"
			/*,  filter: 'number'  숫자일경우 비교 */
			} ]
			);
			grid_cm_role_cd.build();

			grid_cm_role_cd.on('click', (ev) => {
				if (ev.rowKey >=0) {
					
					if(ev.columnName=='GRP_CD'){
						var row_data=grid_cm_role_cd.getRow(ev.rowKey);
						if(PjtUtil.isEmpty(row_data.GRP_CD)==false){
							cmCdSearchForm.get("cm_cd_search").trigger("click");
						}
						
						
					}
					
				}
			});

			const grid_cm_user_role_cd = new TuiGridMngr(_this, 'grid_cm_user_role_cd', {
				editable : true,
				showRowStatus : true,
				rowNum : true,
				checkbox : true,
				bodyHeight : 300 /*그리드 높이지정 */
				,
				showDummyRows : false
			},
			[ {
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
				formatter: 'listItemText',
				editor: {
		            type: 'select',
		            options: {
		              listItems: [
		                { text: 'Y', value: 'Y' },
		                { text: 'N', value: 'N' }
		              ]
		            }
				}
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
				editor : 'text'
			}, {
				header : '생성일',
				name : 'CRT_DTM',
				width : 140,
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
				width : 140,
				sortable : true,
				align : "center"
			/*,  filter: 'number'  숫자일경우 비교 */
			} ]

			);
			grid_cm_user_role_cd.build();


			cmRoleCdSearchForm.addEvent("click","input[type=button]", function(el) {
				switch (el.target.name) {
				case 'cm_role_cd_search':
					var param = {
						brRq : 'IN_DATA',
						brRs : 'OUT_DATA',
						IN_DATA : [ {} ]
					}
					grid_cm_role_cd.loadData('BR_CM_ROLE_CD_FIND', param, function(data) {
						console.log(data);
						grid_cm_user_role.clear();
						//gridLoadData에서 자동으로 로드됨..

					});
					break;
				case 'cm_role_cd_add_row':
					Message.confirm('행을 추가하시겠습니까?', function() {
						grid_cm_role_cd.appendRow();
					});
					break;

				case 'cm_role_cd_save':
					var data = grid_cm_role_cd.getModifiedRows();
					console.log(data);
					var crt_cnt = data.createdRows.length;
					var updt_cnt = data.updatedRows.length;

					if ((crt_cnt + updt_cnt) == 0) {
						Message.alert("저장할 내용이 존재하지 않습니다.");
						return;
					}
					if (grid_cm_role_cd.isValid() == false) {
						grid_cm_role_cd.validMsg();
						return;
					}

					Message.confirm('역할코드를 저장하시겠습니까?', function() {
						var param = {
							brRq : 'IN_DATA,UPDT_DATA',
							brRs : '',
							IN_DATA : data.createdRows,
							UPDT_DATA : data.updatedRows
						}
						_this.send('BR_CM_ROLE_CD_SAVE', param, function(data) {
							if(data){
								Message.alert('역할코드가 저장되었습니다.', function() {
									cmRoleCdSearchForm.get("cm_role_cd_search").trigger("click");
								});
							}
						});
					});
					break;
				case "cm_role_cd_del":
					var data = grid_cm_role_cd.getCheckedData();
					console.log(data);
					if (data.length <= 0) {
						Message.alert('선택된 항목이 없습니다.');
						return;
					}

					Message.confirm('역할코드를 삭제하시겠습니까?', function() {
						var param = {
							brRq : 'IN_DATA',
							brRs : '',
							IN_DATA : data
						}
						_this.send('BR_CM_ROLE_CD_RM', param, function(data) {
							if(data) {
								Message.alert('역할코드를 삭제되었습니다.', function() {
									cmRoleCdSearchForm.get("cm_role_cd_search").trigger("click");
								});
							}
						});
					});
					break;
				}
			});

			cmUserRoleCdSearchForm.addEvent("click","input[type=button]", function(el) {
				switch (el.target.name) {
				case 'cm_user_role_cd_search':
					var row=grid_cm_role_cd.getSelectedRow();
					if(row==null){
						Message.alert("역할코드를 선택해주세요.");
						return;
					}
					var param = {
						brRq : 'IN_DATA',
						brRs : 'OUT_DATA',
						IN_DATA : [ { ROLE_CD : row.ROLE_CD } ]
					}
					grid_cm_user_role_cd.loadData('BR_CM_USER_ROLE_CD_FIND', param, function(data) {
						console.log(data);
					});
					
					break;
				case 'cm_user_role_cd_add_row':
					Message.confirm('행을 추가하시겠습니까?', function() {
						var row=grid_cm_role_cd.getSelectedRow();
						if(row==null){
							Message.alert("상단역할코드를 선택해주세요.");
							return;
						}
						
						inline_popup = new InlinePopupManger(_this, 'popup_cm_user', {
				          width: 500,
				          heght: 700,
				          title: "사용자조회"
				        });
						inline_popup.open(function(data){
				        	if(data){
				        		console.log(data);
				        	}
				        });
					
						//grid_cm_user_role_cd.appendRow({ ROLE_CD: row.ROLE_CD });
					});
					break;

				case 'cm_user_role_cd_save':
					var data = grid_user_role_cd.getModifiedRows();
					console.log(data);
					var crt_cnt = data.createdRows.length;
					var updt_cnt = data.updatedRows.length;

					if ((crt_cnt + updt_cnt) == 0) {
						Message.alert("사용자 역할 추가에 저장할 내용이 존재하지 않습니다.");
						return;
					}
					if (grid_user_role_cd.isValid() == false) {
						grid_user_role_cd.validMsg();
						return;
					}
					
					Message.confirm('공통코드상세를 저장하시겠습니까?', function() {
						var param = {
							brRq : 'IN_DATA,UPDT_DATA',
							brRs : '',
							IN_DATA : data.createdRows,
							UPDT_DATA : data.updatedRows
						}
						_this.send('BR_CM_USER_ROLE_CD_SAVE', param, function(data) {
							if(data){
								Message.alert('저장되었습니다.', function() {
									cmUserRoleCdSearchForm.get("cm_user_role_cd_search").trigger("click");
								});
							}
						});
					});
					break;
				case "cm_user_role_cd_del":
					var data = grid_user_role_cd.getCheckedData();
					console.log(data);
					if (data.length <= 0) {
						Message.alert('선택된 항목이 없습니다.');
						return;
					}
					Message.confirm('사용자 역할을 삭제하시겠습니까?', function() {
						var param = {
							brRq : 'IN_DATA',
							brRs : '',
							IN_DATA : data
						}
						_this.send('BR_CM_USER_ROLE_CD_RM', param, function(data) {
							if(data) {
								Message.alert('삭제되었습니다.', function() {
									cmUserRoleCdSearchForm.get("cm_user_role_cd_search").trigger("click");
								});
							}
						});
					});
					break;
				}
			});
			cmRoleCdSearchForm.get("cm_role_cd_search").trigger("click");
		});
	});
</script>