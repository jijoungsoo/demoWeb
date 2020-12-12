<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/include/inner_top.jsp" %>
<%	String pgmId = (String) request.getAttribute("pgmId");
	String uuid = (String) request.getAttribute("uuid");
%>
<script>


</script>
<div id="<%=uuid%>">
  <div name="search_area">
    <table>
      <tr>
        <td><input type="button" name="search" value="조회" /></td>
        <td><input type="button" name="add_row" value="추가" /></td>
        <td><input type="button" name="save" value="저장" /></td>
        <td><input type="button" name="del" value="삭제" /></td>
      </tr>
    </table>
  </div>
  <div id="<%=uuid%>-grid"></div>
</div>
<script>
var CM_0100 = function () {
    var _this = this;
    var searchForm = new PgmForm(_this, "search_area");
/*
 *  컬럼 너비 지정
 https://github.com/nhn/tui.grid/blob/master/packages/toast-ui.grid/docs/ko/setting-width-height.md
 */
 const dataSource = {
		  api: {
			readData: { url: '/api/findPgm'
				  ,headers: { '${_csrf.headerName}' : csrf_token } 	  
	              , method: 'POST'
	              , contentType: 'application/json' /* -- 여기가 아니라 밑에다가 전체적으로 쓸수있다. 그런데 잘 안됨*/
	              
		              /*  이해 못함 파라미터를 던지고 싶은데 참조값이 계속 바뀌나???
	              ,serializer(params) {
	                  return Qs.stringify(params);
	              }*/
	        },
 			/*, headers: { '${_csrf.headerName}' : csrf_token }  */
 			/*,contentType: 'application/json'*/
 			/* 이거 사용할 필요가 없다   grid.getModifiedRows 클릭하면 create,update, delete가 json 형태로 트리로 한나의 root로 나타난다.
 	 	    createData: { url: '/api/createData', method: 'POST' },
 		    updateData: { url: '/api/updateData', method: 'PUT' },
		    modifyData: { url: '/api/modifyData', method: 'PUT' },
		    deleteData: { url: '/api/deleteData', method: 'DELETE' }
	        */
		  },
		  initialRequest: false // 디폴트 값은 true  true면 로딩시 조회, false면 클릭조회
		};
	
  const grid = new tui.Grid({
      el: document.getElementById('<%=uuid%>-grid'),
      data: dataSource,
      scrollX: false,
      scrollY: false,
      width: 1100,   /*그리드 너비 조절 */
      bodyHeight: 700,  /*그리드 높이지정 */
      editingEvent:'dblclick',  /*더블클릭 수정 */
      minBodyHeight: 30,
      copyOptions: {
    	    useFormattedValue: true,   /*셀의 formatter와 함께 텍스트를 복사한다.*/
    	    useListItemText: true    /*선택 또는 체크 박스 셀의 값을 listItem의 value가 아닌 text로 복사한다.*/
    	    /*,customValue: 'custom'   문자열 또는 함수로 변경된 값을 복사한다.*/
    	  },
      hideLoadingBar: true, /*loading 바를 숨김  별도 로딩바를 구현했으므로 필요없다.*/
      rowHeaders: ['rowNum'],
      onGridUpdated: (ev) => {
          /*
          console.log('cccc')
          console.log(ev)
    	  	var t = ev.instance.getData(); 
    		t.forEach(element => { 
    			element.AAA=null;
    			}
    		)
    		ev.instance.resetData(t);
    		여기넣었더니 무한반복됨.
    	  */

    	  /*결국 별도로 ajax 호출하고 임의로 필를 위와 같이 만들어준다음에     resetData(t)  이런식으로 채워얗나다.)*/
    },




		
      columns: [
        {
          header: '프로그램',
          name: 'pgmId',
          width: 100,
          resizable: false,
          sortable: true,
          sortingType: 'desc', /*내림차순   ctrl 키를 누르고 정렬키를 여러개 누르면 이어서 정렬이 된다.*/
          filter: { type: 'text', showApplyBtn: true, showClearBtn: true },   /*text, number, select, date 4가지가 있다.*/
          validation: {
            dataType: 'string',  /*string ,number*/
            required: true,    /*  true 필수, false 필수아님  */
            unique: true   /*true 데이터가 중복되면 빨간색 표시 */
          },
          editor: 'text'
        },
        {
          header: '프로그램명',
          name: 'pgmNm',
          width: 'auto',   /*너비 자동조절*/
          sortable: true,
          filter: { type: 'text', showApplyBtn: true, showClearBtn: true },
          editor: 'text'
              /*
https://github.com/nhn/tui.grid/tree/master/packages/toast-ui.grid/docs/ko 설명서              
내장에디터 종료
https://github.com/nhn/tui.grid/blob/master/packages/toast-ui.grid/docs/ko/custom-editor.md              
text : Text input (input[type=text])
password : Password input (input[type=password])
checkbox : Check box (input[type=checkbox])
radio : Radio button (input[type=radio])
select : Select box (select)
              */
        },
        
        {
          header: '카테고리',
          name: 'category',
          width: 100,
          sortable: true,
          align: "center",
          filter: 'select',  /*콤보 카테고리 */
          formatter: 'listItemText',
          editor: {
              type: 'select',
              options: {
                listItems: [
                  { text: 'CM', value: 'CM' },
                  { text: '키움', value: '키움API' },
                ]
              }
            }
        },
        {
          header: '프로그램링크',
          name: 'pgmLink',
          editor: 'text',
          filter: {
              type: 'text',
              operator: 'OR'
            },    /*자동검색*/
          validation: {
              dataType: 'string',  /*string ,number*/
              required: true,    /*  true 필수, false 필수아님  */
              unique: true   /*true 데이터가 중복되면 빨간색 표시 */
            },
          
        },
        {
          header: '비고',
          name: 'rmk',
          editor: 'text'
        },
        {
            header: 'row status',
            name: 'AAA',
            editor: 'text'
        },
        {
            header: '생성일',
            name: 'crtDtm',
            renderer: {
                type: datetimeRenderer
            },
            width: 120,
            sortable: true,
            filter: {
                type: 'date',
                format: 'yyyy-MM-dd'
                    /*'yyyy-MM-dd HH:mm A'*/
                    /*실제 데이터랑 비교하나보다 .. 비교가 안된다. */
              }
        },
        {
            header: '수정일',
            name: 'updtDtm',
			renderer: {
             	type: datetimeRenderer
			},
            width: 120,
            sortable: true    
            /*,  filter: 'number'  숫자일경우 비교 */            
        }
        /* 안먹음..
        ,
        {
            header: 'rowKey',
            name: 'rowKey'
        }
        */
        
        
      ],
      columnOptions: {
          resizable: true,
          frozenCount: 1,
          frozenBorderWidth: 2,
          minWidth: 60
        },
        showDummyRows: true   /*높이만큼 비어있으면 비어있는 컨텐츠를 보여준다.*/
    });
    //default  striped  clear
     tui.Grid.applyTheme('striped', {
		 frozenBorder: {
			    border: '#ff0000'
			}
     });
     tui.Grid.setLanguage('ko',// set new language
    	     /*이거 재 정의 하면 문구 바꿀수있다.*/ 
    	     { 
               display: {
                       noData: '데이터 없음.',
                       loadingData: 'Loading data.',
                       resizeHandleGuide: 'You can change the width of the column by mouse drag, ' +
                                           'and initialize the width by double-clicking.'
                   },
                   net: {
                       confirmCreate: '{{count}}개의 데이터를 추가하시겠습니까?',
                       confirmUpdate: 'Are you sure you want to update {{count}} data?',
                       confirmDelete: 'Are you sure you want to delete {{count}} data?',
                       confirmModify: 'Are you sure you want to modify {{count}} data?',
                       noDataToCreate: 'No data to create.',
                       noDataToUpdate: 'No data to update.',
                       noDataToDelete: 'No data to delete.',
                       noDataToModify: 'No data to modify.',
                       failResponse: 'An error occurred while requesting data.\nPlease try again.'
                   }
              }); /*메시지를 한국어로 표기 */

     grid.on('beforeRequest', function(ev) {
    		_this.showProgress(); 
	   	  console.log('요청을 보내기 전')
	   	  console.log(ev)
   	});
   	grid.on('response', function(ev) {
   		  _this.hideProgress(); 
     	  console.log('성공/실패와 관계 없이 응답을 받았을 경우')
	   	  console.log(ev)
	   	     	
   	});
   	
   	grid.on('failResponse', function(ev) {
     	  console.log('결과가 false인 경우')
	   	  console.log(ev)
   	});
   	grid.on('errorResponse', function(ev) {
     	  console.log('오류가 발생한 경우')
	   	  console.log(ev)
   	});
	/* 이거 에러가 난다.
   	grid.on('successResponse', function(ev) {
   	  console.log('결과가 true인 경우');
	   	  console.log(ev);
 	});
 	*/

 	 grid.on('afterChange', ev => {
 		console.log('aaaaaa', ev);
 	      console.log('check!', ev);
 	    });

	 grid.on('editingFinish', ev => {
		 /*수정이벤트가 일어나면 여기가 고고 한다.*/
		 console.log('bbb');
	 		console.log('aaaaaa', ev);
	 	      console.log('check!', ev);		 
    	var tmp = ev.instance.dataManager.getModifiedData('UPDATE',{rowKeyOnly: true}).updatedRows;
    	console.log('aaa');
    	console.log(tmp);
    	if(tmp!=undefined && tmp.length>0) {
	    	if(tmp.indexOf(ev.rowKey)>=0){
	    		console.log('aaa1111');
	    		/*이렇게 해도 값이 안들어가는데 이유는 초기에 data에   상태 필드에 값이 안들어가기 때문이다. 그래서 
	    		처음에 상태를 보여준다고 한다면 

	    		데이터를 조회하였을때 
	    		var t = grid.getData();   데이터를 가져와서 
	    		상태필드에 해당하는 값을 null로 기본 세팅을 해주어야한다.
	    		AAA를 상태필드라고 한다면  디폴트로 null을 해준다음에
	    		var t = grid.getData(); 
	    		t.forEach(element => { 
	    			element.AAA=null;
	    			}
	    		)
	    		grid.resetData(t);    다시 값을 넣어주어야한다.
	    		또한 상태필드 요청에 따라 처음에 column을 설정할때 앞에다가 넣어주어야한다.
	    		
	    		*/
	    		ev.instance.setValue(ev.rowKey,  'AAA' /*columnName*/,'C');
	    		return;
	    	}
    	}
    	
    	
    	var tmp = ev.instance.dataManager.getModifiedData('CREATE',{rowKeyOnly: true}).createdRows;
    	console.log(tmp);
    	if(tmp!=undefined && tmp.length>0 ) {
	    	if(tmp.indexOf(ev.rowKey)>=0){
	    		console.log('aaa22222');
	    		ev.instance.setValue(ev.rowKey, 'AAA' /*columnName*/, 'M');
	    	}
    	}

	 	    });
    
console.log(grid);

    searchForm.addEvent("save", "click", function (e) {
    	//var data  = grid.getModifiedRows({});
    	var data = grid.getData();
    	console.log(data);

    	/*
    	
    커서텀 rederer를 만들어서
    getModifiedData: function (type, options)  이걸로 가져온다음에..
	'type'  UPDATE,CREATE 등을 넣으면  수정여부를 표시할수있음. 삭제한것은 어차피 그리드에서 안보임

	options에  rowKeyOnly  이걸 넣어주면 rowKey만 넘어온다고 한다.
	
	grid.dataManager.getModifiedData('UPDATE',{rowKeyOnly: true})
	{ updateRows: [11]  } 
    	이런식임 2개 이면 updateRows: [11,3] 
    	이런식임  배열에서 원소 찾는 법
    	[11,3].indexOf(1)  없어서 -1
    	[11,3].indexOf(11)  있어서 첫번째 요소인 0
    	[11,3].indexOf(3)  있어서 두번째 요소인 1
    	[11,3].includes(11)  포함해서 true
    	[11,3].includes(1)  포함하지 않아서 false
    	
    	*/

/* 선택된 셀들의 범위를 가져오기 
    	grid.getSelectionRange()
*/    
/*
 * 
 선택된 행을 가져온느게 없어서 사용자가 만ㄷ것 
 https://github.com/nhn/tui.grid/issues/303
 */
    	
        //'createData|updateData|deleteData|modifyData'
    	//grid.request('createData'); // Uses the 'GET' method to send a request to '/api/createData'.
    });

    searchForm.addEvent("search", "click", function (e) {
	
    	grid.reloadData();
    	/* read시점에서 파라미터 관련 한 내용
		https://ui.toast.com/weekly-pick/ko_monthly_202001

			let applicationId = "id";

		// ...
		const dataSource = {
		  api: {
		    readData: {
		      url: "/readData",
		      method: "get",
		      initParams: { a: 1 },
		    },
		    createDta: {
		      url: "/createData",
		      method: "post",
		      contentType: "application/json",
		    },
		    deleteData: {
		      url: () => `/deleteData/${applicationId}`,
		      method: "delete",
		    },
		  },
		  // 커스텀 serializer 정의
		  serializer: (params) => {
		    return QS.stringify(params);
		  },
		};

		이것도 그런데..
		// 특정 페이징 상태 유지
		
		
		https://ui.toast.com/weekly-pick/ko_monthly_202005

			
		const pageState = { page: 2, totalCount: 20, perPage: 5 };

		grid.resetData(data, { pageState });

		// 특정 정렬 상태 유지
		const sortState = { columnName: "alphabetA", ascending: true };

		grid.resetData(data, { sortState });

    	
    	*/
    	
    });
    /*  고정하는 컬럼수 변경
    grid.setFrozenColumnCount(2); // 고정하고자 하는 컬럼의 갯수
*/    

    /*예제  23. Client Pagination   */
    const appendedData = {
    		pgmId: '',
    		pgmNm: '',
    		category: '',
    		pgmLink: '',
    		rmk: '',
    		AAA: ''
    	    };
    	    

    searchForm.addEvent("add_row", "click", function (e) {
        
    	Message.confirm('행을 추가하시겠습니까?',function()  {
    		// grid.prependRow(appendedData); 앞에다 더하기 
        	grid.appendRow(appendedData)   /*뒤에다 더하기 */
		});
    });

    searchForm.addEvent("del", "click", function (e) {
        //removeCheckedRows
        //removeCheckedRows(true);
        //removeTreeRow(rowKey)
        //getCheckedRows()
        
    	//grid.request('deleteData');
    	//grid.getData();
    	grid.removeRow(0);
    });

    

    

	/*https://github.com/nhn/tui.grid/blob/master/packages/toast-ui.grid/docs/ko/data-source.md
 	
 	grid.request('updateData'); // Uses the 'POST' method to send a request to '/api/updateData'.
 	*/
}  
</script>
<!--하단에 공통으로 스크립트를 넣을 것이 필요하다.-->
<%@ include file="/WEB-INF/jsp/include/inner_bottom.jsp" %>