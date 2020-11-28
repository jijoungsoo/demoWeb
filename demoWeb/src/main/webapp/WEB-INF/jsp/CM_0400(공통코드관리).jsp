<script>
  var CM_0400 = function () {
    var _this = this;
    var searchForm1 = new PgmForm(_this, "search_area1");
    var searchForm2 = new PgmForm(_this, "search_area2");
    function requiredFieldValidator(value) {
      console.log(value)
      if (value == null || value == undefined || !value.length) {
        return { valid: false, msg: "This is a required field" };
      } else {
        return { valid: true, msg: null };
      }
    }

    var columns = [
      { name: "공통그룹코드", id: "grp_cd", field: "grp_cd", width: 200, cssClass: "tar", sortable: true, editor: Slick.Editors.Text, validator: requiredFieldValidator },
      { name: "공통그룹명", id: "grp_cd_nm", field: "grp_cd_nm", width: 200, cssClass: "tar", sortable: true, editor: Slick.Editors.Text, validator: requiredFieldValidator },
      { name: "사용여부", id: "use_yn", field: "use_yn", width: 200, cssClass: "tar", sortable: true, editor: Slick.Editors.Text, validator: requiredFieldValidator },
      { name: "정렬", id: "ord", field: "ord", width: 200, cssClass: "tar", sortable: true, editor: Slick.Editors.Text, validator: requiredFieldValidator },
      { name: "비고", id: "rmk", field: "rmk", width: 200, cssClass: "tac", sortable: true, editor: Slick.Editors.Text },
      { name: "등록일", id: "crt_dtm", field: "crt_dtm", width: 200, cssClass: "tac", sortable: true },
      { name: "수정일", id: "updt_dtm", field: "updt_dtm", width: 200, cssClass: "tac", sortable: true }
    ];

    var columns_detail = [
      { name: "공통그룹코드", id: "grp_cd", field: "grp_cd", width: 200, cssClass: "tar", sortable: true, editor: Slick.Editors.Text, validator: requiredFieldValidator },
      { name: "공통코드", id: "cd", field: "cd", width: 200, cssClass: "tar", sortable: true, editor: Slick.Editors.Text, validator: requiredFieldValidator },
      { name: "공통코드명", id: "cd_nm", field: "cd_nm", width: 200, cssClass: "tar", sortable: true, editor: Slick.Editors.Text, validator: requiredFieldValidator },
      { name: "사용여부", id: "use_yn", field: "use_yn", width: 200, cssClass: "tar", sortable: true, editor: Slick.Editors.Text, validator: requiredFieldValidator },
      { name: "정렬", id: "ord", field: "ord", width: 200, cssClass: "tar", sortable: true, editor: Slick.Editors.Text, validator: requiredFieldValidator },
      { name: "비고", id: "rmk", field: "rmk", width: 200, cssClass: "tac", sortable: true, editor: Slick.Editors.Text },
      { name: "등록일", id: "crt_dtm", field: "crt_dtm", width: 200, cssClass: "tac", sortable: true },
      { name: "수정일", id: "updt_dtm", field: "updt_dtm", width: 200, cssClass: "tac", sortable: true }
    ];

    var options = {
      editable: true /*수정여부*/,
      enableAddRow: true /*행 추가 여부*/,
      autoEdit: true   /*셀에 커서를 두면 자동으로 수정모드 되는게 true, 더블 클릭해서 수정 박스가 뜨는게 false*/,
      showNumber: true,
      height: 500
    };


    var grid1 = new GridMngr(_this, "grid1", columns, options);
    grid1.build();
    var grid2 = new GridMngr(_this, "grid2", columns_detail, options);
    grid2.build();


    grid1.onClick(function (e, p_args, p_grid) {
      var cell = p_grid.getCellFromEvent(e);
      if (p_grid.getColumns()[cell.cell].id == "grp_cd") {
        if (!p_grid.getEditorLock().commitCurrentEdit()) {
          return;
        }
        var rd = grid1.dataView.getItem(cell.row);
        if (rd == undefined) {
          return;
        }

        if (rd.grp_cd == undefined) {
          return;
        }
        var param = {
          grp_cd: rd.grp_cd
        }
        grid2.LoadData("cd_mngr_data", param);
        //data[cell.row].priority = states[data[cell.row].priority];
        e.stopPropagation();
      }
    });

    /*조회버튼*/
    searchForm1.addEvent("grid1-search", "click", function (e) {
      grid1.LoadData("cd_grp_mngr_data", null);
    });

    /*저장*/
    searchForm1.addEvent("grid1-save", "click", function (e) {
      if (grid1.Validate() == false) {
        return;
      }
      var tmp_data = grid1.GetChagedData();
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
          grp_cd: tmp.grp_cd,
          grp_cd_nm: tmp.grp_cd_nm,
          use_yn: tmp.use_yn,
          ord: tmp.ord,
          rmk: tmp.rmk,
        })
      }

      send_post_ajax("insert_cd_grp_mngr_data", p_param, function (data) {
        searchForm1.get("grid1-search").trigger("click");
      });
    });
    /*상세저장*/
    searchForm2.addEvent("grid2-save", "click", function (e) {
      if (grid2.Validate() == false) {
        return;
      }
      var tmp_data = grid2.GetChagedData();
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
          grp_cd: tmp.grp_cd,
          grp_nm: tmp.grp_nm,
          cd: tmp.cd,
          cd_nm: tmp.cd_nm,
          use_yn: tmp.use_yn,
          ord: tmp.ord,
          rmk: tmp.rmk
        })
      }

      send_post_ajax("insert_cd_mngr_data", p_param, function (data) {
        searchForm1.get("grid1-search").trigger("click");
      });
    });
    searchForm1.get("grid1-search").trigger("click");
  }
</script>
<div id="{{.uuid}}">
  <div name="search_area1">
    <table>
      <tr>
        <td><input type="button" name="grid1-search" value="조회" /></td>
        <td><input type="button" name="grid1-save" value="저장" /></td>
      </tr>
    </table>
  </div>

  <div name="grid1"></div>

  <hr />
  <div name="search_area2">
    <table>
      <tr>
        <td><input type="button" name="grid2-save" value="저장" /></td>
      </tr>
    </table>
  </div>

  <div name="grid2"></div>
</div>
{{include "templates/footer" }}