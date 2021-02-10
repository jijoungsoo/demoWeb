
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
	    
	    var datepicker = new tui.DatePicker(popupForm.get("SELL_DATE_CAL")[0]  /*달력이표시될 div*/, {
	        date: new Date(),
	        input: {
	          element: popupForm.get("SELL_DATE")[0]  /*값이 실제로 입력될 input*/,
	          format: 'yyyy-MM-dd hh:mm A'
	        },
	        timePicker: true,
	        language: 'ko'
	    });
	    datepicker._element.style="z-index:100"; //위로 올리기 잘리는 효과 제거
	    
	    
/*
	    PjtUtil.setMaskNumber(popupForm.get("AMT")[0]);
	    PjtUtil.setMaskNumber(popupForm.get("CNT")[0]);
	    PjtUtil.setMaskNumber(popupForm.get("TOT_AMT")[0]);
	    PjtUtil.setMaskNumber(popupForm.get("BAL_CNT")[0]);
	    PjtUtil.setMaskNumber(popupForm.get("BAL_TOT_AMT")[0]);
	    PjtUtil.setMaskNumber(popupForm.get("SELL_AMT")[0]);
	    PjtUtil.setMaskNumber(popupForm.get("SELL_CNT")[0]);
	    PjtUtil.setMaskNumber(popupForm.get("SELL_TOT_AMT")[0]);
*/		
		var grid_summary = {
			height: 40,
			position: 'bottom', // or 'top'
			columnContent: {
				AMT: {
				  template: function(valueMap) {
				    return `MAX: \${PjtUtil.numberComma(valueMap.max)}<br>MIN: \${PjtUtil.numberComma(valueMap.min)}`;
				  }
				},
				FEE: {
				   template: function(valueMap) {
				   	 /*여기서 다른 값들을 판단할 방법이 없다.
				   	 setSummaryColumnContent(columnName, columnContent) 이걸로 셋하고
				   	getSummaryValues(columnName) 이걸로 겟하고
				   	
				   	filter가 적용되어도 아래쪽 써머리가 변경되지 않는다.
				   	그리드의 row 갯수를 세어서 계산하는 로직을 별도로 빼야할것 같다.
				   	그리고 실제로 이 구문을 페이지소스에 넣으면 너무 코드가 길어지므로
				   	라이브러리로 빼자
				   	
				   	내가 이걸 찾은 이유는 2개의 써머리 값을 비교해서 색깔을 다르게 해주고 
				   	싶었기 때문이다.
				   	
				   	 */
				     return `\${PjtUtil.numberComma(valueMap.sum)}`;
				   }
				},
				TOT_AMT: {
				  template: function(valueMap) {
				    return `\${PjtUtil.numberComma(valueMap.sum)}`;
				  }
				},
				TOT_BAL_CURR_AMT: {
				   template: function(valueMap) {
				     return `\${PjtUtil.numberComma(valueMap.sum)}`;
				   }
				},
				TOT_DIFF_BAL_AMT: {
				  template: function(valueMap) {
				    return `\${PjtUtil.numberComma(valueMap.sum)}`;
				  }
				},
				TOT_BAL_AMT: {
				  template: function(valueMap) {
				    return `\${PjtUtil.numberComma(valueMap.sum)}`;
				  }
				},
				TOT_BNFT_RT: {
				  template: function(valueMap) {
				    return `\${PjtUtil.numberComma(valueMap.avg)}`;
				  }
				}
			}
		}
		const grid = new TuiGridMngr(_this, 'grid',
		{
			editable : true,
			showRowStatus : true,
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
				name : 'BUY_SEQ',
				width : 60,
				resizable : false,
				sortable : true,
				sortingType : 'desc'
			},{
				header : '주식코드',
				name : 'STOCK_CD',
				width : 60,
				resizable : false,
				sortable : true,
				sortingType : 'desc',
				validation : {
					dataType : 'string', /*string ,number*/
					required : true, /*  true 필수, false 필수아님  */
				}
			}, {
				header : '주식명',
				name : 'STOCK_NM',
				width : 100,
				sortable : true,
				filter : {
					type : 'text',
					showApplyBtn : true,
					showClearBtn : true
				},
				validation : {
					dataType : 'string', /*string ,number*/
					required : true, /*  true 필수, false 필수아님  */
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
				editor : 'text',
				validation : {
					dataType : 'string', /*string ,number*/
					required : true, /*  true 필수, false 필수아님  */
				}
			}, {
				header : '현재가',
				name : 'CURR_AMT',
				renderer : {
					type: commaStRenderer,
					options : {
						src : 'BUY_AMT',
						tgt : 'CURR_AMT'
					}
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
						tgt : 'CURR_AMT'
					}
				},
				width : 80,
				sortable : true,
				align : "right",
				sortingType : 'desc',
				editor : 'text'
			}, {				
				header : '수익비율',
				name : 'BNFT_RT',
				renderer : {
					type: commaStRenderer,
					options : {
						src : 'BUY_AMT',
						tgt : 'CURR_AMT'
					}
				},
				width : 80,
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
				width : 80,
				sortable : true,
				align : "right",
				sortingType : 'desc',
				editor : 'text',
				validation : {
					dataType : 'number', /*string ,number*/
					required : true, /*  true 필수, false 필수아님  */
				}
			}, {
				header : '팔기',
				name : 'BTN_SELL',
				renderer : {
					type: buttonRenderer,
					options : {
						txt : '팔기',
						fn : function(el,data){
							  var row_data=data.grid.getRow(data.rowKey);
						        if(row_data.BAL_CNT==0){
						        	$(el).hide();
						        }
						        
						}
					}
				},
				width : 60,
				sortable : true,
				align : "center"
			}, {
				header : '잔고갯수',
				name : 'BAL_CNT',
				renderer : {
					type: commaRenderer
				},
				width : 80,
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
				name : 'TOT_AMT',
				renderer : {
					type: commaRenderer
				},
				width : 120,
				sortable : true,
				align : "right",
				sortingType : 'desc',
				editor : 'text'
			}, {
				header : '총잔액금액',
				name : 'TOT_BAL_AMT',
				renderer : {
					type: commaRenderer
				},
				width : 120,
				sortable : true,
				align : "right",
				sortingType : 'desc',
				editor : 'text'
			}, {
				header : '총잔액현재금액',
				name : 'TOT_BAL_CURR_AMT',
				renderer : {
					type: commaStRenderer,
					options : {
						src : 'TOT_BAL_AMT',
						tgt : 'TOT_BAL_CURR_AMT'
					}
				},
				width : 120,
				sortable : true,
				align : "right",
				sortingType : 'desc',
				editor : 'text'
			}, {
				header : '총잔액차감액',
				name : 'TOT_DIFF_BAL_AMT',
				renderer : {
					type: commaStRenderer,
					options : {
						src : 'TOT_BAL_AMT',
						tgt : 'TOT_BAL_CURR_AMT'
					}
				},
				width : 120,
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
				width : 120,
			    editor: {
			      type: 'datePicker',
			      options: {
			        format: 'yyyyMMddHHmm',
			        timepicker: true,
			        language: 'ko',
			        usageStatistics: false
			        
			      }
			    },
				validation : {
					dataType : 'string', /*string ,number*/
					required : true, /*  true 필수, false 필수아님  */
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
			        		grid.setValue(rowKey, "BUY_AMT", data.CLS_AMT)
			        		
			        		
			        	}
			        });
					
				}
			}
			
			
		});
		grid.on('click', (ev) => {
			if (ev.rowKey >=0) {
				if(ev.columnName=="BTN_SELL"){
					var row_data=grid.getRow(ev.rowKey);
					
					if(row_data.BAL_CNT==0) {
						return;	
					}

					var BAL_CNT 		 = row_data.BAL_CNT
					var AMT 			 = row_data.AMT
					row_data.BAL_TOT_AMT = (BAL_CNT * AMT);
					var SELL_CNT 		 = BAL_CNT;
					row_data.SELL_AMT 	 = AMT;
					row_data.SELL_CNT    = SELL_CNT;
					row_data.SELL_TOT_AMT= (SELL_CNT * AMT);
					row_data.SELL_TAX		 = String(0);
					row_data.SELL_FEE		 = String(0);
					row_data.SELL_DATE		 = moment(new Date()).format("yyyy-MM-DD hh:mm A");
					
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
			        		popupForm.clearData()
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
					|| ev.columnName=="BUY_AMT"
						|| ev.columnName=="FEE"
				){
					var rowKey = ev.rowKey ;
					var row_data=grid.getRow(ev.rowKey);
					var cnt = row_data["CNT"];
					var buy_amt = row_data["BUY_AMT"];
					if(!PjtUtil.isNumeric(cnt)){
						cnt=0;
					}
					
					if(!PjtUtil.isNumeric(buy_amt)){
						buy_amt=0;
					}
					
					var tot_amt = (cnt*buy_amt);
					console.log(tot_amt);
					grid.setValue(rowKey, "TOT_AMT", tot_amt)
				}
				if(ev.columnName=="CNT"){
					var cnt = row_data["CNT"];
					grid.setValue(rowKey, "BAL_CNT", cnt);
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
					brRq : '',
					brRs : 'OUT_DATA'
				}
				grid.loadData('BR_STCK_BUY_FIND',param,function(data) {
					console.log(data);
					
					/*로딩이 되면 summary를 변경한다.*/
					var arr_TOT_BAL_AMT= grid.getSummaryValues("TOT_BAL_AMT");
					var arr_TOT_BAL_CURR_AMT= grid.getSummaryValues("TOT_BAL_CURR_AMT");
					var arr_TOT_DIFF_BAL_AMT= grid.getSummaryValues("TOT_DIFF_BAL_AMT");
					var arr_TOT_BNFT_RT= grid.getSummaryValues("TOT_BNFT_RT");
					
					console.log(arr_TOT_BAL_CURR_AMT);
					console.log(arr_TOT_BNFT_RT);
					if(arr_TOT_BAL_AMT.sum>arr_TOT_BAL_CURR_AMT.sum){
						grid.setSummaryColumnContent("TOT_BAL_CURR_AMT",{
							  template: function(valueMap) {
								    return `<div class="st_dn_amt">\${PjtUtil.numberComma(arr_TOT_DIFF_BAL_AMT.sum)}</div>`;
								  }
								});
					} else if(arr_TOT_BAL_AMT.sum<arr_TOT_BAL_CURR_AMT.sum) {
						grid.setSummaryColumnContent("TOT_BAL_CURR_AMT",{
							  template: function(valueMap) {
								  return `<div class="st_up_amt">\${PjtUtil.numberComma(arr_TOT_DIFF_BAL_AMT.sum)}</div>`;
								  }
								});
					}
					if(arr_TOT_BAL_AMT.sum>arr_TOT_BAL_CURR_AMT.sum){
						grid.setSummaryColumnContent("TOT_DIFF_BAL_AMT",{
							  template: function(valueMap) {
								    return `<div class="st_dn_amt">\${PjtUtil.numberComma(arr_TOT_DIFF_BAL_AMT.sum)}</div>`;
								  }
								});
					} else if(arr_TOT_BAL_AMT.sum<arr_TOT_BAL_CURR_AMT.sum) {
						grid.setSummaryColumnContent("TOT_DIFF_BAL_AMT",{
						  template: function(valueMap) {
							    return `<div class="st_up_amt">\${PjtUtil.numberComma(arr_TOT_DIFF_BAL_AMT.sum)}</div>`;
							  }
							});
					}
					
					if(arr_TOT_BAL_AMT.sum>arr_TOT_BAL_CURR_AMT.sum){
						grid.setSummaryColumnContent("TOT_BNFT_RT",{
							  template: function(valueMap) {
								    return `<div class="st_dn_amt">\${PjtUtil.numberComma(arr_TOT_BNFT_RT.avg)}</div>`;
								  }
								});
					} else if(arr_TOT_BAL_AMT.sum<arr_TOT_BAL_CURR_AMT.sum) {
						grid.setSummaryColumnContent("TOT_BNFT_RT",{
							  template: function(valueMap) {
								    return `<div class="st_up_amt">\${PjtUtil.numberComma(arr_TOT_BNFT_RT.avg.toFixed(2))}</div>`;
								  }
								});
					}
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
			
				var crt_data=data.createdRows;
				var updt_data=data.updatedRows;
				

				Message.confirm('내가산 주식을 저장하시겠습니까?', function() {
					var param = {
						brRq : 'IN_DATA,UPDT_DATA',
						brRs : '',
						IN_DATA : crt_data,
						UPDT_DATA : updt_data
					}
					_this.send('BR_STCK_BUY_SAVE', param, function(data) {
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
					_this.send('BR_STCK_BUY_RM', param, function(data) {
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
					inline_popup.close();
					
					var data = popupForm.getData();
					
					/*날짜 데이터를 컨버전해줘야한다.
					BUY_DATE 는 14자리이다.
					UI에서는 아래와 같이 넘어온다.
					ex)  2021-01-13 12:00 AM
					202101131200   --이런식으로 변경해줘야함.
					var ed_dt = moment(new Date());
					var str_ed_dt = ed_dt.format("YYYYMMDD")
					*/
					data.SELL_DATE=moment(datepicker.getDate()).format("YYYYMMDDHHmm");
					
					var param = {
						brRq : 'IN_DATA',
						brRs : '',
						IN_DATA : [ {
							BUY_SEQ : data.BUY_SEQ,
							STOCK_CD : data.STOCK_CD,
							STOCK_NM : data.STOCK_NM,
							AMT : PjtUtil.removeComma(data.SELL_AMT),
							CNT : PjtUtil.removeComma(data.SELL_CNT),
							FEE : PjtUtil.removeComma(data.SELL_FEE),
							TAX : PjtUtil.removeComma(data.SELL_TAX),
							TOT_AMT : PjtUtil.removeComma(data.SELL_TOT_AMT),
							SELL_DATE : data.SELL_DATE,  
						} ],
					}
					_this.send('BR_STCK_SELL_CREATE', param, function(data) {
						if(data){
							Message.alert('저장되었습니다.', function() {
								searchForm.get("search").trigger("click");
								popupForm.clearData();
							});
						}
					});
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