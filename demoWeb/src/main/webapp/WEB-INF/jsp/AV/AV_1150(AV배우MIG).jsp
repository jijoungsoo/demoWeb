
<% String uuid = (String) request.getAttribute("uuid"); %>
<script>
$(document).ready(function(){
	var AV_1150 = new PgmPageMngr ('<%=uuid%>');
	AV_1150.init(function(p_param) {
		var _this = AV_1150;
		var searchForm = new FormMngr(_this, "search_area");
		
		const grid = new TuiGridMngr(_this,'grid',{
		      editable: false
		      ,showRowStatus: false
		      ,rowNum: true
		      ,checkbox: false
		  	}
		,[
			{
		           header: 'ACTOR_IDX',
		           name: 'ACTOR_IDX',
		           width: 80,
		           sortingType: 'desc'
				},{
			       header: 'IMG',
			       name: 'IMG',
			       width: 100,
		           sortingType: 'desc'
		         },{					 
		           header: 'IMG_S',
		           name: 'IMG_S',
		           width: 100,
		           sortingType: 'desc'
		         },{
		           header: 'DEBUT_DT',
		           name: 'DEBUT_DT',
		           width: 100,
		           sortingType: 'desc'
		         },{
		           header: 'NAME_KR',
		           name: 'NAME_KR',
		           width: 200,
		           sortingType: 'desc'
				},{
		           header: 'O_NM',
		           name: 'O_NM',
		           width: 200,
		           sortingType: 'desc'
		         },{
		           header: 'NAME_EN',
		           name: 'NAME_EN',
		           width: 200,
		           sortingType: 'desc'
		         },{
		           header: 'NAME_CN',
		           name: 'NAME_CN',
		           width: 200,
		           sortingType: 'desc'

		         },{
					header : 'BIRTH',
					name : 'BIRTH',
					width : 100,
					sortingType: 'desc'
				},{
		           header: 'HEIGHT',
		           name: 'HEIGHT',
		           width: 100,
		           sortingType: 'desc'
				},{
		           header: 'SIZE',
		           name: 'SIZE',
		           width: 200,
		           sortingType: 'desc'
				},{
		           header: 'BRA_SIZE',
		           name: 'BRA_SIZE',
		           width: 100,
		           sortingType: 'desc'
				},{
		           header: 'DSCR_TTL',
		           name: 'DSCR_TTL',
		           width: 100,
				   resizable: true,
		           sortingType: 'desc'
				},{
		           header: 'DSCR',
		           name: 'DSCR',
		           width: 100,
				   resizable: true,
		           sortingType: 'desc'
				},{
		           header: 'SYNC',
		           name: 'SYNC',
		           width: 100,
				   resizable: true,
		           sortingType: 'desc'
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
        		var param ={
					 brRq : 'IN_DATA'
					,brRs : 'OUT_DATA'
					,IN_DATA:[{}]
				}
		    	grid.loadData('BR_MIG_AV_ACTR_FIND',param,function(data){
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