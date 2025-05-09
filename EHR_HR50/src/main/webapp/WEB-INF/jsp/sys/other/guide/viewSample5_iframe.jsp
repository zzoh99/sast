<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><tit:txt mid='appComLayout' mdef='신청'/></title>
<link rel="stylesheet" href="/common/${theme}/css/style.css" />
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>


<script type="text/javascript">
	/*Sheet 기본 설정 */
	$(function() {
		var cfg = {};
		mySheet0.SetConfig(cfg);
		mySheet1.SetConfig(cfg);

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

		mySheet0.InitHeaders(headers);
		mySheet0.InitColumns(cols);
		mySheet0.SetCountPosition(4);
		mySheet0.DataInsert();

		mySheet1.InitHeaders(headers);
		mySheet1.InitColumns(cols);
		mySheet1.SetCountPosition(4);
		mySheet1.DataInsert();

	    $(window).smartresize(sheetResize);

	    sheetInit();

	    $( "#date" ).datepicker2();
	    parent.iframeOnLoad($("body").height());
	});
	function setValue(){
		return true;
	}
</script>

</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='title' mdef='타이틀'/></li>
			<li class="btn">
				<btn:a css="basic" mid='110822' mdef="버튼"/>
				<btn:a css="basic" mid='110822' mdef="버튼"/>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("mySheet0", "100%", "50%", "${ssnLocaleCd}"); </script>
	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='title' mdef='타이틀'/></li>
			<li class="btn">
				<btn:a css="basic" mid='110822' mdef="버튼"/>
				<btn:a css="basic" mid='110822' mdef="버튼"/>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("mySheet1", "100%", "50%", "${ssnLocaleCd}"); </script>

</div>
</body>
</html>
