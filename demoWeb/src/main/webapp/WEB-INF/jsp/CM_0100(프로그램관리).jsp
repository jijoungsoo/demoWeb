<script>
  var CM_0100 = function () {
    var _this = this;


    var searchForm = new PgmForm(_this,"search_area");

    function requiredFieldValidator(value) {
      if (value == null || value == undefined || !value.length) {
        return { valid: false, msg: "This is a required field" };
      } else {
        return { valid: true, msg: null };
      }
    }

    var columns = [
      { name: "프로그램ID", id: "pgm_id", field: "pgm_id", width: 200, cssClass: "tac", sortable: true, editor: Slick.Editors.Text, validator: requiredFieldValidator },
      { name: "프로그램명", id: "pgm_nm", field: "pgm_nm", width: 200, cssClass: "tac", sortable: true, editor: Slick.Editors.Text, validator: requiredFieldValidator },
      { name: "카테고리", id: "category", field: "category", width: 200, cssClass: "tac", sortable: true, editor: Slick.Editors.Text, validator: requiredFieldValidator },
      { name: "프로그램링크", id: "pgm_link", field: "pgm_link", width: 400, cssClass: "tac", sortable: true, editor: Slick.Editors.Text, validator: requiredFieldValidator },
      { name: "비고", id: "rmk", field: "rmk", cssClass: "tar", width: 400, sortable: true, editor: Slick.Editors.Text },
      { name: "생성일", id: "crt_dtm", field: "crt_dtm", cssClass: "tac", sortable: true },
      { name: "수정일", id: "updt_dtm", field: "updt_dtm", cssClass: "tac", sortable: true },
    ];

    var options = {
      editable: true /*수정여부*/,
      enableAddRow: true /*행 추가 여부*/,
      showNumber: true, /*지정수가 넣은 임의 값  숫자 앞에 보이기 */
      enableCheckBox: true, /*지정수가 넣은 임의 값  숫자 앞에 보이기 */
      showDbSave: true /*지정수가 넣은 값 db에서 불러온 값인지 보이기*/
    };

    var grid = new GridMngr(_this, "grid", columns, options);
    grid.build();

    /*조회버튼*/
    searchForm.addEvent("search", "click", function (e) {
      grid.LoadData("pgm_mngr_data", null);
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
          pgm_id: tmp.pgm_id,
          pgm_nm: tmp.pgm_nm,
          pgm_link: tmp.pgm_link,
          category: tmp.category,
          rmk: tmp.rmk
        })
      }

      send_post_ajax("insert_pgm_mngr_data", p_param, function (data) {
        searchForm.get("search").trigger("click");
      });
    });

    /*삭제*/
    searchForm.addEvent("del", "click", function (e) {
      var arr_data = grid.GetCheckedData();  /*행번호를 가져온다. */
      if (arr_data.length <= 0) {
        alert("삭제할 행을 선택해주세요");
      }

      if (!confirm("삭제하시겠습니까?")) {
        return;
      }
      var tmp_param = []
      arr_data.forEach(function (value) {
        tmp_param.push({ pgm_id: value.pgm_id })
      });

      send_post_ajax("delete_pgm_mngr_data", tmp_param, function (data) {
        searchForm.get("search").trigger("click");
      });
    });
    searchForm.get("search").trigger("click");
  }
    //https://chenyitian.gitbooks.io/gin-tutorials/gin/8.html
    //https://gohugo.io/templates/introduction/
    //https://levelup.gitconnected.com/using-go-templates-for-effective-web-development-f7df10b0e4a0
    //footer.tmpl
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
<!--하단에 공통으로 스크립트를 넣을 것이 필요하다.-->
{{include "templates/footer" }}