<script>
  /*조회버튼*/
  var KIW_1400 = function (pgm_id,uuid,req) {
    console.log(req)
    var _this = this;
    var detailForm = new PgmForm(_this, "detail_area");
    var opt10001Form = new PgmForm(_this, "opt10001");

    var order_type = new SelectBoxMngr(detailForm,"order_type", "get_api_cm_cd", {
      grp_cd: "ORDER_TYPE"
    });

    var hoga_gubun = new SelectBoxMngr(detailForm,"hoga_gubun", "get_api_cm_cd", {
      grp_cd: "HOGA_GUBUN"
    });
    console.log('aaaa');
    console.log(req.stock_cd);

    detailForm.get("stock_cd").val(req.stock_cd);
    bind_one_ajax(opt10001Form, "Get_stock_code_info", {
      stock_cd: req.stock_cd
    }, function (data) {
      $('[data-ax5formatter]').ax5formatter();
    });


    detailForm.addEvent("order", "click", function (e) {
      var param = {
        rq_name: _this.get("rq_name").val(),
        acct_num: _this.get("acct_num").val(),
        order_type: _this.get("order_type").val(),
        stock_cd: _this.get("stock_cd").val(),
        qty: _this.get("qty").val(),
        amt: _this.get("amt").val(),
        hoga_gubun: _this.get("hoga_gubun").val(),
        orgn_order_no: _this.get("orgn_order_no").val(),
      };
      send_post_ajax("external_send_order", param)
    });
  }

</script>
<div id="{{.uuid}}" class="screen_detail">
  <div name="detail_area">
    <table>
      <tr>
        <td>주문제목</td>
        <td width="150"><input type="text" name="rq_name" value="GO주문" /></td>
      </tr>
      <tr>
        <td>계좌번호</td>
        <td><input type="text" name="acct_num" value="8132761911" /></td>
      </tr>
      <tr>
        <td>주문유형</td>
        <td>
          <select name="order_type" width="200"></select>
        </td>
      </tr>
      <tr>
        <td>종목코드</td>
        <td><input type="text" name="stock_cd" value="" /></td>
      </tr>
      <tr>
        <td>주문수량</td>
        <td><input type="text" name="qty" value="2" /></td>
      </tr>
      <tr>
        <td>가격</td>
        <td><input type="text" name="amt" value="500" /></td>
      </tr>
      <tr>
        <td>거래구분(호가구분)</td>
        <td>
          <select name="hoga_gubun" width="200"></select>
        </td>
      </tr>
      <tr>
        <td>원주문번호</td>
        <td><input type="text" name="orgn_order_no" /></td>
      </tr>
      <tr>
        <td>주문</td>
        <td><input type="button" value="주문" name="order" /></td>
      </tr>
    </table>
  </div>

  <div name="opt10001">
    <table>
      <tr>
        <td>액면가</td>
        <td><input type="text" name="face_amt" class="tal" data-ax5formatter="money"></td>
        <td>자본금</td>
        <td><input type="text" name="capital_amt" class="tal" data-ax5formatter="money"></td>
        <td>상장주식수</td>
        <td><input type="text" name="stock_cnt" class="tal" data-ax5formatter="money"></td>
        <td>신용비율(credit_rate)</td>
        <td><input type="text" name="credit_rt" class="tal" data-ax5formatter="money"></td>
        <td>결산월(02)</td>
        <td><input type="text" name="settlement_mm" class="tal" data-ax5formatter="money"></td>
      </tr>
      <tr>
        <td>연중최고</td>
        <td><input type="text" name="year_high_amt" class="tal" data-ax5formatter="money"></td>
        <td>연중최저</td>
        <td><input type="text" name="year_low_amt" class="tal" data-ax5formatter="money"></td>
        <td>시가총액</td>
        <td><input type="text" name="total_mrkt_amt" class="tal" data-ax5formatter="money"></td>
        <td>시가총액비중</td>
        <td><input type="text" name="total_mrkt_amt_rt" class="tal" data-ax5formatter="money"></td>
        <td>외인소진률</td>
        <td><input type="text" name="foreigner_exhaustion_rt" class="tal" data-ax5formatter="money"></td>
      </tr>
      <tr>
        <td>대용가</td>
        <td><input type="text" name="substitute_amt" class="tal" data-ax5formatter="money"></td>
        <td>주가수익률</td>
        <td><input type="text" name="per" class="tal" data-ax5formatter="money"></td>
        <td>주당순이익</td>
        <td><input type="text" name="eps" class="tal" data-ax5formatter="money"></td>
        <td>자기자본이익률</td>
        <td><input type="text" name="roe" class="tal" data-ax5formatter="money"></td>
        <td>주가순자산비율</td>
        <td><input type="text" name="pbr" class="tal" data-ax5formatter="money"></td>
      </tr>
      <tr>
        <td>이자비용,법인세비용, 감가상각비용을 공제하기 전의 이익</td>
        <td><input type="text" name="ev" class="tal" data-ax5formatter="money"></td>
        <td>주당순자산가치</td>
        <td><input type="text" name="bps" class="tal" data-ax5formatter="money"></td>
        <td>매출액</td>
        <td><input type="text" name="sales" class="tal" data-ax5formatter="money"></td>
        <td>영업이익</td>
        <td><input type="text" name="business_profits" class="tal" data-ax5formatter="money"></td>
        <td>D250최고</td>
        <td><input type="text" name="d250_high_amt" class="tal" data-ax5formatter="money"></td>
      </tr>
      <tr>
        <td>D250최저</td>
        <td><input type="text" name="d250_low_amt" class="tal" data-ax5formatter="money"></td>
        <td>시작가</td>
        <td><input type="text" name="start_amt" class="tal" data-ax5formatter="money"></td>
        <td>고가</td>
        <td><input type="text" name="high_amt" class="tal" data-ax5formatter="money"></td>
        <td>상한가</td>
        <td><input type="text" name="upper_amt_lmt" class="tal" data-ax5formatter="money"></td>
        <td>하한가</td>
        <td><input type="text" name="lower_amt_lmt" class="tal" data-ax5formatter="money"></td>
      </tr>
      <tr>
        <td>기준가(어제가격)</td>
        <td><input type="text" name="yesterday_curr_amt" class="tal" data-ax5formatter="money"></td>
        <td>예상체결가</td>
        <td><input type="text" name="expectation_contract_amt" class="tal" data-ax5formatter="money"></td>
        <td>예상체결수량</td>
        <td><input type="text" name="expectation_contract_qty" class="tal" data-ax5formatter="money"></td>
        <td>D250최고가일</td>
        <td><input type="text" name="d250_high_dt" class="tac"></td>
        <td>D250최고가대비율</td>
        <td><input type="text" name="d250_high_rt" class="tal" data-ax5formatter="money"></td>
      </tr>
      <tr>
        <td>현재가</td>
        <td><input type="text" name="curr_amt" class="tal" data-ax5formatter="money"></td>
        <td>대비기호</td>
        <td><input type="text" name="contrast_symbol" class="tal" data-ax5formatter="money"></td>
        <td>전일대비</td>
        <td><input type="text" name="contrast_yesterday" class="tal" data-ax5formatter="money"></td>
        <td>등락율</td>
        <td><input type="text" name="fluctuation_rt" class="tal" data-ax5formatter="money"></td>
        <td>거래량</td>
        <td><input type="text" name="trade_qty" class="tal" data-ax5formatter="money"></td>
      </tr>
      <tr>
        <td>거래대비</td>
        <td><input type="text" name="trade_contrast" class="tal" data-ax5formatter="money"></td>
        <td>생성일자</td>
        <td><input type="text" name="crt_dtm" class="tal" data-ax5formatter="date"></td>
        <td>D250최저가일</td>
        <td><input type="text" name="d250_low_dt" class="tac"></td>
        <td>액면가단위</td>
        <td><input type="text" name="face_amt_unit" class="tal"></td>
      </tr>
    </table>
  </div>
</div>
{{include "templates/footer" }}