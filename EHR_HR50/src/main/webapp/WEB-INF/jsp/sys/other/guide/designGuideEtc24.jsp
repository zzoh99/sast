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
<script src="/common/js/jquery/datepicker_lang_KR.js"	type="text/javascript" charset="utf-8"></script>
<script src="/common/js/jquery/jquery.datepicker.js" type="text/javascript" charset="utf-8"></script>

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
		
	    $(window).smartresize(sheetResize);
	    
	    sheetInit();

	    $( "#date0" ).datepicker2();
	    $( "#date1" ).datepicker2();
	    $( "#date2" ).datepicker2();
	    
	    $(".close").click(function() {
	    	self.close();
	    });
	});
</script>
</head>
<body class="bodywrap">
<div class="wrapper popup_scroll">
	<div class="popup_title">
	<ul>
		<li><tit:txt mid='attachMgrDtlPopup1' mdef='압류세부내역'/></li>
		<li class="close"></li>
	</ul>
	</div>
	
	<div class="popup_main">
		<!-- // 조회화면 -->
		
		<table border="0" cellpadding="0" cellspacing="0" class="table outer">
		<colgroup>
			<col width="13%" />
			<col width="20%" />
			<col width="13%" />
			<col width="20%" />
			<col width="13%" />
			<col width="21%" />
		</colgroup>
		<tr>
			<th><tit:txt mid='103880' mdef='성명'/></th>
			<td><input type="text" class="text readonly" readonly="readonly" /></td>
			<th><tit:txt mid='103975' mdef='사번'/></th>
			<td><input type="text" class="text readonly" readonly="readonly" /></td>
			<th><tit:txt mid='104471' mdef='직급'/></th>
			<td><input type="text" class="text readonly w100p" readonly="readonly" /></td>
		</tr>
		<tr>
			<th><tit:txt mid='103785' mdef='직책'/></th>
			<td><input type="text" class="text readonly w100p" readonly="readonly" /></td>
			<th><tit:txt mid='104279' mdef='소속'/></th>
			<td><input type="text" class="text readonly w100p" readonly="readonly" /></td>
			<th><tit:txt mid='104523' mdef='재직여부'/></th>
			<td><input type="text" class="text readonly w100p" readonly="readonly" /></td>
		</tr>
		</table>
		
		<div class="sheet_title outer">
		<ul>
			<li class="txt"><tit:txt mid='attachMgrDtlPopup2' mdef='사건내역'/></li>
		</ul>
		</div>
		
		<table border="0" cellpadding="0" cellspacing="0" class="table outer">
		<colgroup>
			<col width="13%" />
			<col width="20%" />
			<col width="13%" />
			<col width="20%" />
			<col width="13%" />
			<col width="21%" />
		</colgroup>
		<tr>
			<th><tit:txt mid='114197' mdef='접수일'/></th>
			<td colspan="5"><input id="date0" type="text" class="text date2" /></td>
		</tr>
		<tr>
			<th><tit:txt mid='112781' mdef='사건번호'/></th>
			<td><input type="text" class="text w100p" /></td>
			<th><tit:txt mid='113146' mdef='사건구분'/></th>
			<td><select></select></td>
			<th><tit:txt mid='cpnProcessBarPop' mdef='진행상태'/></th>
			<td><select></select></td>
		</tr>
		<tr>
			<th><tit:txt mid='113491' mdef='채무내용'/></th>
			<td><input type="text" class="text w100p" /></td>
			<th><tit:txt mid='112086' mdef='관련사건'/></th>
			<td colspan="3"><input type="text" class="text w100p" /></td>
		</tr>
		</table>
		
		<div class="sheet_title outer">
		<ul>
			<li class="txt"><tit:txt mid='attachMgrDtlPopup3' mdef='채권자 정보'/></li>
		</ul>
		</div>
		
		<table border="0" cellpadding="0" cellspacing="0" class="table outer">
		<colgroup>
			<col width="13%" />
			<col width="20%" />
			<col width="13%" />
			<col width="20%" />
			<col width="13%" />
			<col width="21%" />
		</colgroup>
		<tr>
			<th><tit:txt mid='112087' mdef='채권자'/></th>
			<td><input type="text" class="text w100p" /></td>
			<th><tit:txt mid='manager' mdef='담당자'/></th>
			<td><input type="text" class="text w100p" /></td>
			<th><tit:txt mid='112985' mdef='전화번호'/></th>
			<td><input type="text" class="text w100p" /></td>
		</tr>
		<tr>
			<th><tit:txt mid='112433' mdef='채권내용'/></th>
			<td colspan="3"><input type="text" class="text w100p" /></td>
			<th><tit:txt mid='113492' mdef='이동전화'/></th>
			<td><input type="text" class="text w100p" /></td>
		</tr>
		<tr>
			<th><tit:txt mid='114577' mdef='은행'/></th>
			<td><input type="text" class="text w100p" /></td>
			<th><tit:txt mid='104465' mdef='계좌번호'/></th>
			<td><input type="text" class="text w100p" /></td>
			<th><tit:txt mid='113147' mdef='예금주명'/></th>
			<td><input type="text" class="text w100p" /></td>
		</tr>
		</table>
		
		<div class="sheet_title outer">
		<ul>
			<li class="txt"><tit:txt mid='attachMgrDtlPopup4' mdef='청구 및 공제내역'/></li>
		</ul>
		</div>
		
		<table border="0" cellpadding="0" cellspacing="0" class="table outer">
		<colgroup>
			<col width="13%" />
			<col width="20%" />
			<col width="13%" />
			<col width="20%" />
			<col width="13%" />
			<col width="21%" />
		</colgroup>
		<tr>
			<th><tit:txt mid='113148' mdef='청구액'/></th>
			<td><input type="text" class="text w100p" /></td>
			<th><tit:txt mid='112088' mdef='공제누계액'/></th>
			<td><input type="text" class="text w100p readonly" readonly="readonly"/></td>
			<th><tit:txt mid='112089' mdef='입금누계액'/></th>
			<td><input type="text" class="text w100p readonly" readonly="readonly"/></td>
		</tr>
		<tr>
			<th><tit:txt mid='112782' mdef='청구잔액'/></th>
			<td colspan="5"><input type="text" class="text readonly" readonly="readonly"/></td>
		</tr>
		</table>
		
		<div class="sheet_title outer">
		<ul>
			<li class="txt"><tit:txt mid='attachMgrDtlPopup5' mdef='공탁내역'/></li>
			<li class="btn">
				<btn:a css="basic" mid='110700' mdef="입력"/>
				<btn:a css="basic" mid='110696' mdef="복사"/>
				<btn:a css="basic" mid='110708' mdef="저장"/>
			</li>
		</ul>
		</div>
		
		<script type="text/javascript"> createIBSheet("mySheet", "100%", "200px", "${ssnLocaleCd}"); </script>
		
		<div class="sheet_title outer">
		<ul>
			<li class="txt"><tit:txt mid='114578' mdef='기타 내역'/></li>
		</ul>
		</div>
		
		<table border="0" cellpadding="0" cellspacing="0" class="table outer">
		<colgroup>
			<col width="13%" />
			<col width="20%" />
			<col width="13%" />
			<col width="54%" />
		</colgroup>
		<tr>
			<th><tit:txt mid='114579' mdef='결정일'/></th>
			<td><input id="date1" type="text" class="text date2" /></td>
			<th><tit:txt mid='111909' mdef='종료일'/></th>
			<td><input id="date2" type="text" class="text date2"/></td>
		</tr>
		<tr>
			<th><tit:txt mid='103783' mdef='비고'/></th>
			<td colspan="3"><input type="text" class="text w100p"/></td>
		</tr>
		</table>
		
		<div class="popup_button outer">
		<ul>
			<li>
				<btn:a css="pink large" mid='110716' mdef="확인"/>
				<btn:a href="javascript:self.close();" css="gray large" mid='110881' mdef="닫기"/>
			</li>
		</ul>
		</div>
	</div>
			
</div>

</body>
</html>
