class buttonRenderer {
  constructor(props) {
      const el = document.createElement('button');
      const { txt } = props.columnInfo.renderer.options;
      this.txt =txt;
      el.className="tui-grid-cell-content"
      this.el = el;
      this.render(props);
  }
  
     getElement() {
      return this.el;
    }

    render(props) {
        this.el.innerText = this.txt;
    }
}