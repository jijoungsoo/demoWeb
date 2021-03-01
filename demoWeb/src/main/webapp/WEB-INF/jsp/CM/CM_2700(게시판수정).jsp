<%	String uuid = (String) request.getAttribute("uuid"); %>
<script>
$(document).ready(function(){
	var CM_2700 = new PgmPageMngr ('<%=uuid%>');
	var myEditor;
	CM_2700.init(function(p_param) {
		console.log(p_param);
		var _this = CM_2700;
		
		if(p_param.param==null){
			Message.alert('파라미터가 넘어오지 않았습니다.', function() {});
			_this.close();
			return;
		}
		if(PjtUtil.isEmpty(p_param.param,GRP_SEQ)==true){
			Message.alert('파라미터가 넘어오지 않았습니다2.', function() {});
			_this.close();
			return;
		}
		console.log(p_param.param);
		var GRP_SEQ = p_param.param.GRP_SEQ;
		var brd_seq = null;

		var brdModifyForm = new FormMngr(_this, "brd_modify_area");
		brdModifyForm.initCombo("GRP_SEQ",'BR_CM_BOARD_GROUP_FIND', {brRq: 'IN_DATA',brRs: 'OUT_DATA',IN_DATA: [{USE_YN: 'Y'}]},{ USE_EMPTY_YN : 'Y' , VALUE :'GRP_SEQ' , TEXT :'GRP_NM' });
		brdModifyForm.setData("GRP_SEQ",GRP_SEQ);
		$('[data-ax5formatter]').ax5formatter();

		console.log(_this);
		//에디터
		DecoupledEditor
        .create( _this.get( "CNTNT")[0] )
		.then(editor=>{   
			const toolbarContainer = document.querySelector("[name=toolbar-container]");
			toolbarContainer.appendChild( editor.ui.view.toolbar.element );
			console.log( 'Editor was initialized', editor );
			myEditor = editor;
		})
        .catch( error => {
            console.error( error );
        } );
		//에디터

		if(PjtUtil.isEmpty(p_param.param.BRD_SEQ)==false){
			brd_seq = p_param.param.BRD_SEQ;
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
					brdModifyForm.setDataAll(row_data);
					myEditor.setData(row_data.CNTNT)
					//brdDetailForm.setDataAll(row_data);
					//var tmp = row_data.CNTNT;
					//console.log('cntnt');
					//console.log(tmp);
					//console.log(editor);
					//editor.setContents(tmp);
				}
			});	
		}
	



	
		
		brdModifyForm.addEvent("click", "input[type=button]", function(el) {
			//console.log(el);
			switch (el.target.name) {
			case "save":
				var data = brdModifyForm.getData();
				console.log(data);
				
				//비밀번호 체크
				if(PjtUtil.isEmpty(data.TTL)){
					Message.alert("제목을 입력해주세요.");
					return;
				}
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
					_this.send('BR_CM_BOARD_SAVE', param, function(data) {
						if(data){
							Message.alert('저장되었습니다.', function() {
								console.log(data);
								_this.close(data);
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