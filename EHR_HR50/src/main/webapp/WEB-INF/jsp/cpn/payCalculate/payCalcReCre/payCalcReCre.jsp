<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>월급여재계산</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 월급여재계산
 * @author JM
-->
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
var mode = "";
<c:if test="${ !empty param.mode }">
	mode = "${param.mode}";
</c:if>

$(function() {
	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22, FrozenCol:10};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata1.Cols = [
		{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제",		Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",				Sort:0 },
		{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",				Sort:0 },
		{Header:"세부\n내역",	Type:"Image",		Hidden:0,				Width:40,			Align:"Center",	ColMerge:0,	SaveName:"detail",				Cursor:"Pointer",			EditLen:1 },
		{Header:"급여계산코드",	Type:"Text",		Hidden:1,				Width:90,			Align:"Center",	ColMerge:0,	SaveName:"payActionCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"재계산",		Type:"CheckBox",	Hidden:0,				Width:65,			Align:"Center",	ColMerge:0,	SaveName:"reCre",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
		{Header:"대상상태",		Type:"Combo",		Hidden:0,				Width:90,			Align:"Center",	ColMerge:0,	SaveName:"payPeopleStatus",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"대상상태",		Type:"Text",		Hidden:1,				Width:90,			Align:"Center",	ColMerge:0,	SaveName:"payPeopleStatusNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"사번",		Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"sabun",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"성명",		Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"name",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"소속",		Type:"Text",		Hidden:0,					Width:120,			Align:"Left",	ColMerge:0,	SaveName:"orgNm",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
        {Header:"계약유형",		Type:"Combo",		Hidden:0,				Width:100,			Align:"Center",	ColMerge:0,	SaveName:"manageCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
        {Header:"직구분",		Type:"Combo",		Hidden:0,				Width:100,			Align:"Center",	ColMerge:0,	SaveName:"workType",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
        {Header:"급여유형",		Type:"Combo",		Hidden:0,				Width:100,			Align:"Center",	ColMerge:0,	SaveName:"payType",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
        {Header:"직위",      Type:"Combo",       Hidden:0,                  Width:100,          Align:"Center", ColMerge:0, SaveName:"jikweeCd",            KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
        {Header:"직급",		Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
        {Header:"직책",      Type:"Combo",       Hidden:0,                  Width:100,          Align:"Center", ColMerge:0, SaveName:"jikchakCd",           KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
        {Header:"호봉",		Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"salClass",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"입사일",		Type:"Date",		Hidden:0,				Width:90,			Align:"Center",	ColMerge:0,	SaveName:"empYmd",				KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"그룹입사일",	Type:"Date",		Hidden:0,				Width:90,			Align:"Center",	ColMerge:0,	SaveName:"gempYmd",				KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 }
	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);

	//------------------------------------- 그리드 콤보 -------------------------------------//
	// 직구분코드(H10050)
	var workType = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10050"), "");
	sheet1.SetColProperty("workType", {ComboText:"|"+workType[0], ComboCode:"|"+workType[1]});
	
	// 계약유형코드(H10030)
	var manageCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10030"), "");
	sheet1.SetColProperty("manageCd", {ComboText:"|"+manageCd[0], ComboCode:"|"+manageCd[1]});
	
	// 급여유형코드(H10110)
	var payType = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10110"), "");
	sheet1.SetColProperty("payType", {ComboText:"|"+payType[0], ComboCode:"|"+payType[1]});	
	
	// 급여대상자상태(C00125)
	var payPeopleStatus = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "C00125"), "");
	sheet1.SetColProperty("payPeopleStatus", {ComboText:payPeopleStatus[0], ComboCode:payPeopleStatus[1]});

	// 직급코드(H20010)
	var jikgubCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20010"), "");
	sheet1.SetColProperty("jikgubCd", {ComboText:jikgubCd[0], ComboCode:jikgubCd[1]});

    // 직책코드(H20020)
    var jikchakCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20020"), "");
    sheet1.SetColProperty("jikchakCd", {ComboText:"|"+jikchakCd[0], ComboCode:"|"+jikchakCd[1]});

    // 직위코드(H20030)
    var jikweeCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20030"), "");
    sheet1.SetColProperty("jikweeCd", {ComboText:"|"+jikweeCd[0], ComboCode:"|"+jikweeCd[1]});

	sheet1.SetDataLinkMouse("detail", 1);
	sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

	//------------------------------------- 조회조건 콤보 -------------------------------------//
	// 사업장
	<c:choose>
		<c:when test="${ssnSearchType == 'A'}">
			var tcpn121Cd = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getTcpn121List", false).codeList, "전체");
		</c:when>
		<c:otherwise>
			var tcpn121Cd = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getTcpn121List", false).codeList, "");
		</c:otherwise>
	</c:choose>
	$("#businessPlaceCd").html(tcpn121Cd[2]);

	// 급여유형(H10110)
	var payType = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10110"), "");
	$("#payType").html(payType[2]);
	$("#payType").select2({placeholder:" 선택"});

	// 계약유형코드(H10030)
	var manageCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10030"), "");
	$("#manageCd").html(manageCd[2]);
	$("#manageCd").select2({placeholder:" 선택"});

	// 재직상태코드(H10010)
	var statusCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10010"), "");
	$("#statusCd").html(statusCd[2]);
	$("#statusCd").select2({placeholder:" 선택"});

	//$(window).smartresize(sheetResize);
	sheetInit();

	$("#sabunName").bind("keyup",function(event) {
		if (event.keyCode == 13) {
			//doAction1("Search");
			sabunName();
		}
	});

	// 최근급여일자 조회
	getCpnLatestPaymentInfo();
	//doAction1("SearchBasic");
	doAction1("Search");
});

//필수값/유효성 체크
function chkInVal(sAction) {
	if ($("#payActionCd").val() == "") {
		alert("급여일자를 선택하십시오.");
		$("#payActionNm").focus();
		return false;
	}

	return true;
}

//마감여부 확인
function chkClose() {
	if ($("#closeYn").val() == "Y") {
		alert("마감된 급여일자입니다.");
		return false;
	}

	return true;
}

function doAction1(sAction) {
	switch (sAction) {
		case "SearchBasic":
			doAction1("Clear");

			// 기본사항조회
			var basicInfo = ajaxCall("${ctx}/PayCalcReCre.do?cmd=getPayCalcReCreBasicMap",$("#sheet1Form").serialize(), false);
			if (basicInfo.DATA != null) {
				basicInfo = basicInfo.DATA;
				$("#payYm"			).html(basicInfo.payYm		);
				$("#payNm"			).html(basicInfo.payNm		);
				$("#paymentYmd"		).html(basicInfo.paymentYmd	);
				$("#timeYm"			).html(basicInfo.timeYm		);
				$("#calTaxMethod"	).html(basicInfo.calTaxMethod);
				$("#addTaxRate"		).html(basicInfo.addTaxRate	);
				$("#closeYn"		).val(basicInfo.closeYn		);
			}
			break;

		case "Search":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			// 급여구분별 항목리스트 조회
			searchTitleList();

			$("#multiManageCd").val(getMultiSelect($("#manageCd").val()));
			$("#multiStatusCd").val(getMultiSelect($("#statusCd").val()));
			$("#multiPayType").val(getMultiSelect($("#payType").val()));

			sheet1.DoSearch("${ctx}/PayCalcReCre.do?cmd=getPayCalcReCreList", $("#sheet1Form").serialize());
			break;

		case "ReCre":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}
			// 마감여부 확인
			if (!chkClose()) {
				break;
			}

			var rowCnt = sheet1.RowCount();
			if (rowCnt == 0) {
				alert("조회 후 처리하십시오.");
				return;
			}
			var chkYn = "N";
			for (var i=1; i<=rowCnt; i++) {
				if (sheet1.GetCellValue(i, "reCre") == "1") {
					chkYn = "Y";
					break;
				}
			}
			if (chkYn == "N") {
				alert("재계산 대상을 선택하십시오.");
				return;
			}

			if (confirm("월급여재계산을 실행하시겠습니까?")) {
				// 급여대상자상태 저장후  월급여재계산 호출

				if (sheet1.RowCount("U") > 0 || sheet1.RowCount("I") > 0 ) {
					// 급여대상자상태 저장
					IBS_SaveName(document.sheet1Form,sheet1);
					sheet1.DoSave("${ctx}/PayCalcReCre.do?cmd=savePayCalcReCre", $("#sheet1Form").serialize());
				}

			}
			break;

		case "prcP_CPN_RETRY_PAY_MAIN":
			var payActionCd = $("#payActionCd").val();
			var businessPlaceCd = $("#businessPlaceCd").val();

			// 월급여재계산
			var result = ajaxCall("${ctx}/PayCalcReCre.do?cmd=prcP_CPN_RETRY_PAY_MAIN", "payActionCd="+payActionCd+"&businessPlaceCd="+businessPlaceCd, false);

			if (result != null && result["Result"] != null && result["Result"]["Code"] != null) {
				if (result["Result"]["Code"] == "0") {
					alert("월급여재계산 되었습니다.");
					// 프로시저 호출 후 재조회
					doAction1("SearchBasic");
					doAction1("Search");
				} else if (result["Result"]["Message"] != null && result["Result"]["Message"] != "") {
					alert(result["Result"]["Message"]);
				}
			} else {
				alert("월급여재계산 오류입니다.");
			}
			break;

		case "Clear":
			$("#payYm"			).html("");
			$("#payNm"			).html("");
			$("#paymentYmd"		).html("");
			$("#timeYm"			).html("");
			$("#calTaxMethod"	).html("");
			$("#addTaxRate"		).html("");
			$("#closeYn"		).val("");

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

function sabunName(){
	
	if($("#sabunName").val() == "") return;

	var Row = 0;

	if( sheet1.GetSelectRow() < sheet1.LastRow()){
		Row = sheet1.FindText("name", $("#sabunName").val(), sheet1.GetSelectRow()+1, 2);
	}else{
		Row = -1;
	}
	
	if(Row > 0){
		sheet1.SelectCell(Row,"name");
		$("#sabunName").focus(); 	
	}else if(Row == -1){
		if(sheet1.GetSelectRow() > 1){
			Row = sheet1.FindText("name", $("#sabunName").val(), 1, 2);
			if(Row > 0){
				sheet1.SelectCell(Row,"name");
				$("#sabunName").focus(); 	
			}
		}
	}	
	$("#sabunName").focus(); 		
}

function searchTitleList() {
	// 급여구분별 항목리스트 조회
	var titleList = ajaxCall("${ctx}/PayCalcReCre.do?cmd=getPayCalcReCreTitleList",$("#sheet1Form").serialize(), false);

	if (titleList != null && titleList.DATA != null) {

		// IBSheet에 설정된 모든 기본 속성을 제거하고 초기상태로 변경한다.
		sheet1.Reset();

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad, Page:22, FrozenCol:11};
		initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};

		initdata1.Cols = [];
		initdata1.Cols[0] = {Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" };
		initdata1.Cols[1] = {Header:"삭제",		Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",				Sort:0 };
		initdata1.Cols[2] = {Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",				Sort:0 };
		initdata1.Cols[3] = {Header:"세부\n내역",	Type:"Image",		Hidden:0,					Width:40,			Align:"Center",	ColMerge:0,	SaveName:"detail",				Cursor:"Pointer",	EditLen:1 };
		initdata1.Cols[4] = {Header:"급여계산코드",	Type:"Text",		Hidden:1,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"payActionCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 };
		initdata1.Cols[5] = {Header:"재계산",		Type:"CheckBox",	Hidden:0,					Width:65,			Align:"Center",	ColMerge:0,	SaveName:"reCre",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 };
		initdata1.Cols[6] = {Header:"대상상태",		Type:"Combo",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"payPeopleStatus",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 };
		initdata1.Cols[7] = {Header:"대상상태",		Type:"Text",		Hidden:1,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"payPeopleStatusNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
		initdata1.Cols[8] = {Header:"사번",		Type:"Text",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"sabun",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 };
		initdata1.Cols[9] = {Header:"성명",		Type:"Text",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"name",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
		initdata1.Cols[10] = {Header:"소속",		Type:"Text",		Hidden:0,					Width:120,			Align:"Left",	ColMerge:0,	SaveName:"orgNm",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 };
		initdata1.Cols[11] = {Header:"계약유형",	Type:"Combo",		Hidden:0,				Width:100,			Align:"Center",	ColMerge:0,	SaveName:"manageCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		initdata1.Cols[12] = {Header:"직구분",		Type:"Combo",		Hidden:0,				Width:100,			Align:"Center",	ColMerge:0,	SaveName:"workType",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		initdata1.Cols[13] = {Header:"급여유형",	Type:"Combo",		Hidden:0,				Width:100,			Align:"Center",	ColMerge:0,	SaveName:"payType",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		initdata1.Cols[14] = {Header:"호봉",		Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"salClass",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
		initdata1.Cols[15] = {Header:"직급",		Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 };
		initdata1.Cols[16] = {Header:"입사일",		Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"empYmd",				KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 };
		initdata1.Cols[17] = {Header:"그룹입사일",	Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"gempYmd",				KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 };

		var elementCd = "";
		for(var i=0; i<titleList.DATA.length; i++) {
			elementCd = convCamel(titleList.DATA[i].elementCd);
			initdata1.Cols[i+16] = {Header:titleList.DATA[i].elementNm,Type:"AutoSum",	Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:elementCd,	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
		}
		IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);

		//------------------------------------- 그리드 콤보 -------------------------------------//
		// 직구분코드(H10050)
		var workType = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10050"), "");
		sheet1.SetColProperty("workType", {ComboText:"|"+workType[0], ComboCode:"|"+workType[1]});
		
		// 계약유형코드(H10030)
		var manageCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10030"), "");
		sheet1.SetColProperty("manageCd", {ComboText:"|"+manageCd[0], ComboCode:"|"+manageCd[1]});
		
		// 급여유형코드(H10110)
		var payType = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10110"), "");
		sheet1.SetColProperty("payType", {ComboText:"|"+payType[0], ComboCode:"|"+payType[1]});	
	
		// 급여대상자상태(C00125)
		var payPeopleStatus = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "C00125"), "");
		sheet1.SetColProperty("payPeopleStatus", {ComboText:payPeopleStatus[0], ComboCode:payPeopleStatus[1]});

		// 직급코드(H20010)
		var jikgubCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20010"), "");
		sheet1.SetColProperty("jikgubCd", {ComboText:jikgubCd[0], ComboCode:jikgubCd[1]});

		sheet1.SetDataLinkMouse("detail", 1);
		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
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

//저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try {
		if (parseInt(Code) > 0) {
			// 월급여재계산 호출
			doAction1("prcP_CPN_RETRY_PAY_MAIN");
		} else {
			if (Msg != "") {
				alert(Msg);
			}
		}
	} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}

function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	var colName = sheet1.ColSaveName(Col);

	if (Row > 0 && colName == "detail") {
		var sabun = sheet1.GetCellValue(Row, "sabun");

		// 개인별급여세부내역 호출
		openPerPayPartiAdminStaSubMain(sabun);
	}
}

function sheet1_OnChange(Row, Col, Value) {
	var colName = sheet1.ColSaveName(Col);
	if (Row > 0) {
		if (colName == "reCre") {
			if (sheet1.GetCellValue(Row, "reCre") == "1") {
				// 급여대상자상태(C.대상 E.에러 J.작업완료 M.재계산 P.작업대상 PM.작업대상(재계산) W.미확정)
				if (sheet1.GetCellValue(Row,"payPeopleStatus") == "J") {
					sheet1.SetCellValue(Row, "payPeopleStatus", "M");
				} else {
					sheet1.SetCellValue(Row, "payPeopleStatus", "PM");
				}
				//sheet1.SetCellValue(Row, "payPeopleStatusNm", "");
			} else {
				if (sheet1.GetCellValue(Row,"payPeopleStatus") == "M") {
					sheet1.SetCellValue(Row, "payPeopleStatus", "J");
					//sheet1.SetCellValue(Row, "payPeopleStatusNm", "작업완료");
				} else {
					sheet1.SetCellValue(Row, "payPeopleStatus", "P");
					//sheet1.SetCellValue(Row, "payPeopleStatusNm", "작업대상");
				}
			}
		}
	}
}

// 최근급여일자 조회
function getCpnLatestPaymentInfo() {
	var procNm = "최근급여일자";
	var params = "queryId=getCpnLatestPaymentInfoMap&procNm="+procNm;
	
	if(mode == "retire") {
		params += "&runType=ETC, J0001,R0001,R0003";
		params += "&mode=" + mode;
	} else {
		params += "&runType=00001,00002,00003,ETC, J0001,R0001,R0003";
	}
	// 급여구분(C00001-00001.급여 00002.상여 00003.연월차 R0001.퇴직급여 R0003.퇴직연월차)
	//var paymentInfo = ajaxCall("${ctx}/CpnQuery.do?cmd=getCpnQueryList", "queryId=getCpnLatestPaymentInfoMap&procNm="+procNm+"&runType=00001,00002,00003,R0001,R0003", false);
	var paymentInfo = ajaxCall("${ctx}/PayCalcReCre.do?cmd=getCpnQueryList", params, false);

	if (paymentInfo.DATA != null && paymentInfo.DATA != "" && typeof paymentInfo.DATA[0] != "undefined") {
		$("#payActionCd").val(paymentInfo.DATA[0].payActionCd);
		$("#payActionNm").val(paymentInfo.DATA[0].payActionNm);

		if ($("#payActionCd").val() != null && $("#payActionCd").val() != "") {
			doAction1("SearchBasic");
		}
	} else if (paymentInfo.Message != null && paymentInfo.Message != "") {
		alert(paymentInfo.Message);
	}
}

// 급여일자 검색 팝입
function payActionSearchPopup() {
	let parameters = {
		runType : '00001,00002,00003,R0001,R0003,J0001,ETC'
	};
	if(mode == "retire") {
		parameters.mode = mode;
	}
	let layerModal = new window.top.document.LayerModal({
		id : 'payDayLayer'
		, url : '/PayDayPopup.do?cmd=viewPayDayLayer&authPg=R'
		, parameters : parameters
		, width : 840
		, height : 520
		, title : '<tit:txt mid='payDayPop' mdef='급여일자 조회'/>'
		, trigger :[
			{
				name : 'payDayTrigger'
				, callback : function(result){
					$("#payActionCd").val(result.payActionCd);
					$("#payActionNm").val(result.payActionNm);

					if ($("#payActionCd").val() != null && $("#payActionCd").val() != "") {
						doAction1("SearchBasic");
					}
				}
			}
		]
	});
	layerModal.show();



	// if(!isPopup()) {return;}
	// gPRow = "";
	// pGubun = "payDayPopup";
	//
	// var w	= 900;
	// var h	= 520;
	// var url	= "/PayDayPopup.do?cmd=payDayPopup";
	// var args= new Array();
	// //args["runType"] = "00001,00002,00003,R0001,R0003"; // 급여구분(C00001-00001.급여 00002.상여 00003.연월차 R0001.퇴직급여 R0003.퇴직연월차)
	// args["runType"] = "00001,00002,00003,R0001,R0003,J0001,ETC"; // 급여구분(C00001-00001.급여 00002.상여 00003.연월차 R0001.퇴직급여 R0003.퇴직연월차)
	//
	// if(mode == "retire") {
	// 	args["mode"] = mode;
	// }
	//
	// var result = openPopup(url+"&authPg=R", args, w, h);
	/*
	if (result) {
		var payActionCd	= result["payActionCd"];
		var payActionNm	= result["payActionNm"];

		$("#payActionCd").val(payActionCd);
		$("#payActionNm").val(payActionNm);

		if ($("#payActionCd").val() != null && $("#payActionCd").val() != "") {
			doAction1("SearchBasic");
		}
	}
	*/
}

function getReturnValue(returnValue) {
	var rv = $.parseJSON('{' + returnValue+ '}');

    if(pGubun == "payDayPopup"){

		$("#payActionCd").val(rv["payActionCd"]);
		$("#payActionNm").val(rv["payActionNm"]);

		if ($("#payActionCd").val() != null && $("#payActionCd").val() != "") {
			doAction1("SearchBasic");
		}
    }
}

// 개인별급여세부내역 호출
function openPerPayPartiAdminStaSubMain(sabun) {
	let layerModal = new window.top.document.LayerModal({
		id : 'payPartiTermLayer'
		, url : '${ctx}/PerPayPartiTermUSta.do?cmd=viewPerPayPartiTermAStaLayer&authPg=R'
		, parameters : {
			sabun : sabun
			, payActionCd : $("#payActionCd").val()
		}
		, width : 950
		, height : 550
		, title : '<tit:txt mid='perPayPartiTermAStaPop' mdef='개인별 급여 세부내역'/>'
	});
	layerModal.show();

	<%--if(!isPopup()) {return;}--%>
	<%--gPRow = "";--%>
	<%--pGubun = "viewPerPayPartiTermAStaPopup";--%>

	<%--var w		= 950;--%>
	<%--var h		= 540;--%>
	<%--var url		= "${ctx}/PerPayPartiTermASta.do?cmd=viewPerPayPartiTermAStaPopup";--%>
	<%--var args	= new Array();--%>
	<%--args["payActionCd"]	= $("#payActionCd").val();--%>
	<%--args["sabun"]		= sabun;--%>

	<%--openPopup(url+"&authPg=R", args, w, h);--%>
}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
		<table border="0" cellpadding="0" cellspacing="0" class="default outer">
			<colgroup>
				<col width="15%" />
				<col width="35%" />
				<col width="15%" />
				<col width="35%" />
			</colgroup>
			<tr>
				<th>급여일자</th>
				<td> <input type="hidden" id="payActionCd" name="payActionCd" value="" />
					 <input type="text" id="payActionNm" name="payActionNm" class="text required readonly" value="" readonly style="width:180px" />
					 <a href="javascript:payActionSearchPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
					 <input type="hidden" id="closeYn" name="closeYn" value="" /></td>
				<th>급여구분</th>
				<td id="payNm"> </td>
			</tr>
			<tr>
				<th>대상년월</th>
				<td id="payYm"> </td>
				<th>지급일자</th>
				<td id="paymentYmd"> </td>
			</tr>
			<tr>
				<th>사업장</th>
				<td> <select id="businessPlaceCd" name="businessPlaceCd"> </select> </td>
				<th>근태기준년월</th>
				<td id="timeYm"> </td>
			</tr>
		</table>
		<input type="hidden" id="multiManageCd" name="multiManageCd" value="" />
		<input type="hidden" id="multiStatusCd" name="multiStatusCd" value="" />
		<input type="hidden" id="multiPayType" name="multiPayType" value="" />
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th>계약유형</th>
						<td>  <select id="manageCd" name="manageCd" multiple=""> </select> </td>
						<th>급여유형</th>
						<td>  <select id="payType" name="payType" multiple=""> </select> </td>
						<th>재직상태</th>
						<td>  <select id="statusCd" name="statusCd" multiple=""> </select> </td>
						<th>사번/성명</th>
						<td>  <input type="text" id="sabunName" name="sabunName" class="text" value="" style="ime-mode:active" /> </td>
						<td> <a href="javascript:doAction1('Search')"	class="button authR">조회</a> </td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<div class="outer">
		<div class="sheet_title">
			<ul>
				<li id="txt" class="txt">월급여재계산</li>
				<li class="btn">
					<a href="javascript:doAction1('ReCre')"	class="basic authA">재계산</a>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript">createIBSheet("sheet1", "50%", "100%", "kr"); </script>
</div>
</body>
</html>
