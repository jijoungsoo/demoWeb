<div name="socket_area" style="border: 1px solid #ccc; padding: 10px; border-radius: 10px;">
	<ul><h2>STOMP</h2>
		<li>WebSocketStompConfig.java</li>
		<li>WebSocketEventListener.java</li>
		<li>ApiSocketStompRestController.java</li>
	</ul>
	<div class="container">
		<div class="row row-cols-1">
			<div class="col">
				<div class="form-group">
					<div class="input-group">
						<textarea class="form-control" rows='10' disabled  readonly data-ax-path="OUTPUT"  name="OUTPUT"></textarea>
					</div>
				</div>
			</div>
			<div class="col-sm">
				<div class="form-group">
					<div class="input-group">
						<span class="input-group-addon">메시지</span> 
						<input type="text" class="form-control"  data-ax-path="MSG"  name="MSG">
					</div>
				</div>
			</div>			
		</div>
	</div>
	<div style="padding: 10px;">
		<input type="button" name="send" value="send" />
		<input type="button" name="ws_open" value="ws_open" /> 
		<input type="button" name="ws_close" value="ws_close" />
	</div>
<pre>** 소켓의 단점
** 항상연결되어있다.
CONNECTING	0	연결이 수립되지 않은 상태입니다.
OPEN	1	연결이 수립되어 데이터가 오고갈 수 있는 상태입니다.
CLOSING	2	연결이 닫히는 중 입니다.
CLOSED	3	연결이 종료되었거나, 연결에 실패한 경우입니다.
</pre>
	
</div>
