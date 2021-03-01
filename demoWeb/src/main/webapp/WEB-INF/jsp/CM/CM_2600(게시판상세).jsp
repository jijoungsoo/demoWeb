<%	String uuid = (String) request.getAttribute("uuid"); %>
<script>
$(document).ready(function(){
	var CM_2600 = new PgmPageMngr ('<%=uuid%>');
	CM_2600.init(function(p_param) {
		var _this = CM_2600;
		
		var childForm = new ChildMngr(_this, "child_area",'CM_2800');

		var brdDetailForm = new FormMngr(_this, "brd_detail_area");
		brdDetailForm.initCombo("GRP_SEQ",'BR_CM_BOARD_GROUP_FIND', {brRq: 'IN_DATA',brRs: 'OUT_DATA',IN_DATA: [{USE_YN: 'Y'}]},{ USE_EMPTY_YN : 'Y' , VALUE :'GRP_SEQ' , TEXT :'GRP_NM' });
		_this.on("remoteCall",function(data){
			console.log('remoteCall  ---  vvvvvv')
			var detail =data.detail; 
			console.log(detail);
			switch (detail.ACTION) {
				case 'SEARCH':
					search(detail.BRD_SEQ);					
				break;
			}
		});

		function search(brd_seq){
			var param = {
						brRq: 'IN_DATA',
						brRs: 'OUT_DATA',
						IN_DATA: [{
							BRD_SEQ : brd_seq
						}]
					}
			_this.showProgress();
			_this.send('BR_CM_BOARD_FIND_BY_BRD_SEQ', param, function(data) {
				_this.hideProgress();
				if (data) {
					var row_data = data.OUT_DATA[0];
					console.log(row_data);
					brdDetailForm.setDataAll(row_data);
					console.log('aaaaaaaaaaaaaaaaaaaa');
					console.log(row_data.CNTNT);
					console.log(_this.get("CNTNT"));
					_this.get("CNTNT")[0].innerHTML=row_data.CNTNT;
					var param = {
							ACTION  : 'SEARCH',
							BRD_SEQ : row_data.BRD_SEQ
					}
					childForm.remoteCall({ detail: param });
				}
			});	
		}

		brdDetailForm.addEvent("click", "input[type=button]", function (el) {
				switch (el.target.name) {
					case 'del':
						var data = brdDetailForm.getData();
						if (PjtUtil.isEmpty(data.BRD_SEQ) == true) {
							Message.alert("삭제할 게시물이 존재하지 않습니다.");
							return;
						}
						Message.confirm('게시물을 삭제하시겠습니까?', function () {
							var param ={
								brRq : 'IN_DATA,LSESSION'
								,brRs : ''
								,IN_DATA: [{
									BRD_SEQ: data.BRD_SEQ
								}]
							}
							_this.showProgress();
							_this.send('BR_CM_BOARD_RM',param,function(data2){
								_this.hideProgress();
								if(data2){
									Message.alert('삭제되었습니다.',function()  {
										brdDetailForm.clearData();
										//_this.remoteCall('')
										//리모트로  상단 게시물을 재조회한다.
										var param = {
												ACTION  : 'SEARCH',
												BRD_SEQ : data.BRD_SEQ
										}
										console.log(param);
										_this.parentCall({ detail: param });
									});
								}			        	
							});
						});
						
						break;
					case 'modify':
						console.log('modify')
						var data = brdDetailForm.getData();
						console.log(data);

						if (PjtUtil.isEmpty(data.BRD_SEQ) == true) {
							Message.alert("수정할 게시물이 존재하지 않습니다.");
							return;
						}
						let brd_seq = data.BRD_SEQ;
						var param = {
							GRP_SEQ: data.GRP_SEQ,
							BRD_SEQ: brd_seq
						}
						var popup = new PopupManger(_this, 'CM_2700', {
								width: 1100,
								height: 900,
								title: "게시판수정"
							},
							param
						);
						popup.open(function (data) {
							if (data) {
								search(brd_seq);
								var param = {
										ACTION  : 'SEARCH',
										BRD_SEQ : brd_seq
								}
								console.log(param);
								_this.parentCall({ detail: param });

							}
						});
						break;
				}
			});
	});
});
</script>