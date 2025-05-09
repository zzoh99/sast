<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='sepPenTypeMgr' mdef='퇴직연금유형관리'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 퇴직연금유형관리
 * @author JM
-->
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
$(function() {
	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata1.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",			Sort:0 },
		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",			Sort:0 },
		{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",		Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"orgNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",		Type:"Text",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='alias' mdef='별칭'/>",	Type:"Text",		Hidden:Number("${aliasHdn}"),					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"alias",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",	Type:"Text",		Hidden:Number("${jgHdn}"),					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",	Type:"Text",		Hidden:Number("${jwHdn}"),					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='eduSYmd' mdef='시작일'/>",		Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"sdate",			KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='eYmdV1' mdef='종료일'/>",		Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"edate",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='retPentionType' mdef='퇴직연금유형'/>",	Type:"Combo",		Hidden:0,					Width:100,			Align:"Left",	ColMerge:0,	SaveName:"retPentionType",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 }
	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);

	//------------------------------------- 조회조건 콤보 -------------------------------------//
	// 퇴직연금구분(H10170)
	let baseSYmd = $("#sdate").val();
	var retPentionType = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10170", baseSYmd), "<tit:txt mid='103895' mdef='전체'/>");
	$("#retPentionType").html(retPentionType[2]);

	$(window).smartresize(sheetResize);
	sheetInit();
	getCommonCodeList();

	$("#sabunName").bind("keyup",function(event) {
		if (event.keyCode == 13) {
			doAction1("Search");
		}
	});
	
	// 이름 입력 시 자동완성
	$(sheet1).sheetAutocomplete({
		Columns: [
			{
				ColSaveName  : "name",
				CallbackFunc : function(returnValue){
					var rv = $.parseJSON('{' + returnValue+ '}');
					sheet1.SetCellValue(gPRow, "name", rv["name"]);
					sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
					sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
				}
			}
		]
	});		

	$("#sdate").datepicker2({
		onReturn: function () {
			// 퇴직연금구분(H10170)
			let baseSYmd = $("#sdate").val();
			const retPentionType = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10170", baseSYmd), "<tit:txt mid='103895' mdef='전체'/>");
			$("#retPentionType").html(retPentionType[2]);
		}
	});
	$("#sdate").val("${curSysYyyyMMddHyphen}");
	$("#sdate").bind("keyup",function(event){
		if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
	});
});

function getCommonCodeList() {
	//------------------------------------- 그리드 콤보 -------------------------------------//
	// 퇴직연금유형(H10170)
	let baseSYmd = $("#sdate").val();
	const retPentionType = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10170", baseSYmd), "");
	sheet1.SetColProperty("retPentionType", {ComboText:"|"+retPentionType[0], ComboCode:"|"+retPentionType[1]});
}

//필수값/유효성 체크
function chkInVal(sAction) {
	// 시작일자와 종료일자 체크
	var rowCnt = sheet1.RowCount();
	for (var i=1; i<=rowCnt; i++) {
		if (sheet1.GetCellValue(i, "sStatus") == "I" || sheet1.GetCellValue(i, "sStatus") == "U") {
			if (sheet1.GetCellValue(i, "edate") != null && sheet1.GetCellValue(i, "edate") != "") {
				var sdate = sheet1.GetCellValue(i, "sdate");
				var edate = sheet1.GetCellValue(i, "edate");
				if (parseInt(sdate) > parseInt(edate)) {
					alert("<msg:txt mid='109833' mdef='시작일이 종료일보다 큽니다.'/>");
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
			getCommonCodeList();
			sheet1.DoSearch("${ctx}/SepPenTypeMgr.do?cmd=getSepPenTypeMgrList", $("#sheet1Form").serialize());
			break;

		case "Save":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			// 중복체크
			if (!dupChk(sheet1, "sabun|sdate", false, true)) {break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave("${ctx}/SepPenTypeMgr.do?cmd=saveSepPenTypeMgr", $("#sheet1Form").serialize());
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

		case "LoadExcel":
			// 업로드
			var params = {};
			sheet1.LoadExcel(params);
			break;

		case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;

		case "DownTemplate":
			// 양식다운로드
			sheet1.Down2Excel({ SheetDesign:1, Merge:0, DownRows:"0", DownCols:"sabun|name|sdate|edate|retPentionType"});
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
	<form id="sheet1Form" name="sheet1Form">
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='104352' mdef='기준일자'/></th>
						<td>  <input type="text" id="sdate" name="sdate" class="date2" /> </td>
						<th><tit:txt mid='112804' mdef='연금유형'/></th>
						<td>  <select id="retPentionType" name="retPentionType"></select> </td>
						<th><tit:txt mid='104330' mdef='사번/성명'/></th>
						<td>  <input type="text" id="sabunName" name="sabunName" class="text" value="" style="ime-mode:active" /> </td>
						<td> <btn:a href="javascript:doAction1('Search')"	css="button authR" mid='110697' mdef="조회"/> </td>
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
							<li id="txt" class="txt"><tit:txt mid='113514' mdef='퇴직연금유형관리 '/> </li>
							<li class="btn">
								<btn:a href="javascript:doAction1('DownTemplate')"	css="basic authA" mid='110702' mdef="양식다운로드"/>
								<btn:a href="javascript:doAction1('Insert')"		css="basic authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction1('Copy')"			css="basic authA" mid='110696' mdef="복사"/>
								<btn:a href="javascript:doAction1('Save')"			css="basic authA" mid='110708' mdef="저장"/>
								<btn:a href="javascript:doAction1('LoadExcel')"		css="basic authA" mid='110703' mdef="업로드"/>
								<btn:a href="javascript:doAction1('Down2Excel')"	css="basic authR" mid='110698' mdef="다운로드"/>
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
