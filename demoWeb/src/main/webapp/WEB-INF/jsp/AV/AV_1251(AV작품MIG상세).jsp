<% String uuid = (String) request.getAttribute("uuid"); %>
<script>
$(document).ready(function(){
	var AV_1251 = new PgmPageMngr ('<%=uuid%>');
		AV_1251.init(function(p_param) {
		var _this = AV_1251;
		var bestForm = new FormMngr(_this, "best_area");
		var dvdForm = new FormMngr(_this, "dvd_area");	
		
		console.log(p_param);

		var param = {
						brRq: 'IN_DATA',
						brRs: 'OUT_DATA',
						IN_DATA: [{
							DVD_IDX : p_param.param.DVD_IDX
						}]
					}

		_this.showProgress();
		_this.send_socket('BR_MIG_AV_MV_FIND_BY_DVD_IDX', param, function(data) {
			_this.hideProgress();
			if (data) {
				var row_data = data.OUT_DATA[0];
				console.log(row_data);
				dvdForm.setDataAll(row_data);
				var tmp = _this.get("IMG_L");
				var src = "/DVD_IDX_IMG/L/"+row_data["DVD_IDX"];
				console.log(src);
				$(tmp[0]).attr("src",src);

				if(data.OUT_DATA_BEST.length==0){
					var tmp = _this.get("best_area");
					tmp.hide();
					console.log(tmp);
				} else {
					$( _this.getEl()[0].querySelector("[name=best_list]") ).empty();
					var best_list_template_html = $(_this.getEl()[0].querySelector("[name=best_list-template]")).html();
					var best_list_template = Handlebars.compile(best_list_template_html);
					var best_data = { bestList : data.OUT_DATA_BEST };
					var tmp =best_list_template(best_data);
					$( _this.getEl()[0].querySelector("[name=best_list]") ).append(tmp);

					/*이미지에 클릭 이벤트를 걸어준다. */
					bestForm.addEvent("click","img[class=card-img-top]",function(el){
					console.log(el);
						console.log(p_param.param.ACTOR_IDX);
						console.log(el.toElement.dataset.idx);

						var param = {
							DVD_IDX: el.toElement.dataset.idx,
							ACTOR_IDX: p_param.param.ACTOR_IDX,
						}
						var popup = new PopupManger(_this, 'AV_1251', {
								width: 1200,
								height: 700,
								title: "(MIG)DVD 상세"
							},
							param
						);
						popup.open(function (data) {
							if (data) {

							}
						});
					});
				}	

				if(data.OUT_DATA_DVD.length==0){
				} else {
					$( _this.getEl()[0].querySelector("[name=dvd_list]") ).empty();
					var dvd_list_template_html = $(_this.getEl()[0].querySelector("[name=dvd_list-template]")).html();
					var dvd_list_template = Handlebars.compile(dvd_list_template_html);
					var dvd_data = { dvdList : data.OUT_DATA_DVD };
					var tmp =dvd_list_template(dvd_data);
					$( _this.getEl()[0].querySelector("[name=dvd_list]") ).append(tmp);

					/*이미지에 클릭 이벤트를 걸어준다. */
					dvdForm.addEvent("click","img[class=card-img-top]",function(el){
					console.log(el);
						console.log(p_param.param.ACTOR_IDX);
						console.log(el.toElement.dataset.idx);

						var param = {
							DVD_IDX: el.toElement.dataset.idx,
							ACTOR_IDX: p_param.param.ACTOR_IDX,
						}
						var popup = new PopupManger(_this, 'AV_1251', {
								width: 1200,
								height: 700,
								title: "(MIG)DVD 상세"
							},
							param
						);
						popup.open(function (data) {
							if (data) {

							}
						});
					});
				}
			}
		});	
		
		dvdForm.addEvent("click","input[type=button]",function(el){
		   //console.log(el);
	  	   switch(el.target.name){
           	   case 'external_actor':
				window.open("https://www.avdbs.com/menu/actor.php?actor_idx="+p_param.param.ACTOR_IDX,"actor");
               break;
			   case 'external_dvd':
				window.open("https://www.avdbs.com/menu/dvd.php?dvd_idx="+p_param.param.DVD_IDX,"dvd");
               break;
			   case 'sync_actor':
			   		var param2 = {
						brRq: 'IN_DATA',
						brRs: 'OUT_DATA',
						IN_DATA: [{
							ACTOR_IDX : p_param.param.ACTOR_IDX
						}]
					}
			   		_this.showProgress();
					_this.send('BS_MIG_AV_ACTR_BY_ACTOR_IDX', param2, function(data) {
						_this.hideProgress();
						if (data) {
							//상세 재조회
						}
					});	
               break;
			   case 'sync_dvd':
			   		var param2 = {
						brRq: 'IN_DATA',
						brRs: 'OUT_DATA',
						IN_DATA: [{
							DVD_IDX : p_param.param.DVD_IDX
						}]
					}
			   		_this.showProgress();
					_this.send('BS_MIG_AV_MV_BY_DVD_IDX', param2, function(data) {
						_this.hideProgress();
						if (data) {
							//상세 재조회
						}
					});	
               break;
			   case 'go_avsecret':
			   		var data= dvdForm.getData();
			   		window.open("https://www1.avsecret.net/search?skeyword="+data["MV_NM"],"avsecret");
               break;
			   case 'go_javzoa':
			   		var data= dvdForm.getData();
			   		window.open("https://javzoa.com/bbs/search.php?&gr_id=&sfl=wr_subject%7C%7Cwr_content&stx="+data["MV_NM"],"javzoa");
               break;
			   case 'go_sukebei':
			   		var data= dvdForm.getData();
			   		window.open("https://sukebei.nyaa.si/?f=0&c=0_0&q="+data["MV_NM"],"javzoa");
               break;

			   
			   
          	}
	  	});
	});
});

</script>