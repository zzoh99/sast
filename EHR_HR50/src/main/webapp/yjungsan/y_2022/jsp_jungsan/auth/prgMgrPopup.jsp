<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>프로그램관리</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("<%=popUpStatus%>");
	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
	  		{Header:"No",		Type:"<%=sNoTy%>",	Hidden:<%=sNoHdn%>, Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
			{Header:"프로그램",		Type:"Text",	Hidden:0,	Width:140,	Align:"Left",   ColMerge:0,   SaveName:"prg_cd",		UpdateEdit:0 },
			{Header:"프로그램명",	Type:"Text",	Hidden:0,	Width:135,	Align:"Left",   ColMerge:0,   SaveName:"prg_nm",		UpdateEdit:0 },
			{Header:"프로그램영문명",	Type:"Text",	Hidden:1,	Width:100,	Align:"Left",   ColMerge:0,   SaveName:"prg_eng_nm",	UpdateEdit:0 },
			{Header:"PATH",		Type:"Text",	Hidden:1,	Width:150,	Align:"Left",	ColMerge:0,   SaveName:"prg_path",		UpdateEdit:0 },
			{Header:"사용",		Type:"Combo",	Hidden:1,	Width:40,	Align:"Center",	ColMerge:0,   SaveName:"use",			UpdateEdit:0 },
			{Header:"버전",		Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,   SaveName:"version",		UpdateEdit:0 },
			{Header:"메모",		Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,   SaveName:"memo",			UpdateEdit:0 },
			{Header:"Track",	Type:"Combo",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,   SaveName:"date_track_yn",	UpdateEdit:0 }
		]; IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(4);sheet1.SetEditableColorDiff (0);

		sheet1.SetColProperty("use", 			{ComboText:"사용|사용안함", ComboCode:"Y|N"} );
		sheet1.SetColProperty("date_track_yn", 	{ComboText:"유|무", 	ComboCode:"Y|N"} );
		sheet1.SetColProperty("log_save_yn", 	{ComboText:"Y|N", ComboCode:"Y|N"} );

		$("#srchPrgCd,#srchPrgNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction("Search");
				$(this).focus();
			}
		});
		$(window).smartresize(sheetResize); sheetInit();
	    doAction("Search");

	    $(".close").click(function() {
	    	p.self.close();
	    });
	});

	//Sheet Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "<%=jspPath%>/auth/athGrpMenuMgrRst.jsp?cmd=selectPrgMgrPopList", $("#mySheetForm").serialize() );
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	function sheet1_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		var rv = new Array(5);
		rv["prgCd"] 		= sheet1.GetCellValue(Row, "prg_cd");
		rv["menuNm"]		= sheet1.GetCellValue(Row, "prg_nm");
		//p.window.returnValue 	= rv;
		if(p.popReturnValue) p.popReturnValue(rv);
		p.window.close();
	}
</script>
</head>

<body class="bodywrap">
<div class="wrapper">
	<div class="popup_title">
	<ul>
		<li>프로그램관리</li>
		<!--<li class="close"></li>-->
	</ul>
	</div>

	<div class="popup_main">
		<form id="mySheetForm" name="mySheetForm" tabindex="1">
			<div class="sheet_search outer">
				<div>
				<table>
				<tr>
                       <td> <span>프로그램명</span> <input id="srchPrgNm" name ="srchPrgNm" type="text" class="text" /> </td>
					   <td> <span>프로그램</span> <input id="srchPrgCd" name ="srchPrgCd" type="text" class="text" /> </td>
                       <td>
						<a href="javascript:doAction('Search')" id="btnSearch" class="button">조회</a>
					</td>
				</tr>
				</table>
				</div>
			</div>
		</form>

		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<tr>
				<td>
					<div class="inner">
						<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">프로그램</li>
							<li class="btn">
							</li>
						</ul>
						</div>
					</div>
					<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
				</td>
			</tr>
		</table>
		<div class="popup_button outer">
			<ul>
				<li>
					<a href="javascript:p.self.close();" class="gray large">닫기</a>
				</li>
			</ul>
		</div>
	</div>

</div>
</body>
</html>