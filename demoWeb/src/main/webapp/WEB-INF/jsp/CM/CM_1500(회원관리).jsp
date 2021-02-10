<%
	String pgmId = (String) request.getAttribute("pgmId");
	String uuid = (String) request.getAttribute("uuid");
%>
<script>
$(document).ready(function(){
	var CM_1500 = new PgmPageMngr ('<%=pgmId%>', '<%=uuid%>');
		CM_1500.init(function(p_param) {
			var _this = CM_1500;
			var searchForm = new FormMngr(_this, "search_area");
			var userForm = new FormMngr(_this, "user_area");
		    $('[data-ax5formatter]').ax5formatter();

			const grid = new TuiGridMngr(_this, 'grid', {
				editable : true,
				showRowStatus : true,
				rowNum : true,
				checkbox : true,
				bodyHeight: 300
			},
			[ {
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
				width : 200,
				sortable : true
			},
			{
				header : '사용자ID',
				name : 'USER_ID',
				width : 100,
				sortable : true,
				align : "center",
				filter : 'select'
			},
			{
				header : '비밀번호',
				name : 'USER_PWD',
				width : 300,
				sortable : true,
				align : "center"
			},
			 {
				header : '이메일',
				name : 'EMAIL',
				width : 140,
			},
		 {
	          header: '사용여부',
	          name: 'USE_YN',
	          formatter: 'listItemText',
	          width : 80,
	          editor: {
	            type: 'select',
	            options: {
	              listItems: [
	                { text: 'Y', value: 'Y' },
	                { text: 'N', value: 'N' },
	              ]
	            }
	          }
		 },

		{
			header : '비고',
			name : 'RMK',
			width : 140
		}, {
			header : '마지막접속일',
			name : 'LST_ACC_DTM',
			width : 140
		}
		, {
				header : '생성일',
				name : 'CRT_DTM',
				width : 140,
				sortable : true,
				align : "center"
			}, {
				header : '수정일',
				name : 'UPDT_DTM',
				width : 140,
				sortable : true,
				align : "center"
			} ]
			);
			grid.build();

			grid.on('click', (ev) => {
				if (ev.rowKey >=0) {
					var row_data=grid.getRow(ev.rowKey);
					console.log(row_data);
					userForm.setDataAll(row_data);
				}
			});



			/*<option value="Y">Y</option>
			  <option value="N">N</option>
			*/
			//userForm.get("USE_YN").select2()
			/*
			var data = [
			    {id: 0,text: 'enhancement'},
			    {id: 1,text: 'bug'}
			];
			userForm.get("USE_YN").select2({
			  data: data
			})
			ajax용 코드도 있는데 너무 붙어있다.  따로 호출해서 달자.
			*/
			var param = {
					brRq : 'IN_DATA',
					brRs : 'OUT_DATA',
					IN_DATA : [ { GRP_CD : 'USE_YN'
						,USE_YN : 'Y' } ]
			}
			_this.send('BR_CM_CD_FIND', param, function(data) {
				_this.hideProgress();
				if (data) {
					//콤보박스 세팅
					var arr_data = []
					console.log(data.OUT_DATA);
					if(data.OUT_DATA){
						for(var i =0;i<data.OUT_DATA.length;i++){
							var tmp =data.OUT_DATA[i];
							arr_data.push({ id: tmp.CD , text: tmp.CD_NM  })
						}
					}
					console.log(arr_data);
					userForm.addSelect2("USE_YN",arr_data);
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
					grid.loadData('BR_CM_USER_FIND', param, function(data) {
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
						_this.send('BR_CM_USER_RM', param, function(data) {
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

					if(PjtUtil.isEmpty(data.USER_NO)){
						//비밀번호 체크
						if(PjtUtil.isEmpty(data.USER_PWD)){
							Message.alert("비밀번호를 입력해주세요.");
							return;
						}
						if(PjtUtil.isEmpty(data.RE_USER_PWD)){
							Message.alert("비밀번호확인을 입력해주세요.");
							return;
						}
						if(data.RE_USER_PWD!==data.USER_PWD){
							Message.alert("비밀번호와 비밀번호확인이 같지 않습니다.");
							return;
						}				
					}

					Message.confirm('저장하시겠습니까?', function() {
						var param = {
							brRq : 'IN_DATA',
							brRs : '',
							IN_DATA : [ data ],
						}
						_this.send('BR_CM_USER_SAVE', param, function(data) {
							if(data){
								Message.alert('저장되었습니다.', function() {
									searchForm.get("search").trigger("click");
									userForm.clearData();
								});
							}
						});
					});
					
					break;
				case "change_user_pwd":
					var data = userForm.getData();
					console.log(data);

					if(PjtUtil.isEmpty(data.USER_NO)){
						Message.alert("비밀번호 변경을 위해 회원을 선택해주세요.");
						return;
					}
					//비밀번호 체크
					if(PjtUtil.isEmpty(data.USER_PWD)){
						Message.alert("비밀번호를 입력해주세요.");
						return;
					}
					if(PjtUtil.isEmpty(data.RE_USER_PWD)){
						Message.alert("비밀번호확인을 입력해주세요.");
						return;
					}
					if(data.RE_USER_PWD!==data.USER_PWD){
						Message.alert("비밀번호와 비밀번호확인이 같지 않습니다.");
						return;
					}				
					
					Message.confirm('비밀번호변경을 하시겠습니까?', function() {
						var param = {
							brRq : 'IN_DATA',
							brRs : '',
							IN_DATA : [ data ],
						}
						_this.send('BR_CHANGE_USER_PWD', param, function(data) {
							console.log('aaa');
							console.log(data);
							console.log('bbbb');
							if(data){
								Message.alert('비밀번호변경하였습니다.', function() {
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