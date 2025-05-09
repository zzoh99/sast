<!DOCTYPE html>
<html class="bodywrap">
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
<script type="text/javascript">
$(function() {
	$( "#tabs" ).tabs();
	
	// 화면 리사이즈
	$(window).resize(setIframeHeight);
	setIframeHeight();
});

//탭 높이 변경
function setIframeHeight() {
	var iframeTop = $("#tabs ul.tab_bottom").height() + 16;
	$(".layout_tabs").each(function() {
		$(this).css("top",iframeTop);
	});
}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<table border="0" cellpadding="0" cellspacing="0" class="default">
	<colgroup>
		<col width="" />
		<col width="11%" />
		<col width="11%" />
		<col width="11%" />
		<col width="11%" />
		<col width="11%" />
		<col width="11%" />
		<col width="11%" />
		<col width="" />
	</colgroup>
	<tr>
		<td rowspan="4" class="photo"><img src="/common/images/common/img_default_photo.jpg"/></td>
		<th><tit:txt mid='103880' mdef='성명'/></th>
		<td><tit:txt mid='103921' mdef='홍길동'/></td>
		<th><tit:txt mid='103975' mdef='사번'/></th>
		<td>123456</td>
		<th><tit:txt mid='113265' mdef='고용형태'/></th>
		<td></td>
		<th><tit:txt mid='104472' mdef='재직상태'/></th>
		<td><tit:txt mid='112185' mdef='재직'/></td>
	</tr>
	<tr>
		<th><tit:txt mid='104089' mdef='직군'/></th>
		<td></td>
		<th><tit:txt mid='104104' mdef='직위'/></th>
		<td></td>
		<th><tit:txt mid='103785' mdef='직책'/></th>
		<td></td>
		<th><tit:txt mid='104281' mdef='근무지'/></th>
		<td></td>
	</tr>
	<tr>
		<th><tit:txt mid='113261' mdef='계열입사일'/></th>
		<td>2013.01.01</td>
		<th><tit:txt mid='103881' mdef='입사일'/></th>
		<td>2000-01-01</td>
		<th><tit:txt mid='104369' mdef='퇴직일'/></th>
		<td></td>
		<th><tit:txt mid='103973' mdef='직무'/></th>
		<td></td>
	</tr>
	<tr>
		<th><tit:txt mid='113626' mdef='조직경로'/></th>
		<td colspan="7"></td>
	</tr>
	</table>
	<div class="insa_tab">
		<div id="tabs">
			<ul>
				<li><btn:a href="#tabs-1" mid='111110' mdef="기본"/></li>
				<li><btn:a href="#tabs-2" mid='111736' mdef="신상"/></li>
				<li><btn:a href="#tabs-3" mid='111570' mdef="가족"/></li>
				<li><btn:a href="#tabs-4" mid='110985' mdef="가족"/></li>
				<li><btn:a href="#tabs-5" mid='111741' mdef="가족"/></li>
				<li><btn:a href="#tabs-6" mid='111420' mdef="가족"/></li>
				<li><btn:a href="#tabs-7" mid='110830' mdef="가족"/></li>
				<li><btn:a href="#tabs-8" mid='111577' mdef="가족"/></li>
				<li><btn:a href="#tabs-9" mid='111742' mdef="가족"/></li>
				<li><btn:a href="#tabs-10" mid='111116' mdef="가족"/></li>
				<li><btn:a href="#tabs-11" mid='111421' mdef="가족"/></li>
				<li><btn:a href="#tabs-12" mid='110831' mdef="가족"/></li>
				<li><btn:a href="#tabs-13" mid='111266' mdef="가족"/></li>
			</ul>
			<div id="tabs-1">
				<div  class='layout_tabs'><iframe src='/PwrSrchCdElemtMgr.do?cmd=viewPwrSrchCdElemtMgr' frameborder='0' class='tab_iframes'></iframe></div>
			</div>
			<div id="tabs-2">
				<div  class='layout_tabs'><iframe src='/PwrSrchMgr.do?cmd=viewPwrSrchMgr' frameborder='0' class='tab_iframes'></iframe></div>
			</div>
			<div id="tabs-3">
				
			</div>
		</div>
	</div>

</div>
</body>
</html>
