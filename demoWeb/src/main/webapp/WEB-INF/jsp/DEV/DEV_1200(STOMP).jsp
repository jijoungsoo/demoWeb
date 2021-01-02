
<%	String pgmId = (String) request.getAttribute("pgmId");
	String uuid = (String) request.getAttribute("uuid");
%>
<script>
$(document).ready(function(){
	var DEV_1200 = new PgmPageMngr ('<%=pgmId%>', '<%=uuid%>');
		DEV_1200.init(function(p_param) {
			var _this = DEV_1200;
			var socketForm = new FormMngr(_this, "socket_area");

			var ws_stomp = null
			var stomp_client =null;
			function wsopen() {
				ws_stomp = new SockJS("/ws-stomp");
				stomp_client = Stomp.over(ws_stomp)
				var header = {
					UUID : _this.getId()
					
				}
					
				stomp_client.connect(header,function(frame){
					console.log("Info: connected stomp.");
					console.log(frame)
					///stomp_client.send('/socketApi',{},'aaaaaaaa')
					stomp_client.subscribe('/topic/message',function (msg){
						console.log('aaa',msg);
							var output = socketForm.get("OUTPUT");
							var txt = output[0].value;
							txt = txt + msg.body + "\n";
							output[0].value = txt;	
					});
				})
				/* 이게 있으면 stomp_client가   connected되지 않는다. 꼭!! 잊지말자.
				ws_stomp.onopen = function() {
					console.log("Info: connection opened.");
				}
				*/

				ws_stomp.onclose = function(event) {
					console.log('Info: connection closed.');
					//서버상황에 따라 종료가 된다면 1초에 한번 다시 연결 시도 
					//setTimeout( function(){ wsopen();},1000); //retry connection!!
				}

				ws_stomp.onerror = function(err) {
					console.log('Info: Error.', err);
				}
				
			}
			wsopen();

			console.log(socketForm.get("MSG"));
			socketForm.addEvent("click", "input[type=button]", function(el) {
				//console.log(el);
				switch (el.target.name) {
				case 'ws_open':
					console.log(ws_stomp)
					if (ws_stomp.readyState == 1) {
						alert('이미 열려있다.')
					}
					wsopen();
					break;

				case 'ws_close':
					alert('소켓을 닫는다.')
					ws_stomp.close();
					break;
				
				case 'send':
					var data = socketForm.getData();
					if (!data) {
						return;
					}
					if (PjtUtil.isEmpty(data.MSG)) {
						return;
					}
					console.log(ws_stomp);
					console.log(stomp_client);
					
					if (ws_stomp.readyState == 3) {
						alert('소켓이 닫혔다.')
					}
					if(stomp_client.connected==false){
						Message.alert('STOMP Client가 연결되어있지 않습니다.');
						return;
					}
					var header = {
							UUID : _this.getId()
							
						}
					stomp_client.send('/socketApi',header,data.MSG)
					socketForm.get("MSG")[0].value = ''
					break;
				}
			});
			
			
			_this.on('destory',function(){
				stomp_client.disconnect()
				ws_stomp.close();
				///잘된다..
				//alert('destory')
			})
		});
		
		
	});

</script>