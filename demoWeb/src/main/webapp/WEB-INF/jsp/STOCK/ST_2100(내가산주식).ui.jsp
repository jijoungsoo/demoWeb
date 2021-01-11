<form name="search_area">
<table>
<tr>
	<td><input type="button" name="search" value="조회" /></td>
	<td><input type="button" name="add_row" value="추가" /></td>
	<td><input type="button" name="save" value="저장" /></td>
	<td><input type="button" name="del" value="삭제" /></td>
</tr>
</table>
</form>	
<div name="grid"></div>

<div name="popup_sell" style="display:none">
  <div class="mb-3 row">
    <label for="STOCK_CD" class="col-sm-4 col-form-label">주식코드</label>
    <div class="col-sm-6">
      <input type="text" readonly class="form-control" name="STOCK_CD" data-ax-path="STOCK_CD" />
    </div>
  </div>
  <div class="mb-3 row">
    <label for="STOCK_NM" class="col-sm-4 col-form-label">주식명</label>
    <div class="col-sm-6">
      <input type="text" readonly class="form-control" name="STOCK_NM" data-ax-path="STOCK_NM" />
    </div>
  </div>
  <div class="mb-3 row">
    <label for="AMT" class="col-sm-4 col-form-label">주식단가</label>
    <div class="col-sm-6">
      <input type="text" readonly class="form-control tar" name="AMT" data-ax-path="AMT" data-ax5formatter="money" data-ax5="formatter"  />
    </div>
  </div>
  <div class="mb-3 row">
    <label for="CNT" class="col-sm-4 col-form-label">구매수</label>
    <div class="col-sm-6">
      <input type="text" readonly class="form-control tar" name="CNT" data-ax-path="CNT" data-ax5formatter="money" data-ax5="formatter"  />
    </div>
  </div>
  <div class="mb-3 row">
    <label for="TOTAL_AMT" class="col-sm-4 col-form-label">총금액</label>
    <div class="col-sm-6">
      <input type="text" readonly class="form-control tar" name="TOT_AMT" data-ax-path="TOT_AMT" data-ax5formatter="money" data-ax5="formatter" />
    </div>
  </div>
  <div class="mb-3 row">
    <label for="BAL_CNT" class="col-sm-4 col-form-label">잔량</label>
    <div class="col-sm-6">
      <input type="text" readonly class="form-control tar" name="BAL_CNT" data-ax-path="BAL_CNT" data-ax5formatter="money" data-ax5="formatter" />
    </div>
  </div>
  <div class="mb-3 row">
    <label for="BAL_TOT_AMT" class="col-sm-4 col-form-label">잔액</label>
    <div class="col-sm-6">
      <input type="text" readonly class="form-control tar" name="BAL_TOT_AMT" data-ax-path="BAL_TOT_AMT" data-ax5formatter="money" data-ax5="formatter"  />
    </div>
  </div>
  <div class="mb-3 row">
    <label for="SELL_AMT" class="col-sm-4 col-form-label">매도단가</label>
    <div class="col-sm-6">
      <input type="text" class="form-control tar" name="SELL_AMT" data-ax-path="SELL_AMT" data-ax5formatter="money" data-ax5="formatter"  />
    </div>
  </div>
  <div class="mb-3 row">
    <label for="SELL_CNT" class="col-sm-4 col-form-label">매도수</label>
    <div class="col-sm-6">
      <input type="text" class="form-control tar" name="SELL_CNT" data-ax-path="SELL_CNT" data-ax5formatter="money" data-ax5="formatter"  />
    </div>
  </div>
  <div class="mb-3 row">
    <label for="SELL_TOT_AMT" class="col-sm-4 col-form-label">총매도금액</label>
    <div class="col-sm-6">
      <input type="text" readonly class="form-control tar" name="SELL_TOT_AMT" data-ax-path="SELL_TOT_AMT" data-ax5formatter="money" data-ax5="formatter"  />
    </div>
  </div>  
  
	<div style="padding: 10px;">
		<input type="button" name="save" value="저장" />
		<input type="button" name="close" value="닫기" />
	</div>
</div>
