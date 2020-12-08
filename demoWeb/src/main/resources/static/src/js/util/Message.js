class Message {
    // Static properties shared by all instances
	constructor() { 
	}
    static alert(message,p_funtion) { 
      	var dialog = new ax5.ui.dialog({
			title: "Alert"
    	});
		dialog.alert(message, function () {
				if(p_funtion!=undefined){
					p_funtion()
				}
                
        });
   	}	
   	
   	static confirm(message,p_funtion) { 
        var confirmDialog = new ax5.ui.dialog();
        confirmDialog.setConfig({
            title: "confirm",
            theme: "danger"
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