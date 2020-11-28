<script>
  var KIW_1200 = function () {
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
      { name: "구매일자", id: "purchase_dt", field: "purchase_dt" },
      { name: "계좌번호", id: "acct_num", field: "acct_num" },
      { name: "종목코드", id: "stock_cd", field: "stock_cd" },
      { name: "현재가", id: "curr_amt", field: "curr_amt" },
      { name: "매입가", id: "purchase_amt", field: "purchase_amt" },
      { name: "매입금액", id: "tot_purchase_amt", field: "tot_purchase_amt" },
      { name: "보유수량", id: "possession_qty", field: "possession_qty" },
      { name: "당일매도손익", id: "today_sell_profit_loss", field: "today_sell_profit_loss" },
      { name: "당일매매수수료", id: "today_commission", field: "today_commission" },
      { name: "당일매매세금", id: "today_tax", field: "today_tax" },
      { name: "신용구분", id: "credit_gubun", field: "credit_gubun" },
      { name: "대출일", id: "loan_dt", field: "loan_dt" },
      { name: "결제잔고", id: "payment_balance", field: "payment_balance" },
      { name: "청산가능수량", id: "sellable_qty", field: "sellable_qty" },
      { name: "신용금액", id: "credit_amt", field: "credit_amt" },
      { name: "신용이자", id: "credit_interest", field: "credit_interest" },

      { name: "만기일", id: "expiry_dt", field: "expiry_dt" },
      { name: "평가손익", id: "valuation_profit_loss", field: "valuation_profit_loss" },
      { name: "수익률", id: "earnings_rt", field: "earnings_rt" },
      { name: "평가금액", id: "evaluated_amt", field: "evaluated_amt" },
      { name: "수수료", id: "commission", field: "commission" },
      { name: "매도수수료", id: "selling_commission", field: "selling_commission" },
      { name: "매입수수료", id: "buying_commission", field: "buying_commission" },
      { name: "매도세금", id: "selling_tax", field: "selling_tax" },

      { name: "손익분기매입가", id: "will_profit_amt", field: "will_profit_amt" },
      { name: "손익금액", id: "not_commission_profit_loss", field: "not_commission_profit_loss" },
      { name: "손익율", id: "profit_loss_rt", field: "profit_loss_rt" },
      { name: "주문상태", id: "order_status", field: "order_status" },
      { name: "등록일", id: "crt_dtm", field: "crt_dtm" }
    ];

    var options = {
      editable: false /*수정여부*/,
      enableAddRow: false /*행 추가 여부*/,
      forceFitColumns: false,
      topPanelHeight: 25,
      autoResize: true
    };

    var grid = new GridMngr(_this, "grid", columns, options);
    grid.showTotalSummary(["curr_amt"]);
    grid.build();

    /*조회버튼*/
    searchForm.addEvent("search", "click", function (e) {
      var param = {
        stock_cd: searchForm.get("stock_cd").val(),
      };
      grid.LoadData("opt10085_data", param);
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