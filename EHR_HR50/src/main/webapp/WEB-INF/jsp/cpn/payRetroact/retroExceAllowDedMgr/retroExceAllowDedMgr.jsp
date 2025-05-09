<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='112770' mdef='소급예외수당관리'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 소급예외수당관리
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
		{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",			Sort:0},
		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",			Sort:0},
		{Header:"<sht:txt mid='payActionCdV5' mdef='급여일자코드'/>",		Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"payActionCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='rtrPayActionCd' mdef='소급대상급여계산코드'/>",	Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"rtrPayActionCd",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='payActionNmV3' mdef='소급일자'/>",			Type:"Text",		Hidden:0,					Width:120,			Align:"Center",	ColMerge:0,	SaveName:"payActionNm",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='rtrPayActionNm' mdef='소급대상급여일자'/>",	Type:"Text",		Hidden:0,					Width:120,			Align:"Center",	ColMerge:0,	SaveName:"rtrPayActionNm",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='payCd' mdef='급여구분'/>",			Type:"Text",		Hidden:0,					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"payNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='benefitElemCd' mdef='항목코드'/>",			Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"elementCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='benefitElemNm' mdef='항목명'/>",			Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"elementNm",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 }
	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);

	IBS_setChunkedOnSave("sheet1", {chunkSize : 25});
	
	var initdata2 = {};
	initdata2.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata2.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata2.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",			Sort:0},
		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",			Sort:0},
		{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",			Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",			Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",			Type:"Text",		Hidden:Number("${aliasHdn}"),					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"alias",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",			Type:"Text",		Hidden:Number("${jgHdn}"),					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",			Type:"Text",		Hidden:Number("${jwHdn}"),					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='payActionCdV5' mdef='급여일자코드'/>",		Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"payActionCd",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='rtrPayActionCd' mdef='소급대상급여계산코드'/>",	Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"rtrPayActionCd",	KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='benefitElemCd' mdef='항목코드'/>",			Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"elementCd",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='bizCdV2' mdef='구분'/>",			Type:"Combo",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"gubun",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2 },
		{Header:"<sht:txt mid='basicMon' mdef='금액'/>",			Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon",				KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",			Type:"Text",		Hidden:0,					Width:100,			Align:"Left",	ColMerge:0,	SaveName:"note",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
	]; IBS_InitSheet(sheet2, initdata2); sheet2.SetCountPosition(0);

	// 구분(0:차액, 1:재계산금액)
	sheet2.SetColProperty("gubun", {ComboText:"차액|재계산금액", ComboCode:"0|1"});

	$(window).smartresize(sheetResize);
	sheetInit();
	
	IBS_setChunkedOnSave("sheet2", {chunkSize : 25});

	$("#sabunName").bind("keyup",function(event) {
		if (event.keyCode == 13) {
			doAction1("Search");
		}
	});

	// 성명 입력시 자동완성 처리
	$(sheet2).sheetAutocomplete({
		Columns: [
			{
				ColSaveName  : "name",
				CallbackFunc : function(returnValue){
					var rv = $.parseJSON('{' + returnValue+ '}');
					sheet2.SetCellValue(gPRow, "name", rv["name"]);
					sheet2.SetCellValue(gPRow, "sabun", rv["sabun"]);
					sheet2.SetCellValue(gPRow, "jikgubNm", rv["jikgubNm"]);
				}
			}
		]
	});

	// 최근급여일자 조회
	getCpnLatestPaymentInfo();
});

// 필수값/유효성 체크
function chkInVal(sAction) {
	if ($("#payActionCd").val() == "") {
		alert("<msg:txt mid='alertRetroExceAllowDedMgr7' mdef='소급일자를 선택하십시오.'/>");
		$("#payActionNm").focus();
		return false;
	}

	if (sAction == "Insert" || sAction == "PrcP_CPN_PAY_RETROACT_MAKE_ITEM") {
		if ($("#rtrPayActionCd").val() == "") {
			alert("<msg:txt mid='alertRetroExceAllowDedMgr1' mdef='대상일자를 선택하십시오.'/>");
			$("#rtrPayActionNm").focus();
			return false;
		}
	}

	if (sAction == "Insert") {
		if ($("#elementCd").val() == "") {
			alert("<msg:txt mid='alertRetroExceAllowDedMgr2' mdef='항목명을 선택하십시오.'/>");
			$("#elementNm").focus();
			return false;
		}
	} else if (sAction == "LoadExcel") {
		if ($("#payActionCd").val() == "" || $("#rtrPayActionCd").val() == "" || $("#elementCd").val() == "") {
			alert("<msg:txt mid='109702' mdef='엑셀 자료를 로드할  개인별 예외 Master정보가 유효하지 않습니다.'/>");
			return false;
		}
	}

	return true;
}

// 마감여부 확인
function chkClose() {
	if ($("#closeYn").val() == "Y") {
		alert("<msg:txt mid='alertPayCalcCre1' mdef='이미 마감되었습니다.'/>");
		return false;
	}

	return true;
}

function doAction1(sAction) {
	switch (sAction) {
		case "Search":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			doAction1("Clear");
			doAction2("Clear");
			$("#closeYn").val("");

			sheet1.DoSearch("${ctx}/RetroExceAllowDedMgr.do?cmd=getRetroExceAllowDedMgrList", $("#sheet1Form").serialize());


			var procNm = "마감여부";
			var payActionCd = $("#payActionCd").val();

			// 마감여부 조회
			var closeYnInfo = ajaxCall("${ctx}/RetroExceAllowDedMgr.do?cmd=getCpnQueryList", "queryId=getCpnCloseYnMap&procNm="+procNm+"&payActionCd="+payActionCd, false);

			if (closeYnInfo.DATA != null && closeYnInfo.DATA != "" && typeof closeYnInfo.DATA[0] != "undefined") {
				$("#closeYn").val(closeYnInfo.DATA[0].closeYn);
			} else if (closeYnInfo.Message != null && closeYnInfo.Message != "") {
				alert(closeYnInfo.Message);
			}
			break;

		case "Save":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			// 중복체크
			if (!dupChk(sheet1, "payActionCd|rtrPayActionCd|elementCd", false, true)) {break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave("${ctx}/RetroExceAllowDedMgr.do?cmd=saveRetroExceAllowDedMgr", $("#sheet1Form").serialize());
			break;

		case "Insert":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}
			// 마감여부 확인
			if (!chkClose()) {
				break;
			}

			var Row = sheet1.DataInsert(0);
			sheet1.SetCellValue(Row, "payActionCd", $("#payActionCd").val());
			sheet1.SetCellValue(Row, "payActionNm", $("#payActionNm").val());
			sheet1.SetCellValue(Row, "rtrPayActionCd", $("#rtrPayActionCd").val());
			sheet1.SetCellValue(Row, "rtrPayActionNm", $("#rtrPayActionNm").val());
			sheet1.SetCellValue(Row, "payNm", $("#payNm").val());
			sheet1.SetCellValue(Row, "elementCd", $("#elementCd").val());
			sheet1.SetCellValue(Row, "elementNm", $("#elementNm").val());
			sheet1.SelectCell(Row, 2);
			break;

		case "Copy":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			sheet1.SelectCell(sheet1.DataCopy(), 2);
			break;

		case "PrcP_CPN_PAY_RETROACT_MAKE_ITEM":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}
			// 마감여부 확인
			if (!chkClose()) {
				break;
			}

			if (confirm("항목을 생성 하시겠습니까?")) {

				var payActionCd = $("#payActionCd").val();
				var rtrPayActionCd = $("#rtrPayActionCd").val();
				var elementCd = $("#elementCd").val();
				// 항목생성
				var result = ajaxCall("${ctx}/RetroExceAllowDedMgr.do?cmd=prcP_CPN_PAY_RETROACT_MAKE_ITEM", "payActionCd="+payActionCd+"&rtrPayActionCd="+rtrPayActionCd+"&elementCd="+elementCd, false);

				if (result != null && result["Result"] != null && result["Result"]["Code"] != null) {
					if (result["Result"]["Code"] == "0") {
						alert("<msg:txt mid='109860' mdef='항목생성 되었습니다.'/>");
						// 프로시저 호출 후 재조회
						doAction1("Search");
					} else if (result["Result"]["Message"] != null && result["Result"]["Message"] != "") {
						alert(result["Result"]["Message"]);
					}
				} else {
					alert("<msg:txt mid='110299' mdef='항목생성 오류입니다.'/>");
				}

			}
			break;

		case "Clear":
			sheet1.RemoveAll();
			break;

		case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
			break;
	}
}

function doAction2(sAction) {
	switch (sAction) {
		case "Search":
			$("#rtrPayActionCd").val("");

			var Row = sheet1.GetSelectRow();
			if (Row > 0) {
				if (sheet1.GetCellValue(Row,"payActionCd") != null && sheet1.GetCellValue(Row,"payActionCd") != "" &&
					sheet1.GetCellValue(Row,"rtrPayActionCd") != null && sheet1.GetCellValue(Row,"rtrPayActionCd") != "" &&
					sheet1.GetCellValue(Row,"elementCd") != null && sheet1.GetCellValue(Row,"elementCd") != "") {
					$("#payActionCd").val(sheet1.GetCellValue(Row,"payActionCd"));
					$("#rtrPayActionCd").val(sheet1.GetCellValue(Row,"rtrPayActionCd"));
					$("#elementCd").val(sheet1.GetCellValue(Row,"elementCd"));
				}
			}

			sheet2.DoSearch("${ctx}/RetroExceAllowDedMgr.do?cmd=getRetroExceAllowDedMgrDtlList", $("#sheet1Form").serialize());
			break;

		case "Save":
			// 중복체크
			if (!dupChk(sheet2, "sabun|rtrPayActionCd|elementCd", false, true)) {break;}
			// if (!dupChk(sheet2, "sabun|payActionCd|rtrPayActionCd|elementCd", false, true)) {break;}

			// 개인별 예외수당 Detail 조회
			IBS_SaveName(document.sheet1Form,sheet2);
			sheet2.DoSave("${ctx}/RetroExceAllowDedMgr.do?cmd=saveRetroExceAllowDedMgrDtl", $("#sheet1Form").serialize());
			break;

		case "Insert":
			// 마감여부 확인
			if (!chkClose()) {
				break;
			}

			var Row = sheet1.GetSelectRow();
			if (Row < 1) {
				alert("<msg:txt mid='alertRetroEleSetMgr1' mdef='선택된 Master 정보가 없습니다.'/>");
				break;
			} else if (sheet1.GetCellValue(sheet1.GetSelectRow(), "sStatus") != "R") {
				alert("<msg:txt mid='alertRetroEleSetMgr2' mdef='새로 추가되거나 수정 중인 Master 정보에 대해서는 추가 작업을 할 수 없습니다.'/>");
				break;
			}

			var Row = sheet2.DataInsert(0);
			sheet2.SetCellValue(Row, "payActionCd", sheet1.GetCellValue(sheet1.GetSelectRow(), "payActionCd"));
			sheet2.SetCellValue(Row, "rtrPayActionCd", sheet1.GetCellValue(sheet1.GetSelectRow(), "rtrPayActionCd"));
			sheet2.SetCellValue(Row, "elementCd", sheet1.GetCellValue(sheet1.GetSelectRow(), "elementCd"));
			sheet2.SelectCell(Row, 2);
			break;

		case "Copy":
			sheet2.SelectCell(sheet2.DataCopy(), 2);
			break;

		case "Clear":
			sheet2.RemoveAll();
			break;

		case "LoadExcel":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}
			// 마감여부 확인
			if (!chkClose()) {
				break;
			}

			// 업로드
			var params = {};
			sheet2.LoadExcel(params);
			break;

		case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet2);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet2.Down2Excel(param);
			break;
	}
}

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") {
			alert(Msg);
		}
		sheetResize();

		var Row = sheet1.GetSelectRow();
		if (Row > 0) {
			if (sheet1.GetCellValue(Row,"payActionCd") != null && sheet1.GetCellValue(Row,"payActionCd") != "" &&
				sheet1.GetCellValue(Row,"rtrPayActionCd") != null && sheet1.GetCellValue(Row,"rtrPayActionCd") != "" &&
				sheet1.GetCellValue(Row,"elementCd") != null && sheet1.GetCellValue(Row,"elementCd") != "") {
				$("#payActionCd").val(sheet1.GetCellValue(Row,"payActionCd"));
				$("#rtrPayActionCd").val(sheet1.GetCellValue(Row,"rtrPayActionCd"));
				$("#elementCd").val(sheet1.GetCellValue(Row,"elementCd"));
				// 개인별 예외수당 Detail 조회
				doAction2("Search");
			}
		}
	} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

// 조회 후 에러 메시지
function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("sheet2 OnSearchEnd Event Error : " + ex); }
}

// 저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("sheet1 OnSaveEnd Event Error " + ex); }
}

// 저장 후 메시지
function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("sheet2 OnSaveEnd Event Error " + ex); }
}

// 개인별 예외수당 Master 클릭시 상세조회
function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	try {
		if (Row > 0) {
			if (sheet1.GetCellValue(Row,"payActionCd") != null && sheet1.GetCellValue(Row,"payActionCd") != "" &&
				sheet1.GetCellValue(Row,"rtrPayActionCd") != null && sheet1.GetCellValue(Row,"rtrPayActionCd") != "" &&
				sheet1.GetCellValue(Row,"elementCd") != null && sheet1.GetCellValue(Row,"elementCd") != "") {
				$("#payActionCd").val(sheet1.GetCellValue(Row,"payActionCd"));
				$("#rtrPayActionCd").val(sheet1.GetCellValue(Row,"rtrPayActionCd"));
				$("#elementCd").val(sheet1.GetCellValue(Row,"elementCd"));
				// 개인별 예외수당 Detail 조회
				doAction2("Search");
			}
		}
	} catch (ex) {
		alert("OnClick Event Error " + ex);
	}
}

function sheet2_OnPopupClick(Row, Col) {
	try{
		var colName = sheet2.ColSaveName(Col);
		if (Row > 0 && colName == "name") {
			// 사원검색 팝업
			empSearchPopup(Row, Col);
		}
	} catch(ex) {alert("OnPopupClick Event Error : " + ex);}
}

// 최근급여일자 조회
function getCpnLatestPaymentInfo() {
	var procNm = "최근급여일자";
	// 급여구분(C00001-RETRO.소급)
	var paymentInfo = ajaxCall("${ctx}/RetroExceAllowDedMgr.do?cmd=getCpnQueryList", "queryId=getCpnLatestPaymentInfoMap&procNm="+procNm+"&runType=RETRO,", false);

	if (paymentInfo.DATA != null && paymentInfo.DATA != "" && typeof paymentInfo.DATA[0] != "undefined") {
		$("#payActionCd").val(paymentInfo.DATA[0].payActionCd);
		$("#payActionNm").val(paymentInfo.DATA[0].payActionNm);

		if ($("#payActionCd").val() != null && $("#payActionCd").val() != "") {
			doAction1("Search");
		}
	} else if (paymentInfo.Message != null && paymentInfo.Message != "") {
		alert(paymentInfo.Message);
	}
}

// 사원검색 팝업
function empSearchPopup(Row, Col) {
	let layerModal = new window.top.document.LayerModal({
		id : 'employeeLayer'
		, url : '/Popup.do?cmd=viewEmployeeLayer&authPg=${authPg}'
		, parameters : {}
		, width : 840
		, height : 520
		, title : '사원조회'
		, trigger :[
			{
				name : 'employeeTrigger'
				, callback : function(result){
					sheet2.SetCellValue(Row, "sabun", result.sabun);
					sheet2.SetCellValue(Row, "name", result.name);
					sheet2.SetCellValue(Row, "alias", result.alias);
					sheet2.SetCellValue(Row, "jikgubNm", result.jikgubNm);
					sheet2.SetCellValue(Row, "jikweeNm", result.jikweeNm);
				}
			}
		]
	});
	layerModal.show();


	// if(!isPopup()) {return;}
	// gPRow = Row;
	// pGubun = "employeePopup";
	//
	// var w		= 840;
	// var h		= 520;
	// var url		= "/Popup.do?cmd=employeePopup";
	// var args	= new Array();
	//
	// var result = openPopup(url+"&authPg=R", args, w, h);
	/*
	if (result) {
		var sabun	= result["sabun"];
		var name	= result["name"];

		sheet2.SetCellValue(Row, "sabun", sabun);
		sheet2.SetCellValue(Row, "name", name);
	}
	*/
}

// 급여일자 검색 팝입
function payActionSearchPopup() {
	let layerModal = new window.top.document.LayerModal({
		id : 'payDayLayer'
		, url : '/PayDayPopup.do?cmd=viewPayDayLayer&authPg=R'
		, parameters : {
			runType : 'RETRO'
		}
		, width : 840
		, height : 520
		, title : '<tit:txt mid='payDayPop' mdef='급여일자 조회'/>'
		, trigger :[
			{
				name : 'payDayTrigger'
				, callback : function(result){
					$("#payActionCd").val(result.payActionCd);
					$("#payActionNm").val(result.payActionNm);
				}
			}
		]
	});
	layerModal.show();


	// if(!isPopup()) {return;}
	// gPRow = "";
	// pGubun = "payDayPopup";
	//
	// var w		= 840;
	// var h		= 520;
	// var url		= "/PayDayPopup.do?cmd=payDayPopup";
	// var args 	= new Array();
	// args["runType"] = "RETRO";
	//
	// var result = openPopup(url+"&authPg=R", args, w, h);
	/*
	if (result) {
		var payActionCd	= result["payActionCd"];
		var payActionNm	= result["payActionNm"];

		$("#payActionCd").val(payActionCd);
		$("#payActionNm").val(payActionNm);
	}
	*/
}

// 대상일자 팝입
function rtrPayActionSearchPopup() {
	let layerModal = new window.top.document.LayerModal({
		id : 'retroAllowPayActionLayer'
		, url : '/RetroExceAllowDedMgr.do?cmd=viewRtrPayActionLayer&authPg=R'
		, parameters : {
			payActionCd : $("#payActionCd").val()
		}
		, width : 600
		, height : 520
		, title : '<tit:txt mid='113135' mdef='대상일자'/>'
		, trigger :[
			{
				name : 'retroAllowPayActionTrigger'
				, callback : function(result){
					$("#rtrPayActionCd").val(result.rtrPayActionCd);
					$("#rtrPayActionNm").val(result.rtrPayActionNm);
					$("#payNm").val(result.payNm);
				}
			}
		]
	});
	layerModal.show();

	// if(!isPopup()) {return;}
	// gPRow = "";
	// pGubun = "viewRtrPayActionPopup";
	//
	// var w 		= 600;
	// var h 		= 520;
	// var url 	= "/RetroExceAllowDedMgr.do?cmd=viewRtrPayActionPopup";
	// var args 	= new Array();
	// args["payActionCd"] = $("#payActionCd").val();
	//
	// var result = openPopup(url+"&authPg=R", args, w, h);
	/*
	if (result) {
		var rtrPayActionCd	= result["rtrPayActionCd"];
		var rtrPayActionNm	= result["rtrPayActionNm"];
		var payNm			= result["payNm"];

		$("#rtrPayActionCd").val(rtrPayActionCd);
		$("#rtrPayActionNm").val(rtrPayActionNm);
		$("#payNm").val(payNm);
	}
	*/
}

// 항목명 팝입
function elementSearchPopup() {
	let layerModal = new window.top.document.LayerModal({
		id : 'retroAllowElementLayer'
		, url : '/RetroExceAllowDedMgr.do?cmd=viewElementLayer&authPg=R'
		, parameters : {
			payActionCd : $("#payActionCd").val()
			, rtrPayActionCd : $("#rtrPayActionCd").val()
		}
		, width : 500
		, height : 520
		, title : '<tit:txt mid='allowElePptMgr1' mdef='수당항목'/>'
		, trigger :[
			{
				name : 'retroAllowElementTrigger'
				, callback : function(result){
					$("#rtrPayActionCd").val(result.rtrPayActionCd);
					$("#rtrPayActionNm").val(result.rtrPayActionNm);
					$("#elementCd").val(result.elementCd);
					$("#elementNm").val(result.elementNm);
				}
			}
		]
	});
	layerModal.show();

	// if(!isPopup()) {return;}
	// gPRow = "";
	// pGubun = "viewElementPopup";
	//
	// var w 		= 500;
	// var h 		= 520;
	// var url 	= "/RetroExceAllowDedMgr.do?cmd=viewElementPopup";
	// var args 	= new Array();
	// args["payActionCd"] = $("#payActionCd").val();
	// args["rtrPayActionCd"] = $("#rtrPayActionCd").val();
	//
	// var result = openPopup(url+"&authPg=R", args, w, h);
	/*
	if (result) {
		var rtrPayActionCd	= result["rtrPayActionCd"];
		var rtrPayActionNm	= result["rtrPayActionNm"];
		var elementCd		= result["elementCd"];
		var elementNm		= result["elementNm"];

		$("#rtrPayActionCd").val(rtrPayActionCd);
		$("#rtrPayActionNm").val(rtrPayActionNm);
		$("#elementCd").val(elementCd);
		$("#elementNm").val(elementNm);
	}
	*/
}

function getReturnValue(returnValue) {
	var rv = $.parseJSON('{' + returnValue+ '}');

    if(pGubun == "payDayPopup"){
		$("#payActionCd").val(rv["payActionCd"]);
		$("#payActionNm").val(rv["payActionNm"]);
    }else if(pGubun == "viewRtrPayActionPopup"){
		var rtrPayActionCd	= rv["rtrPayActionCd"];
		var rtrPayActionNm	= rv["rtrPayActionNm"];
		var payNm			= rv["payNm"];

		$("#rtrPayActionCd").val(rtrPayActionCd);
		$("#rtrPayActionNm").val(rtrPayActionNm);
		$("#payNm").val(payNm);

    }else if(pGubun == "viewElementPopup"){
		var rtrPayActionCd	= rv["rtrPayActionCd"];
		var rtrPayActionNm	= rv["rtrPayActionNm"];
		var elementCd		= rv["elementCd"];
		var elementNm		= rv["elementNm"];

		$("#rtrPayActionCd").val(rtrPayActionCd);
		$("#rtrPayActionNm").val(rtrPayActionNm);
		$("#elementCd").val(elementCd);
		$("#elementNm").val(elementNm);

    }else if(pGubun == "employeePopup"){
		var sabun	= rv["sabun"];
		var name	= rv["name"];
		var alias	= rv["alias"];
		var jikgubNm	= rv["jikgubNm"];
		var jikweeNm	= rv["jikweeNm"];

		sheet2.SetCellValue(gPRow, "sabun", sabun);
		sheet2.SetCellValue(gPRow, "name", name);
		sheet2.SetCellValue(gPRow, "alias", alias);
		sheet2.SetCellValue(gPRow, "jikgubNm", jikgubNm);
		sheet2.SetCellValue(gPRow, "jikweeNm", jikweeNm);
    }
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
						<th><tit:txt mid='114569' mdef='소급일자'/></th>
						<td>  <input type="hidden" id="payActionCd" name="payActionCd" value="" />
												<input type="text" id="payActionNm" name="payActionNm" class="text required readonly" value="" readonly style="width:180px" />
						 <a onclick="javascript:payActionSearchPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a> </td>
						 <th><tit:txt mid='113135' mdef='대상일자'/></th>
						<td>  <input type="hidden" id="rtrPayActionCd" name="rtrPayActionCd" value="" />
												<input type="text" id="rtrPayActionNm" name="rtrPayActionNm" class="text readonly" value="" readonly style="width:180px" />
												<a onclick="javascript:rtrPayActionSearchPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
												<a onclick="$('#rtrPayActionCd,#rtrPayActionNm').val('');" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
												<input type="hidden" id="closeYn" name="closeYn" value="" /><input type="hidden" id="payNm" name="payNm" value="" /> 
						</td>
					</tr>
					<tr>
						<th><tit:txt mid='eleGroupMgr2' mdef='항목명'/></th>
						<td>  <input type="hidden" id="elementCd" name="elementCd" value="" />
												<input type="text" id="elementNm" name="elementNm" class="text readonly" value="" readonly style="width:120px" />
												<a onclick="javascript:elementSearchPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
												<a onclick="$('#elementCd,#elementNm').val('');" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a> </td>
						<th><tit:txt mid='104330' mdef='사번/성명'/></th>
						<td>  
							<input type="text" id="sabunName" name="sabunName" class="text" value="" style="ime-mode:active" /> 
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<colgroup>
			<col width="50%" />
			<col width="50%" />
		</colgroup>
		<tr>
			<td class="sheet_left">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='113136' mdef='개인별 예외수당 Master '/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Search')"		css="button authR" mid='110697' mdef="조회"/>
								<btn:a href="javascript:doAction1('Insert')"		css="basic authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction1('Save')"			css="basic authA" mid='110708' mdef="저장"/>
								<btn:a href="javascript:doAction1('Down2Excel')"	css="basic authR" mid='110698' mdef="다운로드"/>
								<a href="javascript:doAction1('PrcP_CPN_PAY_RETROACT_MAKE_ITEM')"	class="basic authA"><tit:txt mid='113836' mdef='항목생성'/></a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet1", "50%", "100%", "${ssnLocaleCd}"); </script>
			</td>

			<td class="sheet_right">
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li id="txt" class="txt"><tit:txt mid='retroExceAllowDedMgr2' mdef='개인별 예외수당 Detail'/></li>
						<li class="btn">
							<btn:a href="javascript:doAction2('Search')"		css="button authR" mid='110697' mdef="조회"/>
							<btn:a href="javascript:doAction2('Insert')"		css="basic authA" mid='110700' mdef="입력"/>
							<btn:a href="javascript:doAction2('Save')"			css="basic authA" mid='110708' mdef="저장"/>
							<btn:a href="javascript:doAction2('Down2Excel')"	css="basic authR" mid='110698' mdef="다운로드"/>
							<btn:a href="javascript:doAction2('LoadExcel')"		css="basic authA" mid='110703' mdef="업로드"/>
						</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet2", "50%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
		</table>
		
		<%-- 
		
			<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<colgroup>
			<col width="49%" />
			<col width="1%" />
			<col width="49%" />
		</colgroup>
		<tr>
			<td>
				<div class="sheet_title outer">
					<ul>
						<li id="txt" class="txt"><tit:txt mid='113136' mdef='개인별 예외수당 Master '/></li>
					</ul>
				</div>
			</td>
			<td>
			</td>
			<td>
				<div class="sheet_title">
					<ul>
						<li id="txt" class="txt"><tit:txt mid='retroExceAllowDedMgr2' mdef='개인별 예외수당 Detail'/></li>
					</ul>
				</div>
			</td>
		</tr>
		<tr>
			<td>
				<div class="outer">
					<div class="sheet_title">
						<ul>
							<li class="btn">
								<btn:a href="javascript:doAction1('Search')"		css="button authR" mid='110697' mdef="조회"/>
								<btn:a href="javascript:doAction1('Insert')"		css="basic authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction1('Save')"			css="basic authA" mid='110708' mdef="저장"/>
								<btn:a href="javascript:doAction1('Down2Excel')"	css="basic authR" mid='110698' mdef="다운로드"/>
								<a href="javascript:doAction1('PrcP_CPN_PAY_RETROACT_MAKE_ITEM')"	class="basic authA"><tit:txt mid='113836' mdef='항목생성'/></a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "50%", "100%", "${ssnLocaleCd}"); </script>
			</td>
			<td>
			</td>
			<td>
				<div class="outer">
					<div class="sheet_title">
						<ul>
							<li class="btn">
								<btn:a href="javascript:doAction2('Search')"		css="button authR" mid='110697' mdef="조회"/>
								<btn:a href="javascript:doAction2('Insert')"		css="basic authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction2('Save')"			css="basic authA" mid='110708' mdef="저장"/>
								<btn:a href="javascript:doAction2('Down2Excel')"	css="basic authR" mid='110698' mdef="다운로드"/>
								<btn:a href="javascript:doAction2('LoadExcel')"		css="basic authA" mid='110703' mdef="업로드"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet2", "50%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table> --%>
</div>
</body>
</html>
