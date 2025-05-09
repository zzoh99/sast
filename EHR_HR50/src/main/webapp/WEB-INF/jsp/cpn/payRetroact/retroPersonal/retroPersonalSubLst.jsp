<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='104379' mdef='급여내역'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 월별급여지급현황
 * @author JM
-->
<script type="text/javascript">
$(function() {
	$(window).smartresize(sheetResize);
	sheetInit();

	var tableHeight = $(window).height()-$("#outer1").height()-2;
	$("#payTableDiv").height(tableHeight-30);
	$("#deductTableDiv").height(tableHeight-30);

	if (parent != null && parent.$("#sabun").val() != null && parent.$("#payActionCd").val() != null &&
		parent.$("#sabun").val() != "" && parent.$("#payActionCd").val() != "") {
		doAction1("Search");
	}
});

function doAction1(sAction) {
	switch (sAction) {
		case "Search":
			if (parent.$("#sabun").val() != null && parent.$("#payActionCd").val() != null &&
				parent.$("#sabun").val() != "" && parent.$("#payActionCd").val() != "") {

				doAction1("Clear");

				$("#sabun"		).val(parent.$("#sabun").val());
				$("#payActionCd").val(parent.$("#payActionCd").val());

				var PerPayPartiUserStaInfo = ajaxCall("${ctx}/RetroPersonal.do?cmd=getRetroPersonalLst", $("#sheet1Form").serialize(), false);

				var payCnt = 0;
				var deductCnt = 0;
				var taxCnt = 0;
				var taxFreeCnt = 0;
				var payHtmlData = "";
				var deductHtmlData = "";

				if (PerPayPartiUserStaInfo.DATA != null && typeof PerPayPartiUserStaInfo.DATA[0] != "undefined") {
					cnt = PerPayPartiUserStaInfo.DATA.length;

					for (var row=0; row<cnt; row++) {
						if (typeof PerPayPartiUserStaInfo.DATA[row] != "undefined" && PerPayPartiUserStaInfo.DATA[row].gubun != null) {
							if (PerPayPartiUserStaInfo.DATA[row].gubun == "PAY") {
								// 지급항목
								payHtmlData = payHtmlData + "<tr>";
								payHtmlData = payHtmlData + "<td class='center'>";
								if (PerPayPartiUserStaInfo.DATA[row].reportNm != null && PerPayPartiUserStaInfo.DATA[row].reportNm != "") {
									payHtmlData = payHtmlData + PerPayPartiUserStaInfo.DATA[row].reportNm;
								}
								payHtmlData = payHtmlData + "</td>";
								payHtmlData = payHtmlData + "<td class='right'>";
								if (PerPayPartiUserStaInfo.DATA[row].resultMon != null && PerPayPartiUserStaInfo.DATA[row].resultMon != "") {
									payHtmlData = payHtmlData + PerPayPartiUserStaInfo.DATA[row].resultMon;
								}
								payHtmlData = payHtmlData + "</td>";
								payHtmlData = payHtmlData + "</tr>";

							} else if (PerPayPartiUserStaInfo.DATA[row].gubun == "PAY_TOT") {
								if (PerPayPartiUserStaInfo.DATA[row].resultMon != null && PerPayPartiUserStaInfo.DATA[row].resultMon != "") {
									$("#tdPayTot").html(PerPayPartiUserStaInfo.DATA[row].resultMon);
								}

							} else if (PerPayPartiUserStaInfo.DATA[row].gubun == "DEDUCT") {
								// 공제내역
								deductHtmlData = deductHtmlData + "<tr>";
								deductHtmlData = deductHtmlData + "<td class='center'>";
								if (PerPayPartiUserStaInfo.DATA[row].reportNm != null && PerPayPartiUserStaInfo.DATA[row].reportNm != "") {
									deductHtmlData = deductHtmlData + PerPayPartiUserStaInfo.DATA[row].reportNm;
								}
								deductHtmlData = deductHtmlData + "</td>";
								deductHtmlData = deductHtmlData + "<td class='right'>";
								if (PerPayPartiUserStaInfo.DATA[row].resultMon != null && PerPayPartiUserStaInfo.DATA[row].resultMon != "") {
									deductHtmlData = deductHtmlData + PerPayPartiUserStaInfo.DATA[row].resultMon;
								}
								deductHtmlData = deductHtmlData + "</td>";
								deductHtmlData = deductHtmlData + "</tr>";

							} else if (PerPayPartiUserStaInfo.DATA[row].gubun == "DEDUCT_TOT") {
								if (PerPayPartiUserStaInfo.DATA[row].resultMon != null && PerPayPartiUserStaInfo.DATA[row].resultMon != "") {
									$("#tdDeductTot").html(PerPayPartiUserStaInfo.DATA[row].resultMon);
								}

							}
						}
					}
				}

				// 지급항목
				if (payHtmlData == "") payHtmlData = "<tr><td colspan='2' class='center'><tit:txt mid='104490' mdef='조회된 데이터가 없습니다.'/></td></tr>";
				// 공제내역
				if (deductHtmlData == "") deductHtmlData = "<tr><td colspan='2' class='center'><tit:txt mid='104490' mdef='조회된 데이터가 없습니다.'/></td></tr>";

				// 지급항목
				$("#payTable").append(payHtmlData);
				// 공제내역
				$("#deductTable").append(deductHtmlData);

				if (PerPayPartiUserStaInfo.Message != null && PerPayPartiUserStaInfo.Message != "") {
					// 조회실패
					alert(PerPayPartiUserStaInfo.Message);
				}

				// 세금내역조회
				var taxInfo = ajaxCall("${ctx}/RetroPersonal.do?cmd=getRetroPersonalMap", $("#sheet1Form").serialize(), false);

				if (taxInfo.Map != null) {
					taxInfo = taxInfo.Map;
					$("#totEarningMon"	).html(taxInfo.totEarningMon	);
					$("#exTotMon"		).html(taxInfo.exTotMon		);
					$("#notaxTotMon"	).html(taxInfo.notaxTotMon		);
					$("#totDedMon"	).html(taxInfo.totDedMon	);
					$("#bonBaseMon"		).html(taxInfo.bonBaseMon		);
					$("#bonBaseRate"	).html(taxInfo.bonBaseRate		);
					$("#bonRate"		).html(taxInfo.bonRate			);
					$("#paymentMon"		).html(taxInfo.paymentMon			);
				}
			}
			break;

		case "Clear":
			$("#sabun"		).val("");
			$("#payActionCd").val("");

			$("#payTable"	).html("");
			$("#tdPayTot"	).html("");
			$("#deductTable").html("");
			$("#tdDeductTot").html("");

			// 세금내역 clear
			$("#totEarningMon"	).html("");
			$("#exTotMon"		).html("");
			$("#notaxTotMon"	).html("");
			$("#totDedMon"	).html("");
			$("#bonBaseMon"		).html("");
			$("#bonBaseRate"	).html("");
			$("#bonRate"		).html("");
			$("#paymentMon"		).html("");
			break;
	}
}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
		<input type="hidden" id="sabun" name="sabun" class="text" value="" />
		<input type="hidden" id="payActionCd" name="payActionCd" value="" />
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<colgroup>
			<col width="" />
			<col width="" />
			<!--  <col width="" /> -->
			<col width="300" />
		</colgroup>
		<tr>
			<!--  <td colspan="3"> -->
			<td colspan="2">
				<div id="outer1" class="sheet_title outer">
				<ul>
					<li class="txt"><tit:txt mid='104097' mdef='계산내역'/></li>
				</ul>
				</div>
			</td>
			<td>
				<div class="sheet_title">
				<ul>
					<li class="txt">세금내역</li>
				</ul>
				</div>
			</td>
		</tr>
		<tr>
			<td class="sheet_left" rowspan="2">
				<div id="payTableDiv" style="overflow:auto;border:1px solid #dae1e6;">
				<table border="0" cellpadding="0" cellspacing="0" class="default outer" style="margin-bottom:0px">
					<colgroup>
						<col width="50%" />
						<col width="50%" />
					</colgroup>
					<tr>
						<th class="center" colspan="2"><tit:txt mid='perPayMasterMgrException1' mdef='지급'/></th>
					</tr>
					<tr>
						<th class="center"><tit:txt mid='103792' mdef='항목'/></th>
						<th class="center"><tit:txt mid='103793' mdef='금액'/></th>
					</tr>
						<tbody id="payTable">
						</tbody>
				</table>
				</div>
				<table border="0" cellpadding="0" cellspacing="0" class="default outer" style="margin-bottom:0px">
					<tr style="height:26px;">
						<td id="tdPayTot" class="right" style="background:#FAD5E6"> </td>
					</tr>
				</table>
			</td>
			<td class="sheet_right" rowspan="2">
				<div id="deductTableDiv" style="overflow:auto;border:1px solid #dae1e6;">
				<table border="0" cellpadding="0" cellspacing="0" class="default" style="margin-bottom:0px">
					<colgroup>
						<col width="50%" />
						<col width="50%" />
					</colgroup>
					<tr>
						<th class="center" colspan="2"><tit:txt mid='perPayMasterMgrException2' mdef='공제'/></th>
					</tr>
					<tr>
						<th class="center"><tit:txt mid='103792' mdef='항목'/></th>
						<th class="center"><tit:txt mid='103793' mdef='금액'/></th>
					</tr>
					<tbody id="deductTable">
					</tbody>
				</table>
				</div>
				<table border="0" cellpadding="0" cellspacing="0" class="default outer" style="margin-bottom:0px">
					<tr style="height:26px;">
						<td id="tdDeductTot" class="right" style="background:#FAD5E6"> </td>
					</tr>
				</table>
			</td>
			<td class="sheet_right" rowspan="2">
				<table border="0" cellpadding="0" cellspacing="0" class="default">
					<colgroup>
						<col width="50%" />
						<col width="50%" />
					</colgroup>
					<tr>
						<th><tit:txt mid='103989' mdef='급여총액'/></th>
						<td id="totEarningMon" class="right"></td>
					</tr>
					<tr>
						<th><tit:txt mid='104194' mdef='총액미포함액'/></th>
						<td id="exTotMon" class="right"></td>
					</tr>
					<tr>
						<th><tit:txt mid='104489' mdef='비과세총액'/></th>
						<td id="notaxTotMon" class="right"></td>
					</tr>
					<tr>
						<th><tit:txt mid='104373' mdef='공제총액'/></th>
						<td id="totDedMon" class="right"></td>
					</tr>
					<tr>
						<th><tit:txt mid='103990' mdef='상여기초액'/></th>
						<td id="bonBaseMon" class="right"></td>
					</tr>
					<tr>
						<th><tit:txt mid='104096' mdef='년상여총지급율'/></th>
						<td id="bonBaseRate" class="right"></td>
					</tr>
					<tr>
						<th><tit:txt mid='103892' mdef='월상여지급율'/></th>
						<td id="bonRate" class="right"></td>
					</tr>
					<tr>
						<th><tit:txt mid='104374' mdef='실지급액'/></th>
						<td id="paymentMon" class="right"></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
