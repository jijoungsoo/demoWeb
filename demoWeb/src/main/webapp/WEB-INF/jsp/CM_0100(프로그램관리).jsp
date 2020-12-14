<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/include/inner_top.jsp" %>
<%	String pgmId = (String) request.getAttribute("pgmId");
	String uuid = (String) request.getAttribute("uuid");
%>
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
  <div name="grid"></div>
  <div id="grid1"></div>
</div>
<script>
$(document).ready(function(){
	var CM_0100 = new PgmPageMngr ('<%=pgmId%>', '<%=uuid%>');
	CM_0100.init(function(p_param) {
		var _this = CM_0100;
		var searchForm = new FormMngr(_this, "search_area");
		var columns= [
	       {
	           header: '프로그램',
	           name: 'PGM_ID',
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
	           name: 'PGM_NM',
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
	           name: 'CATEGORY',
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
	           name: 'PGM_LINK',
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
	           name: 'RMK',
	           editor: 'text'
	         },
	         {
	             header: '생성일',
	             name: 'CRT_DTM',
	             renderer: {
	                 type: datetimeRenderer
                	 ,options: {
                		 format:  'yyyy-MM-DD HH:mm'  /*YYYYMMDDHHmmss    이게 풀양식이다.*/
                         ,source: 'YYYYMMDDHHmmss'  /*TIME 초, YYYYMMDD , YYYYMMDDHHmm,  YYYYMMDDHHmmss  */
                       }
	             },
	             width: 120,
	             sortable: true,
	             align: "center",
	             filter: {
	                 type: 'date',
	                 format: 'yyyy-MM-DD'
	                     /*'yyyy-MM-dd HH:mm A'*/
	                     /*실제 데이터랑 비교하나보다 .. 비교가 안된다. */
	               }
	         },
	         {
	             header: '수정일',
	             name: 'UPDT_DTM',
	 			renderer: {
	              	type: datetimeRenderer
	              	 ,options: {
                		 format: 'yyyy-MM-DD HH:mm'  /*YYYYMMDDHHmmss    이게 풀양식이다.*/
                         ,source: 'YYYYMMDDHHmmss'  /*TIME 초, YYYYMMDD , YYYYMMDDHHmm,  YYYYMMDDHHmmss  */
                       }
	 			},
	             width: 120,
	             sortable: true,
	             align: "center" 
	             /*,  filter: 'number'  숫자일경우 비교 */            
	         }
	    ];
	
		const grid = new TuiGridMngr(_this,'grid',columns,{
	      editable: true
	      ,showRowStatus: true
	      ,rowNum: true
	      ,checkbox: true
	  	});
	  	grid.build();
	    
	    searchForm.addEvent("search", "click", function (e) {
    	 	var param ={
				 brRq : 'IN_DATA'
				,brRs : 'OUT_DATA'
				,IN_DATA:[{}]
			}
	    	grid.loadData('findPgm',param,function(data){
		    	console.log(data);
		    	//gridLoadData에서 자동으로 로드됨..
	        	
	    	});
	    });
	
	    searchForm.addEvent("add_row", "click", function (e) {
	    	Message.confirm('행을 추가하시겠습니까?',function()  {
	        	grid.appendRow();
			});
	    });
	
	    searchForm.addEvent("save", "click", function (e) {
	        var data = grid.getModifiedRows();
	        console.log(data);
	        var crt_cnt	= data.createdRows.length;
	        var updt_cnt= data.updatedRows.length;

	        
	        if((crt_cnt+updt_cnt)==0) {
	        	Message.alert("저장할 내용이 존재하지 않습니다.");
	        	return;
		    }
	        if(grid.isValid()==false) {
	        	grid.validMsg();    
	        	return;
		    }
		    var in_data = [];
		    for (var i=0;i<crt_cnt;i++){
		    	var row = data.createdRows[i];
		    	in_data.push({
		    		PGM_ID 		: row.PGM_ID,
		    		PGM_NM 		: row.PGM_NM,
		    		PGM_LINK	: row.PGM_LINK,
		    		CATEGORY 	: row.CATEGORY,
		    		RMK 		: row.RMK
		    	});
			}

		    var updt_data = [];
		    for (var i=0;i<updt_cnt;i++){
		    	var row = data.updatedRows[i];
		    	updt_data.push({
		    		PGM_ID 		: row.PGM_ID,
		    		PGM_NM 		: row.PGM_NM,
		    		PGM_LINK	: row.PGM_LINK,
		    		CATEGORY 	: row.CATEGORY,
		    		RMK 		: row.RMK
		    	});
			}
	        	        
	    	Message.confirm('저장하시겠습니까?',function()  {
	    		var param ={
					brRq 		: 'IN_DATA,UPDT_DATA'
					,brRs 		: ''
					,IN_DATA	: in_data
	    			,UPDT_DATA	: updt_data
				}
	        	CM_0100.send('savePgm',param,function(data){
		        	console.log(data);

		        });
			});
	    });
	
	    
	
	    searchForm.addEvent("del", "click", function (e) {
	        var data = grid.getCheckedData();
	        console.log(data);
	        if(data.length<=0) {
	        	Message.alert('선택된 항목이 없습니다.');
	        	return;
	        }
	        Message.confirm('삭제하시겠습니까?',function()  {
		        var param ={
					brRq : 'IN_DATA'
					,brRs : ''
					,IN_DATA:[{}]
				}
	        	CM_0100.send('rmPgm',param);
			});
	        //실제로 서버에서 삭제하는로직 필요.
	    	//grid.removeRow(0); 
	    });
	
	});
});

</script>
<!--하단에 공통으로 스크립트를 넣을 것이 필요하다.-->
<%@ include file="/WEB-INF/jsp/include/inner_bottom.jsp" %>