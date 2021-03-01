class ChildMngr {
	constructor(pgm_mngr,area_name,PGM_ID) {
		this.appMap  = new Map();
		var _this = this;
		this.pgm_mngr = pgm_mngr;
		this.pgm_id = PGM_ID;
		this.uuid = pgm_mngr.getId();
		this.container = $("#" + pgm_mngr.getId());
		console.log(this.container)
		if (area_name != "") {
			this.container_area = this.container.find("[name=" + area_name + "]");
		} else {
			this.container_area = this.container;
		}
		this.loadContent();
	}
	
	remoteCall(CALL_METHOD){
		var div_uuid = this.appMap.get(this.pgm_id)
		var app = PgmPageMngr.getPgmUuIdMap(div_uuid);
		app.fire("remoteCall",CALL_METHOD);
	}

	loadContent(p_param){
		var _this = this;
		var div_uuid	= AppMngr.makeUUID();
		var container_id=(_this.uuid + "-" + div_uuid + "-div");
		var tmp = `
		<div id="`+ container_id+`">
		</div>
		`


		this.container_area.append();

		let el1 =$("#" + container_id);
		el1.remove();
		let el2 = this.container_area;
		el2.append(tmp);  //윈도우창에 프로그래스 div를 추가한다.
		let el3 =$("#" + container_id);
		//ajax로 페이지 로딩해야한다.
		var p_param = $.extend(p_param, { uuid: div_uuid ,parent_uuid : _this.pgm_mngr.getUuid() });
		PgmPageMngr.addReqMap(div_uuid,{ popup_mngr : this,param : p_param });			
		_this.appMap.set(_this.pgm_id,div_uuid);
		AjaxMngr.get_page_ajax(el3,_this.pgm_id,p_param);
	}
}