'use strict';
class PjtUtil{
	static isEmpty(param) {
		if(undefined===param){
			return true; 
		}
		if(param.length==0){
			return true;
		}
		return false;
	}
	static addEvent(el, event_name, el_sel, func) {
		var w = el;
		if (w.querySelectorAll(el_sel)) {
			w.querySelectorAll(el_sel).forEach(function(el) {
				el.addEventListener(event_name, func);
			});
		}
	}
}