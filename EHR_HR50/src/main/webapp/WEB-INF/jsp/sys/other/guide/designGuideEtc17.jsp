<!DOCTYPE html>
<html class="bodywrap">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><tit:txt mid='104100' mdef='이수시스템(주)'/></title>
<link rel="stylesheet" href="/common/css/dotum.css" />
<link rel="stylesheet" href="/common/theme1/css/style.css" />
<script type="text/javascript" src="/common/js/jquery/1.9.0/jquery.min.js"></script>
<script type="text/javascript" src="/common/js/ui/1.10.0/jquery-ui.min.js"></script>

<!--  COMMON SCRIT -->
<script src="/common/js/common.js"></script>
<script src="/common/js/commonIBSheet.js"></script>
<!--   IBSHEET	 -->
<script type="text/javascript" src="/common/plugin/IBLeaders/Sheet/js/ibsheetinfo.js"></script>
<script type="text/javascript" src="/common/plugin/IBLeaders/Sheet/js/ibsheet.js"></script>
 
<link rel="stylesheet" type="text/css" href="/common/plugin/IBLeaders/Sheet/css/style.css">
<link rel="stylesheet" type="text/css" href="/common/plugin/IBLeaders/Sheet/css/nwe_common.css">

<script type="text/javascript">
	/*Sheet 기본 설정 */
	$(function() {
	    $(".close").click(function() {
	    	self.close();
	    });
	});
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="popup_title">
	<ul>
		<li><tit:txt mid='114705' mdef='타이틀 명'/></li>
		<li class="close"></li>
	</ul>
	</div>
	
	<div class="popup_main">
		
		<div class="sheet_title">
		<ul>
			<li id="txt" class="txt"><tit:txt mid='114705' mdef='타이틀 명'/></li>
		</ul>
		</div>
		
		<table border="0" cellpadding="0" cellspacing="0" class="table">
		<colgroup>
			<col width="15%" />
			<col width="35%" />
			<col width="15%" />
			<col width="35%" />
		</colgroup>
		<tr>
			<th><tit:txt mid='title' mdef='타이틀'/></th>
			<td><tit:txt mid='104429' mdef='내용'/></td>
			<th><tit:txt mid='title' mdef='타이틀'/></th>
			<td><tit:txt mid='104429' mdef='내용'/></td>
		</tr>
		<tr>
			<th><tit:txt mid='title' mdef='타이틀'/></th>
			<td><tit:txt mid='104429' mdef='내용'/></td>
			<th><tit:txt mid='title' mdef='타이틀'/></th>
			<td><tit:txt mid='104429' mdef='내용'/></td>
		</tr>
		</table>
		
		<div class="sheet_title">
		<ul>
			<li id="txt" class="txt"><tit:txt mid='114705' mdef='타이틀 명'/></li>
			<li class="btn">
				<btn:a href="javascript:doAction('Insert')" css="basic" mid='110700' mdef="입력"/>
				<btn:a href="javascript:doAction('Copy')" css="basic" mid='110696' mdef="복사"/>
				<btn:a href="javascript:doAction('Save')" css="basic" mid='110708' mdef="저장"/>
			</li>
		</ul>
		</div>
		
		<div><tit:txt mid='104242' mdef='업로드'/></div>
		
		<div class="popup_button outer">
		<ul>
			<li>
				<btn:a href="javascript:self.close();" css="pink large" mid='110716' mdef="확인"/>
				<btn:a href="javascript:self.close();" css="gray large" mid='110881' mdef="닫기"/>
			</li>
		</ul>
		</div>
	</div>
			
</div>

</body>
</html>
