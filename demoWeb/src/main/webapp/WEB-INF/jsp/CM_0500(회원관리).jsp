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
	var CM_0500 = new PgmPageMngr ('<%=pgmId%>', '<%=uuid%>');
		CM_0500.init(function(p_param) {
			var _this = CM_0500;
			var searchForm = new FormMngr(_this, "search_area");
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
				}, /*text, number, select, date 4가지가 있다.*/
				validation : {
					dataType : 'string', /*string ,number*/
					required : true, /*  true 필수, false 필수아님  */
					unique : true
				/*true 데이터가 중복되면 빨간색 표시 */
				},
				editor : 'text'
			}, {
				header : '사용자명',
				name : 'USER_NM',
				width : 'auto', /*너비 자동조절*/
				sortable : true,
				filter : {
					type : 'text',
					showApplyBtn : true,
					showClearBtn : true
				},
				editor : 'text'
			},

			{
				header : '사용자ID',
				name : 'USER_ID',
				width : 100,
				sortable : true,
				align : "center",
				filter : 'select', /*콤보 카테고리 */
				formatter : 'listItemText',
				editor : {
					type : 'select',
					options : {
						listItems : [ {
							text : 'CM',
							value : 'CM'
						}, {
							text : '키움',
							value : '키움API'
						}, ]
					}
				}
			}, {
				header : '패스워드',
				name : 'USER_PWD',
				editor : 'text',
				filter : {
					type : 'text',
					operator : 'OR'
				}, /*자동검색*/
				validation : {
					dataType : 'string', /*string ,number*/
					required : true, /*  true 필수, false 필수아님  */
					unique : true
				/*true 데이터가 중복되면 빨간색 표시 */
				},
			}, {
				header : '이메일',
				name : 'EMAIL',
				editor : 'text'
			}, {
			header : '사용여부',
			name : 'USE_YN',
			editor : 'text'
		}, {
			header : '비고',
			name : 'RMK',
			editor : 'text'
		}, {
			header : '마지막접속일',
			name : 'LST_ACC_DTM',
			editor : 'text'
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
				checkbox : true
			});
			grid.build();

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
						_this.showProgress();
						_this.send('saveCmUser', param, function(data) {
							_this.hideProgress();
							if (data) {
								Message.alert('저장되었습니다.', function() {
									searchForm.get("search").trigger("click");
								});
							}

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
						_this.showProgress();
						_this.send('rmCmUser', param, function(data) {
							_this.hideProgress();
							if (data) {
								Message.alert('삭제되었습니다.', function() {
									searchForm.get("search").trigger("click");
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
<!--하단에 공통으로 스크립트를 넣을 것이 필요하다.-->
<%@ include file="/WEB-INF/jsp/include/inner_bottom.jsp"%>