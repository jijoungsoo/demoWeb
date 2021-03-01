
<% String uuid = (String) request.getAttribute("uuid"); %>
<script>
$(document).ready(function(){
	var AV_1100 = new PgmPageMngr ('<%=uuid%>');
	AV_1100.init(function(p_param) {
		var _this = AV_1100;
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
								_this.send('BR_AV_ACTR_EXCEL_SAVE', param, function(data) {
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
		
		var searchForm = new FormMngr(_this, "search_area");
		var param = {
				brRq : 'IN_DATA',
				brRs : 'OUT_DATA',
				IN_DATA : [ { GRP_CD : 'MSC_YN'
					,USE_YN : 'Y' } ]
		}
		//콤보박스 세팅
		var grid_arr_data_msc_yn = []
		_this.send_sync('BR_CM_CD_FIND', param, function(data) {
			if (data) {
				console.log(data.OUT_DATA);
				if(data.OUT_DATA){
					for(var i =0;i<data.OUT_DATA.length;i++){
						var tmp =data.OUT_DATA[i];
						grid_arr_data_msc_yn.push({ value: tmp.CD , text: tmp.CD_NM  })
					}
				}
			}
		});
		
		var param = {
				brRq : 'IN_DATA',
				brRs : 'OUT_DATA',
				IN_DATA : [ { GRP_CD : 'SEX'
					,USE_YN : 'Y' } ]
		}
		//콤보박스 세팅
		var grid_arr_data_sex = []
		_this.send_sync('BR_CM_CD_FIND', param, function(data) {
			if (data) {
				console.log(data.OUT_DATA);
				if(data.OUT_DATA){
					for(var i =0;i<data.OUT_DATA.length;i++){
						var tmp =data.OUT_DATA[i];
						grid_arr_data_sex.push({ value: tmp.CD , text: tmp.CD_NM  })
					}
				}
			}
		});
	
		const grid = new TuiGridMngr(_this,'grid',{
		      editable: true
		      ,showRowStatus: true
		      ,rowNum: true
		      ,checkbox: true
		      ,pageable : true
			  ,pageSize : 300      
		  	}
		,[
			{
		           header: 'ACTR_SEQ',
		           name: 'ACTR_SEQ',
		           width: 80,
		           resizable: false,
		           sortable: true,
		           sortingType: 'desc'
		         },{
		           header: '배우명(한글)',
		           name: 'ACTR_NM_KR',
		           width: 100,
		           resizable: false,
		           sortable: true,
		           sortingType: 'desc',
		           editor: 'text',
		           validation: {
		             dataType: 'string',  /*string ,number*/
		             required: true,    /*  true 필수, false 필수아님  */
		             unique: false   /*true 데이터가 중복되면 빨간색 표시 */
		           	}
		         },{
		           header: '배우명(일본)',
		           name: 'ACTR_NM_JP',
		           width: 100,
		           resizable: false,
		           sortable: true,
		           sortingType: 'desc',
		           editor: 'text'
		         },{
		           header: '배우명(영어)',
		           name: 'ACTR_NM_ENG',
		           width: 100,
		           sortable: true,
		           sortingType: 'desc',
		           editor: 'text'
		         },{
		           header: '생년월일',
		           name: 'BIRTH_DT',
		           width: 100,
		           sortable: true,
		           sortingType: 'desc',
		           editor: 'text'
		         },{
		           header: '나이',
		           name: 'AGE',
		           width: 100,
		           sortable: true,
		           sortingType: 'desc'
		         }, {
		           header: '성별',
		           name: 'SEX',
		           width: 100,
		           sortable: true,
		           sortingType: 'desc',
		           align: "center",
		           formatter: 'listItemText',
		            editor: {
		               type: 'select',
		               options: {
		                 listItems: grid_arr_data_sex
		               }
		            }
		            ,validation: {
		             dataType: 'string',  /*string ,number*/
		             required: true,    /*  true 필수, false 필수아님  */
		             unique: false   /*true 데이터가 중복되면 빨간색 표시 */
		           	}
		         },{
			       header: '랭킹',
			       name: 'RNK',
			       width: 100,
		           sortable: true,
		           align : "center",
		           sortingType: 'desc',
		           editor: 'text'
		           ,validation: {
		             dataType: 'number',  /*string ,number*/
		             required: false,    /*  true 필수, false 필수아님  */
		             unique: false   /*true 데이터가 중복되면 빨간색 표시 */
		           	}
		         },{
					header : '정렬',
					name : 'ORD',
					width : 100,
					sortable : true,
					align : "center",
					sortingType : 'desc',
					filter : {
						type : 'text',
						showApplyBtn : true,
						showClearBtn : true
					},
					editor : 'text'
					,validation: {
		             dataType: 'number',  /*string ,number*/
		             required: false,    /*  true 필수, false 필수아님  */
		             unique: false   /*true 데이터가 중복되면 빨간색 표시 */
		           	}
		         },{
		           header: '비고',
		           name: 'RMK',
		           width: 100,
		           editor: 'text'
		         },{
					header : '모자이크여부',
					name : 'MSC_YN',
					width : 200,
					sortable : true,
					align : "center",
					sortingType : 'desc', /*내림차순   ctrl 키를 누르고 정렬키를 여러개 누르면 이어서 정렬이 된다.*/
					formatter: 'listItemText',
		            editor: {
		               type: 'select',
		               options: {
		                 listItems: grid_arr_data_msc_yn
		               }
		            }
		            ,validation: {
		             dataType: 'string',  /*string ,number*/
		             required: true,    /*  true 필수, false 필수아님  */
		             unique: false   /*true 데이터가 중복되면 빨간색 표시 */
		           	}
				 },{
		             header: '생성일',
		             name: 'CRT_DTM',
		             width: 140,
		             sortable: true,
		             align: "center"
		         },{
		             header: '수정일',
		             name: 'UPDT_DTM',
		             width: 140,
		             sortable: true,
		             align: "center" 
		         }
		    ]
		);
	  	grid.build();

	  	searchForm.addEvent("click","input[type=button]",function(el){
		   //console.log(el);
	  	   switch(el.target.name){
           case 'search':
        		var param ={
					 brRq : 'IN_DATA'
					,brRs : 'OUT_DATA'
					,IN_DATA:[{}]
				}
		    	grid.loadData('BR_AV_ACTR_FIND',param,function(data){
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
		    		_this.send('BR_AV_ACTR_SAVE',param,function(data){
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
			        _this.send('BR_AV_ACTR_RM',param,function(data){
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
		  		var param ={
						brRq 		: 'IN_DATA'
						,brRs 		: 'OUT_DATA'
						,IN_DATA	: [{}]
				}
		  		ExcelMngr.downExcel('BR_AV_ACTR_EXCEL_DWNLD',
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