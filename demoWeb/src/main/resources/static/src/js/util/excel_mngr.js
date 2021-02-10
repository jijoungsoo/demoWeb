class ExcelMngr {
	static saveExcel(file_id,func) {
		var req_url = '/EXCEL_CREATE_DATA';
	    $.ajax({
	        url: req_url,
	        method: 'POST',
			beforeSend : function(xhr)   /*이거 동작한다.  -- https://hyunsangwon93.tistory.com/28*/
	        { 
				xhr.setRequestHeader(csrf_headerName, csrf_token);
	        },
	        data: {
	        	FILE_ID	: file_id
	        }
	    }).done(function(data, textStatus, jqXhr) {
	        if (!data) {
	            return;
	        }
	        
	        if(func){
	        	func(data);
	        }
	    });
	}
	static downExcel(br,p_param,func){
		 var req_url = '/EXCEL_DWNLD/'+br;
		 $.ajax({
		        url: req_url,
		        method: 'POST',
		       	contentType: "application/json; charset=utf-8",
	        	accept: "application/json",
	        	xhrFields: {
	            	responseType: 'arraybuffer'
	        	},
				beforeSend : function(xhr)   /*이거 동작한다.  -- https://hyunsangwon93.tistory.com/28*/
		        { 
					xhr.setRequestHeader(csrf_headerName, csrf_token);
		        },
		        data: JSON.stringify(p_param) //이게 포인트 였다
		    }).done(function(data, textStatus, jqXhr) {
		        if (!data) {
		            return;
		        }
		        try {
		            var blob = new Blob([data], { type: jqXhr.getResponseHeader('content-type') });
		            var fileName = FileMngr.getFileName(jqXhr.getResponseHeader('content-disposition'));
		            fileName = decodeURI(fileName);
		 
		            if (window.navigator.msSaveOrOpenBlob) { // IE 10+
		                window.navigator.msSaveOrOpenBlob(blob, fileName);
		            } else { // not IE
		                var link = document.createElement('a');
		                var url = window.URL.createObjectURL(blob);
		                link.href = url;
		                link.target = '_self';
		                if (fileName) link.download = fileName;
		                document.body.append(link);
		                link.click();
		                link.remove();
		                window.URL.revokeObjectURL(url);
		            }
		        } catch (e) {
		            console.error(e)
		        }
		        
		        if(func){
		        	func(data);
		        }
		    }).fail(function (jqXHR, textStatus) {
		        console.log(jqXHR)
		        console.log(textStatus)
		        if (textStatus == "error") {
		            var msg = "Sorry but there was an error: ";
		            console.log(msg + jqXHR.status + ",statusText: " + jqXHR.statusText+ ",responseText: " + jqXHR.responseText);
		            Message.alert(msg + jqXHR.status + "<br />statusText: " + jqXHR.statusText+ "<br />responseText: " + jqXHR.responseText);
		            
		            if(func){
		        		func(msg);
		        	}
		        }
	    });   
		
	}
}