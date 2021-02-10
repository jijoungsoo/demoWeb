class FileMngr {
//https://nanogallery2.nanostudio.org/
/*https://danielmg.org/demo/java-script/uploader/single-upload*/	
	constructor(pgm_mngr,target_el, p_options) {
		var _this = this;
		this.container = $("#" + pgm_mngr.getId());
		this.up_uploader_el = target_el;
		console.log(this.up_uploader_el)
		this.file_el =null;
		var basic_options = {
			url: "/file_upld?"+csrf_parameterName+"="+csrf_token,
			maxFileSize: 3000000, // 3 Megs
			auto: true,   /*true면 자동 업로드 false 면 수동*/
			queue: false,
			multiple : false,
			/*allowedTypes: 'image/*',*/
    		/*extFilter: ['jpg','jpeg','png','gif'],*/
			onDragEnter: function(){
			  this.addClass('active');
			},
			onDragLeave: function(){
			  this.removeClass('active');
			},
			onInit: function(){
			  // Plugin is ready to use
      		  
			},
			onComplete: function(){
			  // All files in the queue are processed (success or error)
			},
			onNewFile: function(id, file){
			  // When a new file is added using the file selector or the DnD area
			  console.log('onNewFile');
			  console.log('id=>'+id);
			  console.log(file);
			  console.log('file=>'+file);
			  
			  
		      if (typeof FileReader !== "undefined"){
		        var reader = new FileReader();
		        var img = this.find('img');
		        
		        reader.onload = function (e) {
		        //  img.attr('src', e.target.result);
		        }
		        reader.readAsDataURL(file);
		      }
			  
			  
			},
			onBeforeUpload: function(id){
			  // about tho start uploading a file
			},
			onUploadProgress: function(id, percent){
			  // Updating file progress
			  
			},
			onUploadSuccess: function(id, data){
			  // A file was successfully uploaded
			  console.log('onUploadSuccess')
			  console.log(id)
			  console.log(data)
			  
			},
			onUploadError: function(id, xhr, status, message){
			  // Happens when an upload error happens
			  alert('onUploadError');
			},
			onFallbackMode: function(){
			  // When the browser doesn't support this plugin :(
			  alert('onFallbackMode');

			},
			onFileSizeError: function(file){
				alert('onFileSizeError');
			},
			onUploadCanceled: function(file){
				alert('onUploadCanceled');
			},
			onFileTypeError: function(file){
				alert('onFileTypeError');
			},
			onFileSizeError: function(file){
				alert('onFileSizeError');
			},
			onFileExtError: function(file){
				alert('onFileExtError');
			}
		};
      	this.options = $.extend(basic_options, p_options);
	}
	build(){
		console.log(this.options);
		$(this.up_uploader_el).dmUploader(this.options);	 
	}
	start(){
		alert('start');
		$(this.up_uploader_el).dmUploader('start');
	}
	cancel(){
		$(this.up_uploader_el).dmUploader('cancel');
	}
	static download(FILE_ID) {
		let _this = this;
		var req_url = '/file_dwn/'+	FILE_ID;
	    $.ajax({
	        url: req_url,
	        method: 'GET',
	        xhrFields: {
	            responseType: 'arraybuffer'
	        },
			beforeSend : function(xhr)   /*이거 동작한다.  -- https://hyunsangwon93.tistory.com/28*/
	        { 
				xhr.setRequestHeader(csrf_headerName, csrf_token);
	        },
	        data: []
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
	    });
	}
	static delete(data,func) {
		let _this = this;
		var req_url = '/file_del';
		var param ={
			brRq : 'IN_DATA'
			,brRs : ''
			,IN_DATA: data
		}
		        	
	    $.ajax({
	        url: req_url,
	        method: 'POST',
	        contentType: "application/json; charset=utf-8",
	        accept: "application/json",
			beforeSend : function(xhr)
	        { 
				xhr.setRequestHeader(csrf_headerName, csrf_token);
	        },
	        data: JSON.stringify(param),
	        dataType: "json",
	    }).done(function(data, textStatus, jqXhr) {
	        if (!data) {
	            return;
	        }
	        func();
	    });
	}
	static getFileName (contentDisposition) {
	    var fileName = contentDisposition
	        .split(';')
	        .filter(function(ele) {
	            return ele.indexOf('filename') > -1
	        })
	        .map(function(ele) {
	            return ele
	                .replace(/"/g, '')
	                .split('=')[1]
	        });
	    return fileName[0] ? fileName[0] : null
	}
}