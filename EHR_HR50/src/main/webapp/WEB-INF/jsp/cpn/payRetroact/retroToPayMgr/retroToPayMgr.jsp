<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='retroToPayMgr' mdef='소급결과급여반영'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 소급결과급여반영
 * @author JM
-->
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
$(function() {

	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};
	initdata1.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",						Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",				Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",					Type:"${sSttTy}",	Hidden:0,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },
		{Header:"Hidden",	Hidden:1, SaveName:"rePayActionCd"},
		{Header:"Hidden",	Hidden:1, SaveName:"enterCd"},
		{Header:"Hidden",	Hidden:1, SaveName:"elementCd"},
		{Header:"소급항목",				Type:"Text",		Hidden:0,					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"elementNm",		KeyField:0,	Format:"",			UpdateEdit:0,	InsertEdit:0,	EditLen:50 },
		{Header:"반영항목코드",			Type:"Text",		Hidden:0,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"appElementCd",	KeyField:0,	Format:"",			UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"반영항목명",			Type:"Popup",		Hidden:0,					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"appElementNm",	KeyField:0,	Format:"",			UpdateEdit:1,	InsertEdit:0,	EditLen:50 },
	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);
	
	var initdata2 = {};
	initdata2.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata2.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};
	initdata2.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",						Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",				Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",					Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },
		{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",				Type:"Text",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",			UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",				Type:"Text",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",			UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",				Type:"Text",		Hidden:1,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"alias",		KeyField:0,	Format:"",			UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"<sht:txt mid='jikChakNmV8' mdef='직책'/>",				Type:"Text",		Hidden:1,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",	KeyField:0,	Format:"",			UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",			Type:"Text",		Hidden:1,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",			UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"<sht:txt mid='benefitElemCd' mdef='항목코드'/>",		Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"elementCd",	KeyField:0,	Format:"",			UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='benefitElemNm' mdef='항목명'/>",			Type:"Text",		Hidden:1,					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"elementNm",	KeyField:0,	Format:"",			UpdateEdit:0,	InsertEdit:1,	EditLen:50 },
		{Header:"<sht:txt mid='basicMon' mdef='금액'/>",				Type:"Int",			Hidden:0,					Width:120,			Align:"Right",	ColMerge:0,	SaveName:"paymentMon",	KeyField:0,	Format:"Integer",	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='chkdateV4' mdef='최종작업시간'/>",		Type:"Date",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"chkdate",		KeyField:0,	Format:"YmdHms",	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },
		{Header:"<sht:txt mid='chkidV3' mdef='최종작업자'/>",			Type:"Text",		Hidden:0,					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"chknm",		KeyField:0,	Format:"",			UpdateEdit:0,	InsertEdit:0,	EditLen:50 },
	]; IBS_InitSheet(sheet2, initdata2); sheet2.SetCountPosition(4);

	$(window).smartresize(sheetResize);
	sheetInit();

	$("#rate").bind("keyup",function(event) {
		makeNumber(this, 'A');
	});

	// 최근급여일자 조회
	getCpnLatestPaymentInfo();

	// 최근소급일자 조회
	getCpnLatestRPaymentInfo();
});

// 필수값/유효성 체크
function chkInVal(sAction) {
	if ($("#searchPayActionCd").val() == "") {
		alert("<msg:txt mid='109681' mdef='급여일자를 선택하십시오.'/>");
		$("#payActionNm").focus();
		return false;
	}

	if (sAction == "PrcP_CPN_RE_CAL_TO_PAY_APPLY" || sAction == "PrcP_CPN_RE_CAL_TO_PAY_CANCEL") {
		if ($("#searchRePayActionCd").val() == "") {
			alert("<msg:txt mid='alertRetroExceAllowDedMgr7' mdef='소급일자를 선택하십시오.'/>");
			$("#rePayActionNm").focus();
			return false;
		}
		if ($("#elementCd").val() == "") {
			alert("<msg:txt mid='alertElementNm' mdef='급여적용 수당항목을 선택하십시오.'/>");
			$("#elementNm").focus();
			return false;
		}
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

			sheet1.DoSearch("${ctx}/RetroToPayMgr.do?cmd=getRetroToPayMgrPriorList", $("#sheet1Form").serialize());
			break;

		case "Save":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/RetroToPayMgr.do?cmd=saveRetroToPayMgrPriorList", $("#sheet1Form").serialize());
			break;

		case "PrcP_CPN_RE_CAL_TO_PAY_APPLY":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			if (confirm("<msg:txt mid='114807' mdef='급여반영작업을 시작하시겠습니까?\n\n[선택한 급여계산일자에 대한 수당항목이 예외수당항목에서 등록됩니다.]\n\n계속진행하시겠습니까?'/>")) {

				var searchRePayActionCd = $("#searchRePayActionCd").val();
				var searchPayActionCd = $("#searchPayActionCd").val();
				var elementCd = $("#elementCd").val();
				var rate = $("#rate").val();

				// 급여반영
				var result = ajaxCall("${ctx}/RetroToPayMgr.do?cmd=prcP_CPN_RE_CAL_TO_PAY_APPLY", "searchRePayActionCd="+searchRePayActionCd+"&searchPayActionCd="+searchPayActionCd+"&elementCd="+elementCd+"&rate="+rate, false);

				if (result != null && result["Result"] != null && result["Result"]["Code"] != null) {
					if (result["Result"]["Code"] == "0") {
						alert("<msg:txt mid='alertRetroToPayMgr2' mdef='급여반영이 완료되었습니다.'/>");
						// 프로시저 호출 후 재조회
						doAction1("Search");
					} else if (result["Result"]["Message"] != null && result["Result"]["Message"] != "") {
						alert(result["Result"]["Message"]);
					}
				} else {
					alert("<msg:txt mid='109873' mdef='급여반영 오류입니다.'/>");
				}

			}
			break;

		case "PrcP_CPN_RE_CAL_TO_PAY_CANCEL":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			if (confirm("급여반영작업을 취소하시겠습니까?\n\n[선택한 급여계산일자에 대한 수당항목이 예외수당항목에서 삭제됩니다.]\n\n계속진행하시겠습니까?")) {

				var searchRePayActionCd = $("#searchRePayActionCd").val();
				var searchPayActionCd = $("#searchPayActionCd").val();
				var elementCd = $("#elementCd").val();

				// 급여반영 취소
				var result = ajaxCall("${ctx}/RetroToPayMgr.do?cmd=prcP_CPN_RE_CAL_TO_PAY_CANCEL", "searchRePayActionCd="+searchRePayActionCd+"&searchPayActionCd="+searchPayActionCd+"&elementCd="+elementCd, false);

				if (result != null && result["Result"] != null && result["Result"]["Code"] != null) {
					if (result["Result"]["Code"] == "0") {
						alert("<msg:txt mid='alertRetroToPayMgr5' mdef='급여반영 취소작업이 완료되었습니다.'/>");
						// 프로시저 호출 후 재조회
						doAction1("Search");
					} else if (result["Result"]["Message"] != null && result["Result"]["Message"] != "") {
						alert(result["Result"]["Message"]);
					}
				} else {
					alert("<msg:txt mid='alertRetroToPayMgr6' mdef='급여반영 취소 오류입니다.'/>");
				}

			}
			break;
		/* case "PrcP_CPN_RE_CAL_TO_PAY_APPLY_EB":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}
			
			if (confirm("급여반영작업을 시작하시겠습니까?\n[선택한 급여계산일자에 연결된 소급항목이 예외수당항목에서 등록됩니다.]\n계속진행하시겠습니까?")) {

				var searchRePayActionCd = $("#searchRePayActionCd").val();
				var searchPayActionCd = $("#searchPayActionCd").val();
				var rate = $("#rate").val();
				
				// 소급항목반영을
				var result = ajaxCall("${ctx}/RetroToPayMgr.do?cmd=prcP_CPN_RE_CAL_TO_PAY_APPLY_EB", "searchRePayActionCd="+searchRePayActionCd+"&searchPayActionCd="+searchPayActionCd+"&rate="+rate, false);
				
				if(result.Result.Code == null) {
					alert("<msg:txt mid='alertRetroToPayMgr7' mdef='소급항목반영작업이 완료되었습니다.'/>");
					doAction1("Search");
				} else {
					alert("처리중 오류가 발생했습니다.\n"+data.Result.Message);
				}
			}
			break;
			 */
		case "PrcP_CPN_RE_CAL_TO_PAY_CREATE":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}
			
			if (confirm("기존생성 내역이 초기화 됩니다.\n소급결과를 생성하시겠습니까?")) {

				var searchRePayActionCd = $("#searchRePayActionCd").val();
				var searchPayActionCd = $("#searchPayActionCd").val();
				var rate = $("#rate").val();
				
				// 소급항목반영을
				var result = ajaxCall("${ctx}/RetroToPayMgr.do?cmd=prcP_CPN_RE_CAL_TO_PAY_CREATE", "searchRePayActionCd="+searchRePayActionCd+"&searchPayActionCd="+searchPayActionCd+"&rate="+rate, false);
				
				if(result.Result.Code == null) {
					alert("<msg:txt mid='alertRetroToPayMgr7' mdef='소급결과 생성이 완료되었습니다.'/>");
					doAction1("Search");
				} else {
					alert("처리중 오류가 발생했습니다.\n"+data.Result.Message);
				}
			}
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

function doAction2(sAction) {
	switch (sAction) {
		case "Search":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			sheet2.DoSearch("${ctx}/RetroToPayMgr.do?cmd=getRetroToPayMgrList", $("#sheet1Form").serialize());
			break;
	}
}

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

//조회 후 에러 메시지
function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

// 셀 선택 시 이벤트
function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
	try{

		if( NewRow < sheet2.HeaderRows() ) return;
		
		if( OldRow != NewRow ){ 
			$("#searchElementCd").val(sheet1.GetCellValue(NewRow,"elementCd"));
			doAction2("Search"); 
		}
	}catch(ex){alert("OnSelectCell Event Error : " + ex);}
}


//Type이 POPUP인 셀에서 팝업버튼을 눌렀을때 발생하는 이벤트
function sheet1_OnPopupClick(Row, Col){
	var colName = sheet1.ColSaveName(Col);
	if(colName !== "appElementNm") return;

	let layerModal = new window.top.document.LayerModal({
		id : 'payElementLayer'
		, url : '/PayElementPopup.do?cmd=viewPayElementLayer&authPg=${authPg}'
		, parameters : {
			elementCd : sheet1.GetCellValue(Row, "elementCd")
			, elementNm : sheet1.GetCellValue(Row, "elementNm")
		}
		, width : 860
		, height : 520
		, title : '<tit:txt mid='payElementPop4' mdef='수당,공제 항목'/>'
		, trigger :[
			{
				name : 'payTrigger'
				, callback : function(result){
					sheet1.SetCellValue(Row, "appElementCd",   result.resultElementCd);
					sheet1.SetCellValue(Row, "appElementNm",   result.resultElementNm);
				}
			}
		]
	});
	layerModal.show();


	<%--try{--%>
	<%--	var colName = sheet1.ColSaveName(Col);--%>
	<%--	if(colName == "appElementNm") {--%>
	<%--		if(!isPopup()) {return;}--%>

	<%--		var args	= new Array();--%>
	<%--		--%>
	<%--		args["elementCd"]   = sheet1.GetCellValue(Row, "appElementCd");--%>
	<%--		args["elementNm"]   = sheet1.GetCellValue(Row, "appElementNm");--%>
	<%--		--%>
	<%--		var rv = null;--%>
	<%--		--%>
	<%--		gPRow = Row;--%>
	<%--		pGubun = "payElementPopupSheet1";--%>

	<%--		var rv = openPopup("/PayElementPopup.do?cmd=payElementPopup&authPg=${authPg}", args, "740","520");--%>
	<%--	}--%>

	<%--}catch(ex){alert("OnPopupClick Event Error : " + ex);}--%>
}

// 최근급여일자 조회
function getCpnLatestPaymentInfo() {
	var procNm = "최근급여일자";
	// 급여구분(C00001-00001.급여)
	var paymentInfo = ajaxCall("${ctx}/RetroToPayMgr.do?cmd=getCpnQueryList", "queryId=getCpnLatestPaymentInfoMap&procNm="+procNm+"&runType=00001,", false);
	if (paymentInfo.DATA != null && paymentInfo.DATA != "" && typeof paymentInfo.DATA[0] != "undefined") {
		$("#searchPayActionCd").val(paymentInfo.DATA[0].payActionCd);
		$("#payActionNm").val(paymentInfo.DATA[0].payActionNm);
		$("#closeYn").val(paymentInfo.DATA[0].closeYn);
		changeByCloseYn();

		if ($("#searchPayActionCd").val() != null && $("#searchPayActionCd").val() != "") {
			doAction1("Search");
		}
	} else if (paymentInfo.Message != null && paymentInfo.Message != "") {
		alert(paymentInfo.Message);
	}
}

//최근소급일자 조회
function getCpnLatestRPaymentInfo() {
	var procNm = "최근소급일자";
	// 급여구분(C00001-00001.급여)
	var paymentInfo = ajaxCall("${ctx}/RetroToPayMgr.do?cmd=getCpnQueryList", "queryId=getCpnLatestPaymentInfoMap&procNm="+procNm+"&runType=RETRO,", false);

	if (paymentInfo.DATA != null && paymentInfo.DATA != "" && typeof paymentInfo.DATA[0] != "undefined") {
		$("#searchRePayActionCd").val(paymentInfo.DATA[0].payActionCd);
		$("#rePayActionNm").val(paymentInfo.DATA[0].payActionNm);
		
		if ($("#searchRePayActionCd").val() != null && $("#searchRePayActionCd").val() != "") {
			doAction1("Search");
		}
	} else if (paymentInfo.Message != null && paymentInfo.Message != "") {
		alert(paymentInfo.Message);
	}
}

// 소급일자 검색 팝입
function rePayActionSearchPopup() {
	let layerModal = new window.top.document.LayerModal({
		id : 'payDayLayer'
		, url : '/PayDayPopup.do?cmd=viewPayDayLayer&authPg=R'
		, parameters : {
			runType : 'RETRO'
		}
		, width : 900
		, height : 520
		, title : '<tit:txt mid='payDayPop' mdef='급여일자 조회'/>'
		, trigger :[
			{
				name : 'payDayTrigger'
				, callback : function(result){
					$("#searchRePayActionCd").val(result.payActionCd);
					$("#rePayActionNm").val(result.payActionNm);
				}
			}
		]
	});
	layerModal.show();


	// if(!isPopup()) {return;}
	// gPRow = "";
	// pGubun = "payDayPopup";
	//
	// var w 		= 840;
	// var h 		= 520;
	// var url 	= "/PayDayPopup.do?cmd=payDayPopup";
	// var args 	= new Array();
	// args["runType"] = "RETRO";
	//
	// var result = openPopup(url+"&authPg=R", args, w, h);
}

// 급여일자 검색 팝입
function payActionSearchPopup() {
	let layerModal = new window.top.document.LayerModal({
		id : 'payDayLayer'
		, url : '/PayDayPopup.do?cmd=viewPayDayLayer&authPg=R'
		, parameters : {
			runType : '00001'
		}
		, width : 900
		, height : 520
		, title : '<tit:txt mid='payDayPop' mdef='급여일자 조회'/>'
		, trigger :[
			{
				name : 'payDayTrigger'
				, callback : function(result){
					$("#searchPayActionCd").val(result.payActionCd);
					$("#payActionNm").val(result.payActionNm);
					$("#closeYn").val(result.closeYn === "1" || result.closeYn === "Y" ? "Y" : "N");
					changeByCloseYn();
					if ($("#searchPayActionCd").val() != null && $("#searchPayActionCd").val() != "") {
						doAction1("Search");
					}
				}
			}
		]
	});
	layerModal.show();


	// if(!isPopup()) {return;}
	// gPRow = "";
	// pGubun = "payDayPopup2";
	//
	// var w 		= 840;
	// var h 		= 520;
	// var url 	= "/PayDayPopup.do?cmd=payDayPopup";
	// var args 	= new Array();
	// args["runType"] = "00001";
	//
	// var result = openPopup(url+"&authPg=R", args, w, h);
}

// 수당항목 검색 팝입
function elementSearchPopup() {
	let layerModal = new window.top.document.LayerModal({
		id : 'payElementLayer'
		, url : '/PayElementPopup.do?cmd=viewPayElementLayer&authPg=${authPg}'
		, parameters : {
			searchElementLinkType : 'retro'
			, elementType : 'A'
		}
		, width : 860
		, height : 520
		, title : '<tit:txt mid='payElementPop4' mdef='수당,공제 항목'/>'
		, trigger :[
			{
				name : 'payTrigger'
				, callback : function(result){
					$("#elementCd").val(result.resultElementCd);
					$("#elementNm").val(result.resultElementNm);
				}
			}
		]
	});
	layerModal.show();


	// if(!isPopup()) {return;}
	// gPRow = "";
	// pGubun = "payElementPopup";
	//
	// var w		= 700;
	// var h		= 520;
	// var url		= "/PayElementPopup.do?cmd=payElementPopup";
	// var args	= new Array();
	//
	// args["searchElementLinkType"] = "retro"; // 소급
	// args["elementType"] = "A"; // 지급
	//
	// var result = openPopup(url+"&authPg=R", args, w, h);
}

function getReturnValue(returnValue) {
	var rv = $.parseJSON('{' + returnValue+ '}');

	if(pGubun == "payDayPopup"){
		$("#searchRePayActionCd").val(rv["payActionCd"]);
		$("#rePayActionNm").val(rv["payActionNm"]);
	}else if(pGubun == "payDayPopup2"){
		$("#searchPayActionCd").val(rv["payActionCd"]);
		$("#payActionNm").val(rv["payActionNm"]);
		$("#closeYn").val(rv["closeYn"] == "1" || rv["closeYn"] == "Y" ? "Y":"N");
		changeByCloseYn();
		if ($("#searchPayActionCd").val() != null && $("#searchPayActionCd").val() != "") {
			doAction1("Search");
		}
	}else if(pGubun == "payElementPopup"){
		$("#elementCd").val(rv["elementCd"]);
		$("#elementNm").val(rv["elementNm"]);
	}else if(pGubun == "payElementPopupSheet1"){
		sheet1.SetCellValue(gPRow, "appElementCd",   rv["elementCd"] );
		sheet1.SetCellValue(gPRow, "appElementNm",   rv["elementNm"] );
	}
}

function changeByCloseYn(){
	if($("#closeYn").val() == "Y"){
		$("#cpnReCalToPayApply0").addClass("hide");
		$("#cpnReCalToPayApply1").addClass("hide");
		$("#closeComment").removeClass("hide");
	}else{
		$("#cpnReCalToPayApply0").removeClass("hide");
		$("#cpnReCalToPayApply1").removeClass("hide");
		$("#closeComment").addClass("hide");
	}
}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form">
		<input type="hidden" id="searchElementCd" name="searchElementCd"/>
		<input type="hidden" id="closeYn" name="closeYn"/>
		<table border="0" cellpadding="0" cellspacing="0" class="default outer">
			<colgroup>
				<col width="15%" />
				<col width="35%" />
				<col width="15%" />
				<col width="35%" />
			</colgroup>
			<tr>
				<th><tit:txt mid='114569' mdef='소급일자'/></th>
				<td colspan="3"> <input type="hidden" id="searchRePayActionCd" name="searchRePayActionCd" value="" />
					 <input type="text" id="rePayActionNm" name="rePayActionNm" class="text readonly" value="" readonly style="width:180px" />
					 <a onclick="javascript:rePayActionSearchPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
					 <a onclick="$('#searchRePayActionCd,#rePayActionNm').val('');" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
					<tit:txt mid='201705040000142' mdef='소급계산결과금액을 가져올 소급일자를 선택하여 주십시요.'/> </td>
			</tr>
			<tr>
				<td colspan="4"><tit:txt mid='113140' mdef=' 소급계산결과금액을 적용시킬 급여일자 및 급여에적용시킬 해당 항목명(소급분)을 선택하여 주십시요. '/></td>
			</tr>
			<tr>
				<th><tit:txt mid='104477' mdef='급여일자'/></th>
				<td colspan="4">
					<input type="hidden" id="searchPayActionCd" name="searchPayActionCd" value="" />
					<input type="text" id="payActionNm" name="payActionNm" class="text required readonly" value="" readonly style="width:180px" />
					<a onclick="javascript:payActionSearchPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
					<label id="closeComment" class="hide">해당 급여는 마감되었습니다.</label>
				</td>
<%-- 				<th><tit:txt mid='allowElePptMgr1' mdef='수당항목'/></th> --%>
<!-- 				<td> -->
<!-- 					<input type="hidden" id="elementCd" name="elementCd" value="" /> -->
<!-- 					<input type="text" id="elementNm" name="elementNm" class="text readonly" value="" readonly style="width:180px" /> -->
<%-- 					<a onclick="javascript:elementSearchPopup();return false;" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a> --%>
<%-- 					<a onclick="$('#elementCd,#elementNm').val('');return false;" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a> --%>
<!-- 				</td> -->
			</tr>
			<tr>
				<th><tit:txt mid='114192' mdef='적용비율'/></th>
				<td> <input type="text" id="rate" name="rate" value="100" class="text right" maxlength="3" /> % </td>
				<th>작업
				</th>
				<td>
<%-- 					<btn:a href="javascript:doAction1('PrcP_CPN_RE_CAL_TO_PAY_APPLY_EB')" id="cpnReCalToPayApply0"  css="button" mid='19999' mdef="소급항목반영"/> --%>
					<btn:a href="javascript:doAction1('PrcP_CPN_RE_CAL_TO_PAY_APPLY')" id="cpnReCalToPayApply1" css="button" mid='110741' mdef="작업"/>
				<td>
			</tr>
		</table>
	</form>
	
	
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<colgroup>
		<col width="500px" />
		<col width="*" />
	</colgroup>
	<tr>
		<td class="sheet_left">
			<div class="inner">
				<div class="sheet_title">
					<ul>
						<li id="txt" class="txt"><tit:txt mid='retroToPayMgr' mdef='소급결과급여반영'/></li>
						<li class="btn">
							<btn:a href="javascript:doAction1('PrcP_CPN_RE_CAL_TO_PAY_CREATE')" id="cpnReCalToPayApply2"  css="button" mid='9999999999' mdef="소급결과생성"/>
							<a href="javascript:doAction1('Search')"			class="basic authR">조회</a>
							<a href="javascript:doAction1('Save');"				class="basic authA">저장</a>
						</li>
					</ul>
				</div>
			</div>
			<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
		</td>
		<td class="sheet_right">
			<div class="inner">
				<div class="sheet_title">
					<ul>
						<li id="txt" class="txt">소급대상자</li>
					<li class="btn">
						<a href="javascript:doAction2('Down2Excel');" class="basic authR">다운로드</a>
					</li>
					</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet2", "100%", "100%", "kr"); </script>
		</td>
	</tr>
	</table>
</div>
</body>
</html>
