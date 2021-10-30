class PgmPageMngr {

	static printPgm(){

		var len = Object.keys(PgmPageMngr.pgmUuidMap).length;
		//console.log("pgm list => "+len);
	}
	
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
						pgm_mngr.destory();
			        } else {
			        	console.log('error','pgm_mngr이 undefined 문제..')
			        }
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

	
	getChildPgmMap(){
		return this.childPgmMap;
	}

	addChildPgmMap(pgm_mngr){
		//console.log('addChildPgmMap------------------');
		this.childPgmMap.push(pgm_mngr)
	}
	
	constructor(uuid) {
		
		this.childPgmMap =[];
		//console.log('PgmPageMngr-constructor');
		

		var _this = this;
		this.container = $("#" + uuid);
		console.log(uuid);

		//goldenlayout  스크롤 바스 생성
		$(this.container).parent().css("overflow-y","auto");

		this.pgm_id = this.container.attr("pgm_id");
		this.parent_uuid = this.container.attr("parent_uuid");
		this.uuid = uuid;
		//console.log('aaaaa');
		//console.log(uuid);
        PgmPageMngr.addPgmUuIdMap(uuid,this);
    	if(AppMngr.debug_console=="Y") {
    		this.makeDebug(uuid);   
    	}

		console.log(this.uuid)
		console.log(this.parent_uuid)
		if(this.parent_uuid!="ROOT" && !PjtUtil.isEmpty(this.parent_uuid)){
			//부모 것이 있으면
			//자식이 로드 될때 
			//부모의 차일드 맵에
			//내 uuid를 넣는다.
			var p = PgmPageMngr.getPgmUuIdMap(this.parent_uuid);
			console.log(p)
			p.addChildPgmMap(this);
		}
		this.progress = new ProgressMngr(uuid);

    }
    getEl(){
    	return this.container;
    }
    
    makeDebug(uuid){
    	var div_height =$( "#"+uuid+"_debug_log" ).height()+4;
    	$( "#"+uuid+"_draggable" ).draggable({ axis: "y"  /*수직으로만 이동*/
			, zIndex: 999  /*z-index를 크게 줘서 최 상단에 보이도록*/ 
			, start: function(event, ui) {
		    		$(event.toElement).one('click', function(e) { e.stopPropagation(); });
		  		}
			, drag: function( event, ui ) {
				var screenRelativeTop =  $("#"+uuid+"_draggable").offset().top - (window.scrollY || window.pageYOffset || document.body.scrollTop);
				$("#"+uuid+"_debug_log").offset({top : screenRelativeTop-div_height });
			 	//console.log(ui.position);
				}	
		});
		$("#"+uuid+"_debug_log").hide();
		$("#"+uuid+"_debug_bottom_a").click(function(event){
			if($("#"+uuid+"_debug_log").is(':visible') == false ) { 
				$("#"+uuid+"_debug_log").show();
				var screenRelativeTop =  $("#"+uuid+"_draggable").offset().top - (window.scrollY || window.pageYOffset || document.body.scrollTop);
				$("#"+uuid+"_debug_log").offset({top : screenRelativeTop-(div_height*2) });
				$("#"+uuid+"_draggable").offset({top : screenRelativeTop-div_height}); 
			} else { 
				$("#"+uuid+"_debug_log").hide();
				var screenRelativeTop =  $("#"+uuid+"_draggable").offset().top - (window.scrollY || window.pageYOffset || document.body.scrollTop);
				$("#"+uuid+"_draggable").offset({top : screenRelativeTop+div_height});  
			}
		});
    }

    init(func){
        if(func!=undefined){
            var p_param={};
            var reqData=PgmPageMngr.getReqMap(this.getId());   /*페이지 호출을 했을때 입력된 req값을 기준으로 얻어온다. */
            //console.log(reqData);
            if(reqData!=undefined){           
                $.extend(p_param, reqData);
            }
            func(p_param);
        }

		var config = {
			'.chosen-select'           : {},
			'.chosen-select-deselect'  : { allow_single_deselect: true },
			'.chosen-select-no-single' : { disable_search_threshold: 10 },
			'.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
			'.chosen-select-rtl'       : { rtl: true },
			'.chosen-select-width'     : { width: '95%' }
		  }
		  var el =this.getEl();

		  //console.log(el);
		  for (var selector in config) {
			  
			var tmp =el[0].querySelectorAll(selector);
			$(tmp).chosen(config[selector]);
		  }
    }

    getId() {
        return this.uuid;    
    }

	getUuid() {
        return this.uuid;    
    }

    getPgmId() {
        return this.pgm_id;    
    }
    get(name) {
        return this.container.find("[name=" + name + "]");
    }
    find(name) {
        return this.container.find(name);
    }
    showProgress() {
		this.progress.showProgress();
    }
    hideProgress() {
		this.progress.hideProgress();
    }

    send(p_url, p_param, p_funtion){
    	console.log('p_url=>'+p_url);
    	console.log('p_param=>'+p_param);
    	console.log('p_funtion=>'+p_funtion);
    	AjaxMngr.send_post_ajax(p_url, p_param, p_funtion);
    }

    
    send_api(p_url, p_param, p_funtion){
    	console.log('p_url=>'+p_url);
    	console.log('p_param=>'+p_param);
    	console.log('p_funtion=>'+p_funtion);
    	AjaxMngr.send_api_post_ajax(p_url, p_param, p_funtion,this.uuid);
    }

	send_proxy(p_param, p_funtion){
    	console.log('p_param=>'+p_param);
    	console.log('p_funtion=>'+p_funtion);
    	AjaxMngr.send_proxy(p_param, p_funtion,this.uuid);
    }


    send_sync(p_url, p_param, p_funtion){
    	console.log('p_url=>'+p_url);
    	console.log('p_param=>'+p_param);
    	console.log('p_funtion=>'+p_funtion);
    	AjaxMngr.send_api_post_ajax_sync(p_url, p_param, p_funtion);
    }
	send_socket(p_url, p_param, p_funtion){
		console.log('send_socket');
		console.log('p_url=>'+p_url);
    	console.log('p_param=>'+p_param);
    	console.log('p_funtion=>'+p_funtion);
		AjaxMngr.send_socket(p_url, p_param, p_funtion,this.getId());
		
    }
    
    close(p_param){
	   	var uuid=this.getId();
    	var data = PgmPageMngr.getReqMap(uuid);
    	//console.log(data);
    	//console.log(data.popup_mngr);
    	if(data.popup_mngr != undefined)  {
    		data.popup_mngr.close(p_param);
    	}
		this.destory();
    }
    on(event_name,func){
		// 이벤트 리슨.
		//console.log(this.container);
		//console.log(func)
		this.container[0].addEventListener(event_name,func, false);

	}
	
	fire(event_name,data){
		//console.log('PgmPageMngr-fire-'+event_name);
		//console.log(data);
		// 이벤트 디스패치.
		var event = new CustomEvent(event_name,data);
		//console.log(this.container);
		//console.log(data);
		this.container[0].dispatchEvent(event);
	}

	getComboData(br,param,option) {
		let _this =this;
		let _option =option;
		let option_data=[];
		this.send_sync(br, param, function(data){
			if(_option && _option.USE_EMPTY_YN){
				if(_option.USE_EMPTY_YN=='Y'){
					option_data.push({VALUE : '', TEXT : '빈것' });
				}
			} else {
				if(_option.USE_EMPTY_YN=='Y'){
					option_data.push({VALUE : '', TEXT : '빈것' });
				}
			}

            
            var arr_brRs = param.brRs.split(",");
            var brRs  = arr_brRs[0];
            console.log('brRs=>'+brRs);
            if(data !=undefined  && data[brRs]!=undefined) {
                var tmp_data=data[brRs];

                console.log(param);
                console.log(data);
                if(tmp_data && tmp_data.length){
                    var value_name="value";
                    var text_name="text";
                    console.log(_option);
                    if(_option && _option.VALUE) {
                        value_name=_option.VALUE;
                    }
                    if(_option && _option.TEXT) {
                        text_name=_option.TEXT;
                    }
                    
                    for(var i=0;i<tmp_data.length;i++){
                        var item_data = tmp_data[i];
                        option.value = item_data[value_name];
                        option.text  = item_data[text_name];
                        option_data.push(
                            {
                                VALUE : item_data[value_name] , 
                                TEXT : item_data[text_name] 
                            }
                        );
                    }
                }

            }

			
		});
		return option_data;
	}

	parentCall(CALL_METHOD){
		//console.log('PgmPageMngr-parentCall-'+ this.getPgmId());
		var parent_uuid = this.parent_uuid;
		//console.log('parent_uuid');
		//console.log(parent_uuid);
		var app = PgmPageMngr.getPgmUuIdMap(parent_uuid);
		//console.log('app');
		//console.log(app);
		app.fire("remoteCall",CALL_METHOD);
	}

	destory(){
			//원래는 navigator를 두어서 제거하면 지우려고 했는데 필요없음.
			var uuid = this.uuid;
			//console.log("destory");
			//console.log(uuid);
			//console.log(this)
			var tmp =this.getChildPgmMap()
			for(var i=0;i<tmp.length;i++){
				//child가 있으면 child의 것들도 destory 해줘야한다.
				var p = tmp[i];
				//console.log(p)
				p.destory();
			}


			sessionStorage.removeItem(uuid);
			PgmPageMngr.removePgmUuIdMap(uuid);
			PgmPageMngr.removeReqMap(uuid);
	}
}



