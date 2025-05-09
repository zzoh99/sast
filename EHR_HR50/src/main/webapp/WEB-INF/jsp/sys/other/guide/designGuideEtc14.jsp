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
			{Text:"No|삭제|결과|상태|필드명1|필드명2|필드명3|필드명4", Align:"Center"}
		];
		
		mySheet.InitHeaders(headers);
		mySheet.InitColumns(cols);
		mySheet.SetCountPosition(4);
		mySheet.DataInsert();

	    
	    $(window).smartresize(sheetResize);
	    
	    sheetInit();
	    
	    $(".close").click(function() {
	    	self.close();
	    })
	    
	    $( "#tabs" ).tabs();
	});
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
		<div id="tabs">
			<ul class="outer tab_bottom">
				<li><btn:a href="#tabs-1" mid='111737' mdef="탭1"/></li>
				<li><btn:a href="#tabs-2" mid='111738' mdef="탭2"/></li>
			</ul>
			<div id="tabs-1">
				<div class="sheet_search inner">
					<div>
					<table>
					<tr>
						<th><tit:txt mid='103792' mdef='항목'/></th>
						<td>
							<input type="text" class="text readonly" />
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
						<li id="txt" class="txt"><tit:txt mid='114705' mdef='타이틀 명'/></li>
						<li class="btn">
							<btn:a href="javascript:doAction('Insert')" css="basic" mid='110700' mdef="입력"/>
							<btn:a href="javascript:doAction('Copy')" css="basic" mid='110696' mdef="복사"/>
							<btn:a href="javascript:doAction('Save')" css="basic" mid='110708' mdef="저장"/>
						</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("mySheet", "100%", "100%", "${ssnLocaleCd}"); </script>
				
			</div>
			<div id="tabs-2">
				내용2
			</div>
		</div>
		
		<div class="popup_button outer">
		<ul>
			<li>
				<btn:a href="javascript:self.close();" css="pink large" mid='110716' mdef="확인"/>
				<btn:a href="javascript:self.close();" css="gray large" mid='110881' mdef="닫기"/>
				<btn:a href="javascript:self.close();" css="gray large" mid='110754' mdef="초기화"/>
			</li>
		</ul>
		</div>
	</div>
			
</div>

</body>
</html>
