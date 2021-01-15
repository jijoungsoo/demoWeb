class commaStRenderer {
  constructor(props) {
      const el = document.createElement('div');
      el.className="tui-grid-cell-content"
      const { src ,tgt } = props.columnInfo.renderer.options;
      this.el = el;
      this.src = src;
      this.tgt = tgt;
      this.render(props);
      
    }

    getElement() {
      return this.el;
    }

    render(props) {
   	    if(props.value){
   	     	var row_data=props.grid.getRow(props.rowKey);
			var src_amt = row_data[this.src];
			var tgt_amt = row_data[this.tgt];
			
   	    	var tmp=String(props.value);
            var tmp2 = PjtUtil.numberComma(tmp);
            this.el.innerText = tmp2;
            
            if(src_amt<tgt_amt){
            	this.el.style="color:#f10808";
            } else if(src_amt>tgt_amt){
            	this.el.style="color:#0080ff";
            } 
		}  else {
			this.el.innerText = props.value;
		}	
    }
  }