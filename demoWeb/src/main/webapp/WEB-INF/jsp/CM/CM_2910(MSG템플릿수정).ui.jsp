
<form name="msg_tmpl_modify_area" style="border: 1px solid #ccc; padding: 10px; border-radius: 10px;">
  <div class="container">
    <div class="row row-cols-3">
      <div class="col">
        <div class="form-group">
          <div class="input-group">
            <span class="input-group-addon">템플릿SEQ</span> <input type="text" disabled class="form-control"
            data-ax-path="TMPL_SEQ" name="TMPL_SEQ">
          </div>
        </div>
      </div>
      <div class="col">
        <div class="form-group">
          <div class="input-group">
            <span class="input-group-addon">발송구분</span> 
            <select data-ax-path="SND_KIND_CD" name="SND_KIND_CD"  class="form-control"></select>
          </div>
        </div>
      </div>
      <div class="col">
        <div class="form-group">
          <div class="input-group">
            <span class="input-group-addon">템플릿상태</span> 
            <select data-ax-path="MSG_TMPL_STATUS_CD" name="MSG_TMPL_STATUS_CD" disabled  class="form-control"></select>
          </div>
        </div>
      </div>
    </div>
    <div class="row row-cols-3">
      <div class="col">
        <div class="form-group">
          <div class="input-group">
            <span class="input-group-addon">템플릿파일경로</span> <input type="text" class="form-control"
            data-ax-path="TMPL_PATH" name="TMPL_PATH">
          </div>
        </div>
      </div>
      <div class="col">
        <div class="form-group">
          <div class="input-group">
            <span class="input-group-addon">생성자</span> 
            <input type="text" class="form-control" disabled data-ax-path="CRT_USR_NO" name="CRT_USR_NO">
          </div>
        </div>
      </div>
      <div class="col">
        <div class="form-group">
          <div class="input-group">
            <span class="input-group-addon">생성일시</span> <input type="datetime" class="form-control"
              placeholder="yyyy-mm-dd hh:mi:ss" disabled data-ax5formatter="date(time)" data-ax-path="CRT_DTM"
              name="CRT_DTM">
          </div>
        </div>
      </div>
    </div>
    <div class="row row-cols-3">
      <div class="col">
        <div class="form-group">
          <div class="input-group">
            <span class="input-group-addon">수정자</span> 
            <input type="text" class="form-control" data-ax-path="UPDT_USR_NO" disabled name="UPDT_USR_NO">
          </div>
        </div>
      </div>
      <div class="col">
        <div class="form-group">
          <div class="input-group">
            <span class="input-group-addon">생성일시</span> <input type="datetime" class="form-control"
              placeholder="yyyy-mm-dd hh:mi:ss" disabled data-ax5formatter="date(time)" data-ax-path="CRT_DTM"
              name="CRT_DTM">
          </div>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col">
        <div class="form-group">
          <div class="input-group">
            <span class="input-group-addon">제목</span> <input type="text" class="form-control" data-ax-path="TTL"
              name="TTL">
          </div>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col">
        <div class="form-group">
          <div class="input-group">
            <textarea class="form-control" data-ax-path="MSG"
            name="MSG"></textarea>
          </div>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col">
        <div class="form-group">
          <div class="input-group">
            <span class="input-group-addon">비고</span> <input type="text" class="form-control" data-ax-path="RMK"
              name="RMK">
          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="container">
    <div class="row row-cols-2">
      <div class="col tal">
        <input type="button" name="use" value="사용" />
        <input type="button" name="del" value="삭제" />
        <input type="button" name="search" value="조회" style="display: none;" />
        
      </div>
      <div class="col tar">
        <input type="button" name="save" value="저장" />
      </div>
    </div>
  </div>
</form>