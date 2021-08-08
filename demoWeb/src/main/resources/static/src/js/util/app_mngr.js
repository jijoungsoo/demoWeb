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
	
	static makeUUID() {
		return PjtUtil.makeUUID();
	    
	}
	
	static debug_console ="Y";
	
	static openLog(uuid,seq,api_uuid){
		var param = {
				UUID : uuid,
				SEQ : seq,
				API_UUID : api_uuid,
				
		}
		var tmp = PgmPageMngr.getPgmUuIdMap(uuid);
		var popup = new PopupManger(tmp, 'CM_1800', {
          width: 1100,
          heght: 700,
		  title: "로그보기"
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
