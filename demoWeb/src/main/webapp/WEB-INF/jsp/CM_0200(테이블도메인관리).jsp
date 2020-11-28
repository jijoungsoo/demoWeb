<script>
  var CM_0200 = function () {
    var _this = this;
    var searchForm = new PgmForm(_this, "search_area");
    function requiredFieldValidator(value) {
      console.log(value)
      if (value == null || value == undefined || !value.length) {
        return { valid: false, msg: "This is a required field" };
      } else {
        return { valid: true, msg: null };
      }
    }

    var columns = [
      { name: "도메인명", id: "domain_nm", field: "domain_nm", width: 200, cssClass: "tar", sortable: true, editor: Slick.Editors.Text, validator: requiredFieldValidator },
      { name: "도메인코드", id: "domain_cd", field: "domain_cd", width: 200, cssClass: "tar", sortable: true, editor: Slick.Editors.Text, validator: requiredFieldValidator },
      { name: "크기", id: "data_type", field: "data_type", width: 200, cssClass: "tar", sortable: true, editor: Slick.Editors.Text, validator: requiredFieldValidator },
      { name: "비고", id: "rmk", field: "rmk", cssClass: "tar", width: 400, sortable: true, editor: Slick.Editors.Text },
      { name: "등록일", id: "crt_dtm", field: "crt_dtm", cssClass: "tac", sortable: true },
      { name: "수정일", id: "updt_dtm", field: "updt_dtm", cssClass: "tac", sortable: true }
    ];

    var options = {
      editable: true /*수정여부*/,
      enableAddRow: true /*행 추가 여부*/,
      autoEdit: true   /*셀에 커서를 두면 자동으로 수정모드 되는게 true, 더블 클릭해서 수정 박스가 뜨는게 false*/
    };

    var grid = new GridMngr(_this, "grid", columns, options);
    grid.build();

    /*조회버튼*/
    searchForm.addEvent("search", "click", function (e) {
      grid.LoadData("domain_mngr_data", null);
    });

    /*저장*/
    searchForm.addEvent("save", "click", function (e) {
      var tmp_data = grid.GetChagedData();
      if (tmp_data.length <= 0) {
        alert("변경된 데이터가 없습니다");
        return;
      }
      if (!confirm("저장하시겠습니까?")) {
        return;
      }
      var p_param = [];
      for (var i = 0; i < tmp_data.length; i++) {
        var tmp = tmp_data[i];
        p_param.push({
          domain_cd: tmp.domain_cd,
          domain_nm: tmp.id,
          data_type: tmp.data_type,
          rmk: tmp.rmk
        })
      }

      send_post_ajax("insert_domain_mngr_data", p_param, function (data) {
        searchForm.get("search").trigger("click");
      });
    });
    searchForm.get("search").trigger("click");
  }
</script>
<div id="{{.uuid}}">
  <div name="search_area">
    <table>
      <tr>
        <td><input type="button" name="search" value="조회" /></td>
        <td><input type="button" name="save" value="저장" /></td>
      </tr>
    </table>
  </div>
  <div name="grid"></div>
</div>
<!--하단에 공통으로 스크립트를 넣을 것이 필요하다.-->
{{include "templates/footer" }}