'use strict';
class InlinePopupManger {
	constructor(pgm_mngr, div_name, options) {
		var uuid 			= pgm_mngr.getId();
		var _this=this;
		var defaults = {
			dialogClass: "no-close",
			appendTo: "#" + uuid,   /*이건 사실 큰 의 미 없다. */
			autoOpen: false,        /*초기화 즉시 다이얼로그를 열지 */
			closeOnEscape: false,   /*esc  를 누를때 닫히게 할지*/
			resizable: true,       /*사이즈 조절을 가능하게 할지 */
			modal: true,         /*  뒤에가 클릭이 안되도록   */
			draggable: true,   /*false면 창이 안움직인다. */
			height: 700,
			width: 600,
			open: function() {
			},
			beforeClose: function() {
			},
		    close: function() {
        		//dialog("destroy").remove()
        		//x버튼을 눌렀을때 삭제하는 기능
        		_this.close();
      		}
		}
		var settings = $.extend({}, defaults, options);

		this.el =pgm_mngr.get(div_name)
		this.el.css('display', 'none');
		this.dialog = this.el.dialog(settings);
	
		this.dialog.on("dialogopen", function(event, ui) {
			var a = $("#" + uuid)
			var tmp_style = 'top:' + a.offset().top + 'px !important;left:' + a.offset().left + 'px !important;height: ' + a.height() + 'px !important;width:' + a.width() + 'px !important; z-index: 100;background:#aaa !important;opacity : 0.5;'
			$("#" + uuid + " .ui-widget-overlay").attr('style', tmp_style);
		});
	}
	
	open(func){
		this.dialog.dialog("open");
		this.func=func;
	}
	close(data) {
		this.dialog.dialog("destroy");		
		if(data!=undefined){
			console.log(data);
			this.func(data);
		}
	}
}