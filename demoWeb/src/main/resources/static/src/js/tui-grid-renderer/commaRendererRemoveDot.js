class commaRendererRemoveDot  {
  constructor(props) {
      const el = document.createElement('div');
      el.className="tui-grid-cell-content"
      this.el = el;
      this.render(props);
    }

    getElement() {
      return this.el;
    }

    render(props) {
   	    if(props.value){
   	    	var tmp=String(props.value);
            var tmp2 = PjtUtil.numberCommaRemoveDot(tmp);
            this.el.innerText = tmp2;
		}  else {
			this.el.innerText = props.value;
		}	
    }
  }