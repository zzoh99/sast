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
<script type="text/javascript">
	/*Sheet 기본 설정 */
	$(function() {

		// 달력 설정
	    $( "#from" ).datepicker({
			onClose: function( selectedDate ) {	// 닫을때 이벤트
				$( "#to" ).datepicker( "option", "minDate", selectedDate );
			}
		});
	    
	 	// 달력 설정
		$( "#to" ).datepicker({
			onClose: function( selectedDate ) {
				$( "#from" ).datepicker( "option", "maxDate", selectedDate );
			}
		});
	});
</script>
</head>
<body>
<div class="wrapper">
	<table border="0" cellpadding="0" cellspacing="0" class="explain_main">
	<tr>
		<td class="top">
			<div class="sheet_title">
			<ul>
				<li class="txt"><tit:txt mid='114316' mdef='일근무 생성조건'/></li>
			</ul>
			</div>
			<table border="0" cellpadding="0" cellspacing="0" class="default">
			<colgroup>
				<col width="150" />
				<col width="" />
			</colgroup>
			<tr>
				<th><tit:txt mid='113979' mdef='급여사업장'/></th>
				<td>
					<select>
						<option><tit:txt mid='113937' mdef='선택하세요'/></option>
					</select>
				</td>
			</tr>
			<tr>
				<th rowspan="3"><tit:txt mid='112549' mdef='생성기준'/></th>
				<td><tit:txt mid='114702' mdef='타임카드 사용여부 :'/></td>
			</tr>
			<tr>
				<td><tit:txt mid='114317' mdef='타임카드 번호체계 :'/></td>
			</tr>
			<tr>
				<td><tit:txt mid='112223' mdef='근무시간 입력구분 :'/></td>
			</tr>
			<tr>
				<th><tit:txt mid='113195' mdef='생성일자'/></th>
				<td>
					<input type="text" id="from" name="from" class="date" disabled/>
					~
					<input type="text" id="to" name="to" class="date" disabled/>
				</td>
			</tr>
			<tr>
				<td colspan="2" class="center">
					<input type="radio" class="radio"/> 사원
					<input type="radio" class="radio" /> 성명
					<input type="radio" class="radio" /> 사번
					<input type="text" class="text" />
					<a class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
				</td>
			</tr>
			</table>
			<div class="center">
				<btn:a css="button large" mid='111418' mdef="작업실행"/>
				<btn:a css="basic large" mid='111418' mdef="작업실행"/>
			</div>
		</td>
	</tr>
	<tr>
		<td class="bottom">
		<div class="explain">
			<div class="title"><tit:txt mid='timWorkCount2' mdef='설명'/></div>
			<div class="txt">
			<ul>
				<li><tit:txt mid='112900' mdef='1. 일근무데이터를 자동생성하는 화면입니다.'/></li>
				<li><tit:txt mid='114318' mdef='2. 급여사업장을 선택합니다.'/></li>
				<li><tit:txt mid='112550' mdef='3. 생성일자를 선택합니다.'/></li>
				<li><tit:txt mid='114319' mdef='4. 개인별 일근무 생성 시 해당 사원을 선택합니다.'/></li>
				<li><tit:txt mid='112551' mdef='5. [작업실행] 버튼을 클릭하여 작업을 실행합니다.'/></li>
			</ul>
			</div>
		</div>
		</td>
	</tr>
	</table>
	
</div>
</body>
</html>
