<%	String pgmId = (String) request.getAttribute("pgmId");
	String uuid = (String) request.getAttribute("uuid");
%>
<script>
$(document).ready(function(){
	var CM_2700 = new PgmPageMngr ('<%=pgmId%>', '<%=uuid%>');
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
		var GRP_SEQ = p_param.param.GRP_SEQ;
		

		var userForm = new FormMngr(_this, "user_area");
		$('[data-ax5formatter]').ax5formatter();

		var param = {
				brRq : 'IN_DATA',
				brRs : 'OUT_DATA',
				IN_DATA : [ { USE_YN : 'Y' } ]
		}
		_this.send_sync('BR_CM_BOARD_GROUP_FIND', param, function(data) {
			_this.hideProgress();
			if (data) {
				//콤보박스 세팅
				var arr_data = []
				console.log(data.OUT_DATA);
				if(data.OUT_DATA){
					for(var i =0;i<data.OUT_DATA.length;i++){
						var tmp =data.OUT_DATA[i];
						console.log(tmp);
						arr_data.push({ id: tmp.GRP_SEQ , text: tmp.GRP_NM  })
					}
				}
				userForm.addSelect2("GRP_SEQ",arr_data,true);
				_this.get("GRP_SEQ").val(GRP_SEQ).select2();  //최초 빈값 설정
			}
		});	
		
		userForm.addEvent("click", "input[type=button]", function(el) {
			//console.log(el);
			switch (el.target.name) {
			case "save":
				var data = userForm.getData();
				console.log(data);
				
				//비밀번호 체크
				if(PjtUtil.isEmpty(data.TTL)){
					Message.alert("제목을 입력해주세요.");
					return;
				}
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