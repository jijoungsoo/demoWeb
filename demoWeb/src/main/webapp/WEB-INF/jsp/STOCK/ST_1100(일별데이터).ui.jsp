<form name="search_area">
	<div class="row row-cols-auto" >
		<div class="col">
			<div class="form-group">
				<div class="input-group">
					<span class="input-group-addon">시작일자</span> <input type="text"
						class="form-control" placeholder="yyyy-mm-dd"
						data-ax5formatter="date"
						data-ax-path="STOCK_DT_ST"  name="STOCK_DT_ST"
						style="width:120px;" required>
					</div>
				</div>
			</div>
			<div class="col">
				<div class="form-group">
					<div class="input-group">
						<span class="input-group-addon">종료일자</span> <input type="text"
							class="form-control" placeholder="yyyy-mm-dd"
							data-ax5formatter="date" data-ax-path="STOCK_DT_ED" name="STOCK_DT_ED"
							style="width:120px;" required>
					</div>
				</div>
			</div>
			<div class="col">
				<div class="form-group">
					<div class="input-group">
						<span class="input-group-addon">종목코드</span> <input type="text"
							class="form-control"
							data-ax-path="STOCK_CD" name="STOCK_CD"
							style="width:120px;"
							>
					</div>
				</div>
			</div>
			<div class="col">
				<div class="form-group">
					<div class="input-group">
						<input type="button" name="search" value="조회" />
					</div>
				</div>
			</div>
	</div>
</form>	


<div name="grid"></div>
