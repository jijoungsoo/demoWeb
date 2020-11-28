<script>
  /*조회버튼*/
  alert("ddddd");
  $("#{{.uuid}}-order").on("click", function (e) {
    e.preventDefault();
    alert("조회");
    var param = {
      rq_name: $("#{{.uuid}}-rq_name").val(),
      acct_num: $("#{{.uuid}}-acct_num").val(),
      order_type: $("#{{.uuid}}-order_type").val(),
      stock_cd: $("#{{.uuid}}-stock_cd").val(),
      qty: $("#{{.uuid}}-qty").val(),
      amt: $("#{{.uuid}}-amt").val(),
      hoga_gubun: $("#{{.uuid}}-hoga_gubun").val(),
      orgn_order_no: $("#{{.uuid}}-orgn_order_no").val(),
    };
    send_post_ajax("external_send_order",param)
  });
</script>
<div id="{{.uuid}}">
  <table>
    <tr>
      <td>주문제목</td>
      <td><input type="text" id="{{.uuid}}-rq_name" value="GO주문" /></td>
    </tr>
    <tr>
      <td>계좌번호</td>
      <td><input type="text" id="{{.uuid}}-acct_num" value="8132761911" /></td>
    </tr>
    <tr>
      <td>주문유형
        <pre>
        comboSourceSendOrderNOrderType.Add(1, "(1)신규매수");
        comboSourceSendOrderNOrderType.Add(2, "(2)신규매도");
        comboSourceSendOrderNOrderType.Add(3, "(3)매수취소");
        comboSourceSendOrderNOrderType.Add(4, "(4)매도취소");
        comboSourceSendOrderNOrderType.Add(5, "(5)매수정정");
        comboSourceSendOrderNOrderType.Add(6, "(6)매도정정");
      </pre>
      </td>
      <td><input type="text" id="{{.uuid}}-order_type" value="1" /></td>
    </tr>
    <tr>
      <td>종목코드</td>
      <td><input type="text" id="{{.uuid}}-stock_cd" value="005930" /></td>
    </tr>
    <tr>
      <td>주문수량</td>
      <td><input type="text" id="{{.uuid}}-qty" value="2" /></td>
    </tr>
    <tr>
      <td>가격</td>
      <td><input type="text" id="{{.uuid}}-amt" value="500" /></td>
    </tr>
    <tr>
      <td>거래구분
      <pre>
        comboSourceSendOrderSHogaGb.Add("00", "(00)지정가");
        comboSourceSendOrderSHogaGb.Add("03", "(03)시장가");
        comboSourceSendOrderSHogaGb.Add("05", "(05)조건부지정가");
        comboSourceSendOrderSHogaGb.Add("06", "(06)최유리지정가");
        comboSourceSendOrderSHogaGb.Add("07", "(07)최우선지정가");
        comboSourceSendOrderSHogaGb.Add("10", "(10)지정가IOC");
        comboSourceSendOrderSHogaGb.Add("13", "(13)시장가IOC");
        comboSourceSendOrderSHogaGb.Add("16", "(16)최유리IOC");
        comboSourceSendOrderSHogaGb.Add("20", "(20)지정가FOK");
        comboSourceSendOrderSHogaGb.Add("23", "(23)시장가FOK");
        comboSourceSendOrderSHogaGb.Add("26", "(26)최유리FOK");
        comboSourceSendOrderSHogaGb.Add("61", "(61)지정가IOC");
        comboSourceSendOrderSHogaGb.Add("81", "(81)지정가IOC");

      </pre>

      </td>
      <td><input type="text" id="{{.uuid}}-hoga_gubun" value="03" /></td>
    </tr>
    <tr>
      <td>원주문번호</td>
      <td><input type="text" id="{{.uuid}}-orgn_order_no" /></td>
    </tr>
    <tr>
      <td>주문</td>
      <td><input type="button" value="주문" id="{{.uuid}}-order" /></td>
    </tr>
  </table>
</div>
