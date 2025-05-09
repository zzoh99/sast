<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='sepEleLinkCalcMgrDbItemPopup' mdef='DB ITEM'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 퇴직항목링크(계산식)
 * @author JM
-->
<script type="text/javascript">
var p = eval("${popUpStatus}");
$(function() {
	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};
	initdata1.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },
		{Header:"<sht:txt mid='authScopeCd' mdef='코드'/>",		Type:"Text",		Hidden:0,					Width:100,			Align:"Left",	ColMerge:0,	SaveName:"dbItemCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='dbItemNm' mdef='ITEM명'/>",	Type:"Text",		Hidden:0,					Width:100,			Align:"Left",	ColMerge:0,	SaveName:"dbItemNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='description' mdef='설명'/>",		Type:"Text",		Hidden:0,					Width:100,			Align:"Left",	ColMerge:0,	SaveName:"description",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000 },
		{Header:"<sht:txt mid='dataTypeV5' mdef='데이타타입'/>",	Type:"Combo",		Hidden:0,					Width:100,			Align:"Left",	ColMerge:0,	SaveName:"dataType",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='bizCd' mdef='업무구분'/>",		Type:"Combo",		Hidden:0,					Width:100,			Align:"Left",	ColMerge:0,	SaveName:"bizCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 }
	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);

	//------------------------------------- 그리드 콤보 -------------------------------------//
	// 데이타타입(C00025)
	var dataType = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "C00025"), "");
	sheet1.SetColProperty("dataType", {ComboText:dataType[0], ComboCode:dataType[1]});

	// 업무구분코드(R10020)
	//var bizCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "R10020"), "");
	var bizCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getCommonMainMenuList&searchMainMenuCd="), "<tit:txt mid='103895' mdef='전체'/>");

	sheet1.SetColProperty("bizCd", {ComboText:bizCd[0], ComboCode:bizCd[1]});

	$("#bizCd").html(bizCd[2]);

	$(window).smartresize(sheetResize);
	sheetInit();

	doAction1("Search");

	$(".close").click(function() {
		p.self.close();
	});
});

function doAction1(sAction) {
	switch (sAction) {
		case "Search":
			sheet1.DoSearch("${ctx}/SepEleLinkCalcMgr.do?cmd=getSepEleLinkCalcMgrDbItemList", $("#sheet1Form").serialize());
			break;

		case "Clear":
			sheet1.RemoveAll();
			break;

		case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
			break;
	}
}

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

function sheet1_OnDblClick(Row, Col, CellX, CellY, CellW, CellH) {
	var args = new Array();
	if (Row > 0) {
		args["dbItemCd"] 	= sheet1.GetCellValue(Row, "dbItemCd");
		args["dbItemNm"]	= sheet1.GetCellValue(Row, "dbItemNm");

		//p.window.returnValue 	= args;
		if(p.popReturnValue) p.popReturnValue(args);
		p.window.close();
	}
}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="popup_title">
	<ul>
		<li><tit:txt mid='sepEleLinkCalcMgrDbItemPopup' mdef='DB ITEM'/></li>
		<li class="close"></li>
	</ul>
	</div>
	<div class="popup_main">
		<form id="sheet1Form" name="sheet1Form">
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='114394' mdef='업무구분'/></th>
						<td>  <select id="bizCd" name="bizCd"> </select> </td>
						<th><tit:txt mid='114208' mdef='ITEM명'/></th>
						<td>  <input type="text" id="dbItemNm" name ="dbItemNm" class="text" value="" /> </td>
						<td> <a href="javascript:doAction1('Search')"	class="button authR"><tit:txt mid='104081' mdef='조회'/></a> </td>
					</tr>
				</table>
			</div>
		</div>
		</form>
		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<tr>
				<td class="top">
					<div class="outer">
						<div class="sheet_title">
							<ul>
								<li id="txt" class="txt">DB ITEM </li>
								<li class="btn">
									<a href="javascript:doAction1('Down2Excel')"	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
								</li>
							</ul>
						</div>
					</div>
					<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
				</td>
			</tr>
		</table>
		<div class="popup_button outer">
			<ul>
				<li>
					<a href="javascript:p.self.close();" class="gray large"><tit:txt mid='104157' mdef='닫기'/></a>
				</li>
			</ul>
		</div>
	</div>
</div>
</body>
</html>
