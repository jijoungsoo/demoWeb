
<% String uuid = (String) request.getAttribute("uuid"); %>
<script>
$(document).ready(function(){
	var AV_1150 = new PgmPageMngr ('<%=uuid%>');
	AV_1150.init(function(p_param) {
		var _this = AV_1150;
		var searchForm = new FormMngr(_this, "search_area");
		searchForm.initCombo("AGE",'BS_MIG_AV_ACTR_AGE_FIND', {brRq: '',brRs: 'OUT_DATA'},{ USE_EMPTY_YN : 'Y' , VALUE :'CD' , TEXT :'CD_NM' });
		
		const grid = new TuiGridMngr(_this,'grid',{
		      editable: false
		      ,showRowStatus: false
		      ,rowNum: true
		      ,checkbox: false
			  ,pageable: true
		  	}
		,[
				{
		           header: 'SYNC',
		           name: 'SYNC',
		           width: 80,
				   align : 'center',
				   filter : {
					type : 'text',
					showApplyBtn : true,
					showClearBtn : true
					}
				},{
		           header: 'IDX',
		           name: 'ACTOR_IDX',
		           width: 100,
				   align : 'center',
				   filter : {
					type : 'text',
					showApplyBtn : true,
					showClearBtn : true
				   },
				   resizable: true,
				   sortable : true,
		           sortingType: 'desc'
				},{
		           header: 'DVD',
		           name: 'DVD_CNT',
		           width: 60,
				   align : 'center',
				   sortable : true,
				   resizable: true,
		           sortingType: 'desc'
				},{
		           header: 'BEST',
		           name: 'BEST_DVD_CNT',
		           width: 60,
				   align : 'center',
				   sortable : true,
				   resizable: true,
		           sortingType: 'desc'
				},{
		           header: 'CMT',
		           name: 'ACTOR_CMT_CNT',
		           width: 60,
				   align : 'center',
				   sortable : true,
				   resizable: true,
		           sortingType: 'desc'
				},{
		           header: 'LK',
		           name: 'ACTOR_LK_CNT',
		           width: 60,
				   align : 'center',
				   sortable : true,
				   resizable: true,
		           sortingType: 'desc'
				},{
		           header: 'DSLK',
		           name: 'ACTOR_DSLK_CNT',
		           width: 60,
				   align : 'center',
				   sortable : true,
				   resizable: true,
		           sortingType: 'desc'
		         },{
		           header: 'D_DT',
		           name: 'DEBUT_DT',
		           width: 100,
				   align : 'center',
				   filter : {
					type : 'text',
					showApplyBtn : true,
					showClearBtn : true
				   },
				   sortable : true,
				   resizable: true,
		           sortingType: 'desc'
				},{
		           header: 'AGE',
		           name: 'AGE',
		           width: 80,
				   sortable : true,
				   resizable: true,
		           sortingType: 'desc'
		         },{
		           header: 'NAME_KR',
		           name: 'NAME_KR',
		           width: 140,
				   filter : {
					type : 'text',
					showApplyBtn : true,
					showClearBtn : true
				   },
				   sortable : true,
				   resizable: true,
		           sortingType: 'desc'
				},{
		           header: 'O_NM',
		           name: 'O_NM',
		           width: 140,
				   filter : {
					type : 'text',
					showApplyBtn : true,
					showClearBtn : true
				   },
				   sortable : true,
				   resizable: true,
		           sortingType: 'desc'
		         },{
		           header: 'NAME_EN',
		           name: 'NAME_EN',
		           width: 140,
				   filter : {
					type : 'text',
					showApplyBtn : true,
					showClearBtn : true
				   },
				   sortable : true,
				   resizable: true,
		           sortingType: 'desc'
		         },{
		           header: 'NAME_CN',
		           name: 'NAME_CN',
		           width: 140,
				   filter : {
					type : 'text',
					showApplyBtn : true,
					showClearBtn : true
				   },
				   sortable : true,
				   resizable: true,
		           sortingType: 'desc'
		         },{
					header : 'BIRTH',
					name : 'BIRTH',
					width : 120,
					filter : {
					type : 'text',
					showApplyBtn : true,
					showClearBtn : true
				   },
				   sortable : true,
				   resizable: true,
		           sortingType: 'desc'
				},{
		           header: 'HEIGHT',
		           name: 'HEIGHT',
		           width: 120,
				   filter : {
					type : 'text',
					showApplyBtn : true,
					showClearBtn : true
				   },
				   sortable : true,
				   resizable: true,
		           sortingType: 'desc'
				},{
		           header: 'SIZE',
		           name: 'SIZE',
		           width: 140,
				   align : 'center',
		           filter : {
					type : 'text',
					showApplyBtn : true,
					showClearBtn : true
				   },
				   sortable : true,
				   resizable: true,
		           sortingType: 'desc'
				},{
		           header: 'BRA_SIZE',
		           name: 'BRA_SIZE',
		           width: 100,
		           filter : {
					type : 'text',
					showApplyBtn : true,
					showClearBtn : true
				   },
				   sortable : true,
				   resizable: true,
		           sortingType: 'desc'
				},{
		           header: 'DSCR_TTL',
		           name: 'DSCR_TTL',
		           width: 100,
				   sortable : true,
				   resizable: true,
		           sortingType: 'desc'
				},{
		           header: 'DSCR',
		           name: 'DSCR',
		           width: 100,
				   sortable : true,
				   resizable: true,
		           sortingType: 'desc'
				},{
			       header: 'IMG',
			       name: 'IMG',
				   resizable: true,
			       width: 100
		         },{					 
		           header: 'IMG_S',
		           name: 'IMG_S',
				   resizable: true,
		           width: 100
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

		grid.on('click', (ev) => {
			if (ev.rowKey >=0) {
				var row_data=grid.getRow(ev.rowKey);
				console.log(row_data);

				var param = {
					ACTOR_IDX: row_data.ACTOR_IDX
				}
				var popup = new PopupManger(_this, 'AV_1160', {
						width: 1200,
						height: 700,
						title: "(MIG)배우상세"
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