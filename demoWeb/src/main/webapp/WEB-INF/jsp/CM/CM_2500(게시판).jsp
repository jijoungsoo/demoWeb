<%	String pgmId = (String) request.getAttribute("pgmId");
	String uuid = (String) request.getAttribute("uuid");
%>
<script>
	$(document).ready(function () {
		var CM_2400 = new PgmPageMngr('<%=pgmId%>', '<%=uuid%>');
		CM_2400.init(function (p_param) {
			var _this = CM_2400;
			var searchForm = new FormMngr(_this, "search_area");
			console.log(_this)
			var tabForm = new TabMngr(_this, "tab_area");

			tabForm.appendTab(
				[	{INDEX : 0,  PGM_ID : 'CM_2700' ,PARAM : null } ]
			);

			tabForm.build({
				active: 1
			});		
			

			var param = {
				brRq: 'IN_DATA',
				brRs: 'OUT_DATA',
				IN_DATA: [{
					USE_YN: 'Y'
				}]
			}
			_this.send_sync('BR_CM_BOARD_GROUP_FIND', param, function (data) {
				_this.hideProgress();
				if (data) {
					//콤보박스 세팅
					var arr_data = []
					console.log(data.OUT_DATA);
					if (data.OUT_DATA) {
						for (var i = 0; i < data.OUT_DATA.length; i++) {
							var tmp = data.OUT_DATA[i];
							console.log(tmp);
							arr_data.push({
								id: tmp.GRP_SEQ,
								text: tmp.GRP_NM
							})
						}
					}
					searchForm.addSelect2("GRP_SEQ", arr_data, true);
					_this.get("GRP_SEQ").val('').select2(); //최초 빈값 설정
				}
			});



			const grid = new TuiGridMngr(_this, 'grid', {
					editable: false,
					showRowStatus: false,
					rowNum: true,
					checkbox: false,
					width: 1400 /*그리드 너비 조절 */ ,
					bodyHeight: 700 /*그리드 높이지정 */ ,
					showDummyRows: false
				},
				[{
						header: '관리일련번호',
						name: 'GRP_SEQ',
						width: 100,
						hidden: true
					}, {
						header: 'BRD_SEQ',
						name: 'BRD_SEQ',
						width: 100
					}, {
						header: '게시판번호',
						name: 'BRD_NO',
						width: 100,
						hidden: true
					}, {
						header: '게시판답글순서',
						name: 'BRD_RPLY_ORD',
						width: 100,
						hidden: true
					}, {
						header: '답글깊이',
						name: 'BRD_DPTH',
						width: 100,
						hidden: true
					}, {
						header: '참조일련번호',
						name: 'REF_BRD_SEQ',
						width: 100,
						hidden: true
					}, {
						header: '제목',
						name: 'TTL',
						width: 200
					}, {
						header: '내용',
						name: 'CNTNT',
						width: 200,
						resizable: false,
					}, {
						header: '삭제여부',
						name: 'DEL_YN',
						width: 100,
						sortable: true,
						align: "center"
					}, {

						header: '생성일',
						name: 'CRT_DTM',
						width: 140,
						sortable: true,
						align: "center"
					},
					{
						header: '수정일',
						name: 'UPDT_DTM',
						width: 140,
						sortable: true,
						align: "center"
					}
				]
			);
			grid.build();

			grid.on('click', (ev) => {
				if (ev.rowKey >=0) {
					var row_data=grid.getRow(ev.rowKey);
					console.log(row_data);
					
				}
			});

			searchForm.addEvent("click", "input[type=button]", function (el) {
				switch (el.target.name) {
					case 'search':
						var param = {
							brRq: 'IN_DATA',
							brRs: 'OUT_DATA',
							IN_DATA: [{}]
						}
						grid.loadData('BR_CM_BOARD_FIND', param, function (data) {

						});
						break;
					case 'add_row':
						var data = _this.get("GRP_SEQ").select2('data')
						console.log(data);

						if (PjtUtil.isEmpty(data[0].id) == true) {

							Message.alert("게시판선택을 선택해주세요.");
							return;
						}

						Message.confirm('신규게시물을 등록하시겠습니까?', function () {
							var param = {
								GRP_SEQ: data[0].id,
								GRP_NM: data[0].text,
							}
							var popup = new PopupManger(_this, 'CM_2700', {
									width: 1100,
									height: 900,
									title: "게시판등록/수정"
								},
								param
							);
							popup.open(function (data) {
								if (data) {
									console.log(data);
									searchForm.get("search").trigger("click");
								}
							});
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

						Message.confirm('저장하시겠습니까?', function () {
							var param = {
								brRq: 'IN_DATA,UPDT_DATA',
								brRs: '',
								IN_DATA: data.createdRows,
								UPDT_DATA: data.updatedRows
							}
							_this.showProgress();
							_this.send('BR_CM_BOARD_SAVE', param, function (data) {
								_this.hideProgress();
								if (data) {
									Message.alert('저장되었습니다.', function () {
										searchForm.get("search").trigger(
											"click");
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
						var in_data = [];
						for (var i = 0; i < data.length; i++) {
							var row = data[i];
							in_data.push({
								DMN_NO: row.DMN_NO
							});
						}
						Message.confirm('삭제하시겠습니까?', function () {
							var param = {
								brRq: 'IN_DATA,LSESSION',
								brRs: '',
								IN_DATA: in_data
							}
							_this.showProgress();
							_this.send('BR_CM_BOARD_RM', param, function (data) {
								_this.hideProgress();
								if (data) {
									Message.alert('삭제되었습니다.', function () {
										searchForm.get("search").trigger(
											"click");
									});
								}
							});
						});
						//실제로 서버에서 삭제하는로직 필요.
						//grid.removeRow(0); 
						break;
				}
			});
		});
	});
</script>