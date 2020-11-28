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
</script>
<div id="{{.uuid}}">
  <div name="search_area">
    <table>
      <tr>
        <td>종목</td>
        <td><input type="text" name="stock_cd" /></td>
        <td><input type="button" name="search" value="조회" /></td>
      </tr>
    </table>
  </div>

  <div name="grid"></div>
</div>
{{include "templates/footer" }}