<%	String uuid = (String) request.getAttribute("uuid"); %>
<script>
$(document).ready(function(){
	var CM_3220 = new PgmPageMngr ('<%=uuid%>');
	var myEditor;
	CM_3220.init(function(p_param) {
		console.log(p_param);
		var _this = CM_3220;
		var arr_rcv_list = [];
		var msgForm = new FormMngr(_this, "msg_detail_area");
		msgForm.initCombo("SND_KIND_CD",'BR_CM_CD_FIND', {brRq: 'IN_DATA',brRs: 'OUT_DATA',IN_DATA: [{  GRP_CD : 'SND_KIND_CD', USE_YN: 'Y'}]},{ USE_EMPTY_YN : 'Y' , VALUE :'CD' , TEXT :'CD_NM' });
		msgForm.initCombo("SND_TYPE_CD",'BR_CM_CD_FIND', {brRq: 'IN_DATA',brRs: 'OUT_DATA',IN_DATA: [{  GRP_CD : 'SND_TYPE_CD', USE_YN: 'Y'}]},{ USE_EMPTY_YN : 'Y' , VALUE :'CD' , TEXT :'CD_NM' });
		msgForm.initCombo("SND_STATUS_CD",'BR_CM_CD_FIND', {brRq: 'IN_DATA',brRs: 'OUT_DATA',IN_DATA: [{  GRP_CD : 'SND_STATUS_CD', USE_YN: 'Y'}]},{ USE_EMPTY_YN : 'Y' , VALUE :'CD' , TEXT :'CD_NM' });
		msgForm.setData("SND_KIND_CD","");
		msgForm.setData("SND_TYPE_CD","");
		msgForm.setData("SND_STATUS_CD","");
		$('[data-ax5formatter]').ax5formatter();

		_this.on("remoteCall",function(data){
			console.log('remoteCall  ---  vvvvvv')
			var detail =data.detail; 
			console.log(detail);
			switch (detail.ACTION) {
				case 'SEARCH':
					msgForm.setData("SND_SEQ",detail.SND_SEQ);
					msgForm.get("search").trigger("click");
				break;
			}
		});
		
		msgForm.addEvent("click", "input[type=button]", function(el) {
			//console.log(el);
			switch (el.target.name) {
			case "search":
				var data = msgForm.getData();
				var param = {
						brRq: 'IN_DATA',
						brRs: 'OUT_DATA,RCV_DATA',
						IN_DATA: [{
							SND_SEQ : data["SND_SEQ"]
						}]
				}
				_this.showProgress();
				_this.send('BR_CM_MSG_SND_FIND_BY_SND_SEQ', param, function(data) {
					_this.hideProgress();
					if (data) {
						var row_data = data.OUT_DATA[0];
						msgForm.setDataAll(row_data);

						arr_rcv_list = data.RCV_DATA;
						$( _this.getEl()[0].querySelector("[name=rcv_list]") ).empty();
						var rcv_list_template_html = $(_this.getEl()[0].querySelector("[name=rcv-list-template]")).html();
						var rcv_list_template = Handlebars.compile(rcv_list_template_html);
						var rcv_data = { rcvList : arr_rcv_list };
						var tmp =rcv_list_template(rcv_data);
						//console.log(tmp);
						$( _this.getEl()[0].querySelector("[name=rcv_list]") ).append(tmp);
					}
				});	
				break;
			}
		});
	});
});
</script>