<div name="search_area">
  <table>
    <tr>
      <td>
        <div class="form-group">
          <div class="input-group">
            <span class="input-group-addon">모자이크상태</span> 
            <select class="form-control" data-ax-path="MSC_CD"  name="MSC_CD" style="width:140px;">
            </select>
          </div>
        </div>
      </td>
      <td>
        <div class="form-group">
          <div class="input-group">
            <span class="input-group-addon">VR여부</span> 
            <select class="form-control" data-ax-path="VR_YN"  name="VR_YN" style="width:140px;">
            </select>
          </div>
        </div>
      </td>
      <td><input type="button" name="search" value="조회" /></td>
      <td><input type="button" name="add_row" value="추가" /></td>
      <td><input type="button" name="save" value="저장" /></td>
      <td><input type="button" name="del" value="삭제" /></td>
      <td><input type="file" title="엑셀업로드" name="excel_upld"></td>
      <td><input type="button" value="엑셀다운로드" name="excel_dwnld"></td>
    </tr>
  </table>
</div>
<div name="grid"></div>
