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
               if(!isNaN(props.value)){
                var tmp =  new Date(Number(props.value)) ;
                var yyyy  = ('0000'+( tmp.getFullYear())).substr(-4,4);
                console.log(yyyy);
                var mm = ('00'+( tmp.getMonth()+1 )).substr(-2,2);
                console.log(mm);
                var dd   = ('00'+( tmp.getDate() )).substr(-2,2);
                console.log(dd);
                var yyyymmdd  = (yyyy+'-'+mm+'-'+dd);
               }
            
		}    	
        this.el.innerText = yyyymmdd;
    }
  }