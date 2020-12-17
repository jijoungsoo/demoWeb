class FormMngr {
    constructor(pgm_mngr, area_name) {
        var _this = this;
        this.area_name=area_name;
        this.uuid = pgm_mngr.getId();
        this.area_name = area_name;
        this.container = $("#" + pgm_mngr.getId());
        if(area_name!="") {
            this.container_area = this.container.find("[name=" + area_name + "]");    
        } else {
            this.container_area = this.container;
        }
    }
    getUUID(){
        return this.uuid;
    }
    getPgmId(){
        return this.pgm_id;    
    }
    getAreaName() {
        return this.area_name;
    }
    get(name) {
        return this.container_area.find("[name=" + name + "]");
    }
    
    
    
    /*https://stackoverflow.com/questions/57774772/how-to-get-child-element-in-a-click-event
    버튼을 순회하여 누르면 event를 발생시키자.
    */
    /*
     <td><input type="button" name="search" value="조회" /></td>
        <td><input type="button" name="add_row" value="추가" /></td>
        <td><input type="button" name="save" value="저장" /></td>
        <td><input type="button" name="del" value="삭제" /></td>
    */
    addEvent(event_name,func){
    	console.log(this);
    	var w=document.getElementById(this.getUUID());
    	if(w.querySelectorAll("input[type=button]")){
			w.querySelectorAll("input[type=button]").forEach(function(el){
					el.addEventListener(event_name, func);	
			});
    	}
    }
}