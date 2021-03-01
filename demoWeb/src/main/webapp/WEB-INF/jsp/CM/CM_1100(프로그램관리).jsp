<%	String uuid = (String) request.getAttribute("uuid"); %>
<script>
$(document).ready(function(){
	var CM_1100 = new PgmPageMngr ('<%=uuid%>');
	CM_1100.init(function(p_param) {
		var _this = CM_1100;
		var searchForm = new FormMngr(_this, "search_area");
		searchForm.initCombo("CATEGORY",'BR_CM_CD_FIND', {brRq: 'IN_DATA',brRs: 'OUT_DATA',IN_DATA: [  { GRP_CD : 'CATEGORY',  USE_YN: 'Y'}]},{ USE_EMPTY_YN : 'Y' , VALUE :'CD' , TEXT :'CD_NM' });
		
		const grid = new TuiGridMngr(_this,'grid',{
		      editable: true
		      ,showRowStatus: true
		      ,rowNum: true
		      ,checkbox: true      
		  	}
		,[
			{
		           header: 'PGM_NO',
		           name: 'PGM_NO',
		           width: 80,
		           resizable: false,
		           sortable: true,
		           sortingType: 'desc' /*내림차순   ctrl 키를 누르고 정렬키를 여러개 누르면 이어서 정렬이 된다.*/
		         },
		       {
		           header: '프로그램',
		           name: 'PGM_ID',
		           width: 100,
		           resizable: false,
		           sortable: true,
		           sortingType: 'desc', /*내림차순   ctrl 키를 누르고 정렬키를 여러개 누르면 이어서 정렬이 된다.*/
		           filter: { type: 'text', showApplyBtn: true, showClearBtn: true },   /*text, number, select, date 4가지가 있다.*/
		           validation: {
		             dataType: 'string',  /*string ,number*/
		             required: true,    /*  true 필수, false 필수아님  */
		             unique: true   /*true 데이터가 중복되면 빨간색 표시 */
		           },
		           editor: 'text'
		         },
		         {
		           header: '프로그램명',
		           name: 'PGM_NM',
		           width: 'auto',   /*너비 자동조절*/
		           sortable: true,
		           filter: { type: 'text', showApplyBtn: true, showClearBtn: true },
		           editor: 'text'
		               /*
		 https://github.com/nhn/tui.grid/tree/master/packages/toast-ui.grid/docs/ko 설명서              
		 내장에디터 종료
		 https://github.com/nhn/tui.grid/blob/master/packages/toast-ui.grid/docs/ko/custom-editor.md              
		 text : Text input (input[type=text])
		 password : Password input (input[type=password])
		 checkbox : Check box (input[type=checkbox])
		 radio : Radio button (input[type=radio])
		 select : Select box (select)
		               */
		         },
		         
		         {
		           header: '카테고리',
		           name: 'CATEGORY',
		           width: 100,
		           sortable: true,
		           align: "center",
				   type : "combo",
				   comboData : _this.getComboData('BR_CM_CD_FIND', {brRq: 'IN_DATA',brRs: 'OUT_DATA',IN_DATA: [{  GRP_CD : 'CATEGORY' , USE_YN: 'Y' }]},{ USE_EMPTY_YN : 'Y' , VALUE :'CD' , TEXT :'CD_NM' })
		         },
		         {
			           header: '폴더링크',
			           name: 'DIR_LINK',
			           editor: 'text',
			           filter: {
			               type: 'text',
			               operator: 'OR'
			             },    /*자동검색*/
			           validation: {
			               dataType: 'string',  /*string ,number*/
			               required: true,    /*  true 필수, false 필수아님  */
			               unique: false   /*true 데이터가 중복되면 빨간색 표시 */
			             },
			           
			         },
		         {
		           header: '프로그램링크',
		           name: 'PGM_LINK',
		           editor: 'text',
		           filter: {
		               type: 'text',
		               operator: 'OR'
		             },    /*자동검색*/
		           validation: {
		               dataType: 'string',  /*string ,number*/
		               required: true,    /*  true 필수, false 필수아님  */
		               unique: true   /*true 데이터가 중복되면 빨간색 표시 */
		             },
		           
		         },
		         {
						header : '정렬',
						name : 'ORD',
						width : 100,
						sortable : true,
						align : "center",
						sortingType : 'desc', /*내림차순   ctrl 키를 누르고 정렬키를 여러개 누르면 이어서 정렬이 된다.*/
						filter : {
							type : 'text',
							showApplyBtn : true,
							showClearBtn : true
						}, /*text, number, select, date 4가지가 있다.*/
						editor : 'text'
					},
		         {
		           header: '비고',
		           name: 'RMK',
		           editor: 'text'
		         },
		         {
		             header: '생성일',
		             name: 'CRT_DTM',
		             width: 140,
		             sortable: true,
		             align: "center"
		         },
		         {
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
			   var data = searchForm.getData();
        		var param ={
					 brRq : 'IN_DATA'
					,brRs : 'OUT_DATA'
					,IN_DATA:[data]
				}
		    	grid.loadData('BR_CM_PGM_FIND',param,function(data){
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
		    		_this.send('BR_CM_PGM_SAVE',param,function(data){
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
			        _this.send('BR_CM_PGM_RM',param,function(data){
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