<% String uuid = (String) request.getAttribute("uuid"); %>
<script>
$(document).ready(function(){
	var AV_1160 = new PgmPageMngr ('<%=uuid%>');
		AV_1160.init(function(p_param) {
		var _this = AV_1160;
		var actorForm = new FormMngr(_this, "actor_area");
		var bestForm = new FormMngr(_this, "best_area");
		var dvdForm = new FormMngr(_this, "dvd_area");
		var pageCmtForm = new ChildMngr(_this, "page_cmt_area",'AV_1165');

		var param = {
			brRq: 'IN_DATA',
			brRs: 'OUT_DATA',
			IN_DATA: [{
				ACTOR_IDX : p_param.param.ACTOR_IDX
			}]
		}
		_this.showProgress();
		_this.send_socket('BS_MIG_AV_ACTR_FIND_BY_ACTOR_IDX', param, function(data) {
			_this.hideProgress();
			if (data) {
				var row_data = data.OUT_DATA[0];
				console.log(row_data);
				actorForm.setDataAll(row_data);
				var tmp = _this.get("IMG_L");
				var src = "/ACTOR_IDX_PF_IMG/L/"+row_data["ACTOR_IDX"];
				console.log(src);
				$(tmp[0]).attr("src",src);

				$( _this.getEl()[0].querySelector("[name=img_list]") ).empty();
				var actr_img_template_html = $(_this.getEl()[0].querySelector("[name=actr_img-template]")).html();
				var actr_img_template = Handlebars.compile(actr_img_template_html);
				var img_data = { imgList : data.OUT_DATA_IMG };
				var tmp =actr_img_template(img_data);
				$( _this.getEl()[0].querySelector("[name=img_list]") ).append(tmp);

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

		
		console.log(p_param);
		var param = {
				ACTION  : 'SEARCH',
				ACTOR_IDX : p_param.param.ACTOR_IDX
		}
		//자식페이지가 로딩되는 시점을 알수없으므로 자식은 로딩이 완료되면 부모에게 onload를 보낸다.	
		_this.on("remoteCall",function(data){
			console.log('remoteCall  ---  vvvvvv')
			var detail =data.detail; 
			console.log(detail);

			var b_call_1164 =false;
			var b_call_1165 =false;

		   switch(detail.ACTION){
           case 'ON_LOAD':
				switch(detail.PGM_ID){
				case 'AV_1165':
					if(b_call_1165==true){
						pageCmtForm.remoteCall({ detail: param });
					}
					b_call_1165=true;
					break;
				}
			case 'CALL':
				switch(detail.PGM_ID){
				case 'AV_1165':
					if(b_call_1165==true){
						pageCmtForm.remoteCall({ detail: param });
					}
					break;
				}
               break;
           }
		});

		actorForm.addEvent("click","input[type=button]",function(el){
		   //console.log(el);
	  	   switch(el.target.name){
           	   case 'external_web':
				window.open("https://www.avdbs.com/menu/actor.php?actor_idx="+p_param.param.ACTOR_IDX,"web");
               break;
			   case 'avsecret':
				window.open("https://www1.avsecret.net/search?skeyword=fsdss-048"+p_param.param.ACTOR_IDX,"web");
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
					_this.send_socket('BS_MIG_AV_ACTR_BY_ACTOR_IDX', param2, function(data) {
						_this.hideProgress();
						if (data) {
							pageCmtForm.remoteCall({ detail: param });
						}
					});	
               break;

			   
          	}
	  	});


		
	});
});

</script>