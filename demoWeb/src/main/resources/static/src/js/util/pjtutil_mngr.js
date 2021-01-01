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
}