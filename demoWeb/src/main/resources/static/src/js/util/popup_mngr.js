function PopupManger(pgm_mngr, page_id, options, p_param) {  /*page_id로 페이지내에 유일한 div로 생각한다. 앞에서 넘길때  uuid까지 조합해서 만들어야한다. */
    /*
    아이디어들 ==>
    https://gist.github.com/craigmccoy/3753941
    https://stackoverflow.com/questions/3837166/jquery-load-modal-dialog-contents-via-ajax
    */
   var uuid = pgm_mngr.getId();
    var defaults = {
        dialogClass: "no-close",
        appendTo: "#" + uuid,   /*이건 사실 큰 의 미 없다. */
        autoOpen: false,        /*초기화 즉시 다이얼로그를 열지 */
        closeOnEscape: false,   /*esc  를 누를때 닫히게 할지*/
        resizable: true,       /*사이즈 조절을 가능하게 할지 */
        modal: true,         /*  뒤에가 클릭이 안되도록   */
        draggable: true,   /*false면 창이 안움직인다. */
        height: 700,
        width: 600,
        open: function () {
        },
        beforeClose: function () {
        }
    }

    // Merge defaults and options, without modifying defaults
    var settings = $.extend({}, defaults, options);
    var tmp = `
    <div id="`+ uuid + `-` + page_id + `-popup">

    </div>
    `
    $("#" + uuid + "-" + page_id + "-popup").remove();
    $("#" + uuid).append(tmp);  //윈도우창에 프로그래스 div를 추가한다.
    $("#" + uuid + "-" + page_id + "-popup").css('display', 'none');
    var dialog = $("#" + uuid + "-" + page_id + "-popup").dialog(settings);

    /*  이 방법도 되고 아래 방법도 된다.
        $.ajaxSetup({
            contentType: "application/json; charset=utf-8",   // 요청된 데이터의 타입 결정 
            accept: "application/json"
        });
        $("#" + uuid + "-" + page_id + "-popup").load(page_id, p_param, function (response, status, xhr) {
            if (status == "error") {
                var msg = "Sorry but there was an error: ";
                console.log(msg + xhr.status + " " + xhr.statusText);
            }
        });
    */
   
    //
    var popup_uuid=getUUID() ;
    //uuid="+popup_uuid
    var p_param = $.extend(p_param, {uuid : popup_uuid});

    var req = $.ajax({
        type: "POST",
        url: page_id,
        contentType: "application/json; charset=utf-8",   // 요청된 데이터의 타입 결정 
        accept: "application/json",
        data: JSON.stringify(p_param), //이게 포인트 였다
        dataType: "html"   // 리턴된 데이터의 타입결정   
    });

    req.done(function (data) {
        reqMap.add(popup_uuid,JSON.stringify(p_param)); /*파라미터를 넣는다. */
        $("#" + uuid + "-" + page_id + "-popup").html(data);
       
    });

    req.fail(function (jqXHR, textStatus) {
        console.log(jqXHR)
        console.log(textStatus)
        if (textStatus == "error") {
            var msg = "Sorry but there was an error: ";
            console.log(msg + jqXHR.status + " " + jqXHR.statusText);
        }
    });
    


    dialog.on("dialogopen", function (event, ui) {
        var a = $("#" + uuid)
        var tmp_style = 'top:' + a.offset().top + 'px !important;left' + a.offset().left + 'px !important;height: ' + a.offset().height + 'px !important;width' + a.offset().width + 'px !important; z-index: 100;'
        $("#" + uuid + " .ui-widget-overlay").attr('style', tmp_style);
    });

    this.open = function () {
        //console.log(dialog);
        dialog.dialog("open");
    }
    this.close = function () {
        dialog.dialog("close");
    }
}

