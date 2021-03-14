<% String uuid = (String) request.getAttribute("uuid"); %>
<script>
$(document).ready(function(){
	var AV_1200 = new PgmPageMngr ('<%=uuid%>');
	AV_1200.init(function(p_param) {
		var searchForm;
		var grid_arr_data_msc_cd = [];
		var search_arr_data_msc_cd = [];
		var grid_arr_data_cptn_yn = [];
		var grid_arr_data_vr_yn = [];
		var search_arr_data_vr_yn = [];
		var grid ;

		var _this = AV_1200;
		searchForm = new FormMngr(_this, "search_area");
		searchForm.initCombo("MSC_CD",'BR_CM_CD_FIND', {brRq: 'IN_DATA',brRs: 'OUT_DATA',IN_DATA: [{  GRP_CD : 'MSC_CD', USE_YN: 'Y'}]},{ USE_EMPTY_YN : 'Y' , VALUE :'CD' , TEXT :'CD_NM' });
		searchForm.initCombo("VR_YN",'BR_CM_CD_FIND', {brRq: 'IN_DATA',brRs: 'OUT_DATA',IN_DATA: [{  GRP_CD : 'VR_YN', USE_YN: 'Y'}]},{ USE_EMPTY_YN : 'Y' , VALUE :'CD' , TEXT :'CD_NM' });
		searchForm.setData("MSC_CD","");
		searchForm.setData("VR_YN","");
		var up_uploader_el = _this.get("excel_upld")
		var fileMngr = new FileMngr(_this,up_uploader_el,{
		    extFilter: ['xls','xlsx'],
			onBeforeUpload: function(id){
			  _this.showProgress();
			},
			onFileExtError: function(file){
				console.log(file);
				Message.alert("xls,xlsx 확장자만 업로드 가능합니다.");
		        return;
				
			},
			onUploadSuccess: function(id, data){
				_this.hideProgress();
				Message.confirm('xls,xlsx파일이 업로드 되었습니다. 엑셀 데이터를 반영하시겠습니까?',function()  {
					console.log('aaaa');
					console.log(data);
					if(data.length>0){
			        	var file_id = data[0].fileId;
			        	_this.showProgress();
			        	ExcelMngr.saveExcel(file_id, function(data2) {
							if (data2) {
								var param = {
										brRq : 'IN_DATA',
										brRs : 'OUT_DATA',
										IN_DATA : [ { FILE_ID : file_id } ]
								}
								_this.send('BR_AV_MV_EXCEL_SAVE', param, function(data) {
									if (data) {
									}
								});
							
								_this.hideProgress();
								searchForm.get("search").trigger("click");
							}
						});
			        }	
				});
			}
		});
		fileMngr.build();
		
		
		grid = new TuiGridMngr(_this,'grid',{
		      editable: true
		      ,showRowStatus: true
		      ,rowNum: true
		      ,checkbox: true      
		      ,pageable : true
			  ,pageSize : 300
		  	}
		,[
			{
		           header: 'AV_SEQ',
		           name: 'AV_SEQ',
		           width: 60,
		           resizable: false,
		           sortable: true,
				   align : "right",
		           sortingType: 'desc'
			  }, {
			           header: '좋아요',
			           width : 60,
			           name: 'LK_CNT',
					   align: "center"
					}, {
			           header: '싫어요',
			           width : 60,
			           name: 'DSLK_CNT',
					   align: "center"
			},{     
					header : '모자이크상태',
					name : 'MSC_CD',
					width : 100,
					sortable : true,
					align : "center",
					sortingType : 'desc', /*내림차순   ctrl 키를 누르고 정렬키를 여러개 누르면 이어서 정렬이 된다.*/
					type : "combo",
					comboData : _this.getComboData('BR_CM_CD_FIND', {brRq: 'IN_DATA',brRs: 'OUT_DATA',IN_DATA: [{  GRP_CD : 'MSC_CD', USE_YN: 'Y'}]},{ USE_EMPTY_YN : 'Y' , VALUE :'CD' , TEXT :'CD_NM' }),
		            validation: {
		             dataType: 'string',  /*string ,number*/
		             required: true,    /*  true 필수, false 필수아님  */
		             unique: false   /*true 데이터가 중복되면 빨간색 표시 */
		           	}
				},{     
					header : 'VR여부',
					name : 'VR_YN',
					width : 100,
					sortable : true,
					align : "center",
					sortingType : 'desc', /*내림차순   ctrl 키를 누르고 정렬키를 여러개 누르면 이어서 정렬이 된다.*/
					type : "combo",
					comboData : _this.getComboData('BR_CM_CD_FIND', {brRq: 'IN_DATA',brRs: 'OUT_DATA',IN_DATA: [{  GRP_CD : 'VR_YN', USE_YN: 'Y'}]},{ USE_EMPTY_YN : 'Y' , VALUE :'CD' , TEXT :'CD_NM' }),
		            validation: {
		             dataType: 'string',  /*string ,number*/
		             required: false,    /*  true 필수, false 필수아님  */
		             unique: false   /*true 데이터가 중복되면 빨간색 표시 */
		           	}
		       }, {
		           header: '품번',
		           name: 'AV_NM',
		           width: 400,
		           resizable: false,
		           sortable: true,
		           sortingType: 'desc',
		           editor: 'text'
		         },{
		           header: '자막',
		           width: 60,
		           name: 'CPTN_YN',
				   type : "combo",
				   align: "center",
				   comboData : _this.getComboData('BR_CM_CD_FIND', {brRq: 'IN_DATA',brRs: 'OUT_DATA',IN_DATA: [{  GRP_CD : 'CPTN_YN', USE_YN: 'Y'}]},{ USE_EMPTY_YN : 'Y' , VALUE :'CD' , TEXT :'CD_NM' }),
                   validation: {
		             dataType: 'string',
		             required: true,
		             unique: false
		           	}
		         },{
				    header: '출시일',
				    name: 'MK_DT',
				    renderer : {
						type: datetimeRenderer,
						options : {
							format : 'yyyy-MM-DD',
							source : 'YYYYMMDD'
						}
					},
					width : 120,
				    editor: {
				      type: 'datePicker',
				      options: {
				        format: 'yyyyMMdd',
				        timepicker: false,
				        language: 'ko',
				        usageStatistics: false
				      }
				    }
		         },{  
		           header: '제목',
		           name: 'TTL',
		           width: 200,
		           sortable: true,
		           editor: 'text'
		         },
		         {
		           header: '내용',
		           name: 'CNTNT',
		           width: 200,
		           sortable: true,
		           align: "center"
		       
		         }, {
						header : '정렬',
						name : 'ORD',
						width : 100,
						sortable : true,
						align : "center",
						sortingType : 'desc',
						editor : 'text'
				}, {
		           header: '비고',
		           name: 'RMK',
		           editor: 'text'
		         }, {
		             header: '생성일',
		             name: 'CRT_DTM',
		             width: 140,
		             sortable: true,
		             align: "center"
		         }, {
		             header: '수정일',
		             name: 'UPDT_DTM',
		             width: 140,
		             sortable: true,
		             align: "center" 
		         }
		    ]
		);
	  	grid.build();

		grid.on('click', (ev) => {
			if (ev.rowKey >=0) {
				var row_data=grid.getRow(ev.rowKey);
				console.log(row_data);

				var param = {
					AV_SEQ: row_data.AV_SEQ
				}
				var popup = new PopupManger(_this, 'AV_1210', {
						width: 1100,
						height: 900,
						title: "AV작품상세"
					},
					param
				);
				popup.open(function (data) {
					if (data) {

					}
				});
				
			}
		});

	  	searchForm.addEvent("click","input[type=button]",function(el){
		   //console.log(el);
	  	   switch(el.target.name){
           case 'search':
			   var data = searchForm.getData();
        		var param ={
					 brRq : 'IN_DATA'
					,brRs : 'OUT_DATA'
					,IN_DATA:[ data ]
				}
		    	grid.loadData('BR_AV_MV_FIND',param,function(data){
			    	console.log(data);
			    	//gridLoadData에서 자동으로 로드됨..
		        	
		    	});
               break;
           case 'add_row':
        	   Message.confirm('행을 추가하시겠습니까?',function()  {
		        	grid.appendRow();
				});
               break;
	  		
	  		case 'save':
	  		    var data = grid.getModifiedRows();
		        console.log(data);
		        var crt_cnt	= data.createdRows.length;
		        var updt_cnt= data.updatedRows.length;

		        
		        if((crt_cnt+updt_cnt)==0) {
		        	Message.alert("저장할 내용이 존재하지 않습니다.");
		        	return;
			    }
		        if(grid.isValid()==false) {
		        	grid.validMsg();    
		        	return;
			    }
			    	        
		    	Message.confirm('저장하시겠습니까?',function()  {
		    		var param ={
						brRq 		: 'IN_DATA,UPDT_DATA'
						,brRs 		: ''
						,IN_DATA	: data.createdRows
		    			,UPDT_DATA	: data.updatedRows
					}
		    		_this.showProgress();					
		    		_this.send('BR_AV_MV_SAVE',param,function(data){
		    			_this.hideProgress();
		    			if(data){
		    				Message.alert('저장되었습니다.',function()  {
				        		searchForm.get("search").trigger("click");
				        	});
			    		}
		        		
			        });
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
			        var param ={
						brRq : 'IN_DATA'
						,brRs : ''
						,IN_DATA: data
					}
		        	_this.showProgress();
			        _this.send('BR_AV_MV_RM',param,function(data){
			        	_this.hideProgress();
			        	if(data){
			        		Message.alert('삭제되었습니다.',function()  {
				        		searchForm.get("search").trigger("click");
				        	});
				        }
			        	
			        });
				});
		  		break;
		  	case "excel_dwnld":
			  var data = searchForm.getData();
		  		var param ={
						brRq 		: 'IN_DATA'
						,brRs 		: 'OUT_DATA'
						,IN_DATA	: [ data ]
				}
		  		ExcelMngr.downExcel('BR_AV_MV_EXCEL_DWNLD',
		  		param,
		  		function(data){
		  			
		  		});
	  			break;
	  	   }
	  	});
	  	searchForm.get("search").trigger("click");
	});	
});

</script>