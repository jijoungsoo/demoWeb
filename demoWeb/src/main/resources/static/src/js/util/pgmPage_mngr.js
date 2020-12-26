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

    
    static goOnePage(_component_name,p_title) {
        var v_title ="";
        if(!AppMngr.isEmpty(p_title)) {
            v_title=PgmPageMngr.getPgmPageMap(_component_name)+"_"+p_title
        } else {
            v_title=PgmPageMngr.getPgmPageMap(_component_name)
        }

        var newItemConfig = {
            type: "component",
            title: v_title,
            componentName: _component_name,
            pg: _component_name,
            id: AppMngr.makeUUID(),
        };
        //console.log(myLayout);
        //이쪽에서 registerComponent를 동적으로 해보았는데
        //결론은 잘되었다. 특이점은 myLayout.init()을 여기서 해주면 안된다는 것이었다.
        //그런데 문제는 팝업창을 띄우면 프로그램을 인지하지 못했다.
        //결국엔 여기서가 아니라 componetName이 프로그램마다 모두 등록이되어있어야한다.
        //그래야 팝업뜨는것도 해결할수있다.

        //아래는 하나창만 뜨게 하는로직 굳이 필요할것 같진 않다.
        let compName = myLayout.root.getComponentsByName(_component_name);
        if (compName && compName.length != 0) {
            var tmp = myLayout.root.getItemsById('stack_window')[0]
            var tmp_a = myLayout.root.getItemsByFilter( function( item ) {
                return item.config.componentName === _component_name;
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
                //https://github.com/golden-layout/golden-layout/issues/364

            }
            myLayout.root.contentItems[0].addChild(newItemConfig);
            var tmp = myLayout.root.getItemsById('stack_window')[0]
            var item = tmp.getActiveContentItem();
            item.container.on("destroy", () => {  /*팝업닫기는 여기*/
                /*
                console.log("-destroy--:start");
                console.log("-destroy--item.config.componentName=>"+item.config.componentName);
                console.log("-destroy--item.config.pg=>"+item.config.pg);
                console.log("-destroy--item.config.id=>"+item.config.id);
                console.log("-destroy--reqMap=>");
                console.log(reqMap);
                console.log("-destroy--pgmMap=>");
                console.log(pgmMap);
                console.log("-destroy--:end");
                */
                PgmPageMngr.removePgmUuIdMap(item.config.id);
                PgmPageMngr.removeReqMap(item.config.id);
                //그때 id가져오는 걸 했었는데 기억이 안난다.
            })   //The middle mouse button
            
            //item.container.on("close", () => { alert("ddd2") })       //Close button
        }

        //myLayout.root.contentItems[0].addChild(newItemConfig);
    }
    
    static goNextPage(_component_name,p_title,p_param) {
        var v_title ="";
        if(!AppMngr.isEmpty(p_title)) {
            v_title=pgmNmMap.get(_component_name)+"_"+p_title
        } else {
            v_title=pgmNmMap.get(_component_name)
        }
        var newItemConfig = {
            type: "component",
            title: v_title,
            componentName: _component_name,
            pg: _component_name,
            id: AppMngr.makeUUID(),
        };
        
        let compName = myLayout.root.getComponentsByName(_component_name);
        if (compName && compName.length != 0) {
            //
            //
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

        if(p_param!=undefined)  {
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
    }

    init(func){
        if(func!=undefined){
            var p_param={};
            var reqData=PgmPageMngr.getReqMap(this.getId());   /*페이지 호출을 했을때 입력된 req값을 기준으로 얻어온다. */
            if(reqData!=undefined){           
                $.extend(p_param, JSON.parse(reqData));
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
}



