<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/include/inner_top.jsp"%>
<%
    String pgmId = (String) request.getAttribute("pgmId");
String uuid = (String) request.getAttribute("uuid");
%>
<div id="<%=uuid%>">
	<div name="search_area">
		<table>
			<tr>
				<td><input type="button" name="search" value="조회" /></td>
				<td><input type="button" name="add_row" value="추가" /></td>
				<td><input type="button" name="save" value="저장" /></td>
				<td><input type="button" name="del" value="삭제" /></td>
			</tr>
		</table>
	</div>
	<div name="grid"></div>
</div>
<script>
$(document).ready(function(){
	var CM_0300 = new PgmPageMngr ('<%=pgmId%>', '<%=uuid%>
	');
		CM_0300.init(function(p_param) {
			var _this = CM_0300;
			var searchForm = new FormMngr(_this, "search_area");
			var columns = [ {
				header : '메뉴코드',
				name : 'MENU_CD',
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
					unique : true
				/*true 데이터가 중복되면 빨간색 표시 */
				},
				editor : 'text'
			},
			{
				header : '메뉴명',
				name : 'MENU_NM',
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
				header : '부모메뉴코드',
				name : 'PRNT_MENU_CD',
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
				header : '첫번째정렬',
				name : 'FST_ORD',
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
			}, {
				header : '두번째정렬',
				name : 'SED_ORD',
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
			}, {
				header : '프로그램',
				name : 'PGM_ID',
				width : 100,
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
			}, {
				header : '종류',
				name : 'MENU_KIND',
				width : 100,
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
			}, {
				header : '비고',
				name : 'RMK',
				width : 300,
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

			const grid = new TuiGridMngr(_this, 'grid', columns, {
				editable : true,
				showRowStatus : true,
				rowNum : true,
				checkbox : true,
				width : 1400 /*그리드 너비 조절 */
				,
				bodyHeight : 700 /*그리드 높이지정 */
				,
				showDummyRows : false
			});
			grid.build();

			searchForm.addEvent("click", function(el) {
				switch (el.target.name) {
				case 'search':
					var param = {
						brRq : 'IN_DATA',
						brRs : 'OUT_DATA',
						IN_DATA : [ {} ]
					}
					grid.loadData('findMenu', param, function(data) {
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
					var in_data = [];
					for (var i = 0; i < crt_cnt; i++) {
						var row = data.createdRows[i];
						in_data.push({
							MENU_CD : row.MENU_CD,
							MENU_NM : row.MENU_NM,
							PRNT_MENU_CD : row.PRNT_MENU_CD,
							FST_ORD : row.FST_ORD,
							SED_ORD : row.SED_ORD,
							PGM_ID : row.PGM_ID,
							MENU_KIND : row.MENU_KIND,
							RMK : row.RMK

						});
					}

					var updt_data = [];
					for (var i = 0; i < updt_cnt; i++) {
						var row = data.updatedRows[i];
						updt_data.push({
							MENU_CD : row.MENU_CD,
							MENU_NM : row.MENU_NM,
							PRNT_MENU_CD : row.PRNT_MENU_CD,
							FST_ORD : row.FST_ORD,
							SED_ORD : row.SED_ORD,
							PGM_ID : row.PGM_ID,
							MENU_KIND : row.MENU_KIND,
							RMK : row.RMK
						});
					}

					Message.confirm('저장하시겠습니까?', function() {
						var param = {
							brRq : 'IN_DATA,UPDT_DATA',
							brRs : '',
							IN_DATA : in_data,
							UPDT_DATA : updt_data
						}
						_this.send('saveDomain', param, function(data) {
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
					var in_data = [];
					for (var i = 0; i < data.length; i++) {
						var row = data[i];
						in_data.push({
							MENU_CD : row.MENU_CD
						});
					}
					Message.confirm('삭제하시겠습니까?', function() {
						var param = {
							brRq : 'IN_DATA',
							brRs : '',
							IN_DATA : in_data
						}
						_this.send('rmMenu', param, function(data) {
							Message.alert('삭제되었습니다.', function() {
								searchForm.get("search").trigger("click");
							});
						});
					});
					//실제로 서버에서 삭제하는로직 필요.
					//grid.removeRow(0); 
					break;
				}
			});
			searchForm.get("search").trigger("click");
		});
	});
</script>
<%@ include file="/WEB-INF/jsp/include/inner_bottom.jsp"%>