function isEmpty(str){
    if(str==undefined){
        return true;
    }
    if(str.trim()==''){
        return true;
    }
    return false;

}

function getUUID() { // UUID v4 generator in JavaScript (RFC4122 compliant)
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
      var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 3 | 8);
      return v.toString(16);
    });
}

var PgmUuidMap = function () {
    this.pgmUuidMap={}
}    
PgmUuidMap.prototype.add = function (uuid,pgm_mngr) {
    this.pgmUuidMap[uuid]=pgm_mngr;
}
PgmUuidMap.prototype.get = function (uuid) {
    return this.pgmUuidMap[uuid];
}
PgmUuidMap.prototype.remove = function (uuid) {
    delete this.pgmUuidMap[uuid];
}
var pgmUuidMap=new PgmUuidMap();



var PgmNmMap = function () {
    this.pgmNmMap={}
}    
PgmNmMap.prototype.add = function (_component_name,_title) {
    this.pgmNmMap[_component_name]=_title;
}
PgmNmMap.prototype.get = function (_component_name) {
    return this.pgmNmMap[_component_name];
}
var pgmNmMap=new PgmNmMap();



var RequestMap = function () {
    this.requestMap={}
}    
RequestMap.prototype.add = function (uuid,json) {
    this.requestMap[uuid]=json;
}
RequestMap.prototype.get = function (uuid) {
    return this.requestMap[uuid];
}
RequestMap.prototype.remove = function (uuid) {
    delete this.requestMap[uuid];
}
var reqMap=new RequestMap();



var PgmPage = function (pgm_id, uuid) {
    var _this = this;
    this.progressMngr = new ProgressMngr(uuid);
    this.container = $("#" + uuid);
    this.pgm_id = pgm_id
    this.uuid = uuid;
    this.init = function () {


    };
    this.init();
}
PgmPage.prototype.getId = function () {
    return this.uuid;
}
PgmPage.prototype.getPgmId = function () {
    return this.pgm_id;
}

PgmPage.prototype.get = function (name) {
    return this.container.find("[name=" + name + "]");
}

PgmPage.prototype.showProgress = function () {
    this.progressMngr.showProgress();
}
PgmPage.prototype.hideProgress = function () {
    this.progressMngr.hideProgress();
}


function goOnePage(_component_name,p_title) {
    var v_title ="";
    if(!isEmpty(p_title)) {
        v_title=pgmNmMap.get(_component_name)+"_"+p_title
    } else {
        v_title=pgmNmMap.get(_component_name)
    }

    var newItemConfig = {
        type: "component",
        title: v_title,
        componentName: _component_name,
        pg: _component_name,
        id: getUUID(),
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
            pgmUuidMap.remove(item.config.id);
            reqMap.remove(item.config.id);
            //그때 id가져오는 걸 했었는데 기억이 안난다.
        })   //The middle mouse button
        
        //item.container.on("close", () => { alert("ddd2") })       //Close button
    }

    //myLayout.root.contentItems[0].addChild(newItemConfig);
}


function goNextPage(_component_name,p_title,p_param) {
    var v_title ="";
    if(!isEmpty(p_title)) {
        v_title=pgmNmMap.get(_component_name)+"_"+p_title
    } else {
        v_title=pgmNmMap.get(_component_name)
    }
    var newItemConfig = {
        type: "component",
        title: v_title,
        componentName: _component_name,
        pg: _component_name,
        id: getUUID(),
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
        pgmUuidMap.remove(item.config.id);
        reqMap.remove(item.config.id);
    })

    if(p_param!=undefined)  {
        reqMap.add(item.config.id,JSON.stringify(p_param));
    }
}