<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='empRatioMgr' mdef='고용보험요율'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 고용보험요율
 * @author JM
-->
<script type="text/javascript">
$(function() {
	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22, MergeSheet:msHeaderOnly};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata1.Cols = [
		{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V1' mdef='삭제|삭제'/>",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",			Sort:0 },
		{Header:"<sht:txt mid='sStatus V4' mdef='상태|상태'/>",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",			Sort:0 },
		{Header:"<sht:txt mid='sDate' mdef='시작일자|시작일자'/>",			Type:"Date",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"sdate",			KeyField:1,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 , EndDateCol:"edate"},
		{Header:"<sht:txt mid='edateV7' mdef='종료일자|종료일자'/>",			Type:"Date",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"edate",			KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 , StartDateCol:"sdate"},
		{Header:"<sht:txt mid='umempSelfRate' mdef='실업급여|본인부담율'/>",			Type:"Float",		Hidden:0,					Width:90,			Align:"Right",	ColMerge:0,	SaveName:"umempSelfRate",	KeyField:0,	Format:"Float",		PointCount:5,	UpdateEdit:1,	InsertEdit:1,	EditLen:8 },
		{Header:"<sht:txt mid='unempCompRate' mdef='실업급여|회사부담율'/>",			Type:"Float",		Hidden:0,					Width:90,			Align:"Right",	ColMerge:0,	SaveName:"unempCompRate",	KeyField:0,	Format:"Float",		PointCount:5,	UpdateEdit:1,	InsertEdit:1,	EditLen:8 },
		{Header:"<sht:txt mid='empSelfRate' mdef='고용안정사업|본인부담율'/>",		Type:"Float",		Hidden:0,					Width:90,			Align:"Right",	ColMerge:0,	SaveName:"empSelfRate",		KeyField:0,	Format:"Float",		PointCount:5,	UpdateEdit:1,	InsertEdit:1,	EditLen:8 },
		{Header:"<sht:txt mid='empCompRate' mdef='고용안정사업|회사부담율'/>",		Type:"Float",		Hidden:0,					Width:90,			Align:"Right",	ColMerge:0,	SaveName:"empCompRate",		KeyField:0,	Format:"Float",		PointCount:5,	UpdateEdit:1,	InsertEdit:1,	EditLen:8 },
		{Header:"<sht:txt mid='abilitySelfRate' mdef='직업능력개발|본인부담율'/>",		Type:"Float",		Hidden:0,					Width:90,			Align:"Right",	ColMerge:0,	SaveName:"abilitySelfRate",	KeyField:0,	Format:"Float",		PointCount:5,	UpdateEdit:1,	InsertEdit:1,	EditLen:8 },
		{Header:"<sht:txt mid='abilityCompRate' mdef='직업능력개발|회사부담율'/>",		Type:"Float",		Hidden:0,					Width:90,			Align:"Right",	ColMerge:0,	SaveName:"abilityCompRate",	KeyField:0,	Format:"Float",		PointCount:5,	UpdateEdit:1,	InsertEdit:1,	EditLen:8 },
		{Header:"<sht:txt mid='accidentRate' mdef='산재보험부담율|산재보험부담율'/>",		Type:"Float",		Hidden:1,					Width:90,			Align:"Right",	ColMerge:0,	SaveName:"accidentRate",	KeyField:0,	Format:"Float",		PointCount:5,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
		{Header:"<sht:txt mid='bondMon' mdef='임금채권부담금|임금채권부담금'/>",		Type:"Int",			Hidden:1,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"bondMon",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);

	$(window).smartresize(sheetResize);
	sheetInit();

	doAction1("Search");
});

function chkInVal() {
	// 시작일자와 종료일자 체크
	var rowCnt = sheet1.RowCount();
	for (var i=2; i<=rowCnt+1; i++) {
		if (sheet1.GetCellValue(i, "sStatus") == "I" || sheet1.GetCellValue(i, "sStatus") == "U") {
			if (sheet1.GetCellValue(i, "edate") != null && sheet1.GetCellValue(i, "edate") != "") {
				var sdate = sheet1.GetCellValue(i, "sdate");
				var edate = sheet1.GetCellValue(i, "edate");
				if (parseInt(sdate) > parseInt(edate)) {
					alert("<msg:txt mid='110396' mdef='시작일자가 종료일자보다 큽니다.'/>");
					sheet1.SelectCell(i, "edate");
					return false;
				}
			}
		}
	}

	return true;
}

function doAction1(sAction) {
	switch (sAction) {
		case "Search":
			sheet1.DoSearch("${ctx}/SocInsRatesMgr.do?cmd=getEmpRatioMgrList");
			break;

		case "Save":
			// 필수값/유효성 체크
			if (!chkInVal()) {
				break;
			}

			// 중복체크
			if (!dupChk(sheet1, "sdate", false, true)) {break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave("${ctx}/SocInsRatesMgr.do?cmd=saveEmpRatioMgr", $("#sheet1Form").serialize());
			break;

		case "Insert":
			var Row = sheet1.DataInsert(0);
			sheet1.SetCellValue(Row, "sdate", "${curSysYyyyMMdd}");
			sheet1.SelectCell(Row, 2);
			break;

		case "Copy":
			sheet1.SelectCell(sheet1.DataCopy(), 2);
			break;

		case "Clear":
			sheet1.RemoveAll();
			break;

		case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
	}
}

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

// 저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<form id="sheet1Form" name="sheet1Form"></form>
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='empRatioMgr' mdef='고용보험요율'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Down2Excel')"	css="btn outline-gray authR" mid='110698' mdef="다운로드"/>
								<btn:a href="javascript:doAction1('Copy')"			css="btn outline-gray authA" mid='110696' mdef="복사"/>
								<btn:a href="javascript:doAction1('Insert')"		css="btn outline-gray authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction1('Save')"			css="btn filled authA" mid='110708' mdef="저장"/>
								<btn:a href="javascript:doAction1('Search')"		css="btn dark authR" mid='110697' mdef="조회"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
