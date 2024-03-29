class TuiGridMngr {
  constructor(pgm_mngr, grid_name, p_options ,columns ) {
		this.pgm_mngr=pgm_mngr;
		this.total_size=0;    /*전체 데이터 사이즈--전체갯수*/
		this.curr_size=0;     /*현재까지 불러온 데이터 사이즈*/
		this.url  ='';        /*페이징 처리를 하려면 화면에서 넘어온 주소를 알고 있어야한다. */
		this.param  =[];        /*페이징 처리를 하려면 화면에서 넘어온 파라미터를 알고있어야한다. */ 
		this.page_num =0;       /*현재페이지 번호  첫번째 페이지가 0 번이다. */
		this.total_page = 1;    /*전체페이지 수*/
        this.grid_name=grid_name;
      var basic_options = {
        editable: false
        ,scrollX: true
        ,scrollY: true
        ,bodyHeight: 620           /*그리드 높이지정 */
        /*,editingEvent: 'dblclick'  더블클릭 수정 */
		,editingEvent: 'click'   /*한번 클릭으로 그리드 수정하게 */
        ,contextMenu: true 
        ,minBodyHeight: 30
        ,rowHeight: 30
        ,minRowHeight: 30
        ,copyOptions: {
          useFormattedValue: true,   /*셀의 formatter와 함께 텍스트를 복사한다.*/
          useListItemText: true,    /*선택 또는 체크 박스 셀의 값을 listItem의 value가 아닌 text로 복사한다.*/
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
        ,columnOptions: {  /*컬럼 너비 조절 */
            resizable: true
        }
        ,visibleTotalCnt: true 
      };
      this.options = $.extend(basic_options, p_options);
      var o_columns = [];
      /*상태넣기 */
      if (this.options.showRowStatus == true) {
        o_columns.push({
          header: 'M'
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
		  	var tmp = columns[i];
			if(tmp && tmp.type){
				switch(tmp.type){
					case "combo":
						console.log('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa')
						var item_data2 = [];
						var item_data = tmp.comboData;
						for(var j=0;j<item_data.length;j++){
							item_data2.push({
								value : item_data[j].VALUE,
								text : item_data[j].TEXT
							});
						}
						console.log(item_data2);
						console.log('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa2222222a')
						tmp.formatter= 'listItemText';
						tmp.editor = {
							type: 'select',
							options: {
							  listItems: item_data2
							}
						}
						break;									
				}
			}
			o_columns.push(tmp);
      }
      console.log("aaaa");
      console.log(pgm_mngr.get(grid_name));
      pgm_mngr.get(grid_name).empty();
      this.options.el= pgm_mngr.get(grid_name)[0]; /*타켓대상*/
      
      this.options.columns= o_columns;
  }
  initCombo(br,param,option) {
	console.log('tui-initCombo');
	console.log(option);
	let _this =this;
	let _option =option;
	this.pgm_mngr.send_sync(br, param, function(data){
		var tmp = _this.get(name);
		console.log(tmp);
		var el = _this.get(name)[0];
		if(_option && _option.USE_EMPTY_YN){
			if(_option.USE_EMPTY_YN=='Y'){
				var option = document.createElement("option");
				option.value = '';
				option.text  = '빈것';
				el.add(option);
			}
		} else {
			if(_option.USE_EMPTY_YN=='Y'){
				var option = document.createElement("option");
				option.value = '';
				option.text  = '빈것';
				el.add(option);
			}
		}
		if(data.OUT_DATA && data.OUT_DATA.length){
			var value_name="value";
			var text_name="text";
			console.log(_option);
			if(_option && _option.VALUE) {
				value_name=_option.VALUE;
			}
			if(_option && _option.TEXT) {
				text_name=_option.TEXT;
			}
			
			for(var i=0;i<data.OUT_DATA.length;i++){
				var item_data = data.OUT_DATA[i];
				var option = document.createElement("option");
				option.value = item_data[value_name];
				option.text  = item_data[text_name];
				console.log(value_name);
				console.log(text_name);
				console.log(item_data);
				console.log(option);
				el.add(option);
			}
		}
		console.log(data);
	});
  }
  build()  {
    var tmp =this.options;
    console.log('grid->option');
      console.log(tmp);
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
   
    grid.on('check', ev => {
		console.log('check!', ev);
		if(this.options.checkFunc!=null){
			this.options.checkFunc(ev);
		}
	});

	grid.on('checkAll', ev => {
		console.log('checkAll!', ev);
		if(this.options.checkAllFunc!=null){
			this.options.checkAllFunc(ev);
		}
	});

	grid.on('uncheckAll', ev => {
		console.log('uncheckAll!', ev);
		if(this.options.uncheckAllFunc!=null){
			this.options.uncheckAllFunc(ev);
		}
	});

	grid.on('uncheck', ev => {
		console.log('uncheck!', ev);
		if(this.options.uncheckFunc!=null){
			this.options.uncheckFunc(ev);
		}
	});
	

    grid.on('afterChange', ev => {
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

	grid.on('beforeSort', function(ev) {
		console.log('beforeSort 발생한 경우')
		console.log(ev)
	});

	grid.on('afterSort', function(ev) {
		console.log('afterSort 발생한 경우')
		console.log(ev)
	});

    this.grid=grid;
    
    if(this.options.pageable==true) {
    	const page_element = `
	    <div name='`+this.grid_name+`_page_div'>
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
        console.log('cccccccccccccccccccccc');
        console.log(this.pgm_mngr.get(this.grid_name+'_page_div'));
		this.pgm_mngr.get(this.grid_name+'_page_div').find('[name=more]')[0].addEventListener('click', function(event){
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
		this.pgm_mngr.get(this.grid_name+'_page_div').find('[name=more_all]')[0].addEventListener('click', function(event){
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
    } else {
        if(this.options.visibleTotalCnt){
            const page_element = `
            <div name='`+this.grid_name+`_page_div'>
                (<span name='total_size'>0</span>)
            </div>
            `
            $(this.options.el).append(page_element);
        }
    }
	
	const context_menu_div = `
    <div name='tui-context-menu-container'>
    </div>
	`
	if(tmp.contextMenu==true && false/*문제있다 무조건 false */){	/*context Menu 생성 */
		$(this.options.el).append(context_menu_div);
		const contextMenu = new tui.ContextMenu(this.pgm_mngr.get("tui-context-menu-container")[0]);
		var _this =this;
		function onClick(e, cmd) {
            console.log(cmd);
            var arr_header = {};
            var arr_name = []
            var arr_data = [];
            if(cmd=='excel_download'){
            	var data = _this.grid.getColumns();
            	for(var i=0;i<data.length;i++){
            		var name = data[i].name;
            		var header = data[i].header;
            		if(name !=undefined && name !='_ROW_STATUS'){
            			arr_header[name] = header
            			arr_name.push(name);
            		}
            	}
            	arr_data.push(arr_header);
            	var data = _this.grid.getData();
        		for (var i=0;i<data.length;i++){
        			var rowKey = data[i].rowKey
        			var row_data = {}
        			for (var j=0;j<arr_name.length;j++){
        				var columnName 	= arr_name[j];
        				var value 		= _this.grid.getFormattedValue(rowKey, columnName);
        				row_data[columnName]=value;
        			}
        			arr_data.push(row_data);
        		}
        		console.log(arr_data);
        		var param ={
						brRq 		: 'IN_DATA'
						,brRs 		: ''
						,IN_DATA	: arr_data
					}
        		_this.download('BR_CM_GRID_DWNLD' ,param ,null);
            }
            
        }
        console.log(contextMenu);
        console.log(this.options.el);
        document.querySelector(this.options.el)
        
   	    contextMenu.register(this.options.el, onClick , [
            {title: '엑셀다운로드', command: 'excel_download'}
        ]);

	}
  }
 
  loadData(url,param, p_func){
    this.url   = url;
    this.param = _.cloneDeep(param);
    if(this.options.pageable==true){
/*과거 
		param.brRq=(param.brRq+",PAGE_DATA");
		param.PAGE_DATA={PAGE_NUM:  0 , PAGE_SIZE: this.options.pageSize };
*/

		param.brRq=(param.brRq+",__PAGING_INFO_IN__");  /*비즈액터 페이징 인풋 키 */
		/*__P_TOT_ROW_CNT_REQUIRED__   
		 "TRUE" 또는 "FALSE"로    "TRUE"로 보내면 전체 카운트를 세는 da를 자동으로 만들어 한번 더 실행한다.
		 */
		/*__P_START_ROWNUM__    시작 위치 */
		/*__P_END_ROWNUM__    종료 위치 */
		/*__P_TOT_ROW_CNT_TYPE__  필요없음  안넣어도 비즈액터 104=> NUMERIC  으로 자동세팅 */


		/*페이지 출력 */
		/*__PAGING_INFO_OUT__"&/
		/*========>  __P_TOT_ROW_CNT__  */
		/*========>  __P_TOT_ROW_CNT__  */

		param.__PAGING_INFO_IN__=[{__P_TOT_ROW_CNT_REQUIRED__ : "TRUE" 
		,__P_START_ROWNUM__:  1 
		,__P_END_ROWNUM__:  this.options.pageSize

		/*
		시작과 끝을 보내주면
		자동으로   offset값과 limit값을 계산해서 구해준다.
		X  s=>0,e=>100    =====>   o=>-1 , ㅣ=>101       오류발생  offset이 음수이다.
		O  s=>1,e=>100    =====>   o=>0 , ㅣ=>100         (100)
		X  s=>100,e=>200    =====>   o=>99 , ㅣ=>101      (101)
		O  s=>101,e=>200    =====>   o=>100 , ㅣ=>100      (100)
		*/
		}];

		//param.brRs=(param.brRs+",__PAGING_INFO_OUT__");   
		/*이걸 넣으면  오히려 안나오고  BR에 page에 da 에 page 옵션보고 나오고 안나오고 결정됨*/	
		/*bizacotr-json-servlet-v2를 수정함  brRq값이 있다면 무조건  __PAGING_INFO_OUT__를 더하도록 수정 */



    }
		var progress = new ProgressMngr(this.pgm_mngr.getId());
		progress.showProgress();
		let _this=this;	
    AjaxMngr.send_api_post_ajax(url, param, function (data) {
      var arr_brRs = param.brRs.split(",");
      var brRs  = arr_brRs[0];
	  console.log('brRs=>'+brRs);
      if(data !=undefined  && data[brRs]!=undefined) {
        if(_this.options.showRowStatus==true){
          for(var i=0;i<data[brRs].length;i++){
	        	data[brRs][i]._ROW_STATUS=null;
	      }
		  console.log(_this.grid);
		  console.log(brRs);
		  console.log(data);
	 	  _this.grid.resetData(data[brRs])
        } else {
          _this.grid.resetData(data[brRs])
        }
      }
      _this.total_size=0;
      if(_this.options.pageable==true 
      		&& data !=undefined 
      		&& data["__PAGING_INFO_OUT__"]!=undefined) {
      		 _this.total_size = data["__PAGING_INFO_OUT__"][0]["__P_TOT_ROW_CNT__"]
			   console.log(data["__PAGING_INFO_OUT__"]);

      		 //_this.total_page   = data["__PAGING_INFO_OUT__"]["TOTAL_PAGE"]
			   _this.total_page   = Math.ceil(_this.total_size/_this.options.pageSize)
      		 _this.curr_size  = _this.grid.getRowCount()
      		// _this.page_num   = data["__PAGING_INFO_OUT__"]["PAGE_NUM"]
			  _this.page_num    = Math.ceil(_this.curr_size/_this.options.pageSize)			   
      } else {
        _this.total_size  = _this.grid.getRowCount()
      }
      progress.hideProgress();
      if(p_func){
    	p_func(data);
      }
        

	    if(_this.options.pageable==false) {
            if(_this.visibleTotalCnt=== undefined){
                _this.pgm_mngr.get(_this.grid_name+'_page_div').find('[name=total_size]')[0].innerText=_this.total_size;
            } else if(_this.visibleTotalCnt==true){
                _this.pgm_mngr.get(_this.grid_name+'_page_div').find('[name=total_size]')[0].innerText=_this.total_size;
            }
	    } else {
            _this.pgm_mngr.get(_this.grid_name+'_page_div').find('[name=curr_size]')[0].innerText=_this.curr_size;
            _this.pgm_mngr.get(_this.grid_name+'_page_div').find('[name=total_size]')[0].innerText=_this.total_size;
            _this.pgm_mngr.get(_this.grid_name+'_page_div').find('[name=page_num]')[0].innerText=_this.page_num;
            _this.pgm_mngr.get(_this.grid_name+'_page_div').find('[name=total_page]')[0].innerText=_this.total_page;
        }
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
		/*과거
   		param.brRq=(param.brRq+",PAGE_DATA");		
		this.page_num = Number(this.page_num)+1;
		param.PAGE_DATA={PAGE_NUM: this.page_num, PAGE_SIZE: this.options.pageSize };
		*/
		this.page_num = Number(this.page_num);
		//alert(this.page_num);
		//alert(((this.page_num*this.options.pageSize)+1));
		//alert((this.page_num*this.options.pageSize)+this.options.pageSize);
		param.brRq=(param.brRq+",__PAGING_INFO_IN__");  /*비즈액터 페이징 인풋 키 */
		param.__PAGING_INFO_IN__=[{__P_TOT_ROW_CNT_REQUIRED__ : "TRUE" 
		,__P_START_ROWNUM__:  ((this.page_num*this.options.pageSize)+1)
		,__P_END_ROWNUM__:  (this.page_num*this.options.pageSize)+this.options.pageSize
		}];
	    
	    var progress = new ProgressMngr(this.pgm_mngr.getId());
		progress.showProgress();
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
	      		&& data["__PAGING_INFO_OUT__"]!=undefined) {
	      		//_this.total_page  = data["__PAGING_INFO_OUT__"]["TOTAL_PAGE"];
				_this.total_page   = Math.ceil(_this.total_size/_this.options.pageSize)
	      		_this.total_size  = data["__PAGING_INFO_OUT__"][0]["__P_TOT_ROW_CNT__"];
				_this.curr_size   = _this.grid.getRowCount();
	      		_this.page_num    = Math.ceil(_this.curr_size/_this.options.pageSize)
	      		
	      }
          _this.pgm_mngr.get(_this.grid_name+'_page_div').find('[name=curr_size]')[0].innerText=_this.curr_size;
          _this.pgm_mngr.get(_this.grid_name+'_page_div').find('[name=total_size]')[0].innerText=_this.total_size;
          _this.pgm_mngr.get(_this.grid_name+'_page_div').find('[name=page_num]')[0].innerText=(_this.page_num);
          _this.pgm_mngr.get(_this.grid_name+'_page_div').find('[name=total_page]')[0].innerText=_this.total_page;
      	  if(p_data_flag_all!='all'){  //all 이 아니라면 종료
			progress.hideProgress();
      	  	return;   
      	  }
	      
	      
	      if(_this.curr_size>=_this.total_size){
			progress.hideProgress();
      	  	return;
	      }
	      
	      if(p_data_flag_all==='all'){
  	        setTimeout(function() {
				progress.hideProgress();
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
  /*
  removeCellClassName(rowKey, columnName, className) {
	this.grid.removeCellClassName(rowKey,columnName, className);
  }
  addCellClassName(rowKey, columnName, className) {
	this.grid.addCellClassName(rowKey,columnName, className);
  }

  removeRowClassName(rowKey, className){
	this.grid.removeRowClassName(rowKey,className);
  }

  addRowClassName(rowKey, className){
	this.grid.addRowClassName(rowKey,className);
  }
  */
  check(columnName,columnValue){
	var data = this.grid.getData();
	for (var i=0;i<data.length;i++){
		var row    = data[i];
		if(row[columnName]==columnValue){
			this.grid.check(row.rowKey);
		}
	}
  }
  getData(){
	var data = this.grid.getData();
	return data;
  }
  disableRowCheck(columnName,columnValue){
	var data = this.grid.getData();
	for (var i=0;i<data.length;i++){
		var row    = data[i];
		if(row[columnName]==columnValue){
			this.grid.disableRowCheck(row.rowKey);
		}
	}
  }

  hideColumn(columnName){
	this.grid.hideColumn(columnName);
  }

  setSummaryColumnContent(columnName, columnContent){
  		this.grid.setSummaryColumnContent(columnName, columnContent);
  }
  getSummaryValues(columnName) {
  		//return this.grid.getSummaryValues(columnName);
  		console.log(this.grid.getSummaryValues(columnName));
  		console.log('abbbb');
  		//위에꺼쓰면안된다. 한번 사용하고 거기에 위에 것을 넣어 html을 넣으면 그다음부터 못가져옴
  		console.log(this.grid);
  		var sum=0;
  		var cnt = this.grid.getRowCount()
  		for(var i=0;i<cnt;i++){
  			var row_data = this.grid.getRowAt(i);
  			sum = sum+row_data[columnName];
  		}
  		//return sum;
  		return this.grid.getSummaryValues(columnName);
  }
  download(fileName ,p_param,func){
	/*데이터를 서버로 올리고   그걸 다운로드 하자.
	  이렇게 해야 다운로드 로그를 남길수있다.
	*/
	 var req_url = '/GRID_DWNLD/'+fileName;
	 $.ajax({
	        url: req_url,
	        method: 'POST',
	       	contentType: "application/json; charset=utf-8",
	    	accept: "application/json",
	    	xhrFields: {
	        	responseType: 'arraybuffer'
	    	},
			beforeSend : function(xhr)   /*이거 동작한다.  -- https://hyunsangwon93.tistory.com/28*/
	        { 
				xhr.setRequestHeader(csrf_headerName, csrf_token);
	        },
	        data: JSON.stringify(p_param) //이게 포인트 였다
	    }).done(function(data, textStatus, jqXhr) {
	        if (!data) {
	            return;
	        }
	        try {
	            var blob = new Blob([data], { type: jqXhr.getResponseHeader('content-type') });
	            var fileName = FileMngr.getFileName(jqXhr.getResponseHeader('content-disposition'));
	            fileName = decodeURI(fileName);
	 
	            if (window.navigator.msSaveOrOpenBlob) { // IE 10+
	                window.navigator.msSaveOrOpenBlob(blob, fileName);
	            } else { // not IE
	                var link = document.createElement('a');
	                var url = window.URL.createObjectURL(blob);
	                link.href = url;
	                link.target = '_self';
	                if (fileName) link.download = fileName;
	                document.body.append(link);
	                link.click();
	                link.remove();
	                window.URL.revokeObjectURL(url);
	            }
	        } catch (e) {
	            console.error(e)
	        }
	        
	        if(func){
	        	func(data);
	        }
	    }).fail(function (jqXHR, textStatus) {
	        console.log(jqXHR)
	        console.log(textStatus)
	        if (textStatus == "error") {
	            var msg = "Sorry but there was an error: ";
	            console.log(msg + jqXHR.status + ",statusText: " + jqXHR.statusText+ ",responseText: " + jqXHR.responseText);
	            Message.alert(msg + jqXHR.status + "<br />statusText: " + jqXHR.statusText+ "<br />responseText: " + jqXHR.responseText);
	            
	            if(func){
	        		func(msg);
	        	}
	        }
		});
	}   
    serverExcelDownload(fileName,cmd){
        console.log(cmd);
        var arr_header = {};
        var arr_name = []
        var arr_data = [];
        let _this = this;
        var data = _this.grid.getColumns();
        for(var i=0;i<data.length;i++){
            var name = data[i].name;
            var header = data[i].header;
            if(name !=undefined && name !='_ROW_STATUS'){
                arr_header[name] = header
                arr_name.push(name);
            }
        }
        arr_data.push(arr_header);
        var data = _this.grid.getData();
        for (var i=0;i<data.length;i++){
            var rowKey = data[i].rowKey
            var row_data = {}
            for (var j=0;j<arr_name.length;j++){
                var columnName 	= arr_name[j];
                var value 		= _this.grid.getFormattedValue(rowKey, columnName);
                row_data[columnName]=value;
            }
            arr_data.push(row_data);
        }
        console.log(arr_data);
        var param ={
                brRq 		: 'IN_DATA'
                ,brRs 		: ''
                ,IN_DATA	: arr_data
            }
        _this.download(fileName ,param ,cmd);
    }
}