<!DOCTYPE html>
<html>
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

</head>
<body>
<div class="wrapper">
	<div class="sheet_title">
	<ul>
		<li class="txt"><tit:txt mid='113355' mdef='지원사항 및 분야'/></li>
		<li class="btn">
			<btn:a css="basic" mid='110708' mdef="저장"/>
		</li>
	</ul>
	</div>
	
	<table border="0" cellpadding="0" cellspacing="0" class="table">
	<colgroup>
		<col width="11%" />
		<col width="9%" />
		<col width="30%" />
		<col width="15%" />
		<col width="" />
	</colgroup>
	<tr>
		<th rowspan="2"><tit:txt mid='104119' mdef='지원분야'/></th>
		<th><tit:txt mid='104409' mdef='1지망'/></th>
		<td><input type="text" class="text w150" /></td>
		<th rowspan="2"><tit:txt mid='104222' mdef='희망직무'/></th>
		<td class="bnoline"><input type="text" class="text w150" /></td>
	</tr>
	<tr>
		<th><tit:txt mid='104021' mdef='2지망'/></th>
		<td ><input type="text" class="text w150" /></td>
		<td class="tnoline"><span class="info"><tit:txt mid='112295' mdef='- 본인이 희망하는 세부직무'/></span></td>
	</tr>
	</table>
	
	<div class="sheet_title">
	<ul>
		<li class="txt"><tit:txt mid='114425' mdef='인적사항'/></li>
		<li class="btn">
			<btn:a css="basic" mid='110708' mdef="저장"/>
		</li>
	</ul>
	</div>
	
	<table border="0" cellpadding="0" cellspacing="0" class="table">
	<colgroup>
		<col width="11%" />
		<col width="9%" />
		<col width="30%" />
		<col width="15%" />
		<col width="35%" />
	</colgroup>
	<tr>
		<th colspan="2"><tit:txt mid='114426' mdef='사진'/></th>
		<td colspan="3">
			<img src="/common/images/contents/myface.jpg" class="userface" />
		</td>
	</tr>
	<tr>
		<th rowspan="2"><tit:txt mid='103880' mdef='성명'/></th>
		<th><tit:txt mid='112983' mdef='한글'/></th>
		<td><input type="text" class="text w150" /></td>
		<th><tit:txt mid='112625' mdef='한자'/></th>
		<td><input type="text" class="text w100" /></td>
	</tr>
	<tr>
		<th><tit:txt mid='113341' mdef='영문'/></th>
		<td colspan="3"><input type="text" class="text w150" /> <span class="info"><tit:txt mid='112626' mdef='- 성, 이름순으로 입력 ex) Hong Kil Dong'/></span></td>
	</tr>
	<tr>
		<th colspan="2"><tit:txt mid='104294' mdef='생년월일'/></th>
		<td>
			<input type="text" class="text w100" /> <input type="text" class="text w45" /><br/>
			<span class="info"><tit:txt mid='113357' mdef='- yyyy.mm.dd로 표기해 주시기 바랍니다.'/></span>
		</td>
		<th><tit:txt mid='104011' mdef='성별'/></th>
		<td></td>
	</tr>
	<tr>
		<th colspan="2"><tit:txt mid='104392' mdef='최종학력'/></th>
		<td colspan="3"><input type="text" class="text w100" /> <span class="info"><tit:txt mid='112984' mdef='- 졸업예정일 경우, 졸업 선택'/></span></td>
	</tr>
	<tr>
		<th colspan="2"><tit:txt mid='104175' mdef='현주소'/></th>
		<td colspan="3">
			<input type="text" class="text w100" /> <input type="text" class="text" style="width:300px" /><br/>
			<input type="text" class="text" style="width:406px" />
		</td>
	</tr>
	<tr>
		<th colspan="2"><tit:txt mid='104262' mdef='긴급연락처'/></th>
		<td colspan="3">
			<input type="text" class="text w60" /> - <input type="text" class="text w60" /> - <input type="text" class="text w60" />
		</td>
	</tr>
	<tr>
		<th colspan="2"><tit:txt mid='103945' mdef='휴대폰'/></th>
		<td colspan="3">
			<input type="text" class="text w60" /> - <input type="text" class="text w60" /> - <input type="text" class="text w60" />
		</td>
	</tr>
	<tr>
		<th colspan="2"><tit:txt mid='112985' mdef='전화번호'/></th>
		<td colspan="3">
			<input type="text" class="text w60" /> - <input type="text" class="text w60" /> - <input type="text" class="text w60" />
		</td>
	</tr>
	<tr>
		<th colspan="2"><tit:txt mid='104041' mdef='이메일'/></th>
		<td colspan="3">
			<input type="text" class="text" style="width:212px;"/><br/>
			<span class="info"><tit:txt mid='114059' mdef='- 채용결과 메일발송 및 비밀번호 분실 시 확인을 위한 이메일입니다. 정확하게 입력해주세요.'/></span>
		</td>
	</tr>
	<tr>
		<th colspan="2"><tit:txt mid='114426' mdef='사진'/></th>
		<td colspan="3">
			<input type="file" class="text" style="width:212px;" /><br/>
			<span class="info"><tit:txt mid='112296' mdef='- 최근 6개월 이내에 촬영한 정면사진'/></span><br/>
			<span class="info"><tit:txt mid='112297' mdef='- 반명함 형태의 jpg파일'/></span>
		</td>
	</tr>
	</table>
	
	<div class="sheet_title">
	<ul>
		<li class="txt"><tit:txt mid='104545' mdef='병역사항'/></li>
		<li class="btn">
			<btn:a css="basic" mid='110708' mdef="저장"/>
		</li>
	</ul>
	</div>
	
	<table border="0" cellpadding="0" cellspacing="0" class="table">
	<colgroup>
		<col width="20%" />
		<col width="30%" />
		<col width="15%" />
		<col width="" />
	</colgroup>
	<tr>
		<th><tit:txt mid='103997' mdef='구분'/></th>
		<td><input type="text" class="text w100" /></td>
		<th><tit:txt mid='103926' mdef='군별'/></th>
		<td><input type="text" class="text w100" /></td>
	</tr>
	<tr>
		<th><tit:txt mid='104219' mdef='계급'/></th>
		<td><input type="text" class="text w100" /></td>
		<th><tit:txt mid='104518' mdef='복무기간'/></th>
		<td>
			<input type="text" class="text w100" /> - <input type="text" class="text w100" /><br/>
			<span class="info"><tit:txt mid='111940' mdef='- 복무기간 : 날짜는 yyyy.mm.dd로 표기해 주시기 바랍니다.'/></span>
		</td>
	</tr>
	</table>
	
	<div class="sheet_title">
	<ul>
		<li class="txt"><tit:txt mid='veterans' mdef='보훈사항'/></li>
		<li class="btn">
			<btn:a css="basic" mid='110708' mdef="저장"/>
		</li>
	</ul>
	</div>
	
	<table border="0" cellpadding="0" cellspacing="0" class="table">
	<colgroup>
		<col width="20%" />
		<col width="30%" />
		<col width="15%" />
		<col width="" />
	</colgroup>
	<tr>
		<th><tit:txt mid='103843' mdef='보훈구분'/></th>
		<td><input type="text" class="text w100" /></td>
		<th><tit:txt mid='104414' mdef='보훈번호'/></th>
		<td><input type="text" class="text w100" /></td>
	</tr>
	</table>
	
	<div class="sheet_title">
	<ul>
		<li class="txt"><tit:txt mid='obstacle' mdef='장애사항'/></li>
		<li class="btn">
			<btn:a css="basic" mid='110708' mdef="저장"/>
		</li>
	</ul>
	</div>
	
	<table border="0" cellpadding="0" cellspacing="0" class="table">
	<colgroup>
		<col width="20%" />
		<col width="30%" />
		<col width="15%" />
		<col width="" />
	</colgroup>
	<tr>
		<th><tit:txt mid='103844' mdef='장애구분'/></th>
		<td><input type="text" class="text w100" /></td>
		<th><tit:txt mid='104046' mdef='장애등급'/></th>
		<td><input type="text" class="text w100" /></td>
	</tr>
	</table>
	<div class="h50"></div>
</div>

</body>
</html>
