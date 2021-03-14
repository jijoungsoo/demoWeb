<%	String uuid = (String) request.getAttribute("uuid"); %>
<script>
$(document).ready(function(){
	var CM_1550 = new PgmPageMngr ('<%=uuid%>');
	CM_1550.init(function(p_param) {
		var _this = CM_1550;
		var searchForm = new FormMngr(_this, "search_area");
	
		const grid = new TuiGridMngr(_this,'grid',{
		      editable: false
		      ,showRowStatus: false
		      ,rowNum: true
		      ,checkbox: false      
		  	}
		,[
				{
		           header: 'SEQ_NO',
		           name: 'SEQ_NO',
		           width: 100,
				   resizable: false,
		           sortable: true,
				   align:"right",
		           sortingType: 'desc'
				},{
		           header: '구분ID',
		           name: 'GBN_ID',
				   width : 100,
		           sortable : true
				},{
		           header: '인증ID',
		           name: 'AUTH_ID',
				   width : 200,
		           sortable : true		
				},{
		           header: '닉네임',
		           name: 'NCK_NM',
		           width: 300,
		           sortable: true
		         },{
		           header: '프로필이미지',
		           name: 'PRF_IMG',
		           width: 200,
		           resizable: false,
		           sortable: true,
		           sortingType: 'desc'
		         },{
		           header: '썸네일',
		           name: 'THUMB_IMG',
		           width: 200,
		           sortable: true
		         },{
			           header: '이메일',
			           name: 'EML',
					   width : 200,
					   sortable: true
				},{
		           header: '생일(MMDD)',
		           name: 'BRTH_DAY',
				   width : 100,
				   align: "center",
				   sortable: true
				},{
					header : '성별',
					name : 'GNDR',
					width : 100,
					sortable : true
		        },{
		             header: '생성일',
		             name: 'CRT_DTM',
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
		    	grid.loadData('BR_CM_OAUTH_LOG_FIND',param,function(data){
			    	console.log(data);
			    	//gridLoadData에서 자동으로 로드됨..
		        	
		    	});
               break;
           }
	  	});
	  	searchForm.get("search").trigger("click");
	});	
});

</script>