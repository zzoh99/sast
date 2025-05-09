<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>급여계산</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 급여계산
 * @author JM
-->
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
var mode = "";
<c:if test="${ !empty param.mode }">
	mode = "${param.mode}";
</c:if>
var isLayerShow = false;
var interval;

$(function() {
	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};
	initdata1.Cols = [
		{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제",		Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",			Sort:0 },
		{Header:"상태",		Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",			Sort:0 },
		{Header:"사업장",		Type:"Combo",		Hidden:0,					Width:120,			Align:"Center",	ColMerge:0,	SaveName:"businessPlaceCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"복리후생업무구분", Type:"Combo",     Hidden:0,  					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"benefitBizCd",	KeyField:0, Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
		{Header:"마감상태",		Type:"Combo",		Hidden:0,					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"closeSt",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"최종작업시간",	Type:"Text",		Hidden:0,	Width:150,			Align:"Center",	ColMerge:0,	SaveName:"chkdate",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },
		{Header:"연계처리",		Type:"CheckBox",	Hidden:1,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 }
	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);
	
	//------------------------------------- 그리드 콤보 -------------------------------------//
<c:choose>
	<c:when test="${ssnSearchType == 'A'}">
		var tcpn121Cd = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getTcpn121List", false).codeList, "전체");
	</c:when>
	<c:otherwise>
		var tcpn121Cd = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getTcpn121List", false).codeList, "");
	</c:otherwise>
</c:choose>
	sheet1.SetColProperty("businessPlaceCd", {ComboText:tcpn121Cd[0], ComboCode:tcpn121Cd[1]});

	//복리후생업무구분(B10230)
	var benefitBizCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","B10230"), "");
	sheet1.SetColProperty("benefitBizCd", {ComboText:benefitBizCdList[0], ComboCode:benefitBizCdList[1]} );

	// 마감상태코드(S90003)
	var closeSt = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "S90003"), "");
	sheet1.SetColProperty("closeSt", {ComboText:closeSt[0], ComboCode:closeSt[1]});

	var initdata2 = {};
	initdata2.Cfg = {SearchMode:smLazyLoad, Page:10, SmartResize:1, FrozenCol:10, SizeMode:0, MergeSheet:msHeaderOnly};
	initdata2.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};
	initdata2.Cols = [
		{Header:"No|No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제|삭제",				Type:"${sDelTy}",	Hidden:0,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
		{Header:"상태|상태",				Type:"${sSttTy}",	Hidden:0,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
		{Header:"급여계산코드|급여계산코드",	Type:"Text",		Hidden:1,					Width:100,			Align:"Left",	ColMerge:0,	SaveName:"payActionCd",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"작업\n대상|작업\n대상",	Type:"CheckBox",	Hidden:1,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"payPeopleStatus",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
		{Header:"작업|작업",				Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"payPeopleStatusText",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"계산/취소|계산/취소",		Type:"Html",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"btnPrt",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"급여사업장|급여사업장",	Type:"Combo",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"businessPlaceCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"사번|사번",				Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"sabun",				KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"성명|성명",				Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"name",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"최종작업시간|최종작업시간",	Type:"Text",		Hidden:0,	Width:150,			Align:"Center",	ColMerge:0,	SaveName:"chkdate",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },
		{Header:"주민번호|주민번호",		Type:"Text",		Hidden:1,					Width:120,			Align:"Center",	ColMerge:0,	SaveName:"resNo",				KeyField:0,	Format:"IdNo",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"소속|소속",				Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"orgNm",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"코스트센터|코스트센터",	Type:"Combo",		Hidden:0,					Width:120,			Align:"Center",	ColMerge:0,	SaveName:"ccCd",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },

		// 구분(A : 입사, B : 퇴사, C : 부서이동, D : 보직임명, E : 보직해제, F ; 휴직, G : 복직, H : 산전후휴가, I : 임금피크제, J : 징계)
		{Header:"일할계산 사항|입사",		Type:"CheckBox", Hidden:0, 	Width:60, Align:"Center",	ColMerge:0,	SaveName:"calcYnA", KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100, HeaderCheck: 0, TrueValue: "Y", FalseValue: "N" },
		{Header:"일할계산 사항|퇴사",		Type:"CheckBox", Hidden:0,	Width:60, Align:"Center",	ColMerge:0,	SaveName:"calcYnB", KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100, HeaderCheck: 0, TrueValue: "Y", FalseValue: "N" },
		{Header:"일할계산 사항|부서이동",	Type:"CheckBox", Hidden:0, 	Width:60, Align:"Center",	ColMerge:0,	SaveName:"calcYnC", KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100, HeaderCheck: 0, TrueValue: "Y", FalseValue: "N" },
		{Header:"일할계산 사항|보직임명",	Type:"CheckBox", Hidden:0, 	Width:60, Align:"Center",	ColMerge:0,	SaveName:"calcYnD", KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100, HeaderCheck: 0, TrueValue: "Y", FalseValue: "N" },
		{Header:"일할계산 사항|보직해제",	Type:"CheckBox", Hidden:0, 	Width:60, Align:"Center",	ColMerge:0,	SaveName:"calcYnE", KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100, HeaderCheck: 0, TrueValue: "Y", FalseValue: "N" },
		{Header:"일할계산 사항|휴직",		Type:"CheckBox", Hidden:0,	Width:60, Align:"Center",	ColMerge:0,	SaveName:"calcYnF", KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100, HeaderCheck: 0, TrueValue: "Y", FalseValue: "N" },
		{Header:"일할계산 사항|복직",		Type:"CheckBox", Hidden:0, 	Width:60, Align:"Center",	ColMerge:0,	SaveName:"calcYnG", KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100, HeaderCheck: 0, TrueValue: "Y", FalseValue: "N" },
		{Header:"일할계산 사항|산전후휴가",	Type:"CheckBox", Hidden:0,	Width:60, Align:"Center",	ColMerge:0,	SaveName:"calcYnH", KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100, HeaderCheck: 0, TrueValue: "Y", FalseValue: "N" },
		{Header:"일할계산 사항|임금피크제",	Type:"CheckBox", Hidden:0,	Width:60, Align:"Center",	ColMerge:0,	SaveName:"calcYnI", KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100, HeaderCheck: 0, TrueValue: "Y", FalseValue: "N" },
		{Header:"일할계산 사항|징계",		Type:"CheckBox", Hidden:0,	Width:60, Align:"Center",	ColMerge:0,	SaveName:"calcYnJ", KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100, HeaderCheck: 0, TrueValue: "Y", FalseValue: "N" },

		{Header:"급여유형|급여유형",		Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"payType",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"호봉|호봉",				Type:"Text",		Hidden:0,				Width:60,			Align:"Center",	ColMerge:0,	SaveName:"salClass",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"직위|직위",				Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"직책|직책",				Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikchakCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"직급|직급",				Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"직무|직무",				Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jobNm",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"직구분|직구분",			Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"workType",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"계약유형|계약유형",		Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"manageCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"재직상태|재직상태",		Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"statusCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"입사일|입사일",			Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"empYmd",				KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"그룹입사일|그룹입사일",	Type:"Date",		Hidden:1,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"gempYmd",				KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"퇴사일|퇴사일",			Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"retYmd",				KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"변경전급여대상자상태|변경전급여대상자상태",	Type:"Text",	Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"oldPayPeopleStatus",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"계산상태|계산상태",		Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"status",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
	]; IBS_InitSheet(sheet2, initdata2); sheet2.SetCountPosition(4);sheet2.SetEditable(true);

	//------------------------------------- 그리드 콤보 -------------------------------------//
	// 직구분코드(H10050)
	var workType = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10050"), "");
	sheet2.SetColProperty("workType", {ComboText:"|"+workType[0], ComboCode:"|"+workType[1]});

	// 직책코드(H20020)
	var jikchakCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20020"), "");
	sheet2.SetColProperty("jikchakCd", {ComboText:"|"+jikchakCd[0], ComboCode:"|"+jikchakCd[1]});
	
	// 직급코드(H20010)
	var jikgubCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20010"), "");
	sheet2.SetColProperty("jikgubCd", {ComboText:"|"+jikgubCd[0], ComboCode:"|"+jikgubCd[1]});

	// 직위코드(H20030)
	var jikweeCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20030"), "");
	sheet2.SetColProperty("jikweeCd", {ComboText:"|"+jikweeCd[0], ComboCode:"|"+jikweeCd[1]});

	// 계약유형코드(H10030)
	var manageCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10030"), "");
	sheet2.SetColProperty("manageCd", {ComboText:"|"+manageCd[0], ComboCode:"|"+manageCd[1]});
	
	// 급여유형코드(H10110)
	var payType = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10110"), "");
	sheet2.SetColProperty("payType", {ComboText:"|"+payType[0], ComboCode:"|"+payType[1]});	

	// 재직상태코드(H10010)
	var statusCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10010"), "");
	sheet2.SetColProperty("statusCd", {ComboText:"|"+statusCd[0], ComboCode:"|"+statusCd[1]});

	// 사업장(TCPN121)
	sheet2.SetColProperty("businessPlaceCd", {ComboText:"|"+tcpn121Cd[0], ComboCode:"|"+tcpn121Cd[1]});

	// 코스트센터(TORG109)
	var torg109Cd = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&mapTypeCd=300", "queryId=getTorg109List", false).codeList, "");
	sheet2.SetColProperty("ccCd", {ComboText:"|"+torg109Cd[0], ComboCode:"|"+torg109Cd[1]});
	
	//------------------------------------- 조회조건 콤보 -------------------------------------//
	// 사업장(TCPN121)
	$("#businessPlaceCd").html(tcpn121Cd[2]);
	
	$(window).smartresize(sheetResize);
	$(window).smartresize(setSheet1Height);
	setSheet1Height();
	sheetInit();

	$("#businessPlaceCd").change(function(){
		doAction1("SearchPeople");
		doAction1("Search");
	});

	// 최근급여일자 조회
	getCpnLatestPaymentInfo();
	
	$("#sheet2Form #sabunName").bind("keyup",function(event){
		if (event.keyCode == 13) {
			//doAction2("Search"); 
			sabunName();
		}
	});

	//Autocomplete
	$(sheet2).sheetAutocomplete({
		Columns: [
			{
				ColSaveName  : "name",
				CallbackFunc : function(returnValue) {
					var rv = $.parseJSON('{' + returnValue+ '}');

					sheet2.SetCellValue(gPRow, "name",		rv["name"] );
					sheet2.SetCellValue(gPRow, "sabun",		rv["sabun"] );
					sheet2.SetCellValue(gPRow, "orgNm",		rv["orgNm"] );
					sheet2.SetCellValue(gPRow, "workType",	rv["workType"] );
					sheet2.SetCellValue(gPRow, "jikchakCd",	rv["jikchakCd"] );
					sheet2.SetCellValue(gPRow, "jikweeCd",	rv["jikweeCd"] );
					sheet2.SetCellValue(gPRow, "jikgubCd",	rv["jikgubCd"] );
					sheet2.SetCellValue(gPRow, "payType",	rv["payType"] );

					sheet2.SetCellValue(gPRow, "manageCd",	rv["manageCd"] );
					sheet2.SetCellValue(gPRow, "statusCd",	rv["statusCd"] );
					sheet2.SetCellValue(gPRow, "empYmd",	rv["empYmd"] );
					sheet2.SetCellValue(gPRow, "gempYmd",	rv["gempYmd"] );
					sheet2.SetCellValue(gPRow, "resNo",	rv["resNo"] );
					sheet2.SetCellValue(gPRow, "businessPlaceCd",	rv["businessPlaceCd"] );
					sheet2.SetCellValue(gPRow, "ccCd",	rv["ccCd"] );
					sheet2.SetCellValue(gPRow, "jobNm",	rv["jobNm"] );
				}
			}
		]
	});
});

// 필수값/유효성 체크
function chkInVal(sAction) {
	if ($("#payActionCd").val() == "") {
		alert("급여일자를 선택하십시오.");
		$("#payActionNm").focus();
		return false;
	}

	return true;
}

// 마감여부 확인
function chkClose() {
	if ($("#payCalcCloseYn").is(":checked") == true) {
		alert("이미 마감되었습니다.");
		return false;
	}

	return true;
}

function doAction1(sAction) {
	switch (sAction) {
		case "SearchBasic":
			// 기본사항조회
			var basicInfo = ajaxCall("${ctx}/PayCalcCre.do?cmd=getPayCalcCreBasicMap", $("#sheet1Form").serialize(), false);

			$("#payYm"			).html("");
			$("#payNm"			).html("");
			$("#ordYmd"			).html("");
			$("#paymentYmd"		).html("");
			$("#timeYm"			).html("");
			$("#calTaxMethod"	).html("");
//			$("#addTaxRate"		).html("");
			$("#payCd"			).val("");
			$("#payCalcCloseYn").attr("checked",false);

			if (basicInfo.DATA != null) {
				basicInfo = basicInfo.DATA;
				$("#payYm"			).html(basicInfo.payYm		);
				$("#payNm"			).html(basicInfo.payNm		);
				$("#ordYmd"			).html(basicInfo.ordYmd		);
				$("#paymentYmd"		).html(basicInfo.paymentYmd	);
				$("#timeYm"			).html(basicInfo.timeYm		);
				$("#calTaxMethod"	).html(basicInfo.calTaxMethod);
//				$("#addTaxRate"		).html(basicInfo.addTaxRate	);
				$("#payCd"			).val(basicInfo.payCd);
				if (basicInfo.closeYn == "Y") {
					$("#payCalcCloseYn").attr("checked",true);
				}
			}
			break;

	case "PrcP_BEN_PAY_DATA_CREATE_ALL":
			// 필수값/유효성 체크
			if (!chkInVal2(sAction)) {
				break;
			}
			// 마감여부 확인
			if (!chkClose2()) {
				break;
			}
			
			if ($("#sheet2Form #empStatus").val() != "10005") {

				if (confirm("모든 복리후생 연계자료의 마감이 취소되고 재생성됩니다. 복리후생 데이터 생성작업을 실행하시겠습니까?")) {

					progressBar(true, "복리후생 연계자료 생성중입니다.");

					var payActionCd = $("#sheet2Form #s2_payActionCd").val();
					ajaxCall2("${ctx}/PayCalcCre.do?cmd=prcP_BEN_PAY_DATA_CREATE_ALL"
							, "payActionCd="+payActionCd
							, true
							, null
							, function(data) {
								progressBar(false);
								if (data && data.Result && data.Result.Code) {
									if (data.Result.Code === "0") {
										alert("복리후생 연계자료의 생성이 완료되었습니다. 반드시 급여를 계산하시기 바랍니다.");
										doAction1("Search");
										peopleCnt();
									} else if (data.Result.Message) {
										alert(data.Result.Message);
									}
								} else {
									alert("복리후생 연계자료 생성 오류입니다.");
								}
							}, function() {
								progressBar(false);
							})
				}
			} else {
				alert("급여가 이미 마감되었습니다.\n 급여마감을 취소한 후 복리후생 연계작업이 가능합니다.");
			}
			break;
			
		case "SearchPeople":
			// 인원정보 조회
			var peopleInfo = ajaxCall("${ctx}/PayCalcCre.do?cmd=getPayCalcCrePeopleMap", $("#sheet1Form").serialize(), false);
			$("#peopleTotCnt"	).html("");
			$("#peopleSubCnt"	).html("");
//			$("#peoplePCnt"		).html("");
			$("#peopleJCnt"		).html("");

			//alert(JSON.stringify(peopleInfo));

			if (peopleInfo.DATA != null) {
				peopleInfo = peopleInfo.DATA;
				$("#peopleTotCnt"	).html(peopleInfo.peopleTotCnt);
				$("#peopleSubCnt"	).html(peopleInfo.peopleSubCnt);
//				$("#peoplePCnt"		).html(peopleInfo.peoplePCnt);
				$("#peopleJCnt"		).html(peopleInfo.peopleJCnt);

				if ( peopleInfo.cnt ) {
					$("#payErrCnt").html(peopleInfo.cnt);
				}else{
					$("#payErrCnt").html("0");
				}
				if ( peopleInfo.workCloseYn != null){
					$("#workCloseYn").val(peopleInfo.workCloseYn);
				}else{
					$("#workCloseYn").val("");
				}
				if ( peopleInfo.workStatus != null){
					$("#workStatus").val(peopleInfo.workStatus);
				}else{
					$("#workStatus").val("");
				}
			}

			break;

		case "Search":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			// 마감현황 조회
			sheet1.DoSearch("${ctx}/PayCalcCre.do?cmd=getPayCalcCreCloseList", $("#sheet1Form").serialize());
			break;

		case "PrcP_CPN_CAL_PAY_MAIN":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}
			// 마감여부 확인
			if (!chkClose()) {
				break;
			}
/*
			if ($("#peopleTotCnt").html() == null || $("#peopleTotCnt").html() == "" || $("#peopleTotCnt").html() == "0") {
				alert("총인원을 확인하십시오.");
				break;
			}

			if ($("#peoplePCnt").html() == null || $("#peoplePCnt").html() == "" || $("#peoplePCnt").html() == "0") {
				alert("작업대상 인원을 확인하십시오.");
				break;
			}

			if ($("#peopleJCnt").html() != null && $("#peopleJCnt").html() != "") {
				if (parseInt($("#peopleJCnt").html()) > 0) {
					alert("작업완료인원이 존재합니다.\n작업취소후 작업하실 수 있습니다.");
					break;
				}
			}
			*/
			if (confirm("[급여계산] 작업을 수행하시겠습니까?")) {

				//작업중인 급여 로그가 있는지 확인
				var ingYn = ajaxCall("/CommonCode.do?cmd=getCommonNSCodeList&searchBizCd=CPN&searchPrgCd=P_CPN_CAL_PAY_MAIN&searchPayActionCd="+$("#payActionCd").val(), "queryId=getPayCalcMsgYn", false) ;
				if( ingYn.codeList[0].code != null && ingYn.codeList[0].code == "N" ) {
					if( confirm("이미 실행중입니다.\nClear 후 진행하시겠습니까?") ) {
						//작업중이던 급여 로그를 강제 삭제 후 실행
						ajaxCall("/PayCalcCre.do?cmd=deleteTSYS904ForPayCalcCre&searchBizCd=CPN&searchPrgCd=P_CPN_CAL_PAY_MAIN&searchPayActionCd="+$("#payActionCd").val(), "queryId=deleteTSYS904ForPayCalcCre", false) ;
					} else {
						return ;
					}
				}

				var payActionCd = $("#payActionCd").val();
				var businessPlaceCd = $("#businessPlaceCd").val();

				// 진행상태 팝업 OPEN
				openProcessBar("1");

				$.ajax({
					url : "${ctx}/PayCalcCre.do?cmd=prcP_CPN_CAL_PAY_MAIN",
					type : "post",
					dataType : "json",
					async : true,
					data : "payActionCd="+payActionCd+"&businessPlaceCd="+businessPlaceCd,
					success : function(result) {

						if (result != null && result["Result"] != null && result["Result"]["Code"] != null) {
							if (result["Result"]["Code"] == "0") {
								interval = setInterval(chkLayerShow, 1000, "급여계산 되었습니다.", 500, globalWindowPopup, function(){doAction1("SearchPeople"); doAction2("Search");})
								//alertTimer("급여계산 되었습니다.", 1000, globalWindowPopup, function(){globalWindowPopup.close(); doAction1("SearchPeople");});
							} else if (result["Result"]["Message"] != null && result["Result"]["Message"] != "") {
								alertTimer(result["Result"]["Message"], 1000);
							}
						} else {
							alertTimer("급여계산 오류입니다.", 1000);
						}
						doAction2("Search");
					},
					error : function(jqXHR, ajaxSettings, thrownError) {
						ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
					}
				});

			}
			break;

		case "PrcP_CPN_CAL_PAY_CANCEL":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}
			// 마감여부 확인
			if (!chkClose()) {
				break;
			}

			if ($("#peopleJCnt").html() != null && $("#peopleJCnt").html() != "") {
				if (parseInt($("#peopleJCnt").html()) <= 0) {
					alert("작업완료 인원이 존재하지 않습니다.");
					break;
				}
			} else {
				alert("작업완료 인원이 존재하지 않습니다.");
				break;
			}

			if (confirm("[급여계산] 작업취소를 수행하시겠습니까?")) {

				progressBar(true, "급여계산 작업취소중입니다.");

				var payActionCd = $("#payActionCd").val();
				var businessPlaceCd = $("#businessPlaceCd").val();
				ajaxCall2("${ctx}/PayCalcCre.do?cmd=prcP_CPN_CAL_PAY_CANCEL"
						, "payActionCd="+payActionCd+"&businessPlaceCd="+businessPlaceCd
						, true
						, null
						, function(data) {
							progressBar(false);
							if (data && data.Result && data.Result.Code) {
								if (data.Result.Code === "0") {
									alert("급여계산취소 되었습니다.");
									// 프로시저 호출 후 인원정보 재조회
									doAction1("SearchPeople");
								} else if (data.Result.Message) {
									alert(data.Result.Message);
								}
							} else {
								alert("급여계산취소 오류입니다.");
							}
							doAction2("Search");
						}, function() {
							progressBar(false);
						});
			}
			break;

		case "Close":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}
			// 마감여부 확인
			if (!chkClose()) {
				break;
			}

			if ($("#peopleSubCnt").html() != null && $("#peopleSubCnt").html() != "") {
				if (parseInt($("#peopleSubCnt").html()) <= 0) {
					alert("대상인원이 존재하지 않습니다.\n마감할 수 없습니다.");
					break;
				}
			} else {
				alert("대상인원이 존재하지 않습니다.\n마감할 수 없습니다.");
				break;
			}

			if ($("#peopleJCnt").html() != null && $("#peopleJCnt").html() != "") {
				if ($("#peopleSubCnt").html() != $("#peopleJCnt").html()) {
					alert("대상인원과 작업완료인원이 일치하지 않습니다.\n마감할 수 없습니다.");
					break;
				}
			} else {
				alert("대상인원과 작업완료인원이 일치하지 않습니다.\n마감할 수 없습니다.");
				break;
			}

			if (confirm("[마감] 작업을 수행하시겠습니까?")) {

				var payActionCd = $("#payActionCd").val();

				//var procNm = "마감";
				// 마감
				//var result = ajaxCall("${ctx}/CpnQuery.do?cmd=saveCpnQuery", "queryId=saveCpnCloseYn&procNm="+procNm+"&closeYn=Y&payActionCd="+payActionCd, false);
				var result = ajaxCall("${ctx}/PayCalcCre.do?cmd=saveCpnQuery", "queryId=saveCpnCloseYn&closeYn=Y&payActionCd="+payActionCd, false);

				if (result != null && result["Result"] != null && result["Result"]["Code"] != null) {
					if (result["Result"]["Message"] != null && result["Result"]["Message"] != "") {
						alert(result["Result"]["Message"]);
					}
					if (parseInt(result["Result"]["Code"]) > 0) {
						// 전체 재조회
						if ($("#payActionCd").val() != null && $("#payActionCd").val() != "") {
							doAction1("SearchBasic");
							doAction1("SearchPeople");
							doAction1("Search");
						}
					}
				} else {
					alert("마감 오류입니다.");
				}
				doAction2("Search");
			}
			break;

		case "CancelClose":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			if ($("#payCalcCloseYn").is(":checked") == false) {
				alert("마감되지않은 급여계산작업입니다.");
				break;
			}

			if (confirm("[마감취소] 작업을 수행하시겠습니까?")) {

				var procNm = "2";//마감취소
				var payActionCd = $("#payActionCd").val();

				// 마감취소

				var result = ajaxCall("${ctx}/PayCalcCre.do?cmd=saveCpnQuery", "queryId=saveCpnCloseYn&procNm="+procNm+"&closeYn=N&payActionCd="+payActionCd, false);
				if (result != null && result["Result"] != null && result["Result"]["Code"] != null) {
					if (result["Result"]["Message"] != null && result["Result"]["Message"] != "") {
						alert(result["Result"]["Message"]);
					}
					if (parseInt(result["Result"]["Code"]) > 0) {
						// 전체 재조회
						if ($("#payActionCd").val() != null && $("#payActionCd").val() != "") {
							doAction1("SearchBasic");
							doAction1("SearchPeople");
							doAction1("Search");
						}
					}
				} else {
					alert("마감취소 오류입니다.");
				}
				doAction2("Search");
			}
			break;

		case "Clear":
			sheet1.RemoveAll();
			break;
	}
}

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } 
		doAction2("Search");	
		sheetResize();
	} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
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
	// 급여구분(C00001-00001.급여)
	//var paymentInfo = ajaxCall("${ctx}/CpnQuery.do?cmd=getCpnQueryList", "queryId=getCpnLatestPaymentInfoMap&procNm="+procNm+"&runType=00001,R0001", false);
	var paymentInfo = ajaxCall("${ctx}/PayCalcCre.do?cmd=getCpnQueryList", params, false);

	if (paymentInfo.DATA != null && paymentInfo.DATA != "" && typeof paymentInfo.DATA[0] != "undefined") {
		$("#payActionCd").val(paymentInfo.DATA[0].payActionCd);
		$("#payActionNm").val(paymentInfo.DATA[0].payActionNm);
		$("#payCd").val(paymentInfo.DATA[0].payCd);

		if ($("#payActionCd").val() != null && $("#payActionCd").val() != "") {
			doAction1("SearchBasic");
			doAction1("SearchPeople");
			doAction1("Search");
		}
	} else if (paymentInfo.Message != null && paymentInfo.Message != "") {
		alert(paymentInfo.Message);
	}
}

function sabunName(){
	
	if($("#sabunName").val() == "") return;

	var Row = 0;

	if( sheet2.GetSelectRow() < sheet2.LastRow()){
		Row = sheet2.FindText("name", $("#sabunName").val(), sheet2.GetSelectRow()+1, 2);
	}else{
		Row = -1;
	}
	
	if(Row > 0){
		sheet2.SelectCell(Row,"name");
		$("#sabunName").focus(); 	
	}else if(Row == -1){
		if(sheet2.GetSelectRow() > 1){
			Row = sheet2.FindText("name", $("#sabunName").val(), 1, 2);
			if(Row > 0){
				sheet2.SelectCell(Row,"name");
				$("#sabunName").focus(); 	
			}
		}
	}	
	$("#sabunName").focus(); 		
}

// 급여일자 검색 팝입
function payActionSearchPopup() {

	let parameters = {
		runType : '00001,00003,R0001,00002,ETC,J0001,R0001,R0003'
	};
	if(mode == "retire") parameters.mode = mode;

	let layerModal = new window.top.document.LayerModal({
		id : 'payDayLayer'
		, url : '/PayDayPopup.do?cmd=viewPayDayLayer&authPg=R'
		, parameters : parameters
		, width : 900
		, height : 520
		, title : '<tit:txt mid='payDayPop' mdef='급여일자 조회'/>'
		, trigger :[
			{
				name : 'payDayTrigger'
				, callback : function(result){
					$("#payActionCd").val(result.payActionCd);
					$("#payActionNm").val(result.payActionNm);
					$("#payCd").val(result.payCd);

					if ($("#payActionCd").val() != null && $("#payActionCd").val() != "") {
						doAction1("SearchBasic");
						doAction1("SearchPeople");
						doAction1("Search");
					}
				}
			}
		]
	});
	layerModal.show();
}


function getReturnValue(returnValue) {
	var rv = $.parseJSON('{' + returnValue+ '}');

    if(pGubun == "payDayPopup"){

		$("#payActionCd").val(rv["payActionCd"]);
		$("#payActionNm").val(rv["payActionNm"]);
		$("#payCd").val(rv["payCd"]);

		if ($("#payActionCd").val() != null && $("#payActionCd").val() != "") {
			doAction1("SearchBasic");
			doAction1("SearchPeople");
			doAction1("Search");
		}
    }else if(pGubun == "viewPeopleSetPopup"){
    	$("#peopleTotCnt"	).html("");
    	$("#peopleSubCnt"	).html("");
    	$("#peopleJCnt"		).html("");

    	$("#peopleTotCnt"	).html(rv["peopleTotCnt"]);
    	$("#peopleSubCnt"	).html(rv["peopleSubCnt"]);
    	$("#peopleJCnt"		).html(rv["peopleJCnt"]);

    }
}

// 대상자선정 팝업
function openPeopleSet() {
	// 필수값/유효성 체크
	if (!chkInVal("PeopleSetPopup")) return;

	let parameters = {
		payActionCd : $("#payActionCd").val()
		, payActionNm : $("#payActionNm").val()
		, businessPlaceCd : $("#businessPlaceCd").val() || ''
		, businessPlaceNm : $("#businessPlaceCd option:selected").text() || ''
		, closeYn : ($("#payCalcCloseYn").is(":checked")) ? 'Y' : 'N'
	};
	let layerModal = new window.top.document.LayerModal({
		id : 'payDayLayer'
		, url : '/PayCalcCre.do?cmd=viewPeopleSetLayer&authPg=${authPg}'
		, parameters : parameters
		, width : 1000
		, height : 700
		, title : '급여대상자관리'
		, trigger :[
			{
				name : 'peopleSetTrigger'
				, callback : function(result){
					$("#peopleTotCnt").html("");
					$("#peopleSubCnt").html("");
					$("#peopleJCnt").html("");

					$("#peopleTotCnt").html(result.peopleTotCnt);
					$("#peopleSubCnt").html(result.peopleSubCnt);
					$("#peopleJCnt").html(result.peopleJCnt);
				}
			}
		]
	});
	layerModal.show();
}


// 작업 프로그램 진행현황 팝업
function openProcessBar(actYn) {

	let layerModal = new window.top.document.LayerModal({
		id : 'processBarLayer'
		, url : '/CpnComPopup.do?cmd=viewCpnProcessBarComLayer&authPg=R'
		, parameters : {
			prgCd : 'P_CPN_CAL_PAY_MAIN'
			, payActionCd : $("#payActionCd").val()
			, payActionNm : $("#payActionNm").val()
			, businessPlaceCd : $("#businessPlaceCd").val()
			, actYn : actYn
		}
		, width : 470
		, height : 400
		, title : '<tit:txt mid="cpnProcessBarPop" mdef="진행상태" />'
		, trigger: [
			{
				name: 'processBarLayerTrigger',
				callback: function(rv) {
					isLayerShow = false;
				}
			}
		]
	});

	isLayerShow = true;
	layerModal.show();
}

function payCalcCreErrorPopup(){
	let layerModal = new window.top.document.LayerModal({
		id : 'payCalcErrorLayer'
		, url : '/PayCalcCre.do?cmd=viewPayCalcCreErrorLayer&authPg=R'
		, parameters : {
			payActionCd : $("#payActionCd").val()
			, payActionNm : $("#payActionNm").val()
		}
		, width : 800
		, height : 550
		, title : '오류확인'
	});
	layerModal.show();
}

//*********************
// 필수값/유효성 체크
function chkInVal2(sAction) {
	if ($("#sheet2Form #s2_payActionCd").val() == "") {
		alert("급여일자를 확인하십시오.");
		return false;
	}

	return true;
}

// 마감여부 확인
function chkClose2() {
	if ($("#sheet2Form #s2_closeYn").val() == "Y") {
		alert("급여가 이미 마감되었습니다.");
		return false;
	}

	return true;
}

/**
 * 레이어창 오픈 여부를 확인하여 alertTimer 호출
 */
function chkLayerShow(pMsg, pTime, pWin, pFn) {
	if(isLayerShow) {
		return;
	}
	alertTimer(pMsg, pTime, pWin, pFn);
	clearInterval(interval);
}

function doAction2(sAction) {
	// pre task
	if (!chkInVal("PeopleSetPopup")) {
		return;
	}
	
	$("#sheet2Form #s2_payActionCd").val($("#payActionCd").val());
	$("#sheet2Form #s2_businessPlaceCd").val($("#businessPlaceCd").val());
	if ($("#payCalcCloseYn").is(":checked") == true) {
		$("#sheet2Form #s2_closeYn").val("Y");
	} else {
		$("#sheet2Form #s2_closeYn").val("N");
	}
	
	switch (sAction) {
		case "SearchBasic":
			// 필수값/유효성 체크
			if (!chkInVal2(sAction)) {
				break;
			}

			// 기본사항조회
			var basicInfo = ajaxCall("${ctx}/PayCalcCre.do?cmd=getPayCalcCreBasicMap", $("#sheet2Form").serialize(), false);

			$("#sheet2Form #empStatus"	).val("");
			$("#sheet2Form #s2_closeYn"	).val("");

			if (basicInfo.DATA != null) {
				basicInfo = basicInfo.DATA;
				$("#sheet2Form #empStatus"	).val(basicInfo.empStatus	);
				$("#sheet2Form #s2_closeYn"	).val(basicInfo.closeYn		);

				doAction2("Search");
			}
			break;

		case "PrcP_CPN_CAL_EMP_INS":
			// 필수값/유효성 체크
			if (!chkInVal2(sAction)) {
				break;
			}
			// 마감여부 확인
			if (!chkClose2()) {
				break;
			}

			if ($("#sheet2Form #empStatus").val() != "10005") {
				var rowCnt = sheet2.RowCount();
				if (rowCnt > 0) {
					if (!confirm("이미 대상자가 존재합니다. 덮어쓰시겠습니까?"))
						return;
				}

				if (confirm("[작업]을 실행하시겠습니까?")) {

					progressBar(true, "급여대상자 생성중입니다.");

					var payActionCd = $("#sheet2Form #s2_payActionCd").val();
					var businessPlaceCd = $("#sheet2Form #s2_businessPlaceCd").val();
					// 급여대상자 생성
					ajaxCall2("${ctx}/PayCalcCre.do?cmd=prcP_CPN_CAL_EMP_INS"
							, "sabun=&payActionCd="+payActionCd+"&businessPlaceCd="+businessPlaceCd
							, true
							, null
							, function(data) {
								progressBar(false);
								if (data && data.Result && data.Result.Code) {
									if (data.Result.Code === "0") {
										alert("급여대상자 생성 되었습니다.");
										doAction2("Search");
										peopleCnt();
									} else if (!data.Result.Message) {
										alert(data.Result.Message);
									}
								} else {
									alert("급여대상자 생성 오류입니다.");
								}
							}
							, function() {
								progressBar(false);
							});
				}
			} else {
				alert("이미 마감되었습니다.\n마감취소 후 작업이 가능합니다.");
			}
			break;

		case "Search":
			sheet2.ClearHeaderCheck();

			sheet2.DoSearch("/PayCalcCre.do?cmd=getPayCalcCrePeopleSetList", $("#sheet2Form").serialize());
			
			$("#sabunName").focus();
			break;

		case "Save":
			// 마감여부 확인
			if (!chkClose2()) {
				break;
			}
			if(sheet2.RowCount() > 0) {
				for ( var i = sheet2.HeaderRows(); i < sheet2.RowCount()+sheet2.HeaderRows(); i++){
					if(sheet2.GetCellValue(i, "payActionCd") == "" ) {
						sheet2.SetCellValue(i, "payActionCd", $("#sheet2Form #s2_payActionCd").val());
					}
				}
			}

			if(!dupChk(sheet2, "sabun", false, true)){break;}
			IBS_SaveName(document.sheet2Form,sheet2);
			sheet2.DoSave("${ctx}/PayCalcCre.do?cmd=savePayCalcCrePeopleSet", $("#sheet2Form").serialize());
			break;

		case "Insert":
			// 필수값/유효성 체크
			if (!chkInVal2(sAction)) {
				break;
			}
			// 마감여부 확인
			if (!chkClose2()) {
				break;
			}

			var Row = sheet2.DataInsert(0);
			sheet2.SetCellValue(Row, "payActionCd", $("#sheet2Form #s2_payActionCd").val());
			sheet2.SelectCell(Row, 2);
			break;

		case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet2);
			downcol = downcol.replace("|"+sheet2.SaveNameCol("btnPrt")+"|", "|");
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet2.Down2Excel(param);
			break;
			
		case "DownTemplate":
			// 양식다운로드
			sheet2.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0|1", DownCols:"8"});
			break;
		case "LoadExcel":
			// 업로드
			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet2.LoadExcel(params);
			break;
	}
	
	// post task
	var payActionCd = $("#sheet2Form #s2_payActionCd").val();
	var businessPlaceCd = $("#sheet2Form #s2_businessPlaceCd").val();
	var peopleInfo = ajaxCall("${ctx}/PayCalcCre.do?cmd=getPayCalcCrePeopleMap", "payActionCd="+payActionCd+"&businessPlaceCd="+businessPlaceCd, false).DATA;

	if (peopleInfo != null) {
		$("#peopleTotCnt"	).html(peopleInfo.peopleTotCnt);
		$("#peopleSubCnt"	).html(peopleInfo.peopleSubCnt);
		$("#peopleJCnt"		).html(peopleInfo.peopleJCnt);
	}
	
}

function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
    try {
            if (Msg != "") {
                alert(Msg);
            }
//             if($("#sheet2Form #s2_closeYn").val() == "Y"){
//                 sheet2.SetEditable(0);
//             }else if($("#sheet2Form #s2_closeYn").val() == "N"){
                for ( var i = sheet2.HeaderRows(); i < sheet2.RowCount()+sheet2.HeaderRows(); i++){
                	if($("#sheet2Form #s2_closeYn").val() == "Y"){
                		sheet2.SetCellEditable(i,"sDelete",0);
                	} else if($("#sheet2Form #s2_closeYn").val() == "N"){
                		if(sheet2.GetCellValue(i, "status") == "J"){
                            sheet2.SetCellEditable(i,"sDelete",0);
                        }else if(sheet2.GetCellValue(i, "status") == "P"){
                        }
                        
                        if(sheet2.GetCellValue(i, "status") == "J"){
                            sheet2.SetCellEditable(i,"sDelete",0);
                            sheet2.SetCellValue(i, "btnPrt", '<a class="basic">계산취소</a>');
                            sheet2.SetCellValue(i, "sStatus", 'R');
                        }else if(sheet2.GetCellValue(i, "status") == "P"){
                            sheet2.SetCellValue(i, "btnPrt", '<a class="basic">계산</a>');
                            sheet2.SetCellValue(i, "sStatus", 'R');
                        }	
                	}
                    
                }
//             }
            sheetResize();
        } catch (ex) {
            alert("OnSearchEnd Event Error : " + ex);
        }
}

function sheet2_OnClick(Row, Col, Value) {
	try{
		if(sheet2.ColSaveName(Col) == "btnPrt" && Row != 0){
		if(sheet2.GetCellValue(Row, "status") == "J" && $("#sheet2Form #s2_closeYn").val() != "Y" ){
			var sabun = sheet2.GetCellValue( Row, "sabun");
			calcCancel(sabun);
		}else if(sheet2.GetCellValue(Row, "status") == "P" && $("#sheet2Form #s2_closeYn").val() != "Y" ){
			var sabun = sheet2.GetCellValue( Row, "sabun");
			calc(sabun);
		}
		}
	}catch(ex){alert("OnClick Event Error : " + ex);}
}

//저장 후 메시지
function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") {
			alert(Msg);
		}

		peopleCnt();
		doAction2("Search");

	} catch (ex) {
		alert("OnSaveEnd Event Error " + ex);
	}
}

function calcCancel(sabun){
	if (confirm("[급여계산] 작업취소를 수행하시겠습니까?")) {

		var payActionCd = $("#sheet2Form #s2_payActionCd").val();
		var businessPlaceCd = $("#sheet2Form #s2_businessPlaceCd").val();
		// 작업취소
			var result = ajaxCall("${ctx}/PayCalcCre.do?cmd=prcP_CPN_CAL_PAY_CANCEL2", "payActionCd="+payActionCd+"&businessPlaceCd="+businessPlaceCd+"&sabun="+sabun, false);

		if (result != null && result["Result"] != null && result["Result"]["Code"] != null) {
			if (result["Result"]["Code"] == "0") {
				alert("급여계산취소 되었습니다.");
				peopleCnt();
				doAction2("Search");
			} else if (result["Result"]["Message"] != null && result["Result"]["Message"] != "") {
				alert(result["Result"]["Message"]);
			}
		} else {
			alert("급여계산취소 오류입니다.");
		}

	}
}

function calc(sabun){

	if (confirm("[급여계산] 작업을 수행하시겠습니까?")) {
		//작업중인 급여 로그가 있는지 확인
		var ingYn = ajaxCall("/CommonCode.do?cmd=getCommonNSCodeList&searchBizCd=CPN&searchPrgCd=P_CPN_CAL_PAY_MAIN&searchPayActionCd="+$("#sheet2Form #s2_payActionCd").val(), "queryId=getPayCalcMsgYn", false) ;
		if( ingYn.codeList[0].code != null && ingYn.codeList[0].code == "N" ) {
			if( confirm("이미 실행중입니다.\nClear 후 진행하시겠습니까?") ) {
				//작업중이던 급여 로그를 강제 삭제 후 실행
				ajaxCall("/PayCalcCre.do?cmd=deleteTSYS904ForPayCalcCre&searchBizCd=CPN&searchPrgCd=P_CPN_CAL_PAY_MAIN&searchPayActionCd="+$("#sheet2Form #s2_payActionCd").val(), "queryId=deleteTSYS904ForPayCalcCre", false) ;
			} else {
				return ;
			}
		}

		var payActionCd = $("#sheet2Form #s2_payActionCd").val();
		var businessPlaceCd = $("#sheet2Form #s2_businessPlaceCd").val();
		
		$.ajax({
			url : "${ctx}/PayCalcCre.do?cmd=prcP_CPN_CAL_PAY_MAIN2",
			type : "post",
			dataType : "json",
			async : true,
			data : "payActionCd="+payActionCd+"&businessPlaceCd="+businessPlaceCd+"&sabun="+sabun,
			success : function(result) {

				if (result != null && result["Result"] != null && result["Result"]["Code"] != null) {
					if (result["Result"]["Code"] == "0") {
						alert("급여계산 되었습니다.");
						peopleCnt();
						doAction2("Search");
					} else if (result["Result"]["Message"] != null && result["Result"]["Message"] != "") {
						alert(result["Result"]["Message"]);
					}
				} else {
					alert("급여계산 오류입니다.");
				}

			},
			error : function(jqXHR, ajaxSettings, thrownError) {
				ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
			}
		});

	}
}

function peopleCnt(){
	var payActionCd = $("#sheet2Form #s2_payActionCd").val();
	var businessPlaceCd = $("#sheet2Form #s2_businessPlaceCd").val();
	var peopleInfo = ajaxCall("${ctx}/PayCalcCre.do?cmd=getPayCalcCrePeopleMap", "payActionCd="+payActionCd+"&businessPlaceCd="+businessPlaceCd, false).DATA;

	if (peopleInfo != null) {
		$("#peopleTotCnt"	).html(peopleInfo.peopleTotCnt);
		$("#peopleSubCnt"	).html(peopleInfo.peopleSubCnt);
		$("#peopleJCnt"		).html(peopleInfo.peopleJCnt);
	}
}

//저장 후 메시지
function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } peopleCnt(); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}

function returnFunc(returnValue) {
	var rv = $.parseJSON('{' + returnValue+ '}');

	sheet2.SetCellValue(gPRow, "name",		rv["name"] );
	sheet2.SetCellValue(gPRow, "sabun",		rv["sabun"] );
	sheet2.SetCellValue(gPRow, "orgNm",		rv["orgNm"] );
	sheet2.SetCellValue(gPRow, "workType",	rv["workType"] );
	sheet2.SetCellValue(gPRow, "jikchakCd",	rv["jikchakCd"] );
	sheet2.SetCellValue(gPRow, "jikweeCd",	rv["jikweeCd"] );
	sheet2.SetCellValue(gPRow, "jikgubCd",	rv["jikgubCd"] );
	sheet2.SetCellValue(gPRow, "payType",	rv["payType"] );

	sheet2.SetCellValue(gPRow, "manageCd",	rv["manageCd"] );
	sheet2.SetCellValue(gPRow, "statusCd",	rv["statusCd"] );
	sheet2.SetCellValue(gPRow, "empYmd",	rv["empYmd"] );
	sheet2.SetCellValue(gPRow, "gempYmd",	rv["gempYmd"] );
	sheet2.SetCellValue(gPRow, "resNo",	rv["resNo"] );
	sheet2.SetCellValue(gPRow, "businessPlaceCd",	rv["businessPlaceCd"] );
	sheet2.SetCellValue(gPRow, "ccCd",	rv["ccCd"] );
	sheet2.SetCellValue(gPRow, "jobNm",	rv["jobNm"] );
}

// 복리후생sheet 높이 설정
function setSheet1Height() {
	const topHeight = document.querySelector("td.top>table").offsetHeight;
	$("#DIV_sheet1").css("height", topHeight);
	$("#DIV_sheet1").attr("fixed", "true"); // 높이 고정
}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<div class="inner">
		<form id="sheet1Form" name="sheet1Form" >
			<table border="0" cellpadding="0" cellspacing="0" class="default inner">
				<colgroup>
					<col width="7%" />
					<col width="18%" />
					<col width="7%" />
					<col width="18%" />
					<col width="7%" />
					<col width="18%" />
					<col width="7%" />
					<col width="18%" />
				</colgroup>
				<tr>
					<th>급여일자</th>
					<td> <input type="hidden" id="payActionCd" name="payActionCd" value="" />
						 <input type="text" id="payActionNm" name="payActionNm" class="text required readonly" value="" readonly style="width:150px" />
						 <a href="javascript:payActionSearchPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
						 <input type="hidden" id="payPeopleStatus" name="payPeopleStatus" value="" /><input type="hidden" id="payCd" name="payCd" value="" /></td>
					<th style="display:none;">급여구분</th>
					<td style="display:none;" id="payNm"> </td>
					<th>사업장</th>
					<td> <select id="businessPlaceCd" name="businessPlaceCd"> </select> </td>
					<th>대상년월</th>
					<td id="payYm"> </td>
					<th style="display:none;">지급일자</th>
					<td style="display:none;" id="paymentYmd"> </td>
					<th>근태기준년월</th>
					<td id="timeYm"> </td>
				</tr>
			</table>
		</form>
		<table border="0" cellspacing="0" cellpadding="0" class="default inner border-top-none">
			<colgroup>
				<col width="49%" />
				<col width="1%" />
				<col width="50%" />
			</colgroup>
			<tr>
				<td>
					<div class="outer">
						<div class="sheet_title">
							<ul>
								<li class="txt">복리후생 마감현황</li>
								<li class="btn">
								   <a href="javascript:doAction1('PrcP_BEN_PAY_DATA_CREATE_ALL')"	class="basic authA">연계자료 전체생성</a>
									<a href="javascript:doAction1('Search')"	class="button authR">조회</a>
								</li>
							</ul>
						</div>
					</div>
					<script type="text/javascript">createIBSheet("sheet1", "50%", "60%", "kr"); </script>
				</td>
				<td>
				</td>
				<td class="top">
					<div class="inner">
						<div class="sheet_title">
							<ul>
								<li class="txt">처리조건</li>
								<li class="btn"><a href="javascript:doAction1('SearchPeople')"	class="button authR">조회</a></li>
							</ul>
						</div>
					</div>
					<table border="0" cellpadding="0" cellspacing="0" class="default outer">
						<colgroup>
							<col width="25%" />
							<col width="25%" />
							<col width="25%" />
							<col width="25%" />
						</colgroup>
						<tr>
							<th>세금계산</th>
							<td id="calTaxMethod" colspan="3"> </td>
						</tr>
						<!-- tr>
							<th>세금가중치</th>
							<td id="addTaxRate" colspan="3"> </td>
						</tr -->
						<tr>
							<th>총인원</th>
							<td id="peopleTotCnt" colspan="3" > </td>
						</tr>
						<tr>
							<th>대상인원</th>
							<td id="peopleSubCnt"> </td>
							<th>작업완료인원</th>
							<td id="peopleJCnt"> </td>
						</tr>
						<!-- tr>
							<th>작업대상전체</th>
							<td colspan="3"><input type="checkbox" id="peoplePTot" name="peoplePTot" value="N" class="checkbox" onClick="javascript:doAction1('SavePeopleStatus');">
											<a href="javascript:doAction1('PrcP_CPN_CAL_PAY_MAIN')"		class="basic authA">작업</a>
											<a href="javascript:doAction1('PrcP_CPN_CAL_PAY_CANCEL')"	class="basic authA">작업취소</a></td>
						</tr -->
						<tr>
							<th>급여계산</th>
							<td colspan="3">
										<a href="javascript:doAction1('PrcP_CPN_CAL_PAY_MAIN')"		class="button basic authA">계산</a>
										<a href="javascript:doAction1('PrcP_CPN_CAL_PAY_CANCEL')"	class="basic authA">계산취소</a>
										<a href="javascript:openProcessBar('0')"						class="basic authA">진행상태</a></td>
						</tr>
						<tr>
							<th>급여계산 오류</th>
							<td colspan="3" style="border-right-style: none;"><span id="payErrCnt">0</span>&nbsp;<span> 건 </span>
								<input type="hidden" id="workCloseYn" />
								<input type="hidden" id="workStatus" />
								<a href="javascript:payCalcCreErrorPopup();" onclick="" class="basic" > 오류확인 </a>
							</td>
						</tr>
						<tr>
							<th>급여계산 마감여부</th>
							<td colspan="3"><input id="payCalcCloseYn" name="payCalcCloseYn" type="checkbox" class="checkbox" disabled/>
											<a href="javascript:doAction1('Close')"			class="basic authA">마감</a>
											<a href="javascript:doAction1('CancelClose')"	class="basic authA">마감취소</a></td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
	
	<form id="sheet2Form" name="sheet2Form" >
		<input type="hidden" id="empStatus" name="empStatus"/>
		<input type="hidden" id="s2_payActionCd" name="payActionCd"/>
		<input type="hidden" id="s2_closeYn" name="closeYn"/>
		<input type="hidden" id="s2_businessPlaceCd" name="businessPlaceCd"/>
		<div class="inner">
			<div class="sheet_title">
				<ul>
					<li class="txt">급여대상자</li>
					<li class="btn">
						<span>사번/성명</span>&nbsp;<input type="text" id="sabunName" name="sabunName" class="text" value="" style="ime-mode:active" onKeyUp="check_Enter();"/>
						<a href="javascript:doAction2('Search')"		class="button authR">조회</a>
						<a href="javascript:doAction2('PrcP_CPN_CAL_EMP_INS')"	class="basic authA">대상자선정작업</a>
						<a href="javascript:doAction2('DownTemplate')" 	class=" basic authA">양식다운로드</a>
						<a href="javascript:doAction2('LoadExcel')" 	class="basic authA">업로드</a>
						<a href="javascript:doAction2('Insert')"		class="basic authA">입력</a>
						<a href="javascript:doAction2('Save')"			class="basic authA">저장</a>
						<a href="javascript:doAction2('Down2Excel')"	class="basic authR">다운로드</a>
					</li>
				</ul>
			</div>
		</div>
		<script type="text/javascript">createIBSheet("sheet2", "90%", "85%","kr"); </script>
	</form>
</div>
</body>
</html>