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
<script src="/common/js/jquery/datepicker_lang_KR.js"	type="text/javascript" charset="utf-8"></script>
<script src="/common/js/jquery/jquery.datepicker.js" type="text/javascript" charset="utf-8"></script>

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
		var cfg = {};
		mySheet.SetConfig(cfg);
		
		var cols = [
			
			{Type:"Seq",    Hidden:0, 	Width:"45",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
			{Type:"DelCheck",	Hidden:0,	Width:"45",	Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
			{Type:"Result",   Hidden:1,	Width:"45",	Align:"Center",  ColMerge:0,   SaveName:"sResult" },
			{Type:"Status",   Hidden:0,	Width:"45",	Align:"Center",  ColMerge:0,   SaveName:"sStatus" },
			{Type:"Text",    	Hidden:1,   		Width:0,   			Align:"Left",    ColMerge:0,   SaveName:"viewCd",    KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Type:"Text",    	Hidden:0,   		Width:200,  		Align:"Left",    ColMerge:0,   SaveName:"viewNm",    KeyField:1,   CalcLogic:"",   Format:"", 	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Type:"Text",    	Hidden:0,   		Width:60,   		Align:"Right",   ColMerge:0,   SaveName:"seq",       KeyField:0,   CalcLogic:"",   Format:"", 	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
			{Type:"Text",    	Hidden:0,   		Width:220,			Align:"Left",    ColMerge:0,   SaveName:"viewDesc",  KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000 }
		
		];
		
		var headers = [
			{Text:"No|삭제|결과|상태|View코드|View명|순서|View설명", Align:"Center"}
		];
		
		mySheet.InitHeaders(headers);
		mySheet.InitColumns(cols);
		mySheet.SetCountPosition(4);
		mySheet.DataInsert();

	    $(window).smartresize(sheetResize);
	    
	    sheetInit();

	    $("#from").datepicker2({startdate:"to"});
		$("#to").datepicker2({enddate:"from"});
	});
</script>

</head>
<body class="bodywrap">
<div class="wrapper">
	
	<table border="0" cellpadding="0" cellspacing="0" class="default outer">
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
	
	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<th><tit:txt mid='103880' mdef='성명'/></th>
			<td>
				<input type="text" class="text required" />
				<a class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
			</td>
			<th><tit:txt mid='113633' mdef='활동일자'/></th>
			<td>
				<input type="text" id="from" name="from" class="date" disabled/>
				~
				<input type="text" id="to" name="to" class="date disabled" disabled/>
			</td>
			<th><tit:txt mid='104367' mdef='동호회명'/></th>
			<td>
				<select class="required">
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
	
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<tr>
		<td>
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='112213' mdef='동호회 관리'/></li>
					<li class="btn">
						<btn:a css="basic" mid='110700' mdef="입력"/>
						<btn:a css="basic" mid='110696' mdef="복사"/>
						<btn:a css="basic" mid='110708' mdef="저장"/>
						<btn:a css="basic" mid='110698' mdef="다운로드"/>
						<btn:a css="basic" mid='110703' mdef="업로드"/>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("mySheet", "100%", "100%", "${ssnLocaleCd}"); </script>
		</td>
	</tr>
	</table>
</div>
</body>
</html>
