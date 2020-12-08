class dateRenderer {
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
           	var yyyy  = ('0000'+( (new Date(props.value)).getFullYear())).substr(-4,4);
           	var mm = ('00'+( (new Date(props.value)).getMonth()+1 )).substr(-2,2);
           	var dd   = ('00'+( (new Date(props.value)).getDate() )).substr(-2,2);
			var yyyymmdd  = (yyyy+'-'+mm+'-'+dd);
		}    	
        this.el.innerText = yyyymmdd;
    }
  }