<!DOCTYPE html>
<html>
<head>

<!--   META	 -->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Cache-Control" content="no-cache" />
<meta http-equiv="Expires" content="-1" />
<meta http-equiv="Imagetoolbar" content="no" />
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />

<title><tit:txt mid='104100' mdef='이수시스템(주)'/></title>
<link rel="stylesheet" href="/common/css/dotum.css" />
<link rel="stylesheet" href="/common/theme1/css/style.css" />

<!--   JQUERY	 -->
<script src="/common/js/jquery/1.9.0/jquery.min.js"></script>
<script src="/common/js/ui/1.10.0/jquery-ui.min.js"></script>

<!--  COMMON SCRIT -->
<script src="/common/js/common.js"></script>
<script src="/common/js/commonIBSheet.js"></script>
<!--   IBSHEET	 -->
<script type="text/javascript" src="/common/plugin/IBLeaders/Sheet/js/ibsheetinfo.js"></script>
<script type="text/javascript" src="/common/plugin/IBLeaders/Sheet/js/ibsheet.js"></script>
 
<link rel="stylesheet" type="text/css" href="/common/plugin/IBLeaders/Sheet/css/style.css">
<link rel="stylesheet" type="text/css" href="/common/plugin/IBLeaders/Sheet/css/nwe_common.css">

</head>
<body>
<h3><tit:txt mid='112234' mdef='### 조회 ###'/></h3>
<br />
<br />
<div class="wrapper">

	<div class="sheet_search">
		<div>
		<table>
		<tr>
			<th><tit:txt mid='103792' mdef='항목'/></th>
			<td>
				<input type="text" class="text readonly" />
				<a class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
				<a class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
			</td>
			<th><tit:txt mid='113627' mdef='항목일자'/></th>
			<td>
				<input type="text" id="date" name="date" class="date" disabled/>
			</td>
			<td>
				<btn:a css="button" mid='110697' mdef="조회"/>
			</td>
		</tr>
		</table>
		</div>
	</div>
	<br />
	<br />
	
	<div class="sheet_search">
		<div>
		<table>
		<tr>
			<th><tit:txt mid='103792' mdef='항목'/></th>
			<td>
				<input type="text" class="text readonly" />
				<a class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
			</td>
			<th><tit:txt mid='113627' mdef='항목일자'/></th>
			<td>
				<input type="text" id="date" name="date" class="date" disabled/>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='113996' mdef='미입력'/></th>
			<td>
				<input type="text" class="text disabled" />
			</td>
			<th><tit:txt mid='111914' mdef='선택'/></th>
			<td>
				<select class="readonly">
					<option><tit:txt mid='103895' mdef='전체'/></option>
				</select>
			</td>
			<td>
				<btn:a css="button" mid='110697' mdef="조회"/>
			</td>
		</tr>
		</table>
		</div>
	</div>
	<br />
	<br />
	
	
	<div class="sheet_search">
		<div>
		<table>
		<tr>
			<th><tit:txt mid='103792' mdef='항목'/></th>
			<td>
				<input type="text" class="text readonly" />
				<a class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
			</td>
			<th><tit:txt mid='113627' mdef='항목일자'/></th>
			<td>
				<input type="text" id="date" name="date" class="date" disabled/>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='113996' mdef='미입력'/></th>
			<td>
				<input type="text" class="text disabled" />
			</td>
			<th><tit:txt mid='111914' mdef='선택'/></th>
			<td>
				<select class="readonly">
					<option><tit:txt mid='103895' mdef='전체'/></option>
				</select>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='113627' mdef='항목일자'/></th>
			<td>
				<input type="text" id="from" name="from" class="date" disabled/>
				~
				<input type="text" id="to" name="to" class="date disabled" disabled/>
			</td>
			<th><tit:txt mid='114721' mdef='항목선택'/></th>
			<td>
				<select>
					<option><tit:txt mid='103895' mdef='전체'/></option>
				</select>
			</td>
			<td>
				<btn:a css="button" mid='110697' mdef="조회"/>
			</td>
		</tr>
		</table>
		</div>
	</div>
	
</div>
</body>
</html>
