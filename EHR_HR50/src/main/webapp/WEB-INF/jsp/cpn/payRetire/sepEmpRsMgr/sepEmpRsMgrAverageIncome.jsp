<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>퇴직금기본내역 평균임금</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 퇴직금기본내역
 * @author JM
-->
<script type="text/javascript">
// 퇴직금기본내역 평균임금TAB 급여 항목리스트
var gPRow = "";
var pGubun = "";
var titleList;

$(function() {

	$("input[type='text']").keydown(function(event){
		if(event.keyCode == 27){
			return false;
		}
	});

	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22, FrozenCol:10};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0, Hidden:1};
	initdata1.Cols = [
		{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",			Sort:0 },
		{Header:"상태",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",			Sort:0 },
		{Header:"급여계산코드",		Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"payActionCd",		KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"급여년월",		Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"subPayYm",		KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"사번",			Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"계산시작일",		Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"calFymd",			KeyField:1,	CalcLogic:"",	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"계산종료일",		Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"calTymd",			KeyField:1,	CalcLogic:"",	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"일수",			Type:"Int",			Hidden:0,					Width:60,			Align:"Right",	ColMerge:0,	SaveName:"workDay",			KeyField:0,	CalcLogic:"",	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"총금액",			Type:"Int",			Hidden:0,					Width:80,			Align:"Right",	ColMerge:0,	SaveName:"mon",				KeyField:1,	CalcLogic:"",	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);

	var initdata2 = {};
	initdata2.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata2.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata2.Cols = [
		{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",			Sort:0 },
		{Header:"상태",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",			Sort:0 },
		{Header:"급여계산코드",		Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"payActionCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"순서",			Type:"Int",			Hidden:1,					Width:50,			Align:"Right",	ColMerge:0,	SaveName:"seq",				KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"사번",			Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"서브퇴직급여계산코드",	Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"subPayActionCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"급여일자",			Type:"Popup",		Hidden:0,					Width:110,			Align:"Left",	ColMerge:0,	SaveName:"subPayActionNm",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"지급일자",			Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"paymentYmd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
		{Header:"급여구분",			Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"payCd",			KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
		{Header:"금액",			Type:"AutoSum",		Hidden:0,					Width:80,			Align:"Right",	ColMerge:0,	SaveName:"mon",				KeyField:1,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"연차보상갯수",		Type:"Int",			Hidden:1,					Width:50,			Align:"Right",	ColMerge:0,	SaveName:"alrYCnt",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"월차보상갯수",		Type:"Int",			Hidden:1,					Width:50,			Align:"Right",	ColMerge:0,	SaveName:"alrMCnt",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
	]; IBS_InitSheet(sheet2, initdata2); sheet2.SetCountPosition(0);

	var initdata3 = {};
	initdata3.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata3.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata3.Cols = [
		{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",			Sort:0 },
		{Header:"상태",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",			Sort:0 },
		{Header:"급여계산코드",		Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"payActionCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"사번",			Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"순서",			Type:"Int",			Hidden:1,					Width:50,			Align:"Right",	ColMerge:0,	SaveName:"seq",				KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"서브퇴직급여계산코드",	Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"subPayActionCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"급여일자",			Type:"Popup",		Hidden:0,					Width:110,			Align:"Left",	ColMerge:0,	SaveName:"subPayActionNm",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"지급일자",			Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"incomeAnnualPaymentYmd",	KeyField:0,	Format:"Ymd",PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
		{Header:"급여구분",			Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"payCd",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
		{Header:"항목코드",			Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"elementCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"금액",			Type:"Int",			Hidden:0,					Width:80,			Align:"Right",	ColMerge:0,	SaveName:"mon",				KeyField:1,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"보상일수",			Type:"Int",			Hidden:1,					Width:50,			Align:"Right",	ColMerge:0,	SaveName:"alrYCnt",			KeyField:1,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
	]; IBS_InitSheet(sheet3, initdata3); sheet3.SetCountPosition(0);

	//------------------------------------- 그리드 콤보 -------------------------------------//
	// 급여구분코드(TCPN051)
	var tcpn051Cd = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getCpnPayCdList", false).codeList, "");
	sheet2.SetColProperty("payCd", {ComboText:"|"+tcpn051Cd[0], ComboCode:"|"+tcpn051Cd[1]});
	sheet3.SetColProperty("payCd", {ComboText:"|"+tcpn051Cd[0], ComboCode:"|"+tcpn051Cd[1]});

	//$(window).smartresize(sheetResize);
	sheetInit();

/* 	if (parent.$("#tdSabun").val() != null && parent.$("#tdSabun").val() != "" &&
		parent.$("#payActionCd").val() != null && parent.$("#payActionCd").val() != "") {
		$("#sabun").val(parent.$("#tdSabun").val());
		$("#payActionCd").val(parent.$("#payActionCd").val());
		doAction1("Search");
		doAction2("Search");
		doAction3("Search");
	} */

	setEmpPage();

});

function chkInVal() {
/* 	if(parent.$("#tdSabun").val() == "") {
		alert("대상자를 선택하십시오.");
		parent.$("#tdSabun").focus();
		return false;
	}
	if(parent.$("#payActionCd").val() == "") {
		alert("퇴직일자를 선택하십시오.");
		parent.$("#payActionCd").focus();
		return false;
	} */
	if($("#sabun").val() == "") {
		alert("대상자를 선택하십시오.");
		return false;
	}
	if($("#payActionCd").val() == "") {
		alert("퇴직일자를 선택하십시오.");
		return false;
	}
	return true;
}

function doAction1(sAction) {
	switch (sAction) {
		case "Search":
			// 필수값/유효성 체크
 			if (!chkInVal()) {
				break;
			}

			//$("#sabun").val(parent.$("#tdSabun").val());
			//$("#payActionCd").val(parent.$("#payActionCd").val());

			// 항목리스트 조회
			searchTitleList();

			sheet1.DoSearch("${ctx}/SepEmpRsMgr.do?cmd=getSepEmpRsMgrAverageIncomePayList", $("#sheet1Form").serialize());
			break;

		case "Save":
			// 중복체크
			if(!dupChk(sheet1, "payActionCd|sabun|calFymd", false, true)) {break;}

			var rowCnt = sheet1.RowCount();
			for (var i=1; i<=rowCnt; i++) {
				if (sheet1.GetCellValue(i, "mon") == "0") {
					alert("총금액이 '0'인 자료가 있습니다. 해당금액을 입력하여주십시요.");
					sheet1.SelectCell(i, "mon");
					return;
				}
			}

			// 항목별 금액 저장을 위한 셋
			setElementInfo();
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave("${ctx}/SepEmpRsMgr.do?cmd=saveSepEmpRsMgrAverageIncomePay", $("#sheet1Form").serialize());
			break;

		case "Insert":
			// 필수값/유효성 체크
			if (!chkInVal()) {
				break;
			}

			//$("#sabun").val(parent.$("#tdSabun").val());
			//$("#payActionCd").val(parent.$("#payActionCd").val());

			var Row = sheet1.DataInsert(0);
			sheet1.SetCellValue(Row, "payActionCd", parent.$("#payActionCd").val());
			sheet1.SetCellValue(Row, "sabun", parent.$("#tdSabun").val());
			sheet1.SelectCell(Row, 2);
			break;

		case "Copy":
			var Row = sheet1.DataCopy();
			sheet1.SelectCell(Row, 2);
			break;

		case "Clear":
			sheet1.RemoveAll();
			doAction2("Clear");
			doAction3("Clear");
			break;

		case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
			break;
		case "LoadExcel":
			if (!chkInVal()) {
				break;
			}
			// 업로드
			//var params = {ColumnMapping:'||||||1|2|||3|4|5|6|7|8|9|10|11|12'};
			var params = {Mode:"HeaderMatch"};
			sheet1.LoadExcel(params);
			break;
		case "DownTemplate":
			if (!chkInVal()) {
				break;
			}
			var size = titleList.DATA.length + 10;
			var dString = "6|7|";
			for(var i=10; i<size; i++ ){
				dString += i+"|";
			}
			// 양식다운로드
			var downcol = makeHiddenSkipCol(sheet1);
			//sheet1.Down2Excel({SheetDesign:0, Merge:1,DownRows:"0", DownCols:"6|7|10|11|12|13|14|15|16|17|18|19"});
			sheet1.Down2Excel({SheetDesign:0, Merge:1,DownRows:"0", DownCols:dString});
			break;
	}
}

function sheet1_OnLoadExcel() {
	var rowCnt = sheet1.RowCount();
	for (var i=1; i<=rowCnt; i++) {
		sheet1.SetCellValue(i, "sabun",parent.$("#tdSabun").val());
		sheet1.SetCellValue(i, "payActionCd",parent.$("#payActionCd").val());
		sheet1.SetCellValue(i, "workDay", getDaysBetween(sheet1.GetCellValue(i, "calFymd"), sheet1.GetCellValue(i, "calTymd")));
	}
}


function doAction2(sAction) {
	switch (sAction) {
		case "Search":
			// 필수값/유효성 체크
 			if (!chkInVal()) {
				break;
			}

			//$("#sabun").val(parent.$("#tdSabun").val());
			//$("#payActionCd").val(parent.$("#payActionCd").val());

			// 상여 조회
			sheet2.DoSearch("${ctx}/SepEmpRsMgr.do?cmd=getSepEmpRsMgrAverageIncomeBonusList", $("#sheet1Form").serialize());
			break;

		case "Save":
			IBS_SaveName(document.sheet1Form,sheet2);
			sheet2.DoSave("${ctx}/SepEmpRsMgr.do?cmd=saveSepEmpRsMgrAverageIncomeBonus", $("#sheet1Form").serialize());
			break;

		case "Insert":
			// 필수값/유효성 체크
			if (!chkInVal()) {
				break;
			}

			//$("#sabun").val(parent.$("#tdSabun").val());
			//$("#payActionCd").val(parent.$("#payActionCd").val());
			var Row = sheet2.DataInsert(0);
			sheet2.SetCellValue(Row, "payActionCd", parent.$("#payActionCd").val());
			sheet2.SetCellValue(Row, "sabun", parent.$("#tdSabun").val());
			sheet2.SelectCell(Row, 2);
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
			var param  = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet2.Down2Excel(param);
			break;

		case "LoadExcel":
			if (!chkInVal()) {
				break;
			}
			// 업로드
			var params = {ColumnMapping:'||||||||1|2|3'};
			sheet2.LoadExcel(params);
			break;
		case "DownTemplate":
			if (!chkInVal()) {
				break;
			}
			// 양식다운로드
			var downcol = makeHiddenSkipCol(sheet2);
			sheet2.Down2Excel({SheetDesign:0, Merge:1,DownRows:"0", DownCols:"8|9|10"});
			break;
	}
}

function sheet2_OnLoadExcel() {
	var rowCnt = sheet2.RowCount();
	for (var i=1; i<=rowCnt; i++) {
		sheet2.SetCellValue(i, "sabun",parent.$("#tdSabun").val());
		sheet2.SetCellValue(i, "payActionCd",parent.$("#payActionCd").val());
	}
}

function doAction3(sAction) {
	switch (sAction) {
		case "Search":
			// 필수값/유효성 체크
/* 			if (!chkInVal()) {
				break;
			} */

			//$("#sabun").val(parent.$("#tdSabun").val());
			//$("#payActionCd").val(parent.$("#payActionCd").val());

			doAction3("Clear");

			// 연차 조회
			sheet3.DoSearch("${ctx}/SepEmpRsMgr.do?cmd=getSepEmpRsMgrAverageIncomeAnnualList", $("#sheet1Form").serialize());

			// 퇴직금계산내역 조회
			var severancePayInfo = ajaxCall("${ctx}/SepEmpRsMgr.do?cmd=getSepEmpRsMgrSeverancePayMap", $("#sheet1Form").serialize(), false);

			if (severancePayInfo.Map != null) {
				severancePayInfo = severancePayInfo.Map;
				$("#tdA001070Mon").html(severancePayInfo.a001070Mon);
				$("#tdA001090Mon").html(severancePayInfo.a001090Mon);
				$("#tdA001110Mon").html(severancePayInfo.a001110Mon);
				$("#tdA001130Mon").html(severancePayInfo.a001130Mon);
				$("#tdB001210Mon").html(severancePayInfo.b001210Mon);
				$("#tdB001090Mon").html(severancePayInfo.b001090Mon);
				$("#tdB001150Mon").html(severancePayInfo.b001150Mon);
				$("#tdC001010Mon").html(severancePayInfo.c001010Mon);
				$("#tdB001170Mon").html(severancePayInfo.b001170Mon);
				$("#tdB001230Mon").html(severancePayInfo.b001230Mon);
				$("#tdB001270Mon").html(severancePayInfo.b001270Mon);
			}
			break;

		case "Save":
			IBS_SaveName(document.sheet1Form,sheet3);
			sheet3.DoSave("${ctx}/SepEmpRsMgr.do?cmd=saveSepEmpRsMgrAverageIncomeAnnual", $("#sheet1Form").serialize());
			break;

		case "Insert":
			// 필수값/유효성 체크
			if (!chkInVal()) {
				break;
			}

			//$("#sabun").val(parent.$("#tdSabun").val());
			//$("#payActionCd").val(parent.$("#payActionCd").val());
			var Row = sheet3.DataInsert(0);
			sheet3.SetCellValue(Row, "payActionCd", parent.$("#payActionCd").val());
			sheet3.SetCellValue(Row, "sabun", parent.$("#tdSabun").val());
			sheet3.SelectCell(Row, 2);
			break;

		case "Copy":
			var Row = sheet3.DataCopy();
			sheet3.SetCellValue(Row, "seq", "");
			sheet3.SelectCell(Row, 2);
			break;

		case "Clear":
			sheet3.RemoveAll();
			$("#tdA001070Mon").html("");
			$("#tdA001090Mon").html("");
			$("#tdA001110Mon").html("");
			$("#tdA001130Mon").html("");
			$("#tdB001210Mon").html("");
			$("#tdB001090Mon").html("");
			$("#tdB001150Mon").html("");
			$("#tdC001010Mon").html("");
			$("#tdB001170Mon").html("");
			$("#tdB001230Mon").html("");
			$("#tdB001270Mon").html("");
			break;

		case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet3);
			var param  = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet3.Down2Excel(param);
			break;
	}
}

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") {
			alert(Msg);
		}
		//sheetResize();
	} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

//조회 후 에러 메시지
function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") {
			alert(Msg);
		}
		//sheetResize();
	} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

//조회 후 에러 메시지
function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") {
			alert(Msg);
		}
		//sheetResize();
	} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

//저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } doAction1("Search");} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}

//저장 후 메시지
function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } doAction2("Search");} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}

//저장 후 메시지
function sheet3_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } doAction3("Search");} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}

function sheet2_OnPopupClick(Row, Col) {
	try{
		var colName = sheet2.ColSaveName(Col);
		if(colName == "subPayActionNm") {
			// 급여일자검색 팝업
			openPayDayPopup(Row, Col, "sheet2");
		}
	}catch(ex) {alert("OnPopupClick Event Error : " + ex);}
}

function sheet3_OnPopupClick(Row, Col) {
	try{
		var colName = sheet3.ColSaveName(Col);
		if(colName == "subPayActionNm") {
			// 급여일자검색 팝업
			openPayDayPopup(Row, Col, "sheet3");
		}
	}catch(ex) {alert("OnPopupClick Event Error : " + ex);}
}

function sheet1_OnChange(Row, Col, Value) {
	try{
		var colName = sheet1.ColSaveName(Col);
		if (Row > 0) {
			// 시작일자 종료일자 체크
			if(colName == "calFymd" || colName == "calTymd") {
				checkNMDate(sheet1, Row, Col, "평균임금 계산시작일/종료일의", "calFymd", "calTymd");

				if (sheet1.GetCellValue(Row, "calFymd") != "" && sheet1.GetCellValue(Row, "calTymd") != "") {
					sheet1.SetCellValue(Row, "workDay", getDaysBetween(sheet1.GetCellValue(sheet1.GetSelectRow(), "calFymd"), sheet1.GetCellValue(sheet1.GetSelectRow(), "calTymd")));
				}
			}
		}
	}catch(ex) {alert("OnChange Event Error : " + ex);}
}

function getReturnValue(returnValue) {
	var rv = $.parseJSON('{' + returnValue+ '}');

	var payActionCd		= $("#payActionCd").val();
	var subPayActionCd	= rv["payActionCd"];
	var subPayActionNm	= rv["payActionNm"];
	var payCd			= rv["payCd"];
	var paymentYmd		= rv["paymentYmd"];

    if(pGubun == "payDayPopup2"){
		sheet2.SetCellValue(gPRow, "payActionCd", payActionCd);
		sheet2.SetCellValue(gPRow, "subPayActionCd", subPayActionCd);
		sheet2.SetCellValue(gPRow, "subPayActionNm", subPayActionNm);
		sheet2.SetCellValue(gPRow, "payCd", payCd);
		sheet2.SetCellValue(gPRow, "paymentYmd", paymentYmd);
    }else if(pGubun == "payDayPopup3"){
		sheet3.SetCellValue(gPRow, "payActionCd", payActionCd);
		sheet3.SetCellValue(gPRow, "subPayActionCd", subPayActionCd);
		sheet3.SetCellValue(gPRow, "subPayActionNm", subPayActionNm);
		sheet3.SetCellValue(gPRow, "payCd", payCd);
		sheet3.SetCellValue(gPRow, "incomeAnnualPaymentYmd", paymentYmd);
    }
}

//급여일자 조회 팝업
function openPayDayPopup(Row, Col, sheetNm){
	let parameters = {
		runType : '00001,00002,00003'
	};
	
	let layerModal = new window.top.document.LayerModal({
		id : 'payDayLayer'
		, url : '/PayDayPopup.do?cmd=viewPayDayLayer&authPg=${authPg}'
		, parameters : parameters
		, width : 840
		, height : 520
		, title : '<tit:txt mid='payDayPop' mdef='급여일자 조회'/>'
		, trigger :[
			{
				name : 'payDayTrigger'
				, callback : function(result){
					
					var payActionCd		= $("#payActionCd").val();
					var subPayActionCd	= result.payActionCd;
					var subPayActionNm	= result.payActionNm;
					var payCd			= result.payCd;
					var paymentYmd		= result.paymentYmd;
					if(sheetNm=="sheet2"){
						sheet2.SetCellValue(Row, "payActionCd", payActionCd);
						sheet2.SetCellValue(Row, "subPayActionCd", subPayActionCd);
						sheet2.SetCellValue(Row, "subPayActionNm", subPayActionNm);
						sheet2.SetCellValue(Row, "payCd", payCd);
						sheet2.SetCellValue(Row, "paymentYmd", paymentYmd);	
					} else if(sheetNm=="sheet3"){
						sheet3.SetCellValue(Row, "payActionCd", payActionCd);
						sheet3.SetCellValue(Row, "subPayActionCd", subPayActionCd);
						sheet3.SetCellValue(Row, "subPayActionNm", subPayActionNm);
						sheet3.SetCellValue(Row, "payCd", payCd);
						sheet3.SetCellValue(Row, "incomeAnnualPaymentYmd", paymentYmd);
	                }
					
				}
			}
		]
	});
	layerModal.show();
}

function searchTitleList() {
	// 퇴직금기본내역 평균임금TAB 급여 항목리스트 조회
	titleList = ajaxCall("${ctx}/SepEmpRsMgr.do?cmd=getSepEmpRsMgrAverageIncomePayTitleList", $("#sheet1Form").serialize(), false);

	if(titleList != null && titleList.DATA != null) {

		// IBSheet에 설정된 모든 기본 속성을 제거하고 초기상태로 변경한다.
		sheet1.Reset();

		// 총금액 자동합계
		var calcLogic = "";
		for(var i=0; i<titleList.DATA.length; i++){
			if (titleList.DATA[i].elementCd != null && titleList.DATA[i].elementCd != "") {
				var elementCd = convCamel(titleList.DATA[i].elementCd);
				if (i==0) {
					calcLogic = "|" + elementCd + "|";
				} else {
					calcLogic = calcLogic + "+|" + elementCd + "|";
				}
			}
		}

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, Page:22, FrozenCol:10};
		initdata.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};

		initdata.Cols = [];
		initdata.Cols[0] = {Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" };
		initdata.Cols[1] = {Header:"삭제",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",			Sort:0 };
		initdata.Cols[2] = {Header:"상태",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",			Sort:0 };
		initdata.Cols[3] = {Header:"급여계산코드",		Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"payActionCd",		KeyField:0,	CalcLogic:"",		Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 };
		initdata.Cols[4] = {Header:"급여년월",			Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"subPayYm",		KeyField:0,	CalcLogic:"",		Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 };
		initdata.Cols[5] = {Header:"사번",			Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	CalcLogic:"",		Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 };
		initdata.Cols[6] = {Header:"계산시작일",		Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"calFymd",			KeyField:1,	CalcLogic:"",		Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 };
		initdata.Cols[7] = {Header:"계산종료일",		Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"calTymd",			KeyField:1,	CalcLogic:"",		Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 };
		initdata.Cols[8] = {Header:"일수",			Type:"AutoSum",			Hidden:0,					Width:60,			Align:"Right",	ColMerge:0,	SaveName:"workDay",			KeyField:0,	CalcLogic:"",		Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 };
		initdata.Cols[9] = {Header:"총금액",			Type:"AutoSum",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon",				KeyField:1,	CalcLogic:calcLogic,Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };

		var elementCd = "";
		for(var i=0; i<titleList.DATA.length; i++){
			elementCd = under2camel(titleList.DATA[i].elementCd);
			initdata.Cols[i+10] = {Header:titleList.DATA[i].elementNm,	Type:"AutoSum",	Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:elementCd,	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 };
		}

		initdata.Cols[titleList.DATA.length+10]	= {Header:"detailElementCd",Type:"Text",	Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"detailElementCd",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10000 };
		initdata.Cols[titleList.DATA.length+10+1]= {Header:"detailMon",		Type:"Text",	Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"detailMon",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10000 };

		IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(0);


		var selectRow = parent.sheetLeft.GetSelectRow();

		if ( selectRow > 0 ){
			var closeYn = parent.sheetLeft.GetCellValue(selectRow, "closeYn");
			if ( closeYn == "Y" ){
				sheet1.SetEditable(0);
			}else{
				sheet1.SetEditable(1);
			}
		}

	}
}

//항목별 금액 저장을 위한 셋
function setElementInfo() {

	var detailElementCd = "";
	var detailMon = "";

	// 퇴직금기본내역 평균임금TAB 급여 항목리스트
	if(titleList != null && titleList.DATA != null) {
		for(var i=0; i<titleList.DATA.length; i++){
			if (titleList.DATA[i].elementCd != null && titleList.DATA[i].elementCd != "") {
				if (i==0) {
					detailElementCd = titleList.DATA[i].elementCd;
				} else {
					detailElementCd = detailElementCd + "," + titleList.DATA[i].elementCd;
				}
			}
		}

		var rowCnt = sheet1.RowCount();

		for (var Row=1; Row<=rowCnt; Row++) {
			sheet1.SetCellValue(Row, "detailElementCd", detailElementCd);

			detailMon = "";
			for(var i=0; i<titleList.DATA.length; i++){
				if (titleList.DATA[i].elementCd != null && titleList.DATA[i].elementCd != "") {
					var elementCd = convCamel(titleList.DATA[i].elementCd);
					if (i==0) {
						detailMon = sheet1.GetCellValue(Row, elementCd);
					} else {
						detailMon = detailMon + "," + sheet1.GetCellValue(Row, elementCd);
					}
				}
			}

			sheet1.SetCellValue(Row, "detailMon", detailMon);
		}
	}
}

/* function setEmpPage() {
	if (parent.$("#tdSabun").val() != null && parent.$("#tdSabun").val() != "" && parent.$("#payActionCd").val() != null && parent.$("#payActionCd").val() != "") {
		doAction1("Search");
		doAction2("Search");
		doAction3("Search");
	}
} */

function setEmpPage() {

	var selectRow = parent.sheetLeft.GetSelectRow();

	if ( selectRow > 0 ){
		var tdSabun = parent.sheetLeft.GetCellValue(selectRow, "sabun");
		var payActionCd = parent.sheetLeft.GetCellValue(selectRow, "payActionCd");
		var closeYn = parent.sheetLeft.GetCellValue(selectRow, "closeYn");

		$("#sabun").val(tdSabun);
		$("#payActionCd").val(payActionCd);

		if ( closeYn == "Y" ){
			$(".closeBtn").hide();
			sheet1.SetEditable(0);
			sheet2.SetEditable(0);
			sheet3.SetEditable(0);
		}else{
			$(".closeBtn").show();
			sheet1.SetEditable(1);
			sheet2.SetEditable(1);
			sheet3.SetEditable(1);
		}

		doAction1("Search");
		doAction2("Search");
		doAction3("Search");
	}else{
		$(".closeBtn").hide();
		sheet1.SetEditable(0);
		sheet2.SetEditable(0);
		sheet3.SetEditable(0);
	}
}


</script>
</head>
<body class="hidden">
<div class="wrapper" id="tableDiv" style="overflow:auto;overflow-x:hidden;border:0px;margin-bottom:0px">
	<form id="sheet1Form" name="sheet1Form" >
	<input type="hidden" id="sabun" name="sabun" value="" />
	<input type="hidden" id="payActionCd" name="payActionCd" value="" />
	</form>


	<div class="sheet_title">
		<ul>
			<li id="txt" class="txt">급여</li>
			<li class="btn">
				<!-- <a href="javascript:doAction1('DownTemplate')"		class="basic authA closeBtn">양식다운로드</a>
				<a href="javascript:doAction1('LoadExcel')"		class="basic authA closeBtn">업로드</a> -->
				<a href="javascript:doAction1('Search')"		class="button authR">조회</a>
				<a href="javascript:doAction1('Insert')"		class="basic authA closeBtn">입력</a>
				<a href="javascript:doAction1('Copy')"			class="basic authA closeBtn">복사</a>
				<a href="javascript:doAction1('Save')"			class="basic authA closeBtn">저장</a>
				<a href="javascript:doAction1('Down2Excel')"	class="basic authR">다운로드</a>
			</li>
		</ul>
	</div>
	<script type="text/javascript">createIBSheet("sheet1", "100%", "30%", "kr"); </script>

	<div class="sheet_title">
		<ul>
			<li id="txt" class="txt">상여</li>
			<li class="btn">
				<!-- <a href="javascript:doAction2('DownTemplate')"		class="basic authA closeBtn">양식다운로드</a>
				<a href="javascript:doAction2('LoadExcel')"		class="basic authA closeBtn">업로드</a> -->
				<a href="javascript:doAction2('Search')"		class="button authR">조회</a>
				<a href="javascript:doAction2('Insert')"		class="basic authA closeBtn">입력</a>
				<a href="javascript:doAction2('Copy')"			class="basic authA closeBtn">복사</a>
				<a href="javascript:doAction2('Save')"			class="basic authA closeBtn">저장</a>
				<a href="javascript:doAction2('Down2Excel')"	class="basic authR">다운로드</a>
			</li>
		</ul>
	</div>
	<script type="text/javascript">createIBSheet("sheet2", "100%", "30%", "kr"); </script>

	<div class="sheet_title">
		<ul>
			<li id="txt" class="txt">연차</li>
			<li class="btn">
				<a href="javascript:doAction3('Search')"		class="button authR">조회</a>
				<a href="javascript:doAction3('Insert')"		class="basic authA closeBtn">입력</a>
				<a href="javascript:doAction3('Copy')"			class="basic authA closeBtn">복사</a>
				<a href="javascript:doAction3('Save')"			class="basic authA closeBtn">저장</a>
				<a href="javascript:doAction3('Down2Excel')"	class="basic authR">다운로드</a>
			</li>
		</ul>
	</div>
	<script type="text/javascript">createIBSheet("sheet3", "100%", "80px", "kr"); </script>

	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td class="top">
				<div>
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">퇴직금 계산내역</li>
						</ul>
					</div>
				</div>
				<table border="0" cellpadding="0" cellspacing="0" class="default">
				<colgroup>
					<col width="25%" />
					<col width="25%" />
					<col width="25%" />
					<col width="25%" />
				</colgroup>
				<tr>
					<th class="center">근속년수</th>
					<td class="right" id="tdA001070Mon" name="tdA001070Mon"></td>
					<th class="center">3개월 연차</th>
					<td class="right" id="tdB001230Mon" name="tdB001230Mon"></td>
				</tr>
				<tr>
					<th class="center">근속월수</th>
					<td class="right" id="tdA001090Mon" name=tdA001090Mon></td>
					<th class="center">평균임금</th>
					<td class="right" id="tdB001270Mon" name="tdB001270Mon"></td>
				</tr>
				<tr>
					<th class="center">근속일수</th>
					<td class="right" id="tdA001110Mon" name="tdA001110Mon"></td>
					<th class="center">1일평균임금</th>
					<td class="right" id="td" name="td"></td>
				</tr>
				<tr>
					<th class="center">근속지급율</th>
					<td class="right" id="tdA001130Mon" name="tdA001130Mon"></td>
					<th class="center">산정일수/월수</th>
					<td class="right" id="td" name="td"></td>
				</tr>
				<tr>
					<th class="center">3개월 급여</th>
					<td class="right" id="tdB001090Mon" name="tdB001090Mon"></td>
					<th class="center">퇴직금</th>
					<td class="right" id="tdC001010Mon" name="tdC001010Mon"></td>
				</tr>
				<tr>
					<th class="center">3개월 상여</th>
					<td class="right" id="tdB001170Mon" name="tdB001170Mon"></td>
					<th class="center"></th>
					<td class="right" id="td" name="td"></td>
				</tr>
				</table>
			</td>
		</tr>
	</table>
</div>
</body>
</html>