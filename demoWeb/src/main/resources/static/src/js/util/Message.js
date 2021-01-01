'use strict';
class Message {
    // Static properties shared by all instances
	constructor() { 
	}
    static alert(message,p_funtion) { 
    	var mask = new ax5.ui.mask();
        mask.open();
      	var dialog = new ax5.ui.dialog({
			title: "Alert",
			width: 400,
			height: 600
    	});
		dialog.alert(message, function () {
		 		mask.close();
				if(p_funtion!=undefined){
					p_funtion()
				}
                
        });
   	}	
   	
   	static confirm(message,p_funtion) { 
        var confirmDialog = new ax5.ui.dialog();
        confirmDialog.setConfig({
            title: "confirm",
            theme: "danger",
            width: 400,
			height: 600
        });
        var mask = new ax5.ui.mask();
        mask.open();
        confirmDialog.confirm({
            title: "Confirm",
            msg: message
        }, function(){
            if(this.key == "ok"){
                if(p_funtion!=undefined){
					p_funtion()
				}
            }
            else if(this.key == "cancel"){
                
            }
            mask.close();
        });
   	}
}