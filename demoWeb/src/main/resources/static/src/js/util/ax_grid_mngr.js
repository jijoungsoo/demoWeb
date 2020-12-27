class AxGridMngr {
  constructor(pgm_mngr, grid_name, columns, p_options) {
	  this.pgm_mngr=pgm_mngr;
      var basic_options = {
         	frozenColumnIndex: 2,
		    frozenRowIndex: 0,
		    showLineNumber: true,
		    showRowSelector: true,
		    multipleSelect: false,
		    lineNumberColumnWidth: 40,
		    rowSelectorColumnWidth: 28,
		    sortable: true, 
		    multiSort: false,
      };
      this.options.target= pgm_mngr.get(grid_name)[0] /*타켓대상*/
      this.options.columns= o_columns;
      this.body = []
  }
  build()  {
    var tmp =this.options;
    const grid = new ax5.ui.grid();
    tmp.body = this.body
    grid.setConfig(tmp)
    this.grid=grid;
  }
  
  on(event_name,func){
  	if(event_name==='click') {
  		this.body.push({ onClick: func  })
  	}
  	
  	if(event_name==='dbClick') {
  		this.body.push({ dbClick:  func  })
  	}
  	
  	if(event_name==='onDataChanged') {
  		this.body.push({ dbClick:  func  })
  	}
  	
  }
   
  loadData(url,param, p_func){
    var mask = new ax5.ui.mask();
	mask.open({
		content: '<h1><i class="fa fa-spinner fa-spin"></i> Loading</h1>'
		,target: $("#"+this.pgm_mngr.getId()).get(0),
	});
    let grid=this.grid;    
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
	    grid.setData(data[brRs]);
      }
      mask.close();
      if(p_func){
    	p_func(data);
    	}
    })
  }
  resetData(data){
  	this.grid.setData(data);
  }
   
  getCheckedData() {
    return this.grid.getList("selected");
  }
  
  getModifiedRows() {
  	//ax5Grid.getList();
	//ax5Grid.getList("selected");
	//ax5Grid.getList("modified");
	//ax5Grid.getList("deleted");
    return this.grid.getList("modified");
  }
  appendRow() {
    //this.grid.addRow($.extend({}, grid.list[Math.floor(Math.random() * grid.list.length)], {__index: undefined}));
    this.grid.addRow($.extend({}, {}, {__index: undefined}),"last");
  }

  clear(){
  	//clear함수가 따로 없다
  	//this.grid.clear(); 
  	this.grid.setData({})
  	
  }
}