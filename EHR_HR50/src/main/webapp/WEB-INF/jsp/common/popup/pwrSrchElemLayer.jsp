<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
	<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
	<script type="text/javascript">
		var p = eval("${popUpStatus}");
		$(function() {
			createIBSheet3(document.getElementById('pwrSrchElemLayerSheet-wrap'), "pwrSrchElemLayerSheet", "100%", "100%", "kr");

			var initdata = {};
			initdata.Cfg = {SearchMode:smLazyLoad,Page:22, AutoFitColWidth:'init|search|resize|rowtransaction'};
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
			];
			IBS_InitSheet(pwrSrchElemLayerSheet, initdata);
			pwrSrchElemLayerSheet.SetEditable("${editable}");
			pwrSrchElemLayerSheet.SetCountPosition(4);
			pwrSrchElemLayerSheet.SetEditableColorDiff (0);
			pwrSrchElemLayerSheet.SetColProperty("itemMapType", {ComboText:"SQL|URL", ComboCode:"SQL|URL"} );

			var sheetHeight = $(".modal_body").height() - $("#mySheetForm").height() - $(".sheet_title").height() - 63;
			$(window).smartresize(sheetResize); sheetInit();
			pwrSrchElemLayerSheet.SetSheetHeight(sheetHeight);

			doAction("Search");

			$("#cdNm").bind("keyup",function(event){
				if( event.keyCode == 13){
					doAction("Search"); $(this).focus();
				}
			});
		});
		function doAction(sAction) {
			switch (sAction) {
				case "Search"		:	pwrSrchElemLayerSheet.DoSearch( "${ctx}/PwrSrchElemPopup.do?cmd=getPwrSrchElemPopupList", $("#mySheetForm").serialize() ); break;
			}
		}
		function pwrSrchElemLayerSheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); } sheetResize();
			} catch (ex) {
				alert("OnSearchEnd Event Error : " + ex);
			}
		}
		function pwrSrchElemLayerSheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
			var rv = new Array(5);

			const modal = window.top.document.LayerModalUtility.getModal('pwrSrchElemLayer');
			modal.fire('pwrSrchElemLayerTrigger', {
				searchItemCd :  pwrSrchElemLayerSheet.GetCellValue(Row, "searchItemCd"),
				searchItemNm : pwrSrchElemLayerSheet.GetCellValue(Row, "searchItemNm"),
				searchItemDesc : pwrSrchElemLayerSheet.GetCellValue(Row, "searchItemDesc"),
				itemMapType : pwrSrchElemLayerSheet.GetCellValue(Row, "itemMapType"),
				prgUrl : pwrSrchElemLayerSheet.GetCellValue(Row, "prgUrl"),
				sqlSyntax : pwrSrchElemLayerSheet.GetCellValue(Row, "sqlSyntax")
			}, p).hide();
		}
	</script>
</head>

<body class="bodywrap">
<div class="wrapper modal_layer">
	<div class="modal_body">
		<div class="sheet_search outer">
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
			<div class="inner">
				<div class="sheet_title">
					<ul>
						<li id="txt" class="txt"><tit:txt mid='program' mdef='프로그램'/></li>
					</ul>
				</div>
			</div>
			<div id="pwrSrchElemLayerSheet-wrap"></div>
		</div>
	</div>
	<div class="modal_footer">
		<a href="javascript:closeCommonLayer('pwrSrchElemLayer');" class="btn outline_gray">닫기</a>
	</div>
</body>
</html>
