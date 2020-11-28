var PgmForm = function (pgm_mngr, area_name) {
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
PgmForm.prototype.getUUID = function () {
    return this.uuid;
}
PgmForm.prototype.getPgmId = function () {
    return this.pgm_id;
}
PgmForm.prototype.getAreaName = function () {
    return this.area_name;
}

PgmForm.prototype.get = function (name) {
    return this.container_area.find("[name=" + name + "]");
}

PgmForm.prototype.addEvent = function (sel_name, event_name, func){
    if(event_name!="click") {
        return;
    } 
    this.get(sel_name).on(event_name, function (e) {
        e.preventDefault();
        func(e);
    });
}
