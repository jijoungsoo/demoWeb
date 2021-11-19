'use strict';
class MetismenuMngr {
	constructor(menu_root,left_menu_item,left_menu_3depth_list) {
		this.menu_root= menu_root;
		this.left_menu_item= left_menu_item;
		this.left_menu_3depth_list = left_menu_3depth_list;
		let _this=this;
		/*상단버튼 이벤트*/
		const top_buttons = document.querySelectorAll("[name=top_menu_cd]");
		for (const button of top_buttons) {
			button.addEventListener('click', function(event) {
	    	var tmp=this.getAttribute('menu_cd');
	    		_this.top_menu_click(tmp);
			});
		}
		
		/*메뉴 버튼*/	
		const three_buttons = document.querySelectorAll(".three_depth_right")
		for (const button of three_buttons) {
		  button.addEventListener('click', function(event) {
		    	var tmp=this.getAttribute('menu_no');
		    	_this.join_fav_menu(tmp)
		  })
		}
		
		/*좌측메뉴*/
		this.left_metismenu();
		/*좌측즐겨찾기 가져오기*/
		this.fav_menu_sync();
		this.targetClickEvent();
		
		/*좌측하단 검색기능*/
		var my_search = document.getElementById("mySearch");
		my_search.addEventListener('keyup', function(event) {
			_this.func_menu_search();
	  	})
	}
	func_menu_search() {
		let input = document.getElementById("mySearch");
		let filter = input.value.toUpperCase();
		if(filter==''){
			$("#footer_menu").empty();  //전체를 지우고
			return;
	  	}
	  	$("#footer_menu").empty();  //전체를 지우고
	  	let _this=this;

	  	for (var i = 0; i < this.left_menu_3depth_list.length; i++) {
			var tmp=this.left_menu_3depth_list[i];
    		if (tmp.MENU_NM.toUpperCase().indexOf(filter) > -1) {
     	    	var tmp_el = `<li><a href='#' 
    									class="js-open-target" 
    									data-target="`+tmp.PGM_ID+`" 
    									data-title="`+tmp.MENU_NM+`">
    									`+tmp.MENU_NM+`</a></li>`;
    			$("#footer_menu").append(tmp_el);
    			_this.targetClickEvent();
     		}
	  	}
	}
	
	join_fav_menu(menu_no){
		var param = {
				brRq : 'IN_DATA',
				brRs : '',
				IN_DATA : [ { MENU_NO : menu_no } ]
		}
		let _this=this;
		AjaxMngr.send_api_post_ajax('BR_CM_FAV_MENU_CREATE', param,  function(data) {
			if (data) {
				Message.alert("즐겨찾기에 추가되었습니다.",function(data2){
					_this.fav_menu_sync();
				});
				return;
			}
		});
	}
	
	top_menu_click(menu_id){
		for(var i=0;i<this.menu_root.length;i++){
			$('#'+this.menu_root[i]).hide();	
		}
		$('#'+menu_id).show();
	}
	
	rm_fav_menu(fav_no){
		var param = {
				brRq : 'IN_DATA',
				brRs : '',
				IN_DATA : [ { FAV_NO : fav_no } ]
		}
		let _this =this;
		AjaxMngr.send_api_post_ajax('BR_CM_FAV_MENU_RM', param,  function(data) {
			if (data) {
				Message.alert("즐겨찾기가 삭제되었습니다.",function(data2){
					_this.fav_menu_sync();
				});
				return;
			}
		});
	}
	
	fav_menu_button_trigger(){
		let _this =this;
	    const fav_buttons = document.querySelectorAll(".fav_depth_left")
		for (const button of fav_buttons) {
	      button.addEventListener('click', function(event) {
	        	var tmp=this.getAttribute('fav_no');
	        	_this.rm_fav_menu(tmp);
	      })
		}
	}
	
	targetClickEvent() {
		$(".js-open-target").on("click", function (e) {
			e.preventDefault();
			var target = $(this).data("target");
			console.log(target);
			//var title = $(this).data("title");
			//PgmPageMngr.goOnePage(target);   //한페이지만 여는 옵션
			PgmPageMngr.goPage({
	    			COMPONENT_NAME: target
	    			/*,TITLE : "창이름"*/
	    			,WINDOW : "S"
			});
		});
	}
	
	fav_menu_sync(){
		let param = {
				brRq : '',
				brRs : 'OUT_DATA'
		}
		let _this = this;
		AjaxMngr.send_api_post_ajax('BR_CM_FAV_MENU_FIND_BY_USER_NO', param,  function(data) {
			if(data){
			    let fav_menu_template_html = $("#fav_menu-template").html();
			    let fav_menu_template = Handlebars.compile(fav_menu_template_html);
			    let fav_menu = { favMenuList : data.OUT_DATA };
				let tmp =fav_menu_template(fav_menu);

				$("#fav_menu").empty();
			    $("#fav_menu").append(tmp);
			    //_this.fav_metismenu_resync();
			   	_this.targetClickEvent();
			    _this.fav_menu_button_trigger();
			    
			}
			
		});
	}

	left_metismenu(){
		for(var i=0;i<this.left_menu_item.length;i++){
			var tmp =this.left_menu_item[i].MENU_CD;
			$('#'+tmp).metisMenu('dispose');
	    	var left_menu_metis=$('#'+tmp).metisMenu(
		    	{expand:true/*한번 열리면 모두 펼치기 */ 	
		    	, toggle: false   /*이거를 true로 하면 하나 닫히고 하나열림, false면 그것만 닫히고 그것만 열림*/
		    	, triggerElement: 'div' 
		    	}
	    	);
		}
	}
	
	fav_metismenu_resync(){
		$('#metismenu_fav').metisMenu('dispose');
		var fav_menu_metis=$('#metismenu_fav').metisMenu(
			{
				expand:true/*한번 열리면 모두 펼치기 */ 	
				, toggle: false   /*이거를 true로 하면 하나 닫히고 하나열림, false면 그것만 닫히고 그것만 열림*/
				, triggerElement: 'div'
			}
		);
	}

}