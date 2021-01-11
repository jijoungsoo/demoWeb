
<%	String pgmId = (String) request.getAttribute("pgmId");
	String uuid = (String) request.getAttribute("uuid");
%>
<style>
.tui-grid-summary-area .tui-grid-cell {
    text-align: right;
}
</style>
<script>
$(document).ready(function(){
	var ST_2100 = new PgmPageMngr ('<%=pgmId%>', '<%=uuid%>');
	var inline_popup;
	ST_2100.init(function(p_param) {
		var _this = ST_2100;
		var searchForm = new FormMngr(_this,"search_area");
		var popupForm = new FormMngr(_this, "popup_sell");
	    $('[data-ax5formatter]').ax5formatter();
		
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
			editable : true,
			showRowStatus : true,
			rowNum : true,
			checkbox : false,
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
				header : '구매수',
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
				header : '팔기',
				name : 'BTN_SELL',
				renderer : {
					type: buttonRenderer,
					options : {
						txt : '팔기',
					}
				},
				width : 100,
				sortable : true,
				align : "center"
			}, {
				header : '잔고갯수',
				name : 'BAL_CNT',
				renderer : {
					type: commaRenderer
				},
				width : 100,
				sortable : true,
				align : "right",
				sortingType : 'desc'
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
				header : '총금액',
				name : 'TOT_AMT',
				renderer : {
					type: commaRenderer
				},
				width : 140,
				sortable : true,
				align : "right",
				sortingType : 'desc',
				editor : 'text'
			},{
			    header: '산날',
			    name: 'BUY_DATE',
			    renderer : {
					type: datetimeRenderer,
					options : {
						format : 'yyyy-MM-DD HH:mm A',
						source : 'YYYYMMDDHHmm'
					}
				},
				width : 140,
			    editor: {
			      type: 'datePicker',
			      options: {
			        format: 'yyyyMMddHHmm',
			        timepicker: true,
			        language: 'ko',
			        usageStatistics: false
			        
			      }
			    }
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
		
		grid.on('dblclick', (ev) => {
			if (ev.rowKey >=0) {
				if(ev.columnName=="STOCK_NM"
					|| ev.columnName=="STOCK_CD"
				){
					var rowKey = ev.rowKey ;
					var row_data=grid.getRow(ev.rowKey);
					console.log(row_data);
					var param = {
							STOCK_NM : row_data["STOCK_NM"]
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
			        		grid.setValue(rowKey, "STOCK_CD", data.STOCK_CD)
			        		grid.setValue(rowKey, "STOCK_NM", data.STOCK_NM)
			        		grid.setValue(rowKey, "AMT", data.CLS_AMT)
			        		
			        		
			        	}
			        });
					
				}
			}
			
			
		});
		grid.on('click', (ev) => {
			if (ev.rowKey >=0) {
				if(ev.columnName=="BTN_SELL"){
					var row_data=grid.getRow(ev.rowKey);
					console.log(row_data);
					var BAL_CNT = row_data.BAL_CNT
					var AMT = row_data.AMT
					row_data.BAL_TOT_AMT = (BAL_CNT * AMT);
					var SELL_CNT = BAL_CNT;
					row_data.SELL_AMT = AMT;
					row_data.SELL_CNT = SELL_CNT;
					row_data.SELL_TOT_AMT = (SELL_CNT * AMT);					
					popupForm.setDataAll(row_data);
					 $('[data-ax5formatter]').ax5formatter();
						inline_popup = new InlinePopupManger(_this, 'popup_sell', {
				          width: 500,
				          heght: 700,
				          title: "매도입력창"
				        });
						inline_popup.open(function(data){
				        	if(data){
				        		console.log(data);
				        	}
				        });
				}	
			}
		});
		
		grid.on('editingFinish', (ev) => {
			/*		수정이 완료된 후 
					rowKey			행번호	
					columnName      컬럼
					value			변경된 값
					instance		그리드 자체 grid
			*/
			if (ev.rowKey >=0) {
				if(ev.columnName=="CNT"
					|| ev.columnName=="AMT"
						|| ev.columnName=="FEE"
				){
					var rowKey = ev.rowKey ;
					var row_data=grid.getRow(ev.rowKey);
					console.log(ev.value);
					console.log(row_data);
					/*TOT_AMT 를 자동 계산하기 위해 사용
					value 는 잘 넘어오지만
					row_data로 다 하자.
					*/
					var cnt = row_data["CNT"];
					var amt = row_data["AMT"];
					if(!PjtUtil.isNumeric(cnt)){
						cnt=0;
					}
					
					if(!PjtUtil.isNumeric(amt)){
						amt=0;
					}
					
					var tot_amt = (cnt*amt);
					console.log(tot_amt);
					grid.setValue(rowKey, "TOT_AMT", tot_amt)
				}
				
			}
		});
		
		
		
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
				grid.loadData('findStckBuy',param,function(data) {
					console.log(data);
				});
				break;
			case 'add_row':
				Message.confirm('행을 추가하시겠습니까?', function() {
					grid.appendRow();
				});
				break;

			case 'save':
				var data = grid.getModifiedRows();
				console.log(data);
				var crt_cnt = data.createdRows.length;
				var updt_cnt = data.updatedRows.length;

				if ((crt_cnt + updt_cnt) == 0) {
					Message.alert("저장할 내용이 존재하지 않습니다.");
					return;
				}
				if (grid.isValid() == false) {
					grid.validMsg();
					return;
				}
				
				/*날짜 데이터를 컨버전해줘야한다.
				BUY_DATE 는 14자리이다.
				UI에서는 아래와 같이 넘어온다.
				ex)  2021-01-13 12:00 AM
				202101131200   --이런식으로 변경해줘야함.
				var ed_dt = moment(new Date());
				var str_ed_dt = ed_dt.format("YYYYMMDD")
				*/
				var crt_data=data.createdRows;
				
				var updt_data=data.updatedRows;
				

				Message.confirm('내가산 주식을 저장하시겠습니까?', function() {
					var param = {
						brRq : 'IN_DATA,UPDT_DATA',
						brRs : '',
						IN_DATA : crt_data,
						UPDT_DATA : updt_data
					}
					_this.send('saveStckBuy', param, function(data) {
						if(data){
							Message.alert('내가 산 주식이 저장되었습니다.', function() {
								searchForm.get("search").trigger("click");
							});
						}
					});
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
					_this.send('rmStckBuy', param, function(data) {
						if(data) {
							Message.alert('내가 산 주식이 삭제되었습니다.', function() {
								searchForm.get("search").trigger("click");
							});
						}
					});
				});
				break;
			}
		});
	
	
		popupForm.addEvent("keyup","input[name=SELL_AMT]",function(el) {
			var sell_amt =PjtUtil.removeComma(el.target.value);
			var data =  popupForm.getData();
			var sell_cnt = PjtUtil.removeComma(data.SELL_CNT);
			var sell_tot_amt = (parseInt(sell_amt) * parseInt(sell_cnt))
			popupForm.setData('SELL_TOT_AMT',sell_tot_amt);
			$('[data-ax5formatter]').ax5formatter();
		});
		
		popupForm.addEvent("keyup","input[name=SELL_CNT]",function(el) {
			var sell_cnt = PjtUtil.removeComma(el.target.value);
			var data =  popupForm.getData();
			var sell_amt = PjtUtil.removeComma(data.SELL_AMT);
			var sell_tot_amt = (parseInt(sell_amt) * parseInt(sell_cnt))
			popupForm.setData('SELL_TOT_AMT',sell_tot_amt);
			$('[data-ax5formatter]').ax5formatter();
		});
		
		popupForm.addEvent("click","input[type=button]", function(el) {
			switch (el.target.name) {
			case 'save':
				Message.confirm('매도정보를 저장하시겠습니까?', function() {
					alert("저장되었습니다.");
					inline_popup.close();
					searchForm.get("search").trigger("click");
				});
				break;

			case 'close':
				inline_popup.close();
				break;
			}
		});
	
		searchForm.get("search").trigger("click");
	});
});
</script>