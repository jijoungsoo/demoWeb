function SelectBoxMngr(form_mngr,name, p_url, p_param) {
/*https://select2.org/data-sources/formats*/

/* pagination
    {
  "results": [
    {
      "id": 1,
      "text": "Option 1"
    },
    {
      "id": 2,
      "text": "Option 2"
    }
  ],
  "pagination": {
    "more": true
  }
}
*/

/* select ,disbled
{
  "results": [
    {
      "id": 1,
      "text": "Option 1"
    },
    {
      "id": 2,
      "text": "Option 2",
      "selected": true
    },
    {
      "id": 3,
      "text": "Option 3",
      "disabled": true
    }
  ]
}

id,text형태로 받는다.
*/

  send_post_ajax(p_url, p_param, function (data) {
    var tmp=[]
    for(var i=0;i<data.length;i++){
      tmp.push({id: data[i].cd , text : data[i].cd_nm});
    }
    
    form_mngr.get(name).select2( {
      data: tmp,
      width: 200  
    });
  })
}