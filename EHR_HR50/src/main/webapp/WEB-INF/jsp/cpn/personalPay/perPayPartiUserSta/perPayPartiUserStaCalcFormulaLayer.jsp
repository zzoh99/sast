<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="btn" tagdir="/WEB-INF/tags/button" %>
<!DOCTYPE html>
<html class="bodywrap">
<head>
	<title>급여명세서(계산방법 포함)</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<!--
 * 급여명세서
 * @author JM
-->
<script type="text/javascript">

<%--var p = eval("${popUpStatus}");--%>
<%--var args = new Array();--%>
$(function() {

	const modal = window.top.document.LayerModalUtility.getModal('perPayPartiUserStaCalcFormulaLayer');
	<%--createIBSheet3(document.getElementById('appCodeMgrLayerSheet-wrap'), "appCodeMgrLayerSheet", "100%", "100%","${ssnLocaleCd}");--%>

	var arg = modal.parameters;

	var searchSabun = "";
	var searchPayActionCd = "";

    if( arg != undefined ) {
    	searchSabun 		= arg["sabun"];
    	searchPayActionCd 	= arg["payActionCd"];
    }else{
    	if(p.popDialogArgument("sabun")!=null)				searchSabun  		= p.popDialogArgument("sabun");
    	if(p.popDialogArgument("payActionCd")!=null)		searchPayActionCd  	= p.popDialogArgument("payActionCd");
    }


	$("#sabun").val(searchSabun);
	$("#payActionCd").val(searchPayActionCd);

	if ($("#sabun").val() != null && $("#payActionCd").val() != null &&
		$("#sabun").val() != "" && $("#payActionCd").val() != "") {
		doAction("Search");
	}
});

function doAction(sAction) {
	switch (sAction) {
		case "Search":
			// 급여명세서조회
 			var listViewInfo = ajaxCall( "${ctx}/yjungsan/y_workStdLaw/jsp_jungsan/perPayPartiPopStaFormula/perPayPartiPopStaFormulaRst.jsp?cmd=getPerPayPartiPopStaBasicMap", $("#sheet1Form").serialize(), false);
			console.log(listViewInfo)
			$("#name"			).html("");
			$("#sabun"			).html("");
			$("#orgNm"			).html("");
			$("#totEarningMon"	).html("");
			$("#totDedMon"		).html("");
			$("#taxBaseMon"		).html("");
			$("#bankNm"			).html("");
			$("#accountNo"		).html("");
			$("#resultMon"		).html("");
			$("#totCalcTax"		).html("");
			$("#previewTitle"	).html("");

			if (listViewInfo["Data"][0] != null) {
				// 급여명세서 기본정보
				$("#name"			).html(listViewInfo["Data"][0].name			);
				$("#sabunDisp"		).html(listViewInfo["Data"][0].sabun		);
				$("#orgNm"			).html(listViewInfo["Data"][0].org_nm		);
				$("#totEarningMon"	).html(listViewInfo["Data"][0].tot_earning_mon);
				$("#totDedMon"		).html(listViewInfo["Data"][0].tot_ded_mon	);
				$("#taxBaseMon"		).html(listViewInfo["Data"][0].tax_base_mon	);
				$("#bankNm"			).html(listViewInfo["Data"][0].bank_nm		);
				$("#accountNo"		).html(listViewInfo["Data"][0].account_no	);
				$("#resultMon"		).html(listViewInfo["Data"][0].result_mon	);
				$("#previewTitle"	).html(listViewInfo["Data"][0].pay_action_nm	);
			}
			
			var listEtcInfo = ajaxCall( "${ctx}/yjungsan/y_workStdLaw/jsp_jungsan/perPayPartiPopStaFormula/perPayPartiPopStaFormulaRst.jsp?cmd=getPerPayPartiPopStaEtc", $("#sheet1Form").serialize(), false);
			
			// 기타내역
			var insA = "";
			var cnt = 0;
			var aTdCnt = 0;
			if (listEtcInfo["Data"] != null && typeof listEtcInfo["Data"][0] != "undefined") {

				cnt = listEtcInfo["Data"].length;
				if (cnt >= 0) {

					cnt = Math.ceil(cnt / 5);

					for (var row = 0; row < cnt; row++) {
						insA = insA + "<tr>";

						// 타이틀부
						aTdCnt = 0;
						for (var tIdx = 5*row; aTdCnt < 5; tIdx++) {

							insA = insA	+ "<td class='gray3 center'>";
							if (listEtcInfo["Data"][tIdx] != null && typeof listEtcInfo["Data"][tIdx] != "undefined") {
								insA = insA + listEtcInfo["Data"][tIdx].element_nm;
							}
							insA = insA + "</td>";

							aTdCnt++;
						}

						insA = insA + "</tr><tr>";

						// 데이타부
						aTdCnt = 0;
						for (var dIdx = 5*row; aTdCnt < 5; dIdx++) {
							insA = insA	+ "<td class='gray4 center'>";
							if (listEtcInfo["Data"][dIdx] != null && typeof listEtcInfo["Data"][dIdx] != "undefined") {
								insA = insA + listEtcInfo["Data"][dIdx].ele_value_unit;
							}
							insA = insA + "</td>";

							aTdCnt++;
						}
						insA = insA + "</tr>";
					}
				}

			}

			$("#calcATable").append(insA);
			
			
        	$("#elementType").val("A");
			var listFormulaA = ajaxCall( "${ctx}/yjungsan/y_workStdLaw/jsp_jungsan/perPayPartiPopStaFormula/perPayPartiPopStaFormulaRst.jsp?cmd=getPerPayPartiPopStaFormila", $("#sheet1Form").serialize(), false);
			
			var insFormulaA = "";
			var cntTrFormulaA = 0;

			if (listFormulaA["Data"] != null && typeof listFormulaA["Data"][0] != "undefined") {

				cntTrFormulaA = listFormulaA["Data"].length;
				if (cntTrFormulaA >= 0) {

					for (var row = 0; row < cntTrFormulaA; row++) {

						insFormulaA = insFormulaA + "<tr>";
						insFormulaA = insFormulaA	+ "<td class='gray4'>";
						insFormulaA = insFormulaA + listFormulaA["Data"][row].element_nm;
						insFormulaA = insFormulaA + "</td class='dot'>";
						
						insFormulaA = insFormulaA	+ "<td class='gray4'>";
						insFormulaA = insFormulaA + listFormulaA["Data"][row].formula;
						insFormulaA = insFormulaA + "</td>";
						
						insFormulaA = insFormulaA	+ "<td class='gray4 right'>";
						insFormulaA = insFormulaA + listFormulaA["Data"][row].result_mon_for;
						insFormulaA = insFormulaA + "</td>";	
						insFormulaA = insFormulaA + "</tr>";
						
					}
				
					
				}
			}

			$("#formulaTableA").append(insFormulaA);	
			
	       	$("#elementType").val("D");
			var listFormulaB = ajaxCall( "${ctx}/yjungsan/y_workStdLaw/jsp_jungsan/perPayPartiPopStaFormula/perPayPartiPopStaFormulaRst.jsp?cmd=getPerPayPartiPopStaFormila", $("#sheet1Form").serialize(), false);
			
			var insFormulaB = "";
			var cntTrFormulaB = 0;

			if (listFormulaB["Data"] != null && typeof listFormulaB["Data"][0] != "undefined") {

				cntTrFormulaB = listFormulaB["Data"].length;
				if (cntTrFormulaB >= 0) {

					for (var row = 0; row < cntTrFormulaB; row++) {

						insFormulaB = insFormulaB + "<tr>";
						insFormulaB = insFormulaB	+ "<td class='gray4'>";
						insFormulaB = insFormulaB + listFormulaB["Data"][row].element_nm;
						insFormulaB = insFormulaB + "</td>";
						
						insFormulaB = insFormulaB	+ "<td class='gray4'>";
						insFormulaB = insFormulaB + listFormulaB["Data"][row].formula;
						insFormulaB = insFormulaB + "</td>";
						
						insFormulaB = insFormulaB	+ "<td class='gray4 right'>";
						insFormulaB = insFormulaB + listFormulaB["Data"][row].result_mon_for;
						insFormulaB = insFormulaB + "</td>";	
						insFormulaB = insFormulaB + "</tr>";
						
					}
				}
			}

			$("#formulaTableB").append(insFormulaB);					
			
			break;
        case "Search2":
        	$("#elementType").val("A");
            sheet1.DoSearch( "${ctx}/yjungsan/y_workStdLaw/jsp_jungsan/perPayPartiPopStaFormula/perPayPartiPopStaFormulaRst.jsp?cmd=getPerPayPartiPopStaFormila", $("#sheet1Form").serialize() );
            $("#elementType").val("D");
            sheet2.DoSearch( "${ctx}/yjungsan/y_workStdLaw/jsp_jungsan/perPayPartiPopStaFormula/perPayPartiPopStaFormulaRst.jsp?cmd=getPerPayPartiPopStaFormila", $("#sheet1Form").serialize() );
            break;			
	}
}

function printPage() {
  	window.print();
}

window.onbeforeprint = function() {
	document.getElementById('content').classList.remove('popup_scroll');
	document.getElementById('closeBtn').classList.add('no-print');
	document.getElementById('printBtn').classList.add('no-print');
};

window.onafterprint = function() {
	document.getElementById('content').classList.add('popup_scroll');
	document.getElementById('closeBtn').classList.remove('no-print');
	document.getElementById('printBtn').classList.remove('no-print');
};

</script>
<style type="text/css">
#previewTitle {background-color:#FFF!important; border:none;}
table.print_table td.gray4 {border:1px solid #dae1e6}
@page {
    size: auto;  /* auto is the initial value */
    margin: 0;  /* this affects the margin in the printer settings */
}
.no-print, .no-print * { display: none !important; }

</style>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<div class="modal_body">
		<form id="sheet1Form" name="sheet1Form" >
			<input type="hidden" id="sabun" name="sabun" class="text" value="" />
			<input type="hidden" id="payActionCd" name="payActionCd" value="" />
			<input type="hidden" id="elementType" name="elementType" value="" />
		</form>
		<div class="sheet_search outer">
			<div>
				<table border="0" cellpadding="0" cellspacing="0" class="sheet_main">
					<tr>
						<td class="top">
							<table border="0" cellpadding="0" cellspacing="0" class="print_title">
								<tr>
									<td>&nbsp;</td>
									<th id="previewTitle"></th>
									<td id="printBtn"><a href="javascript:printPage();"><img src="/common/images/icon/icon_print.png" /></a></td>
								</tr>
							</table>
							<table border="0" cellpadding="0" cellspacing="0" class="print_table">
								<colgroup>
									<col width="20%" />
									<col width="30%" />
								</colgroup>
								<tr>
									<td class="gray1">성명</td>
									<td id="name" class="gray2"></td>
									<td class="gray1">사번</td>
									<td id="sabunDisp" class="gray2"></td>
								</tr>
								<tr>
									<td class="gray1">소속</td>
									<td id="orgNm" colspan="3" class="gray2"></td>
								</tr>
							</table>

							<div class="h15"></div>

							<table border="0" cellpadding="0" cellspacing="0" class="print_table">
								<colgroup>
									<col width="20%" />
									<col width="30%" />
									<col width="20%" />
									<col width="30%" />
								</colgroup>
								<tr>
									<td class="gray1">지급총액(A)</td>
									<td id="totEarningMon" class="gray2 right"></td>
									<td class="gray1">공제총액(B)</td>
									<td id="totDedMon" class="gray2 right"></td>
								</tr>
								<tr class="hide">
									<td class="gray1 hide">과표총액</td>
									<td id="taxBaseMon" class="gray2 right hide"></td>
									<td class="gray1">계좌번호</td>
									<td id="accountNo" class="gray2"></td>
								</tr>
								<tr>
									<td class="gray1">지급은행</td>
									<td colspan="3" id="bankNm" class="gray2"></td>
								</tr>
								<tr>
									<td class="gray1">실수령액 (A-B)</td>
									<td colspan="3" id="resultMon" class="pink1 right"></td>
								</tr>
							</table>

							<div class="h15"></div>

							<table id="calcATable" border="0" cellpadding="0" cellspacing="0" class="print_table">
								<colgroup>
									<col width="20%" />
									<col width="20%" />
									<col width="20%" />
									<col width="20%" />
									<col width="20%" />
								</colgroup>
								<tr>
									<td colspan="5" class="gray1 center">기타내역</td>
								</tr>
							</table>
							<div class="h15"></div>

							<table id="formulaTableA" border="0" cellpadding="0" cellspacing="0" class="print_table">
								<colgroup>
									<col width="20%" />
									<col width="60%" />
									<col width="20%" />
								</colgroup>
								<tr>
									<td colspan="3" class="gray1 center">수당계산방법</td>
								</tr>
								<tr>
									<td class="gray2 center">수당항목</td>
									<td class="gray2 center">계산방법</td>
									<td class="gray2 center">금액</td>
								</tr>
							</table>
							<div class="h15"></div>

							<table id="formulaTableB" border="0" cellpadding="0" cellspacing="0" class="print_table">
								<colgroup>
									<col width="20%" />
									<col width="60%" />
									<col width="20%" />
								</colgroup>
								<tr>
									<td colspan="3" class="gray1 center">공제계산방법</td>
								</tr>
								<tr>
									<td class="gray2 center">공제항목</td>
									<td class="gray2 center">계산방법</td>
									<td class="gray2 center">금액</td>
								</tr>
							</table>
							<%--			<tr>--%>
							<%--				<td id="closeBtn" >--%>
							<%--					<div class="popup_button outer">--%>
							<%--						<ul>--%>
							<%--							<li>--%>
							<%--								<a href="javascript:p.self.close();" class="gray large">닫기</a>--%>
							<%--							</li>--%>
							<%--						</ul>--%>
							<%--					</div><br>--%>
							<%--				</td>--%>
							<%--			</tr>--%>
				</table>
			</div>
		</div>
	</div>
	<div class="modal_footer ">
		<btn:a href="javascript:closeCommonLayer('perPayPartiUserStaCalcFormulaLayer');" css="btn outline_gray" mid='110881' mdef="닫기"/>
	</div>
</div>
</body>
</html>
