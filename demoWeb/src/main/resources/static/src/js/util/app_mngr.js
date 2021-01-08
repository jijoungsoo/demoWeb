'use strict';
class AppMngr {
	static isEmpty(str){
	    if(str==undefined){
	        return true;
	    }
	    if(str.trim()==''){
	        return true;
	    }
	    return false;
	
	}
	
	static makeUUID() { // UUID v4 generator in JavaScript (RFC4122 compliant)
	    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
	      var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 3 | 8);
	      return v.toString(16);
	    });
	}
	
	static debug_console ="N";
	
	static openLog(uuid,seq){
		var param = {
				UUID : uuid,
				SEQ : seq
				
		}
		var tmp = PgmPageMngr.getPgmUuIdMap(uuid);
		var popup = new PopupManger(tmp, 'CM_1800', {
          width: 1100,
          heght: 700
        },
          param
        );
        popup.open(function(data){
        	if(data){
        		console.log(data);
        	}
        });
	}
}
