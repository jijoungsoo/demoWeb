'use strict';
class PopupManger {
	constructor(pgm_mngr, page_id, options, p_param) {
		/*page_id로 페이지내에 유일한 div로 생각한다. 앞에서 넘길때  uuid까지 조합해서 만들어야한다. */
		/*
	    아이디어들 ==>
	    https://gist.github.com/craigmccoy/3753941
	    https://stackoverflow.com/questions/3837166/jquery-load-modal-dialog-contents-via-ajax
	    */
	    this.pgm_mngr 	= pgm_mngr;
	    var uuid 	= pgm_mngr.getId();
	    var popup_uuid	= AppMngr.makeUUID();
		this.popup_uuid = popup_uuid;
	    this.container_id=(uuid + "-" + popup_uuid + "-popup");
		var _this=this;
		var defaults = {
			dialogClass: "no-close",
			  appendTo: "#layoutContainer",/*   팝업은 무조건 루트에 붙자.-- */
			 /*appendTo: "#"+uuid,*/
			autoOpen: false,        /*초기화 즉시 다이얼로그를 열지 */
			closeOnEscape: false,   /*esc  를 누를때 닫히게 할지*/
			resizable: true,       /*사이즈 조절을 가능하게 할지 */
			modal: true,         /*  뒤에가 클릭이 안되도록   */
			draggable: true,   /*false면 창이 안움직인다. */
			height: 700,
			width: 600,
			open: function(event, ui) {
				$(this).parent().css({'top': 10});
			},
			beforeClose: function() {
			},
		    close: function() {
        		//dialog("destroy").remove()
        		//x버튼을 눌렀을때 삭제하는 기능
        		_this.close();
      		}
		}
		// Merge defaults and options, without modifying defaults
		var settings = $.extend({}, defaults, options);
		//console.log('aaaa');
		//console.log(settings);
		var tmp = `
    	<div id="`+ this.container_id+`">
    	</div>
    	`
    	let el =$("#" + this.container_id);
    		    //console.log(this.el);
		el.remove();
		$("#" + uuid).append(tmp);  //윈도우창에 프로그래스 div를 추가한다.
		
		this.el =$("#" + this.container_id);
		//console.log(this.el);
		this.el.css('display', 'none');
		this.dialog = this.el.dialog(settings);
		var p_param = $.extend(p_param, { uuid: popup_uuid , parent_uuid : uuid  });
		
		PgmPageMngr.addReqMap(popup_uuid,{ popup_mngr : this,param : p_param });
		AjaxMngr.get_page_ajax(this.el,page_id,p_param);

	
		this.dialog.on("dialogopen", function(event, ui) {
			var a = $("#" + uuid)
			//console.log('a');
			//console.log(a);
			//console.log('b');
			//var tmp_style = 'top:' + a.offset().top + 'px !important;left:' + a.offset().left + 'px !important;height: ' + a.height() + 'px !important;width:' + a.width() + 'px !important; z-index: 100;background:#aaa !important;opacity : 0.5;'
			//$("#" + uuid + ".ui-widget-overlay").attr('style', tmp_style);
			//$(".ui-widget-overlay").attr('style', tmp_style);
		});
	}
	
	open(func){
		this.dialog.dialog("open");
		this.func=func;
	}
	close(data) {
		//dialog를 삭제하는기능
		this.dialog.dialog("destroy").remove();
		//console.log(this.popup_uuid)
		var pgm_mngr=PgmPageMngr.getPgmUuIdMap(this.popup_uuid)
		pgm_mngr.destory();
		if(data!=undefined){
			//console.log(data);
			this.func(data);
		}
	}
}