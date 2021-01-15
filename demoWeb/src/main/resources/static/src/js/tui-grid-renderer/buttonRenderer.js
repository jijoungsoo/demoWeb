class buttonRenderer {
  constructor(props) {
      const el = document.createElement('button');
      const { txt ,fn } = props.columnInfo.renderer.options;
      this.txt =txt;
      el.className="tui-grid-cell-content"
      this.el = el;
      this.fn = fn;
      this.render(props);
      
  }
  
     getElement() {
      return this.el;
    }

    render(props) {
        this.el.innerText = this.txt;
        if(this.fn!=undefined){
        	this.fn(this.el,props);
        }
      
    }
}