<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='113864' mdef='퇴직항목링크(계산식)'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 퇴직항목링크(계산식)
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
		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },
		{Header:"<sht:txt mid='benefitElemCd' mdef='항목코드'/>",		Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"elementCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='benefitElemNm' mdef='항목명'/>",		Type:"Popup",		Hidden:0,					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"elementNm",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:50 },
		{Header:"<sht:txt mid='cRule' mdef='계산식'/>",		Type:"Text",		Hidden:0,					Width:120,			Align:"Left",	ColMerge:0,	SaveName:"cRule",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:2000 },
		{Header:"<sht:txt mid='searchSeqV1' mdef='검색순번'/>",		Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"searchSeq",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='searchDesc' mdef='검색설명'/>",		Type:"Popup",		Hidden:0,					Width:150,			Align:"Left",	ColMerge:0,	SaveName:"searchDesc",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1000 }
	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);

	var initdata2 = {};
	initdata2.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata2.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata2.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },
		{Header:"<sht:txt mid='benefitElemCd' mdef='항목코드'/>",		Type:"Text",		Hidden:1,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"elementCd",	KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='searchSeqV1' mdef='검색순번'/>",		Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"searchSeq",	KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",		Type:"Int",			Hidden:0,					Width:30,			Align:"Center",	ColMerge:0,	SaveName:"seq",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='calSeq' mdef='계산순서'/>",		Type:"Int",			Hidden:0,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"calSeq",		KeyField:1,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='eleCalType' mdef='항목구분'/>",		Type:"Combo",		Hidden:0,					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"eleCalType",	KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='calValue' mdef='계산식값'/>",		Type:"Text",		Hidden:1,					Width:100,			Align:"Left",	ColMerge:0,	SaveName:"calValue",	KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='calValueNm' mdef='계산식값명'/>",	Type:"Popup",		Hidden:0,					Width:150,			Align:"Left",	ColMerge:0,	SaveName:"calValueNm",	KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500 }
	]; IBS_InitSheet(sheet2, initdata2); sheet2.SetCountPosition(0);

	// 항목계산식구분(C00760)
	var eleCalType = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "C00760"), "");
	sheet2.SetColProperty("eleCalType", {ComboText:"|"+eleCalType[0], ComboCode:"|"+eleCalType[1]});

	$(window).smartresize(sheetResize);
	sheetInit();
	doAction1("Search");
});

function doAction1(sAction) {
	switch (sAction) {
		case "Search":
			doAction2("Clear");
			sheet1.DoSearch("${ctx}/SepEleLinkCalcMgr.do?cmd=getSepEleLinkCalcMgrList", $("#sheet1Form").serialize());
			break;

		case "Save":
			// 중복체크
			if (!dupChk(sheet1, "elementCd|searchSeq", false, true)) {break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave("${ctx}/SepEleLinkCalcMgr.do?cmd=saveSepEleLinkCalcMgr", $("#sheet1Form").serialize());
			break;

		case "Insert":
			var Row = sheet1.DataInsert(0);
			sheet1.SelectCell(Row, 2);
			break;

		case "Copy":
			var Row = sheet1.DataCopy();
			sheet1.SetCellValue(Row, "searchSeq", "");
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

function doAction2(sAction) {
	switch (sAction) {
		case "Search":
			$("#elementCd").val(sheet1.GetCellValue(sheet1.GetSelectRow(), "elementCd"));
			$("#searchSeq").val(sheet1.GetCellValue(sheet1.GetSelectRow(), "searchSeq"));

			sheet2.DoSearch("${ctx}/SepEleLinkCalcMgr.do?cmd=getSepEleLinkCalcMgrFormulaList", $("#sheet1Form").serialize());
			break;

		case "Save":
			var elementCd = sheet1.GetCellValue(sheet1.GetSelectRow(), "elementCd");
			var searchSeq = sheet1.GetCellValue(sheet1.GetSelectRow(), "searchSeq");
			var cRule = sheet1.GetCellValue(sheet1.GetSelectRow(), "cRule");
			IBS_SaveName(document.sheet1Form,sheet2);
			sheet2.DoSave("${ctx}/SepEleLinkCalcMgr.do?cmd=saveSepEleLinkCalcMgrFormula", $("#sheet1Form").serialize()+"&updateElementCd="+elementCd+"&updateSearchSeq="+searchSeq+"&updateCRule="+cRule);
			break;

		case "Insert":
			if (sheet1.GetCellValue(sheet1.GetSelectRow(), "sStatus") == "I") {
				alert("<msg:txt mid='alertSepEleLinkCalcMgr1' mdef='항목링크를 먼저 저장하세요.'/>");
				break;
			}
			if (sheet1.GetCellValue(sheet1.GetSelectRow(), "sStatus") == "D") {
				alert("<msg:txt mid='109356' mdef='삭제 표시된 항목링크입니다.'/>");
				break;
			}

			var Row = sheet2.DataInsert(0);
			sheet2.SetCellValue(Row, "elementCd", sheet1.GetCellValue(sheet1.GetSelectRow(), "elementCd"));
			sheet2.SetCellValue(Row, "searchSeq", sheet1.GetCellValue(sheet1.GetSelectRow(), "searchSeq"));
			sheet2.SetCellValue(Row, "seq", sheet2.LastRow());
			sheet2.SetCellValue(Row, "calSeq", sheet2.LastRow());
			sheet2.InitCellProperty(Row, "calValueNm", {Type: "Text", Align: "Left", Edit:1});
			sheet2.SelectCell(Row, 2);

			// 순서정렬
			sheet2.ColumnSort("calSeq", "ASC");
			break;

		case "Copy":
			var Row = sheet2.DataCopy();
			sheet2.SetCellValue(Row, "seq", "");
			sheet2.SelectCell(Row, 2);
			break;

		case "Clear":
			sheet2.RemoveAll();
			break;

		case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet2);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet2.Down2Excel(param);
			break;
	}
}

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg)
			alert(Msg);

		sheetResize();

		if (sheet1.RowCount() > 0) {
			$("#elementCd").val(sheet1.GetCellValue(sheet1.GetSelectRow(), "elementCd"));
			$("#searchSeq").val(sheet1.GetCellValue(sheet1.GetSelectRow(), "searchSeq"));

			// 계산식작성 조회
			doAction2("Search");
		}
	} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

// 저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg)
			alert(Msg);

		if (Code > 0)
			doAction1("Search");
	} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}

// 조회 후 에러 메시지
function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") {
			alert(Msg);
		} else {

			//변경된 값에의한 계산식 반영
			var calcValue = "";
			var calType = "";
			var rowCnt = sheet2.RowCount();

			// 퇴직항목계산식구분(C00760)
			var eleCalType = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "C00760"), "");

			for (var i=1; i<=rowCnt; i++) {
				calType = "";
				// 괄호
				if (sheet2.GetCellValue(i, "eleCalType") == "A") {
					sheet2.InitCellProperty(i, "calValueNm", {Type: "Combo", Align: "Left", Edit:1});
					sheet2.CellComboItem(i,"calValueNm", {"ComboCode":"(|)","ComboText":"(|)"});
					sheet2.SetCellValue(i, "calValueNm",  sheet2.GetCellValue(i, "calValue"));
				}
				// 사칙연산
				if (sheet2.GetCellValue(i, "eleCalType") == "B") {
					sheet2.InitCellProperty(i, "calValueNm", {Type: "Combo", Align: "Left", Edit:1});
					sheet2.CellComboItem(i,"calValueNm", {"ComboCode":"+|-|*|/","ComboText":"+|-|*|/"});
					sheet2.SetCellValue(i, "calValueNm",  sheet2.GetCellValue(i, "calValue"));
				}
				// 상수
				if (sheet2.GetCellValue(i, "eleCalType") == "C") {
					sheet2.InitCellProperty(i, "calValueNm", {Type: "Text", Align: "Left", Edit:1});
					sheet2.SetCellValue(i, "calValueNm",  sheet2.GetCellValue(i, "calValue"));
				}
				// DB ITEM
				if (sheet2.GetCellValue(i, "eleCalType") == "I") {
					sheet2.InitCellProperty(i, "calValueNm", {Type: "Popup", Align: "Left", Edit:1});
					calType = "[I]";
				}
				// 사용자정의함수
				if (sheet2.GetCellValue(i, "eleCalType") == "F") {
					sheet2.InitCellProperty(i, "calValueNm", {Type: "Popup", Align: "Left", Edit:1});
					calType = "[F]";
				}
				calcValue = calcValue + calType + sheet2.GetCellText(i, "calValueNm");

				sheet2.SetCellValue(i, "sStatus", "R");
			}
			$("#calcValueTxt").html("계산식 : " + calcValue);
		}
		sheetResize();
	} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

// 저장 후 메시지
function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg) {
			alert(Msg);
		} else {
			doAction1("Save");
		}
	} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}

function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	try {
		if (Row > 0) {
			$("#elementCd").val(sheet1.GetCellValue(Row, "elementCd"));
			$("#searchSeq").val(sheet1.GetCellValue(Row, "searchSeq"));

			// 계산식작성 조회
			doAction2("Search");
		}
	} catch(ex) {alert("OnClick Event Error : " + ex);}
}

function sheet1_OnPopupClick(Row, Col) {
	try{
		var colName = sheet1.ColSaveName(Col);
		if (Row > 0) {
			if (colName == "elementNm") {
				// 항목검색 팝업
				elementSearchPopup(Row, Col);
			} else if (colName == "searchDesc") {
				// 조건검색 팝업
				pwrSrchMgrPopup(Row, Col);
			}
		}
	} catch(ex) {alert("OnPopupClick Event Error : " + ex);}
}

function sheet2_OnPopupClick(Row, Col) {
	try{
		var colName = sheet2.ColSaveName(Col);
		if (Row > 0) {
			if (colName == "calValueNm") {
				// 항목계산식구분(I.DB ITEM F.사용자함수)
				if (sheet2.GetCellValue(Row, "eleCalType") == "I") {
					// DB ITEM검색 팝업
					dbItemSearchPopup(Row, Col);
				} else if (sheet2.GetCellValue(Row, "eleCalType") == "F") {
					// 사용자정의함수검색 팝업
					payUdfMasterSearchPopup(Row, Col);
				}
			}
		}
	} catch(ex) {alert("OnPopupClick Event Error : " + ex);}
}

function sheet2_OnChange(Row, Col, Value) {
	 try {
		var colName = sheet2.ColSaveName(Col);

		if (Row <= 0) {
			return;
		}

		if (colName == "eleCalType") {
			// 항목구분 변경시
			sheet2.SetCellValue(Row, "calValue", "");
			sheet2.SetCellValue(Row, "calValueNm", "");

			// 괄호
			if (sheet2.GetCellValue(Row, "eleCalType") == "A") {
				sheet2.InitCellProperty(Row, "calValueNm", {Type: "Combo", Align: "Left", Edit:1});
				sheet2.CellComboItem(Row,"calValueNm", {"ComboCode":"(|)","ComboText":"(|)"});
				sheet2.SetCellValue(Row, "calValueNm",  sheet2.GetCellValue(Row, "calValue"));
			}
			// 사칙연산
			if (sheet2.GetCellValue(Row, "eleCalType") == "B") {
				sheet2.InitCellProperty(Row, "calValueNm", {Type: "Combo", Align: "Left", Edit:1});
				sheet2.CellComboItem(Row,"calValueNm", {"ComboCode":"+|-|*|/","ComboText":"+|-|*|/"});
				sheet2.SetCellValue(Row, "calValueNm",  sheet2.GetCellValue(Row, "calValue"));
			}
			// 상수
			if (sheet2.GetCellValue(Row, "eleCalType") == "C") {
				sheet2.InitCellProperty(Row, "calValueNm", {Type: "Text", Align: "Left", Edit:1});
				sheet2.SetCellValue(Row, "calValueNm",  sheet2.GetCellValue(Row, "calValue"));
			}
			// DB ITEM
			if (sheet2.GetCellValue(Row, "eleCalType") == "I") {
				sheet2.InitCellProperty(Row, "calValueNm", {Type: "Popup", Align: "Left", Edit:1});
			}
			// 사용자정의함수
			if (sheet2.GetCellValue(Row, "eleCalType") == "F") {
				sheet2.InitCellProperty(Row, "calValueNm", {Type: "Popup", Align: "Left", Edit:1});
			}
		} else if (colName == "calValueNm" || colName == "calSeq" || colName == "sDelete") {
			// 계산식값명 변경시
			if (sheet2.GetCellValue(Row, "eleCalType") != "I" && sheet2.GetCellValue(Row, "eleCalType") != "F") {
				// F.사용자함수와 I.DB ITEM은 팝업창에서 셋팅하도록 한다.
				sheet2.SetCellValue(Row, "calValue",  sheet2.GetCellValue(Row, "calValueNm"));
			}

			// 순서정렬
			sheet2.ColumnSort("calSeq", "ASC");

			//변경된 값에의한 계산식 반영
			var calcValue = "";
			var calType = "";
			var rowCnt = sheet2.RowCount();

			for (var i=1; i<=rowCnt; i++) {
				calType = "";
				// 삭제가 아닐경우
				if (sheet2.GetCellValue(i,"sDelete") == "0") {
					if (sheet2.GetCellValue(i, "eleCalType") == "I") {
						calType = "[I]";
					} else if (sheet2.GetCellValue(i, "eleCalType") == "F") {
						calType = "[F]";
					}
					calcValue = calcValue + calType + sheet2.GetCellText(i, "calValueNm");
				}
			}
			$("#calcValueTxt").html("계산식 : " + calcValue);
			sheet1.SetCellValue(sheet1.GetSelectRow(), "cRule", calcValue);
			if (sheet1.GetCellValue(sheet1.GetSelectRow(), "sStatus") === "U"
					|| sheet1.GetCellValue(sheet1.GetSelectRow(), "sStatus") === "I")
				sheet1.SetCellValue(sheet1.GetSelectRow(), "sStatus", "R");
		}

	 } catch(ex) {alert("OnChange Event Error : " + ex);}
}

// 항목검색 팝업(sheet1)
function elementSearchPopup(Row, Col) {
	let layerModal = new window.top.document.LayerModal({
		id : 'payElementLayer'
		, url : '/PayElementPopup.do?cmd=viewPayElementLayer&authPg=R'
		, parameters : {
			searchElementLinkType : 'C'
			, isSep : 'Y'
		}
		, width : 860
		, height : 520
		, title : '<tit:txt mid='payElementPop4' mdef='수당,공제 항목'/>'
		, trigger :[
			{
				name : 'payTrigger'
				, callback : function(result){
					sheet1.SetCellValue(Row, "elementCd", result.resultElementCd);
					sheet1.SetCellValue(Row, "elementNm", result.resultElementNm);
				}
			}
		]
	});
	layerModal.show();
}

// 조건검색 팝업(sheet1)
function pwrSrchMgrPopup(Row, Col) {
	let layerModal = new window.top.document.LayerModal({
		id : 'pwrSrchMgrLayer'
		, url : '/Popup.do?cmd=viewPwrSrchMgrLayer&authPg=R'
		, parameters : {
		}
		, width : 1100
		, height : 520
		, title : '조건 검색 관리'
		, trigger :[
			{
				name : 'pwrTrigger'
				, callback : function(result){
					sheet1.SetCellValue(Row, "searchSeq", result.searchSeq);
					sheet1.SetCellValue(Row, "searchDesc", result.searchDesc);
				}
			}
		]
	});
	layerModal.show();
}

// DB ITEM검색 팝업(sheet2)
function dbItemSearchPopup(Row, Col) {
	let layerModal = new window.top.document.LayerModal({
		id : 'sepLinkCalcLayer'
		, url : '/SepEleLinkCalcMgr.do?cmd=viewDbItemLayer&authPg=R'
		, parameters : {
		}
		, width : 700
		, height : 520
		, title : '<tit:txt mid='sepEleLinkCalcMgrDbItemPopup' mdef='DB ITEM'/>'
		, trigger :[
			{
				name : 'sepLinkCalcTrigger'
				, callback : function(result){
					sheet2.SetCellValue(Row, "calValue", result.dbItemCd);
					sheet2.SetCellValue(Row, "calValueNm", result.dbItemNm);
				}
			}
		]
	});
	layerModal.show();
}

// 사용자정의함수검색 팝업(sheet2)
function payUdfMasterSearchPopup(Row, Col) {
	let layerModal = new window.top.document.LayerModal({
		id : 'udfMasterLayer'
		, url : '/PayUdfMasterPopup.do?cmd=viewPayUdfMasterLayer&authPg=R'
		, parameters : {}
		, width : 860
		, height : 520
		, title : '<tit:txt mid='payUdfMasterPop' mdef='사용자정의 함수 조회'/>'
		, trigger :[
			{
				name : 'udfMasterTrigger'
				, callback : function(result){
					sheet2.SetCellValue(Row, "calValue", result.udfCd);
					sheet2.SetCellValue(Row, "calValueNm", result.description);
				}
			}
		]
	});
	layerModal.show();
}

function openResult() {
	$("#srchSeq").val(sheet1.GetCellValue(sheet1.GetSelectRow(), "searchSeq"));
	let layerModal = new window.top.document.LayerModal({
		id : 'pwrResultLayer'
		, url : '${ctx}/PwrSrchResultPopup.do?cmd=viewPwrSrchResultLayer&authPg=R'
		, parameters : {}
		, width : 940
		, height : 580
		, title : '검색결과 조회'
	});
	layerModal.show();
}
</script>
</head>
<body class="hidden">
<div class="wrapper">
<input type="hidden" id="srchSeq" name="srchSeq" value="" />
	<form id="sheet1Form" name="sheet1Form">
		<input type="hidden" id="elementCd" name="elementCd" value="" />
		<input type="hidden" id="searchSeq" name="searchSeq" value="" />
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='eleGroupMgr2' mdef='항목명'/></th>
						<td>
							<input type="text" id="elementNm" name="elementNm" class="text" value="" style="width:120px;ime-mode:active" />
						</td>
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
							<li class="txt"><tit:txt mid='112102' mdef='퇴직항목링크 '/> </li>
							<li class="btn">
								<btn:a href="javascript:openResult()"				css="basic authA" mid='110710' mdef="검색결과"/>
								<btn:a href="javascript:doAction1('Insert')"		css="basic authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction1('Copy')"			css="basic authA" mid='110696' mdef="복사"/>
								<btn:a href="javascript:doAction1('Save')"			css="basic authA" mid='110708' mdef="저장"/>
								<btn:a href="javascript:doAction1('Down2Excel')"	css="basic authR" mid='110698' mdef="다운로드"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "50%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<colgroup>
			<col width="" />
			<col width="7px" />
			<col width="300px" />
		</colgroup>
		<tr>
			<td class="top">
				<div class="outer">
					<div class="sheet_title">
						<ul>
							<li class="txt"><tit:txt mid='112451' mdef='계산식작성 '/></li>
							<li class="btn">
								<btn:a href="javascript:doAction2('Search')"		css="button" mid='110697' mdef="조회"/>
								<btn:a href="javascript:doAction2('Insert')"		css="basic authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction2('Copy')"			css="basic authA" mid='110696' mdef="복사"/>
								<btn:a href="javascript:doAction2('Save')"			css="basic authA" mid='110708' mdef="저장"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet2", "50%", "50%", "${ssnLocaleCd}"); </script>
			</td>
			<td></td>
			<td class="top">
				<div class="h35"></div>
				<table border="0" cellpadding="0" cellspacing="0" class="table">
				<colgroup>
					<col width="20%" />
					<col width="" />
				</colgroup>
				<tr>
					<th><tit:txt mid='112728' mdef='계산식'/></th>
					<td id="calcValueTxt"></td>
				</tr>
				</table>
				<div class="explain">
					<div class="title"><tit:txt mid='eleLinkCalcMgr' mdef='항목링크(계산식) 사용방법'/></div>
					<div class="txt">
						<ul>
							<li><tit:txt mid='112729' mdef='1. 계산식은 괄호, 항목, 사칙연산 을 모두 각각 등록.'/></li>
							<li><tit:txt mid='112386' mdef='2. 계산식에 사용할  항목코드는 공통지표  항목관리에 등록 되어 있어야 합니다.'/></li>
						</ul>
					</div>
				</div>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
