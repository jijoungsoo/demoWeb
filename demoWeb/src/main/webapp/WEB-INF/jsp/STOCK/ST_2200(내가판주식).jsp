<%	String uuid = (String) request.getAttribute("uuid"); %>
<style>
.tui-grid-summary-area .tui-grid-cell {
    text-align: right;
}
</style>
<script>
$(document).ready(function(){
	var ST_2200 = new PgmPageMngr ('<%=uuid%>');
	var inline_popup;
	ST_2200.init(function(p_param) {
		var _this = ST_2200;
		var searchForm = new FormMngr(_this,"search_area");
			
		var grid_summary = {
		        height: 40,
		        position: 'bottom', // or 'top'
		        columnContent: {
		          AMT: {
		            template: function(valueMap) {
		            	console.log('bbbb');
		            	console.log(valueMap);
		              return `MAX: \${PjtUtil.numberComma(valueMap.max)}<br>MIN: \${PjtUtil.numberComma(valueMap.min)}`;
		            }
		          },
		          FEE: {
			            template: function(valueMap) {
			            	console.log('ccccccccccc');
			            	console.log(valueMap);
			            	/*
			            	여기서 그리드에 데이터를 읽어서 표시하는 걸 하면 좋겠다.
			            	*/
			              return `TOTAL: \${PjtUtil.numberComma(valueMap.sum)}`;
			            }
			      },
		          TOT_AMT: {
		            template: function(valueMap) {
		            	console.log('ccccccccccc');
		            	console.log(valueMap);
		            	/*
		            	여기서 그리드에 데이터를 읽어서 표시하는 걸 하면 좋겠다.
		            	*/
		              return `TOTAL: \${PjtUtil.numberComma(valueMap.sum)}`;
		            }
		          }
		        }
		}
		const grid = new TuiGridMngr(_this, 'grid',
		{
			editable : false,
			showRowStatus : false,
			rowNum : true,
			checkbox : true,
			pageable : true,
			pageSize : 300,
			summary : grid_summary,
			columnOptions: {
			        resizable: true
			}
		}, 
		[ 
			{
				header : 'SEQ',
				name : 'SELL_SEQ',
				width : 80,
				resizable : false,
				sortable : true,
				sortingType : 'desc'
			},{
				header : 'BUY_SEQ',
				name : 'BUY_SEQ',
				width : 80,
				resizable : false,
				sortable : true,
				sortingType : 'desc'
			},{
				header : '주식코드',
				name : 'STOCK_CD',
				width : 80,
				resizable : false,
				sortable : true,
				sortingType : 'desc'
			}, {
				header : '주식명',
				name : 'STOCK_NM',
				width : 120,
				sortable : true,
				filter : {
					type : 'text',
					showApplyBtn : true,
					showClearBtn : true
				}
			}, {
				header : '구매주식단가',
				name : 'BUY_AMT',
				renderer : {
					type: commaRenderer
				},
				width : 100,
				sortable : true,
				align : "right",
				sortingType : 'desc',
				editor : 'text'
			}, {
				header : '주식단가',
				name : 'AMT',
				renderer : {
					type: commaRenderer
				},
				width : 100,
				sortable : true,
				align : "right",
				sortingType : 'desc',
				editor : 'text'
			}, {
				header : '증감액',
				name : 'DIFF_AMT',
				renderer : {
					type: commaStRenderer,
					options : {
						src : 'BUY_AMT',
						tgt : 'AMT'
					}
				},
				width : 80,
				sortable : true,
				align : "right",
				sortingType : 'desc'
			}, {				
				header : '수익비율',
				name : 'BNFT_RT',
				renderer : {
					type: commaStRenderer,
					options : {
						src : 'BUY_AMT',
						tgt : 'AMT'
					}
				},
				width : 80,
				sortable : true,
				align : "right",
				sortingType : 'desc'
			}, {
				header : '판매수',
				name : 'CNT',
				renderer : {
					type: commaRenderer
				},
				width : 100,
				sortable : true,
				align : "right",
				sortingType : 'desc',
				editor : 'text'
			}, {
				header : '수수료',
				name : 'FEE',
				renderer : {
					type: commaRenderer
				},
				width : 100,
				sortable : true,
				align : "right",
				sortingType : 'desc',
				editor : 'text'
			}, {
				header : '총구매금액',
				name : 'TOT_BUY_AMT',
				renderer : {
					type: commaRenderer
				},
				width : 140,
				sortable : true,
				align : "right",
				sortingType : 'desc',
				editor : 'text'
			}, {
				header : '총판매금액',
				name : 'TOT_AMT',
				renderer : {
					type: commaRenderer
				},
				width : 140,
				sortable : true,
				align : "right",
				sortingType : 'desc',
				editor : 'text'
			}, {
				header : '총이익금액',
				name : 'TOT_BNFT_AMT',
				renderer : {
					type: commaStRenderer,
					options : {
						src : 'TOT_BUY_AMT',
						tgt : 'TOT_AMT'
					}
				},
				width : 120,
				sortable : true,
				align : "right",
				sortingType : 'desc',
				editor : 'text'
			}, {
				header: '판날',
			    name: 'SELL_DATE',
			    renderer : {
					type: datetimeRenderer,
					options : {
						format : 'yyyy-MM-DD HH:mm A',
						source : 'YYYYMMDDHHmm'
					}
				},
				width : 140,
			}, {
				header : '비고',
				name : 'RMK',
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
			}, {
				header : '생성자',
				name : 'CRT_USR_NO',
				width : 80,
				sortable : true,
				align : "center"
			},{
				header : '수정자',
				name : 'UPDT_USR_NO',
				width : 80,
				sortable : true,
				align : "center"
			},{
				header : '생성일',
				name : 'CRT_DTM',
				width : 140,
				sortable : true,
				align : "center"
			},{
				header : '수정일',
				name : 'UPDT_DTM',
				width : 140,
				sortable : true,
				align : "center"
			} 
		]
		);
		grid.build();
		
		searchForm.addEvent("click","input[type=button]", function(el) {
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
				grid.loadData('BR_STCK_SELL_FIND',param,function(data) {
					console.log(data);
				});
				break;

			case "del":
				var data = grid.getCheckedData();
				console.log(data);
				if (data.length <= 0) {
					Message.alert('선택된 항목이 없습니다.');
					return;
				}

				Message.confirm('내가산 주식을 삭제하시겠습니까?', function() {
					var param = {
						brRq : 'IN_DATA',
						brRs : '',
						IN_DATA : data
					}
					_this.send('BR_STCK_SELL_RM', param, function(data) {
						if(data) {
							Message.alert('내가 판 주식이 삭제되었습니다.', function() {
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