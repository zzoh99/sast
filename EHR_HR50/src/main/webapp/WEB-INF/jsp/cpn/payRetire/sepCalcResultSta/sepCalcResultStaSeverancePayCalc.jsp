<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>퇴직금결과내역 퇴직금계산내역</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 퇴직금결과내역
 * @author JM
-->
<script type="text/javascript">
$(function() {
	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0, Hidden:1};
	initdata1.Cols = [
		{Header:"No",	Type:"${sNoTy}",	Hidden:1,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제",	Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
		{Header:"상태",	Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },
		{Header:"항목명",	Type:"Text",		Hidden:0,	Width:100,			Align:"Left",	ColMerge:0,	SaveName:"elementNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"금액",	Type:"Text",		Hidden:0,	Width:100,			Align:"Right",	ColMerge:0,	SaveName:"resultMon",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"항목명",	Type:"Text",		Hidden:0,	Width:100,			Align:"Left",	ColMerge:0,	SaveName:"elementNm2",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"금액",	Type:"Text",		Hidden:0,	Width:100,			Align:"Right",	ColMerge:0,	SaveName:"resultMon2",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);

	sheet1.SetColBackColor("elementNm", "#ebeef0");
	sheet1.SetColBackColor("elementNm2", "#ebeef0");
	sheet1.SetColBackColor("resultMon", "#f7f9fc");
	sheet1.SetColBackColor("resultMon2", "#f7f9fc");

	// 타이틀 숨김
	sheet1.SetRowHidden("0", 1);

	$(window).smartresize(sheetResize);
	sheetInit();

	if (parent.$("#searchUserId").val() != null && parent.$("#searchUserId").val() != "" &&
		parent.$("#payActionCd").val() != null && parent.$("#payActionCd").val() != "") {
		$("#sabun").val(parent.$("#searchUserId").val());
		$("#payActionCd").val(parent.$("#payActionCd").val());
		doAction1("Search");
	}
});

// 필수값/유효성 체크
function chkInVal(sAction) {
	if(parent.$("#searchUserId").val() == "") {
		parent.$("#searchUserId").focus();
		return false;
	}
	if(parent.$("#payActionCd").val() == "") {
		parent.$("#payActionCd").focus();
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

			$("#sabun").val(parent.$("#searchUserId").val());
			$("#payActionCd").val(parent.$("#payActionCd").val());

			// 퇴직금계산내역 조회
			sheet1.DoSearch("${ctx}/SepCalcResultSta.do?cmd=getSepCalcResultStaSeverancePayCalcList", $("#sheet1Form").serialize());

			// 기본정보조회 조회
			var basicInfo = ajaxCall("${ctx}/SepCalcResultSta.do?cmd=getSepCalcResultStaBasicMap", $("#sheet1Form").serialize(), false);

			// 명세 display
			$("#sumTotEarningMon"	).val("");
			$("#totEarningMon"		).val("");
			$("#hTotEarningMon"		).val("");
			$("#totIncomeDedMon"	).val("");
			$("#incomeDedMon"		).val("");
			$("#hIncomeDedMon"		).val("");
			$("#ytaxBaseRate"		).val("");
			$("#hYtaxBaseRate"		).val("");
			$("#totTaxBaseMon"		).val("");
			$("#taxBaseMon"			).val("");
			$("#hTaxBaseMon"		).val("");
			$("#totYtaxBaseMon"		).val("");
			$("#ytaxBaseMon"		).val("");
			$("#hYtaxBaseMon"		).val("");
			$("#totYcalTaxMon"		).val("");
			$("#ycalTaxMon"			).val("");
			$("#hYcalTaxMon"		).val("");
			$("#totCalTaxMon"		).val("");
			$("#calTaxMon"			).val("");
			$("#hCalTaxMon"			).val("");
			$("#totInctaxDedMon"	).val("");
			$("#inctaxDedMon"		).val("");
			$("#hInctaxDedMon"		).val("");
			$("#totRItaxMon"		).val("");
			$("#totRRtaxMon"		).val("");
			$("#totRStaxMon"		).val("");
			$("#bItaxMon"			).val("");
			$("#bRtaxMon"			).val("");
			$("#bStaxMon"			).val("");
			$("#tItaxMon"			).val("");
			$("#tRtaxMon"			).val("");
			$("#tStaxMon"			).val("");

			if (basicInfo.Map != null) {
				basicInfo = basicInfo.Map;
				$("#sumTotEarningMon"	).val(basicInfo.sumTotEarningMon);
				$("#totEarningMon"		).val(basicInfo.totEarningMon	);
				$("#hTotEarningMon"		).val(basicInfo.hTotEarningMon	);
				$("#totIncomeDedMon"	).val(basicInfo.totIncomeDedMon	);
				$("#incomeDedMon"		).val(basicInfo.incomeDedMon	);
				$("#hIncomeDedMon"		).val(basicInfo.hIncomeDedMon	);
				$("#ytaxBaseRate"		).val(basicInfo.ytaxBaseRate	);
				$("#hYtaxBaseRate"		).val(basicInfo.hYtaxBaseRate	);
				$("#totTaxBaseMon"		).val(basicInfo.totTaxBaseMon	);
				$("#taxBaseMon"			).val(basicInfo.taxBaseMon		);
				$("#hTaxBaseMon"		).val(basicInfo.hTaxBaseMon		);
				$("#totYtaxBaseMon"		).val(basicInfo.totYtaxBaseMon	);
				$("#ytaxBaseMon"		).val(basicInfo.ytaxBaseMon		);
				$("#hYtaxBaseMon"		).val(basicInfo.hYtaxBaseMon	);
				$("#totYcalTaxMon"		).val(basicInfo.totYcalTaxMon	);
				$("#ycalTaxMon"			).val(basicInfo.ycalTaxMon		);
				$("#hYcalTaxMon"		).val(basicInfo.hYcalTaxMon		);
				$("#totCalTaxMon"		).val(basicInfo.totCalTaxMon	);
				$("#calTaxMon"			).val(basicInfo.calTaxMon		);
				$("#hCalTaxMon"			).val(basicInfo.hCalTaxMon		);
				$("#totInctaxDedMon"	).val(basicInfo.totInctaxDedMon	);
				$("#inctaxDedMon"		).val(basicInfo.inctaxDedMon	);
				$("#hInctaxDedMon"		).val(basicInfo.hInctaxDedMon	);
				$("#totRItaxMon"		).val(basicInfo.totRItaxMon		);
				$("#totRRtaxMon"		).val(basicInfo.totRRtaxMon		);
				$("#totRStaxMon"		).val(basicInfo.totRStaxMon		);
				$("#bItaxMon"			).val(basicInfo.bItaxMon		);
				$("#bRtaxMon"			).val(basicInfo.bRtaxMon		);
				$("#bStaxMon"			).val(basicInfo.bStaxMon		);
				$("#tItaxMon"			).val(basicInfo.tItaxMon		);
				$("#tRtaxMon"			).val(basicInfo.tRtaxMon		);
				$("#tStaxMon"			).val(basicInfo.tStaxMon		);
			} else if (basicInfo.Message != null && basicInfo.Message != "") {
				alert(basicInfo.Message);
			}
			break;
	}
}

function setEmpPage() {
	doAction1("Search");
}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
	<input type="hidden" id="sabun" name="sabun" value="" />
	<input type="hidden" id="payActionCd" name="payActionCd" value="" />
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<colgroup>
		<col width="45%" />
		<col width="2%" />
		<col width="53%" />
	</colgroup>
		<tr>
			<td class="top">
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
			<td></td>
			<td class="top">
				<table border="0" cellpadding="0" cellspacing="0" class="default">
				<colgroup>
					<col width="25%" />
					<col width="25%" />
					<col width="25%" />
					<col width="25%" />
				</colgroup>
				<tr>
					<th class="center"><b>정산명세</b></th>
					<th class="center">합계</th>
					<th class="center">법정</th>
					<th class="center">법정외</th>
				</tr>
				<tr>
					<th>총퇴직소득</th>
					<td class="center"> <input type="text" id="sumTotEarningMon" name="sumTotEarningMon" value="" readonly class="text right readonly" /> </td>
					<td class="center"> <input type="text" id="totEarningMon" name="totEarningMon" value="" readonly class="text right" /> </td>
					<td class="center"> <input type="text" id="hTotEarningMon" name="hTotEarningMon" value="" readonly class="text right" /> </td>
				</tr>
				<tr>
					<th>퇴직소득공제</th>
					<td class="center"> <input type="text" id="totIncomeDedMon" name="totIncomeDedMon" value="" readonly class="text right readonly" /> </td>
					<td class="center"> <input type="text" id="incomeDedMon" name="incomeDedMon" value="" readonly class="text right" /> </td>
					<td class="center"> <input type="text" id="hIncomeDedMon" name="hIncomeDedMon" value="" readonly class="text right" /> </td>
				</tr>
				<tr>
					<th>세율</th>
					<td class="center"> - </td>
					<td class="center"> <input type="text" id="ytaxBaseRate" name="ytaxBaseRate" value="" readonly class="text right" /> </td>
					<td class="center"> <input type="text" id="hYtaxBaseRate" name="hYtaxBaseRate" value="" readonly class="text right" /> </td>
				</tr>
				<tr>
					<th>과세표준</th>
					<td class="center"> <input type="text" id="totTaxBaseMon" name="totTaxBaseMon" value="" readonly class="text right readonly" /> </td>
					<td class="center"> <input type="text" id="taxBaseMon" name="taxBaseMon" value="" readonly class="text right" /> </td>
					<td class="center"> <input type="text" id="hTaxBaseMon" name="" value="" readonly class="text right" /> </td>
				</tr>
				<tr>
					<th>연평균과세표준</th>
					<td class="center"> <input type="text" id="totYtaxBaseMon" name="totYtaxBaseMon" value="" readonly class="text right readonly" /> </td>
					<td class="center"> <input type="text" id="ytaxBaseMon" name="ytaxBaseMon" value="" readonly class="text right" /> </td>
					<td class="center"> <input type="text" id="hYtaxBaseMon" name="hYtaxBaseMon" value="" readonly class="text right" /> </td>
				</tr>
				<tr>
					<th>연평균산출세액</th>
					<td class="center"> <input type="text" id="totYcalTaxMon" name="totYcalTaxMon" value="" readonly class="text right readonly" /> </td>
					<td class="center"> <input type="text" id="ycalTaxMon" name="ycalTaxMon" value="" readonly class="text right" /> </td>
					<td class="center"> <input type="text" id="hYcalTaxMon" name="hYcalTaxMon" value="" readonly class="text right" /> </td>
				</tr>
				<tr>
					<th>산출세액</th>
					<td class="center"> <input type="text" id="totCalTaxMon" name="totCalTaxMon" value="" readonly class="text right readonly" /> </td>
					<td class="center"> <input type="text" id="calTaxMon" name="calTaxMon" value="" readonly class="text right" /> </td>
					<td class="center"> <input type="text" id="hCalTaxMon" name="hCalTaxMon" value="" readonly class="text right" /> </td>
				</tr>
				<tr>
					<th>소득세액공제</th>
					<td class="center"> <input type="text" id="totInctaxDedMon" name="totInctaxDedMon" value="" readonly class="text right readonly" /> </td>
					<td class="center"> <input type="text" id="inctaxDedMon" name="inctaxDedMon" value="" readonly class="text right" /> </td>
					<td class="center"> <input type="text" id="hInctaxDedMon" name="hInctaxDedMon" value="" readonly class="text right" /> </td>
				</tr>
				<tr>
					<th class="center"><b>납부명세</b></th>
					<th class="center">소득세</th>
					<th class="center">지방소득세(주민세)</th>
					<th class="center">농특세</th>
				</tr>
				<tr>
					<th>결정세액</th>
					<td class="center"> <input type="text" id="totRItaxMon" name="totRItaxMon" value="" readonly class="text right" /> </td>
					<td class="center"> <input type="text" id="totRRtaxMon" name="" value="" readonly class="text right" /> </td>
					<td class="center"> <input type="text" id="totRStaxMon" name="" value="" readonly class="text right" /> </td>
				</tr>
				<tr>
					<th>종전 기납부세액</th>
					<td class="center"> <input type="text" id="bItaxMon" name="bItaxMon" value="" readonly class="text right" /> </td>
					<td class="center"> <input type="text" id="bRtaxMon" name="bRtaxMon" value="" readonly class="text right" /> </td>
					<td class="center"> <input type="text" id="bStaxMon" name="bStaxMon" value="" readonly class="text right" /> </td>
				</tr>
				<tr>
					<th>차감원천징수세액</th>
					<td class="center"> <input type="text" id="tItaxMon" name="tItaxMon" value="" readonly class="text right" /> </td>
					<td class="center"> <input type="text" id="tRtaxMon" name="tRtaxMon" value="" readonly class="text right" /> </td>
					<td class="center"> <input type="text" id="tStaxMon" name="tStaxMon" value="" readonly class="text right" /> </td>
				</tr>
				</table>
			</td>
		</tr>
	</table>
</div>
</body>
</html>