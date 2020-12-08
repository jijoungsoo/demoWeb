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
      minBodyHeight: 30,
      rowHeaders: ['rowNum'],
      columns: [
        {
          header: '프로그램',
          name: 'pgmId',
          width: 80,
          resizable: false
        },
        {
          header: '프로그램명',
          name: 'pgmNm',
          width: 100
        },
        
        {
          header: '카테고리',
          name: 'category',
          width: 80,
        },
        {
          header: '프로그램링크',
          name: 'pgmLink'
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
            width: 120
        },
        {
            header: '수정일',
            name: 'updtDtm',
			renderer: {
             	type: datetimeRenderer
			},
            width: 120
                
        }
        
      ],
      columnOptions: {
          resizable: true
        }
    });
    


    searchForm.addEvent("save", "click", function (e) {
        //'createData|updateData|deleteData|modifyData'
    	grid.request('createData'); // Uses the 'GET' method to send a request to '/api/createData'.
    });

    searchForm.addEvent("search", "click", function (e) {
    	grid.reloadData();
    });
    

	/*https://github.com/nhn/tui.grid/blob/master/packages/toast-ui.grid/docs/ko/data-source.md
 	
 	grid.request('updateData'); // Uses the 'POST' method to send a request to '/api/updateData'.
 	*/
}  
</script>
<!--하단에 공통으로 스크립트를 넣을 것이 필요하다.-->
<%@ include file="/WEB-INF/jsp/include/inner_bottom.jsp" %>