<%	String pgmId = (String) request.getAttribute("pgmId");
	String uuid = (String) request.getAttribute("uuid");
%>
<script>
$(document).ready(function(){
	var ST_CM_0200 = new PgmPageMngr ('<%=pgmId%>', '<%=uuid%>');
	ST_CM_0200.init(function(p_param) {
		console.log(p_param)
		var _this = ST_CM_0200;
		var searchForm = new FormMngr(_this,"search_area");

		
		searchForm.addEvent("click","input[type=button]",function(el) {
			//console.log(el);
			switch (el.target.name) {
			case 'close_data':
				_this.close({aa:'bb'});
				break;
			case 'close':
				_this.close();
				break;
			}
		});
	});
});
</script>