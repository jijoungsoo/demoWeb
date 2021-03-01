
<form name="msg_detail_area" style="border: 1px solid #ccc; padding: 10px; border-radius: 10px;">
  <div class="container">
    <div class="row row-cols-2">
      <div class="col">
        <div class="form-group">
          <div class="input-group">
            <span class="input-group-addon">발송SEQ</span> <input type="text" disabled class="form-control"
            data-ax-path="SND_SEQ" name="SND_SEQ">
          </div>
        </div>
      </div>
      <div class="col">
        <div class="form-group">
          <div class="input-group">
            <span class="input-group-addon">발송구분</span> 
            <select data-ax-path="SND_KIND_CD" name="SND_KIND_CD" disabled  class="form-control"></select>
          </div>
        </div>
      </div>
    </div>
    <div class="row row-cols-2">
      <div class="col">
        <div class="form-group">
          <div class="input-group">
            <span class="input-group-addon">발송상태</span> 
            <select data-ax-path="SND_STATUS_CD" name="SND_STATUS_CD" disabled  class="form-control"></select>
          </div>
        </div>
      </div>
      <div class="col">
        <div class="form-group">
          <div class="input-group">
            <span class="input-group-addon">발송타입</span> 
            <select data-ax-path="SND_TYPE_CD" name="SND_TYPE_CD" disabled class="form-control"></select>
          </div>
        </div>
      </div>
    </div>
    <div class="row row-cols-2">
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
    <div class="row row-cols-2">
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
            <span class="input-group-addon">수정일시</span> <input type="datetime" class="form-control"
              placeholder="yyyy-mm-dd hh:mi:ss" disabled data-ax5formatter="date(time)" data-ax-path="UPDT_DTM"
              name="UPDT_DTM">
          </div>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col">
        <div class="container">
          <div class="row row-cols-2">
            <div class="col">
              <div class="form-group">
                <div class="input-group">
                  <span class="input-group-addon">보내는사람</span> 
                  <input type="text" class="form-control" data-ax-path="SNDR_NM" disabled name="SNDR_NM">            
                </div>
              </div>     
            </div>
            <div class="col">
              <div class="form-group">
                <div class="input-group">
                  <span class="input-group-addon">보내는 TEL</span> 
                  <input type="text" class="form-control" data-ax-path="SNDR_TEL_NO" disabled name="SNDR_TEL_NO">
                </div>
              </div>     
            </div>
            <div class="col">
              
            </div>
          </div>
          <div class="row row-cols">
            <div class="col">
              <table class="table table-success table-striped">
                <thead>
                  <tr>
                    <th scope="col">받는 사람명</th>
                    <th scope="col">받는 TEL</th>
                  </tr>
                </thead>
                <tbody name="rcv_list">
                  <!--목록리스트-->
                </tbody>
              </table>      
            </div>            
          </div>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col tal">
            <div data-ax-path="MSG" name="MSG" style="min-height: 300px;"></div>
            <input type="button" name="search" value="검색">
      </div>
    </div>
  </div>
</form>

<script name="rcv-list-template" type="text/x-handlebars-template">
{{#rcvList}}  
<tr>
  <td>{{RCV_NM}}</td>
  <td>{{RCV_TEL_NO}}</td>
</tr>
{{/rcvList}}  
</script>