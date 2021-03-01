
<form name="brd_modify_area" style="border: 1px solid #ccc; padding: 10px; border-radius: 10px;">
  <div class="container">
    <div class="row row-cols-4">
      <div class="col-sm">
        <div class="form-group">
          <div class="input-group">
            <span class="input-group-addon">게시판선택</span>
            
            <select class="form-control" data-ax-path="GRP_SEQ"  name="GRP_SEQ" style="width:140px;" >
            </select>
          </div>
        </div>
      </div>
      <div class="col">
        <div class="form-group">
          <div class="input-group">
            <span class="input-group-addon">BRD_SEQ</span> <input type="text" disabled class="form-control"
            data-ax-path="BRD_SEQ" name="BRD_SEQ">
          </div>
        </div>
      </div>
      <div class="col">
        <div class="form-group">
          <div class="input-group">
            <span class="input-group-addon">수정일시</span> <input type="text" class="form-control"
              placeholder="yyyy-mm-dd hh:mi:ss" data-ax5formatter="date(time)" data-ax-path="UPDT_DTM" name="UPDT_DTM"
              disabled>
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
<!-- 에디터 컨테이너 시작 -->
   <!-- The toolbar will be rendered in this container. -->
   <div name="toolbar-container"></div>
<div name="CNTNT"  data-ax-path="CNTNT"></div>
<!-- 에디터 컨테이너 끝 -->
      </div>
    </div>
  </div>
  <div style="padding: 10px;">
    <input type="button" name="save" value="저장" />
  </div>
</div>