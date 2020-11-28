<script>
  var KIW_0300 = function () {
    var _this = this;
    var searchForm = new PgmForm(_this, "search_area");
    var columns = [
      { name: "종목", id: "stock_cd", field: "stock_cd" },
      { name: "일자", id: "stock_dt", field: "stock_dt", editor: Slick.Editors.Text },
      { name: "현재가", id: "curr_amt", field: "curr_amt" },
      { name: "분봉", id: "mm", field: "mm" },
      { name: "시간", id: "curr_time", field: "curr_time" },
      { name: "시작가", id: "start_amt", field: "start_amt" },
      { name: "고가", id: "high_amt", field: "high_amt" },
      { name: "저가", id: "low_amt", field: "low_amt" },
      { name: "매수거래량", id: "offered_trade_qty", field: "offered_trade_qty" },
      { name: "매도거래량", id: "bid_trade_qty", field: "bid_trade_qty" },
      { name: "cnt", id: "cnt", field: "cnt" },
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
      grid.LoadData("realtime_contract_data", param);
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