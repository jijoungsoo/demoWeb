function send_post_ajax(p_url, p_param, p_funtion) {
    var hash = window.location.hash;
    if (hash.indexOf("#debug=Y") >= 0) {
        console.log('hash');
        console.log(hash);
        console.log("p_url=>" + p_url);
        console.log("p_param:");
        console.log(JSON.stringify(p_param));
    }
    var req=$.ajax({
        type: "POST",
        url: p_url,
        contentType: "application/json; charset=utf-8",
        accept: "application/json",
        data: JSON.stringify(p_param), //이게 포인트 였다
        dataType: "json",
    });

    req.done(function (data, status) {
        if (hash.indexOf("#debug=Y") >= 0) {
            console.log("result:");
            console.log(JSON.stringify(data));
        }
        p_funtion(data);
    });

    req.fail(function (jqXHR, textStatus) {
        console.log(jqXHR)
        console.log(textStatus)
        if (textStatus == "error") {
            var msg = "Sorry but there was an error: ";
            console.log(msg + jqXHR.status + " " + jqXHR.statusText);
        }
    });   
}

function get_page_ajax(el,p_url, p_param) {
    var hash = window.location.hash;
    if (hash.indexOf("#debug=Y") >= 0) {
        console.log('hash');
        console.log(hash);
        console.log("p_url=>" + p_url);
        console.log("p_param:");
        console.log(JSON.stringify(p_param));
    }
    var req=$.ajax({
        type: "POST",
        url: p_url,
        contentType: "application/json; charset=utf-8",
        accept: "application/json",
        data: JSON.stringify(p_param), //이게 포인트 였다
        dataType: "html",
    });

    req.done(function (data, status) {
        if (hash.indexOf("#debug=Y") >= 0) {
            console.log("result:");
            console.log(JSON.stringify(data));
        }
        el.html(data);
    });

    req.fail(function (jqXHR, textStatus) {
        console.log(jqXHR)
        console.log(textStatus)
        if (textStatus == "error") {
            var msg = "Sorry but there was an error: ";
            console.log(msg + jqXHR.status + " " + jqXHR.statusText);
        }
    });   
}

function bind_one_ajax(area_mngr, p_url, p_param ,p_function) {
    send_post_ajax(p_url, p_param, function (data) {
        if (data.length > 0) {
            for (var key in data[0]) {
                var tmp = area_mngr.get( key)
                if (tmp.length > 0) {
                    tmp.val(data[0][key]);
                }
            }
        }
        if(typeof p_function == "function") {
            p_function(data);
        }
        
    });
}

