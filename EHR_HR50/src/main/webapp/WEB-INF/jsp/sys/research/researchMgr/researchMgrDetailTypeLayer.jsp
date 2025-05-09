<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp"%>
<title><tit:txt mid='112573' mdef='설문지 상세 팝업'/></title>
<script type="text/javascript">
var researchSeq = null;
var questionSeq = null;
$(function(){
	createIBSheet3(document.getElementById('researchMgrDetailTypeLayerSheet-wrap'), "researchMgrDetailTypeLayerSheet", "100%", "100%", "${ssnLocaleCd}");

	const modal = window.top.document.LayerModalUtility.getModal('researchMgrDetailTypeLayer');
	researchSeq 	= modal.parameters.researchSeq;
	questionSeq 	= modal.parameters.questionSeq;

	$("#rSeq").val(researchSeq);
	$("#qSeq").val(questionSeq);

	var initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad,Page:22, AutoFitColWidth:'init|search|resize|rowtransaction'};
	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
	initdata.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",	Type:"${sNoTy}",  	Hidden:0,   Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",	Type:"${sDelTy}", 	Hidden:0,  Width:"${sDelWdt}", Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
		{Header:"<sht:txt mid='statusCd' mdef='상태'/>",	Type:"${sSttTy}", 	Hidden:0,  Width:"${sSttWdt}", Align:"Center",  ColMerge:0,   SaveName:"sStatus" },
		{Header:"<sht:txt mid='researchSeq' mdef='설문지순번'/>",	Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"researchSeq",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='questionSeq' mdef='질문순번'/>",		Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"questionSeq",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='itemSeq' mdef='질문항목순번'/>",	Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"itemSeq",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='displaySeq' mdef='선택지순서'/>",	Type:"Int",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"displaySeq",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='rightPoint' mdef='예상점수'/>",		Type:"Int",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"rightPoint",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='itemNm' mdef='선택지내용'/>",	Type:"Text",	Hidden:0,	Width:180,	Align:"Left",	ColMerge:0,	SaveName:"itemNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
	]; IBS_InitSheet(researchMgrDetailTypeLayerSheet, initdata);researchMgrDetailTypeLayerSheet.SetCountPosition(4);

	var sheetHeight = $(".modal_body").height() - $(".sheet_title").height() - $("#sheetForm").height();
	researchMgrDetailTypeLayerSheet.SetSheetHeight(sheetHeight);

	doAction5("Search");
});

function doAction5(sAction) {
	switch (sAction) {
		case "Search":  researchMgrDetailTypeLayerSheet.DoSearch( "${ctx}/ResearchMgr.do?cmd=getResearchMgrDetailTypeList", $("#sheetForm").serialize()); break;

		case "Save":
						IBS_SaveName(document.sheetForm,researchMgrDetailTypeLayerSheet);
						researchMgrDetailTypeLayerSheet.DoSave( "${ctx}/ResearchMgr.do?cmd=saveResearchMgrDetailType", $("#sheetForm").serialize() );  break;
		case "Insert":
			var iRow = researchMgrDetailTypeLayerSheet.DataInsert(researchMgrDetailTypeLayerSheet.LastRow()+1);
			researchMgrDetailTypeLayerSheet.SetCellValue(iRow, "researchSeq",researchSeq);
			researchMgrDetailTypeLayerSheet.SetCellValue(iRow, "questionSeq",questionSeq);
			researchMgrDetailTypeLayerSheet.SelectCell(iRow, 'displaySeq');
			break;
		case "Copy":
			var cRow = researchMgrDetailTypeLayerSheet.DataCopy();
			researchMgrDetailTypeLayerSheet.SetCellValue(cRow, "itemSeq","");
			break;
	}
}
function sheet5_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); }
		// sheetResize();
	} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}
function sheet5_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg);}
		doAction5("Search");
		// sheetResize();
	} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}
</script>
</head>
<body class="bodywrap">
	<div class="wrapper modal_layer">
		<div class="modal_body">
			<form id="sheetForm" name="sheetForm" >
				<input id="rSeq" name="rSeq" type="hidden"/>
				<input id="qSeq" name="qSeq" type="hidden"/>
			</form>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li class="txt"><tit:txt mid='114006' mdef='질문 선택지'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction5('Copy')" css="btn outline-gray authA" mid='copy' mdef="복사"/>
								<btn:a href="javascript:doAction5('Insert')" css="btn outline-gray authA" mid='insert' mdef="입력"/>
								<a href="javascript:doAction5('Save')" class="btn filled authA"><tit:txt mid='104476' mdef='저장'/></a>
								<btn:a href="javascript:doAction5('Search')" css="btn dark authA" mid='search' mdef="조회"/>
							</li>
						</ul>
					</div>
				</div>
<%--						<script type="text/javascript"> createIBSheet("researchMgrDetailTypeLayerSheet", "100%", "100%", "${ssnLocaleCd}"); </script>--%>
				<div id="researchMgrDetailTypeLayerSheet-wrap"></div>
		</div>
		<div class="modal_footer">
			<btn:a href="javascript:closeCommonLayer('researchMgrDetailTypeLayer');" css="gray large" mid='close' mdef="닫기"/>
		</div>
	</div>
</body>
</html>
