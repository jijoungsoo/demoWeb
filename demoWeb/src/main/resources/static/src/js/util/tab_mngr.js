class TabMngr {
	constructor(pgm_mngr, area_name) {
		this.appMap  = new Map();
		var _this = this;
		this.pgm_mngr = pgm_mngr;
		this.uuid = pgm_mngr.getId();
		this.container = $("#" + pgm_mngr.getId());
		console.log(this.container)
		if (area_name != "") {
			this.container_area = this.container.find("[name=" + area_name + "]");
		} else {
			this.container_area = this.container;
		}
		this.arr_tab={};

		/*
		this.arr_tab.push({  INDEX: 0  ,PGM_ID : '' , LOAD : true  });
		GUBUN   ==> I 내부용, R 이면 ajax
		I일경우   PGM_ID : '' 넣지 않기   , 한번 로딩되면 LOAD 를 true로 고고 
		*/
	}
	appendTab(arrTab){
		var cnt = this.length();
		for(var i=0;i<cnt;i++){
			this.arr_tab[i] = {  INDEX: i  ,PGM_ID : '' , LOAD : false , PARAM : null  };
		}

		for(var i =0;i<arrTab.length;i++){
			var tmp = arrTab[i];
			if(tmp.INDEX==i) {
				this.arr_tab[i]={  INDEX: i  ,PGM_ID : tmp.PGM_ID , LOAD : false , PARAM : tmp.PARAM  };
			}
			
		}
	}

	remoteCall(PGM_ID,CALL_METHOD){
		//console.log('remoteCall');
		//console.log(PGM_ID);
		//console.log(this.appMap);
		var tab_uuid = this.appMap.get(PGM_ID)
		//console.log('tab_uuid');
		//console.log(tab_uuid);
		var app = PgmPageMngr.getPgmUuIdMap(tab_uuid);
		try {
			app.fire("remoteCall",CALL_METHOD);
		} catch(e){
			alert(PGM_ID+'-tab 호출 오류가 발생하였습니다. 관리자에게 문의 부탁드립니다.')
			console.log(e);
		}
		
	}

	loadContent(tabIndex){
		var _this = this;

		if(PjtUtil.isEmpty(_this.arr_tab[tabIndex].PGM_ID)==false
			&& _this.arr_tab[tabIndex].LOAD==false) 
			{
				_this.arr_tab[tabIndex].LOAD=true;
				var PGM_ID = _this.arr_tab[tabIndex].PGM_ID;
				var p_param =  _this.arr_tab[tabIndex].PARAM;
				var tab_uuid	= AppMngr.makeUUID();
				var container_id=(_this.uuid + "-" + tab_uuid + "-tab");
				var tmp = `
				<div id="`+ container_id+`">
				</div>
				`
				let el1 =$("#" + container_id);
				el1.remove();
				console.log(_this);
				console.log(_this.tab);
				let el2 = _this.getTabInfo(tabIndex)
				el2.append(tmp);  //윈도우창에 프로그래스 div를 추가한다.
				let el3 =$("#" + container_id);
				//ajax로 페이지 로딩해야한다.
				var p_param = $.extend(p_param, { uuid: tab_uuid ,parent_uuid : _this.pgm_mngr.getUuid() });
				PgmPageMngr.addReqMap(tab_uuid,{ popup_mngr : this,param : p_param });			
				_this.appMap.set(PGM_ID,tab_uuid);
				AjaxMngr.get_page_ajax(el3,PGM_ID,p_param);

		}
	}


	build(option,p_param) {
		let _this = this;
		this.tab=$(this.container_area[0]).tabs(option);
		this.tab.on( "tabsactivate", function( event, ui ) {
			console.log('tabsactivate');
			var tabIndex = _this.currTabIndex();
			_this.loadContent(tabIndex);
		} );	

		var tabIndex=0;
		if(option && option.active){
			tabIndex=option.active;
		}
		_this.loadContent(tabIndex);

		
	}


	getTabInfo(tabIndex) {
		return $(this.tab[0].children[tabIndex+1]);
	}

	length(){
		var cnt = this.container_area[0].querySelectorAll('ul >li').length;
		return cnt;
	}

	currTabIndex(){
		var tabIndex = this.tab.tabs( "option", "active" );
		console.log('currTabIndex');
		console.log(tabIndex);
		return tabIndex;
	}
}