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
	    setInterval(progress, 100)
	});
	
	var percent = 0;
	function progress() {
		percent++;
		if( percent > 100 ) percent = 0;
		
		setProgress(percent);
	}
	
	// 프로그래스바 셋팅
	function setProgress(value) {

		$("#progressTxt").text(value);
		$("#progressBar").width(value+"%");
	};
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
		
		<table border="0" cellpadding="0" cellspacing="0" class="table">
		<colgroup>
			<col width="30%" />
			<col width="55%" />
			<col width="15%" />
		</colgroup>
		<tr>
			<th id="txt"><tit:txt mid='112689' mdef='지급일'/></th>
			<td colspan="2"><tit:txt mid='113301' mdef='2013.05.25 급여'/></td>
		</tr>
		<tr>
			<th><tit:txt mid='112247' mdef='진행율'/></th>
			<td><div class="progressbar"><div id="progressBar"></div></div></td>
			<td class="center"><span id="progressTxt" class="tPink strong">75</span> %</td>
		</tr>
		<tr>
			<th><tit:txt mid='104429' mdef='내용'/></th>
			<td colspan="2">
				<textarea rows="8" class="text w100p"><tit:txt mid='104429' mdef='내용'/></textarea>
			</td>
		</tr>
		</table>
		
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
