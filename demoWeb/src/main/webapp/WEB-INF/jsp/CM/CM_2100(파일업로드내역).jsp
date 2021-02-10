<%	String pgmId = (String) request.getAttribute("pgmId");
	String uuid = (String) request.getAttribute("uuid");
%>
<script>
$(document).ready(function(){
	var CM_2100 = new PgmPageMngr ('<%=pgmId%>', '<%=uuid%>');
	CM_2100.init(function(p_param) {
		var _this = CM_2100;
		var fileMngr = new FileMngr(_this,{
			onBeforeUpload: function(id){
			  _this.showProgress();
			}
			,onUploadSuccess: function(id, data){
				_this.hideProgress();
				Message.alert('업로드되었습니다.',function()  {
					searchForm.get("search").trigger("click");
				});
			}
		});
		fileMngr.build();
		
		var searchForm = new FormMngr(_this, "search_area");
		const grid = new TuiGridMngr(_this,'grid',{
		      editable: false
		      ,showRowStatus: false
		      ,rowNum: true
		      ,checkbox: true      
		  	}
		,[
			{
		           header: 'FILE_ID',
		           name: 'FILE_ID',
		           width: 100,
		           resizable: false,
		           sortable: true,
		           sortingType: 'desc' /*내림차순   ctrl 키를 누르고 정렬키를 여러개 누르면 이어서 정렬이 된다.*/
		         },
		       {
		           header: 'FILE_GROUP',
		           name: 'FILE_GROUP',
		           width: 300
		         },
		         {
		           header: '원파일명',
		           name: 'ORG_FILE_NM',
		           width: 200
		         }, {
		         	        
		           header: '확장자',
		           name: 'EXT',
		           width: 100,
		           align: "center"
		         }, {
		         	        
		           header: '컨텐츠타입',
		           name: 'CONTENT_TYPE',
		           width: 100,
		           align: "center"
		         }, {
		           header: '서버파일경로',
		           name: 'SVR_DIR_PATH',
		           width: 100,
		           align: "center"
		         }, {
		           header: '파일크기',
		           name: 'FILE_SIZE',
		           width: 100,
		           align: "center"
		         }, {
		           header: '서버파일명',
		           name: 'SVR_FILE_NM',
				   width: 300,
		           align: "center"
				}, {	
				header : '다운받기',
				renderer : {
					type: buttonRenderer,
					options : {
						txt : '다운받기',
						fn  : function(row_data) {
							var FILE_ID = row_data.FILE_ID;
							FileMngr.download(FILE_ID);
						}
					}
				},
				width : 100,
				sortable : true,
				align : "center"
				
			}, {
		             header: '파일상태',
		             name: 'FILE_STATUS_CD',
		             width: 140,
		             sortable: true,
		             align: "center"
		         },{
		             header: '이미지',
		              renderer : {
						type: imageRenderer,
						options : {
							format : 'yyyy-MM-DD',
							source : 'YYYYMMDD'
						}
					},
		             width: 140,
		             sortable: true,
		             align: "center"
		         },{
		             header: '생성일',
		             name: 'CRT_DTM',
		             width: 140,
		             sortable: true,
		             align: "center"
		         },{
		             header: '생성자번호',
		             name: 'CRT_USR_NO',
		             width: 140,
		             sortable: true,
		             align: "center" 
		         }
		    ]
		);
	  	grid.build();
	  	/*
	  	grid.on('click', (ev) => {
			if (ev.rowKey >=0) {
				if(ev.columnName=="BTN_DOWN"){
					var row_data=grid.getRow(ev.rowKey);
					var FILE_ID = row_data.FILE_ID;
					FileMngr.download(FILE_ID)
				}	
			}
		});
		*/

	  	searchForm.addEvent("click","input[type=button]",function(el){
		   //console.log(el);
	  	   switch(el.target.name){
           case 'search':
        		var param ={
					 brRq : ''
					,brRs : 'OUT_DATA'
					,IN_DATA:[{}]
				}
		    	grid.loadData('BR_CM_FILE_FIND',param,function(data){
			    	console.log(data);
			    	//gridLoadData에서 자동으로 로드됨..
		    	});
               break;
	  		case "del":
	  			var data = grid.getCheckedData();
		        console.log(data);
		        if(data.length<=0) {
		        	Message.alert('선택된 항목이 없습니다.');
		        	return;
		        }

		        Message.confirm('삭제하시겠습니까?',function()  {
		        	_this.showProgress();
		        	FileMngr.delete(data,function(){
		        		_this.hideProgress();
		        		Message.alert('삭제되었습니다.',function()  {
		        			searchForm.get("search").trigger("click");
		        		});
		        		
		        	});
			    });
		        break;
	  	   }
	  	});
	  	searchForm.get("search").trigger("click");
	});	
});

</script>