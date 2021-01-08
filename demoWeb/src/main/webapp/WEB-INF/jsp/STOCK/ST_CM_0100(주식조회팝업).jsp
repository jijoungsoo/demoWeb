
<%	String pgmId = (String) request.getAttribute("pgmId");
	String uuid = (String) request.getAttribute("uuid");
%>
<script>
$(document).ready(function(){
	var ST_CM_0100 = new PgmPageMngr ('<%=pgmId%>', '<%=uuid%>');
	ST_CM_0100.init(function(p_param) {
		var _this = ST_CM_0100;
		var searchForm = new FormMngr(_this,"search_area");
		
		var param = {
				brRq : 'IN_DATA',
				brRs : 'OUT_DATA',
				IN_DATA : [ { GRP_CD : 'MARKET'
					,USE_YN : 'Y' } ]
		}
		_this.send('findCmCd', param, function(data) {
			_this.hideProgress();
			if (data) {
				//콤보박스 세팅
				var arr_data = []
				console.log(data.OUT_DATA);
				arr_data.push({ id: "" , text: "ALL"  });
				if(data.OUT_DATA){
					for(var i =0;i<data.OUT_DATA.length;i++){
						var tmp =data.OUT_DATA[i];
						arr_data.push({ id: tmp.CD , text: tmp.CD_NM  });
					}
				}
				console.log(arr_data);
				searchForm.addSelect("MARKET_CD",arr_data);
			}

		});
		
		const grid = new TuiGridMngr(_this, 'grid',
		{
			editable : false,
			showRowStatus : false,
			rowNum : true,
			checkbox : false,
			pageable : true,
			bodyHeight : 400,
			pageSize : 300
		}, 
		[ 
			{
			header : '주식코드',
			name : 'STOCK_CD',
			width : 80,
			resizable : false,
			sortable : true,
			sortingType : 'desc',
			filter : 'select'
		}, {
			header : '마켓코드',
			name : 'LIST_MARKET_NM',
			width : 200,
			resizable : false,
			sortable : true,
			sortingType : 'desc',
			filter : 'select'
		}, {
			header : '마켓CNT',
			name : 'MARKET_CNT',
			width : 100,
			align : "right",
			resizable : false,
			sortable : true,
			sortingType : 'desc',
			filter : 'select'
		}, {
			header : '오픈일자',
			name : 'OPEN_DT',
			width : 100,
			resizable : false,
			sortable : true,
			sortingType : 'desc',
			filter : {
				type : 'text',
				showApplyBtn : true,
				showClearBtn : true
			},
		}, {
			header : '주식명',
			name : 'STOCK_NM',
			width : 200,
			sortable : true,
			filter : {
				type : 'text',
				showApplyBtn : true,
				showClearBtn : true
			}
		},
		{
			header : '종가',
			name : 'CLS_AMT',
			renderer : {
				type: commaRenderer
			},
			width : 100,
			sortable : true,
			align : "right",
			filter : 'select',
		}, {
				header : '주식수',
				name : 'STOCK_CNT',
				renderer : {
					type: commaRenderer
				},
				width : 100,
				sortable : true,
				align : "right",
				filter : 'select',
			}, {
			
			
			header : '감리구분',
			name : 'CONSTRUCTION',
			width : 100,
			sortable : true,
			align : "center",
			sortingType : 'desc'
		}, {
			header : '주식상태',
			name : 'STOCK_STATE',
			width : 200,
			sortable : true,
			align : "center",
			sortingType : 'desc'
		}, {
			header : '생성일',
			name : 'CRT_DTM',
			width : 140,
			sortable : true,
			align : "center"
		}, {
			header : '수정일',
			name : 'UPDT_DTM',
			width : 140,
			sortable : true,
			align : "center"
		} ]
		
		);
		grid.build();
		
		grid.on('dblclick', (ev) => {
			if (ev.rowKey >=0) {
				var row_data=grid.getRow(ev.rowKey);
				console.log(row_data);
				_this.close(row_data);
			}
		});
		
		searchForm.addEvent("click","input[type=button]",function(el) {
			//console.log(el);
			switch (el.target.name) {
			case 'search':
				var data = searchForm.getData();
				console.log(data);
				if(searchForm.valid()==false) {
					return;
				}
				
				var param = {
					brRq : 'IN_DATA',
					brRs : 'OUT_DATA',
					IN_DATA : [ data ]
				}
				grid.loadData('findKiwMst',param,function(data) {
					console.log(data);
				});
				break;
			}
		});
		
		
	});
});
</script>