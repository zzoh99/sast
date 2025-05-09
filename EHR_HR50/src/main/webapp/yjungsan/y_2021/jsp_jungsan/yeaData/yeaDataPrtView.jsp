<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>PDF출력</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%@ page import="com.hr.common.logger.Log" %>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="yjungsan.exception.*"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%String orgAuthPg = request.getParameter("orgAuthPg");%>
<script type="text/javascript">
var orgAuthPg = "<%=removeXSS(orgAuthPg, '1')%>";
var isIncome=false;

$(function() {
    //엑셀,파일다운 시 화면명 저장(교보증권) - 2021.10.26
    $("#menuNm").val($(document).find("title").text()); //엑셀,CURD
    /*필수 기본 세팅*/
    var ssnEnterCd = $("#ssnEnterCd").val( $("#ssnEnterCd", parent.document).val() ) ;
    var ssnSabun = $("#ssnSabun").val( $("#ssnSabun", parent.document).val() ) ;
    var searchWorkYy = $("#searchWorkYy").val( $("#searchWorkYy", parent.document).val() ) ;
    var searchAdjustType = $("#searchAdjustType").val( $("#searchAdjustType", parent.document).val()) ;
    var searchSabun = $("#searchSabun").val( $("#searchSabun", parent.document).val()) ;
    var searchPayActionCd = $("#searchPayActionCd").val( $("#searchPayActionCd", parent.document).val()) ;
});

/**
 * 소득공제서 / 기부금명세서 / 신용카드 등 소득공제 신청서 / 의료비지급명세서 / 교육비명세서(양식) / 소득공제 시기 변경신청서(양식)
 * 레포트 공통에 맞춘 개발 코드 템플릿
 * by JSG
 */
function openPrint(report_type){
    //기부금명세서 문구 초기화
	$("#orgAuthDiv").hide();
    $("#orgAuthDivA").hide();

    // 소득공제서 출력가능여부 체크
    if(report_type == "INCOME") {
		var param = "searchWorkYy="+$("#searchWorkYy").val();
	    var result = ajaxCall("<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=selectDedPrintEnableYn",param,false);

	    if(result.Result.Code != "1") {
	    	alert(result.Result.Message);
			$("#reportPage_ifrmsrc_div").hide();
			$("#incomeY").hide();
			$("#income").show();
	    	return;
	    }
	    if(result.Data.print_enable_yn != "Y") {
	    	alert("국세청에서 개정된 소득공제서 서식이 제공되지 않았으므로\n출력할 수 없습니다.");
			$("#incomeY").hide();
			$("#income").show();
			$("#reportPage_ifrmsrc_div").hide();
	    	return;
	    }
    }

	//본인마감 이상일 경우만 버튼 조회될수 있도록 처리(자료등록(관리자)는 제외) - 2019.12.12
	if(report_type != 'EDUCATION' && report_type != 'INCOMECHGAPP') {
		var btn_id = "#"+report_type.toLowerCase();
		if($(btn_id).attr("class").indexOf("cute_gray") > -1) {
			alert("본인마감 이후 조회가능합니다.");
			return;
		}
	}

	if(orgAuthPg != "A" && report_type == 'INCOME' && !isIncome) {
		if(confirm("본인이 직접 연말정산 공제를 입력하였으며\n"+
				   "이상이 없음을 확인합니다.\n\n"+
				   "소득공제서를 확인하시겠습니까?")) {
			isIncome = true;
		} else {
			$("#incomeY").hide();
			$("#income").show();
			$("#reportPage_ifrmsrc_div").hide();
			return;
		}
	}
	$("#reportPage_ifrmsrc_div").show();

	var rdFileNm = "";
	var baseDate = "<%=curSysYyyyMMdd%>";

	if(report_type == "CARD" || report_type == "DONATION" || report_type == "MEDICAL" || report_type == "EDUCATION" || report_type == "INCOMECHGAPP"){
		/* 신용카드 / 기부명세서 / 의료비명세서  Param*/
		var rdParam = "[<%=removeXSS(session.getAttribute("ssnEnterCd"), "1")%>] ["+$("#searchWorkYy").val()+"] ["+$('#searchAdjustType', parent.document).val()+"]"+
	    "['"+$("#searchSabun").val()+"'] [00000] [ALL] "+
	    "[4] ["+$("#searchSabun").val()+"] [1] ["+baseDate+"]";//rd파라매터
	}

	//2019-11-12. 기부금 명세서일 경우 2페이지 작성방법이 나오지 않게 할 수 있는 옵션 추가
	if(report_type == "DONATION") {
		$("#pageChkArea").show();
		rdParam = rdParam + " ["+$("#SubPageYn").val()+"]";

		var stsParam = "searchWorkYy="+$("#searchWorkYy").val();
	        stsParam += "&searchAdjustType="+$("#searchAdjustType").val();
	        stsParam += "&searchSabun="+$("#searchSabun").val();

	    var stsCnt = ajaxCall("<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=selecPayPeopleStsCnt",stsParam,false);

	    if(stsCnt.Result.Code == "1") {
	    	if(stsCnt.Data.cnt > 0){
	    		if(orgAuthPg == "A"){
	                $("#orgAuthDivA").show();
	            }else{
	                $("#orgAuthDiv").show();
	            }
	    	}else{
	            $("#orgAuthDiv").hide();
	            $("#orgAuthDivA").hide();
	    	}
	    }else{
	    	$("#orgAuthDiv").hide();
	    	$("#orgAuthDivA").hide();
	    }
	} else {
		$("#pageChkArea").hide();
	}

	//소득공제서
	if(report_type == "INCOME") {
		/* 소득공제서 param */
		var rdParam = "[<%=removeXSS(session.getAttribute("ssnEnterCd"), "1")%>] ["+$("#searchWorkYy").val()+"] ["+$('#searchAdjustType', parent.document).val()+"]" +
	    "['"+$("#searchSabun").val()+"'] ["+baseDate+"] " + "[4] ["+$("#searchSabun").val()+"] [1] ["+baseDate+"]";

		if( ($("#searchWorkYy").val()*1) >= 2007 ) {
			rdFileNm = "EmpIncomeDeductionDeclaration_" + $("#searchWorkYy").val() + ".mrd" ;
		} else {
			rdFileNm = "EmpIncomeDeductionDeclaration.mrd" ;
		}
	//신용카드 등 소득공제 신청서
	}else if(report_type == "CARD"){
		rdFileNm = "CardPaymentDescription_" + $("#searchWorkYy").val() + ".mrd" ;
	//기부금 명세서
	}else if(report_type == "DONATION"){
		if( ($("#searchWorkYy").val()*1) > 2006 ) {
			rdFileNm = "DonationPaymentDescription_" + $("#searchWorkYy").val() + ".mrd" ;
		} else {
			rdFileNm = "DonationPaymentDescription.mrd" ;
		}
	//교육비명세서(양식)
	}else if(report_type == "EDUCATION"){
		rdFileNm = "EducationPaymentDescription_" + $("#searchWorkYy").val() + ".mrd" ;
	//소득공제서(세액계산)
	}else if(report_type == "INCOMECALC"){
		/* 소득공제서 param */
		var rdParam = "[<%=removeXSS(session.getAttribute("ssnEnterCd"), "1")%>] ["+$("#searchWorkYy").val()+"] ["+$('#searchAdjustType', parent.document).val()+"]" +
	    "['"+$("#searchSabun").val()+"'] ["+baseDate+"] " + "[4] ["+$("#searchSabun").val()+"] [1] ["+baseDate+"]";

		if( ($("#searchWorkYy").val()*1) >= 2007 ) {
			rdFileNm = "EmpIncomeDeductionDeclaration_" + $("#searchWorkYy").val() + "_a.mrd" ;
		} else {
			rdFileNm = "EmpIncomeDeductionDeclaration.mrd" ;
		}
	//소득공제 시기 변경신청서 양식
	}else if(report_type == "INCOMECHGAPP"){
		rdFileNm = "EmpIncomeDeductionChgApp_" + $("#searchWorkYy").val() + ".mrd" ;
	//의료비지급명세서
	}else{
		rdFileNm = "MedicalPaymentDescription_" + $("#searchWorkYy").val() + ".mrd" ;
	}

	$("#Mrd").val("<%=cpnYearEndPath%>/"+rdFileNm) ;
	$("#Param").val(rdParam+" ") ;
	$("#ToolbarYn").val("Y") ;
	$("#ZoomRatio").val("100") ;
	$("#ParamGubun").val("rp") ;
	$("#SaveYn").val("Y") ;      //기능컨트롤_저장
	$("#PrintYn").val("Y") ; 	 //기능컨트롤_인쇄
	$("#ExcelYn").val("Y") ;     //기능컨트롤_엑셀
	$("#WordYn").val("Y") ;      //기능컨트롤_워드
	$("#PptYn").val("Y") ;       //기능컨트롤_파워포인트
	$("#HwpYn").val("Y") ;       //기능컨트롤_한글
	$("#PdfYn").val("Y") ;       //기능컨트롤_PDF

	/* 파라미터 변조 체크를 위한 securityKey 를 파라미터로 전송 함 */
	$("#SecurityKey").val("<%=removeXSS(request.getAttribute("securityKey"), '1')%>");

	//rd iframe 호출
	/* submitCall($("#mainForm"),"reportPage_ifrmsrc","post","/yjungsan/y_2018/jsp_jungsan/common/rdPopupIframe.jsp"); */
	submitCall($("#mainForm"),"reportPage_ifrmsrc","post","../common/rdPopupIframe.jsp");
}

/* 버튼 기능 */
$(document).ready(function(){
	//소득공제서 버튼 선택시 활성 비활성
	$("#income").live("click",function(){
    		var btnId = $(this).attr('id');
    		if(btnId == "income"){
    			$("#incomeY").show();
    			$("#income").hide();
    			$("#incomecalcY").hide();
    			$("#incomecalc").show();
    			$("#card").show();
    			$("#education").show();
    			$("#donation").show();
    			$("#medical").show();


    			$("#cardY").hide();
    			$("#donationY").hide();
    			$("#medicalY").hide();
    			$("#educationY").hide();
    			$("#incomechgapp").show();
    			$("#incomechgappY").hide();
    		}
	});

	//신용카드 버튼 선택시 활성 비활성
	$("#card").live("click",function(){
    		var btnId = $(this).attr('id');
    		if(btnId == "card"){
    			$("#cardY").show();
    			$("#card").hide();

    			$("#incomeY").hide();
    			$("#incomecalcY").hide();
    			$("#donationY").hide();
    			$("#medicalY").hide();
    			$("#educationY").hide();

    			$("#income").show();
    			$("#incomecalc").show();
    			$("#donation").show();
    			$("#medical").show();
    			$("#education").show();

    			$("#incomechgapp").show();
    			$("#incomechgappY").hide();

    		}
	});

	//기부금명세서 버튼 선택시 활성 비활성
	$("#donation").live("click",function(){
    		var btnId = $(this).attr('id');
    		if(btnId == "donation"){
    			$("#donationY").show();
    			$("#donation").hide();

    			$("#incomeY").hide();
    			$("#incomecalcY").hide();
    			$("#cardY").hide();
    			$("#medicalY").hide();
    			$("#educationY").hide();

    			$("#income").show();
    			$("#incomecalc").show();
    			$("#card").show();
    			$("#medical").show();
    			$("#education").show();

    			$("#incomechgapp").show();
    			$("#incomechgappY").hide();
    		}
	});

	//의료비명세서 버튼 선택시 활성 비활성
	$("#medical").live("click",function(){
    		var btnId = $(this).attr('id');
    		if(btnId == "medical"){
    			$("#medicalY").show();
    			$("#medical").hide();

    			$("#incomeY").hide();
    			$("#incomecalcY").hide();
    			$("#cardY").hide();
    			$("#donationY").hide();
    			$("#educationY").hide();

    			$("#income").show();
    			$("#incomecalc").show();
    			$("#card").show();
    			$("#donation").show();
    			$("#education").show();

    			$("#incomechgapp").show();
    			$("#incomechgappY").hide();
    		}
	});

	//교육비명세서 버튼 선택시 활성 비활성
	$("#education").live("click",function(){
    		var btnId = $(this).attr('id');
    		if(btnId == "education"){
    			$("#educationY").show();
    			$("#education").hide();

    			$("#incomeY").hide();
    			$("#incomecalcY").hide();
    			$("#cardY").hide();
    			$("#donationY").hide();
    			$("#medicalY").hide();

    			$("#income").show();
    			$("#incomecalc").show();
    			$("#card").show();
    			$("#donation").show();
    			$("#medical").show();

    			$("#incomechgapp").show();
    			$("#incomechgappY").hide();
    		}
	});


	//소득공제 시기 변경신청서 클릭시
	$("#incomechgapp").live("click",function(){
    		var btnId = $(this).attr('id');
    		if(btnId == "incomechgapp"){
    			$("#incomechgappY").show();
    			$("#incomechgapp").hide();

    			$("#incomeY").hide();
    			$("#incomecalcY").hide();
    			$("#cardY").hide();
    			$("#donationY").hide();
    			$("#medicalY").hide();

    			$("#income").show();
    			$("#incomecalc").show();
    			$("#card").show();
    			$("#donation").show();
    			$("#medical").show();

    			$("#educationY").hide();
    			$("#education").show();
    		}
	})

	//본인마감 이상일 경우만 버튼 조회될수 있도록 처리(자료등록(관리자)는 제외) - 2019.12.12
	var empStatus = $("#tdStatusView>font:first", parent.document).attr("class");
	if(orgAuthPg != "A" ) {
		if(empStatus == "close_0" || empStatus == "close_1") {
			$("a.button_prt,a.cute_prt").addClass("cute_gray");
			$("a.button_prt,a.cute_prt").removeClass("button_prt cute_prt");
		}
		$("#incomeY").hide();
		$("#income").show();
	} else {
		openPrint('INCOME');
	}
});

//2019-11-12. 기부금 명세서일 경우 2페이지 작성방법이 나오지 않게 할 수 있는 옵션 추가
function chkSubPage(){
	if ($("#pageChk").is(":checked")) {
		$("#SubPageYn").val("Y");
	}else{
		$("#SubPageYn").val("N");
	}
	openPrint('DONATION');
}

</script>
<style type="text/css">

a.button_prt {border:none;display: inline-block;line-height: 20px;margin-right: .1em;cursor: pointer;vertical-align: middle;text-align: center;overflow: visible; /* removes extra width in IE */background: #298d99;font-family:NanumGothic,Dotum,돋움,arial;font-weight: bold;padding: 3px 11px 4px 10px;color:#fff;font-size:14px;word-break:keep-all;height: 20px;}
a:hover.button_prt {color:#fff !important}

a.cute_prt {display: inline-block;line-height: normal;margin-right: .1em;cursor: pointer;vertical-align: middle;text-align: center;overflow: visible; /* removes extra width in IE */background: #3ab7c6;border:1px solid #3ab7c6;font-weight: normal;padding: 4px 5px 3px 6px;padding:5px 5px 4px 6px\9;color:#fff;font-size:11px;word-break:keep-all}
a:hover.cute_prt {color:#fff}
</style>
</head>
<body class="bodywrap">
	<div class="wrapper">
		<div class="sheet_search outer" style="display:none;">
		<form id="mainForm" name="mainForm">
		<input type="hidden" id="searchWorkYy" name="searchWorkYy" value="2018" />
		<input type="hidden" id="searchAdjustType" name="searchAdjustType" value="" />
		<input type="hidden" id="searchSabun" name="searchSabun" value="" />
		<input type="hidden" id="searchRegNo" name="searchRegNo" value="" />
		<input type="hidden" id="inputStatus" name="inputStatus" value="" />
		<input type="hidden" id="searchPayActionCd" name="searchPayActionCd" value="" />
		<input type="hidden" id="Mrd" name="Mrd"></input>
		<input type="hidden" id="Param" name="Param"></input>
		<input type="hidden" id="ToolbarYn" name="ToolbarYn"></input>
		<input type="hidden" id="ZoomRatio" name="ZoomRatio"></input>
		<input type="hidden" id="ParamGubun" name="ParamGubun"></input>
		<input type="hidden" id="SaveYn" name="SaveYn"></input>
		<input type="hidden" id="PrintYn" name="PrintYn"></input>
		<input type="hidden" id="ExcelYn" name="ExcelYn"></input>
		<input type="hidden" id="WordYn" name="WordYn"></input>
		<input type="hidden" id="PptYn" name="PptYn"></input>
		<input type="hidden" id="HwpYn" name="HwpYn"></input>
		<input type="hidden" id="PdfYn" name="PdfYn"></input>
		<input type="hidden" id="printResultYn" name="printResultYn" value="N"></input>
		<input type="hidden" id="SecurityKey" name="SecurityKey"></input>
		<input type="hidden" id="SubPageYn" name="SubPageYn" value="Y"/><!-- 2019-11-12. 기부금 명세서일 경우 2페이지 작성방법이 나오지 않게 할 수 있는 옵션 추가 -->
		<input type="hidden" id="menuNm" name="menuNm" value="" />
		</form>
		</div>
		<br>
		<div class="sheet_search outer">
	        <table>
		        <tr>
		        	<td>
			            <a href="javascript:openPrint('INCOME');" id="income" class="basic btn-green-outline" style="display:none;">소득공제서</a>
			            <a href="javascript:openPrint('INCOME');" id="incomeY" class="basic btn-green ico-check">소득공제서</a>
			            <a href="javascript:openPrint('CARD');" id="card" class="basic btn-green-outline">신용카드등</a>
			            <a href="javascript:openPrint('CARD');" id="cardY" class="basic btn-green ico-check" style="display:none;">신용카드등</a>
			            <a href="javascript:openPrint('DONATION');" id="donation" class="basic btn-green-outline">기부금명세서</a>
			            <a href="javascript:openPrint('DONATION');" id="donationY" class="basic btn-green ico-check" style="display:none;">기부금명세서</a>
			            <a href="javascript:openPrint('MEDICAL');" id="medical" class="basic btn-green-outline">의료비명세서</a>
			            <a href="javascript:openPrint('MEDICAL');" id="medicalY" class="basic btn-green ico-check" style="display:none;">의료비명세서</a>&nbsp;&nbsp;&nbsp;&nbsp;
			            <a href="javascript:openPrint('EDUCATION');" id="education" class="basic btn-white">교육비명세서(양식)</a>
			            <a href="javascript:openPrint('EDUCATION');" id="educationY" class="basic btn-white out-line ico-check" style="display:none;" >교육비명세서(양식)</a>
			            <a href="javascript:openPrint('INCOMECHGAPP');" id="incomechgapp" class="basic btn-white">소득공제 시기 변경신청서(양식)</a>
			            <a href="javascript:openPrint('INCOMECHGAPP');" id="incomechgappY" class="basic btn-white out-line ico-check" style="display:none;" >소득공제 시기 변경신청서(양식)</a>

			            <span id="pageChkArea" style="display: none;">&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" class="checkbox" id="pageChk" name="pageChk" value="Y" onchange="chkSubPage();" style="vertical-align:middle;" checked="checked"/> 작성방법</span><!-- 2019-11-12. 기부금 명세서일 경우 2페이지 작성방법이 나오지 않게 할 수 있는 옵션 추가 -->
		            </td>
		        </tr>
	        </table>
    	</div>
    	<div id="orgAuthDiv" style="display: none;margin-top: 8px"><span class="blue">기부금명세서 금액은 세금계산 작업을 해야 나옵니다. 관리자에게 문의해 주시기 바랍니다.</span></div>
    	<div id="orgAuthDivA" style="display: none;margin-top: 8px"><span class="blue">기부금명세서 금액은 세금계산 작업을 해야 나옵니다. [정산계산/결과>연말정산계산]에서 세금계산을 해주십시오.</span></div>
    	<br>
    	<div id="reportPage_ifrmsrc_div">
			<iframe name="reportPage_ifrmsrc" id="reportPage_ifrmsrc" frameborder='0' class='tab_iframes'  style="height:100%; height: calc(100% - 74px);"></iframe>
		</div>
	</div>
</body>
