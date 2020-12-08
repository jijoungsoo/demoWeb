<script>
    $(function () {
        //CM_0100.prototype = new PgmPage('CM_0100','d7c32f9e-fe35-451f-b91e-6ee5d4faa0dd');
        var obj_tmp =eval(<%=pgmId%>);
        obj_tmp.prototype = new PgmPage('<%=pgmId%>', '<%=uuid%>');
        var req_tmp=reqMap.get('<%=uuid%>'); /*파라미터를 넣는다. */
        
        var p_param={};
        if(req_tmp!=undefined){           
            $.extend(p_param, JSON.parse(req_tmp));
        }
        var tmp = new obj_tmp('<%=pgmId%>', '<%=uuid%>',p_param);
        pgmUuidMap.add("<%=uuid%>",tmp);
    });
</script>