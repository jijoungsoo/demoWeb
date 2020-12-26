<%
    String pgmId = (String) request.getAttribute("pgmId");
	String uuid = (String) request.getAttribute("uuid");
%>
<script>
$(document).ready(function(){
	var KIW_1100 = new PgmPageMngr ('<%=pgmId%>', '<%=uuid%>');
	KIW_1100.init(function(p_param) {
			var _this = KIW_1100;
			var searchForm = new FormMngr(_this, "search_area");

			const grid = new TuiGridMngr(_this, 'grid', {
				editable : true,
				showRowStatus : true,
				rowNum : true,
				checkbox : true,
				bodyHeight : 700 /*그리드 높이지정 */
				,
				showDummyRows : false
			},
			[ {
				header : '종목코드',
				name : 'STOCK_CD',
				width : 300,
				resizable : false,
				sortable : true,
				sortingType : 'desc', /*내림차순   ctrl 키를 누르고 정렬키를 여러개 누르면 이어서 정렬이 된다.*/
				filter : {
					type : 'text',
					showApplyBtn : true,
					showClearBtn : true
				}, /*text, number, select, date 4가지가 있다.*/
				validation : {
					dataType : 'string', /*string ,number*/
					required : true, /*  true 필수, false 필수아님  */
					unique : true
				/*true 데이터가 중복되면 빨간색 표시 */
				},
				editor : 'text'
			},
			{
				header : '종목명',
				name : 'STOCK_NM',
				width : 200,
				sortable : true,
				align : "center",
				sortingType : 'desc', /*내림차순   ctrl 키를 누르고 정렬키를 여러개 누르면 이어서 정렬이 된다.*/
				filter : {
					type : 'text',
					showApplyBtn : true,
					showClearBtn : true
				}, /*text, number, select, date 4가지가 있다.*/
				validation : {
					dataType : 'string', /*string ,number*/
					required : true, /*  true 필수, false 필수아님  */
					unique : true
				/*true 데이터가 중복되면 빨간색 표시 */
				},
				editor : 'text'
			},

			{
				header : '테이블명',
				name : 'TB_NM',
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
			},

			{
				header : '컬러명',
				name : 'COL_NM',
				width : 200,
				sortable : true,
				align : "center",
				sortingType : 'desc', /*내림차순   ctrl 키를 누르고 정렬키를 여러개 누르면 이어서 정렬이 된다.*/
				filter : {
					type : 'text',
					showApplyBtn : true,
					showClearBtn : true
				}, /*text, number, select, date 4가지가 있다.*/
				validation : {
					dataType : 'string', /*string ,number*/
					required : true /*  true 필수, false 필수아님  */
				},
				editor : 'text'
			}, {
				header : '초기값',
				name : 'INIT_VAL',
				width : 100,
				sortable : true,
				align : "center",
				sortingType : 'desc', /*내림차순   ctrl 키를 누르고 정렬키를 여러개 누르면 이어서 정렬이 된다.*/
				filter : {
					type : 'text',
					showApplyBtn : true,
					showClearBtn : true
				}, /*text, number, select, date 4가지가 있다.*/
				validation : {
					dataType : 'string', /*string ,number*/
					required : true /*  true 필수, false 필수아님  */
				},
				editor : 'text'
			}, {
				header : '증가값',
				name : 'ALLOCATION_SIZE',
				width : 100,
				resizable : false,
				sortable : true,
				sortingType : 'desc', /*내림차순   ctrl 키를 누르고 정렬키를 여러개 누르면 이어서 정렬이 된다.*/
				filter : {
					type : 'text',
					showApplyBtn : true,
					showClearBtn : true
				}, 
				editor : 'text'
			}, 












			  { name: "종목코드", id: "stock_cd", field: "stock_cd", width: 70, cssClass: "tac", sortable: true },
		      { name: "종목명", id: "stock_nm", field: "stock_nm", width: 200, cssClass: "tal", sortable: true },
		      { name: "현재가", id: "curr_amt", field: "curr_amt", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
		      { name: "시작가", id: "start_amt", field: "start_amt", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
		      { name: "고가", id: "high_amt", field: "high_amt", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
		      { name: "상장주식수", id: "stock_cnt", field: "stock_cnt", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
		      { name: "자본금", id: "capital_amt", field: "capital_amt", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
		      { name: "액면가", id: "face_amt", field: "face_amt", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
		      { name: "신용비율", id: "credit_rt", field: "credit_rt", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
		      { name: "결산월", id: "settlement_mm", field: "settlement_mm", width: 50, cssClass: "tac", sortable: true },
		      { name: "시가총액", id: "total_mrkt_amt", field: "total_mrkt_amt", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
		      { name: "시가총액비중", id: "total_mrkt_amt_rt", field: "total_mrkt_amt_rt", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
		      { name: "외인소진률", id: "foreigner_exhaustion_rt", field: "foreigner_exhaustion_rt", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
		      { name: "대용가", id: "substitute_amt", field: "substitute_amt", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
		      { name: "주가수익률", id: "per", field: "per", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
		      { name: "주당순이익", id: "eps", field: "eps", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
		      { name: "자기자본이익률", id: "roe", field: "roe", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
		      { name: "주가순자산비율", id: "pbr", field: "pbr", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },

		      { name: "이자비용,법인세비용, 감가상각비용을 공제하기 전의 이익", id: "ev", field: "ev", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
		      { name: "주당순자산가치", id: "bps", field: "bps", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
		      { name: "매출액", id: "sales", field: "sales", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
		      { name: "영업이익", id: "business_profits", field: "business_profits", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
		      { name: "D250최고", id: "d250_high_amt", field: "d250_high_amt", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
		      { name: "D250최저", id: "d250_low_amt", field: "d250_low_amt", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },

		      { name: "예상체결가", id: "expectation_contract_amt", field: "expectation_contract_amt", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
		      { name: "예상체결수량", id: "expectation_contract_qty", field: "expectation_contract_qty", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
		      { name: "D250최고가일", id: "d250_high_dt", field: "d250_high_dt", cssClass: "tac", sortable: true },
		      { name: "D250최고가대비율", id: "d250_high_rt", field: "d250_high_rt", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
		      { name: "대비기호", id: "contrast_symbol", field: "contrast_symbol", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
		      { name: "전일대비", id: "contrast_yesterday", field: "contrast_yesterday", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
		      { name: "등락율", id: "fluctuation_rt", field: "fluctuation_rt", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
		      { name: "거래량", id: "trade_qty", field: "trade_qty", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
		      { name: "거래대비", id: "trade_contrast", field: "trade_contrast", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
		      { name: "생성일자", id: "crt_dtm", field: "crt_dtm", sortable: true },
		      { name: "D250최저가일", id: "d250_low_dt", field: "d250_low_dt", cssClass: "tac", sortable: true },
		      { name: "액면가단위", id: "face_amt_unit", field: "face_amt_unit", cssClass: "tac", sortable: true }
		    ];



			

			{
				header : '생성일',
				name : 'CRT_DTM',
				renderer : {
					type : datetimeRenderer,
					options : {
						format : 'yyyy-MM-DD HH:mm' /*YYYYMMDDHHmmss    이게 풀양식이다.*/
						,
						source : 'YYYYMMDDHHmmss' /*TIME 초, YYYYMMDD , YYYYMMDDHHmm,  YYYYMMDDHHmmss  */
					}
				},
				width : 120,
				sortable : true,
				align : "center",
				filter : {
					type : 'date',
					format : 'yyyy-MM-DD'
				/*'yyyy-MM-dd HH:mm A'*/
				/*실제 데이터랑 비교하나보다 .. 비교가 안된다. */
				}
			}, {
				header : '수정일',
				name : 'UPDT_DTM',
				renderer : {
					type : datetimeRenderer,
					options : {
						format : 'yyyy-MM-DD HH:mm' /*YYYYMMDDHHmmss    이게 풀양식이다.*/
						,
						source : 'YYYYMMDDHHmmss' /*TIME 초, YYYYMMDD , YYYYMMDDHHmm,  YYYYMMDDHHmmss  */
					}
				},
				width : 120,
				sortable : true,
				align : "center"
			/*,  filter: 'number'  숫자일경우 비교 */
			} ]
			);
			grid.build();

			searchForm.addEvent("click","input[type=button]", function(el) {
				switch (el.target.name) {
				case 'search':
					var param = {
						brRq : 'IN_DATA',
						brRs : 'OUT_DATA',
						IN_DATA : [ {} ]
					}
					grid.loadData('findCmSeq', param, function(data) {
						console.log(data);
						//gridLoadData에서 자동으로 로드됨..

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
				
					Message.confirm('저장하시겠습니까?', function() {
						var param = {
							brRq : 'IN_DATA,UPDT_DATA',
							brRs : '',
							IN_DATA : data.createdRows,
							UPDT_DATA : data.updatedRows
						}
						_this.send('saveCmSeq', param, function(data) {
							Message.alert('저장되었습니다.', function() {
								searchForm.get("search").trigger("click");
							});
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
					
					Message.confirm('삭제하시겠습니까?', function() {
						var param = {
							brRq : 'IN_DATA',
							brRs : '',
							IN_DATA : data
						}
						_this.send('rmCmSeq', param, function(data) {
							Message.alert('삭제되었습니다.', function() {
								searchForm.get("search").trigger("click");
							});
						});
					});
					break;
				}
			});
			searchForm.get("search").trigger("click");
		});
	});
</script>

<script>
var KIW_1100 = function () {
    var _this = this;
    var searchForm = new PgmForm(_this, "search_area");
    var columns = [
      {
        name: "#",
        formatter: function (row) {
          return row + 1;
        },
        behavior: "select",
        cssClass: "cell-selection",
        width: 60,
        cannotTriggerInsert: true,
        resizable: false,
        selectable: false,
        excludeFromColumnPicker: true,
      },


      { name: "종목코드", id: "stock_cd", field: "stock_cd", width: 70, cssClass: "tac", sortable: true },
      { name: "종목명", id: "stock_nm", field: "stock_nm", width: 200, cssClass: "tal", sortable: true },
      { name: "현재가", id: "curr_amt", field: "curr_amt", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
      { name: "기준가(어제가격-tb_stock)", id: "last_price", field: "last_price", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
      { name: "기준가(어제가격)", id: "yesterday_amt", field: "yesterday_amt", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
      { name: "시작가", id: "start_amt", field: "start_amt", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
      { name: "고가", id: "high_amt", field: "high_amt", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
      { name: "상한가", id: "upper_amt_lmt", field: "upper_amt_lmt", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
      { name: "하한가", id: "lower_amt_lmt", field: "lower_amt_lmt", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
      { name: "연중최고", id: "year_high_amt", field: "year_high_amt", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
      { name: "연중최저", id: "year_low_amt", field: "year_low_amt", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
      { name: "상장주식수", id: "stock_cnt", field: "stock_cnt", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
      { name: "자본금", id: "capital_amt", field: "capital_amt", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
      { name: "액면가", id: "face_amt", field: "face_amt", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
      { name: "신용비율", id: "credit_rt", field: "credit_rt", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
      { name: "결산월", id: "settlement_mm", field: "settlement_mm", width: 50, cssClass: "tac", sortable: true },
      { name: "시가총액", id: "total_mrkt_amt", field: "total_mrkt_amt", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
      { name: "시가총액비중", id: "total_mrkt_amt_rt", field: "total_mrkt_amt_rt", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
      { name: "외인소진률", id: "foreigner_exhaustion_rt", field: "foreigner_exhaustion_rt", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
      { name: "대용가", id: "substitute_amt", field: "substitute_amt", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
      { name: "주가수익률", id: "per", field: "per", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
      { name: "주당순이익", id: "eps", field: "eps", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
      { name: "자기자본이익률", id: "roe", field: "roe", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
      { name: "주가순자산비율", id: "pbr", field: "pbr", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },

      { name: "이자비용,법인세비용, 감가상각비용을 공제하기 전의 이익", id: "ev", field: "ev", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
      { name: "주당순자산가치", id: "bps", field: "bps", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
      { name: "매출액", id: "sales", field: "sales", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
      { name: "영업이익", id: "business_profits", field: "business_profits", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
      { name: "D250최고", id: "d250_high_amt", field: "d250_high_amt", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
      { name: "D250최저", id: "d250_low_amt", field: "d250_low_amt", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },

      { name: "예상체결가", id: "expectation_contract_amt", field: "expectation_contract_amt", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
      { name: "예상체결수량", id: "expectation_contract_qty", field: "expectation_contract_qty", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
      { name: "D250최고가일", id: "d250_high_dt", field: "d250_high_dt", cssClass: "tac", sortable: true },
      { name: "D250최고가대비율", id: "d250_high_rt", field: "d250_high_rt", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
      { name: "대비기호", id: "contrast_symbol", field: "contrast_symbol", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
      { name: "전일대비", id: "contrast_yesterday", field: "contrast_yesterday", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
      { name: "등락율", id: "fluctuation_rt", field: "fluctuation_rt", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
      { name: "거래량", id: "trade_qty", field: "trade_qty", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
      { name: "거래대비", id: "trade_contrast", field: "trade_contrast", cssClass: "tar", sortable: true, formatter: Slick.Formatters.MoneyFormatter },
      { name: "생성일자", id: "crt_dtm", field: "crt_dtm", sortable: true },
      { name: "D250최저가일", id: "d250_low_dt", field: "d250_low_dt", cssClass: "tac", sortable: true },
      { name: "액면가단위", id: "face_amt_unit", field: "face_amt_unit", cssClass: "tac", sortable: true }
    ];

    var options = {
      editable: false /*수정여부*/,
      enableAddRow: false /*행 추가 여부*/,
      topPanelHeight: 25,
      autoResize: false,
      showTotalSummary: true
    };

    var grid = new GridMngr(_this, "grid", columns, options);
    grid.showTotalSummary(["curr_amt"]);
    grid.build();

    grid.onClick(function (e, args, p_grid) {
      var cell = p_grid.getCellFromEvent(e);
      if (p_grid.getColumns()[cell.cell].id == "stock_cd") {
        if (!p_grid.getEditorLock().commitCurrentEdit()) {
          return;
        }
        var rd = grid.dataView.getItem(cell.row);
        //rd.stock_cd;
        var param = {
          stock_cd: rd.stock_cd
        }
        var popup = new PopupManger("{{.uuid}}", 'stock_detail', {
          width: 1100,
          heght: 700
        },
          param
        );
        popup.open();
        //data[cell.row].priority = states[data[cell.row].priority];
        e.stopPropagation();
      }
    });

    /*조회버튼*/
    searchForm.addEvent("search", "click", function (e) {
      var param = {
        stock_cd: searchForm.get("stock_cd").val(),
      };
      grid.LoadData("opt10001_data", param);
    });

    searchForm.get("search").trigger("click");
  };