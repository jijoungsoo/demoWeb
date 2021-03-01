<%	String uuid = (String) request.getAttribute("uuid");	%>
<script>
$(document).ready(function(){
	var CM_3300 = new PgmPageMngr ('<%=uuid%>');
	CM_3300.init(function(p_param) {
		var _this = CM_3300;
		var searchForm = new FormMngr(_this, "search_area");
		var tabForm = new TabMngr(_this, "tab_area");
		tabForm.appendTab(
			[	{INDEX : 0,  PGM_ID : 'CM_3320' ,PARAM : null } ]
		);

		tabForm.build({
			active: 0
		});		

		const grid = new TuiGridMngr(_this,'grid',{
	      editable: true
	      ,showRowStatus: true
	      ,rowNum: true
	      ,checkbox: true
	      ,width: 1400               /*그리드 너비 조절 */
	      ,bodyHeight: 700           /*그리드 높이지정 */
	      ,showDummyRows: false
	  	},
	  	[
				{
					header: '발송SEQ',
					name: 'SND_SEQ',
					width: 100,
					resizable: false,
					sortable: true,
					sortingType: 'desc' /*내림차순   ctrl 키를 누르고 정렬키를 여러개 누르면 이어서 정렬이 된다.*/
				},{
				   header: '발송상태',
				   name: 'SND_STATUS_CD',
				   width: 100,
				   type : "combo",
				   comboData : _this.getComboData('BR_CM_CD_FIND', {brRq: 'IN_DATA',brRs: 'OUT_DATA',IN_DATA: [{ GRP_CD : 'SND_STATUS_CD', USE_YN: 'Y'}]},{ USE_EMPTY_YN : 'Y' , VALUE :'CD' , TEXT :'CD_NM' })
				},{
				   header: '발송타입',
				   name: 'SND_TYPE_CD',
				   width: 100,
				   type : "combo",
				   comboData : _this.getComboData('BR_CM_CD_FIND', {brRq: 'IN_DATA',brRs: 'OUT_DATA',IN_DATA: [{ GRP_CD : 'SND_TYPE_CD', USE_YN: 'Y'}]},{ USE_EMPTY_YN : 'Y' , VALUE :'CD' , TEXT :'CD_NM' })
				},{
		           header: '제목',
		           name: 'TTL',
		           width: 200,
		           sortable: true,
		           align: "left"
				},{
		           header: '내용',
		           name: 'CNTNT',
		           width: 200,
		           sortable: true,
		           align: "left"
		         },{
				  header: '발송자명',
				  name: 'SNDR_NM',
				  width: 100
				 },{
				   header: '발송자주소',
				   name: 'SNDR_ADDR',
				   width: 100

				},{
				   header: '발송자주소',
				   name: 'SNDR_ADDR',
				   width: 100
				},{
				   header: '수신자명',
				   name: 'RCV_NM',
				   width: 100
				},{
				   header: '수신자주소',
				   name: 'RCV_ADDR',
				   width: 100
				},{
				   header: '수신자수',
				   name: 'RCV_CNT',
				   width: 80,
				   align :"center"
				},{
				   header: '발송예약일자',
				   name: 'SND_DTM',
				   width: 100
				},{
				   header: '발송완료일자',
				   name: 'SND_CMPL_DTM',
				   width: 100
				 },{
		             header: '생성일',
		             name: 'CRT_DTM',
		             width: 140,
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
		             width: 140,
		             sortable: true,
		             align: "center" 
		             /*,  filter: 'number'  숫자일경우 비교 */            
		         }
		    ]
	  	);
	  	grid.build();

		grid.on('click', (ev) => {
			if (ev.rowKey >=0) {
				var row_data=grid.getRow(ev.rowKey);
				console.log(row_data);

				var param = {
						ACTION  : 'SEARCH',
						SND_SEQ : row_data.SND_SEQ
				}
				tabForm.remoteCall('CM_3320', { detail: param });
				
			}
		});


	    searchForm.addEvent("click","input[type=button]",function(el){
	  	   switch(el.target.name){
           case 'search':
        		var param ={
					 brRq : 'IN_DATA'
					,brRs : 'OUT_DATA'
					,IN_DATA:[{}]
				}
		    	grid.loadData('BR_CM_EML_SND_FIND',param,function(data){

		    	});
               break;          
           case 'add':
		   		var param = {};
				var popup = new PopupManger(_this, 'CM_3310', {
						width: 1100,
						height: 500,
						title: "이메일발송"
					},
					param
				);
				popup.open(function (data) {
					if (data) {
						searchForm.get("search").trigger("click");
					}
				});
               break;          
	  	   }
	  	});
	    searchForm.get("search").trigger("click");
	});
});
</script>