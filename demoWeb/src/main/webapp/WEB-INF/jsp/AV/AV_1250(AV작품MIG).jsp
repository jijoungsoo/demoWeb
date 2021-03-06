<% String uuid = (String) request.getAttribute("uuid"); %>
<script>
$(document).ready(function(){
	var AV_1250 = new PgmPageMngr ('<%=uuid%>');
	AV_1250.init(function(p_param) {
		var searchForm;
		var grid ;

		var _this = AV_1250;
		searchForm = new FormMngr(_this, "search_area");
		grid = new TuiGridMngr(_this,'grid',{
		      editable: false
		      ,showRowStatus: false
		      ,rowNum: true
		      ,checkbox: false      
		      ,pageable : true
			  ,pageSize : 300
		  	}
		,[
			{
		           header: 'DVD_IDX',
		           name: 'DVD_IDX',
		           width: 60,
		           sortingType: 'desc'
			}, {
					header: 'IMG_A',
					name: 'IMG_A',
					width : 60,
					sortingType: 'desc'
			}, {
					header: 'IMG_AS',
					name: 'IMG_AS',
					width : 60,					
					sortingType: 'desc'
			},{     
					header : 'IMG_N',
					name : 'IMG_N',
					width : 100,
					sortingType : 'desc'
			},{     
					header : 'IMG_NS',
					name : 'IMG_NS',
					width : 100,
					sortingType : 'desc'
		       }, {
		           header: 'MV_NM',
		           name: 'MV_NM',
		           width: 400,
		           sortingType: 'desc'
		         },{
		           header: 'TITLE_KR',
		           name: 'TITLE_KR',				   
		           width: 100,
				   sortingType: 'desc'			
		         },{
					header: 'MAIN_ACTOR_NM',
		           name: 'MAIN_ACTOR_NM',				   
		           width: 100,
				   sortingType: 'desc'
		         },{  
					header: 'MAIN_ACTOR_IDX',
		           name: 'MAIN_ACTOR_IDX',				   
		           width: 100,
				   sortingType: 'desc'
		         },
		         {
				   header: 'ACTR_NM',
		           name: 'ACTR_NM',				   
		           width: 100,
				   sortingType: 'desc'		       
		         }, {
					header: 'OPEN_DT',
		           name: 'OPEN_DT',				   
		           width: 100,
				   sortingType: 'desc'
				}, {
					header: 'COMP_NM',
		           name: 'COMP_NM',				   
		           width: 100,
				   sortingType: 'desc'
				}, {
					header: 'LABEL',
		           name: 'LABEL',				   
		           width: 100,
				   sortingType: 'desc'
				}, {
					header: 'SYNC',
		           name: 'SYNC',				   
		           width: 100,
				   sortingType: 'desc'
				}, {
					header: 'BEST_YN',
		           name: 'BEST_YN',				   
		           width: 100,
				   sortingType: 'desc'
				}, {
					header: 'SERIES',
		           name: 'SERIES',				   
		           width: 100,
				   sortingType: 'desc'
				}, {
					header: 'DIRECTOR',
		           name: 'DIRECTOR',				   
		           width: 100,
				   sortingType: 'desc'
				}, {
					header: 'RUN_TIME',
		           name: 'RUN_TIME',				   
		           width: 100,
				   sortingType: 'desc'
				}, {
					header: 'STORY_KR',
		           name: 'STORY_KR',				   
		           width: 100,
				   sortingType: 'desc'
				}, {
					header: 'GEN_LIST',
		           name: 'GEN_LIST',				   
		           width: 100,
				   sortingType: 'desc'
		         }, {
		             header: '생성일',
		             name: 'CRT_DTM',
		             width: 140,
					 sortingType: 'desc' 
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
					,IN_DATA:[ data ]
				}
		    	grid.loadData('BR_MIG_AV_MV_FIND',param,function(data){
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