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
    addEvent(sel_name, event_name, func){
        if(event_name!="click") {
            return;
        } 
        this.get(sel_name).on(event_name, function (e) {
            e.preventDefault();
            func(e);
        });
    }
    click(sel_name){
         
        var em = this.get(sel_name);
        console.log(em);
        
        //document.getElementById("my-btn")[0].click();
        em.click();
    }
}