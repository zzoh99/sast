<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html> <head> <title><tit:txt mid='perPayPartiPopSta' mdef='급여명세서'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<link rel="stylesheet" type="text/css" href="/common/css/contents.css">

<!--
 * 급여명세서
 * @author JM
-->
<script type="text/javascript">
var args = new Array();
var p = eval("${popUpStatus}");
$(function() {
	var arg = p.window.dialogArguments;

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

	$(window).smartresize(sheetResize);
	sheetInit();

	if ($("#sabun").val() != null && $("#payActionCd").val() != null &&
		$("#sabun").val() != "" && $("#payActionCd").val() != "") {
		doAction("Search");
	}
});

function doAction(sAction) {
	switch (sAction) {
		case "Search":
			// 급여명세서조회
			var previewInfo = ajaxCall("${ctx}/PerPayPartiUserSta.do?cmd=getPerPayPartiPopSta", $("#sheet1Form").serialize(), false);

			$("#name"			).html("");
			$("#sabun"			).html("");
			$("#orgNm"			).html("");
			$("#totEarningMon"	).html("");
			$("#totDedMon"		).html("");
			$("#taxBaseMon"		).html("");
			$("#bankNm"			).html("");
			$("#accountNo"		).html("");
			$("#resultMon"		).html("");
			$("#totCalcA"		).html("");
			$("#totCalcA"		).html("");
			$("#totCalcTax"		).html("");
			$("#previewTitle"	).html("");

			if (previewInfo.Map != null) {
				// 급여명세서 기본정보
				$("#name"			).html(previewInfo.Map.name			);
				$("#sabunDisp"		).html(previewInfo.Map.sabun		);
				$("#orgNm"			).html(previewInfo.Map.orgNm		);
				$("#totEarningMon"	).html(previewInfo.Map.totEarningMon);
				$("#totDedMon"		).html(previewInfo.Map.totDedMon	);
				$("#taxBaseMon"		).html(previewInfo.Map.taxBaseMon	);
				$("#bankNm"			).html(previewInfo.Map.bankNm		);
				$("#accountNo"		).html(previewInfo.Map.accountNo	);
				$("#resultMon"		).html(previewInfo.Map.resultMon	);
				$("#bigo"			).html(previewInfo.Map.bigo			);
				$("#previewTitle"	).html(previewInfo.Map.payActionNm	);
			}

			// 급여명세서 지급내역
			var insA = "";
			var cnt = 0;
			var aTdCnt = 0;
			if (previewInfo.DATA1 != null && typeof previewInfo.DATA1[0] != "undefined") {

				cnt = previewInfo.DATA1.length-1;
				if (cnt > 0) {

					cnt = Math.ceil(cnt / 5);
					for (var row = 0; row < cnt; row++) {
						insA = insA + "<tr>";

						// 타이틀부
						aTdCnt = 0;
						for (var tIdx = 5*row+1; aTdCnt < 5; tIdx++) {

							insA = insA	+ "<td class='gray3 center'>";
							if (previewInfo.DATA1[tIdx] != null && typeof previewInfo.DATA1[tIdx] != "undefined") {
								insA = insA + previewInfo.DATA1[tIdx].reportNm;
							}
							insA = insA + "</td>";

							aTdCnt++;
						}

						insA = insA + "</tr><tr>";

						// 데이타부
						aTdCnt = 0;
						for (var dIdx = 5*row+1; aTdCnt < 5; dIdx++) {
							insA = insA	+ "<td class='dot right'>";
							if (previewInfo.DATA1[dIdx] != null && typeof previewInfo.DATA1[dIdx] != "undefined") {
								insA = insA + previewInfo.DATA1[dIdx].resultMon;
							}
							insA = insA + "</td>";

							aTdCnt++;
						}
						insA = insA + "</tr>";
					}

					if (previewInfo.DATA1[0].resultMon != null) {
						// 지급총액
						$("#totCalcA").html(previewInfo.DATA1[0].resultMon);
					}
				}

			}

			$("#calcATable").append(insA);


			// 급여명세서 공제내역
			var insD = "";
			var cnt = 0;
			var dTdCnt = 0;
			if (previewInfo.DATA2 != null && typeof previewInfo.DATA2[0] != "undefined") {

				cnt = previewInfo.DATA2.length-1;
				if (cnt > 0) {

					cnt = Math.ceil(cnt / 5);
					for (var row = 0; row < cnt; row++) {
						insD = insD + "<tr>";

						// 타이틀부
						aTdCnt = 0;
						for (var tIdx = 5*row+1; aTdCnt < 5; tIdx++) {

							insD = insD	+ "<td class='gray3 center'>";
							if (previewInfo.DATA2[tIdx] != null && typeof previewInfo.DATA2[tIdx] != "undefined") {
								insD = insD + previewInfo.DATA2[tIdx].reportNm;
							}
							insD = insD + "</td>";

							aTdCnt++;
						}

						insD = insD + "</tr><tr>";

						// 데이타부
						aTdCnt = 0;
						for (var dIdx = 5*row+1; aTdCnt < 5; dIdx++) {
							insD = insD	+ "<td class='dot right'>";
							if (previewInfo.DATA2[dIdx] != null && typeof previewInfo.DATA2[dIdx] != "undefined") {
								insD = insD + previewInfo.DATA2[dIdx].resultMon;
							}
							insD = insD + "</td>";

							aTdCnt++;
						}
						insD = insD + "</tr>";
					}

					if (previewInfo.DATA2[0].resultMon != null) {
						// 공제총액
						$("#totCalcD").html(previewInfo.DATA2[0].resultMon);
					}
				}

			}

			$("#calcDTable").append(insD);


			// 급여명세서 과표내역
			var insTax = "";
			var cnt = 0;
			var taxTdCnt = 0;
			if (previewInfo.DATA3 != null && typeof previewInfo.DATA3[0] != "undefined") {

				cnt = previewInfo.DATA3.length-1;
				if (cnt > 0) {

					cnt = Math.ceil(cnt / 5);
					for (var row = 0; row < cnt; row++) {
						insTax = insTax + "<tr>";

						// 타이틀부
						aTdCnt = 0;
						for (var tIdx = 5*row+1; aTdCnt < 5; tIdx++) {

							insTax = insTax	+ "<td class='gray3 center'>";
							if (previewInfo.DATA3[tIdx] != null && typeof previewInfo.DATA3[tIdx] != "undefined") {
								insTax = insTax + previewInfo.DATA3[tIdx].reportNm;
							}
							insTax = insTax + "</td>";

							aTdCnt++;
						}

						insTax = insTax + "</tr><tr>";

						// 데이타부
						aTdCnt = 0;
						for (var dIdx = 5*row+1; aTdCnt < 5; dIdx++) {
							insTax = insTax	+ "<td class='dot right'>";
							if (previewInfo.DATA3[dIdx] != null && typeof previewInfo.DATA3[dIdx] != "undefined") {
								insTax = insTax + previewInfo.DATA3[dIdx].resultMon;
							}
							insTax = insTax + "</td>";

							aTdCnt++;
						}
						insTax = insTax + "</tr>";
					}

					if (previewInfo.DATA3[0].resultMon != null) {
						// 과표총액
						$("#totCalcTax").html(previewInfo.DATA3[0].resultMon);
					}
				}

			}

			$("#calcTaxTable").append(insTax);
			break;
	}
}

function printPage() {
	window.print();
}
</script>
<style type="text/css">
#previewTitle {background-color:#FFF!important; border:none;}
</style>
</head>
<body>
<div class="wrap_print popup_scroll">
<form id="sheet1Form" name="sheet1Form" >
	<input type="hidden" id="sabun" name="sabun" class="text" value="" />
	<input type="hidden" id="payActionCd" name="payActionCd" value="" />
</form>
<table border="0" cellpadding="0" cellspacing="0" class="main">
	<tr>
		<td class="top">
		<table border="0" cellpadding="0" cellspacing="0" class="print_title">
		<tr>
			<td>&nbsp;</td>
			<th id="previewTitle"></th>
			<td><a href="javascript:printPage();"><img src="/common/images/icon/icon_print.png" /></a></td>
		</tr>
		</table>
		<table border="0" cellpadding="0" cellspacing="0" class="print_table">
		<colgroup>
			<col width="20%" />
			<col width="30%" />
			<col width="20%" />
			<col width="30%" />
		</colgroup>
		<tr>
			<td class="gray1"><tit:txt mid='103880' mdef='성명'/></td>
			<td id="name" class="gray2"></td>
			<td class="gray1"><tit:txt mid='103975' mdef='사번'/></td>
			<td id="sabunDisp" class="gray2"></td>
		</tr>
		<tr>
			<td class="gray1"><tit:txt mid='104279' mdef='소속'/></td>
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
			<td class="gray1"><tit:txt mid='103854' mdef='지급총액(A)'/></td>
			<td id="totEarningMon" class="gray2 right"></td>
			<td class="gray1"><tit:txt mid='103954' mdef='공제총액(B)'/></td>
			<td id="totDedMon" class="gray2 right"></td>
		</tr>
		<tr class="hide">
			<td class="gray1 hide"><tit:txt mid='104440' mdef='과표총액'/></td>
			<td id="taxBaseMon" class="gray2 right hide"></td>
			<td class="gray1"><tit:txt mid='104465' mdef='계좌번호'/></td>
			<td id="accountNo" class="gray2"></td>
		</tr>
		<tr>
			<td class="gray1"><tit:txt mid='104339' mdef='지급은행'/></td>
			<td colspan="3" id="bankNm" class="gray2"></td>
		</tr>
		<tr>
			<td class="gray1"><tit:txt mid='103855' mdef='실수령액 (A-B)'/></td>
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
			<td colspan="5" class="aqua center"><tit:txt mid='104186' mdef='지급내역'/></td>
		</tr>
		</table>
		<table border="0" cellpadding="0" cellspacing="0" class="print_table">
		<colgroup>
			<col width="20%" />
			<col width="20%" />
			<col width="20%" />
			<col width="20%" />
			<col width="20%" />
		</colgroup>
		<tr>
			<td colspan="3" class="pink2 noline"></td>
			<td class="pink2 center"><tit:txt mid='103854' mdef='지급총액(A)'/></td>
			<td id="totCalcA" class="pink2 right"></td>
		</tr>
		</table>

		<div class="h15"></div>

		<table id="calcDTable" border="0" cellpadding="0" cellspacing="0" class="print_table">
		<colgroup>
			<col width="20%" />
			<col width="20%" />
			<col width="20%" />
			<col width="20%" />
			<col width="20%" />
		</colgroup>
		<tr>
			<td colspan="5" class="green center"><tit:txt mid='104372' mdef='공제내역'/></td>
		</tr>
		</table>
		<table border="0" cellpadding="0" cellspacing="0" class="print_table">
		<colgroup>
			<col width="20%" />
			<col width="20%" />
			<col width="20%" />
			<col width="20%" />
			<col width="20%" />
		</colgroup>
		<tr>
			<td colspan="3" class="pink2 noline"></td>
			<td class="pink2 center"><tit:txt mid='103954' mdef='공제총액(B)'/></td>
			<td id="totCalcD" class="pink2 right"></td>
		</tr>
		</table>

		<div class="h15"></div>

		<table id="calcTaxTable" border="0" cellpadding="0" cellspacing="0" class="print_table">
		<colgroup>
			<col width="20%" />
			<col width="20%" />
			<col width="20%" />
			<col width="20%" />
			<col width="20%" />
		</colgroup>
		<tr class="hide">
			<td colspan="5" class="blue center"><tit:txt mid='104441' mdef='과표내역'/></td>
		</tr>
		</table>
		<table order="0" cellpadding="0" cellspacing="0" class="print_table hide">
		<colgroup>
			<col width="20%" />
			<col width="20%" />
			<col width="20%" />
			<col width="20%" />
			<col width="20%" />
		</colgroup>
		<tr>
			<td colspan="3" class="pink2 noline"></td>
			<td class="pink2 center"><tit:txt mid='104440' mdef='과표총액'/></td>
			<td id="totCalcTax" class="pink2 right"></td>
		</tr>
		</table>

		<!-- <div class="h5"></div> -->

		<!-- * 과표내역 : 지급 완료된 현금 또는 현물로서, 제세공과금 납부를 위하여 관리하는 금액(지급/공제금액에 미포함) -->

		<!-- <div class="h20"></div> -->

		<table border="0" cellpadding="0" cellspacing="0" class="print_table">
		<colgroup>
			<col width="20%" />
			<col width="" />
		</colgroup>
		<tr>
			<td class="gray1"><tit:txt mid='103783' mdef='비고'/></td>
			<td id="bigo" class="gray2"></td>
		</tr>
		</table>

		<!-- <div class="h25"></div> -->

		</td>

	</tr>
<!-- 	<tr>
		<td class="bottom">
			<div class="print_logo"><img src="/common/images/common/logo_${ssnEnterCd}.gif" /></div>
		</td>
	</tr> -->
	<tr>
		<td>
			<div class="popup_button outer">
				<ul>
					<li>
						<a href="javascript:p.self.close();" class="gray large"><tit:txt mid='104157' mdef='닫기'/></a>
					</li>
				</ul>
			</div><br>
		</td>
	</tr>
</table>
</div>
</body>
</html>
