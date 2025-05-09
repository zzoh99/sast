<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='allowElePptMgr1' mdef='수당항목'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%--<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>--%>

<!--
 * 소급예외수당관리
 * @author JM
-->
<script type="text/javascript">
<%--var p = eval("${popUpStatus}");--%>
$(function() {

	createIBSheet3(document.getElementById('sheet1-wrap'), "sheet1", "100%", "100%", "${ssnLocaleCd}");

	const modal = window.top.document.LayerModalUtility.getModal('retroAllowElementLayer');
	let payActionCd = modal.parameters.payActionCd || '';
	let rtrPayActionCd = modal.parameters.rtrPayActionCd || '';

	// var arg = p.window.dialogArguments;
	//
    // var payActionCd 	= "";
    // var rtrPayActionCd 	= "";
	//
    // if( arg != undefined ) {
    // 	payActionCd 	= arg["payActionCd"];
    // 	rtrPayActionCd 	= arg["rtrPayActionCd"];
    // }else{
	//     if(p.popDialogArgument("payActionCd")!=null)		payActionCd  	= p.popDialogArgument("payActionCd");
	//     if(p.popDialogArgument("rtrPayActionCd")!=null)		rtrPayActionCd  	= p.popDialogArgument("rtrPayActionCd");
    // }

	$("#payActionCd").val(payActionCd);
	$("#rtrPayActionCd").val(rtrPayActionCd);

	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22, AutoFitColWidth:'init|search|resize|rowtransaction'};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};
	initdata1.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",			Sort:0 },
		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",			Sort:0 },
		{Header:"<sht:txt mid='payActionCdV6' mdef='소급일자코드'/>",		Type:"Text",		Hidden:1,					Width:50,			Align:"Left",	ColMerge:0,	SaveName:"payActionCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='payActionNmV3' mdef='소급일자'/>",			Type:"Text",		Hidden:0,					Width:100,			Align:"Left",	ColMerge:0,	SaveName:"payActionNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='rtrPayActionCd' mdef='소급대상급여계산코드'/>",	Type:"Text",		Hidden:1,					Width:100,			Align:"Left",	ColMerge:0,	SaveName:"rtrPayActionCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='rtrPayActionNmV1' mdef='소급대상급여명'/>",		Type:"Text",		Hidden:0,					Width:100,			Align:"Left",	ColMerge:0,	SaveName:"rtrPayActionNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='benefitElemCd' mdef='항목코드'/>",			Type:"Text",		Hidden:1,					Width:100,			Align:"Left",	ColMerge:0,	SaveName:"elementCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='benefitElemNm' mdef='항목명'/>",			Type:"Text",		Hidden:0,					Width:80,			Align:"Left",	ColMerge:0,	SaveName:"elementNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);

	$(window).smartresize(sheetResize);
	sheetInit();

	// $(".close").click(function() {
	// 	p.self.close();
	// });

	doAction1("Search");
});

function doAction1(sAction) {
	switch (sAction) {
		case "Search":
			sheet1.DoSearch("/RetroExceAllowDedMgr.do?cmd=getRetroExceAllowDedMgrElementList", $("#sheet1Form").serialize());
			break;

		case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
	}
}

//조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

function sheet1_OnDblClick(Row, Col, CellX, CellY, CellW, CellH) {
	const modal = window.top.document.LayerModalUtility.getModal('retroAllowElementLayer');
	modal.fire('retroAllowElementTrigger', {
		payActionCd : sheet1.GetCellValue(Row, "payActionCd")
		, payActionNm : sheet1.GetCellValue(Row, "payActionNm")
		, rtrPayActionCd : sheet1.GetCellValue(Row, "rtrPayActionCd")
		, rtrPayActionNm : sheet1.GetCellValue(Row, "rtrPayActionNm")
		, elementCd : sheet1.GetCellValue(Row, "elementCd")
		, elementNm : sheet1.GetCellValue(Row, "elementNm")
	}).hide();
}

</script>
</head>
<body class="hidden bodywrap">
	<div class="wrapper modal_layer">
		<div class="modal_body">
			<form id="sheet1Form" name="sheet1Form">
				<input type="hidden" id="payActionCd" name="payActionCd" value="" /><input type="hidden" id="rtrPayActionCd" name="rtrPayActionCd" value="" />
			</form>
			<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
				<tr>
					<td>
					<div>
						<div class="sheet_title outer">
							<ul>
								<li class="btn">
									<btn:a href="javascript:doAction1('Down2Excel')"	css="basic authR" mid='110698' mdef="다운로드"/>
								</li>
							</ul>
						</div>
					</div>
						<div id="sheet1-wrap"></div>
					</td>
				</tr>
			</table>
		</div>
		<div class="modal_footer">
			<ul>
				<li>
					<btn:a href="javascript:closeCommonLayer('retroAllowElementLayer');" css="gray large" mid='110881' mdef="닫기"/>
				</li>
			</ul>
		</div>
	</div>
</body>
</html>
