<div name="brd_detail_area" style="border: 1px solid #ccc; padding: 10px; border-radius: 10px;">
  <div class="container">
    <div class="row row-cols-4">
      <div class="col-sm">
        <div class="form-group">
          <div class="input-group">
            <span class="input-group-addon">게시판선택</span>
            <select class="form-control" data-ax-path="GRP_SEQ"  name="GRP_SEQ" style="width:140px;" disabled>
            </select>
          </div>
        </div>
      </div>
      <div class="col">
        <div class="form-group">
          <div class="input-group">
            <span class="input-group-addon">BRD_SEQ</span>
            <div name="BRD_SEQ" data-ax-path="BRD_SEQ" class="form-control"></div>
          </div>
        </div>
      </div>
      <div class="col">
        <div class="form-group">
          <div class="input-group">
            <span class="input-group-addon">수정일시</span>
            <div name="UPDT_DTM" data-ax-path="UPDT_DTM" class="form-control"></div>
          </div>
        </div>
      </div>
      <div class="col">
        <div class="form-group">
          <div class="input-group">
            <span class="input-group-addon">생성일시</span>
            <div name="CRT_DTM" data-ax-path="CRT_DTM" class="form-control"></div>
          </div>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col">
        <div class="form-group">
          <div class="input-group">
            <span class="input-group-addon">제목</span>
            <div name="TTL" data-ax-path="TTL" class="form-control tal"></div>
          </div>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col">
        <div name="CNTNT"  class="form-control tal" style="height: 300px;"></div>
      </div>
    </div>
  </div>
  <div style="padding: 10px;">
		  <input type="button" name="modify" value="수정" />
      <input type="button" name="del" value="삭제" />
	</div>
</div>

<div name="child_area">
</div>