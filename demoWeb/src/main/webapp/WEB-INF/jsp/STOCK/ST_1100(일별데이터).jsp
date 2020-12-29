
<%	String pgmId = (String) request.getAttribute("pgmId");
	String uuid = (String) request.getAttribute("uuid");
%>
<script>
$(document).ready(function(){
	var ST_1100 = new PgmPageMngr ('<%=pgmId%>', '<%=uuid%>');
	ST_1100.init(function(p_param) {
		var _this = ST_1100;
		var searchForm = new FormMngr(_this,"search_area");
		
		var ed_dt = moment(new Date());
		var str_ed_dt = ed_dt.format("YYYYMMDD")
		console.log(str_ed_dt);
		console.log(ed_dt)
		var str_st_dt = ed_dt.subtract('months',3).format("YYYYMMDD")
		
		var tp_STOCK_DT_ST = new TimePickerMngr(_this,"STOCK_DT_ST",{
	         numberOfMonths: [1,3],
	         yearRange: "1996:+0",
	         stepMonths: 3,
	         showWeek: true,
	         dateFormat: 'yymmdd'
		});
		
		
		searchForm.setData("STOCK_DT_ST",str_st_dt)
		var tp_STOCK_DT_ED = new TimePickerMngr(_this,"STOCK_DT_ED",{
			numberOfMonths: [1,3],
	         yearRange: "1996:+0",
	         stepMonths: 3,
	         showWeek: true,
	         dateFormat: 'yymmdd'
		});
		searchForm.setData("STOCK_DT_ED",str_ed_dt)
		
		const grid = new TuiGridMngr(_this, 'grid',
		{
			editable : false,
			showRowStatus : false,
			rowNum : true,
			checkbox : false,
			pageable : true,
			pageSize : 300
		}, [ {
			header : '주식코드',
			name : 'STOCK_CD',
			width : 80,
			resizable : false,
			sortable : true,
			sortingType : 'desc'
		}, {
			header : '일자',
			name : 'STOCK_DT',
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
			width : 'auto',
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
			width : 100,
			sortable : true,
			align : "center",
			filter : 'select',
		}, {
			header : '전일대비금액',
			name : 'CHANGES_AMT',
			filter : {
				type : 'text',
				operator : 'OR'
			}
		}, {
			header : '전일대비비율',
			name : 'CHANGES_RT',
			filter : {
				type : 'text',
				operator : 'OR'
			}
		}, {
			header : '거래량',
			name : 'TRADE_QTY',
			width : 100,
			sortable : true,
			align : "center",
			sortingType : 'desc'
		}, {
			header : '거래대금',
			name : 'TRADE_AMT',
			width : 100,
			sortable : true,
			align : "center",
			sortingType : 'desc'
		}, {
			header : '시작가',
			name : 'START_AMT',
			width : 100,
			sortable : true,
			align : "center",
			sortingType : 'desc'
		}, {
			header : '고가',
			name : 'HIGH_AMT',
			width : 100,
			sortable : true,
			align : "center",
			sortingType : 'desc'
		}, {
			header : '저가',
			name : 'LOW_AMT',
			width : 100,
			sortable : true,
			align : "center",
			sortingType : 'desc'
		}, {
			header : '시가총액(백만원)',
			name : 'TOTAL_MRKT_AMT',
			width : 100,
			sortable : true,
			align : "center",
			sortingType : 'desc'
		}, {
			header : 'MarcapRatio',
			name : 'TOTAL_MRKT_AMT_RT',
			width : 100,
			sortable : true,
			align : "center",
			sortingType : 'desc'
		}, {
			header : '외국인 보유주식수',
			name : 'FRGN_CNT',
			width : 100,
			sortable : true,
			align : "center",
			sortingType : 'desc'
		}, {
			header : '외국인 지분율(%) ',
			name : 'FRGN_RT',
			width : 100,
			sortable : true,
			align : "center",
			sortingType : 'desc'
		}, {
			header : '순위',
			name : 'RNK',
			width : 100,
			sortable : true,
			align : "center",
			sortingType : 'desc'
		},
		{
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
		
		searchForm.addEvent("click","input[name=STOCK_CD]",function(el) {
			var data = searchForm.getData();
			console.log(data);
			var param = {
					STOCK_CD : data["STOCK_CD"]
			}
			console.log(param);
			var popup = new PopupManger(_this, 'ST_CM_0100', {
	          width: 1100,
	          heght: 700
	        },
	          param
	        );
	        popup.open(function(data){
	        	if(data){
	        		console.log(data);
	        	}
	        });
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
				grid.loadData('findStckMarcap',param,function(data) {
					console.log(data);
				});
				break;
			
			}
		});
	});
});
</script>