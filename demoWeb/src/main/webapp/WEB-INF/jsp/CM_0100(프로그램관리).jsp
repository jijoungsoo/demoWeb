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
	        	  , headers: { '${_csrf.headerName}' : csrf_token }
	              , method: 'POST'
	              , contentType: 'application/json'
		              /*  이해 못함 파라미터를 던지고 싶은데 참조값이 계속 바뀌나???
	              ,serializer(params) {
	                  return Qs.stringify(params);
	              }*/
	        }
 /*
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
      minBodyHeight: 30,
      hideLoadingBar: true, /*loading 바를 숨김  별도 로딩바를 구현했으므로 필요없다.*/
      rowHeaders: ['rowNum'],
      pageOptions: {
        perPage: 5
      },
      columns: [
        {
          header: '프로그램',
          name: 'pgmId',
          width: 100,
          resizable: false,
          sortable: true,
          filter: { type: 'text', showApplyBtn: true, showClearBtn: true }
        },
        {
          header: '프로그램명',
          name: 'pgmNm',
          width: 120,
          sortable: true,
          filter: { type: 'text', showApplyBtn: true, showClearBtn: true }
        },
        
        {
          header: '카테고리',
          name: 'category',
          width: 100,
          sortable: true,
          align: "center",
          filter: 'select'  /*콤보 카테고리 */
        },
        {
          header: '프로그램링크',
          name: 'pgmLink',
          filter: {
              type: 'text',
              operator: 'OR'
            }    /*자동검색*/
        },
        {
          header: '비고',
          name: 'rmk'
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
     tui.Grid.applyTheme('striped');

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
    


    searchForm.addEvent("save", "click", function (e) {
        //'createData|updateData|deleteData|modifyData'
    	grid.request('createData'); // Uses the 'GET' method to send a request to '/api/createData'.
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

    /*예제  23. Client Pagination   */
    const appendedData = {
    		pgmId: '',
    		pgmNm: '',
    		category: '',
    		pgmLink: '',
    		rmk: '',
    	    };
    	    

    searchForm.addEvent("add_row", "click", function (e) {
    	Message.confirm('행을 추가하시겠습니까?',function()  {
    		// grid.prependRow(appendedData); 앞에다 더하기 
        	grid.appendRow(appendedData)   /*뒤에다 더하기 */
		});
    });

    

	/*https://github.com/nhn/tui.grid/blob/master/packages/toast-ui.grid/docs/ko/data-source.md
 	
 	grid.request('updateData'); // Uses the 'POST' method to send a request to '/api/updateData'.
 	*/
}  
</script>
<!--하단에 공통으로 스크립트를 넣을 것이 필요하다.-->
<%@ include file="/WEB-INF/jsp/include/inner_bottom.jsp" %>