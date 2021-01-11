class TuiGridMngr {
  constructor(pgm_mngr, grid_name, p_options ,columns ) {
		this.pgm_mngr=pgm_mngr;
		this.total_size=0;    /*전체 데이터 사이즈*/
		this.curr_size=0;     /*현재까지 불러온 데이터 사이즈*/
		this.url  ='';        /*페이징 처리를 하려면 화면에서 넘어온 주소를 알고 있어야한다. */
		this.param  =[];        /*페이징 처리를 하려면 화면에서 넘어온 파라미터를 알고있어야한다. */ 
		this.page_num =0;       /*현재페이지 번호  첫번째 페이지가 0 번이다. */
		this.total_page = 1;    /*전체페이지 수*/
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
    
    if(this.options.pageable==false) {
    	return;
    }
    const page_element = `
    <div>
    	(<span name='curr_size'>0</span>/
    	<span name='total_size'>0</span>
    	)
    	<span name='page_num'>0</span>/
    	<span name='total_page'>0</span>
    	<input type='button' name='more' value='more' />
    	<input type='button' name='more_all' value='more all' />
    </div>
	`
	$(this.options.el).append(page_element);
	let _this=this;
	this.pgm_mngr.get('more')[0].addEventListener('click', function(event){
			if(_this.total_size==0){
				alert('조회버튼을 눌러주세요.');
				return;
			}
			if(_this.curr_size>=_this.total_size){
				alert('전체 검색되었습니다.');
				return;
			}
		_this.appendLoadData('one');
	});
	this.pgm_mngr.get('more_all')[0].addEventListener('click', function(event){
			if(_this.total_size==0){
				alert('조회버튼을 눌러주세요.');
				return;
			}
			if(_this.curr_size>=_this.total_size){
				alert('전체 검색되었습니다.');
				return;
			}
		_this.appendLoadData('all');
	});  
  }
 
  loadData(url,param, p_func){
    this.url   = url;
    this.param = _.cloneDeep(param);
    if(this.options.pageable==true){
		param.brRq=(param.brRq+",PAGE_DATA");
		var tmp=[];
		tmp.push({PAGE_NUM:  0 , PAGE_SIZE: this.options.pageSize });
		param.PAGE_DATA=tmp;
    }
    var mask = new ax5.ui.mask();
	mask.open({
		content: '<h1><i class="fa fa-spinner fa-spin"></i> Loading</h1>'
		,target: $("#"+this.pgm_mngr.getId()).get(0),
	});
	let _this=this;	
    AjaxMngr.send_api_post_ajax(url, param, function (data) {
      var arr_brRs = param.brRs.split(",");
      var brRs  = arr_brRs[0];
      if(data !=undefined  && data[brRs]!=undefined) {
        if(_this.options.showRowStatus==true){
          for(var i=0;i<data[brRs].length;i++){
	        	data[brRs][i]._ROW_STATUS=null;
	      }
	 	  _this.grid.resetData(data[brRs])
        } else {
          _this.grid.resetData(data[brRs])
        }
      }
      _this.total_size=0;
      if(_this.options.pageable==true 
      		&& data !=undefined 
      		&& data["PAGE_DATA"]!=undefined) {
      		 _this.total_size = data["PAGE_DATA"][0]["TOTAL_SIZE"]
      		 _this.page_num   = data["PAGE_DATA"][0]["PAGE_NUM"]
      		 _this.total_page   = data["PAGE_DATA"][0]["TOTAL_PAGE"]
      		 _this.curr_size  = _this.grid.getRowCount()
      }
      mask.close();
      if(p_func){
    	p_func(data);
      }
        
	    if(_this.options.pageable==false) {
	    	return;
	    }
      _this.pgm_mngr.get("curr_size")[0].innerText=_this.curr_size;
      _this.pgm_mngr.get("total_size")[0].innerText=_this.total_size;
      _this.pgm_mngr.get("page_num")[0].innerText=(_this.page_num+1);
      _this.pgm_mngr.get("total_page")[0].innerText=_this.total_page;
    }
    ,this.pgm_mngr.getId()
    )
  }
  resetData(data){
  	this.grid.resetData(data);
  }
  
  appendLoadData(p_data_flag_all){
	    if(this.options.pageable==false){
	    	return;
	    }
	    var param= _.cloneDeep(this.param);
   		param.brRq=(param.brRq+",PAGE_DATA");
		var tmp=[];
		this.page_num = this.page_num+1;
		tmp.push({PAGE_NUM: this.page_num, PAGE_SIZE: this.options.pageSize });
		param.PAGE_DATA=tmp;
	    
	    var mask = new ax5.ui.mask();
		mask.open({
			content: '<h1><i class="fa fa-spinner fa-spin"></i> Loading</h1>'
			,target: $("#"+this.pgm_mngr.getId()).get(0),
		});
	    let _this=this;
	    AjaxMngr.send_api_post_ajax(_this.url, param, function (data) {
	      var arr_brRs = param.brRs.split(",");
	      var brRs  = arr_brRs[0];
	      if(data !=undefined  && data[brRs]!=undefined) {
	        if(_this.options.showRowStatus==true){
	          for(var i=0;i<data[brRs].length;i++){
	        	data[brRs][i]._ROW_STATUS=null;
	          }
	 	      _this.grid.appendRows(data[brRs])
	        } else {
	        	_this.grid.appendRows(data[brRs])
	        }
	      }
	      if(_this.options.pageable==true 
	      		&& data !=undefined 
	      		&& data["PAGE_DATA"]!=undefined) {
	      		_this.total_page  = data["PAGE_DATA"][0]["TOTAL_PAGE"];
	      		_this.total_size  = data["PAGE_DATA"][0]["TOTAL_SIZE"];
	      		_this.page_num    = data["PAGE_DATA"][0]["PAGE_NUM"];
	      		_this.curr_size   = _this.grid.getRowCount();
	      }
	      _this.pgm_mngr.get("curr_size")[0].innerText=_this.curr_size;
      	  _this.pgm_mngr.get("total_size")[0].innerText=_this.total_size;
      	  _this.pgm_mngr.get("page_num")[0].innerText=(_this.page_num+1);
      	  _this.pgm_mngr.get("total_page")[0].innerText=_this.total_page;
      	  if(p_data_flag_all!='all'){  //all 이 아니라면 종료
      	  	mask.close();
      	  	return;   
      	  }
	      
	      
	      if(_this.curr_size>=_this.total_size){
	      	mask.close();
      	  	return;
	      }
	      
	      if(p_data_flag_all==='all'){
  	        setTimeout(function() {
  	           mask.close();	
  	        	_this.appendLoadData(p_data_flag_all);
			}, 0);  //일단 딜레이0 으로 주자 서버 부하를 생각했는데
			//확인해보니까. 1000개짜리 20번 호출하는 것보다 20000개를 1번 호출하는게 더 문제가 된다.
	      }
	    })
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
  setValue(rowKey, columnName, value){
		this.grid.setValue(rowKey, columnName, value, false);  
  }
  
}