<script>
  var KIW_0100 = function () {
    var _this = this;
    var searchForm = new PgmForm(_this, "search_area");
    var columns = [
      { name: "주문/체결시간", id: "curr_time", field: "curr_time" },
      { name: "계좌번호", id: "acct_num", field: "acct_num", editor: Slick.Editors.Text },
      { name: "주문번호", id: "order_num", field: "order_num" },
      { name: "종목코드", id: "stock_cd", field: "stock_cd" },
      { name: "주문업무분류", id: "order_business_classification", field: "order_business_classification" },
      { name: "주문상태", id: "order_status", field: "order_status" },
      { name: "주문수량", id: "order_qty", field: "order_qty" },
      { name: "주문가격", id: "order_amt", field: "order_amt" },
      { name: "미체결수량", id: "not_contract_qty", field: "not_contract_qty" },
      { name: "체결누계금액", id: "contract_tot_amt", field: "contract_tot_amt" },
      { name: "원주문번호", id: "ongn_order_num", field: "ongn_order_num" },
      { name: "주문구분(+현금내수, -현금매도…)", id: "order_gubun", field: "order_gubun" },
      { name: "매매구분(보통, 시장가…)", id: "trade_gubun", field: "trade_gubun" },
      { name: "매도수구분(1:매도, 2:매수)", id: "order_type", field: "order_type" },
      { name: "체결번호", id: "contract_num", field: "contract_num" },
      { name: "체결가", id: "contract_amt", field: "contract_amt" },
      { name: "체결수량", id: "contract_qty", field: "contract_qty" },
      { name: "현재가", id: "curr_amt", field: "curr_amt" },
      { name: "(최우선)매도호가", id: "offered_amt", field: "offered_amt" },
      { name: "(최우선)매수호가", id: "bid_amt", field: "bid_amt" },
      { name: "단위체결가", id: "contract_amt_unit", field: "contract_amt_unit" },
      { name: "단위체결량", id: "contract_amt_qty", field: "contract_amt_qty" },
      { name: "당일매매수수료", id: "today_commission", field: "today_commission" },
      { name: "당일매매세금", id: "today_tax", field: "today_tax" },
      { name: "화면번호", id: "screen_num", field: "screen_num" },
      { name: "터미널번호", id: "terminal_num", field: "terminal_num" },
      { name: "신용구분", id: "credit_gubun", field: "credit_gubun" },
      { name: "대출일", id: "loan_dt", field: "loan_dt" },
      { name: "등록일", id: "crt_dtm", field: "crt_dtm" },
    ];

    var options = {
      editable: false /*수정여부*/,
      enableAddRow: false /*행 추가 여부*/,
      autoResize: true
    };

    var grid = new GridMngr(_this, "grid", columns, options);
    grid.showTotalSummary(["order_amt"]);
    grid.build();

    /*조회버튼*/
    searchForm.addEvent("search", "click", function (e) {
      var param = {
        stock_cd: searchForm.get("stock_cd").val(),
      };
      grid.LoadData("chejan_order_data", param);
    });
    searchForm.get("search").trigger("click");
  }

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