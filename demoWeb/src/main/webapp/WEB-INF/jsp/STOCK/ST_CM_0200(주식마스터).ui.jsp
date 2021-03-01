
<form name="search_area">

<div class="row row-cols-auto" >
<div class="col">
	<div class="form-group">
		<div class="input-group">
			<span class="input-group-addon">마켓코드</span> 
			<select class="form-control"  data-ax-path="MARKET_CD"  name="MARKET_CD" style="width:140px;" >
			</select>
		</div>
	</div>
</div>
<div class="col">
	<div class="form-group">
		<div class="input-group">
			<span class="input-group-addon">종목명</span> 
			<input type="text" 	class="form-control" 
				data-ax-path="STOCK_NM" name="STOCK_NM"
				style="width:120px;" >
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
