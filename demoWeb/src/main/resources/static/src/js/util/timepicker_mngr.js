class TimePickerMngr {
	constructor(pgm_mngr, el_name,p_options) {
	/*참고 사이트 https://harui.tistory.com/75 */
	/*참고 사이트 http://www.nextree.co.kr/p9887/ */
	/*참고 사이트 https://offbyone.tistory.com/230 */
	   var basic_options = {
	         showButtonPanel: true, 
	         changeYear: true,
	         changeMonth: true,
//	         numberOfMonths: [1,3],  //한화면에 몇게 보여질찌 정한다. 3개월씩보이도록 하자.
//	         yearRange: "1996:+0",   /* 1996년부터, 지금까지. https://qastack.kr/programming/13865218/jquery-ui-datepicker-set-year-range-dropdown-to-100-years*/
//	         stepMonths: 3,  /*이전 다음 누를때 몇개월씩 이동할 것인지 */
	         currentText: "오늘날짜",
	         closeText: '닫기', 
	         dayNames:
	             [ "일요일", "월요일", "화요일", "수요일",
	             "목요일", "금요일", "토요일" ],
	         dayNamesMin:
		             [ "일", "월", "화", "수",
		             "목", "금", "토" ],
		     monthNames:
		                 [ "1월", "2월", "3월", "4월", "5월", "6월",
		                 "7월", "8월", "9월", "10월", "11월", "12월" ],
		     monthNamesMin:
			                 [ "1월", "2월", "3월", "4월", "5월", "6월",
			                 "7월", "8월", "9월", "10월", "11월", "12월" ],
			 showWeek: false,
			 showOtherMonths: true, /*월 1일 이전, 월 말일 이후 빈칸에 이전달, 다음달 날짜 출력 여부*/ 
			 weekHeader: "주",
	         dateFormat: "yymmdd"
	         /*
	         ,
	         onClose: function () {
               var altFormat = $(this).datepicker('option', 'altFormat');
               var dateFormat = $(this).datepicker('option', 'dateFormat');
               var currentDate = $(this).datepicker('getDate');
               var formattedDate = $.datepicker.formatDate(altFormat, currentDate);
               $('#' + this.id.replace('DatePicker', '')).val(formattedDate);
           	 }*/
           	 
	  	}
	  	this.options = $.extend(basic_options, p_options);
		pgm_mngr.get(el_name).datepicker(this.options);
    }
}
