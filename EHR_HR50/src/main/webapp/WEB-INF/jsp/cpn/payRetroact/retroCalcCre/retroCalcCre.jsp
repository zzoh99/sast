<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='112462' mdef='소급계산'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 소급계산
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
		{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",			Sort:0 },
		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",			Sort:0 },
		{Header:"<sht:txt mid='businessPlaceCdV2' mdef='사업장'/>",		Type:"Combo",		Hidden:0,					Width:120,			Align:"Center",	ColMerge:0,	SaveName:"businessPlaceCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='benefitBizCdV2' mdef='복리후생업무구분'/>", Type:"Combo",     Hidden:0,  					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"benefitBizCd",	KeyField:0, Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
		{Header:"<sht:txt mid='closeSt' mdef='마감상태'/>",		Type:"Combo",		Hidden:0,					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"closeSt",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='interface' mdef='연계처리'/>",		Type:"CheckBox",	Hidden:1,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 }
	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);

	//------------------------------------- 그리드 콤보 -------------------------------------//
	// 사업장(TCPN121)
	var tcpn121Cd = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getTcpn121List", false).codeList, "");
	sheet1.SetColProperty("businessPlaceCd", {ComboText:tcpn121Cd[0], ComboCode:tcpn121Cd[1]});

	//복리후생업무구분(B10230)
	var benefitBizCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","B10230"), "");
	sheet1.SetColProperty("benefitBizCd", {ComboText:benefitBizCdList[0], ComboCode:benefitBizCdList[1]} );

	// 마감상태코드(S90003)
	var closeSt = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "S90003"), "");
	sheet1.SetColProperty("closeSt", {ComboText:closeSt[0], ComboCode:closeSt[1]});

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

	// 최근급여일자 조회
	getCpnLatestPaymentInfo();
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
	if ($("#payCalcCloseYn").is(":checked") == true) {
		alert("<msg:txt mid='alertPayCalcCre1' mdef='이미 마감되었습니다.'/>");
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

			if (basicInfo.Map != null) {
				basicInfo = basicInfo.Map;
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

		case "SearchPeople":
			// 인원정보조회
			var peopleInfo = ajaxCall("${ctx}/RetroCalcCre.do?cmd=getRetroCalcCrePeopleMap", $("#sheet1Form").serialize(), false);
			$("#peopleTotCnt"	).html("");
			$("#peopleSubCnt"	).html("");
			$("#peoplePCnt"		).html("");
			$("#peopleJCnt"		).html("");
			$("#addTaxRate"		).html("");

			if (peopleInfo.Map != null) {
				peopleInfo = peopleInfo.Map;
				$("#peopleTotCnt"	).html(peopleInfo.peopleTotCnt);
				$("#peopleSubCnt"	).html(peopleInfo.peopleSubCnt);
				$("#peoplePCnt"		).html(peopleInfo.peoplePCnt);
				$("#peopleJCnt"		).html(peopleInfo.peopleJCnt);
				$("#addTaxRate"		).html(peopleInfo.addTaxRate);

				if ( peopleInfo.cnt != null){
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
			sheet1.DoSearch("${ctx}/RetroCalcCre.do?cmd=getRetroCalcCreCloseList", $("#sheet1Form").serialize());
			break;

		case "SavePeopleStatus":
			// 작업대상전체 체크박스 클릭시 급여대상자상태 변경

			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			if ($("#peopleTotCnt").html() != null && $("#peopleTotCnt").html() != "") {
				if (parseInt($("#peopleTotCnt").html()) <= 0) {
					alert("<msg:txt mid='109854' mdef='인원을 확인하십시오.'/>");
					break;
				}
			} else {
				alert("<msg:txt mid='109854' mdef='인원을 확인하십시오.'/>");
				break;
			}

			if ($("#peopleJCnt").html() != null && $("#peopleJCnt").html() != "") {
				if (parseInt($("#peopleJCnt").html()) > 0) {
					alert("<msg:txt mid='110425' mdef='작업완료인원이 존재합니다.n작업취소를 먼저하십시오.'/>");
					if ($("#peoplePTot")[0].checked == true) $("#peoplePTot")[0].checked = false;
					else $("#peoplePTot")[0].checked = true;
					break;
				}
			}

			var confirmMsg = "";
			if ($("#peoplePTot")[0].checked == true) {
				confirmMsg = "대상인원전체를 작업대상인원으로 변경하시겠습니까?";
				// 작업대상
				$("#payPeopleStatus").val("P");
			} else {
				confirmMsg = "작업대상인원을 초기화하시겠습니까?";
				// 대상
				$("#payPeopleStatus").val("C");
			}

			if (confirm(confirmMsg)) {

				// 급여대상자상태 변경
				var result = ajaxCall("${ctx}/RetroCalcCre.do?cmd=saveRetroCalcCrePeopleStatus", $("#sheet1Form").serialize(), false);

				if (result != null && result["Result"] != null && result["Result"]["Code"] != null) {
					if (parseInt(result["Result"]["Code"]) > 0) {
						// 인원정보 재조회
						doAction1("SearchPeople");
					} else if (result["Result"]["Message"] != null) {
						alert(result["Result"]["Message"]);
					}
				} else {
					alert("<msg:txt mid='109359' mdef='처리 중 오류입니다.'/>");
				}

			} else {

				if ($("#peoplePTot")[0].checked == true) $("#peoplePTot")[0].checked = false;
				else $("#peoplePTot")[0].checked = true;

			}
			break;

		case "PrcP_CPN_RE_PAY_MAIN":
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
				alert("<msg:txt mid='109855' mdef='총인원을 확인하십시오.'/>");
				break;
			}
*/
			if ($("#peoplePCnt").html() == null || $("#peoplePCnt").html() == "" || $("#peoplePCnt").html() == "0") {
				alert("<msg:txt mid='109360' mdef='작업대상 인원을 확인하십시오.'/>");
				break;
			}

			if ($("#peopleJCnt").html() != null && $("#peopleJCnt").html() != "") {
				if (parseInt($("#peopleJCnt").html()) > 0) {
					alert("<msg:txt mid='110148' mdef='작업완료인원이 존재합니다.n작업취소후 작업하실 수 있습니다.'/>");
					break;
				}
			}

			if (confirm("<msg:txt mid='114764' mdef='[소급계산] 작업을 수행하시겠습니까?'/>")) {

				var payActionCd = $("#payActionCd").val();
				var businessPlaceCd = $("#businessPlaceCd").val();

				$.ajax({
					url : "${ctx}/RetroCalcCreProc.do?cmd=prcP_CPN_RE_PAY_MAIN",
					type : "post",
					dataType : "json",
					async : true,
					data : "payActionCd="+payActionCd+"&businessPlaceCd="+businessPlaceCd,
					success : function(result) {

						if (result != null && result["Result"] != null && result["Result"]["Code"] != null) {
							if (result["Result"]["Code"] == "0") {
								alert("<msg:txt mid='alertRetroCalcCre8' mdef='소급계산 되었습니다.'/>");
								// 프로시저 호출 후 인원정보 재조회
								doAction1("SearchPeople");
							} else if (result["Result"]["Message"] != null && result["Result"]["Message"] != "") {
								alert(result["Result"]["Message"]);
							}
						} else {
							alert("<msg:txt mid='alertRetroCalcCre9' mdef='소급계산 오류입니다.'/>");
						}

					},
					error : function(jqXHR, ajaxSettings, thrownError) {
						ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
					}
				});

				// 진행상태 팝업 OPEN
				openProcessBar();
			}
			break;

		case "PrcP_CPN_RE_PAY_CANCEL":
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
					alert("<msg:txt mid='alertRetroCalcCre10' mdef='작업완료 인원이 존재하지 않습니다.'/>");
					break;
				}
			} else {
				alert("<msg:txt mid='alertRetroCalcCre10' mdef='작업완료 인원이 존재하지 않습니다.'/>");
				break;
			}

			if (confirm("<msg:txt mid='114757' mdef='[소급계산] 작업취소를 수행하시겠습니까?'/>")) {

				var payActionCd = $("#payActionCd").val();
				var businessPlaceCd = $("#businessPlaceCd").val();
				// 소급계산 취소
				var result = ajaxCall("${ctx}/RetroCalcCre.do?cmd=prcP_CPN_RE_PAY_CANCEL", "payActionCd="+payActionCd+"&businessPlaceCd="+businessPlaceCd, false);

				if (result != null && result["Result"] != null && result["Result"]["Code"] != null) {
					if (result["Result"]["Code"] == "0") {
						alert("<msg:txt mid='110152' mdef='소급계산 취소 되었습니다.'/>");
						// 프로시저 호출 후 인원정보 재조회
						doAction1("SearchPeople");
					} else if (result["Result"]["Message"] != null && result["Result"]["Message"] != "") {
						alert(result["Result"]["Message"]);
					}
				} else {
					alert("<msg:txt mid='alertRetroCalcCre13' mdef='소급계산 취소 오류입니다.'/>");
				}

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
					alert("<msg:txt mid='alertPayCalcCre10' mdef='대상인원이 존재하지 않습니다.\n마감할 수 없습니다.'/>");
					break;
				}
			} else {
				alert("<msg:txt mid='alertPayCalcCre10' mdef='대상인원이 존재하지 않습니다.\n마감할 수 없습니다.'/>");
				break;
			}

			if ($("#peopleJCnt").html() != null && $("#peopleJCnt").html() != "") {
				if ($("#peopleSubCnt").html() != $("#peopleJCnt").html()) {
					alert("<msg:txt mid='alertPayCalcCre11' mdef='대상인원과 작업완료인원이 일치하지 않습니다.\n마감할 수 없습니다.'/>");
					break;
				}
			} else {
				alert("<msg:txt mid='alertPayCalcCre11' mdef='대상인원과 작업완료인원이 일치하지 않습니다.\n마감할 수 없습니다.'/>");
				break;
			}

			if (confirm("<msg:txt mid='114794' mdef='[마감] 작업을 수행하시겠습니까?'/>")) {

				var procNm = "마감";
				var payActionCd = $("#payActionCd").val();

				// 마감
				var result = ajaxCall("${ctx}/CpnQuery.do?cmd=saveCpnQuery", "queryId=saveCpnCloseYn&procNm="+procNm+"&closeYn=Y&payActionCd="+payActionCd, false);

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
					alert("<msg:txt mid='alertPayCalcCre13' mdef='마감 오류입니다.'/>");
				}

			}
			break;

		case "CancelClose":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			if ($("#payCalcCloseYn").is(":checked") == false) {
				alert("<msg:txt mid='109362' mdef='마감되지않은 소급계산작업입니다.'/>");
				break;
			}

			if (confirm("[마감취소] 작업을 수행하시겠습니까?")) {

				var procNm = "마감취소";
				var payActionCd = $("#payActionCd").val();

				// 마감취소
				var result = ajaxCall("${ctx}/CpnQuery.do?cmd=saveCpnQuery", "queryId=saveCpnCloseYn&procNm="+procNm+"&closeYn=N&payActionCd="+payActionCd, false);

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
					alert("<msg:txt mid='alertPayCalcCre16' mdef='마감취소 오류입니다.'/>");
				}

			}
			break;

		case "Clear":
			sheet1.RemoveAll();
			break;
	}
}

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

// 최근급여일자 조회
function getCpnLatestPaymentInfo() {
	var procNm = "최근급여일자";
	// 급여구분(C00001-RETRO.소급)
	var paymentInfo = ajaxCall("${ctx}/CpnQuery.do?cmd=getCpnQueryList", "queryId=getCpnLatestPaymentInfoMap&procNm="+procNm+"&runType=RETRO", false);

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

// 급여일자 검색 팝입
function payActionSearchPopup() {
	if(!isPopup()) {return;}
	gPRow = "";
	pGubun = "payDayPopup";

	var w 		= 840;
	var h 		= 520;
	var url 	= "/PayDayPopup.do?cmd=payDayPopup";
	var args 	= new Array();
	args["runType"] = "RETRO"; // 급여구분(C00001-RETRO.소급)

	var result = openPopup(url+"&authPg=R", args, w, h);
	/*
	if (result) {
		var payActionCd	= result["payActionCd"];
		var payActionNm	= result["payActionNm"];
		var payCd		= result["payCd"];

		$("#payActionCd").val(payActionCd);
		$("#payActionNm").val(payActionNm);
		$("#payCd").val(payCd);

		if ($("#payActionCd").val() != null && $("#payActionCd").val() != "") {
			doAction1("SearchBasic");
			doAction1("SearchPeople");
			doAction1("Search");
		}
	}
	*/
}

// 대상자선정 팝업
function openPeopleSet() {

	if(!isPopup()) {return;}
	gPRow = "";
	pGubun = "viewPeopleSetPopup";
	// 필수값/유효성 체크
	if (!chkInVal("PeopleSetPopup")) {
		return;
	}

	var w		= 1000;
	var h		= 700;
	var url		= "/RetroCalcCre.do?cmd=viewPeopleSetPopup";
	var args	= new Array();

	args["payActionCd"] = $("#payActionCd").val();
	args["payActionNm"]	= $("#payActionNm").val();
	if ($("#businessPlaceCd").val() != null && $("#businessPlaceCd").val() != "") {
		args["businessPlaceCd"]	= $("#businessPlaceCd").val();
		args["businessPlaceNm"]	= $("#businessPlaceCd option:selected").text();
	} else {
		args["businessPlaceCd"]	= "";
		args["businessPlaceNm"]	= "";
	}
	args["closeYn"]	= "N";
	if ($("#payCalcCloseYn").is(":checked") == true) {
		args["closeYn"] = "Y";
	}

	openPopup(url+"&authPg=${authPg}", args, w, h);

	// 인원정보 조회
	doAction1("SearchPeople");
}

// 작업 프로그램 진행현황 팝업
function openProcessBar() {
	if(!isPopup()) {return;}
	gPRow = "";
	pGubun = "viewCpnProcessBarComPopup";

	var w 		= 470;
	var h 		= 300;
	var url 	= "/CpnComPopup.do?cmd=viewCpnProcessBarComPopup";
	var args    = new Array();

	args["prgCd"] = "P_CPN_RE_PAY_MAIN";
	args["payActionCd"]	= $("#payActionCd").val();
	args["payActionNm"]	= $("#payActionNm").val();

	openPopup(url+"&authPg=R", args, w, h);
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
    	$("#peoplePCnt"		).html("");
    	$("#peopleJCnt"		).html("");

    	$("#peopleTotCnt"	).html(rv["peopleTotCnt"]);
    	$("#peopleSubCnt"	).html(rv["peopleSubCnt"]);
    	$("#peoplePCnt"		).html(rv["peoplePCnt"]);
    	$("#peopleJCnt"		).html(rv["peopleJCnt"]);

    }
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
				<th><tit:txt mid='104477' mdef='급여일자'/></th>
				<td> <input type="hidden" id="payActionCd" name="payActionCd" value="" />
					 <input type="text" id="payActionNm" name="payActionNm" class="text required readonly" value="" readonly style="width:180px" />
					 <a onclick="javascript:payActionSearchPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
					 <input type="hidden" id="payPeopleStatus" name="payPeopleStatus" value="" /><input type="hidden" id="payCd" name="payCd" value="" /></td>
				<th><tit:txt mid='112032' mdef='급여구분'/></th>
				<td id="payNm"> </td>
			</tr>
			<tr>
				<th><tit:txt mid='114444' mdef='대상년월'/></th>
				<td id="payYm"> </td>
				<th><tit:txt mid='112700' mdef='지급일자'/></th>
				<td id="paymentYmd"> </td>
			</tr>
			<tr>
				<th><tit:txt mid='114399' mdef='사업장'/></th>
				<td> <select id="businessPlaceCd" name="businessPlaceCd"> </select> </td>
				<th><tit:txt mid='112374' mdef='근태기준년월'/></th>
				<td id="timeYm"> </td>
			</tr>
		</table>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<colgroup>
			<col width="50%" />
			<col width="1%" />
			<col width="49%" />
		</colgroup>
		<tr>
			<td>
				<div class="outer">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='payCalcCre1' mdef='복리후생 마감현황'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Search')"	css="button authR" mid='110697' mdef="조회"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "50%", "100%", "${ssnLocaleCd}"); </script>
			</td>
			<td>
			</td>
			<td class="top">
				<div class="sheet_title">
					<ul>
						<li id="txt" class="txt"><tit:txt mid='payCalcCre2' mdef='처리조건'/></li>
						<li class="btn"><btn:a href="javascript:openPeopleSet()"	css="basic authR" mid='110739' mdef="대상자 기준"/></li>
					</ul>
				</div>
				<table border="0" cellpadding="0" cellspacing="0" class="default">
					<colgroup>
						<col width="25%" />
						<col width="25%" />
						<col width="25%" />
						<col width="25%" />
					</colgroup>
					<tr>
						<th><tit:txt mid='114514' mdef='세금계산'/></th>
						<td id="calTaxMethod" colspan="3"> </td>
					</tr>
					<tr>
						<th><tit:txt mid='113789' mdef='세금가중치'/></th>
						<td id="addTaxRate" colspan="3"> </td>
					</tr>
					<tr>
						<th><tit:txt mid='112255' mdef='총인원'/></th>
						<td id="peopleTotCnt"> </td>
						<th><tit:txt mid='114367' mdef='대상인원'/></th>
						<td id="peopleSubCnt"> </td>
					</tr>
					<tr>
						<th><tit:txt mid='113790' mdef='작업대상인원'/></th>
						<td id="peoplePCnt"> </td>
						<th><tit:txt mid='113434' mdef='작업완료인원'/></th>
						<td id="peopleJCnt"> </td>
					</tr>
					<tr>
						<th><tit:txt mid='112378' mdef='작업대상전체'/></th>
						<td colspan="3"><input type="checkbox" id="peoplePTot" name="peoplePTot" value="N" class="checkbox" onClick="javascript:doAction1('SavePeopleStatus');">
										<btn:a href="javascript:doAction1('PrcP_CPN_RE_PAY_MAIN')"		css="basic authA" mid='110741' mdef="작업"/>
										<btn:a href="javascript:doAction1('PrcP_CPN_RE_PAY_CANCEL')"	css="basic authA" mid='111032' mdef="작업취소"/>
										<btn:a href="javascript:openProcessBar()"						css="basic authA" mid='111643' mdef="진행상태"/></td>
					</tr>
					<tr>
						<th><tit:txt mid='114606' mdef='소급계산 마감여부'/></th>
						<td colspan="3"><input id="payCalcCloseYn" name="payCalcCloseYn" type="checkbox" class="checkbox" disabled/>
										<btn:a href="javascript:doAction1('Close')"			css="basic authA" mid='110835' mdef="마감"/>
										<btn:a href="javascript:doAction1('CancelClose')"	css="basic authA" mid='110766' mdef="마감취소"/></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
