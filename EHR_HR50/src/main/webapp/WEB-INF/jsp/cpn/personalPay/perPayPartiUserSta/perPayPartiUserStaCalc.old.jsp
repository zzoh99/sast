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
	$("#payTableDiv").height(tableHeight-50);
	$("#deductTableDiv").height(tableHeight-50);
	$("#basicTableDiv").height(tableHeight-50);
	$("#taxTableDiv").height(tableHeight/2-3-50);
	$("#taxFreeTableDiv").height(tableHeight/2-3-50);

	if (parent != null && parent.$("#sabun").val() != null && parent.$("#payActionCd").val() != null &&
		parent.$("#sabun").val() != "" && parent.$("#payActionCd").val() != "") {
		doAction1("Search");
	}
	
/***********************근로기준법 개정 패치시 참고*********************/
	// 계산방법보기 팝업버튼 활성 조회
	previewFormulaYn();
});

function doAction1(sAction) {
	switch (sAction) {
		case "Search":
			if (parent.$("#sabun").val() != null && parent.$("#payActionCd").val() != null &&
				parent.$("#sabun").val() != "" && parent.$("#payActionCd").val() != "") {

				doAction1("Clear");

				$("#sabun"		).val(parent.$("#sabun").val());
				$("#payActionCd").val(parent.$("#payActionCd").val());

				// 지급항목/공제내역/급여기초/과표내역/비과세내역 조회
				var PerPayPartiUserStaInfo = ajaxCall("${ctx}/PerPayPartiUserSta.do?cmd=getPerPayPartiUserStaList", $("#sheet1Form").serialize(), false);

				var payCnt 			= 0;
				var deductCnt 		= 0;
				var basicCnt		= 0;
				var taxCnt 			= 0;
				var taxFreeCnt 		= 0;
				var payHtmlData 	= "";
				var deductHtmlData	= "";
				var basicHtmlData	= "";
				var taxHtmlData 	= "";
				var taxFreeHtmlData = "";

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
							} else if (PerPayPartiUserStaInfo.DATA[row].gubun == "BASIC") {
								// 급여기초
								basicHtmlData = basicHtmlData + "<tr>";
								basicHtmlData = basicHtmlData + "<td class='center'>";
								if (PerPayPartiUserStaInfo.DATA[row].reportNm != null && PerPayPartiUserStaInfo.DATA[row].reportNm != "") {
									basicHtmlData = basicHtmlData + PerPayPartiUserStaInfo.DATA[row].reportNm;
								}
								basicHtmlData = basicHtmlData + "</td>";
								basicHtmlData = basicHtmlData + "<td class='right'>";
								if (PerPayPartiUserStaInfo.DATA[row].resultMon != null && PerPayPartiUserStaInfo.DATA[row].resultMon != "") {
									basicHtmlData = basicHtmlData + PerPayPartiUserStaInfo.DATA[row].resultMon;
								}
								basicHtmlData = basicHtmlData + "</td>";
								basicHtmlData = basicHtmlData + "</tr>";

							} else if (PerPayPartiUserStaInfo.DATA[row].gubun == "BASIC_TOT") {
								if (PerPayPartiUserStaInfo.DATA[row].resultMon != null && PerPayPartiUserStaInfo.DATA[row].resultMon != "") {
									console.log(PerPayPartiUserStaInfo.DATA[row].resultMon);
									$("#tdBasicTot").html(PerPayPartiUserStaInfo.DATA[row].resultMon);
								}
							} else if (PerPayPartiUserStaInfo.DATA[row].gubun == "TAX") {
								// 과표내역
								taxHtmlData = taxHtmlData + "<tr>";
								taxHtmlData = taxHtmlData + "<td class='center'>";
								if (PerPayPartiUserStaInfo.DATA[row].reportNm != null && PerPayPartiUserStaInfo.DATA[row].reportNm != "") {
									taxHtmlData = taxHtmlData + PerPayPartiUserStaInfo.DATA[row].reportNm;
								}
								taxHtmlData = taxHtmlData + "</td>";
								taxHtmlData = taxHtmlData + "<td class='right'>";
								if (PerPayPartiUserStaInfo.DATA[row].resultMon != null && PerPayPartiUserStaInfo.DATA[row].resultMon != "") {
									taxHtmlData = taxHtmlData + PerPayPartiUserStaInfo.DATA[row].resultMon;
								}
								taxHtmlData = taxHtmlData + "</td>";
								taxHtmlData = taxHtmlData + "</tr>";

							} else if (PerPayPartiUserStaInfo.DATA[row].gubun == "TAX_TOT") {
								if (PerPayPartiUserStaInfo.DATA[row].resultMon != null && PerPayPartiUserStaInfo.DATA[row].resultMon != "") {
									$("#tdTaxTot").html(PerPayPartiUserStaInfo.DATA[row].resultMon);
								}

							} else if (PerPayPartiUserStaInfo.DATA[row].gubun == "TAX_FREE") {
								// 비과세내역
								taxFreeHtmlData = taxFreeHtmlData + "<tr>";
								taxFreeHtmlData = taxFreeHtmlData + "<td class='center'>";
								if (PerPayPartiUserStaInfo.DATA[row].reportNm != null && PerPayPartiUserStaInfo.DATA[row].reportNm != "") {
									taxFreeHtmlData = taxFreeHtmlData + PerPayPartiUserStaInfo.DATA[row].reportNm;
								}
								taxFreeHtmlData = taxFreeHtmlData + "</td>";
								taxFreeHtmlData = taxFreeHtmlData + "<td class='right'>";
								if (PerPayPartiUserStaInfo.DATA[row].resultMon != null && PerPayPartiUserStaInfo.DATA[row].resultMon != "") {
									taxFreeHtmlData = taxFreeHtmlData + PerPayPartiUserStaInfo.DATA[row].resultMon;
								}
								taxFreeHtmlData = taxFreeHtmlData + "</td>";
								taxFreeHtmlData = taxFreeHtmlData + "</tr>";

							} else if (PerPayPartiUserStaInfo.DATA[row].gubun == "TAX_FREE_TOT") {
								if (PerPayPartiUserStaInfo.DATA[row].resultMon != null && PerPayPartiUserStaInfo.DATA[row].resultMon != "") {
									$("#tdTaxFreeTot").html(PerPayPartiUserStaInfo.DATA[row].resultMon);
								}
							}
						}
					}
				}

				// 지급항목
				if (payHtmlData == "") 		payHtmlData 	= "<tr><td colspan='2' class='center'><tit:txt mid='104490' mdef='조회된 데이터가 없습니다.'/></td></tr>";
				// 공제내역
				if (deductHtmlData == "")	deductHtmlData	= "<tr><td colspan='2' class='center'><tit:txt mid='104490' mdef='조회된 데이터가 없습니다.'/></td></tr>";
				// 급여기초
				if (basicHtmlData == "")	basicHtmlData 	= "<tr><td colspan='2' class='center'><tit:txt mid='104490' mdef='조회된 데이터가 없습니다.'/></td></tr>";
				// 과표내역
				if (taxHtmlData == "") 		taxHtmlData 	= "<tr><td colspan='2' class='center'><tit:txt mid='104490' mdef='조회된 데이터가 없습니다.'/></td></tr>";
				// 비과세내역
				if (taxFreeHtmlData == "") 	taxFreeHtmlData = "<tr><td colspan='2' class='center'><tit:txt mid='104490' mdef='조회된 데이터가 없습니다.'/></td></tr>";

				// 지급항목
				$("#payTable").append(payHtmlData);
				// 공제내역
				$("#deductTable").append(deductHtmlData);
				// 급여기초
				$("#basicTable").append(basicHtmlData);
				// 과표내역
				$("#taxTable").append(taxHtmlData);
				// 비과세내역
				$("#taxFreeTable").append(taxFreeHtmlData);

				if (PerPayPartiUserStaInfo.Message != null && PerPayPartiUserStaInfo.Message != "") {
					// 조회실패
					alert(PerPayPartiUserStaInfo.Message);
				}

				// 세금내역조회
				var taxInfo = ajaxCall("${ctx}/PerPayPartiUserSta.do?cmd=getPerPayPartiUserStaTaxMap", $("#sheet1Form").serialize(), false);

				if (taxInfo.Map != null) {
					taxInfo = taxInfo.Map;
					$("#totEarningMon"	).html(taxInfo.totEarningMon	);
					$("#taxBaseMon"		).html(taxInfo.taxBaseMon		);
					$("#notaxTotMon"	).html(taxInfo.notaxTotMon		);
					$("#taxibleEarnMon"	).html(taxInfo.taxibleEarnMon	);
					$("#familyCnt"		).html(taxInfo.familyCnt		);
					$("#addChildCnt"	).html(taxInfo.addChildCnt		);
					$("#itaxMon"		).html(taxInfo.itaxMon			);
					$("#rtaxMon"		).html(taxInfo.rtaxMon			);
					$("#paymentMon"		).html(taxInfo.paymentMon		);
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
			$("#basicTable" ).html("");
			$("#tdBasicTot" ).html("");
			$("#taxTable"	).html("");
			$("#tdTaxTot"	).html("");
			$("#taxFreeTable").html("");
			$("#tdTaxFreeTot").html("");

			// 세금내역 clear
			$("#totEarningMon"	).html("");
			$("#taxBaseMon"		).html("");
			$("#notaxTotMon"	).html("");
			$("#taxibleEarnMon"	).html("");
			$("#familyCnt"		).html("");
			$("#addChildCnt"	).html("");
			$("#itaxMon"		).html("");
			$("#rtaxMon"		).html("");
			$("#paymentMon"		).html("");
			break;
	}
}

/***********************근로기준법 개정 패치시 참고*********************/
//급여명세서(계산방법) 팝업 활성화여부 체크
function previewFormulaYn() {
    try{
        var formulaYn = ajaxCall("${ctx}/yjungsan/y_workStdLaw/jsp_jungsan/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=CPN_FORMULA_BTN_YN", "queryId=getSystemStdData",false).codeList;
        
    	if(formulaYn[0].code_nm == "Y") {
    		$("#previewFormulaPop").show();
    	}else{
    		$("#previewFormulaPop").hide();
    	}
    } catch(ex) {
    	alert("Button Show Event Error : " + ex);
    }	

}

/***********************근로기준법 개정 패치시 참고*********************/
//급여명세서(계산방법}) 팝업
function previewFormulaPopup() {
    try{
    	if(!isPopup()) {return;}
		
	    var args    = new Array();

		args["sabun"]		= $("#sabun").val();
		args["payActionCd"] = $("#payActionCd").val();
	    
	    var rv = openPopup("${ctx}/yjungsan/y_workStdLaw/jsp_jungsan/perPayPartiPopStaFormula/perPayPartiPopStaFormula.jsp?authPg=R", args,  "800","880");

    } catch(ex) {
    	alert("Open Popup Event Error : " + ex);
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
			<td colspan="3">
				<div id="outer1" class="sheet_title outer">
				<ul>
					<li class="txt"><tit:txt mid='perPayPartiAdminStaCalc1' mdef='급여지급내역'/>
					<btn:a href="javascript:previewFormulaPopup()"  id= "previewFormulaPop" css="basic authR" mid='previewFormulaPopup' mdef="계산방법보기" style="display:none;"/></li>
				</ul>
				</div>
			</td>
			<td>
				<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='perPayPartiAdminStaCalc2' mdef='세금내역'/></li>
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
				<div id="basicTableDiv" style="overflow:auto;border:1px solid #dae1e6;">
				<table border="0" cellpadding="0" cellspacing="0" class="default" style="margin-bottom:0px">
					<colgroup>
						<col width="50%" />
						<col width="50%" />
					</colgroup>
					<tr>
						<th class="center" colspan="2"><tit:txt mid='perPayMasterMgrException3' mdef='급여기초'/></th>
					</tr>
					<tr>
						<th class="center"><tit:txt mid='103792' mdef='항목'/></th>
						<th class="center"><tit:txt mid='103793' mdef='금액'/></th>
					</tr>
					<tbody id="basicTable">
					</tbody>
				</table>
				</div>
				<table border="0" cellpadding="0" cellspacing="0" class="default outer" style="margin-bottom:0px">
					<tr style="height:26px;">
						<td id="tdBasicTot" class="right" style="background:#FAD5E6"> </td>
					</tr>
				</table>
			</td>
			<td class="sheet_right hide">
				<div id="taxTableDiv" style="overflow:auto;border:1px solid #dae1e6;">
				<table border="0" cellpadding="0" cellspacing="0" class="default" style="margin-bottom:0px">
					<colgroup>
						<col width="50%" />
						<col width="50%" />
					</colgroup>
					<tr>
						<th class="center" colspan="2"><tit:txt mid='103998' mdef='과표'/></th>
					</tr>
					<tr>
						<th class="center"><tit:txt mid='103792' mdef='항목'/></th>
						<th class="center"><tit:txt mid='103793' mdef='금액'/></th>
					</tr>
					<tbody id="taxTable">
					</tbody>
				</table>
				</div>
				<table border="0" cellpadding="0" cellspacing="0" class="default outer" style="margin-bottom:5px">
					<tr style="height:26px;">
						<td id="tdTaxTot" class="right" style="background:#FAD5E6"> </td>
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
						<th><tit:txt mid='103984' mdef='지급총액'/></th>
						<td id="totEarningMon" class="right"></td>
					</tr>
					<tr>
						<th><tit:txt mid='104385' mdef='과세총액'/></th>
						<td id="taxBaseMon" class="right"></td>
					</tr>
					<tr>
						<th><tit:txt mid='104489' mdef='비과세총액'/></th>
						<td id="notaxTotMon" class="right"></td>
					</tr>
					<tr>
						<th><tit:txt mid='104382' mdef='과세대상금액'/></th>
						<td id="taxibleEarnMon" class="right"></td>
					</tr>
					<tr>
						<th><tit:txt mid='104197' mdef='부양가족수'/></th>
						<td id="familyCnt" class="right"></td>
					</tr>
					<tr>
						<th><tit:txt mid='104493' mdef='다자녀수'/></th>
						<td id="addChildCnt" class="right"></td>
					</tr>
					<tr>
						<th><tit:txt mid='103981' mdef='소득세'/></th>
						<td id="itaxMon" class="right"></td>
					</tr>
					<tr>
						<th><tit:txt mid='103983' mdef='주민세'/></th>
						<td id="rtaxMon" class="right"></td>
					</tr>
					<tr>
						<th><tit:txt mid='104374' mdef='실지급액'/></th>
						<td id="paymentMon" class="right"></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td class="sheet_right hide">
				<div id="taxFreeTableDiv" style="overflow:auto;border:1px solid #dae1e6;margin-bottom:0px">
				<table border="0" cellpadding="0" cellspacing="0" class="default" style="margin-bottom:0px">
					<colgroup>
						<col width="50%" />
						<col width="50%" />
					</colgroup>
					<tr>
						<th class="center" colspan="2"><tit:txt mid='104383' mdef='비과세'/></th>
					</tr>
					<tr>
						<th class="center"><tit:txt mid='103792' mdef='항목'/></th>
						<th class="center"><tit:txt mid='103793' mdef='금액'/></th>
					</tr>
					<tbody id="taxFreeTable">
					</tbody>
				</table>
				</div>
				<table border="0" cellpadding="0" cellspacing="0" class="default outer" style="margin-bottom:0px">
					<tr style="height:26px;">
						<td id="tdTaxFreeTot" class="right" style="background:#FAD5E6"></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
