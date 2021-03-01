
<form name="msg_snd_area" style="border: 1px solid #ccc; padding: 10px; border-radius: 10px;">
  <div class="container">
    <div class="row row-cols-3">
      <div class="col">
        <div class="form-group">
          <div class="input-group">
            <span class="input-group-addon">발송타입</span> 
            <select data-ax-path="SND_TYPE_CD" name="SND_TYPE_CD" class="form-control"></select>
          </div>
        </div>
      </div>
      <div class="col">
        <div class="form-group">
          <div class="input-group">
            <span class="input-group-addon">보내는사람</span> 
            <input type="text" class="form-control" data-ax-path="SNDR_NM" name="SNDR_NM">            
          </div>
        </div>     
      </div>
      <div class="col">
        <div class="form-group">
          <div class="input-group">
            <span class="input-group-addon">보내는주소</span> 
            <input type="text" class="form-control" data-ax-path="SNDR_ADDR" name="SNDR_ADDR">
          </div>
        </div>     
      </div>
    </div> 
   
    <div class="row">
      <div class="col">
        <div class="container">
          <div class="row row-cols-3">
            <div class="col">
              <div class="form-group">
                <div class="input-group">
                  <span class="input-group-addon">받는 사람명</span> 
                  <input type="text" class="form-control"  name="RCV_NM" data-ax-path="RCV_NM" >
                </div>          
              </div>      
            </div>
            <div class="col">
              <div class="form-group">
                <div class="input-group">
                  <span class="input-group-addon">받는 주소</span> 
                  <input type="text" class="form-control"  name="RCV_ADDR" data-ax-path="RCV_ADDR" >            
                </div>          
              </div>      
            </div>
            <div class="col">
              <div class="form-group">
                <div class="input-group">
                  <input type="button" name="rcvAdd" value="등록">
                </div>
              </div>
            </div>
          </div>
          <div class="row row-cols">
            <div class="col">
              <table class="table table-success table-striped">
                <thead>
                  <tr>
                    <th scope="col">받는 사람명</th>
                    <th scope="col">받는 주소</th>
                    <th scope="col">삭제버튼</th>
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
    <div class="row row-cols">
      <div class="col">
        <div class="form-group">
          <div class="input-group">
            <span class="input-group-addon">제목</span> 
            <input type="text" class="form-control" data-ax-path="TTL" name="TTL">            
          </div>
        </div>     
      </div>
    </div>
    <div class="row">
      <div class="col">
        <div class="form-group">
          <div class="input-group">
            <textarea class="form-control" data-ax-path="CNTNT" name="CNTNT"></textarea>
          </div>
        </div>
      </div>
    </div>
  </div>
  <div class="container">
    <div class="row row-cols-2">
      <div class="col tar">
        <input type="button" name="snd" value="전송" />
      </div>
    </div>
  </div>
</form>

<script name="rcv-list-template" type="text/x-handlebars-template">
{{#rcvList}}  
<tr>
  <td>{{RCV_NM}}</td>
  <td>{{RCV_ADDR}}</td>
  <td> 
      <input type="button" name="rcvDel" value="X" key="{{@index}}">
  </td>
</tr>
{{/rcvList}}  
</script>