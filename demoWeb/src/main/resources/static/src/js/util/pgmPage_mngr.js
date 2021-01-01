class PgmPageMngr {
    static pgmNmMap={};
    static addPgmPageMap(_component_name,_title) {
        PgmPageMngr.pgmNmMap[_component_name]=_title;
    }
    static getPgmPageMap(_component_name) {
        return PgmPageMngr.pgmNmMap[_component_name];
    }
    static reqMap={}
    static addReqMap(uuid,json) {
        PgmPageMngr.reqMap[uuid]=json;
    }
    static getReqMap(uuid) {
        return PgmPageMngr.reqMap[uuid];
    }
    static removeReqMap(uuid) {
        delete PgmPageMngr.reqMap[uuid];
    }

    static pgmUuidMap={}

    static addPgmUuIdMap(uuid,pgm_mngr) {
        PgmPageMngr.pgmUuidMap[uuid]=pgm_mngr;
    }
    static getPgmUuIdMap(uuid) {
        return PgmPageMngr.pgmUuidMap[uuid];
    }
    static removePgmUuIdMap(uuid) {
        delete PgmPageMngr.pgmUuidMap[uuid];
    }

    
    static goPage(p_param,p_req_param) {
    	/*
    		p_param = {
    			COMPONENT_NAME: "컴포넌트이름"
    			,TITLE : "창이름"
    			,WINDOW : "S" 또는 "M"  S는 창이 하나만 뜨고 , M은 여러개가 가능하도록한다.
    		}
    	*/
    
    	if(!p_param){
    		alert('파라미터가 넘어오지 않았습니다.');
    	}
    	if(!p_param.COMPONENT_NAME){
    		alert('COMPONENT_NAME 파라미터가 넘어오지 않았습니다.');
    	}
    	if(!p_param.WINDOW){
    		alert('WINDOW 파라미터가 넘어오지 않았습니다.');
    	}
    	var v_component_name = p_param.COMPONENT_NAME;
        var v_title ="";
        if(!AppMngr.isEmpty(p_param.TITLE)) {
            v_title=PgmPageMngr.getPgmPageMap(v_component_name)+"_"+p_param.TITLE
        } else {
            v_title=PgmPageMngr.getPgmPageMap(v_component_name)
        }

        var newItemConfig = {
            type: "component",
            title: v_title,
            componentName: v_component_name,
            pg: v_component_name,
            id: AppMngr.makeUUID(),
        };
        
        let compName = myLayout.root.getComponentsByName(v_component_name);
        if(p_param.WINDOW=='S'){
			if (compName && compName.length != 0) {
			    var tmp = myLayout.root.getItemsById('stack_window')[0]
			    var tmp_a = myLayout.root.getItemsByFilter( function( item ) {
			        return item.config.componentName === v_component_name;
			    });
			    tmp_a=tmp_a[0];
			    tmp.setActiveContentItem(tmp_a);
			    //focus 이동
			} else {
			    //창 추가
			    if(myLayout.root.contentItems.length==0){
			        //stack을 하나 넣어줘야한다.
			        myLayout.root.addChild({
			            width: 100,
			            type: "stack",
			            id: "stack_window",
			            content: []
			        })
			    }
			    myLayout.root.contentItems[0].addChild(newItemConfig);
			    var tmp = myLayout.root.getItemsById('stack_window')[0]
			    var item = tmp.getActiveContentItem();
			    item.container.on("destroy", () => {  /*팝업닫기는 여기*/
			        var pgm_mngr = PgmPageMngr.getPgmUuIdMap(item.config.id);
			        if(pgm_mngr!=undefined){
			        	pgm_mngr.fire('destory');
			        } else {
			        	console.log('error','pgm_mngr이 undefined 문제..')
			        }
			        PgmPageMngr.removePgmUuIdMap(item.config.id);
			        PgmPageMngr.removeReqMap(item.config.id);
			        //그때 id가져오는 걸 했었는데 기억이 안난다.
			    })   //The middle mouse button
			}
        } else if(p_param.WINDOW=='M'){
			if (compName && compName.length != 0) {
			    //focus 이동
			} else {
			    //창 추가
			    if(myLayout.root.contentItems.length==0){
			        myLayout.root.addChild({
			            width: 100,
			            type: "stack",
			            id: "stack_window",
			            content: []
			        })
			    }
			}
			myLayout.root.contentItems[0].addChild(newItemConfig);
			var tmp = myLayout.root.getItemsById('stack_window')[0]
			var item = tmp.getActiveContentItem();
			item.container.on("destroy", () => {  /*팝업닫기는 여기*/
			    PgmPageMngr.removePgmUuIdMap(item.config.id);
			    PgmPageMngr.removeReqMap(item.config.id);
			})
        }
        
        if(p_req_param!=undefined)  {
            PgmPageMngr.addReqMap(item.config.id,JSON.stringify(p_param));
        }
        
    }

    constructor(pgm_id, uuid) {
        var _this = this;
        this.mask = new ax5.ui.mask();
        this.container = $("#" + uuid);
        this.pgm_id = pgm_id
        this.uuid = uuid;
        PgmPageMngr.addPgmUuIdMap(uuid,this);
        ///container가 있으니까 이벤트를 걸대는 여기다 걸자.!!!
    }

    init(func){
        if(func!=undefined){
            var p_param={};
            var reqData=PgmPageMngr.getReqMap(this.getId());   /*페이지 호출을 했을때 입력된 req값을 기준으로 얻어온다. */
            console.log(reqData);
            if(reqData!=undefined){           
                $.extend(p_param, reqData);
            }
            func(p_param);
        }
        
    }

    getId() {
        return this.uuid;    
    }

    getPgmId() {
        return this.pgm_id;    
    }
    get(name) {
        return this.container.find("[name=" + name + "]");
    }
    showProgress() {
		this.mask.open({
			content: '<h1><i class="fa fa-spinner fa-spin"></i> Loading</h1>'
			,target: $("#"+this.getId()).get(0),
		});
    }
    hideProgress() {
        this.mask.close();
    }
    send(p_url, p_param, p_funtion){
    	console.log('p_url=>'+p_url);
    	console.log('p_param=>'+p_param);
    	console.log('p_funtion=>'+p_funtion);
    	AjaxMngr.send_api_post_ajax(p_url, p_param, p_funtion);
    }
    send_sync(p_url, p_param, p_funtion){
    	console.log('p_url=>'+p_url);
    	console.log('p_param=>'+p_param);
    	console.log('p_funtion=>'+p_funtion);
    	AjaxMngr.send_api_post_ajax_sync(p_url, p_param, p_funtion);
    }
    
    close(p_param){
    	var uuid=this.getId();
    	var data = PgmPageMngr.getReqMap(uuid);
    	console.log(data);
    	console.log(data.popup_mngr);
    	if(data.popup_mngr != undefined)  {
    		data.popup_mngr.close(p_param);
    	}

    	PgmPageMngr.removeReqMap(uuid);
    }
    on(event_name,func){
		// 이벤트 리슨.
		console.log(this.container);
		this.container[0].addEventListener(event_name,func, false);

	}
	
	fire(event_name){
		// 이벤트 디스패치.
		var event = new Event(event_name);
		console.log(this.container);
		this.container[0].dispatchEvent(event);
	}
}



