class TuiGridMngr {
  constructor(pgm_mngr, grid_name, columns, p_options) {

      var basic_options = {
        editable: false
        ,scrollX: false
        ,scrollY: false
        ,width: 1100               /*그리드 너비 조절 */
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
        ,columnOptions: {
          resizable: true,
          frozenCount: 1,
          frozenBorderWidth: 2,
          minWidth: 20
        }
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
    let grid=this.grid;    
    let options = this.options;
    grid.clear();
    AjaxMngr.send_post_ajax(url, param, function (data) {

      console.log('loadData')
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
      p_func(data);
    })
  }
   
  getCheckedData() {
    return this.grid.getCheckedRows();
  }
  
  getModifiedRows() {
    return this.grid.getModifiedRows();
  }
  validate() {
    return this.grid.validate();
  }
  appendRow() {
    //column 값을 읽어와서 하나짜리 row를 만들어야한다.
    var t  = this.grid.getColumns();
    var tmp={};
    this.grid.appendRow(tmp);
  }
}