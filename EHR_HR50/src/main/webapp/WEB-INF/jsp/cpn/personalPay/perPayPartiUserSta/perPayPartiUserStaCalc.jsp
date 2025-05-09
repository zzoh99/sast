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
	
	// 부모 iframe 높이값 계산
	var parentHeight = function() {
		var _height = 0;
		$(".ui-tabs-panel", parent.document).each(function(idx, item){
			if( $(item).css("display") != "none" ) {
				_height = $("iframe", item).outerHeight();
				return false;
			}
		});
		return _height;
	};
	
	var contentHeight = parentHeight() - getOuterHeight() - 20;
	$(".section ", "#area_content").css({
		"min-height" : contentHeight + "px"
	});
	$("#detailListBox").css({
		"height" : (contentHeight - 189) + "px"
	});
	$(".subListBox").css({
		"height" : (contentHeight - 75) + "px"
	});
	
	/*
	var tableHeight = $(window).height() - $("#outer1").height() - 2;
	$("#payTableDiv").height(tableHeight-50);
	$("#deductTableDiv").height(tableHeight-50);
	$("#basicTableDiv").height(tableHeight-50);
	$("#taxTableDiv").height(tableHeight/2-3-50);
	$("#taxFreeTableDiv").height(tableHeight/2-3-50);
	*/

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
				
				var emptyMsg 		= "<tit:txt mid='104490' mdef='조회된 데이터가 없습니다.'/>";

				if (PerPayPartiUserStaInfo.DATA != null && typeof PerPayPartiUserStaInfo.DATA[0] != "undefined") {
					cnt = PerPayPartiUserStaInfo.DATA.length;

					for (var row=0; row<cnt; row++) {
						if (typeof PerPayPartiUserStaInfo.DATA[row] != "undefined" && PerPayPartiUserStaInfo.DATA[row].gubun != null) {
							if (PerPayPartiUserStaInfo.DATA[row].gubun == "PAY") {
								// 지급항목
								payHtmlData += "<li class='disp_flex justify_between alignItem_center bd_bottom_dash h30'>";
								payHtmlData += "<span class='mal10'>";
								if (PerPayPartiUserStaInfo.DATA[row].reportNm != null && PerPayPartiUserStaInfo.DATA[row].reportNm != "") {
									payHtmlData += PerPayPartiUserStaInfo.DATA[row].reportNm;
								}
								payHtmlData += "</span>";
								payHtmlData += "<span class='mar10'>";
								if (PerPayPartiUserStaInfo.DATA[row].resultMon != null && PerPayPartiUserStaInfo.DATA[row].resultMon != "") {
									payHtmlData += PerPayPartiUserStaInfo.DATA[row].resultMon;
								}
								payHtmlData += "</span>";
								payHtmlData += "</li>";
								
							} else if (PerPayPartiUserStaInfo.DATA[row].gubun == "PAY_TOT") {
								if (PerPayPartiUserStaInfo.DATA[row].resultMon != null && PerPayPartiUserStaInfo.DATA[row].resultMon != "") {
									$("#tdPayTot").html(PerPayPartiUserStaInfo.DATA[row].resultMon);
								}
							} else if (PerPayPartiUserStaInfo.DATA[row].gubun == "DEDUCT") {
								// 공제내역
								deductHtmlData += "<li class='disp_flex justify_between alignItem_center bd_bottom_dash h30'>";
								deductHtmlData += "<span class='mal10'>";
								if (PerPayPartiUserStaInfo.DATA[row].reportNm != null && PerPayPartiUserStaInfo.DATA[row].reportNm != "") {
									deductHtmlData += PerPayPartiUserStaInfo.DATA[row].reportNm;
								}
								deductHtmlData += "</span>";
								deductHtmlData += "<span class='mar10'>";
								if (PerPayPartiUserStaInfo.DATA[row].resultMon != null && PerPayPartiUserStaInfo.DATA[row].resultMon != "") {
									deductHtmlData += PerPayPartiUserStaInfo.DATA[row].resultMon;
								}
								deductHtmlData += "</span>";
								deductHtmlData += "</li>";

							} else if (PerPayPartiUserStaInfo.DATA[row].gubun == "DEDUCT_TOT") {
								if (PerPayPartiUserStaInfo.DATA[row].resultMon != null && PerPayPartiUserStaInfo.DATA[row].resultMon != "") {
									$("#tdDeductTot").html(PerPayPartiUserStaInfo.DATA[row].resultMon);
								}
							} else if (PerPayPartiUserStaInfo.DATA[row].gubun == "BASIC") {
								// 급여기초
								basicHtmlData += "<li class='disp_flex justify_between alignItem_center bd_bottom_dash h30'>";
								basicHtmlData += "<span class='mal10'>";
								if (PerPayPartiUserStaInfo.DATA[row].reportNm != null && PerPayPartiUserStaInfo.DATA[row].reportNm != "") {
									basicHtmlData += PerPayPartiUserStaInfo.DATA[row].reportNm;
								}
								basicHtmlData += "</span>";
								basicHtmlData += "<span class='mar10'>";
								if (PerPayPartiUserStaInfo.DATA[row].resultMon != null && PerPayPartiUserStaInfo.DATA[row].resultMon != "") {
									basicHtmlData += PerPayPartiUserStaInfo.DATA[row].resultMon;
								}
								basicHtmlData += "</span>";
								basicHtmlData += "</li>";

							} else if (PerPayPartiUserStaInfo.DATA[row].gubun == "BASIC_TOT") {
								if (PerPayPartiUserStaInfo.DATA[row].resultMon != null && PerPayPartiUserStaInfo.DATA[row].resultMon != "") {
									//console.log(PerPayPartiUserStaInfo.DATA[row].resultMon);
									$("#tdBasicTot").html(PerPayPartiUserStaInfo.DATA[row].resultMon);
								}
							} else if (PerPayPartiUserStaInfo.DATA[row].gubun == "TAX") {
								// 과표내역
								taxHtmlData += "<li class='disp_flex justify_between alignItem_center bd_bottom_dash h30'>";
								taxHtmlData += "<span class='mal10'>";
								if (PerPayPartiUserStaInfo.DATA[row].reportNm != null && PerPayPartiUserStaInfo.DATA[row].reportNm != "") {
									taxHtmlData += PerPayPartiUserStaInfo.DATA[row].reportNm;
								}
								taxHtmlData += "</span>";
								taxHtmlData += "<span class='mar10'>";
								if (PerPayPartiUserStaInfo.DATA[row].resultMon != null && PerPayPartiUserStaInfo.DATA[row].resultMon != "") {
									taxHtmlData += PerPayPartiUserStaInfo.DATA[row].resultMon;
								}
								taxHtmlData += "</span>";
								taxHtmlData += "</li>";

							} else if (PerPayPartiUserStaInfo.DATA[row].gubun == "TAX_TOT") {
								if (PerPayPartiUserStaInfo.DATA[row].resultMon != null && PerPayPartiUserStaInfo.DATA[row].resultMon != "") {
									$("#tdTaxTot").html(PerPayPartiUserStaInfo.DATA[row].resultMon);
								}

							} else if (PerPayPartiUserStaInfo.DATA[row].gubun == "TAX_FREE") {
								// 비과세내역
								taxFreeHtmlData += "<li class='disp_flex justify_between alignItem_center bd_bottom_dash h30'>";
								taxFreeHtmlData += "<span class='mal10'>";
								if (PerPayPartiUserStaInfo.DATA[row].reportNm != null && PerPayPartiUserStaInfo.DATA[row].reportNm != "") {
									taxFreeHtmlData += PerPayPartiUserStaInfo.DATA[row].reportNm;
								}
								taxFreeHtmlData += "</span>";
								taxFreeHtmlData += "<span class='mar10'>";
								if (PerPayPartiUserStaInfo.DATA[row].resultMon != null && PerPayPartiUserStaInfo.DATA[row].resultMon != "") {
									taxFreeHtmlData += PerPayPartiUserStaInfo.DATA[row].resultMon;
								}
								taxFreeHtmlData += "</span>";
								taxFreeHtmlData += "</li>";

							} else if (PerPayPartiUserStaInfo.DATA[row].gubun == "TAX_FREE_TOT") {
								if (PerPayPartiUserStaInfo.DATA[row].resultMon != null && PerPayPartiUserStaInfo.DATA[row].resultMon != "") {
									$("#tdTaxFreeTot").html(PerPayPartiUserStaInfo.DATA[row].resultMon);
								}
							}
						}
					}
				}

				// 지급항목
				if (payHtmlData == "") 		payHtmlData 	= "<li class='mat10 alignC'><span class=''>" + emptyMsg + "</span></li>";
				// 공제내역
				if (deductHtmlData == "")	deductHtmlData	= "<li class='mat10 alignC'><span class=''>" + emptyMsg + "</span></li>";
				// 급여기초
				if (basicHtmlData == "")	basicHtmlData 	= "<li class='mat10 alignC'><span class=''>" + emptyMsg + "</span></li>";
				// 과표내역
				if (taxHtmlData == "") 		taxHtmlData 	= "<li class='mat10 alignC'><span class=''>" + emptyMsg + "</span></li>";
				// 비과세내역
				if (taxFreeHtmlData == "") 	taxFreeHtmlData = "<li class='mat10 alignC'><span class=''>" + emptyMsg + "</span></li>";

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
					$("#totEarningMon").html(taxInfo.totEarningMon);
					$("#taxBaseMon").html(taxInfo.taxBaseMon);
					$("#notaxTotMon").html(taxInfo.notaxTotMon);
					$("#taxibleEarnMon").html(taxInfo.taxibleEarnMon);
					$("#familyCnt").html(taxInfo.familyCnt);
					$("#addChildCnt").html(taxInfo.addChildCnt);
					$("#paymentMon").html(taxInfo.paymentMon);
					$("#totDedMon").html(taxInfo.totDedMon);
					$("#itaxMon").html(taxInfo.itaxMon);
					$("#rtaxMon").html(taxInfo.rtaxMon);
					
					// 기타공제 금액 계산
					var totDedMon = (taxInfo.totDedMon && taxInfo.totDedMon != null) ? parseInt(taxInfo.totDedMon.replace(/,/gi, ""), 10) : 0;
					var itaxMon   = (taxInfo.itaxMon && taxInfo.itaxMon != null) ? parseInt(taxInfo.itaxMon.replace(/,/gi, ""), 10) : 0;
					var rtaxMon   = (taxInfo.rtaxMon && taxInfo.rtaxMon != null) ? parseInt(taxInfo.rtaxMon.replace(/,/gi, ""), 10) : 0;
					var etcDedMon = (totDedMon - itaxMon - rtaxMon);
					
					$("#etcDedMon").html((( etcDedMon > 0 )) ? makeComma(etcDedMon) : "");
					
					// 실지급액 비율 계산
					var paymentRate = ((parseInt(taxInfo.paymentMon.replace(/,/gi, ""), 10) / parseInt(taxInfo.totEarningMon.replace(/,/gi, ""), 10)) * 100).toFixed(1);
					$("#paymentRate, #deductRate").empty();
					$("#paymentBar").css("width", "0%").animate({
						"width" : paymentRate + "%"
					},{
						duration : 900,
						complete : function() {
							$("#paymentRate").html( paymentRate + "%" );
							$("#deductRate").html( (100 - paymentRate).toFixed(1) + "%" );
						}
					});
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
			$("#totDedMon"		).html("");
			$("#etcDedMon"		).html("");

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

	    <%--var rv = openPopup("${ctx}/yjungsan/y_workStdLaw/jsp_jungsan/perPayPartiPopStaFormula/perPayPartiPopStaFormula.jsp?authPg=R", args,  "800","880");--%>

		var url = '/PerPayPartiUserSta.do?cmd=viewPerPayPartiUserStaCalcFormulaLayer';
		var layerModal = new window.top.document.LayerModal({
			id: 'perPayPartiUserStaCalcFormulaLayer',
			parameters: args,
			url: url,
			width: 800,
			height: 815,
			title: '급여명세서(계산방법 포함)',
			trigger: [
				{
					name: 'perPayPartiUserStaCalcFormulaLayerTrigger',
					callback: function(rv) {
						// getReturnValueListBox4(rv);
					}
				}
			]
		});
		layerModal.show();
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
	<div class="sheet_title outer">
		<ul>
			<li class="txt">
				<tit:txt mid='perPayPartiAdminStaCalc1' mdef='급여지급내역'/>
			</li>
			<li class="btn">
				<btn:a href="javascript:previewFormulaPopup()"  id= "previewFormulaPop" css="basic authR" mid='previewFormulaPopup' mdef="계산방법보기" style="display:none;"/></li>
			</li>
		</ul>
	</div>
	<div id="area_content" class="disp_flex justify_between">
		<div class="section w35p">
			<div id="area_summary" class="bd_r6 point_bg_lite pad-y-15">
				<div class="disp_flex justify_between alignItem_center pad-x-15">
					<p class="f_s14 f_bold">
						<i class="fas fa-asterisk f_point f_s8"></i>
						<span><tit:txt mid='104374' mdef='실지급액'/></span>
					</p>
					<p>
						<span id="paymentMon" class="f_point f_s17 f_bold"></span>
					</p>
				</div>
				<div id="area_rate" class="pad-x-15 mat10">
					<div class="bd_r4 bg_white pad15">
						<div id="rateBar" class="disp_flex justify_start alignItem_center h10 bg_red bd_r5 mat5">
							<div id="paymentBar" class="point_bg_deep h10 bd_r5"></div>
						</div>
						<div class="disp_flex justify_between alignItem_center mat10">
							<p class="f_s11 mal5">
								<tit:txt mid='perPayMasterMgrException1' mdef='지급'/>
								<span id="paymentRate" class="f_point"></span>
							</p>
							<p class="f_s11 mar5">
								<tit:txt mid='perPayMasterMgrException2' mdef='공제'/>
								<span id="deductRate" class="f_red"></span>
							</p>
						</div>
					</div>
				</div>
				<div class="disp_flex justify_start alignItem_center pad-x-15 mat20">
					<span class="f_bold"><tit:txt mid='2017083001015' mdef='상세내역'/></span>
				</div>
				<div class="pad-x-15 mat10">
					<div id="detailListBox" class="overflow_hide_x overflow_auto_y bd_r4 bg_white pad-y-10">
						<dl class="disp_flex justify_between alignItem_center h25 ma-x-10">
							<dt class="f_s13">
								<span class="mal10 f_bold">
									<i class="fas fa-plus f_point mar5"></i>
									<tit:txt mid='103984' mdef='지급총액'/>
								</span>
							</dt>
							<dd id="totEarningMon" class="alignR mar10 f_bold f_s13"></dd>
						</dl>
						<dl class="disp_flex justify_between alignItem_center h25 ma-x-10">
							<dt class="f_s13">
								<span class="mal30"><tit:txt mid='104385' mdef='과세총액'/></span>
							</dt>
							<dd id="taxBaseMon" class="alignR mar10"></dd>
						</dl>
						<dl class="disp_flex justify_between alignItem_center h25 ma-x-10">
							<dt class="f_s13">
								<span class="mal30"><tit:txt mid='104489' mdef='비과세총액'/></span>
							</dt>
							<dd id="notaxTotMon" class="alignR mar10"></dd>
						</dl>
						<dl class="disp_flex justify_between alignItem_center h25 ma-x-10">
							<dt class="f_s13">
								<span class="mal30"><tit:txt mid='104382' mdef='과세대상금액'/></span>
							</dt>
							<dd id="taxibleEarnMon" class="alignR mar10"></dd>
						</dl>
					<!-- 경계선 -->
						<div class="ma-y-10 ma-x-20 bd_top_dash"></div>
					<!-- //경계선 -->
						<dl class="disp_flex justify_between alignItem_center h25 ma-x-10">
							<dt class="f_s13">
								<span class="mal10">
									<i class="fas fa-check mar5"></i>
									<tit:txt mid='104197' mdef='부양가족수'/>
								</span>
							</dt>
							<dd id="familyCnt" class="alignR mar10"></dd>
						</dl>
						<dl class="disp_flex justify_between alignItem_center h25 ma-x-10">
							<dt class="f_s13">
								<span class="mal10">
									<i class="fas fa-check mar5"></i>
									<tit:txt mid='104493' mdef='다자녀수'/>
								</span>
							</dt>
							<dd id="addChildCnt" class="alignR mar10"></dd>
						</dl>
					<!-- 경계선 -->
						<div class="ma-y-10 ma-x-20 bd_top_dash"></div>
					<!-- //경계선 -->
						<dl class="disp_flex justify_between alignItem_center h25 ma-x-10">
							<dt class="f_s13">
								<span class="mal10">
									<i class="fas fa-minus f_red mar5"></i>
									<tit:txt mid='104373' mdef='공제총액'/>
								</span>
							</dt>
							<dd id="totDedMon" class="alignR mar10 f_bold f_s13"></dd>
						</dl>
						<dl class="disp_flex justify_between alignItem_center h25 ma-x-10">
							<dt class="f_s13">
								<span class="mal30">
									<tit:txt mid='103981' mdef='소득세'/>
								</span>
							</dt>
							<dd id="itaxMon" class="alignR mar10"></dd>
						</dl>
						<dl class="disp_flex justify_between alignItem_center h25 ma-x-10">
							<dt class="f_s13">
								<span class="mal30">
									<tit:txt mid='103983' mdef='주민세'/>
								</span>
							</dt>
							<dd id="rtaxMon" class="alignR mar10"></dd>
						</dl>
						<dl class="disp_flex justify_between alignItem_center h25 ma-x-10">
							<dt class="f_s13">
								<span class="mal30">
									<tit:txt mid='104152' mdef='기타공제'/>
								</span>
							</dt>
							<dd id="etcDedMon" class="alignR mar10"></dd>
						</dl>
					</div>
				</div>
			</div>
		</div>
		<div class="section disp_flex justify_start alignItem_start w65p mal30 mar5">
			<div class="w33p pad-y-10">
				<div class="title disp_flex justify_start alignItem_center f_s13">
					<i class="fas fa-asterisk f_point f_s8 mar5"></i>
					<strong><tit:txt mid='perPayMasterMgrException1' mdef='지급'/></strong>
				</div>
				<div class="subListBox overflow_hide_x overflow_auto_y bd_top_solid mat10">
					<ul id="payTable"></ul>
				</div>
				<ul class="mat5">
					<li class="disp_flex justify_between alignItem_center bd_r5 point_bg_lite h30">
						<span class="mal10 f_bold"><tit:txt mid='104481' mdef='합계'/></span>
						<span id="tdPayTot" class="mar10 f_bold"></span>
					</li>
				</ul>
			</div>
			<div class="w33p pad-y-10 mal30">
				<div class="title disp_flex justify_start alignItem_center f_s13">
					<i class="fas fa-asterisk f_point f_s8 mar5"></i>
					<strong><tit:txt mid='perPayMasterMgrException2' mdef='공제'/></strong>
				</div>
				<div class="subListBox overflow_hide_x overflow_auto_y bd_top_solid mat10">
					<ul id="deductTable"></ul>
				</div>
				<ul class="mat5">
					<li class="disp_flex justify_between alignItem_center bd_r5 point_bg_lite h30">
						<span class="mal10 f_bold"><tit:txt mid='104481' mdef='합계'/></span>
						<span id="tdDeductTot" class="mar10 f_bold"></span>
					</li>
				</ul>
			</div>
			<div class="w33p pad-y-10 mal30">
				<div class="title disp_flex justify_start alignItem_center f_s13">
					<i class="fas fa-asterisk f_point f_s8 mar5"></i>
					<strong><tit:txt mid='perPayMasterMgrException3' mdef='급여기초'/></strong>
				</div>
				<div class="subListBox overflow_hide_x overflow_auto_y bd_top_solid mat10">
					<ul id="basicTable"></ul>
				</div>
				<ul class="mat5">
					<li class="disp_flex justify_between alignItem_center bd_r5 point_bg_lite h30">
						<span class="mal10 f_bold"><tit:txt mid='104481' mdef='합계'/></span>
						<span id="tdBasicTot" class="mar10 f_bold"></span>
					</li>
				</ul>
			</div>
		</div>
	</div>
</div>
</body>
</html>
