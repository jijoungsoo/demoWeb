
<%
String pgmId = (String) request.getAttribute("pgmId");
String uuid = (String) request.getAttribute("uuid");
%>
<script>
$(document).ready(function(){
	var AV_1200 = new PgmPageMngr ('<%=pgmId%>', '<%=uuid%>');
	AV_1200.init(function(p_param) {
		var _this = AV_1200;
		var searchForm = new FormMngr(_this, "search_area");
		var param = {
				brRq : 'IN_DATA',
				brRs : 'OUT_DATA',
				IN_DATA : [ { GRP_CD : 'MSC_CD'
					,USE_YN : 'Y' } ]
		}
		//콤보박스 세팅
		var grid_arr_data_msc_cd = []
		_this.send_sync('findCmCd', param, function(data) {
			if (data) {
				console.log(data.OUT_DATA);
				if(data.OUT_DATA){
					for(var i =0;i<data.OUT_DATA.length;i++){
						var tmp =data.OUT_DATA[i];
						grid_arr_data_msc_cd.push({ value: tmp.CD , text: tmp.CD_NM  })
					}
				}
			}
		});
		
		var param = {
				brRq : 'IN_DATA',
				brRs : 'OUT_DATA',
				IN_DATA : [ { GRP_CD : 'CPTN_YN'
					,USE_YN : 'Y' } ]
		}
		//콤보박스 세팅
		var grid_arr_data_cptn_yn = []
		_this.send_sync('findCmCd', param, function(data) {
			if (data) {
				console.log(data.OUT_DATA);
				if(data.OUT_DATA){
					for(var i =0;i<data.OUT_DATA.length;i++){
						var tmp =data.OUT_DATA[i];
						grid_arr_data_cptn_yn.push({ value: tmp.CD , text: tmp.CD_NM  })
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
		           header: 'AV_SEQ',
		           name: 'AV_SEQ',
		           width: 80,
		           resizable: false,
		           sortable: true,
		           sortingType: 'desc'
			  }, {
			           header: '좋아요',
			           width : 100,
			           name: 'LK_CNT'
			},{     
					header : '모자이크상태',
					name : 'MSC_CD',
					width : 200,
					sortable : true,
					align : "center",
					sortingType : 'desc', /*내림차순   ctrl 키를 누르고 정렬키를 여러개 누르면 이어서 정렬이 된다.*/
					formatter: 'listItemText',
		            editor: {
		               type: 'select',
		               options: {
		                 listItems: grid_arr_data_msc_cd
		               }
		            }
		            ,validation: {
		             dataType: 'string',  /*string ,number*/
		             required: true,    /*  true 필수, false 필수아님  */
		             unique: false   /*true 데이터가 중복되면 빨간색 표시 */
		           	}
		       }, {
		           header: '품번',
		           name: 'AV_NM',
		           width: 200,
		           resizable: false,
		           sortable: true,
		           sortingType: 'desc',
		           editor: 'text'
		         },{
		           header: '자막유무',
		           width: 100,
		           name: 'CPTN_YN',
		           formatter: 'listItemText',
		            editor: {
		               type: 'select',
		               options: {
		                 listItems: grid_arr_data_cptn_yn
		               }
		            }
		            ,validation: {
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

	  	searchForm.addEvent("click","input[type=button]",function(el){
		   //console.log(el);
	  	   switch(el.target.name){
           case 'search':
        		var param ={
					 brRq : 'IN_DATA'
					,brRs : 'OUT_DATA'
					,IN_DATA:[{}]
				}
		    	grid.loadData('findAvMv',param,function(data){
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
		    		_this.send('saveAvMv',param,function(data){
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
			        _this.send('rmAvMv',param,function(data){
			        	_this.hideProgress();
			        	if(data){
			        		Message.alert('삭제되었습니다.',function()  {
				        		searchForm.get("search").trigger("click");
				        	});
				        }
			        	
			        });
				});
		  		break;
	  	   }
	  	});
	  	searchForm.get("search").trigger("click");
	});	
});

</script>