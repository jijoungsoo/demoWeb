class TuiGridMngr {
  constructor(pgm_mngr, grid_name, p_options ,columns ) {
  		var _this = this;
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
        ,pageable: false /*커스터마이징 서버에 보낼때 페이징 파라미터를 달고 갈것인지 여부*/
        ,pageSize: 300   /*페이징 처리를 한다면 한화면에 몇개보일지 여부*/
        ,pageNum:1   /*페이징 처리를 한다면 현재화면이 몇번째인지 저장 */  
       
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
      
      if(this.options.rowNum==true || this.options.checkbox==true) {
	      var arr_rowHeaders = new Array();
	      if(this.options.rowNum==true) {
	        arr_rowHeaders.push('rowNum');
	      }
	      if(this.options.checkbox==true) {
	        arr_rowHeaders.push('checkbox');
	      }
	      this.options.rowHeaders=arr_rowHeaders;
      } 
      


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
    if(this.options.pageable==true){
    	//이걸변경시킨다.
    	/*늘 동일한 형식
    	var param = {
					brRq : 'IN_DATA',
					brRs : 'OUT_DATA',
					IN_DATA : [ data ]
		}
		이렇게 바꿔야한다.
		var param = {
					brRq : 'IN_DATA,PAGE_DATA',
					brRs : 'OUT_DATA',
					IN_DATA : [ data ],
					PAGE_DATA: [{PAGE_NUM: 1 , PAGE_SIZE: 100 }]
					
		}
		*/
		console.log(param)
		param.brRq=(param.brRq+",PAGE_DATA");
		var tmp=[];
		var page_num = this.options.pageNum;
		var page_size = this.options.pageSize;
		tmp.push({PAGE_NUM:page_num, PAGE_SIZE: page_size });
		param.PAGE_DATA=tmp;
		console.log(param);
    }
  
  
    var mask = new ax5.ui.mask();
	mask.open({
		content: '<h1><i class="fa fa-spinner fa-spin"></i> Loading</h1>'
		,target: $("#"+this.pgm_mngr.getId()).get(0),
	});
    let grid=this.grid;    
    let options = this.options;
    console.log('ddddddddddddddddddddddd');
    let _this=this;
    ///..grid.clear();  저장하고 다시 loadData를 호출할때  grid.clear()에서 간헐적으로 에러나서 주석 
    console.log('ccccccccccccccccccccc');
    AjaxMngr.send_api_post_ajax(url, param, function (data) {

	  console.log('param')
	  console.log(param)
	  
      console.log('loadData')
      console.log(data)
      
      var arr_brRs = param.brRs.split(",");
      var brRs  = arr_brRs[0];
      
      console.log('arr_brRs')
      console.log(brRs);

      if(data !=undefined  && data[brRs]!=undefined) {
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
      var total_size=0;
      if(_this.options.pageable==true 
      		&& data !=undefined 
      		&& data["PAGE_DATA"]!=undefined) {
      		total_size = data["PAGE_DATA"][0]["TOTAL_SIZE"]
      }
      mask.close();
      if(p_func){
    	p_func(data);
    	}

      /*조회를 하면  현재화면출력수/전체출력수  표시되었으면 한다 
      	 more로갈거니까.
      */
      var tmp = _this.pgm_mngr.get("grid_status");
      console.log(tmp)
      if(tmp[0]==undefined) {
      	if(_this.options.pageable==true){
      		$(_this.options.el).append("<span name='grid_status'>"+(_this.getRowCount())+"/"+total_size+"</span>")
      	} else {
      		$(_this.options.el).append("<span name='grid_status'>"+(_this.getRowCount())+"</span>")
      	}
      	
      } else {
        if(_this.options.pageable==true){
      		tmp[0].innerHTML=(   (_this.getRowCount())+"/"+total_size    );
      	} else {
      		tmp[0].innerHTML=(_this.getRowCount());
      	}
      }
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
  appendRow(row) {
    //column 값을 읽어와서 하나짜리 row를 만들어야한다.
    console.log(row)
    var t  = this.grid.getColumns();
    var tmp={};
	tmp = $.extend(tmp, row);
    console.log(tmp)
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
  getSelectedRow() {
  	var tmp =this.grid.getFocusedCell();
  	if(tmp.rowKey==null){
  		return null;
  	}
  	var tmp2 =this.grid.getRow(tmp.rowKey);
  	console.log(tmp2);
  	return tmp2; 
  }
  getRowCount(){
  	return this.grid.getRowCount();
  }
  
}