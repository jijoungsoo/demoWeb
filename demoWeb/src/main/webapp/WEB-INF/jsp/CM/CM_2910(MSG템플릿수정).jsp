<%	String uuid = (String) request.getAttribute("uuid"); %>
<script>
$(document).ready(function(){
	var CM_2910 = new PgmPageMngr ('<%=uuid%>');
	var myEditor;
	CM_2910.init(function(p_param) {
		console.log(p_param);
		var _this = CM_2910;
		var mtmForm = new FormMngr(_this, "msg_tmpl_modify_area");
		mtmForm.initCombo("SND_KIND_CD",'BR_CM_CD_FIND', {brRq: 'IN_DATA',brRs: 'OUT_DATA',IN_DATA: [{  GRP_CD : 'SND_KIND_CD', USE_YN: 'Y'}]},{ USE_EMPTY_YN : 'Y' , VALUE :'CD' , TEXT :'CD_NM' });
		mtmForm.initCombo("MSG_TMPL_STATUS_CD",'BR_CM_CD_FIND', {brRq: 'IN_DATA',brRs: 'OUT_DATA',IN_DATA: [{  GRP_CD : 'MSG_TMPL_STATUS_CD', USE_YN: 'Y'}]},{ USE_EMPTY_YN : 'Y' , VALUE :'CD' , TEXT :'CD_NM' });
		mtmForm.setData("SND_KIND_CD","");
		mtmForm.setData("MSG_TMPL_STATUS_CD","");
		$('[data-ax5formatter]').ax5formatter();

		_this.on("remoteCall",function(data){
			console.log('remoteCall  ---  vvvvvv')
			var detail =data.detail; 
			console.log(detail);
			switch (detail.ACTION) {
				case 'SEARCH':
					mtmForm.setData("TMPL_SEQ",detail.TMPL_SEQ);				
					mtmForm.get("search").trigger("click");
				break;
			}
		});

		
		mtmForm.addEvent("click", "input[type=button]", function(el) {
			//console.log(el);
			switch (el.target.name) {
			case "search":
				var data = mtmForm.getData();
				var param = {
						brRq : 'IN_DATA',
						brRs : 'OUT_DATA',
						IN_DATA : [ data ],
				}
				_this.showProgress();
				_this.send('BR_CM_MSG_TMPL_FIND_BY_TMPL_SEQ',param,function(data){
					_this.hideProgress();
					if(data && data.OUT_DATA){
						//초기화하고 리모트콜로 게시판 을 조회하는걸 넣는다.
						row_data = data.OUT_DATA[0];
						console.log(row_data);
						mtmForm.setDataAll(row_data);
						//mtmForm
					}
				});

				break;
			case "save":
				var data = mtmForm.getData();
				console.log(data);
				
				if(PjtUtil.isEmpty(data.SND_KIND_CD)){
					Message.alert("템플릿구분을 입력해주세요.");
					return;
				}

				if(PjtUtil.isEmpty(data.TTL)){
					Message.alert("제목을 입력해주세요.");
					return;
				}
				if(PjtUtil.isEmpty(data.MSG)){
					Message.alert("내용을 입력해주세요.");
					return;
				}

				Message.confirm('저장하시겠습니까?', function() {
					var param = {
						brRq : 'IN_DATA',
						brRs : '',
						IN_DATA : [ data ],
					}
					_this.send('BR_CM_MSG_TMPL_SAVE', param, function(data2) {
						if(data2){
							Message.alert('저장되었습니다.', function() {
								console.log(data);
								mtmForm.clearData();
								var param = {
										ACTION  : 'SEARCH'
								}
								_this.parentCall({ detail: param });
							});
						}
					});
				});					
				break;		
			case "del":
				var data = mtmForm.getData();
				console.log(data);
				
				//비밀번호 체크
				if(PjtUtil.isEmpty(data.TMPL_SEQ)){
					Message.alert("템플릿SEQ가 비어있습니다.");
					return;
				}
				
				Message.confirm('삭제하시겠습니까?', function() {
					var param = {
						brRq : 'IN_DATA',
						brRs : '',
						IN_DATA : [ {
							TMPL_SEQ :  data.TMPL_SEQ,
							MSG_TMPL_STATUS_CD :  'D'
						}
						],
					}
					_this.send('BR_CM_MSG_TMPL_CHG', param, function(data2) {
						if(data2){
							Message.alert('삭제되었습니다.', function() {
								console.log(data);
								//리모트로  상단 게시물을 재조회한다.
								var param = {
										ACTION  : 'SEARCH'
								}
								console.log(param);
								mtmForm.clearData();
								_this.parentCall({ detail: param });
							});
						}
					});
				});					
				break;		
			case "use":
				var data = mtmForm.getData();
				console.log(data);
				
				//비밀번호 체크
				if(PjtUtil.isEmpty(data.TMPL_SEQ)){
					Message.alert("템플릿SEQ가 비어있습니다.");
					return;
				}
				
				Message.confirm('사용으로 변경하시겠습니까?', function() {
					var param = {
						brRq : 'IN_DATA',
						brRs : '',
						IN_DATA : [ {
							TMPL_SEQ :  data.TMPL_SEQ,
							MSG_TMPL_STATUS_CD :  'U'

						} ],
					}
					_this.send('BR_CM_MSG_TMPL_CHG', param, function(data2) {
						if(data2){
							Message.alert('변경되었습니다.', function() {
								console.log(data);
								//리모트로  상단 게시물을 재조회한다.
								var param = {
										ACTION  : 'SEARCH'
								}
								console.log(param);
								mtmForm.clearData();
								_this.parentCall({ detail: param });
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