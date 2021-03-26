<% String uuid = (String) request.getAttribute("uuid"); %>
<script>
$(document).ready(function(){
	var AV_1300 = new PgmPageMngr ('<%=uuid%>');
	AV_1300.init(function(p_param) {
		var searchForm;
		var grid ;

		var _this = AV_1300;
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
		           header: 'MK_ID',
		           name: 'MK_ID',
		           width: 100,
		           sortingType: 'desc'
			}, {
					header: 'NM',
					name: 'NM',
					width : 200,
					sortingType: 'desc'
			}, {
					header : 'TTL',
					name : 'TTL',
					sortingType : 'desc'
			},{     
					header: 'IMG_L',
					name: 'IMG_L',
					width : 200,					
					sortingType: 'desc'
			},{     
					header : 'IMG',
					name : 'IMG',
					width : 200,
					sortingType : 'desc'
		    }, {
		             header: '생성일',
		             name: 'CRT_DTM',
		             width: 140,
					 sortingType: 'desc' 
		    }
		    ]
		);
	  	grid.build();

		  
		grid.on('click', (ev) => {
			if (ev.rowKey >=0) {
				var row_data=grid.getRow(ev.rowKey);
				console.log(row_data);

				var param = {
					DVD_IDX: row_data.DVD_IDX,
					ACTOR_IDX: row_data.MAIN_ACTOR_IDX,
				}
				var popup = new PopupManger(_this, 'AV_1251', {
						width: 1000,
						height: 800,
						title: "(MIG)DVD 상세"
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
		    	grid.loadData('BS_MIG_AV_MK_FIND',param,function(data){
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