class FormMngr {
	constructor(pgm_mngr, area_name) {
		var _this = this;
		this.arr_select2=[];
		this.area_name = area_name;
		this.uuid = pgm_mngr.getId();
		this.area_name = area_name;
		this.container = $("#" + pgm_mngr.getId());
		if (area_name != "") {
			this.container_area = this.container.find("[name=" + area_name + "]");
		} else {
			this.container_area = this.container;
		}
		this.initBinder();
	}
	getUUID() {
		return this.uuid;
	}
	getPgmId() {
		return this.pgm_id;
	}
	getAreaName() {
		return this.area_name;
	}
	get(name) {
		return this.container_area.find("[name=" + name + "]");
	}
	initBinder() {
		this.target_data = {};
		let tgt_data = this.target_data;
		var w = this.container_area[0];
		for (var i = 0; i < w.querySelectorAll('[data-model]').length; i++) {
			var el = w.querySelectorAll('[data-model]')[i];
			tgt_data[el.name] = '';
		}
		this.myModel = new ax5.ui.binder();
		this.myModel.setModel(tgt_data, this.container_area);
	}
	getData() {
		return this.myModel.get()
	}
	setDataAll(data_all) {
		this.myModel.setModel(data_all, this.container_area);
		//select2 combobox 갱신
		this.reSyncSelect2();
	}
	setData(prop, value) {
		this.myModel.set(prop, value);
	}
	clearData() {
		this.target_data = {};
		let tgt_data = this.target_data;
		var w = this.container_area[0];
		for (var i = 0; i < w.querySelectorAll('[data-model]').length; i++) {
			var el = w.querySelectorAll('[data-model]')[i];
			tgt_data[el.name] = '';
		}
		this.myModel = new ax5.ui.binder();
		this.myModel.setModel(tgt_data, this.container_area);
	}

	addEvent(event_name, el_sel, func) {
		var w = this.container_area[0];
		if (w.querySelectorAll(el_sel)) {
			w.querySelectorAll(el_sel).forEach(function(el) {
				el.addEventListener(event_name, func);
			});
		}
	}
	addSelect2(element_name,arr_data){
		if(this.arr_select2.indexOf(element_name)<0){	//배열에 없으면 추가
			this.arr_select2.push(element_name);
			this.get(element_name).select2({
				data: arr_data
			});
			this.get(element_name).val('').select2();  //최초 빈값 설정
			
			this.initBinder()//바인딩을 한번 더 해준다.
		}
	}
	reSyncSelect2(){
		for(var i=0;i<this.arr_select2.length;i++){
			var tmp =this.arr_select2[i];
			this.get(tmp).select2({});
		}
	}
	
	addSelect(element_name,arr_data){
		var tmp = this.get(element_name);
		console.log(tmp);
		for (var i=0;i<arr_data.length;i++) {
			var data = arr_data[i];
			console.log(data);
			var t= "<option value='"+data.id+"'>"+data.text+"</option>";
			
			
			console.log(t);
			
			
            tmp.append(t);
		}
               
	}
	
	valid(){
		var t=this.container_area;
		var tmp =t[0].reportValidity();
		return tmp;
		
	}

}