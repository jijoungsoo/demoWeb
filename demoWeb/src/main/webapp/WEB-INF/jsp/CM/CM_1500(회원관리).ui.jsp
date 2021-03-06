<div name="search_area">
	<table>
		<tr>
			<td><input type="button" name="search" value="조회" /></td>
			<td><input type="button" name="del" value="삭제" /></td>
		</tr>
	</table>
</div>
<div name="grid"></div>

<div name="user_area"
	style="border: 1px solid #ccc; padding: 10px; border-radius: 10px;">
	<div class="container">
		<div class="row row-cols-4">
			<div class="col-sm">
				<div class="form-group">
					<div class="input-group">
						<span class="input-group-addon">사용자번호</span> <input type="text"
							disabled class="form-control"  data-ax-path="USER_NO"  name="USER_NO">
					</div>
				</div>
			</div>
			<div class="col">
				<div class="form-group">
					<div class="input-group">
						<span class="input-group-addon">마지막접속일</span> <input type="text"
							class="form-control" placeholder="yyyy-mm-dd hh:mi:ss" disabled
							data-ax5formatter="date(time)" data-ax-path="LST_ACC_DTM" name="LST_ACC_DTM">
					</div>
				</div>
			</div>
			<div class="col">
				<div class="form-group">
					<div class="input-group">
						<span class="input-group-addon">수정일시</span> <input type="text"
							class="form-control" placeholder="yyyy-mm-dd hh:mi:ss"
							data-ax5formatter="date(time)" data-ax-path="UPDT_DTM" name="UPDT_DTM"
							disabled>
					</div>
				</div>
			</div>
			<div class="col">
				<div class="form-group">
					<div class="input-group">
						<span class="input-group-addon">생성일시</span> <input type="datetime"
							class="form-control" placeholder="yyyy-mm-dd hh:mi:ss" disabled
							data-ax5formatter="date(time)" data-ax-path="CRT_DTM" name="CRT_DTM">
					</div>
				</div>
			</div>
			<div class="col">
				<div class="form-group">
					<div class="input-group">
						<span class="input-group-addon">사용자명</span> <input type="text"
							class="form-control"  data-ax-path="USER_NM" name="USER_NM">
					</div>
				</div>
			</div>
			<div class="col">
				<div class="form-group">
					<div class="input-group">
						<span class="input-group-addon">사용자ID</span> <input type="text"
							class="form-control"  data-ax-path="USER_ID" name="USER_ID">
					</div>
				</div>
			</div>
			<div class="col">
				<div class="form-group">
					<div class="input-group">
						<span class="input-group-addon">Email</span> <input type="email"
							class="form-control" data-ax-path="EMAIL"  name="EMAIL">
					</div>
				</div>
			</div>
			<div class="col">
				<div class="form-group">
					<div class="input-group">
						<span class="input-group-addon">사용여부</span> 
						<select class="form-control"  data-ax-path="USE_YN"  name="USE_YN">
						</select>
					</div>
				</div>
			</div>
			<div class="col">
				<div class="form-group">
					<div class="input-group">
						<span class="input-group-addon">비밀번호</span> <input type="password"
							class="form-control"  data-ax-path="USER_PWD"  name="USER_PWD">
					</div>
				</div>
			</div>
			<div class="col">
				<div class="form-group">
					<div class="input-group">
						<span class="input-group-addon">비밀번호확인</span> <input
							type="password" class="form-control" data-ax-path="RE_USER_PWD"
							name="RE_USER_PWD">

					</div>
				</div>
			</div>
			<div class="col">
				<div class="form-group">
					<div class="input-group">
						<span class="input-group-addon">비고</span> <input type="text"
							class="form-control"  data-ax-path="RMK" name="RMK">
					</div>
				</div>
			</div>

		</div>
	</div>
	<div style="padding: 10px;">
		<input type="button" name="new" value="신규" /> <input type="button"
			name="change_user_pwd" value="비밀번호변경" /> <input type="button"
			name="save" value="저장" />
	</div>
</div>

