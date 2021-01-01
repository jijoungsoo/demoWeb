<%
    String pgmId = (String) request.getAttribute("pgmId");
	String uuid = (String) request.getAttribute("uuid");
%>
<script>
$(document).ready(function(){
	var CM_1600 = new PgmPageMngr ('<%=pgmId%>', '<%=uuid%>');
		CM_1600.init(function(p_param) {
			var _this = CM_1600;
			var searchForm = new FormMngr(_this, "search_area");

			const grid = new TuiGridMngr(_this, 'grid', {
				editable : true,
				showRowStatus : true,
				rowNum : true,
				checkbox : true,
				bodyHeight : 700 /*그리드 높이지정 */
				,
				showDummyRows : false
			},
			[ {
				header : '시퀀스명',
				name : 'SEQ_NM',
				width : 300,
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
					unique : true
				/*true 데이터가 중복되면 빨간색 표시 */
				},
				editor : 'text'
			},
			{
				header : '시퀀스값',
				name : 'SEQ_NO',
				width : 100,
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
					required : true, /*  true 필수, false 필수아님  */
					unique : false
				/*true 데이터가 중복되면 빨간색 표시 */
				},
				editor : 'text'
			},

			{
				header : '테이블명',
				name : 'TB_NM',
				width : 200,
				sortable : true,
				align : "center",
				sortingType : 'desc', /*내림차순   ctrl 키를 누르고 정렬키를 여러개 누르면 이어서 정렬이 된다.*/
				filter : {
					type : 'text',
					showApplyBtn : true,
					showClearBtn : true
				}, /*text, number, select, date 4가지가 있다.*/
				editor : 'text'
			},

			{
				header : '컬러명',
				name : 'COL_NM',
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
				header : '초기값',
				name : 'INIT_VAL',
				width : 100,
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
				header : '증가값',
				name : 'ALLOCATION_SIZE',
				width : 100,
				resizable : false,
				sortable : true,
				sortingType : 'desc', /*내림차순   ctrl 키를 누르고 정렬키를 여러개 누르면 이어서 정렬이 된다.*/
				filter : {
					type : 'text',
					showApplyBtn : true,
					showClearBtn : true
				}, 
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
			} ]
			);
			grid.build();

			searchForm.addEvent("click","input[type=button]", function(el) {
				switch (el.target.name) {
				case 'search':
					var param = {
						brRq : 'IN_DATA',
						brRs : 'OUT_DATA',
						IN_DATA : [ {} ]
					}
					grid.loadData('findCmSeq', param, function(data) {
						console.log(data);
						//gridLoadData에서 자동으로 로드됨..

					});
					break;
				case 'add_row':
					Message.confirm('행을 추가하시겠습니까?', function() {
						grid.appendRow();
					});
					break;

				case 'save':
					var data = grid.getModifiedRows();
					console.log(data);
					var crt_cnt = data.createdRows.length;
					var updt_cnt = data.updatedRows.length;

					if ((crt_cnt + updt_cnt) == 0) {
						Message.alert("저장할 내용이 존재하지 않습니다.");
						return;
					}
					if (grid.isValid() == false) {
						grid.validMsg();
						return;
					}
				
					Message.confirm('저장하시겠습니까?', function() {
						var param = {
							brRq : 'IN_DATA,UPDT_DATA',
							brRs : '',
							IN_DATA : data.createdRows,
							UPDT_DATA : data.updatedRows
						}
						_this.send('saveCmSeq', param, function(data) {
							Message.alert('저장되었습니다.', function() {
								searchForm.get("search").trigger("click");
							});
						});
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
						_this.send('rmCmSeq', param, function(data) {
							Message.alert('삭제되었습니다.', function() {
								searchForm.get("search").trigger("click");
							});
						});
					});
					break;
				}
			});
			searchForm.get("search").trigger("click");
		});
	});
</script>