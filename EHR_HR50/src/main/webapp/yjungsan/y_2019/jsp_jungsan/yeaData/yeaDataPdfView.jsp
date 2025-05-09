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
<script type="text/javascript">

$(function() {
    /*필수 기본 세팅*/
    var ssnEnterCd = $("#ssnEnterCd").val( $("#ssnEnterCd", parent.document).val() ) ;
    var ssnSabun = $("#ssnSabun").val( $("#ssnSabun", parent.document).val() ) ;
    var searchWorkYy = $("#searchWorkYy").val( $("#searchWorkYy", parent.document).val() ) ;
    var searchAdjustType = $("#searchAdjustType").val( $("#searchAdjustType", parent.document).val()) ;
    var searchSabun = $("#searchSabun").val( $("#searchSabun", parent.document).val()) ;
    var searchPayActionCd = $("#searchPayActionCd").val( $("#searchPayActionCd", parent.document).val()) ;  
});

/**
 * 소득공제서 / 기부금명세서 / 신용카드 등 소득공제 신청서 / 의료비지급명세서 / 교육비명세서(양식)
 * 레포트 공통에 맞춘 개발 코드 템플릿
 * by JSG
 */
function openPrint(report_type){
	var rdFileNm = "";
	var baseDate = "<%=curSysYyyyMMdd%>";

	if(report_type == "CARD" || report_type == "DONATION" || report_type == "MEDICAL" || report_type == "EDUCATION"){
		/* 신용카드 / 기부명세서 / 의료비명세서  Param*/
		var rdParam = "[<%=removeXSS(session.getAttribute("ssnEnterCd"), '1')%>] ["+$("#searchWorkYy").val()+"] ["+$('#searchAdjustType', parent.document).val()+"]"+
	    "['"+$("#searchSabun").val()+"'] [00000] [ALL] "+
	    "[4] ["+$("#searchSabun").val()+"] [1] ["+baseDate+"]";//rd파라매터
	}
	
	//소득공제서
	if(report_type == "INCOME") {
		/* 소득공제서 param */
		var rdParam = "[<%=removeXSS(session.getAttribute("ssnEnterCd"), '1')%>] ["+$("#searchWorkYy").val()+"] ["+$('#searchAdjustType', parent.document).val()+"]" +
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
		var rdParam = "[<%=removeXSS(session.getAttribute("ssnEnterCd"), '1')%>] ["+$("#searchWorkYy").val()+"] ["+$('#searchAdjustType', parent.document).val()+"]" +
	    "['"+$("#searchSabun").val()+"'] ["+baseDate+"] " + "[4] ["+$("#searchSabun").val()+"] [1] ["+baseDate+"]";
		
		if( ($("#searchWorkYy").val()*1) >= 2007 ) {
			rdFileNm = "EmpIncomeDeductionDeclaration_" + $("#searchWorkYy").val() + "_a.mrd" ;
		} else {
			rdFileNm = "EmpIncomeDeductionDeclaration.mrd" ;
		}
		
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
	$("#SecurityKey").val("<%=request.getAttribute("securityKey")%>");

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
    			
    			$("#cardY").hide();
    			$("#donationY").hide();
    			$("#medicalY").hide();
    			$("#educationY").hide();
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
    		}
	});
});

</script>
</head>
<body class="bodywrap" onload="openPrint('INCOMECALC')">
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
		</form>
		</div>
		<br>
		<div class="sheet_search outer">
	        <table>
		        <tr>
		        	<td>
			            <a href="javascript:openPrint('INCOME');" id="income" class="cute_gray" style="display:none;">소득공제서</a>
			            <a href="javascript:openPrint('INCOME');" id="incomeY" class="button">소득공제서</a>
			            <a href="javascript:openPrint('CARD');" id="card" class="cute_gray">신용카드등</a>
			            <a href="javascript:openPrint('CARD');" id="cardY" class="button" style="display:none;">신용카드등</a>
			            <a href="javascript:openPrint('DONATION');" id="donation" class="cute_gray">기부금명세서</a>
			            <a href="javascript:openPrint('DONATION');" id="donationY" class="button" style="display:none;">기부금명세서</a>
			            <a href="javascript:openPrint('MEDICAL');" id="medical" class="cute_gray">의료비명세서</a>
			            <a href="javascript:openPrint('MEDICAL');" id="medicalY" class="button" style="display:none;">의료비명세서</a>
			            <a href="javascript:openPrint('EDUCATION');" id="education" class="cute_gray">교육비명세서</a>
			            <a href="javascript:openPrint('EDUCATION');" id="educationY" class="button" style="display:none;">교육비명세서</a>
		            </td>
		        </tr>
	        </table>
    	</div>
    	<br>
		<iframe name="reportPage_ifrmsrc" id="reportPage_ifrmsrc" frameborder='0' class='tab_iframes'></iframe>
	</div>
</body>
