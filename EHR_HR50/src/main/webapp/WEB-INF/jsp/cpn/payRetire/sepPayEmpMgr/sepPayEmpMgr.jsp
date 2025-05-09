<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='sepPayEmpMgr' mdef='퇴직금대상자관리'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 퇴직금대상자관리
 * @author JM
-->
<c:if test="${ !empty param.mode }">
	mode = "${param.mode}";
</c:if>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
$(function() {
	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22, FrozenCol:11};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};
	initdata1.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",				Sort:0 },
		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",				Sort:0 },
		{Header:"<sht:txt mid='payActionCdV1' mdef='급여계산코드'/>",		Type:"Text",		Hidden:1,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"payActionCd",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='payPeopleStatusV2' mdef='대상자\n확정여부'/>",	Type:"Text",	Hidden:1,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"payPeopleStatus",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
		{Header:"<sht:txt mid='payPeopleStatusText' mdef='작업'/>",			Type:"Text",		Hidden:0,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"payPeopleStatusText",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='payPeopleStatusChgYn' mdef='대상자확정여부변경여부'/>",	Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"payPeopleStatusChgYn",KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
		{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",			Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"sabun",				KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",			Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"name",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",			Type:"Text",		Hidden:Number("${aliasHdn}"),					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"alias",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='manageCd' mdef='사원구분'/>",			Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"manageCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='manageNmV1' mdef='사원구분명'/>",		Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"manageNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='appOrgCdV5' mdef='소속코드'/>",			Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"orgCd",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",			Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"orgNm",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='applJobJikgunNmV1' mdef='직군'/>",			Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"workType",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='workTypeNmV6' mdef='직군명'/>",			Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"workTypeNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",			Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"jikchakCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='jikchakNmV1' mdef='직책명'/>",			Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",			Type:"Text",		Hidden:Number("${jwHdn}"),					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='jikweeNmV1' mdef='직위명'/>",			Type:"Text",		Hidden:Number("${jwHdn}"),					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",			Type:"Text",		Hidden:Number("${jgHdn}"),					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='jikgubNmV1' mdef='직급명'/>",			Type:"Text",		Hidden:Number("${jgHdn}"),					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='accResNoV1' mdef='주민번호'/>",			Type:"Text",		Hidden:1,					Width:120,			Align:"Center",	ColMerge:0,	SaveName:"resNo",				KeyField:0,	Format:"IdNo",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"<sht:txt mid='statusCdV5' mdef='재직상태'/>",			Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"statusCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='statusNmV2' mdef='재직상태명'/>",		Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"statusNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='empYmd' mdef='입사일'/>",			Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"empYmd",				KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='gempYmd' mdef='그룹입사일'/>",		Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"gempYmd",				KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='edateV1' mdef='퇴사일'/>",			Type:"Date",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"retYmd",				KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='adjYmd' mdef='중도정산일'/>",		Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"adjYmd",				KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='businessPlaceCdV4' mdef='급여사업장코드'/>",		Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"businessPlaceCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='businessPlaceCdV4' mdef='급여사업장코드'/>",		Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"businessPlaceNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='ccCd' mdef='코스트센터'/>",		Type:"Combo",		Hidden:0,					Width:120,			Align:"Center",	ColMerge:0,	SaveName:"ccCd",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='retBonYnV1' mdef='퇴직상여\n계산여부'/>",	Type:"Combo",		Hidden:1,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"retBonYn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
		{Header:"<sht:txt mid='retAlrYnV1' mdef='퇴직연월차\n계산여부'/>",	Type:"Combo",		Hidden:1,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"retAlrYn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
		{Header:"<sht:txt mid='retTaxdedYn' mdef='퇴직소득\n세액공제여부'/>",Type:"Combo",		Hidden:1,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"retTaxdedYn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='ordSymd' mdef='발령기준시작일'/>",		Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"ordSymd",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
		{Header:"<sht:txt mid='ordEymd' mdef='발령기준종료일'/>",		Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"ordEymd",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
		{Header:"<sht:txt mid='workSymd' mdef='근무기준시작일'/>",		Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"workSymd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
		{Header:"<sht:txt mid='workEymd' mdef='근무기준종료일'/>",		Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"workEymd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
		{Header:"<sht:txt mid='gntSymdV2' mdef='근태기준시작일'/>",		Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"gntSymd",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
		{Header:"<sht:txt mid='gntEymdV2' mdef='근태기준종료일'/>",		Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"gntEymd",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
		{Header:"<sht:txt mid='rmidYmd' mdef='최종중간정산일'/>",		Type:"Date",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"rmidYmd",				KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='traYmdV4' mdef='면수습일자'/>",		Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"traYmd",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
		{Header:"<sht:txt mid='payTypeNmV3' mdef='급여유형코드'/>",		Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"payType",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='payTypeNmV3' mdef='급여유형코드'/>",		Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"payTypeNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='qOrgCdV3' mdef='본부소속코드'/>",		Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"qOrgCd",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='placeWorkCd' mdef='소속공정코드'/>",		Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"placeWorkCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='workOrgCd' mdef='근무조'/>",			Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"workteamCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='salClassNm' mdef='호봉'/>",			Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"salClass",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='sgPointV2' mdef='승급포인트'/>",		Type:"Int",			Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"sgPoint",				KeyField:0,	Format:"Integer",PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='jobCdV1' mdef='직무코드'/>",			Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"jobCd",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='jobNmV2' mdef='직무명'/>",			Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"jobNm",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='locationCdV1' mdef='근무지코드'/>",		Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"locationCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='mthPayYn' mdef='당월급여지급여부'/>",	Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"mthPayYn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 }
	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);

	//------------------------------------- 그리드 콤보 -------------------------------------//
	// 사업장(TCPN121)
	var tcpn121Cd = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getTcpn121List", false).codeList, "");
	sheet1.SetColProperty("businessPlaceCd", {ComboText:"|"+tcpn121Cd[0], ComboCode:"|"+tcpn121Cd[1]});

	// 코스트센터(TORG109)
	var torg109Cd = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&mapTypeCd=300", "queryId=getTorg109List", false).codeList, "");
	sheet1.SetColProperty("ccCd", {ComboText:"|"+torg109Cd[0], ComboCode:"|"+torg109Cd[1]});

	// 퇴직상여계산여부
	sheet1.SetColProperty("retBonYn", {ComboText:"|예|아니오", ComboCode:"|Y|N"});

	// 퇴직연월차계산여부
	sheet1.SetColProperty("retAlrYn", {ComboText:"|예|아니오", ComboCode:"|Y|N"});

	// 퇴직소득세액공제여부
	sheet1.SetColProperty("retTaxdedYn", {ComboText:"|예|아니오", ComboCode:"|Y|N"});

	//------------------------------------- 조회조건 콤보 -------------------------------------//
	// 사업장
	<c:choose>
		<c:when test="${ssnSearchType == 'A'}">
			var tcpn121Cd = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getTcpn121List", false).codeList, "<tit:txt mid='103895' mdef='전체'/>");
		</c:when>
		<c:otherwise>
			var tcpn121Cd = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getTcpn121List", false).codeList, "");
		</c:otherwise>
	</c:choose>
	$("#businessPlaceCd").html(tcpn121Cd[2]);

	$(window).smartresize(sheetResize);
	sheetInit();

	$("#sabunName").bind("keyup",function(event){
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
					sheet1.SetCellValue(gPRow, "name", 		rv["name"]);
					sheet1.SetCellValue(gPRow, "sabun", 	rv["sabun"]);
					sheet1.SetCellValue(gPRow, "alias", 	rv["alias"]);
					sheet1.SetCellValue(gPRow, "orgCd", 	rv["orgCd"]);
					sheet1.SetCellValue(gPRow, "orgNm", 	rv["orgNm"]);
					sheet1.SetCellValue(gPRow, "manageCd",	rv["manageCd"]);
					sheet1.SetCellValue(gPRow, "manageNm",	rv["manageNm"]);
					sheet1.SetCellValue(gPRow, "workType",  rv["workType"]);
					sheet1.SetCellValue(gPRow, "workTypeNm",rv["workTypeNm"]);
					sheet1.SetCellValue(gPRow, "jikchakCd",	rv["jikchakCd"]);
					sheet1.SetCellValue(gPRow, "jikchakNm",	rv["jikchakNm"]);
					sheet1.SetCellValue(gPRow, "jikweeCd",	rv["jikweeCd"]);
					sheet1.SetCellValue(gPRow, "jikweeNm",	rv["jikweeNm"]);
					sheet1.SetCellValue(gPRow, "jikgubCd",	rv["jikgubCd"]);
					sheet1.SetCellValue(gPRow, "jikgubNm",	rv["jikgubNm"]);
					sheet1.SetCellValue(gPRow, "statusCd",	rv["statusCd"]);
					sheet1.SetCellValue(gPRow, "statusNm",	rv["statusNm"]);
					sheet1.SetCellValue(gPRow, "gempYmd",	rv["gempYmd"]);
					sheet1.SetCellValue(gPRow, "empYmd",	rv["empYmd"]);
					sheet1.SetCellValue(gPRow, "retYmd",	rv["retYmd"]);
					sheet1.SetCellValue(gPRow, "businessPlaceCd",	rv["businessPlaceCd"]);
				}
			}
		]
	});		
	
	// 최근급여일자 조회
	getCpnLatestPaymentInfo();
	doAction1("Search");
});

// 필수값/유효성 체크
function chkInVal(sAction) {
	if ($("#payActionCd").val() == "") {
		alert("<msg:txt mid='109681' mdef='급여일자를 선택하십시오.'/>");
		$("#payActionNm").focus();
		return false;
	}

	return true;
}

// 마감여부 확인
function chkClose() {
	if ($("#closeYn").val() == "Y") {
		alert("<msg:txt mid='alertPeopleSetPop6' mdef='이미 마감되었습니다.n마감취소 후 작업이 가능합니다.'/>");
		return false;
	}

	return true;
}

function doAction1(sAction) {
	switch (sAction) {
		case "SearchBasic":
			// 기본사항조회
			var basicInfo = ajaxCall("${ctx}/SepPayEmpMgr.do?cmd=getSepPayEmpMgrBasicMap",$("#sheet1Form").serialize(), false);

			$("#payNm"		).html("");
			$("#paymentYmd"	).html("");
			$("#ordYmd"		).html("");
			$("#payCd"		).val("");
			$("#closeYn"	).val("");

			if (basicInfo.Map != null) {
				basicInfo = basicInfo.Map;
				$("#payNm"		).html(basicInfo.payNm);
				$("#paymentYmd"	).html(basicInfo.paymentYmd);
				$("#ordYmd"		).html(basicInfo.ordYmd);
				$("#payCd"		).val(basicInfo.payCd);
				$("#closeYn"	).val(basicInfo.closeYn);
			}

			break;

		case "Search":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			sheet1.ClearHeaderCheck();

			sheet1.DoSearch("${ctx}/SepPayEmpMgr.do?cmd=getSepPayEmpMgrList", $("#sheet1Form").serialize());
			break;

		case "Save":
			// 중복체크
			if (!dupChk(sheet1, "payActionCd|sabun", false, true)) {break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave("${ctx}/SepPayEmpMgr.do?cmd=saveSepPayEmpMgr", $("#sheet1Form").serialize());
			break;

		case "Insert":
			var Row = sheet1.DataInsert(0);
			sheet1.SetCellValue(Row, "payActionCd", $("#payActionCd").val());
			sheet1.SelectCell(Row, 2);
			break;

		case "Copy":
			var Row = sheet1.DataCopy();
			sheet1.SelectCell(Row, 2);
			break;

		case "prcP_CPN_SEP_EMP_INS":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}
			// 마감여부 확인
			if (!chkClose()) {
				break;
			}

			var rowCnt = sheet1.RowCount();
			if (rowCnt > 0) {
				if (!confirm("<msg:txt mid='114756' mdef='이미 대상자가 존재합니다. 덮어쓰시겠습니까?'/>")) return;
			}

			var payActionCd = $("#payActionCd").val();
			var businessPlaceCd = $("#businessPlaceCd").val();

			// 퇴직계산 대상자 선정 작업
			var result = ajaxCall("${ctx}/SepPayEmpMgr.do?cmd=prcP_CPN_SEP_EMP_INS", "payActionCd="+payActionCd+"&businessPlaceCd="+businessPlaceCd, false);

			if (result != null && result["Result"] != null && result["Result"]["Code"] != null) {
				if (result["Result"]["Code"] == "0") {
					alert("<msg:txt mid='alertSepPayEmpMgr2' mdef='대상자생성 되었습니다.'/>");
					// 프로시저 호출 후 재조회
					doAction1("SearchBasic");
					doAction1("Search");
				} else if (result["Result"]["Message"] != null && result["Result"]["Message"] != "") {
					alert(result["Result"]["Message"]);
				}
			} else {
				alert("<msg:txt mid='alertSepPayEmpMgr3' mdef='대상자생성 오류입니다.'/>");
			}
			break;

		case "prcP_CPN_SEP_EMP_UPD":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			if (!confirm("<msg:txt mid='114763' mdef='대상자 확정처리 하시겠습니까?'/>")) return;

			var payActionCd = $("#payActionCd").val();

			// 퇴직계산 대상자 확정 작업
			var result = ajaxCall("${ctx}/SepPayEmpMgr.do?cmd=prcP_CPN_SEP_EMP_UPD", "payActionCd="+payActionCd, false);

			if (result != null && result["Result"] != null && result["Result"]["Code"] != null) {
				if (result["Result"]["Code"] == "0") {
					alert("<msg:txt mid='alertSepPayEmpMgr5' mdef='대상자 확정 되었습니다.'/>");
					// 프로시저 호출 후 재조회
					doAction1("SearchBasic");
					doAction1("Search");
				} else if (result["Result"]["Message"] != null && result["Result"]["Message"] != "") {
					alert(result["Result"]["Message"]);
				}
			} else {
				alert("<msg:txt mid='alertSepPayEmpMgr6' mdef='대상자 확정 오류입니다.'/>");
			}
			break;

		case "prcP_CPN_SEP_EMP_DEL":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			if (!confirm("대상자 확정취소 하시겠습니까?")) return;

			var payActionCd = $("#payActionCd").val();

			// 퇴직계산 대상자 확정취소 작업
			var result = ajaxCall("${ctx}/SepPayEmpMgr.do?cmd=prcP_CPN_SEP_EMP_DEL", "payActionCd="+payActionCd, false);

			if (result != null && result["Result"] != null && result["Result"]["Code"] != null) {
				if (result["Result"]["Code"] == "0") {
					alert("<msg:txt mid='alertSepPayEmpMgr8' mdef='대상자 확정취소 되었습니다.'/>");
					// 프로시저 호출 후 재조회
					doAction1("SearchBasic");
					doAction1("Search");
				} else if (result["Result"]["Message"] != null && result["Result"]["Message"] != "") {
					alert(result["Result"]["Message"]);
				}
			} else {
				alert("<msg:txt mid='alertSepPayEmpMgr9' mdef='대상자 확정취소 오류입니다.'/>");
			}
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
	}
}

// 업로드 처리가 완료된 후
function sheet1_OnLoadExcel() {
	// 저장시  payActionCd NULL 인경우 대체용
	$("#searchPayActionCd").val($("#payActionCd").val());
}

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") {
			alert(Msg);
		}

		var rowCnt = sheet1.RowCount();
		for (var i=1; i<rowCnt+1; i++) {
			// 급여대상자상태(C.대상 E.에러 J.작업완료 M.재계산 P.작업대상 PM.작업대상(재계산) W.미확정)
			if (sheet1.GetCellValue(i, "payPeopleStatus") == "J" || sheet1.GetCellValue(i, "payPeopleStatus") == "M" || sheet1.GetCellValue(i, "payPeopleStatus") == "PM") { // J.작업완료
				//sheet1.SetCellValue(i, "payPeopleStatus", "1"); // P.작업대상
				sheet1.SetCellEditable(i, "gempYmd", 0);
				sheet1.SetCellEditable(i, "sDelete", 0);
				sheet1.SetCellEditable(i, "empYmd", 0);
				sheet1.SetCellEditable(i, "adjYmd", 0);
				sheet1.SetCellEditable(i, "retYmd", 0);
				sheet1.SetCellEditable(i, "businessPlaceCd", 0);
				sheet1.SetCellEditable(i, "ccCd", 0);
				sheet1.SetCellEditable(i, "retAlrYn", 0);
				sheet1.SetCellEditable(i, "retTaxdedYn", 0);
				sheet1.SetCellEditable(i, "rmidYmd", 0);
				sheet1.SetRowBackColor(i,"#FFC296");
			}else{
				sheet1.SetCellEditable(i, "sDelete", 1);
				sheet1.SetCellEditable(i, "gempYmd", 1);
				sheet1.SetCellEditable(i, "empYmd", 1);
				sheet1.SetCellEditable(i, "adjYmd", 1);
				sheet1.SetCellEditable(i, "retYmd", 1);
				sheet1.SetCellEditable(i, "businessPlaceCd", 1);
				sheet1.SetCellEditable(i, "ccCd", 1);
				sheet1.SetCellEditable(i, "retAlrYn", 1);
				sheet1.SetCellEditable(i, "retTaxdedYn", 1);
				sheet1.SetCellEditable(i, "rmidYmd", 1);
			}
		}

		sheetResize();
	} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

//저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") { alert(Msg);}
		doAction1("Search");
	} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}

function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	try{
		var colName = sheet1.ColSaveName(Col);
		if (Row > 0) {
			/*
			if (colName == "empYmd" || colName == "adjYmd" || colName == "retYmd" || colName == "businessPlaceCd" || colName == "ccCd" || colName == "retAlrYn"|| colName == "retTaxdedYn") {
				if (sheet1.GetCellValue(Row, "payPeopleStatus") == "1") { // P.작업대상
					alert("<msg:txt mid='109999' mdef='대상자 확정여부를 취소후 입력해 주시기 바랍니다.'/>");
					return;
				}
			}

			if (colName == "payPeopleStatus") {
				if (sheet1.GetCellValue(Row, "sStatus") == "I") {
					if (sheet1.GetCellValue(Row, "payPeopleStatus") == "1") { // P.작업대상
						sheet1.SetCellValue(Row, "payPeopleStatus", "0"); // W.미확정
					} else {
						sheet1.SetCellValue(Row, "payPeopleStatus", "1"); // P.작업대상
					}
					alert("<msg:txt mid='109545' mdef='저장후 선택해 주시기 바랍니다.'/>");
				}
			}
			*/
		}
	} catch(ex) {alert("OnClick Event Error : " + ex);}
}

function sheet1_OnChange(Row, Col, Value) {
	try{
		var colName = sheet1.ColSaveName(Col);
		if (Row > 0) {
			/*
			if (colName == "payPeopleStatus") {
				// P_CPN_SEP_EMP_UPD 호출을 위해 대상자 확정여부 변경여부 판단
				var payPeopleStatusChgYn = sheet1.GetCellValue(Row, "payPeopleStatusChgYn");
				if (payPeopleStatusChgYn == "Y") {
					payPeopleStatusChgYn = "";
				} else {
					payPeopleStatusChgYn = "Y";
				}
				sheet1.SetCellValue(Row, "payPeopleStatusChgYn", payPeopleStatusChgYn);

				if (sheet1.GetCellValue(Row, "payPeopleStatus") == "1") { // P.작업대상
					sheet1.SetCellEditable(Row, "empYmd", 0);
					sheet1.SetCellEditable(Row, "adjYmd", 0);
					sheet1.SetCellEditable(Row, "retYmd", 0);
					sheet1.SetCellEditable(Row, "businessPlaceCd", 0);
					sheet1.SetCellEditable(Row, "ccCd", 0);
					sheet1.SetCellEditable(Row, "retAlrYn", 0);
					sheet1.SetCellEditable(Row, "retTaxdedYn", 0);
				} else {
					sheet1.SetCellEditable(Row, "empYmd", 1);
					sheet1.SetCellEditable(Row, "adjYmd", 1);
					sheet1.SetCellEditable(Row, "retYmd", 1);
					sheet1.SetCellEditable(Row, "businessPlaceCd", 1);
					sheet1.SetCellEditable(Row, "ccCd", 1);
					sheet1.SetCellEditable(Row, "retAlrYn", 1);
					sheet1.SetCellEditable(Row, "retTaxdedYn", 1);
				}
			}
			*/
			// 시작일자와 종료일자 체크
			if (colName == "empYmd" || colName == "retYmd") {
				checkNMDate2(sheet1, Row, Col, "입사", "퇴사", "empYmd", "retYmd");
			}
			if (colName == "adjYmd" || colName == "retYmd") {
				checkNMDate2(sheet1, Row, Col, "중도산정", "퇴사", "adjYmd", "retYmd");
			}
			if (colName == "empYmd" || colName == "adjYmd") {
				checkNMDate2(sheet1, Row, Col, "입사", "중도산정", "empYmd", "adjYmd");
			}
		}

	} catch(ex) {alert("OnChange Event Error : " + ex);}
}

// 최근급여일자 조회
function getCpnLatestPaymentInfo() {
	var procNm = "최근급여일자";
	// 급여구분(C00001-00004.퇴직금)
	var paymentInfo = ajaxCall("${ctx}/SepPayEmpMgr.do?cmd=getCpnQueryList", "queryId=getCpnLatestPaymentInfoMap&procNm="+procNm+"&runType=00004,", false);

	if (paymentInfo.DATA != null && paymentInfo.DATA != "" && typeof paymentInfo.DATA[0] != "undefined") {
		$("#payActionCd").val(paymentInfo.DATA[0].payActionCd);
		$("#payActionNm").val(paymentInfo.DATA[0].payActionNm);

		if ($("#payActionCd").val() != null && $("#payActionCd").val() != "") {
			doAction1("SearchBasic");
//			doAction1("Search");
		}
	} else if (paymentInfo.Message != null && paymentInfo.Message != "") {
		alert(paymentInfo.Message);
	}
}


//  급여일자 조회 팝업
function openPayDayPopup(){
	let parameters = {
		runType : '00004'
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
					$("#payActionCd").val(result.payActionCd);
					$("#payActionNm").val(result.payActionNm);
					doAction1("Search");
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

		if ($("#payActionCd").val() != null && $("#payActionCd").val() != "") {
			doAction1("SearchBasic");
			doAction1("Search");
		}
    }
}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form">
	<input type="hidden" id="searchPayActionCd" name="searchPayActionCd" value="" />
	<table border="0" cellpadding="0" cellspacing="0" class="default outer">
		<colgroup>
			<col width="15%" />
			<col width="35%" />
			<col width="15%" />
			<col width="35%" />
		</colgroup>
		<tr>
			<th><tit:txt mid='113397' mdef='퇴직일자'/></th>
			<td> <input type="hidden" id="payActionCd" name="payActionCd" value="" />
				 <input type="text" id="payActionNm" name="payActionNm" class="text required readonly" value="" readonly style="width:180px" />
				 <a onclick="javascript:openPayDayPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
				 <input type="hidden" id="closeYn" name="closeYn" value="" /></td>
			<th><tit:txt mid='103863' mdef='대상자'/></th>
			<td> <btn:a href="javascript:doAction1('prcP_CPN_SEP_EMP_INS')"			css="basic authA" mid='111039' mdef="대상자선정"/>
			<%--
				 <btn:a href="javascript:doAction1('prcP_CPN_SEP_EMP_UPD')"	css="basic authA" mid='111666' mdef="대상자확정"/>
				 <btn:a href="javascript:doAction1('prcP_CPN_SEP_EMP_DEL')"	css="basic authA" mid='111167' mdef="대상자확정취소"/>
			--%>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='112458' mdef='퇴직구분'/></th>
			<td id="payNm"> </td>
			<th><tit:txt mid='112700' mdef='지급일자'/></th>
			<td id="paymentYmd"> </td>
		</tr>
		<tr>
			<th><tit:txt mid='114399' mdef='사업장'/></th>
			<td> <select id="businessPlaceCd" name="businessPlaceCd"> </select> </td>
			<th><tit:txt mid='104535' mdef='기준일'/></th>
			<td id="ordYmd"> </td>
		</tr>
	</table>
	<div class="outer">
		<div class="sheet_title">
			<ul>
				<li id="txt" class="txt"><tit:txt mid='sepPayEmpMgr' mdef='퇴직금대상자관리'/></li>
				<li class="btn">
					<span><tit:txt mid='104330' mdef='사번/성명'/></span>
					&nbsp;<input type="text" id="sabunName" name="sabunName" class="text" value="" />
					<btn:a href="javascript:doAction1('Search')"		css="button authR" mid='110697' mdef="조회"/>
					<btn:a href="javascript:doAction1('Insert')"		css="basic authA" mid='110700' mdef="입력"/>
					<btn:a href="javascript:doAction1('Copy')"			css="basic authA" mid='110696' mdef="복사"/>
					<btn:a href="javascript:doAction1('Save')"			css="basic authA" mid='110708' mdef="저장"/>
					<btn:a href="javascript:doAction1('LoadExcel')"		css="basic authA" mid='110703' mdef="업로드"/>
					<btn:a href="javascript:doAction1('Down2Excel')"	css="basic authR" mid='110698' mdef="다운로드"/>
				</li>
			</ul>
		</div>
	</div>
	</form>
	<script type="text/javascript">createIBSheet("sheet1", "50%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>