class datetimeRenderer {
  constructor(props) {
      const el = document.createElement('div');
      el.className="tui-grid-cell-content"
      const { format ,source} = props.columnInfo.renderer.options;
      this.format = format;  /*YYYYMMDDHHmmss    이게 풀양식이다.*/
      this.source = source;  /*TIME 초, YYYYMMDD , YYYYMMDDHHmm,  YYYYMMDDHHmmss  */

      this.el = el;
      this.render(props);
      
    }

    getElement() {
      return this.el;
    }

    render(props) {
    /*  날짜관련해서  mement 라이브러리를 설치했다.
var myDate = new Date("2015-06-17 14:24:36");
console.log(moment(myDate).format("YYYY-MM-DD HH:mm:ss"));
console.log("Date: "+moment(myDate).format("YYYY-MM-DD"));
console.log("Year: "+moment(myDate).format("YYYY"));
console.log("Month: "+moment(myDate).format("MM"));
console.log("Month: "+moment(myDate).format("MMMM"));
console.log("Day: "+moment(myDate).format("DD"));
console.log("Day: "+moment(myDate).format("dddd"));
console.log("Time: "+moment(myDate).format("HH:mm")); // Time in24 hour format
console.log("Time: "+moment(myDate).format("hh:mm A"));
   	    */
   	    
   	    
   	    console.log(props.value)
   	    console.log(this.source)
   	    console.log(this.format)
   	        if(this.source=='YYYYMMDDHHmmss'){
	   	      	this.el.innerText = moment(props.value,'YYYYMMDDHHmmss').format(this.format);
	   	      	console.log('a')
   	        } else if(this.source=='YYYYMMDDHHmm'){
				this.el.innerText = moment(props.value,'YYYYMMDDHHmm').format(this.format);
				console.log('b')
   	        } else if(this.source=='YYYYMMDD'){
   	        	this.el.innerText = moment(props.value,'YYYYMMDD').format(this.format);
   	        	console.log('c')
   	        } else if(this.source=='TIME'){
   	        	var tmp = new Date(props.value);
   	        	this.el.innerText = moment(tmp).format(this.format);
   	        	console.log('d')
   	        } else {
   	        	this.el.innerText = props.value;
   	        	console.log('e')
   	        }
     
    }
  }