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
<script type="text/javascript" src="/common/plugin/IBLeaders/Sheet/js/ibsheetcalendar.js"></script>
 
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
			{Type:"Date",    	Hidden:0,   		Width:200,  		Align:"Left",    ColMerge:0,   SaveName:"viewNm",    KeyField:1,   CalcLogic:"",   Format:"", 	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100,	Format:"Ymd" },
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
		$( "#tabs" ).tabs();
	});
</script>

</head>
<body class="bodywrap">
<div class="wrapper">

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
	
	<div class="innertab inner" >
		<div id="tabs" class="tab">
			<ul>
				<li><btn:a href="#tabs-1" mid='111110' mdef="기본"/></li>
				<li><btn:a href="#tabs-2" mid='111736' mdef="신상"/></li>
				<li><btn:a href="#tabs-3" mid='111570' mdef="가족"/></li>
			</ul>
			<div id="tabs-1">
				<div  class="layout_tabs"><iframe src='/PwrSrchCdElemtMgr.do?cmd=viewPwrSrchCdElemtMgr' frameborder='0' class='tab_iframes'></iframe></div>
			</div>
			<div id="tabs-2">
				<!-- <div  class='layout_tabs'><iframe src='/PwrSrchMgr.do?cmd=viewPwrSrchMgr' frameborder='0' class='tab_iframes'></iframe></div> -->
			</div>
			<div id="tabs-3">
				
			</div>
		</div>
	</div>
</div>
</body>
</html>
