<%	String uuid = (String) request.getAttribute("uuid"); %>
<script>
$(document).ready(function(){
	var inline_popup;
	var myEditor;
	var CM_2800 = new PgmPageMngr ('<%=uuid%>');
	CM_2800.init(function(p_param) {
		var _this = CM_2800;
		var cmtForm = new FormMngr(_this, "cmt_area");
		var popupCmtForm = new FormMngr(_this, "popup_cmt");

		//에디터
		DecoupledEditor
		.create(popupCmtForm.get( "CNTNT")[0] )
		.then(editor=>{
			const toolbarContainer = _this.getEl()[0].querySelector("[name=toolbar-container]");
			toolbarContainer.appendChild( editor.ui.view.toolbar.element );
			console.log( 'Editor was initialized', editor );
			myEditor = editor;
		})
		.catch( error => {
			console.error( error );
		} );
		//에디터

		console.log('cmtForm');
		console.log(cmtForm);

		console.log(_this);
		
		_this.on("remoteCall",function(data){
			console.log('remoteCall  ---  vvvvvv')
			var detail =data.detail; 
			console.log(detail);
			switch (detail.ACTION) {
				case 'SEARCH':
					var brd_seq = detail.BRD_SEQ;
					cmtForm.setData("BRD_SEQ",brd_seq);
					cmtForm.get("searchCmt").trigger("click");
				break;
			}
		});

		
		cmtForm.addEvent("click", "input[type=button]", function(el) {
			console.log(el);
			switch (el.target.name) {
			case "searchCmt":
				var brd_seq = cmtForm.getData('BRD_SEQ');
				console.log(brd_seq);
				var param = {
						brRq : 'IN_DATA',
						brRs : '',
						IN_DATA : [ {
							BRD_SEQ : brd_seq
						} ],
				}
				_this.showProgress();							    			
				_this.send('BR_CM_BOARD_CMT_FIND', param, function(data) {
					_this.hideProgress();
					if(data){
						console.log(data);
						cmtList(data.OUT_DATA);
						

						/*삭제랑 수정 이벤트는 별도로 넣어줘야겠다.*/
						cmtForm.addEvent("click", "input[type=button]", function(el,el2) {
							console.log(el);
							switch (el.target.name) {
								case 'delCmt':
								Message.confirm('삭제하시겠습니까?', function() {
									var tmp =el.target;
									var cmt_seq = $(tmp).attr("cmt_seq");
									console.log(cmt_seq);
									_this.showProgress();
									var param = {
											brRq : 'IN_DATA',
											brRs : '',
											IN_DATA : [ {
												CMT_SEQ : cmt_seq
											} ],
									}							    			
									_this.send('BR_CM_BOARD_CMT_RM', param, function(data2) {
										_this.hideProgress();
										if(data2){
											cmtForm.get("searchCmt").trigger("click");
										}
									});

								});
									
									
								break;
								case 'modifyCmt':
									var tmp =el.target;
									var cmt_seq = $(tmp).attr("cmt_seq");
									console.log(brd_seq);

									if(PjtUtil.isEmpty(brd_seq)){
										Message.alert("게시물SEQ가 없으면 댓글 등록을 할수 없습니다.");
										return;
									}
									if(PjtUtil.isEmpty(cmt_seq)){
										Message.alert("댓글SEQ가 없으면 댓글 등록을 할수 없습니다.");
										return;
									}
									/* 데이터를 읽어서 표기해야한다.*/
									_this.showProgress();
									var param = {
											brRq : 'IN_DATA',
											brRs : '',
											IN_DATA : [ {
												CMT_SEQ : cmt_seq
											} ],
									}							    			
									_this.send('BR_CM_BOARD_CMT_FIND_BY_CMT_SEQ', param, function(data2) {
										_this.hideProgress();
										if(data2){
											var row_data = data2.OUT_DATA[0];
											popupCmtForm.setData("BRD_SEQ",row_data.BRD_SEQ);
											popupCmtForm.setData("CMT_SEQ",row_data.CMT_SEQ);
											$('[data-ax5formatter]').ax5formatter();						

											popupCmtForm.setDataAll(row_data);
											myEditor.setData(row_data.CNTNT);		
											inline_popup = new InlinePopupManger(_this, 'popup_cmt', {
												width: 800,
												height: 300,
												title: "댓글수정"
											});
											inline_popup.open(function(data){
												if(data){
													console.log(data);
													popupCmtForm.clearData()
															
												}
											});
										}
									});


									
								break;
							}
						});
					}
				});

				break;
			case "saveCmt":
				var brd_seq = cmtForm.getData('BRD_SEQ');
				console.log(brd_seq);

				if(PjtUtil.isEmpty(brd_seq)){
					Message.alert("게시물번호가 없으면 댓글 등록을 할수 없습니다.");
					return;
				}
				var brd_seq = cmtForm.getData("BRD_SEQ");
				popupCmtForm.setData("BRD_SEQ",brd_seq);
				$('[data-ax5formatter]').ax5formatter();						

				inline_popup = new InlinePopupManger(_this, 'popup_cmt', {
					width: 800,
					height: 300,
					title: "댓글입력"
				});
				inline_popup.open(function(data){
					if(data){
						console.log(data);
						popupCmtForm.clearData()
						myEditor.setData("");				
					}
				});
							
				break;	
			}
		});

		popupCmtForm.addEvent("click", "input[type=button]", function(el) {
			//console.log(el);
			switch (el.target.name) {
			case "save":
			var data = popupCmtForm.getData();
				console.log(data);
			
				data.CNTNT = myEditor.getData();
				if(PjtUtil.isEmpty(data.CNTNT)){
					Message.alert("내용을 입력해주세요.");
					return;
				}

				Message.confirm('저장하시겠습니까?', function() {
					var param = {
						brRq : 'IN_DATA',
						brRs : '',
						IN_DATA : [ data ],
					}
					_this.send('BR_CM_BOARD_CMT_SAVE', param, function(data) {
						if(data){
							Message.alert('저장되었습니다.', function() {
								console.log(data);
								inline_popup.close(data);
								cmtForm.get("searchCmt").trigger("click");
							});
						}
					});
				});					
				break;									
			case "close":
			inline_popup.close();
				break;
			}
		});

		function cmtList(cm_list_item){
			/*
			var cm_list_item=[{
				CMT_SEQ : "1",
				CNTNT : "안녕하세요내용입니다.",
				CRT_USR_NO : "내용"

			}]
			*/
			$( _this.getEl()[0].querySelector("[name=cmt_list]") ).empty();
			var brd_cmt_template_html = $(_this.getEl()[0].querySelector("[name=brd_cmt-template]")).html();
			var brd_cmt_template = Handlebars.compile(brd_cmt_template_html);
			var cmt_data = { cmtList : cm_list_item };
			//console.log(left_menu);
			var tmp =brd_cmt_template(cmt_data);
			//console.log(tmp);
			$( _this.getEl()[0].querySelector("[name=cmt_list]") ).append(tmp);
		}
		cmtList();
	});
});
</script>