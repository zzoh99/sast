<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='104491' mdef='급여기본사항 사회보험'/></title>
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
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22, MergeSheet:msHeaderOnly, FrozenCol:8};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata1.Cols = [
		{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V1' mdef='삭제|삭제'/>",				Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",			Sort:0 },
		{Header:"<sht:txt mid='sStatus V4' mdef='상태|상태'/>",				Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",			Sort:0 },
		{Header:"<sht:txt mid='payYear' mdef='귀속년도|귀속년도'/>",			Type:"Text",		Hidden:0,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"payYear",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='paymentYmdV3' mdef='급여반영일|급여반영일'/>",			Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"paymentYmd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='totEarningMonV1' mdef='소득총액|소득총액'/>",			Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"totEarningMon",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='monV2' mdef='보수월액|보수월액'/>",			Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='hiMon' mdef='보험료|보험료'/>",				Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"hiMon",				KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='workCnt' mdef='근무월수|근무월수'/>",			Type:"Int",			Hidden:0,					Width:70,			Align:"Right",	ColMerge:0,	SaveName:"workCnt",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='mon1V4' mdef='확정보험료|건강보험료'/>",			Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon1",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='mon2V3' mdef='확정보험료|요양보험료'/>",			Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon2",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='sum1' mdef='확정보험료|합계'/>",				Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"",				KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='mon3V3' mdef='납부한보험료|건강보험료'/>",		Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon3",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='mon4V3' mdef='납부한보험료|요양보험료'/>",		Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon4",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='sum2' mdef='납부한보험료|합계'/>",			Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"",				KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='mon5V1' mdef='추가납부/환급보험료|건강보험료'/>",	Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon5",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='mon6' mdef='추가납부/환급보험료|요양보험료'/>",	Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon6",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='sum3' mdef='추가납부/환급보험료|합계'/>",		Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"",				KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 }
	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);

	$(window).smartresize(sheetResize);
	sheetInit();

	if (parent.$("#searchSabunRef").val() != null && parent.$("#searchSabunRef").val() != "") {
		$("#sabun").val(parent.$("#searchSabunRef").val());
		doAction1("Search");
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

			// 현재불입상태 조회
			var payStatusInfo = ajaxCall("${ctx}/PerPayMasterMgr.do?cmd=getPerPayMasterMgrPayStatusList", $("#sheet1Form").serialize(), false);

			var cnt = 0;
			var htmlData = "";
			$("#payStatusTable").html("");

			if(payStatusInfo.DATA != null && typeof payStatusInfo.DATA[0] != "undefined") {
				cnt = payStatusInfo.DATA.length;

				for (var row = 0; row < cnt; row++) {
					htmlData = htmlData + "<tr>";
					htmlData = htmlData + "<th class='center'>";
					if(payStatusInfo.DATA != null && typeof payStatusInfo.DATA[row] != "undefined" && payStatusInfo.DATA[row].gubun != null) {
						htmlData = htmlData + payStatusInfo.DATA[row].gubun;
					}
					htmlData = htmlData + "</th>";
					htmlData = htmlData + "<td class='center'>";
					if(payStatusInfo.DATA != null && typeof payStatusInfo.DATA[row] != "undefined" && payStatusInfo.DATA[row].socStateNm != null) {
						htmlData = htmlData + payStatusInfo.DATA[row].socStateNm;
					}
					htmlData = htmlData + "</td>";
					htmlData = htmlData + "<td class='right'>";
					if(payStatusInfo.DATA != null && typeof payStatusInfo.DATA[row] != "undefined" && payStatusInfo.DATA[row].rewardTotMon != null) {
						htmlData = htmlData + payStatusInfo.DATA[row].rewardTotMon;
					}
					htmlData = htmlData + "</td>";
					htmlData = htmlData + "<td class='right'>";
					if(payStatusInfo.DATA != null && typeof payStatusInfo.DATA[row] != "undefined" && payStatusInfo.DATA[row].rate != null) {
						htmlData = htmlData + payStatusInfo.DATA[row].rate;
					}
					htmlData = htmlData + "</td>";
					htmlData = htmlData + "<td class='right'>";
					if(payStatusInfo.DATA != null && typeof payStatusInfo.DATA[row] != "undefined" && payStatusInfo.DATA[row].selfMon != null) {
						htmlData = htmlData + payStatusInfo.DATA[row].selfMon;
					}
					htmlData = htmlData + "</td>";
					htmlData = htmlData + "</tr>";
				}
				$("#payStatusTable").append(htmlData);
			}

			if (cnt == 0) {
				if (payStatusInfo.Message != null && payStatusInfo.Message != "") {
					// 조회실패
					alert(payStatusInfo.Message);
				}

				htmlData = htmlData + "<tr><th class='center'><tit:txt mid='103995' mdef='국민연금'/></th><td></td><td></td><td></td><td></td></tr>";
				htmlData = htmlData + "<tr><th class='center'><tit:txt mid='103996' mdef='건강보험'/></th><td></td><td></td><td></td><td></td></tr>";
				htmlData = htmlData + "<tr><th class='center'><tit:txt mid='104287' mdef='요양보험료'/></th><td></td><td></td><td></td><td></td></tr>";
				htmlData = htmlData + "<tr><th class='center'><tit:txt mid='104380' mdef='고용보험료'/></th><td></td><td></td><td></td><td></td></tr>";
				$("#payStatusTable").append(htmlData);
			}

			// 년도별 건강/요양보험료정산 조회
			sheet1.DoSearch("${ctx}/PerPayMasterMgr.do?cmd=getPerPayMasterMgrPremiumCalcList", $("#sheet1Form").serialize());
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

function setEmpPage() {
	doAction1("Search");
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
			<td>
				<div class="outer">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='perPayMasterMgrSocialInsurance1' mdef='현재불입상태'/></li>
						</ul>
					</div>
				</div>
			</td>
		</tr>
	</table>
	<table border="0" cellpadding="0" cellspacing="0" class="default outer">
	<colgroup>
		<col width="20%" />
		<col width="20%" />
		<col width="20%" />
		<col width="20%" />
		<col width="20%" />
	</colgroup>
	<tr>
		<th class="center"><tit:txt mid='103997' mdef='구분'/></th>
		<th class="center"><tit:txt mid='103796' mdef='불입상태'/></th>
		<th class="center"><tit:txt mid='104288' mdef='보수월액'/></th>
		<th class="center"><tit:txt mid='104381' mdef='보험료율'/></th>
		<th class="center"><tit:txt mid='104492' mdef='보험료'/></th>
	</tr>
	<tbody id="payStatusTable">
	<tr>
		<th class="center"><tit:txt mid='103995' mdef='국민연금'/></th>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
	</tr>
	<tr>
		<th class="center"><tit:txt mid='103996' mdef='건강보험'/></th>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
	</tr>
	<tr>
		<th class="center"><tit:txt mid='104287' mdef='요양보험료'/></th>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
	</tr>
	<tr>
		<th class="center"><tit:txt mid='104380' mdef='고용보험료'/></th>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
	</tr>
	</tbody>
	</table>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td class="top">
				<div class="outer">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='perPayMasterMgrSocialInsurance2' mdef='년도별 건강/요양보험료 정산'/></li>
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
