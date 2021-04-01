<% String uuid = (String) request.getAttribute("uuid"); %>
<script>
$(document).ready(function(){
	var AV_1165 = new PgmPageMngr ('<%=uuid%>');
		AV_1165.init(function(p_param) {
		var _this = AV_1165;
		var searchForm = new FormMngr(_this, "search_area");

		
		  
		searchForm.addEvent("click","input[type=button]",function(el){
		   //console.log(el);
	  	   switch(el.target.name){
           case 'search':
			   var data = searchForm.getData();
			   if(PjtUtil.isEmpty(data["ACTOR_IDX"])==true){
						Message.alert('배우IDX가 입력되지 않았습니다.', function() {
						});
						return;
				}
        		var param ={
					 brRq : 'IN_DATA'
					,brRs : 'OUT_DATA'
					,IN_DATA: [data]
				}
		    	grid.loadData('BS_MIG_AV_ACTR_CMT_FIND_BY_ACTOR_IDX',param,function(data){
			    	console.log(data);
			    	//gridLoadData에서 자동으로 로드됨..
		        	
		    	});
               break;
			   case 'sync':
					var data = searchForm.getData();
					if(PjtUtil.isEmpty(data["ACTOR_IDX"])==true){
						Message.alert('배우IDX가 입력되지 않았습니다.', function() {
						});
						return;
					}
					var param ={
							brRq : 'IN_DATA'
							,brRs : 'OUT_DATA'
							,IN_DATA: [{
								ACTOR_IDX : data["ACTOR_IDX"]
								,SYNC_YN : "N"
							}]
						}
					_this.showProgress();
					_this.send('BS_MIG_AV_ACTR_CMT_SYNC_ACTOR_IDX', param, function(data) {
						_this.hideProgress();
						if (data) {
							searchForm.get("search").trigger("click");
						}
					});	
			   	
				   break;
				   case 'sync_all':
					var data = searchForm.getData();
					if(PjtUtil.isEmpty(data["ACTOR_IDX"])==true){
						Message.alert('배우IDX가 입력되지 않았습니다.', function() {
						});
						return;
					}
					var param ={
							brRq : 'IN_DATA'
							,brRs : 'OUT_DATA'
							,IN_DATA: [{
								ACTOR_IDX : data["ACTOR_IDX"]
								,SYNC_YN : "Y"
							}]
						}
					_this.showProgress();
					_this.send('BS_MIG_AV_ACTR_CMT_SYNC_ACTOR_IDX', param, function(data) {
						_this.hideProgress();
						if (data) {
							searchForm.get("search").trigger("click");
						}
					});	
			   	
				   break;
        	}
	  	});
	  	
		_this.on("remoteCall",function(data){
			console.log('remoteCall  ---  vvvvvv')
			var detail =data.detail; 
			console.log(detail);
			switch (detail.ACTION) {
				case 'SEARCH':
					searchForm.setData('ACTOR_IDX',detail.ACTOR_IDX);
					searchForm.get("search").trigger("click");

					
					var param = {
							ACTION  : 'CALL',
							PGM_ID : 'AV_1164'
					}
					console.log(param);
					_this.parentCall({ detail: param });
				break;
			}
		});
		
		const grid = new TuiGridMngr(_this,'grid',{
		      editable: false
		      ,showRowStatus: false
		      ,rowNum: true
		      ,checkbox: false
			  ,pageable: false
			  ,bodyHeight: 200 
			  ,width: 700
			
		  	}
		,[
				{
		           header: 'CMT_IDX',
		           name: 'CMT_IDX',
		           width: 80,
				   align : 'center',
				   sortable : true,
				   resizable: true,
		           sortingType: 'desc'
				},{
		           header: 'CMT',
		           name: 'CMT',
				   align : 'left',
				   sortable : true,
				   resizable: true,
		           sortingType: 'desc'
				},{
		           header: 'WRITER',
		           name: 'WRITER',
		           width: 100,
				   align : 'center',
				   sortable : true,
				   resizable: true,
		           sortingType: 'desc'
		         },{
		           header: 'LK',
		           name: 'LK_CNT',
		           width: 60,
				   align : 'center',
				   sortable : true,
				   resizable: true,
		           sortingType: 'desc'
		         },{
		           header: 'DSLK',
		           name: 'DSLK_CNT',
		           width: 60,
				   align : 'center',
				   sortable : true,
				   resizable: true,
		           sortingType: 'desc'
		         }
		    ]
		);
	  	grid.build();


		var param = {
			ACTION  : 'ON_LOAD',
			PGM_ID : 'AV_1165'
		}
		console.log(param);
		_this.parentCall({ detail: param });

	});
});

</script>