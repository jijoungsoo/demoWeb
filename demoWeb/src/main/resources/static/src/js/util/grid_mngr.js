function GridMngr(pgm_mngr, grid_name, columns, options) {
  var editedRows = [];
  var tmp = `
    <div style="text-align: left;">
    <div class="grid-header" style="width: 100%;">
      <label>SlickGrid</label>
      <span style="float: right;" class="ui-icon ui-icon-search" title="Toggle search panel" name="`+ grid_name + `-filter"></span>
    </div>
    <div name="`+ grid_name + `-grid" style="width: 100%; height: 900px" class="example-grid"></div>
    <div name="`+ grid_name + `-pager" style="width: 100%; height: 20px;"></div>
  </div>
  <div name="`+ grid_name + `-inlineFilterPanel" style="display: none; background: #dddddd; padding: 3px; color: black;">Show tasks with title including <input type="text" name="` + grid_name + `-txtSearch" /></div>
  `
  //$("#"+uuid).remove();
  //이렇게 하면 uuid div가 지워지므로 위는 안됨
  pgm_mngr.get(grid_name).empty();
  pgm_mngr.get(grid_name).append(tmp);
  var sortdir = 1;
  var dataView;
  var grid;
  var search_string = "";
  var sortcol;
  /*http://jsfiddle.net/4nil/gvemw9m9/ */
  var selectActiveRow = false;  /*sing row만 선택되게 만들 때 사용 */
  var selectedRows = [];  /*sing row만 선택되게 만들 때 사용 */
  //var data = [];
  dataView = new Slick.Data.DataView({ inlineFilters: true });

  var basic_options = {
    editable: false /*수정여부*/,
    enableAddRow: false /*행 추가 여부*/,
    explicitInitialization: false /*이거 true로 하면 표가 나타나지 않는다. 왜인지 는 모름 */,
    enableCellNavigation: true /*row선택모드로 할때 이것이 false 이면 안먹는다.*/,
    enableColumnReorder: true /*true일때만 컬럼 이동이 가능하다. */,
    showHeaderRow: false /*상단에 빈 행을 하나 보여준다.*/,
    forceFitColumns: false,
    topPanelHeight: 25,
    asyncEditorLoading: false,
    autoEdit: true   /*셀에 커서를 두면 자동으로 수정모드 되는게 true, 더블 클릭해서 수정 박스가 뜨는게 false*/,
    showNumber: false /*지정수가 넣은 임의 값  숫자 앞에 보이기 */,
    enableCheckBox: false /*지정수가 넣은 임의 값  숫자 앞에 보이기 */,
    showDbSave: false /*지정수가 넣은 값 db에서 불러온 값인지 보이기*/,
    autoHeight: false /*slickgrid에서 이 설정을 true로 하면 스크롤이 없어진다. 내 프로그램에서는 데이터가 짤린다. */,
    /*https://github.com/6pac/SlickGrid/blob/master/examples/example15-auto-resize.html 이 기능을 써야한다. */
    autoResize: false,
    showTotalSummary: false
  };

  options = $.extend(basic_options, options);

  var showTotalSummaryColumn = [];  /*aa,bb,cc 컬럼명*/
  var o_columns = [];
  var h_columns = [];

  this.build = function () {

    /*체크박스 넣기 */
    var checkboxSelector = new Slick.CheckboxSelectColumn({
      cssClass: "slick-cell-checkboxsel"
    });

    if (options.enableCheckBox == true) {
      o_columns.push(checkboxSelector.getColumnDefinition());
    }

    if (options.showDbSave == true) {
      o_columns.push({
        name: "*",
        id: "_status",
        field: "_status",
        formatter: function (row, cell, value, columnDef, dataContext) {
          return value;
        },
        behavior: "select",
        cssClass: "cell-selection tac",
        width: 20,
        cannotTriggerInsert: true,
        resizable: false,
        selectable: false,
        excludeFromColumnPicker: true
      });
    }

    /*순서넣기 */
    if (options.showNumber == true) {
      o_columns.push({
        name: "#",
        formatter: function (row) {
          return row + 1;
        },
        behavior: "select",
        cssClass: "cell-selection",
        width: 60,
        cannotTriggerInsert: true,
        resizable: false,
        selectable: false,
        excludeFromColumnPicker: true,
      });
    }

    for (var i = 0; i < columns.length; i++) {
      o_columns.push(columns[i]);
      h_columns.push(columns[i]);
    }
    h_columns.push({ name: "ROW_ID", id: "id", field: "id" });  /*유일한 id가 하나 있어야 해서 숨김으로 하나 만들어준다. */

    grid = new Slick.Grid(pgm_mngr.get(grid_name+"-grid"), dataView, o_columns, options);

    if (options.enableCheckBox == true) {
      selectActiveRow = false;
      grid.setSelectionModel(new Slick.RowSelectionModel({ selectActiveRow: false }));  /*이걸해줘야 멀티 선택이 된다.*/
      grid.registerPlugin(checkboxSelector);
    } else {
      selectActiveRow = true;
      grid.setSelectionModel(new Slick.RowSelectionModel({ selectActiveRow: true })); /*셀을 클릭하면 한줄이 선택되도록 한다. */
    }

    /*이거는 뭘까 여기저기 보니까.   그리드에 넣는건 표시되는거고 여기 넣는건 안표시된다고 한다.   data용으로가지고 있는것 같다. 
    https://code-examples.net/ko/q/613fd8
    https://ko.programqa.com/question/26647792/
    */
    var columnpicker = new Slick.Controls.ColumnPicker(h_columns, grid, options);  /*숨김 필드를 가지기 위해서 썼다. */

    grid.registerPlugin(new Slick.AutoTooltips({ enableForHeaderCells: true })); /*tooltip */
    $(document).tooltip({ tooltipClass: "slick-tooltip" });

    if (options.autoResize == true) {

      //그리드 리사이즈 플러그인 
      // create the Resizer plugin
      // you need to provide a DOM element container for the plugin to calculate available space
      var resizer = new Slick.Plugins.Resizer({
        container: '#' + pgm_mngr.getId(), // DOM element selector, can be an ID or a class

        // optionally define some padding and dimensions
        rightPadding: 0,    // defaults to 0
        bottomPadding: 100,  // defaults to 20
        minHeight: 180,     // defaults to 180
        minWidth: 250,      // defaults to 300

        // you can also add some max values (none by default)
        // maxHeight: 1000
        // maxWidth: 2000
      },
        // the 2nd argument is an object and is optional
        // you could pass fixed dimensions, you can pass both height/width or a single dimension (passing both would obviously disable the auto-resize completely)
        // for example if we pass only the height (as shown below), it will use a fixed height but will auto-resize only the width
        // { height: 300 }
      );
      grid.registerPlugin(resizer);

      // you can optionally Subscribe to the following events
      /*
      resizer.onGridBeforeResize.subscribe(function () {
        console.log('onGridBeforeResize');
      });
      resizer.onGridAfterResize.subscribe(function (e, args) {
        console.log('onGridAfterResize new dimensions', args.dimensions);
      });
      */
    } else {
      if(options.height) {
        pgm_mngr.get(grid_name+"-grid").height(options.height);
      }
    }


    this.grid = grid;
    this.dataView = dataView;

    var pager = new Slick.Controls.Pager(dataView, grid, pgm_mngr.get(grid_name+"-pager"));

    grid.onKeyDown.subscribe(function (e) {
      // select all rows on ctrl-a
      if (e.which != 65 || !e.ctrlKey) {
        return false;
      }

      var rows = [];
      for (var i = 0; i < dataView.getLength(); i++) {
        rows.push(i);
      }

      grid.setSelectedRows(rows);
      e.preventDefault();
    });
    function isIEPreVer9() { var v = navigator.appVersion.match(/MSIE ([\d.]+)/i); return (v ? v[1] < 9 : false); }


    function comparer(a, b) {
      var x = a[sortcol], y = b[sortcol];
      return (x == y ? 0 : (x > y ? 1 : -1));
    }



    grid.onAddNewRow.subscribe(function (e, args) {
      var item = args.item;
      item.id = getUUID();
      grid.invalidateRow(dataView.getLength());
      dataView.addItem(item);
      editedRows.push(item);  //신규건 저장
      grid.updateRowCount();
      grid.render();
      console.log(editedRows);
    });

    grid.onCellChange.subscribe(function (e, args) {
      const index = editedRows.findIndex(x => x.id === args.item.id);
      if (!(index < 0)) {
        editedRows.splice(index, 1)
      };
      //참조가 되었다.
      editedRows.push(args.item);
      dataView.updateItem(args.item.id, args.item);  /*https://qiita.com/t-iguchi/items/95c6b1a60ab44ab96e3d*/
    });

    grid.onValidationError.subscribe(function (e, args) {
      alert(args.validationResults.msg);
    });

    grid.onSort.subscribe(function (e, args) {
      sortdir = args.sortAsc ? 1 : -1;
      sortcol = args.sortCol.field;

      if (isIEPreVer9()) {
        // using temporary Object.prototype.toString override
        // more limited and does lexicographic sort only by default, but can be much faster

        var percentCompleteValueFn = function () {
          var val = this["percentComplete"];
          if (val < 10) {
            return "00" + val;
          } else if (val < 100) {
            return "0" + val;
          } else {
            return val;
          }
        };

        // use numeric sort of % and lexicographic for everything else
        dataView.fastSort(sortcol == "percentComplete" ? percentCompleteValueFn : sortcol, args.sortAsc);
      } else {
        // using native sort with comparer
        // preferred method but can be very slow in IE with huge datasets
        dataView.sort(comparer, args.sortAsc);
      }
    });

    // wire up model events to drive the grid
    // !! both dataView.onRowCountChanged and dataView.onRowsChanged MUST be wired to correctly update the grid
    // see Issue#91
    dataView.onRowCountChanged.subscribe(function (e, args) {
      grid.updateRowCount();
      grid.render();
    });

    dataView.onRowsChanged.subscribe(function (e, args) {
      grid.invalidateRows(args.rows);
      grid.render();
    });

    dataView.onPagingInfoChanged.subscribe(function (e, pagingInfo) {
      grid.updatePagingStatusFromView(pagingInfo);

      // show the pagingInfo but remove the dataView from the object, just for the Cypress E2E test
      delete pagingInfo.dataView;
      //console.log("on After Paging Info Changed - New Paging:: ", pagingInfo);
    });

    dataView.onBeforePagingInfoChanged.subscribe(function (e, previousPagingInfo) {
      // show the previous pagingInfo but remove the dataView from the object, just for the Cypress E2E test
      delete previousPagingInfo.dataView;
      //console.log("on Before Paging Info Changed - Previous Paging:: ", previousPagingInfo);
    });

    function myFilter(item, args) {
      if ((args.searchString == "")) {
        return true; /*검색어가 없으면 무조건 true  전부 나오도록*/
      }

      /*item json 인데 한 행이 움직이면서 하나씩 한로우가 item이 되는것이다.*/
      for (key in item) {
        /*for in 문으로 컬럼을 돌면서 한토시라도 매칭되는게 있으면 true */
        var tmp = item[key] + "";
        if (!(tmp.indexOf(args.searchString) == -1)) {
          return true;
        }
      }
      /*여기까지 오면 매칭되는게 하나도 없음 */
      return false;
    }

    dataView.setFilterArgs({
      searchString: search_string,
    });
    dataView.setFilter(myFilter);

    // wire up the search textbox to apply the filter to the model
    
    pgm_mngr.get(grid_name+"-txtSearch").keyup(function (e) {
      Slick.GlobalEditorLock.cancelCurrentEdit();

      // clear on Esc
      if (e.which == 27) {
        this.value = "";
      }

      search_string = this.value;
      dataView.setFilterArgs({
        searchString: search_string,
      });
      dataView.refresh();
    });


    /*헤더 모양*/
    pgm_mngr.get(grid_name+"-filter")
      .addClass("ui-state-default ui-corner-all")
      .mouseover(function (e) {
        $(e.target).addClass("ui-state-hover");
      })
      .mouseout(function (e) {
        $(e.target).removeClass("ui-state-hover");
      });

    /*필터영역 붙이기*/
    pgm_mngr.get(grid_name+"-inlineFilterPanel").appendTo(grid.getTopPanel()).show();

    /*필터 돋보기 버튼 클릭 */
    pgm_mngr.get(grid_name+"-filter").on("click", function (e) {
      grid.setTopPanelVisibility(!grid.getOptions().showTopPanel);
    });

    /*summary */

    grid.onClick.subscribe(function (e, args) {
      if (selectActiveRow) {
        if ($.inArray(args.row, selectedRows) === -1) {
          selectedRows = [];
          selectedRows.push(args.row)
        } else {
          selectedRows = [];
        }
      } else {
        ($.inArray(args.row, selectedRows) === -1) ? selectedRows.push(args.row) : selectedRows.splice(selectedRows.indexOf(args.row), 1);
      }
      grid.setSelectedRows(selectedRows);
    });

    /*써머리 */
    if (options.showTotalSummary == true) {
      grid.onCellChange.subscribe(function (e, args) {
        UpdateTotal(args.cell, args.grid);
      });

      grid.onColumnsReordered.subscribe(function (e, args) {
        UpdateAllTotals(args.grid);
      });
    }
  }

  
  this.LoadData = function (url, param) {
    grid.setSelectedRows([]);  /*체크박스가 있다면 선택을 지움*/
    pgm_mngr.showProgress();
    send_post_ajax(url, param, function (data) {
      /* 그리드 칸을 모두 지운다음에 */
      /*초기화*/
      dataView.beginUpdate();
      dataView.getItems().length = 0;
      dataView.endUpdate();  //여기서 validate이 실행되네..  잡을 방법이 없다.

      /*데이터가 로드 되었을때 유일한 id를 하나씩 가져야한다. */
      for (var i = 0; i < data.length; i++) {
        data[i].id = getUUID();
        data[i]._status = '*';  /*DB에서 불러왔다는 표시 */
      }

      /*데이터 다시 세팅 */
      dataView.setItems(data);
      pgm_mngr.hideProgress();

      if (options.showTotalSummary == true) {
        UpdateAllTotals(grid,showTotalSummaryColumn)
      }
    })
  }
  this.GetCheckedData = function () {
    /* 선택된 row 가져오기
     https://qiita.com/t-iguchi/items/95c6b1a60ab44ab96e3d
     */
    var check_data = grid.getSelectedRows();  /*행번호를 가져온다. */
    var arr_data = []
    check_data.forEach(function (value) {
      //console.log(JSON.stringify(grid.dataView.getItem(value)));
      var tmp = dataView.getItem(value);
      arr_data.push(tmp)
    });
    return arr_data;
  }
  this.GetSelectedData = function () {

    return this.GetCheckedData();
  }
  this.GetChagedData = function () {
    return editedRows;
  }
  this.Validate = function () {
    /*포커스가 그리드 안에 있다면 포커스를 벗어나게 해준다. validate체크   true면 문제 false면 ok */
    //Slick.GlobalEditorLock.isActive() && !Slick.GlobalEditorLock.commitCurrentEdit()
    /*! 를 붙여 false면 문제 true면 ok */
    Slick.GlobalEditorLock.isActive() && !Slick.GlobalEditorLock.commitCurrentEdit()

    return !(Slick.GlobalEditorLock.isActive() && !Slick.GlobalEditorLock.commitCurrentEdit());
  }



  this.addEvent = function (event_name, p_func){
    if(event_name!="click") {
        return;
    } 
    grid.onClick.subscribe(function (e, args) {
      e.preventDefault();
      p_func(e, args, grid)
    });
  }



  this.showTotalSummary = function (show_total_summary_column) {
    if (show_total_summary_column) {
      options = $.extend(basic_options, {
        createFooterRow: true,  /*하단 써머리*/
        showFooterRow: true,  /*하단 써머리*/
        footerRowHeight: 30,  /*하단 써머리*/
        showTotalSummary: true
      });
      showTotalSummaryColumn = show_total_summary_column;
    }

  }

  function UpdateAllTotals(grid, showTotalSummaryColumn) {
    if (showTotalSummaryColumn) {
      for (var i = 0; i < showTotalSummaryColumn.length; i++) {
        UpdateTotal(showTotalSummaryColumn[i], grid);
      }
    }
  }

  function UpdateTotal(columnId, grid) {
    var total = 0;
    var i = dataView.getLength();
    while (i--) {
      total += (parseInt(dataView.getItemByIdx(i)[columnId], 10) || 0);
    }
    var columnElement = grid.getFooterRowColumn(columnId);
    total = Slick.Formatters.MoneyFormatter(null,null,total);
    $(columnElement).html(total);
    //console.log(columnElement);
    //console.log($(columnElement));
    $(columnElement).attr("style","text-align:right")
  }
}