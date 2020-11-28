<script>
  var CM_0300 = function () {
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
      { name: "메뉴코드", id: "menu_cd", field: "menu_cd", width: 200, cssClass: "tar", sortable: true, editor: Slick.Editors.Text, validator: requiredFieldValidator },
      { name: "메뉴명", id: "menu_nm", field: "menu_nm", width: 200, cssClass: "tar", sortable: true, editor: Slick.Editors.Text, validator: requiredFieldValidator },
      { name: "부모메뉴코드", id: "prnt_menu_cd", field: "prnt_menu_cd", width: 200, cssClass: "tar", sortable: true, editor: Slick.Editors.Text },
      { name: "첫번째정렬", id: "fst_ord", field: "fst_ord", width: 200, cssClass: "tar", sortable: true, editor: Slick.Editors.Text },
      { name: "두번째정렬", id: "sed_ord", field: "sed_ord", width: 200, cssClass: "tar", sortable: true, editor: Slick.Editors.Text },
      { name: "프로그램ID", id: "pgm_id", field: "pgm_id", width: 200, cssClass: "tar", sortable: true, editor: Slick.Editors.Text },
      { name: "종류", id: "menu_kind", field: "menu_kind", width: 200, cssClass: "tar", sortable: true, editor: Slick.Editors.Text, validator: requiredFieldValidator },
      { name: "비고", id: "rmk", field: "rmk", cssClass: "tar", width: 400, sortable: true, editor: Slick.Editors.Text },
      { name: "등록일", id: "crt_dtm", field: "crt_dtm", cssClass: "tac", sortable: true },
      { name: "수정일", id: "updt_dtm", field: "updt_dtm", cssClass: "tac", sortable: true }

    ];

    var options = {
      editable: true /*수정여부*/,
      enableAddRow: true /*행 추가 여부*/,
      autoEdit: true   /*셀에 커서를 두면 자동으로 수정모드 되는게 true, 더블 클릭해서 수정 박스가 뜨는게 false*/,
      showNumber: true
    };


    var grid = new GridMngr(_this, "grid", columns, options);
    grid.build();

    /*조회버튼*/
    searchForm.addEvent("search", "click", function (e) {
      grid.LoadData("menu_mngr_data", null);
    });

    /*저장*/
    searchForm.addEvent("save", "click", function (e) {
      if (grid.Validate() == false) {
        return;
      }
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
          menu_cd: tmp.menu_cd,
          menu_nm: tmp.menu_nm,
          prnt_menu_cd: tmp.prnt_menu_cd,
          fst_ord: tmp.fst_ord,
          sed_ord: tmp.sed_ord,
          pgm_id: tmp.pgm_id,
          menu_kind: tmp.menu_kind,
          rmk: tmp.rmk
        })
      }

      send_post_ajax("insert_menu_mngr_data", p_param, function (data) {
        searchForm.get("search").trigger("click");
      });
    });

    /*삭제*/
    searchForm.addEvent("del", "click", function (e) {
      var arr_data = grid.GetSelectedData();  /*행번호를 가져온다. */
      if (arr_data.length != 1) {
        alert("삭제할 행을 하나 선택해주세요");
      }

      if (!confirm("삭제하시겠습니까?")) {
        return;
      }
      var tmp_param = { menu_cd: arr_data[0].menu_cd }

      send_post_ajax("delete_menu_mngr_data", tmp_param, function (data) {
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
        <td><input type="button" name="del" value="삭제" /></td>
      </tr>
    </table>
  </div>
  <div name="grid"></div>
</div>
{{include "templates/footer" }}