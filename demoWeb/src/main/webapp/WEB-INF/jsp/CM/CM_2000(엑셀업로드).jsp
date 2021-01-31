
<%
String pgmId = (String) request.getAttribute("pgmId");
String uuid = (String) request.getAttribute("uuid");
%>
<script>
$(document).ready(function(){
	var CM_2000 = new PgmPageMngr ('<%=pgmId%>', '<%=uuid%>');
		CM_2000.init(function(p_param) {
			var _this = CM_2000;
	        var div_el = _this.getEl()[0];
	        const up_uploader_el = div_el.querySelector('#drag-and-drop-zone');
			$(up_uploader_el).dmUploader({
				url: "/excel_upld?${_csrf.parameterName}=${_csrf.token}",
				maxFileSize: 3000000, // 3 Megs
				extFilter: ["xls"], 
				auto: false,
    			queue: true,
    			multiple : false, 
				onDragEnter: function(){
				  this.addClass('active');
				},
				onDragLeave: function(){
				  this.removeClass('active');
				},
				onInit: function(){
				  // Plugin is ready to use
				  ui_add_log( div_el,'Penguin initialized :)', 'info');
				},
				onComplete: function(){
				  // All files in the queue are processed (success or error)
				  alert('onComplete');
				  ui_add_log(div_el,'All pending tranfers finished');
				},
				onNewFile: function(id, file){
				  // When a new file is added using the file selector or the DnD area
				  console.log('onNewFile');
				  console.log('id=>'+id);
				  console.log('file=>'+file);
				  ui_add_log(div_el,'New file added #' + id);
				  ui_multi_add_file(div_el,id, file);
				},
				onBeforeUpload: function(id){
				  // about tho start uploading a file
				  alert('onBeforeUpload');
				  ui_add_log(div_el,'Starting the upload of #' + id);
				  ui_multi_update_file_progress(div_el,id, 0, '', true);
				  ui_multi_update_file_status(div_el,id, 'uploading', 'Uploading...');
				},
				onUploadProgress: function(id, percent){
				  // Updating file progress
				  alert('onUploadProgress');
				  ui_multi_update_file_progress(div_el,id, percent);
				},
				onUploadSuccess: function(id, data){
				  // A file was successfully uploaded
				  alert('onUploadSuccess');
				  ui_add_log(div_el,'Server Response for file #' + id + ': ' + JSON.stringify(data));
				  ui_add_log(div_el,'Upload of file #' + id + ' COMPLETED', 'success');
				  ui_multi_update_file_status(div_el, 'success', 'Upload Complete');
				  ui_multi_update_file_progress(div_el,id, 100, 'success', false);
				},
				onUploadError: function(id, xhr, status, message){
				  // Happens when an upload error happens
				  alert('onUploadError');
				  ui_multi_update_file_status(div_el,id, 'danger', message);
				  ui_multi_update_file_progress(div_el,id, 0, 'danger', false);  
				},
				onFallbackMode: function(){
				  // When the browser doesn't support this plugin :(
				  alert('onFallbackMode');
				  ui_add_log(div_el,'Plugin cant be used here, running Fallback callback', 'danger');
				},
				onFileSizeError: function(file){
					alert('onFileSizeError');
      				ui_add_log('File \'' + file.name + '\' cannot be added: size excess limit', 'danger');
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
			});	 
			$(div_el.querySelector('#btnApiStart')).on('click', function(evt){
			  evt.preventDefault();
			  $(up_uploader_el).dmUploader('start');
			});
			
			$(div_el.querySelector('#btnApiCancel')).on('click', function(evt){
			  evt.preventDefault();
			  $(up_uploader_el).dmUploader('cancel');
			});
		});
	});
</script>