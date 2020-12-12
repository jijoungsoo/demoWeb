class datetimeRenderer {
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
   	    if(props.value!=''){
           	var yyyy  = ('0000'+( (new Date(props.value)).getFullYear())).substr(-4,4);
           	var mm = ('00'+( (new Date(props.value)).getMonth()+1 )).substr(-2,2);
           	var dd   = ('00'+( (new Date(props.value)).getDate() )).substr(-2,2);
           	var hh24   = ('00'+( (new Date(props.value)).getHours() )).substr(-2,2);
           	var mi   = ('00'+( (new Date(props.value)).getMinutes() )).substr(-2,2);
           	var ss   = ('00'+( (new Date(props.value)).getSeconds() )).substr(-2,2);
			var yyyymmddhh24miss  = (yyyy+'-'+mm+'-'+dd+' '+hh24+':'+mi+':'+ss);
			this.el.innerText = yyyymmddhh24miss;
		}  else {
			this.el.innerText = '';
		}
        
    }
  }