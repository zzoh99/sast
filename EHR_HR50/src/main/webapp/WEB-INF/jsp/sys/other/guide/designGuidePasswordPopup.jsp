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
	$(function() {
		$(".close").click(function() {
			self.close();
		});
		
		$('input:radio').click(function() {
			if( $(this).attr("value") == 0 ) {
				$("#email").show();
				$("#phone").hide();
			}
			else {
				$("#email").hide();
				$("#phone").show();
			}
		})

	});
</script>

</head>
<body class="bodywrap">

<div class="wrapper">
	<div class="popup_title">
	<ul>
		<li><tit:txt mid='pwdFindPop' mdef='비밀번호 찾기'/></li>
		<li class="close"></li>
	</ul>
	</div>
	
	<div class="popup_main">
		<div class="pass_info tPink"><tit:txt mid='112847' mdef='- 인사시스템에 등록된 E-mail 주소, 핸드폰번호로 임시비밀번호를 발급 받으실 수 있습니다.'/></div>
		
		<table border="0" cellpadding="0" cellspacing="0" class="table none">
		<colgroup>
			<col width="20%" />
			<col width="80%" />
		</colgroup>
		<tr>
			<th class="center tGray"><tit:txt mid='103880' mdef='성명'/></th>
			<td>
				<input type="text" class="text required" style="width:150px;"/>
			</td>
		</tr>
		<tr>
			<th class="center tGray"><tit:txt mid='103975' mdef='사번'/></th>
			<td>
				<input type="text" class="text required" style="width:150px;"/>
			</td>
		</tr>
		</table>
		
		<table class="find_pass">
		<tr>
			<td><input id="type" name="type" type="radio" value="0" class="radio" checked/> E-mail</td>
			<td><input id="type" name="type" type="radio" value="1" class="radio" /><tit:txt mid='114263' mdef=' 핸드폰'/></td>
		</tr>
		</table>
		
		<table id="email" border="0" cellpadding="0" cellspacing="0" class="table none">
		<colgroup>
			<col width="20%" />
			<col width="80%" />
		</colgroup>
		<tr>
			<th class="center tGray">E-mail</th>
			<td>
				<input type="text" class="text required" style="width:150px;"/> @pantech.com
			</td>
		</tr>
		</table>
		
		<table id="phone" border="0" cellpadding="0" cellspacing="0" class="table none" style="display:none;">
		<colgroup>
			<col width="20%" />
			<col width="80%" />
		</colgroup>
		<tr>
			<th class="center tGray"><tit:txt mid='112168' mdef='핸드폰 번호'/></th>
			<td>
				<input type="text" class="text required" style="width:150px;"/> 공백없이 입력 해 주세요
			</td>
		</tr>
		</table>
		
		<div class="popup_button">
		<ul>
			<li>
				<btn:a css="pink large" mid='111213' mdef="임시비밀번호 생성"/>
				<btn:a href="javascript:self.close();" css="gray large" mid='110778' mdef="취소"/>
			</li>
		</ul>
		</div>
		
		<div class="explain">
			<div class="title"><tit:txt mid='114264' mdef='도움말'/></div>
			<div class="txt">
			<ul>
				<li><tit:txt mid='114326' mdef='인사시스템에 등록된 E-mail 주소, 핸드폰번호가 맞지 않을 경우 인사담당자에게 연락바랍니다.'/></li>
				<li><tit:txt mid='112554' mdef='- 내선1234'/></li>
			</ul>
			</div>
		</div>
		
	</div>
</div>

</body>
</html>
