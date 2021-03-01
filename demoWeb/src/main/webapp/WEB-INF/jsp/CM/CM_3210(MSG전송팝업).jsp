<%	String uuid = (String) request.getAttribute("uuid"); %>
<script>
$(document).ready(function(){
	var CM_3210 = new PgmPageMngr ('<%=uuid%>');
	var myEditor;
	CM_3210.init(function(p_param) {
		console.log(p_param);
		var _this = CM_3210;
		var arr_rcv_list = [];
		var msgForm = new FormMngr(_this, "msg_snd_area");
		msgForm.initCombo("SND_KIND_CD",'BR_CM_CD_FIND', {brRq: 'IN_DATA',brRs: 'OUT_DATA',IN_DATA: [{  GRP_CD : 'SND_KIND_CD', USE_YN: 'Y'}]},{ USE_EMPTY_YN : 'Y' , VALUE :'CD' , TEXT :'CD_NM' });
		msgForm.initCombo("SND_TYPE_CD",'BR_CM_CD_FIND', {brRq: 'IN_DATA',brRs: 'OUT_DATA',IN_DATA: [{  GRP_CD : 'SND_TYPE_CD', USE_YN: 'Y'}]},{ USE_EMPTY_YN : 'Y' , VALUE :'CD' , TEXT :'CD_NM' });
		msgForm.setData("SND_KIND_CD","");
		msgForm.setData("SND_TYPE_CD","");
		$('[data-ax5formatter]').ax5formatter();

		function rcvList(){
			$( _this.getEl()[0].querySelector("[name=rcv_list]") ).empty();
			var rcv_list_template_html = $(_this.getEl()[0].querySelector("[name=rcv-list-template]")).html();
			var rcv_list_template = Handlebars.compile(rcv_list_template_html);
			var rcv_data = { rcvList : arr_rcv_list };
			var tmp =rcv_list_template(rcv_data);
			//console.log(tmp);
			$( _this.getEl()[0].querySelector("[name=rcv_list]") ).append(tmp);
			msgForm.addEvent("click", "input[type=button]", function(el) {
				//console.log(el);
				switch (el.target.name) {
					case "rcvDel":
					var tmp =el.target;
					var key = $(tmp).attr("key");

					Message.confirm('받는 사람을 삭제하시겠습니까?', function() {
						var sel_index=-1;
						for(var i=0;i<arr_rcv_list.length;i++){							
								if(key==i){
									sel_index=i;
								}
						}
						delete arr_rcv_list[sel_index];
						rcvList();
					});					
					break;		
				}
			});
		}
		
		msgForm.addEvent("click", "input[type=button]", function(el) {
			//console.log(el);
			switch (el.target.name) {
			case "rcvAdd":
				var data = msgForm.getData();
				console.log('rcvAdd');
				console.log(msgForm);
				console.log(data);
				var rcv_nm = data["RCV_NM"];
				var rcv_tel_no = data["RCV_TEL_NO"];
				
				if(PjtUtil.isEmpty(rcv_nm)==true){
					Message.alert("받는 사람을 입력해주세요.");
					return;
				}

				if(PjtUtil.isTelNo(rcv_tel_no)==false){
					Message.alert("받는 전화번호는 필수입니다.");
					return;
				}
				arr_rcv_list.push({
					RCV_NM : rcv_nm,
					RCV_TEL_NO: rcv_tel_no
				})
				rcvList();
				msgForm.setData("RCV_NM","");
				msgForm.setData("RCV_TEL_NO","");
				break;
			case "snd":
				var data = msgForm.getData();
				console.log(data);

				if(PjtUtil.isEmpty(data.SND_KIND_CD)){
					Message.alert("발송구분을 입력해주세요.");
					return;
				}
				
				if(PjtUtil.isEmpty(data.SND_TYPE_CD)){
					Message.alert("발송타입을 입력해주세요.");
					return;
				}

				if(PjtUtil.isEmpty(data.SNDR_NM)==true){
					Message.alert("보내는 사람을 입력해주세요.");
					return;
				}

				if(PjtUtil.isTelNo(data.SNDR_TEL_NO)==false){
					Message.alert("보내는 전화번호는 필수입니다.");
					return;
				}

				if(arr_rcv_list.length==0){
					Message.alert("받는 전화번호를 등록해주세요.");
					return;
				}

				if(PjtUtil.isEmpty(data.MSG)){
					Message.alert("내용을 입력해주세요.");
					return;
				}

				Message.confirm('발송하시겠습니까?', function() {
					var param = {
						brRq : 'IN_DATA,RCV_DATA',
						brRs : '',
						IN_DATA : [ data ],
						RCV_DATA : arr_rcv_list,
					}
					_this.send('BR_CM_MSG_SND_SAVE', param, function(data2) {
						if(data2){
							Message.alert('발송되었습니다.', function() {
								console.log(data2);
								msgForm.clearData();
								_this.close({});
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