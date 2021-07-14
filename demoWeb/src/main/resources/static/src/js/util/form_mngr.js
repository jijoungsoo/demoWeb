class FormMngr {
	constructor(pgm_mngr, area_name) {
		var _this = this;
		this.arr_select2=[];
		this.area_name = area_name;
		this.uuid = pgm_mngr.getId();
		this.pgm_mngr = pgm_mngr;
		this.area_name = area_name;
		this.container = $("#" + pgm_mngr.getId());
		if (area_name != "") {
			this.container_area = this.container.find("[name=" + area_name + "]");
		} else {
			this.container_area = this.container;
		}
		if(this.container_area[0] == undefined){
			alert("form을 찾을수 없습니다.["+area_name+"] 코드를 확인해주세요.");
			return;
		}
		this.initBinder();
	}
	getUUID() {
		return this.uuid;
	}
	getPgmId() {
		return this.pgm_id;
	}
	getEl() {
		return this.container;
	}
	get(name) {
		return this.container_area.find("[name=" + name + "]");
	}
	initBinder() {
		this.target_data = {};
		let tgt_data = this.target_data;
		var w = this.container_area[0];
		
		//console.log(this.pgm_mngr);
		//console.log(this.container_area);
		console.log(w);
		//console.log(w.querySelectorAll('[data-model]'));
		console.log('aaaaaaaaaaaaaaaaa');
		for (var i = 0; i < w.querySelectorAll('[data-model]').length; i++) {
			var el = w.querySelectorAll('[data-model]')[i];
			console.log(el.name);
			tgt_data[el.name] = '';
		}
		console.log('bbbbbbbbbbbbb');
		this.myModel = new ax5.ui.binder();
		this.myModel.setModel(tgt_data, this.container_area);
	}
	initCombo(name,br,param,option) {
		try {
				console.log('initCombo');
				console.log(option);
				let _this =this;
				let _option =option;
				var option_data = this.pgm_mngr.getComboData(br,param,option);
				var el = _this.get(name)[0];
				for(var i=0;i<option_data.length;i++){
					var item_data = option_data[i];
					var option = document.createElement("option");
					option.value = item_data.VALUE;
					option.text  = item_data.TEXT;
					el.add(option);
				}
				if(option_data.length>0){
					console.log(el);
					el.options[0].selected = true;
				}
		} catch(e){
			var tmp = name+"에 combo data 설정중 오류가 발생하였습니다."+name+" 요소가 있는지 확인해보세요."
			alert(tmp);
			console.log(e);
			
		}
		this.initBinder()//바인딩을 한번 더 해준다.
	}
	getData(name) {
		if(name){
			console.log(this.myModel.get());
			return this.myModel.get()[name]	;
		} else {
			return this.myModel.get();
		}
		
	}
	setDataAll(data_all) {
		this.myModel.setModel(data_all, this.container_area);
		//select2 combobox 갱신
		//this.reSyncSelect2();
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
				//console.log(el)
				//console.log(event_name)
				el.addEventListener(event_name, func);
			});
		}
	}
	/*  제거
	addSelect2(element_name,arr_data){
		if(this.arr_select2.indexOf(element_name)<0){	//배열에 없으면 추가
			console.log('addSelect2');
			this.arr_select2.push(element_name);
			this.get(element_name).select2({
				data: arr_data
			});
			this.get(element_name).val('').select2();  //최초 빈값 설정
			
			this.initBinder()//바인딩을 한번 더 해준다.
		}
	}*/
	/* 제거
	reSyncSelect2(){
		for(var i=0;i<this.arr_select2.length;i++){
			var tmp =this.arr_select2[i];
			this.get(tmp).select2({});
		}
	}
	*/
	
	
	valid(){
		var t=this.container_area;
		var tmp =t[0].reportValidity();
		return tmp;
		
	}

	disable(el_name){
		var w = this.container_area[0];
		var tmp_el_sel = "[name="+el_name+"]";
		if (w.querySelectorAll(tmp_el_sel)) {
			w.querySelectorAll(tmp_el_sel).forEach(function(el) {
				el.setAttribute("disabled", "");
			});
		}
	}
	enable(el_name){
		var w = this.container_area[0];
		var tmp_el_sel = "[name="+el_name+"]";
		if (w.querySelectorAll(tmp_el_sel)) {
			w.querySelectorAll(tmp_el_sel).forEach(function(el) {
				el.removeAttribute("disabled");     
			});
		}
	}
	show(){
		console.log(this.container_area);
		console.log('show()');
		this.container_area.show();
	}

	hide(){
		console.log(this.container_area);
		console.log('hide()');
		this.container_area.hide();
	}

}