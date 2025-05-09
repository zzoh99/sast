<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='103994' mdef='급여기본사항 급여압류'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 급여기본사항
 * @author JM
-->
<script type="text/javascript">
$(function() {
	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata1.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",			Sort:0 },
		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",			Sort:0 },
		{Header:"<sht:txt mid='attatchNo' mdef='접수번호'/>",		Type:"Text",		Hidden:0,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"attatchNo",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:20 },
		{Header:"<sht:txt mid='attatchSymd' mdef='접수일자'/>",		Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"attatchSymd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='debtContent' mdef='적요'/>",		Type:"Text",		Hidden:0,					Width:100,			Align:"Left",	ColMerge:0,	SaveName:"debtContent",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:2000 },
		{Header:"<sht:txt mid='bonder' mdef='채권자'/>",		Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"bonder",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:30 },
		{Header:"<sht:txt mid='attachMon' mdef='채권금액'/>",		Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"attachMon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"attatchStatus",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 }
	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);

	var initdata2 = {};
	initdata2.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata2.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata2.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },
		{Header:"<sht:txt mid='paymentYmdV2' mdef='공제일'/>",		Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"paymentYmd",	KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='payCdV3' mdef='급상구분'/>",		Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"payCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='element13' mdef='지급총액'/>",		Type:"AutoSum",		Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"paymentMon",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='element1070' mdef='소득세'/>",		Type:"AutoSum",		Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"itaxMon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='finInbitTaxMon' mdef='주민세'/>",		Type:"AutoSum",		Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"rtaxMon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='gubun3' mdef='국민연금'/>",		Type:"AutoSum",		Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"npEeMon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='hiEeMon' mdef='건강보험료'/>",	Type:"AutoSum",		Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"hiEeMon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='hiEeMon2' mdef='요양보험료'/>",	Type:"AutoSum",		Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"hiEeMon2",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='eiEeMon' mdef='고용보험료'/>",	Type:"AutoSum",		Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"eiEeMon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='monV1' mdef='압류금액'/>",		Type:"AutoSum",		Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 }
	]; IBS_InitSheet(sheet2, initdata2); sheet2.SetCountPosition(0);

	//------------------------------------- 그리드 콤보 -------------------------------------//
	// 압류진행상태(C00020)
	var attatchStatus = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "C00020"), "");
	sheet1.SetColProperty("attatchStatus", {ComboText:attatchStatus[0], ComboCode:attatchStatus[1]});

	// 급여구분(TCPN051)
	var payCd = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getCpnPayCdList", false).codeList, "<tit:txt mid='103895' mdef='전체'/>");
	sheet2.SetColProperty("payCd", {ComboText:payCd[0], ComboCode:payCd[1]});

	$(window).smartresize(sheetResize);
	sheetInit();

	if (parent.$("#searchSabunRef").val() != null && parent.$("#searchSabunRef").val() != "") {
		$("#sabun").val(parent.$("#searchSabunRef").val());
		doAction1("Search");
		doAction2("Search");
	}
});

// 필수값/유효성 체크
function chkInVal(sAction) {
	if(parent.$("#searchSabunRef").val() == "") {
		alert("<msg:txt mid='alertSepCalcBasicMgr1' mdef='대상자를 선택하십시오.'/>");
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

			$("#sabun").val(parent.$("#searchSabunRef").val());

			// 채권현황 조회
			sheet1.DoSearch("${ctx}/PerPayMasterMgr.do?cmd=getPerPayMasterMgrBondStateList", $("#sheet1Form").serialize());
			break;

		case "Clear":
			sheet1.RemoveAll();
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

			$("#sabun").val(parent.$("#searchSabunRef").val());

			// 공제현황 조회
			sheet2.DoSearch("${ctx}/PerPayMasterMgr.do?cmd=getPerPayMasterMgrDeductionStateList", $("#sheet1Form").serialize());
			break;

		case "Clear":
			sheet2.RemoveAll();
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

function setEmpPage() {
	doAction1("Search");
	doAction2("Search");
}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form">
	<input type="hidden" id="sabun" name="sabun" value="" />
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td class="top">
				<div class="outer">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='perPayMasterMgrPayAttach1' mdef='채권현황'/></li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "50%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td class="top">
				<div class="outer">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='perPayMasterMgrPayAttach2' mdef='공제현황'/></li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet2", "100%", "50%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
