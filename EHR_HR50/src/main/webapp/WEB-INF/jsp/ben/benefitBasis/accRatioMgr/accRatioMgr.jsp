<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='114388' mdef='산재보험요율'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 산재보험요율
 * @author JM
-->
<script type="text/javascript">
$(function() {
	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata1.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },
		{Header:"<sht:txt mid='locationCd_V3078' mdef='산재근무지'/>",		Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"locationCd",	KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='sYmd' mdef='시작일자'/>",			Type:"Date",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 , EndDateCol:"edate"},
		{Header:"<sht:txt mid='eYmd' mdef='종료일자'/>",			Type:"Date",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 , StartDateCol:"sdate"},
		{Header:"<sht:txt mid='rate_V4144' mdef='요율'/>",			Type:"Float",		Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"rate",		KeyField:0,	Format:"Float",		PointCount:5,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='accidentRate_V3089' mdef='산재보험부담율'/>",		Type:"Float",		Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"accidentRate",KeyField:0,	Format:"Float",		PointCount:5,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='bondMon_V4560' mdef='임금채권부담금'/>",		Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"bondMon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",			Type:"Text",		Hidden:0,					Width:100,			Align:"Left",	ColMerge:0,	SaveName:"bigo",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 }
	]; IBS_InitSheet(sheet1,initdata1); sheet1.SetCountPosition(0);

	//------------------------------------- 그리드 콤보 -------------------------------------//
	// 산재근무지(B40120)
	var locationCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "B40120"), "");
	sheet1.SetColProperty("locationCd", {ComboText:"|"+locationCd[0], ComboCode:"|"+locationCd[1]});

	//------------------------------------- 조회조건 콤보 -------------------------------------//
	// 산재근무지(B40120)
	var locationCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "B40120"), "<tit:txt mid='103895' mdef='전체'/>");
	$("#locationCd").html(locationCd[2]);
	$("#locationCd").bind("change", function(){
		doAction1("Search");
	})

	$(window).smartresize(sheetResize);
	sheetInit();

	doAction1("Search");
});

function chkInVal() {
	// 시작일자와 종료일자 체크
	var rowCnt = sheet1.RowCount();
	for (var i=1; i<=rowCnt; i++) {
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
			sheet1.DoSearch("${ctx}/SocInsRatesMgr.do?cmd=getAccRatioMgrList", $("#sheet1Form").serialize());
			break;

		case "Save":
			// 필수값/유효성 체크
			if (!chkInVal()) {
				break;
			}

			// 중복체크
			if (!dupChk(sheet1, "sdate|locationCd", false, true)) {break;}

			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave("${ctx}/SocInsRatesMgr.do?cmd=saveAccRatioMgr", $("#sheet1Form").serialize());
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
<body class="bodywrap">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
		<div class="sheet_search outer" style="border-top: 1px solid #ebeef3">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='104281' mdef='근무지'/></th>
						<td>  <select id="locationCd" name="locationCd"> </select> </td>
						<td> <a href="javascript:doAction1('Search')" class="btn dark authR"><tit:txt mid='104081' mdef='조회'/></a> </td>
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
							<li id="txt" class="txt"><tit:txt mid='114388' mdef='산재보험요율'/></li>
							<li class="btn">
								<a href="javascript:doAction1('Down2Excel')"	class="btn outline-gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
								<a href="javascript:doAction1('Copy')" 			class="btn outline-gray authA"><tit:txt mid='104335' mdef='복사'/></a>
								<a href="javascript:doAction1('Insert')" 		class="btn outline-gray authA"><tit:txt mid='104267' mdef='입력'/></a>
								<a href="javascript:doAction1('Save')" 			class="btn filled authA"><tit:txt mid='104476' mdef='저장'/></a>
<%--								<a href="javascript:doAction1('Search')" 		class="btn dark authR"><tit:txt mid='104081' mdef='조회'/></a>--%>
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
