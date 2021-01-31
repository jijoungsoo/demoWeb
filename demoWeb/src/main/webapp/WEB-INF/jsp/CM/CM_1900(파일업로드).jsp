<%
	String pgmId = (String) request.getAttribute("pgmId");
	String uuid = (String) request.getAttribute("uuid");
%>
<script>
$(document).ready(function(){
	var CM_1900 = new PgmPageMngr ('<%=pgmId%>', '<%=uuid%>');
		CM_1900.init(function(p_param) {
			var _this = CM_1900;
			var API_SERVER = "/";
	        var DIALOG = new ax5.ui.dialog({
	            title: "AX5UI"
	        });
	        var div_el = _this.getEl()[0];
	        var up_uploader_el = div_el.querySelector('[data-ax5uploader="upload1"]')
	        var up_uploaded_box_el = div_el.querySelector('[data-uploaded-box="upload1"]')
	        var UPLOAD = new ax5.ui.uploader({
	            //debug: true,
	            target: $(up_uploader_el),
	            form: {
	                action: API_SERVER + "/excel_upld",
	                fileName: "uploadFile"
	            },
	            multiple: false,
	            manualUpload: false,
	            progressBox: true,
	            progressBoxDirection: "left",
	            dropZone: {
	                target: $(up_uploaded_box_el)
	            },
	            uploadedBox: {
	                target: $(up_uploaded_box_el),
	                icon: {
	                    "download": '<i class="fa fa-download" aria-hidden="true"></i>',
	                    "delete": '<i class="fa fa-minus-circle" aria-hidden="true"></i>'
	                },
	                columnKeys: {
	                    name: "fileName",
	                    type: "ext",
	                    size: "fileSize",
	                    uploadedName: "saveName",
	                    uploadedPath: "",
	                    downloadPath: "",
	                    previewPath: "",
	                    thumbnail: ""
	                },
	                lang: {
	                    supportedHTML5_emptyListMsg: '<div class="text-center" style="padding-top: 30px;">Drop files here or click to upload.</div>',
	                    emptyListMsg: '<div class="text-center" style="padding-top: 30px;">Empty of List.</div>'
	                },
	                onchange: function () {
	 
	                },
	                onclick: function () {
	                    // console.log(this.cellType);
	                    var fileIndex = this.fileIndex;
	                    var file = this.uploadedFiles[fileIndex];
	                    switch (this.cellType) {
	                        case "delete":
	                            DIALOG.confirm({
	                                title: "AX5UI",
	                                msg: "Are you sure you want to delete it?"
	                            }, function () {
	                                if (this.key == "ok") {
	                                    $.ajax({
	                                        contentType: "application/json",
	                                        method: "post",
	                                        url: API_SERVER + "/api/v1/ax5uploader/delete",
	                                        data: JSON.stringify([{
	                                            id: file.id
	                                        }]),
	                                        success: function (res) {
	                                            if (res.error) {
	                                                alert(res.error.message);
	                                                return;
	                                            }
	                                            UPLOAD.removeFile(fileIndex);
	                                        }
	                                    });
	                                }
	                            });
	                            break;
	 
	                        case "download":
	                            if (file.download) {
	                                location.href = API_SERVER + file.download;
	                            }
	                            break;
	                    }
	                }
	            },
	            validateSelectedFiles: function () {
	                console.log(this);
	                // 10개 이상 업로드 되지 않도록 제한.
	                if (this.uploadedFiles.length + this.selectedFiles.length > 10) {
	                    alert("You can not upload more than 10 files.");
	                    return false;
	                }
	 
	                return true;
	            },
	            onprogress: function () {
	 
	            },
	            onuploaderror: function () {
	                console.log(this.error);
	                DIALOG.alert(this.error.message);
	            },
	            onuploaded: function () {
	 
	            },
	            onuploadComplete: function () {
	 
	            }
	        });
	 
	        // 파일 목록 가져오기
	        $.ajax({
	            method: "GET",
	            url: API_SERVER + "/api/v1/ax5uploader",
	            success: function (res) {
	 
	                console.log(res);
	                UPLOAD.setUploadedFiles(res);
	            }
	        });
	 
	        // 컨트롤 버튼 이벤트 제어
	        $('[data-btn-wrap]').clickAttr(this, "data-upload-btn", {
	            "getUploadedFiles": function () {
	                var files = ax5.util.deepCopy(UPLOAD.uploadedFiles);
	                console.log(files);
	                DIALOG.alert(JSON.stringify(files));
	            },
	            "removeFileAll": function () {
	 
	                DIALOG.confirm({
	                    title: "AX5UI",
	                    msg: "Are you sure you want to delete it?"
	                }, function () {
	 
	                    if (this.key == "ok") {
	 
	                        var deleteFiles = [];
	                        UPLOAD.uploadedFiles.forEach(function (f) {
	                            deleteFiles.push({id: f.id});
	                        });
	 
	                        $.ajax({
	                            contentType: "application/json",
	                            method: "post",
	                            url: API_SERVER + "/api/v1/ax5uploader/delete",
	                            data: JSON.stringify(deleteFiles),
	                            success: function (res) {
	                                if (res.error) {
	                                    alert(res.error.message);
	                                    return;
	                                }
	                                UPLOAD.removeFileAll();
	                            }
	                        });
	                    }
	                });
	            }
	        });
		});
	});
</script>