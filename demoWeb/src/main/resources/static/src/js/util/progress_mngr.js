/* http://ax5ui.axisj.com/ax5ui-mask/demo/index.html */
function ProgressMngr(uuid) {
    var mask= new ax5.ui.mask();
    	/* 이거 실제로 필요없음 전체화면에 할꺼니까 부분적으로 할때 target에 넣을 필요있음
	    mask.setConfig({
	        target: document.body, // 미리 선언했지만
	        content: "<h1>Mask will disappear after 3 seconds.</h1>",
	        onStateChanged: function(){
	            
	        }
	    
		});
	*/
    this.showProgress=function(){
    	/*  open 안에  저 icon이 실제로 로딩 이미지 */
       mask.open({
                content: '<h1><i class="fa fa-spinner fa-spin"></i> Loading</h1>'
            });
    }
    this.hideProgress=function(){
       mask.close();
    }
   
} 
