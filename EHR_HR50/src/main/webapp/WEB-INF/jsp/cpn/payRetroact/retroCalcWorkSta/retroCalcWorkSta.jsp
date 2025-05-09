<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='retroCalcWorkSta' mdef='소급작업결과조회'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 소급작업결과조회
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
		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",			Sort:0 },
		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",			Sort:0 },
		{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",			Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",			Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",		Type:"Text",		Hidden:Number("${aliasHdn}"),					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"alias",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",			Type:"Text",		Hidden:0,					Width:120,			Align:"Center",	ColMerge:0,	SaveName:"orgNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",			Type:"Combo",		Hidden:Number("${jgHdn}"),					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",			Type:"Combo",		Hidden:Number("${jwHdn}"),					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='businessPlaceCdV3' mdef='급여사업장'/>",		Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"businessPlaceCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='salClassNm' mdef='호봉'/>",			Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"salClass",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='empYmd' mdef='입사일'/>",			Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"empYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='gempYmd' mdef='그룹입사일'/>",		Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"gempYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 }
	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);
	
	//------------------------------------- 그리드 콤보 -------------------------------------//
	// 직급코드(H20010)
	var jikgubCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20010"), "");
	sheet1.SetColProperty("jikgubCd", {ComboText:jikgubCd[0], ComboCode:jikgubCd[1]});

	// 직위코드(H20030)
	var jikweeCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20030"), "");
	sheet1.SetColProperty("jikweeCd", {ComboText:jikweeCd[0], ComboCode:jikweeCd[1]});

	// 사업장
	<c:choose>
		<c:when test="${ssnSearchType == 'A'}">
			var tcpn121Cd = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getTcpn121List", false).codeList, "<tit:txt mid='103895' mdef='전체'/>");
		</c:when>
		<c:otherwise>
			var tcpn121Cd = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getTcpn121List", false).codeList, "");
		</c:otherwise>
	</c:choose>
	sheet1.SetColProperty("businessPlaceCd", {ComboText:tcpn121Cd[0], ComboCode:tcpn121Cd[1]});

	//------------------------------------- 조회조건 콤보 -------------------------------------//
	$("#businessPlaceCd").html(tcpn121Cd[2]);

	$(window).smartresize(sheetResize);
	sheetInit();

	
	// 최근급여일자 조회
	getCpnLatestPaymentInfo();
});

// 필수값/유효성 체크
function chkInVal() {
	if ($("#payActionCd").val() == "") {
		alert("<msg:txt mid='109681' mdef='급여일자를 선택하십시오.'/>");
		$("#payActionNm").focus();
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

			// 급여구분별 항목리스트 조회
			searchTitleList();

			sheet1.DoSearch("${ctx}/RetroCalcWorkSta.do?cmd=getRetroCalcWorkStaList", $("#sheet1Form").serialize());
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

function searchTitleList() {
	// 급여구분별 항목리스트 조회
	var titleList = ajaxCall("${ctx}/RetroCalcWorkSta.do?cmd=getRetroCalcWorkStaTitleList", $("#sheet1Form").serialize(), false);

	if (titleList != null && titleList.DATA != null) {

		// IBSheet에 설정된 모든 기본 속성을 제거하고 초기상태로 변경한다.
		sheet1.Reset();

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad, Page:22};
		initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};

		var jj = 0;
		initdata1.Cols = [];
		initdata1.Cols[jj++] = {Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" };
		initdata1.Cols[jj++] = {Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",			Sort:0 };
		initdata1.Cols[jj++] = {Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",			Sort:0 };
		initdata1.Cols[jj++] = {Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 };
		initdata1.Cols[jj++] = {Header:"<sht:txt mid='appNameV1' mdef='성명'/>",		Type:"Text",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
		initdata1.Cols[jj++] = {Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",	Type:"Text",		Hidden:Number("${aliasHdn}"),					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"alias",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
		initdata1.Cols[jj++] = {Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",		Type:"Text",		Hidden:0,					Width:120,			Align:"Center",	ColMerge:0,	SaveName:"orgNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 };
		initdata1.Cols[jj++] = {Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",		Type:"Combo",		Hidden:Number("${jgHdn}"),					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 };
		initdata1.Cols[jj++] = {Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",		Type:"Combo",		Hidden:Number("${jwHdn}"),					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 };
		initdata1.Cols[jj++] = {Header:"<sht:txt mid='businessPlaceCdV3' mdef='급여사업장'/>",Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"businessPlaceCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 };
		initdata1.Cols[jj++] = {Header:"<sht:txt mid='salClassNm' mdef='호봉'/>",		Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"salClass",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 };
		initdata1.Cols[jj++] = {Header:"<sht:txt mid='empYmd' mdef='입사일'/>",	Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"empYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 };
		initdata1.Cols[jj++] = {Header:"<sht:txt mid='gempYmd' mdef='그룹입사일'/>",Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"gempYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 };

		var elementCd = "";
		var gapElementCd = "";
		var eleIdx = 0;
		for(var i=0; i<titleList.DATA.length; i++) {
			elementCd = convCamel(titleList.DATA[i].elementCd);
			gapElementCd = convCamel(titleList.DATA[i].gapElementCd);
			var idx1 = (i*2);
			var idx2 = (i*2)+1;
			initdata1.Cols[idx1+11] = {Header:titleList.DATA[i].elementNm,Type:"AutoSum",	Hidden:0,	Width:120,	Align:"Right",	ColMerge:0,	SaveName:elementCd,	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
			initdata1.Cols[idx2+11] = {Header:titleList.DATA[i].elementNm+"_차액",Type:"AutoSum",	Hidden:0,	Width:120,	Align:"Right",	ColMerge:0,	SaveName:gapElementCd,	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
			eleIdx = idx2+11;
		}
		initdata1.Cols[eleIdx+1] = {Header:"<sht:txt mid='element12' mdef='과세총액'/>", Type:"AutoSum",	Hidden:0,	Width:120,	Align:"Right",	ColMerge:0,	SaveName:"gapElement12",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
		initdata1.Cols[eleIdx+2] = {Header:"<sht:txt mid='element13' mdef='지급총액'/>", Type:"AutoSum",	Hidden:0,	Width:120,	Align:"Right",	ColMerge:0,	SaveName:"gapElement13",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
		initdata1.Cols[eleIdx+3] = {Header:"<sht:txt mid='element15' mdef='공제총액'/>", Type:"AutoSum",	Hidden:0,	Width:120,	Align:"Right",	ColMerge:0,	SaveName:"gapElement15",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
		initdata1.Cols[eleIdx+4] = {Header:"<sht:txt mid='element16' mdef='실지급액'/>", Type:"AutoSum",	Hidden:0,	Width:120,	Align:"Right",	ColMerge:0,	SaveName:"gapElement16",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
		//initdata1.Cols[eleIdx+5] = {Header:titleList.DATA[i]."과세총액",Type:"AutoSum",	Hidden:0,	Width:120,	Align:"Right",	ColMerge:0,	SaveName:"gapElementCd16",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
		IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);

		//------------------------------------- 그리드 콤보 -------------------------------------//
		// 직급코드(H20010)
		var jikgubCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20010"), "");
		sheet1.SetColProperty("jikgubCd", {ComboText:jikgubCd[0], ComboCode:jikgubCd[1]});

		// 직위코드(H20030)
		var jikweeCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20030"), "");
		sheet1.SetColProperty("jikweeCd", {ComboText:jikweeCd[0], ComboCode:jikweeCd[1]});

		// 사업장(TCPN121)
		var tcpn121Cd = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getTcpn121List", false).codeList, "");
		sheet1.SetColProperty("businessPlaceCd", {ComboText:tcpn121Cd[0], ComboCode:tcpn121Cd[1]});
		
		sheet1.FitColWidth();
	}
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

// 소급대상급여계산코드 LIST 조회
function getRtrPayActionCdList() {
	var payActionCd = $("#payActionCd").val();

	var tcpn503Cd = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&payActionCd="+payActionCd, "queryId=getTcpn503List", false).codeList, "<tit:txt mid='103895' mdef='전체'/>");
	if (tcpn503Cd == false) {
		$("#rtrPayActionCd").html("<option value=''><tit:txt mid='103895' mdef='전체'/></option>");
	} else {
		$("#rtrPayActionCd").html(tcpn503Cd[2]);
	}
}

// 최근급여일자 조회
function getCpnLatestPaymentInfo() {
	var procNm = "최근급여일자";
	// 급여구분(C00001-RETRO.소급)
	var paymentInfo = ajaxCall("${ctx}/RetroCalcWorkSta.do?cmd=getCpnQueryList", "queryId=getCpnLatestPaymentInfoMap&procNm="+procNm+"&runType=RETRO,", false);

	if (paymentInfo.DATA != null && paymentInfo.DATA != "" && typeof paymentInfo.DATA[0] != "undefined") {
		$("#payActionCd").val(paymentInfo.DATA[0].payActionCd);
		$("#payActionNm").val(paymentInfo.DATA[0].payActionNm);
		$("#payCd").val(paymentInfo.DATA[0].payCd);

		if ($("#payActionCd").val() != null && $("#payActionCd").val() != "") {
			// 소급대상급여계산코드 LIST 조회
			getRtrPayActionCdList();
		}
	} else if (paymentInfo.Message != null && paymentInfo.Message != "") {
		alert(paymentInfo.Message);
	}

	if ($("#payActionCd").val() == null || $("#payActionCd").val() == "") {
		$("#rtrPayActionCd").html("<option value=''><tit:txt mid='103895' mdef='전체'/></option>");
	}
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
					$("#payCd").val(result.payCd);
					getRtrPayActionCdList();
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
	// var args	= new Array();
	//
	// args["runType"] = "RETRO";
	//
	// var result = openPopup(url+"&authPg=R", args, w, h);
	/*
	if (result) {
		var payActionCd	= result["payActionCd"];
		var payActionNm	= result["payActionNm"];
		var payCd		= result["payCd"];

		$("#payActionCd").val(payActionCd);
		$("#payActionNm").val(payActionNm);
		$("#payCd").val(payCd);
	}
	*/
}

function getReturnValue(returnValue) {
	var rv = $.parseJSON('{' + returnValue+ '}');

    if(pGubun == "payDayPopup"){
		$("#payActionCd").val(rv["payActionCd"]);
		$("#payActionNm").val(rv["payActionNm"]);
		$("#payCd").val(rv["payCd"]);
    }
}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form">
		<input type="hidden" id="payCd" name="payCd" value="" />
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='114569' mdef='소급일자'/></th>
						<td>  <input type="hidden" id="payActionCd" name="payActionCd" value=""/>
												<input type="text" id="payActionNm" name="payActionNm" class="text required readonly" value="" readonly style="width:180px" />
						 <a onclick="javascript:payActionSearchPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a> </td>
						 <th><tit:txt mid='104477' mdef='급여일자'/></th>
						<td>  <select id="rtrPayActionCd" name="rtrPayActionCd"> </select> </td>
						<th><tit:txt mid='114399' mdef='사업장'/></th>
						<td>  <select id="businessPlaceCd" name="businessPlaceCd"> </select> </td>
						<td> <btn:a href="javascript:doAction1('Search')"	css="button authR" mid='110697' mdef="조회"/> </td>
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
							<li id="txt" class="txt"><tit:txt mid='retroCalcWorkSta' mdef='소급작업결과조회'/></li>
							<li class="btn">
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
