<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><tit:txt mid='104100' mdef='이수시스템(주)'/></title>
<link rel="stylesheet" href="/common/css/dotum.css" />
<link rel="stylesheet" href="/common/theme1/css/style.css" />
<script src="/common/js/jquery/1.8.3/jquery.min.js" type="text/javascript" charset="utf-8"></script>
<script src="/common/js/ui/1.10.0/jquery-ui.min.js" type="text/javascript" charset="utf-8"></script>
<script src="/common/js/jquery/jquery.defaultvalue.js" type="text/javascript" charset="utf-8"></script>
<script src="/common/js/jquery/jquery.mask.js" type="text/javascript" charset="utf-8"></script>

 
<!--   VALIDATION	 -->

<script src="/common/js/common.js"		type="text/javascript" charset="utf-8"></script>
<script>
	$(function() {
		$("#text0").maxbyte(10);
		$("#text1").maxbyte(20);
		$("#mask0").mask("1111-11-11");
		$("#mask1").mask("11:11");
		$('#mask2').mask('000,000,000,000,000', {reverse: true});
	});
</script>
<style>
table {margin-bottom:15px;}
caption {text-align:left;font-size:13px;font-weight:bold;}
th {text-align:left;padding:10px 0 0 0;}
td {padding:10px;}
p {margin:10px 0 0 0}
</style>
<body>
<h3><tit:txt mid='114321' mdef='### 마스크 ###'/></h3>
<br /><br />
<div id="info"><tit:txt mid='112224' mdef='한글은 3byte 영문은 1byte 입니다.'/></div><br/>
제한10 : <input id="text0" class="text" value="" /> &nbsp;&nbsp; $("#text").maxbyte(10);<br/><br/>
제한20 : <input id="text1" class="text" /> &nbsp;&nbsp; $("#text").maxbyte(20);<br/><br/><br/>
<br />
<btn:a href="http://igorescobar.github.io/jQuery-Mask-Plugin/" target="_blank" mid='111743' mdef="메뉴얼"/><br/><br/>
날짜 : <input id="mask0" class="text date" /><tit:txt mid='113638' mdef=' &nbsp;&nbsp; $("#아이디").mask("1111-11-11"); '/><br/><br/>
시간 : <input id="mask1" class="text date" /><tit:txt mid='112553' mdef=' &nbsp;&nbsp; $("#아이디").mask("11:11"); '/><br/><br/>
화폐 : <input id="mask2" class="text right" /><tit:txt mid='113980' mdef=' &nbsp;&nbsp; $('#아이디').mask('000,000,000,000,000', {reverse: true}); '/><br/><br/>
</body>
</html>
