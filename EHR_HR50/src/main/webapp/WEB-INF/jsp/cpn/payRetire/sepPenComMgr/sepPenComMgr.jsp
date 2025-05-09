<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>퇴직연금기관관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 퇴직연금기관관리
 * @author JM
-->
<script type="text/javascript">
$(function() {
	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata1.Cols = [
		{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
		{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },
		{Header:"금융기관",		Type:"Text",		Hidden:0,					Width:150,			Align:"Center",	ColMerge:0,	SaveName:"retInsCorp",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"비율(%)",	Type:"Float",		Hidden:0,					Width:100,				Align:"Right",	ColMerge:0,	SaveName:"retInsRate",	KeyField:0,	Format:"Float",	PointCount:2,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"시작일자",		Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"종료일자",		Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
		{Header:"담당자",		Type:"Text",		Hidden:0,					Width:150,			Align:"Center",	ColMerge:0,	SaveName:"retInsPerson",KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"전화번호",		Type:"Text",		Hidden:0,					Width:150,			Align:"Center",	ColMerge:0,	SaveName:"retInsTel",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"메일",			Type:"Text",		Hidden:0,					Width:150,			Align:"Center",	ColMerge:0,	SaveName:"retInsMail",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);

	//------------------------------------- 그리드 콤보 -------------------------------------//
	// 금융기관(H20401) -> ISU그룹 프로젝트 : TEXT화
// 	var retInsCorp = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20401"), "");
// 	sheet1.SetColProperty("retInsCorp", {ComboText:"|"+retInsCorp[0], ComboCode:"|"+retInsCorp[1]});

	$(window).smartresize(sheetResize);
	sheetInit();

	doAction1("Search");
});

// 필수값/유효성 체크
function chkInVal(sAction) {
	// 시작일자와 종료일자 체크
	var rowCnt = sheet1.RowCount();
	for (var i=1; i<=rowCnt; i++) {
		if (sheet1.GetCellValue(i, "sStatus") == "I" || sheet1.GetCellValue(i, "sStatus") == "U") {
			if (sheet1.GetCellValue(i, "edate") != null && sheet1.GetCellValue(i, "edate") != "") {
				var sdate = sheet1.GetCellValue(i, "sdate");
				var edate = sheet1.GetCellValue(i, "edate");
				if (parseInt(sdate) > parseInt(edate)) {
					alert("시작일이 종료일보다 큽니다.");
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
			sheet1.DoSearch("${ctx}/SepPenComMgr.do?cmd=getSepPenComMgrList");
			break;

		case "Save":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			// 중복체크
			if(!dupChk(sheet1, "retInsCorp|sdate", false, true)) {break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave("${ctx}/SepPenComMgr.do?cmd=saveSepPenComMgr", $("#sheet1Form").serialize());
			break;

		case "Insert":
			var Row = sheet1.DataInsert(0);
			sheet1.SelectCell(Row, 2);
			break;

		case "Copy":
			var Row = sheet1.DataCopy();
			sheet1.SelectCell(Row, 2);
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

// 저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}
</script>
</head>
<body class="hidden">
<form id="sheet1Form" name="sheet1Form"></form>
<div class="wrapper">
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td class="top">
				<div class="outer">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">퇴직연금기관관리 </li>
							<li class="btn">
								<a href="javascript:doAction1('Search')"		class="button authR">조회</a>
								<a href="javascript:doAction1('Insert')"		class="basic authA">입력</a>
								<a href="javascript:doAction1('Copy')"			class="basic authA">복사</a>
								<a href="javascript:doAction1('Save')"			class="basic authA">저장</a>
								<a href="javascript:doAction1('Down2Excel')"	class="basic authR">다운로드</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "kr"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
