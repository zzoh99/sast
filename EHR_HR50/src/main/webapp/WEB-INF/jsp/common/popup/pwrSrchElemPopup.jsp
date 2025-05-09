<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var p = eval("${popUpStatus}");
	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>"			,Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='resultV2' mdef='결과'/>"			,Type:"Text",		Hidden:1,					Width:0,			Align:"Center",	ColMerge:0,	SaveName:"sResult"},
			{Header:"<sht:txt mid='dbItemDesc' mdef='세부\n내역'/>"	,Type:"Text",		Hidden:1,					Width:0,			Align:"Center",	ColMerge:0,	SaveName:"sStatus"},
			{Header:"<sht:txt mid='benefitElemCd' mdef='항목코드'/>"		,Type:"Text",		Hidden:1,					Width:0,			Align:"Left",	ColMerge:0,	SaveName:"searchItemCd",	UpdateEdit:0 },
			{Header:"<sht:txt mid='benefitElemNm' mdef='항목명'/>"		,Type:"Text",		Hidden:0,					Width:150,			Align:"Left",	ColMerge:0,	SaveName:"searchItemNm",	UpdateEdit:0 },
			{Header:"<sht:txt mid='searchItemDesc' mdef='항목설명'/>"		,Type:"Text",		Hidden:0,					Width:200,			Align:"Left",	ColMerge:0,	SaveName:"searchItemDesc",	UpdateEdit:0 },
			{Header:"<sht:txt mid='itemMapTypeV1' mdef='맵핑구분'/>"		,Type:"Text",		Hidden:1,					Width:0,			Align:"Left",	ColMerge:0,	SaveName:"itemMapType",		UpdateEdit:0 },
			{Header:"<sht:txt mid='prgUrl' mdef='프로그램URL'/>"	,Type:"Text",		Hidden:1,					Width:0,			Align:"Left",	ColMerge:0,	SaveName:"prgUrl",			UpdateEdit:0 },
			{Header:"<sht:txt mid='sqlSyntaxV2' mdef='SQL구문'/>"		,Type:"Text",		Hidden:1,					Width:0,			Align:"Left",	ColMerge:0,	SaveName:"sqlSyntax",		UpdateEdit:0 },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>"			,Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete" }
		];IBS_InitSheet(sheet1, initdata); sheet1.SetEditable("${editable}");sheet1.SetCountPosition(4);sheet1.SetEditableColorDiff (0);
		sheet1.SetColProperty("itemMapType", {ComboText:"SQL|URL", ComboCode:"SQL|URL"} );

		$("#cdNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction("Search"); $(this).focus();
			}
		});
		$(window).smartresize(sheetResize); sheetInit();
	    doAction("Search");

	    $(".close").click(function() { p.self.close(); });
	});
	function doAction(sAction) {
		switch (sAction) {
		case "Search"		:	sheet1.DoSearch( "${ctx}/PwrSrchElemPopup.do?cmd=getPwrSrchElemPopupList", $("#mySheetForm").serialize() ); break;
		}
	}
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	function sheet1_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		var rv = new Array(5);
		rv["searchItemCd"] 	= sheet1.GetCellValue(Row, "searchItemCd");
		rv["searchItemNm"] 	= sheet1.GetCellValue(Row, "searchItemNm");
		rv["searchItemDesc"]= sheet1.GetCellValue(Row, "searchItemDesc");
		rv["itemMapType"] 	= sheet1.GetCellValue(Row, "itemMapType");
		rv["prgUrl"] 		= sheet1.GetCellValue(Row, "prgUrl");
		rv["sqlSyntax"]		= sheet1.GetCellValue(Row, "sqlSyntax");
		p.popReturnValue(rv);
		p.window.close();
	}
</script>
</head>

<body class="bodywrap">
<div class="wrapper">
	<div class="popup_title">
	<ul>
		<li><tit:txt mid='113450' mdef='조건검색 코드항목 조회'/></li>
		<li class="close"></li>
	</ul>
	</div>
	<div class="popup_main">
		<div class="sheet_search outer">
			<div>
				<form id="mySheetForm" name="mySheetForm" >
				<table>
					<tr>
						<th><tit:txt mid='112734' mdef='코드항목명'/></th>
						<td>
							<input id="cdNm" name ="cdNm" type="text" class="text" />
						</td>
						<td>
							<btn:a href="javascript:doAction('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/>
						</td>
					</tr>
				</table>
				</form>
			</div>
		</div>
		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<tr>
				<td>
					<div class="inner">
						<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='program' mdef='프로그램'/></li>
							<li class="btn">
							</li>
						</ul>
						</div>
					</div>
					<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
				</td>
			</tr>
		</table>
		<div class="popup_button outer">
			<ul>
				<li>
					<btn:a href="javascript:p.self.close();" css="gray large" mid='110881' mdef="닫기"/>
				</li>
			</ul>
		</div>
	</div>
</div>
</body>
</html>
