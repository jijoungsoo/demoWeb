<%	String uuid = (String) request.getAttribute("uuid");	%>
<script>
$(document).ready(function(){
	var CM_2900 = new PgmPageMngr ('<%=uuid%>');
	CM_2900.init(function(p_param) {
		var _this = CM_2900;
		var searchForm = new FormMngr(_this, "search_area");
		searchForm.initCombo("MSG_TMPL_KIND_CD",'BR_CM_CD_FIND', {brRq: 'IN_DATA',brRs: 'OUT_DATA',IN_DATA: [{  GRP_CD : 'MSG_TMPL_KIND_CD', USE_YN: 'Y'}]},{ USE_EMPTY_YN : 'Y' , VALUE :'CD' , TEXT :'CD_NM' });
		searchForm.initCombo("MSG_TMPL_STATUS_CD",'BR_CM_CD_FIND', {brRq: 'IN_DATA',brRs: 'OUT_DATA',IN_DATA: [{  GRP_CD : 'MSG_TMPL_STATUS_CD', USE_YN: 'Y'}]},{ USE_EMPTY_YN : 'Y' , VALUE :'CD' , TEXT :'CD_NM' });
		searchForm.setData("MSG_TMPL_KIND_CD","");
		searchForm.setData("MSG_TMPL_STATUS_CD","");

		var tabForm = new TabMngr(_this, "tab_area");
		tabForm.appendTab(
			[	{INDEX : 0,  PGM_ID : 'CM_2910' ,PARAM : null } ]
		);

		tabForm.build({
				active: 0
		});		

		_this.on("remoteCall",function(data){
				console.log('CM_2900-remoteCall  ---  vvvvvv')
				var detail =data.detail; 
				console.log(detail);
				switch (detail.ACTION) {
					case 'SEARCH':
						searchForm.get("search").trigger("click");
					break;
				}
			});


		const grid = new TuiGridMngr(_this,'grid',{
	      editable: false
	      ,showRowStatus: false
	      ,rowNum: true
	      ,checkbox: false
	      ,width: 900               /*그리드 너비 조절 */
	      ,bodyHeight: 500           /*그리드 높이지정 */
	      ,showDummyRows: false
	  	},
	  	[
	  	  	{
	           header: 'SEQ',
	           name: 'TMPL_SEQ',
	           width: 60,
			   align: "right"
	         },{
		           header: '템플릿구분',
		           name: 'MSG_TMPL_KIND_CD',
		           width: 100,
				   type : "combo",
				   comboData : _this.getComboData('BR_CM_CD_FIND', {brRq: 'IN_DATA',brRs: 'OUT_DATA',IN_DATA: [{ GRP_CD : 'MSG_TMPL_KIND_CD', USE_YN: 'Y'}]},{ USE_EMPTY_YN : 'Y' , VALUE :'CD' , TEXT :'CD_NM' })
		         },
		         {
		           header: '템플릿상태',
		           name: 'MSG_TMPL_STATUS_CD',
		           width: 100,
		           type : "combo",
				   comboData : _this.getComboData('BR_CM_CD_FIND', {brRq: 'IN_DATA',brRs: 'OUT_DATA',IN_DATA: [{ GRP_CD : 'MSG_TMPL_STATUS_CD', USE_YN: 'Y'}]},{ USE_EMPTY_YN : 'Y' , VALUE :'CD' , TEXT :'CD_NM' })
		         },
				 {
				  header: '제목',
				  name: 'TTL',
				  width: 100
				 },
				 {
				  header: '내용',
				  name: 'MSG',
				  width: 100
				 },
				 {
				   header: '비고',
				   name: 'RMK',
				   width: 100
				 },
		         {
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
						TMPL_SEQ : row_data.TMPL_SEQ
				}
				tabForm.remoteCall('CM_2910', { detail: param });
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
		    	grid.loadData('BR_CM_MSG_TMPL_FIND',param,function(data){

		    	});
               break;      
	  	   }
	  	});
	    searchForm.get("search").trigger("click");
	});
});
</script>