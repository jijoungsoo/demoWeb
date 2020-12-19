class FormMngr {
	constructor(pgm_mngr, area_name) {
		var _this = this;
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
		//console.log("get aaaa");
		//console.log(this.container_area);
		//console.log(this.container_area.find("[name=" + name + "]"));
		//console.log("get aaaa");
		return this.container_area.find("[name=" + name + "]");
	}
	initBinder() {
		//var myModel = new ax5.ui.binder();
		//이것 너무  axjs붙어있다.
		
		//es6에 proxy를 이용하자.
		//https://www.sitepoint.com/es6-proxies/
		//https://ko.javascript.info/proxy
		//https://www.youtube.com/watch?v=h1RCCJtQoUs&t=463s   [이거 강추]
		let c = this;
		const createState = (stateObj) => {
			return new Proxy(stateObj, {
				set(target, property, new_value) {
					target[property] = new_value;
					//console.log(property);
					//console.log(c.get(property));
					//console.log(new_value);
					c.get(property)[0].value = new_value;
					return true;
				}
			});
		};

		this.target_data = {};
		let tgt_data = this.target_data;
		var w = this.container_area[0];
		console.log(w.querySelectorAll('[data-model]').length)
		for (var i = 0; i < w.querySelectorAll('[data-model]').length; i++) {
			var el = w.querySelectorAll('[data-model]')[i];
			tgt_data[el.name] = '';
		}

		this.state = createState(tgt_data);
		const state = this.state;
		const listeners = w.querySelectorAll('[data-model]');
		listeners.forEach((element) => {
			const name = element.name;
			element.addEventListener('keyup', (event) => {
				state[name] = element.value;
			})
		});
	}
	getData() {
		return this.target_data;
	}
	setDataAll(data_all) {
		console.log(this.state);
		for (const [key, value] of Object.entries(data_all)) {
			this.setData(key, value);
		}
	}
	setData(prop, value) {
		if (this.state.hasOwnProperty(prop)) {
			this.state[prop] = value;
		} else {
			//alert(prop+'속성은 존재하지 않습니다.');
			console.log(prop + '속성은 존재하지 않습니다.')
		}
	}
	clearData(){
		//proxy를 가지고 값들을 "" 처리한다.
		for (const [key, value] of Object.entries(this.target_data)) {
			this.setData(key, "");
		}
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
	addEvent(event_name, el_sel, func) {
		console.log(this);
		var w = this.container_area[0];
    	/*
    	if(w.querySelectorAll("input[type=button]")){
			w.querySelectorAll("input[type=button]").forEach(function(el){
					el.addEventListener(event_name, func);	
			});
    	}
    	*/
		if (w.querySelectorAll(el_sel)) {
			w.querySelectorAll(el_sel).forEach(function(el) {
				el.addEventListener(event_name, func);
			});
		}
	}
}