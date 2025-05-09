<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>급/상여대장검색(개인별)</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 급/상여대장검색(개인별)
 * @author JM
-->
<script type="text/javascript">
var columnInfo = "";
$(function() {
	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22, FrozenCol:0};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata1.Cols = [
		{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제",		Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
		{Header:"상태",		Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },
		{Header:"급여년월",	Type:"Date",		Hidden:0,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"payYm",		KeyField:0,	Format:"Ym",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:7 },
		{Header:"급여일자",	Type:"Text",		Hidden:1,					Width:120,			Align:"Center",	ColMerge:0,	SaveName:"payActionNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"소속",		Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"사번",		Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"성명",		Type:"Text",		Hidden:0,					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"영문약자",	Type:"Text",		Hidden:1,					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"alias",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"직책",		Type:"Combo",		Hidden:0,					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"jikchakCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		//{Header:"직위",		Type:"Combo",		Hidden:Number("${jwHdn}"),					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		//{Header:"직급",		Type:"Combo",		Hidden:Number("${jgHdn}"),					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"사업장",		Type:"Combo",	Hidden:0,					Width:120,			Align:"Center",	ColMerge:0,	SaveName:"bpCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"코스트센터",	Type:"Combo",	Hidden:0,					Width:120,			Align:"Center",	ColMerge:0,	SaveName:"ccCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"급여유형",		Type:"Combo",	Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"payType",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },				
		{Header:"직위",			Type:"Combo",	Hidden:0,					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"직급",			Type:"Combo",	Hidden:0,					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"호봉",			Type:"Text",	Hidden:0,					Width:60,			Align:"Center", ColMerge:0, SaveName:"salClass",	KeyField:0,	Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
		{Header:"계약유형",		Type:"Combo",	Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"manageCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"직구분",		Type:"Combo",	Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"workType",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"재직상태",		Type:"Combo",	Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"statusCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"입사일",		Type:"Date",	Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"empYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"그룹입사일",	Type:"Date",	Hidden:1,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"gempYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"퇴사일",		Type:"Date",	Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"retYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"근무지",		Type:"Combo",	Hidden:1,					Width:100,			Align:"Left",	ColMerge:0,	SaveName:"locationCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 }
	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);

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

	// 급여구분(TCPN051)
	var payCd = convCode(ajaxCall("${ctx}/PaySearchSta.do?cmd=getPaySearchStaCpnPayCdList", "", false).codeList, "");
	$("#payCd").html(payCd[2]);
	$("#payCd").select2({placeholder:""});
	$("#payCd").select2("val", ["11"]);

 	//$(window).smartresize(sheetResize);
	sheetInit();

	$("#sabunName").bind("keyup",function(event) {
		if (event.keyCode == 13) {
			doAction1("Search");
		}
	});
	
	$("#searchPaymentYmd").datepicker2();

	$("#fromPayYm").datepicker2({ymonly:true, onReturn: getCommonComboList});
	$("#toPayYm").datepicker2({ymonly:true, onReturn: getCommonComboList});
	$("#fromPayYm").val("${curSysYyyyMMHyphen}");
	$("#toPayYm").val("${curSysYyyyMMHyphen}");

	$("#fromPayYm, #toPayYm").bind("keyup",function(event){
		if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
	});

	getCommonComboList();

});

function getCommonComboList() {
	let baseSYmd = "";
	let baseEYmd = "";

	if ($("#fromPayYm").val() !== "" && $("#toPayYm").val() !== "") {
		baseSYmd = $("#fromPayYm").val() + "-01";
		baseEYmd = getLastDayOfMonth($("#toPayYm").val());
	}

	// 재직상태코드(H10010)
	var statusCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10010", baseSYmd, baseEYmd), "");
	$("#statusCd").html(statusCd[2]);
	$("#statusCd").select2({placeholder:" 선택"});

	// 직구분(H10050)
	var workType = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10050", baseSYmd, baseEYmd), "");
	$("#workType").html(workType[2]);
	$("#workType").select2({placeholder:" 선택"});

	// 계약유형코드(H10030)
	var manageCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10030", baseSYmd, baseEYmd), "");
	$("#manageCd").html(manageCd[2]);
	$("#manageCd").select2({placeholder:" 선택"});

	// 급여출력구분(C00300)
	var reportYn = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "C00300", baseSYmd, baseEYmd), "");
	$("#reportYn").html(reportYn[2]);

	//직급
	var jikgubCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20010", baseSYmd, baseEYmd), "");
	$("#jikgubCd").html(jikgubCd[2]);
	$("#jikgubCd").select2({placeholder:" 선택"});

	//급여유형
	var payType = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10110", baseSYmd, baseEYmd), "");
	$("#payType").html(payType[2]);
	$("#payType").select2({placeholder:" 선택"});

	//호봉
	var salClass = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "C10000", baseSYmd, baseEYmd), "");
	$("#salClass").html(salClass[2]);
	$("#salClass").select2({placeholder:" 선택"});
}

function getLastDayOfMonth(yearMonth) {
	const [year, month] = yearMonth.split('-').map(Number);
	const lastDate = new Date(year, month, 0);

	const yearStr = lastDate.getFullYear().toString();
	const monthStr = (lastDate.getMonth() + 1).toString().padStart(2, '0');
	const dayStr = lastDate.getDate().toString().padStart(2, '0');

	return yearStr + '-' + monthStr + '-' + dayStr;
}

// 필수값/유효성 체크
function chkInVal(sAction) {
	if ($("#fromPayYm").val() == "") {
		alert("급여년월을 선택하십시오.");
		$("#fromPayYm").focus();
		return false;
	}
	if ($("#toPayYm").val() == "") {
		alert("급여년월을 선택하십시오.");
		$("#toPayYm").focus();
		return false;
	}
	if (!checkFromToDate($("#fromPayYm"),$("#toPayYm"),"급여년월","급여년월","YYYYMM")) {
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


			$("#multiPayCd").val(getMultiSelect($("#payCd").val()));

			// 급여구분별 항목리스트 조회
			searchTitleList();

			$("#multiStatusCd").val(getMultiSelect($("#statusCd").val()));
			$("#multiWorkType").val(getMultiSelect($("#workType").val()));
			$("#multiManageCd").val(getMultiSelect($("#manageCd").val()));
			
			$("#multiJikgubCd").val(getMultiSelect($("#jikgubCd").val()));
			$("#multiPayType").val(getMultiSelect($("#payType").val()));
			$("#multiSalClass").val(getMultiSelect($("#salClass").val()));
			
			
			// 개인별 합계할지 여부
			if ($("#sumYn").val() == "Y") {
				sheet1.SetColHidden("payYm",1);
				sheet1.SetColHidden("payActionNm",1);
			}else if ($("#sumYn").val() == "M") {
				sheet1.SetColHidden("payYm",0);
				sheet1.SetColHidden("payActionNm",1);
			}else{
				$("#sumYn").val("");
				sheet1.SetColHidden("payYm",1);
				sheet1.SetColHidden("payActionNm",0);
			}

			var info = [{StdCol:5, SumCols:columnInfo, CaptionCol:5}];
			if ($("#subSumYnCheckbox").is(":checked")) {
				sheet1.ShowSubSum(info);
			} else {
				sheet1.HideSubSum(info);
			}
			getCommonCodeList();

			sheet1.DoSearch("${ctx}/PaySearchSta.do?cmd=getPaySearchStaList", $("#sheet1Form").serialize());
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

function searchTitleList() {
	// 급여구분별 항목리스트 조회
	var titleList = ajaxCall("${ctx}/PaySearchSta.do?cmd=getPaySearchStaTitleList", $("#sheet1Form").serialize(), false);

	if (titleList != null && titleList.DATA != null) {

		// IBSheet에 설정된 모든 기본 속성을 제거하고 초기상태로 변경한다.
		sheet1.Reset();

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad, Page:22, FrozenCol:8};
		initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};

		initdata1.Cols = [];
		initdata1.Cols[0] = {Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" };
		initdata1.Cols[1] = {Header:"삭제",		Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 };
		initdata1.Cols[2] = {Header:"상태",		Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 };
		initdata1.Cols[3] = {Header:"급여년월",	Type:"Date",		Hidden:0,					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"payYm",		KeyField:0,	Format:"Ym",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:7 };
		initdata1.Cols[4] = {Header:"급여일자",	Type:"Text",		Hidden:1,					Width:120,			Align:"Left",	ColMerge:0,	SaveName:"payActionNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
		initdata1.Cols[5] = {Header:"소속",		Type:"Text",		Hidden:0,					Width:120,			Align:"Left",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
		initdata1.Cols[6] = {Header:"사번",		Type:"Text",		Hidden:0,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 };
		initdata1.Cols[7] = {Header:"성명",		Type:"Text",		Hidden:0,					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
		initdata1.Cols[8] = {Header:"영문약자",	Type:"Text",		Hidden:1,					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"empAlias",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
		initdata1.Cols[9] = {Header:"직책",		Type:"Combo",		Hidden:0,					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"jikchakCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 };
		initdata1.Cols[10] = {Header:"사업장",	Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"bpCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 };
		initdata1.Cols[11] = {Header:"코스트센터",	Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"ccCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 };
		initdata1.Cols[12] = {Header:"급여유형",	Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"payType",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 };		
		initdata1.Cols[13] = {Header:"직위",		Type:"Combo",		Hidden:0,					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 };
		initdata1.Cols[14] = {Header:"직급",		Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 };		
		initdata1.Cols[15] = {Header:"호봉",        Type:"Text",		Hidden:0,				Width:60,   Align:"Center",    ColMerge:0,   SaveName:"salClass",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
		initdata1.Cols[16] = {Header:"계약유형",	Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"manageCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 };
		initdata1.Cols[17] = {Header:"직구분",		Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"workType",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 };
		initdata1.Cols[18] = {Header:"재직상태",	Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"statusCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 };
		initdata1.Cols[19] = {Header:"입사일",	Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"empYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 };
		initdata1.Cols[20] = {Header:"그룹입사일",Type:"Date",			Hidden:1,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"gempYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 };
		initdata1.Cols[21] = {Header:"퇴사일",	Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"retYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 };
		initdata1.Cols[22] = {Header:"근무지",	Type:"Combo",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"locationCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 };

		var elementCd = "";
		columnInfo = "";
		for(var i=0; i<titleList.DATA.length; i++) {
			elementCd = convCamel(titleList.DATA[i].elementCd);
			initdata1.Cols[i+19] = {Header:titleList.DATA[i].elementNm,Type:"AutoSum",	Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:elementCd,	KeyField:0,	Format:"NullInteger",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
			if(i > 0) columnInfo = columnInfo + "|";
			columnInfo = columnInfo+(i+19);
		}
		IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);
		//$(window).smartresize(sheetResize);
		
		
		//sheetInit();


	}
}

function getCommonCodeList() {
	let baseSYmd = $("#fromPayYm").val() + "-01";
	let baseEYmd = getLastDayOfMonth($("#toPayYm").val());
	//------------------------------------- 그리드 콤보 -------------------------------------//
	// 직구분코드(H10050)
	var workType = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10050", baseSYmd, baseEYmd), "");
	sheet1.SetColProperty("workType", {ComboText:"|"+workType[0], ComboCode:"|"+workType[1]});

	// 직급코드(H20010)
	var jikgubCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20010", baseSYmd, baseEYmd), "");
	sheet1.SetColProperty("jikgubCd", {ComboText:"|"+jikgubCd[0], ComboCode:"|"+jikgubCd[1]});

	// 직책코드(H20020)
	var jikchakCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20020", baseSYmd, baseEYmd), "");
	sheet1.SetColProperty("jikchakCd", {ComboText:"|"+jikchakCd[0], ComboCode:"|"+jikchakCd[1]});

	// 직위코드(H20030)
	var jikweeCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20030", baseSYmd, baseEYmd), "");
	sheet1.SetColProperty("jikweeCd", {ComboText:"|"+jikweeCd[0], ComboCode:"|"+jikweeCd[1]});

	// 계약유형코드(H10030)
	var manageCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10030", baseSYmd, baseEYmd), "");
	sheet1.SetColProperty("manageCd", {ComboText:"|"+manageCd[0], ComboCode:"|"+manageCd[1]});

	// 재직상태코드(H10010)
	var statusCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10010", baseSYmd, baseEYmd), "");
	sheet1.SetColProperty("statusCd", {ComboText:"|"+statusCd[0], ComboCode:"|"+statusCd[1]});

	// 급여유형코드(H10110)
	var payType = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10110", baseSYmd, baseEYmd), "");
	sheet1.SetColProperty("payType", {ComboText:"|"+payType[0], ComboCode:"|"+payType[1]});

	// 근무지(TSYS015)
	var tsys015Cd = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getLocationCdList", false).codeList, "");
	sheet1.SetColProperty("locationCd", {ComboText:"|"+tsys015Cd[0], ComboCode:"|"+tsys015Cd[1]});

	// 코스트센터(TORG109)
	var torg109Cd = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&mapTypeCd=300", "queryId=getTorg109List", false).codeList, "");
	sheet1.SetColProperty("ccCd", {ComboText:"|"+torg109Cd[0], ComboCode:"|"+torg109Cd[1]});

	// 사업장(TCPN121)
	var tcpn121Cd = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getTcpn121List", false).codeList, "");
	sheet1.SetColProperty("bpCd", {ComboText:"|"+tcpn121Cd[0], ComboCode:"|"+tcpn121Cd[1]});
}
// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") {
			alert(Msg);
		}

		//sheetResize();
	} catch (ex) {
		alert("OnSearchEnd Event Error : " + ex);
	}
}

//  소속 팝업
function orgSearchPopup(){
    try{
		if(!isPopup()) {return;}
		gPRow = "";
		pGubun = "orgBasicPopup";

		const p = {runType: "00001,00002,00003,R0001,R0002,R0003"}
		let layerModal = new window.top.document.LayerModal({
			id : 'orgLayer'
			, url : '/Popup.do?cmd=viewOrgBasicLayer&authPg=${authPg}'
			, parameters : p
			, width : 740
			, height : 520
			, title : '<tit:txt mid='orgSchList' mdef='조직 리스트 조회'/>'
			, trigger :[
				{
					name : 'orgTrigger'
					, callback : function(result){
						if(!result.length) return;
						$("#searchOrgNm").val(result[0].orgNm);
						$("#searchOrgCd").val(result[0].orgCd);
					}
				}
			]
		});
		layerModal.show();
    }catch(ex){alert("Open Popup Event Error : " + ex);}
}

function getReturnValue(returnValue) {
	var rv = returnValue;
}

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form">
		<input type="hidden" id="multiPayCd" name="multiPayCd" value="" />
		<input type="hidden" id="multiStatusCd" name="multiStatusCd" value="" />
		<input type="hidden" id="multiWorkType" name="multiWorkType" value="" />
		<input type="hidden" id="multiManageCd" name="multiManageCd" value="" />
		
		<input type="hidden" id="multiJikgubCd" name="multiJikgubCd" value="" />
		<input type="hidden" id="multiPayType" name="multiPayType" value="" />
		<input type="hidden" id="multiSalClass" name="multiSalClass" value="" />
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th>급여년월</th>
						<td>
							<input type="text" id="fromPayYm" name="fromPayYm" class="date2 required" /> ~ <input type="text" id="toPayYm" name="toPayYm" class="date2 required" />
						</td>
						<th>사업장</th>
						<td><select id="businessPlaceCd" name="businessPlaceCd"> </select></td>
						<th>급여구분</th>
						<td><select id="payCd" name="payCd" multiple> </select></td>
						<th>합계</th>
						<td><select id="sumYn" name="sumYn"><option value="">미적용</option><option value="Y">전체</option><option value="M">월별</option></select></td>
						<th>출력구분</th>
						<td><select id="reportYn" name="reportYn"></select></td>
					</tr>
					<tr>
						<th>직구분</th>
						<td><select id="workType" name="workType" multiple=""></select></td>
						<th>계약유형</th>
						<td><select id="manageCd" name="manageCd" multiple=""></select></td>
						<th>재직상태</th>
						<td><select id="statusCd" name="statusCd" multiple=""></select></td>
						<th>사번/성명</th>
						<td><input type="text" id="sabunName" name="sabunName" class="text" value="" style="ime-mode:active" /></td>
						<th>소속별<br/>소계</th>
						<td><input type="checkbox" id="subSumYnCheckbox" name="subSumYnCheckbox" /><input type="hidden" id="subSumYn" name="subSumYn" value="" /></td>
					</tr>
					<tr>
						<th>직급</th>
						<td><select id="jikgubCd" name="jikgubCd" multiple=""> </select></td>
						<th>급여유형</th>
						<td><select id="payType" name="payType" multiple=""> </select></td>
						<th>호봉</th>
						<td><select id="salClass" name="salClass" multiple=""> </select></td>
						<th>급여일자</th>
						<td><input type="text" id="searchPaymentYmd" name="searchPaymentYmd" class="date2" /></td>
						<th>소속 </th>
						<td>
							<input type="hidden" id="searchOrgCd" name="searchOrgCd" />
							<input id="searchOrgNm" name ="searchOrgNm" type="text" class="text readonly" readOnly style="width:148px"/>
							<a onclick="javascript:orgSearchPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
							<a onclick="$('#searchOrgCd,#searchOrgNm').val('');" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
						</td>
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
							<li id="txt" class="txt">급/상여대장검색(개인별)</li>
							<li class="btn">
								<a href="javascript:doAction1('Search')" class="button authR">조회</a>
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