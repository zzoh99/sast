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
	    })
	});
</script>
</head>
<body class="bodywrap">

<div class="wrapper">
	<div class="popup_title">
	<ul>
		<li><tit:txt mid='113641' mdef='특별공제(보험료)'/></li>
		<li class="close"></li>
	</ul>
	</div>
	
	<div class="popup_main">
		
		<div class="explain">
			<div class="title"><tit:txt mid='113642' mdef='보험료공제'/></div>
			<div class="txt">
			<ul>
				<li><tit:txt mid='113982' mdef='- 건강보험 / 고용보험 / 노인장기요양보험료：근로자부담분 전액'/></li>
				<li><tit:txt mid='113983' mdef='- 보장성보험료：100만원'/></li>
				<li class="gap"><tit:txt mid='112227' mdef='- 장애인보장성보험료：100만원(1개의 보험으로 보장성보험과의 중복적용 배제)'/></li>
				
				<li><b><tit:txt mid='113643' mdef='* 요건체크'/></b><tit:txt mid='113984' mdef=' : 계약자와 피보험자가 기본공제대상일 경우에만 해당됨,'/></li>
				<li class="sub1"><tit:txt mid='113985' mdef='장애인전용보험은 피보험자가 장애인일 경우에만 해당됨'/></li>
				<li><b><tit:txt mid='112903' mdef='* 불공제대상'/></b><tit:txt mid='114327' mdef=' : 타인의 기본공제대상자에 대한 지출, 외국보험기관보험료,'/></li>
				<li class="sub2"><tit:txt mid='113644' mdef='미지급보험료, 입사전 / 퇴사후 보험료 등'/></li>
			</ul>
			</div>
		</div>
		
		<div class="popup_button">
		<ul>
			<li>
				<btn:a href="javascript:self.close();" css="gray large" mid='110881' mdef="닫기"/>
			</li>
		</ul>
		</div>
	</div>
</div>

</body>
</html>
