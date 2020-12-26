class TuiGridMngr {
  constructor(pgm_mngr, grid_name, columns, p_options) {
		this.pgm_mngr=pgm_mngr;
      var basic_options = {
        editable: false
        ,scrollX: true
        ,scrollY: true
        ,bodyHeight: 700           /*그리드 높이지정 */
        ,editingEvent: 'dblclick'  /*더블클릭 수정 */
        ,minBodyHeight: 30
        ,copyOptions: {
          useFormattedValue: true,   /*셀의 formatter와 함께 텍스트를 복사한다.*/
          useListItemText: true    /*선택 또는 체크 박스 셀의 값을 listItem의 value가 아닌 text로 복사한다.*/
          /*,customValue: 'custom'   문자열 또는 함수로 변경된 값을 복사한다.*/
        }
        ,hideLoadingBar: true /*loading 바를 숨김  별도 로딩바를 구현했으므로 필요없다.*/
        ,rowHeaders:  []   /*그리드에 ['rownum','checkbox'] 표시 */
        ,showRowStatus : true         /*C또는 U 상태보이기*/
        ,rowNum: false
        ,checkbox: false
        ,showDummyRows: true   /*높이만큼 비어있으면 비어있는 컨텐츠를 보여준다.*/
      };
      this.options = $.extend(basic_options, p_options);
      var o_columns = [];
      /*상태넣기 */
      if (this.options.showRowStatus == true) {
        o_columns.push({
          header: ' '
          ,name: '_ROW_STATUS'
          ,width: 20
          ,align: 'center'
        });

        //컬럼고정카운트도 1증가해야함
        if(this.options.columnOptions) {
          if(this.options.columnOptions.frozenCount){
            this.options.columnOptions.frozenCount=this.options.columnOptions.frozenCount+1;
          }
        }
      }
      var arr_rowHeaders = new Array();
      if(this.options.rowNum==true) {
        arr_rowHeaders.push('rowNum');
      }
      if(this.options.checkbox==true) {
        arr_rowHeaders.push('checkbox');
      }
      this.options.rowHeaders=arr_rowHeaders;


      for (var i = 0; i < columns.length; i++) {
        o_columns.push(columns[i]);
      }
      this.options.el= pgm_mngr.get(grid_name)[0] /*타켓대상*/
      this.options.columns= o_columns;
  }
  build()  {
    var tmp =this.options;
      const grid = new tui.Grid(tmp);
      tui.Grid.applyTheme('striped', {
        frozenBorder: {
            border: '#ff0000'
        }
      });
      
      grid.on('beforeRequest', function(ev) {
        pgm_mngr.showProgress(); 
          console.log('요청을 보내기 전')
          console.log(ev)
      });
      grid.on('response', function(ev) {
        pgm_mngr.hideProgress(); 
          console.log('성공/실패와 관계 없이 응답을 받았을 경우')
          console.log(ev)
      });
      
      grid.on('failResponse', function(ev) {
          console.log('결과가 false인 경우')
          console.log(ev)
      });
      grid.on('errorResponse', function(ev) {
          console.log('오류가 발생한 경우')
          console.log(ev)
      });
    /* 이거 에러가 난다.
      grid.on('successResponse', function(ev) {
        console.log('결과가 true인 경우');
          console.log(ev);
    });
    */

    grid.on('afterChange', ev => {
      console.log('aaaaaa', ev);
          console.log('check!', ev);
        });

    grid.on('editingFinish', ev => {
      /*수정이벤트가 일어나면 여기가 고고 한다.*/
        var tmp = ev.instance.dataManager.getModifiedData('UPDATE',{rowKeyOnly: true}).updatedRows;
        if(tmp!=undefined && tmp.length>0) {
          if(tmp.indexOf(ev.rowKey)>=0){
            ev.instance.setValue(ev.rowKey,  '_ROW_STATUS' /*columnName*/,'M');
            return;
          }
        }

        var tmp = ev.instance.dataManager.getModifiedData('CREATE',{rowKeyOnly: true}).createdRows;
        if(tmp!=undefined && tmp.length>0 ) {
          if(tmp.indexOf(ev.rowKey)>=0){
            ev.instance.setValue(ev.rowKey, '_ROW_STATUS' /*columnName*/, '+');
          }
        }
    });
    this.grid=grid;
  }
 
  loadData(url,param, p_func){
    var mask = new ax5.ui.mask();
	mask.open({
		content: '<h1><i class="fa fa-spinner fa-spin"></i> Loading</h1>'
		,target: $("#"+this.pgm_mngr.getId()).get(0),
	});
    let grid=this.grid;    
    let options = this.options;
    grid.clear();
    AjaxMngr.send_api_post_ajax(url, param, function (data) {

	  console.log('param')
	  console.log(param)
	  
      console.log('loadData')
      console.log(data)
      
      var arr_brRs = param.brRs.split(",");
      var brRs  = arr_brRs[0];
      
      console.log('arr_brRs')
      console.log(brRs)
      if(data[brRs]) {
	    grid.resetData(data[brRs]);
        if(options.showRowStatus==true){
          var t = grid.getData(); 
          t.forEach(element => { 
            element._ROW_STATUS=null;
            }
          )
          grid.resetData(t);
        }
      }
      mask.close();
      if(p_func){
    	p_func(data);
    	}
      
      /* tui_grid 전용 함수  나중에는 이대로 가야할것 같다.
      if(data.result) {
        grid.resetData(data.data.contents);
        if(options.showRowStatus==true){
          var t = grid.getData(); 
          t.forEach(element => { 
            element._ROW_STATUS=null;
            }
          )
          grid.resetData(t);
        } 
      }
      
      */
    })
  }
  resetData(data){
  	this.grid.resetData(data);
  }
   
  getCheckedData() {
    return this.grid.getCheckedRows();
  }
  
  getModifiedRows() {
    return this.grid.getModifiedRows();
  }
  getColumns(){
  	return this.grid.getColumns();
  }
  /* 필요없다.
  valid() {
    //없으면 []
    return this.grid.validate();
  }
  */
  isValid() {
	if(this.grid.validate().length==0){
		return true;
	}
    return false;
  }
  validMsg() {
    var valid_err_data=this.grid.validate();
    
    console.log(valid_err_data);
    
    if(valid_err_data.length==0){
    	return;
    }
    
    var grid_columns = this.grid.getColumns();
    
    var ret ='';
    for(var i=0;i<valid_err_data.length;i++){
    	//이거가 한줄이다.  한줄에 컬럼별로 valid가 걸린다.
    	var al_col_error  =  valid_err_data[i].errors;
    	for(var j=0;j<al_col_error.length;j++){
    		var columnNmae =  al_col_error[j].columnName;
    		var errorCode  =  al_col_error[j].errorCode;
    		var header ='';
    		grid_columns.forEach(function(data){ 
    			if(data.name==columnNmae) { 
    				header = data.header;
    			}  
    		});
    		ret = ret+ "["+i+"]행 ["+header+"]컬럼이 유효하지않습니다.["+errorCode+"]<br />";
    		
    	}
    }
    console.log(ret);
    Message.alert("<div style='text-align:left'>"+ret+"</div>");
    return;
    
  }
  appendRow() {
    //column 값을 읽어와서 하나짜리 row를 만들어야한다.
    var t  = this.grid.getColumns();
    var tmp={};
    this.grid.appendRow(tmp);
  }
  on(event_name,func){
  	this.grid.on(event_name,func);
  }
  getRow(rowKey){
  	return this.grid.getRow(rowKey);
  }
  clear(){
  	this.grid.clear();
  }
}