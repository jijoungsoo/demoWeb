<script>
  var KIW_0200 = function () {
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
      { name: "계좌번호", id: "acct_num", field: "acct_num" },
      { name: "종목코드", id: "stock_cd", field: "stock_cd" },
      { name: "현재가", id: "curr_amt", field: "curr_amt" },
      { name: "보유수량", id: "possession_qty", field: "possession_qty" },
      { name: "매입단가", id: "purchase_amt", field: "purchase_amt" },
      { name: "총매입가", id: "tot_purchase_amt", field: "tot_purchase_amt" },
      { name: "주문가능수량", id: "order_possible_qty", field: "order_possible_qty" },
      { name: "당일순매수량", id: "today_net_buy_qty", field: "today_net_buy_qty" },
      { name: "매도/매수구분", id: "order_type", field: "order_type" },
      { name: "당일 총 매도 손익", id: "today_sell_profit_loss", field: "today_sell_profit_loss" },
      { name: "예수금", id: "deposit", field: "deposit" },
      { name: "(최우선)매도호가", id: "offered_amt", field: "offered_amt" },
      { name: "(최우선)매수호가", id: "bid_amt", field: "bid_amt" },
      { name: "기준가(어제종가)", id: "yesterday_amt", field: "yesterday_amt" },
      { name: "손익율", id: "profit_loss_rt", field: "profit_loss_rt" },
      { name: "신용금액", id: "credit_amt", field: "credit_amt" },

      { name: "신용이자", id: "credit_interest", field: "credit_interest" },
      { name: "만기일", id: "expiry_dt", field: "expiry_dt" },
      { name: "당일실현손익(유가)", id: "today_profit_loss_amt", field: "today_profit_loss_amt" },
      { name: "당일실현손익률(유가)", id: "today_profit_loss_rt", field: "today_profit_loss_rt" },
      { name: "당일실현손익(신용)", id: "credit_today_profit_loss_amt", field: "credit_today_profit_loss_amt" },
      { name: "당일실현손익률(신용)", id: "credit_today_profit_loss_rt", field: "credit_today_profit_loss_rt" },
      { name: "담보대출수량", id: "loan_qty", field: "loan_qty" },
      { name: "대출일", id: "loan_dt", field: "loan_dt" },
      { name: "신용구분", id: "credit_gubun", field: "credit_gubun" }
    ];

    var options = {
      editable: false /*수정여부*/,
      enableAddRow: false /*행 추가 여부*/,
    };
    var grid = new GridMngr(_this, "grid", columns, options);
    grid.showTotalSummary(["curr_amt"]);
    grid.build();

    /*조회버튼*/
    searchForm.addEvent("search", "click", function (e) {
      var param = {
        stock_cd: searchForm.get("stock_cd").val(),
      };
      grid.LoadData("chejan_order_data", param);
    });
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