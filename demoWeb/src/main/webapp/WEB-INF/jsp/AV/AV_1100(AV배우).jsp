
<%
String pgmId = (String) request.getAttribute("pgmId");
String uuid = (String) request.getAttribute("uuid");
%>
<script>
$(document).ready(function(){
	var AV_1100 = new PgmPageMngr ('<%=pgmId%>', '<%=uuid%>');
	AV_1100.init(function(p_param) {
		var _this = AV_1100;
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
				IN_DATA : [ { GRP_CD : 'SEX'
					,USE_YN : 'Y' } ]
		}
		//콤보박스 세팅
		var grid_arr_data_sex = []
		_this.send_sync('findCmCd', param, function(data) {
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
		    	grid.loadData('findAvActr',param,function(data){
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
		    		_this.send('saveAvActr',param,function(data){
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
			        _this.send('rmAvActr',param,function(data){
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