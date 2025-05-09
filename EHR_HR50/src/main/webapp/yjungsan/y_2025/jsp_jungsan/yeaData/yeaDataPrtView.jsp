<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>PDF출력</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="yjungsan.exception.*"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%String orgAuthPg = request.getParameter("orgAuthPg");%>
<script type="text/javascript">
var orgAuthPg = "<%=orgAuthPg%>";
var isIncome=false;

var fileUploadTypeList = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=CPN_YEA_FILE_UPLOAD_TYPE&searchWorkYy="+$("#searchWorkYy", parent.document).val(), "queryId=getYeaSystemStdData",false).codeList[0];

$(function() {    

	// ----------------------------------------------------
	// 20240105 브라우저 버전에 따라 SignPad 사용 제어 Start
    var _ua = navigator.userAgent;
    var srcSignPad = "../common/signPadPopup.jsp";
	var isIE = 'N';
	
	var trident = _ua.match(/Trident\/(\d.\d)/i);
	if( trident != null )
	{
		if( trident[1] == "7.0" || trident[1] == "6.0" || trident[1] == "5.0" || trident[1] == "4.0" ) //IE 10,9,8 
		{
			isIE = 'Y';
			srcSignPad = ""; //사인패드 지원 불가
		}
	}
	
	if( navigator.appName == 'Microsoft Internet Explorer' ) //IE 7... 
	{ 
		isIE = 'Y';
		srcSignPad = ""; //사인패드 지원 불가
	}
	if(isIE == 'Y')
	{
		//IE_서명패드 시트 생성
	    createSignSheet_IE();	
	}
	
	if ("" != srcSignPad) {
		$("#finalChk_IE").css("display", "none");
		$('#ifrmSignPad').attr('src', srcSignPad);
	}
	// 20240105 브라우저 버전에 따라 SignPad 사용 제어 End
	// ----------------------------------------------------
    
	
    //엑셀,파일다운 시 화면명 저장(교보증권) - 2021.10.26
    $("#menuNm").val($(document).find("title").text()); //엑셀,CURD
    /*필수 기본 세팅*/
    var ssnEnterCd = $("#ssnEnterCd").val( $("#ssnEnterCd", parent.document).val() ) ;
    var ssnSabun = $("#ssnSabun").val( $("#ssnSabun", parent.document).val() ) ;
    var searchWorkYy = $("#searchWorkYy").val( $("#searchWorkYy", parent.document).val() ) ;
    var searchAdjustType = $("#searchAdjustType").val( $("#searchAdjustType", parent.document).val()) ;
    var searchSabun = $("#searchSabun").val( $("#searchSabun", parent.document).val()) ;
    var searchPayActionCd = $("#searchPayActionCd").val( $("#searchPayActionCd", parent.document).val()) ;

    if(fileUploadTypeList != null){
		$("#fileUploadType").val(fileUploadTypeList.code_nm);
	} else {
		$("#fileUploadType").val('0');
	}
    
  	//소득공제서 전자서명 존재여부
    getIncomeElcSign();
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
	    getIncomeElcSign();
    }else{
		$("#divSignPad").hide();
		$("#second").hide();
		$("#reportPage_ifrmsrc").width('100%');
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
		var rdParam = "[<%=session.getAttribute("ssnEnterCd")%>] ["+$("#searchWorkYy").val()+"] ["+$('#searchAdjustType', parent.document).val()+"]"+
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
	var imgPath = "<%=rdSignImgUrl%>";

	//소득공제서
	if(report_type == "INCOME") {
		/* 소득공제서 param */
		var rdParam = "[<%=session.getAttribute("ssnEnterCd")%>] ["+$("#searchWorkYy").val()+"] ["+$('#searchAdjustType', parent.document).val()+"]" +
	    "['"+$("#searchSabun").val()+"'] ["+baseDate+"] " + "[4] ["+$("#searchSabun").val()+"] [1] ["+baseDate+"] ["+imgPath+"]";
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
		var rdParam = "[<%=session.getAttribute("ssnEnterCd")%>] ["+$("#searchWorkYy").val()+"] ["+$('#searchAdjustType', parent.document).val()+"]" +
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

	<%-- 20231219 MRD 파라미터 암호화 페이지 INCLUDE --%>
	<%@ include file="../common/rdPopupEnc.jsp"%>
	
	<%-- ------------------------------------------------------------------------------- 
	20240117 START
	[ 급여관리 > 연말정산_2023 > 소득공제자료관리 > 자료등록 > (탭) 출력 ]
	  최초에 메뉴 클릭 당시에만 securityMgr2.jsp에서 securityKey가 발급되어서
	  동일 화면에서 "소득공제서", "신용카드등", "기부금명세서", "의료비명세서" 버튼을 시간차를 두고 클릭하면
	  [ 시스템사용기준관리 ]에서 보안을 체크하는 사이트는 SecurityKey 만료로 자료가 조회되지 않음.
	 => 버튼 클릭 때마다 재처리토록 수정 
	------------------------------------------------------------------------------- --%>
	var SetSecParam = '';
	$.ajax({ 
			url 		: 'yeaDataPrtViewGetSecKey.jsp', 
			type 		: 'post', 
			dataType 	: 'json', 
			async 		: true, 
			data 		: SetSecParam, 		
			success : function(data) { 
				if(data != null) { 		
					$('#SecurityKey').val(data.securityKey) ; //hidden필드의 대소문자와 securityMgr2.jsp에서 발급받은 변수의 대소문자가 상이함에 주의
					submitCall($("#mainForm"),"reportPage_ifrmsrc","post","../common/rdPopupIframe.jsp");
		    	} 
			}, 		
			error : function(jqXHR, ajaxSettings, thrownError) { 
					//alert('SecurityKey를 갱신하지 못하였습니다.');
					submitCall($("#mainForm"),"reportPage_ifrmsrc","post","../common/rdPopupIframe.jsp");
			} 
		});
	<%-- -------------------------------------------------------------------------------
	20240118 SecurityKey 갱신을 위해 ajax 결과처리 부분에서 동작토록 수정
	//rd iframe 호출
	/* submitCall($("#mainForm"),"reportPage_ifrmsrc","post","/yjungsan/y_2018/jsp_jungsan/common/rdPopupIframe.jsp"); */
	submitCall($("#mainForm"),"reportPage_ifrmsrc","post","../common/rdPopupIframe.jsp");
	20240117 END 
	------------------------------------------------------------------------------- --%>
	
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

    	  	//소득공제서 전자서명 존재여부
    	    getIncomeElcSign();
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

//소득공제서 전자서명 존재여부(2022.12.28)
function getIncomeElcSign(){
	//전자서영 사용여부 조회
	var param = "searchWorkYy="+$("#searchWorkYy").val();
    var result = ajaxCall("<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=selectSignEnableYn",param,false);
    
    if(result.Data.sign_yn != "Y") {
		$("#divSignPad").hide();
		$("#second").hide();
		$("#reportPage_ifrmsrc").width('100%');
		
    }else{
    	
    	var signParam = "searchWorkYy="+$("#searchWorkYy").val();
			signParam += "&searchAdjustType="+$("#searchAdjustType").val();
			signParam += "&searchSabun="+$("#searchSabun").val();

		//전자서명 존재여부 조회
		var signData1 = ajaxCall("<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=selectIncomeElcSignCnt",signParam ,false);
		
		if(signData1 != null && signData1.Result.Code != "-1"){
			if(signData1.Data.cnt > 0){
				$("#divSignPad").hide();
				$("#second").hide();
			}else{
				$("#divSignPad").show();
				$("#second").show();
			}
		}
		/*	close_0	본인마감전. close_1 대상자아님. close_2 본인마감. close_3 담당자마감. close_4 최종마감	*/
		var empStatus = $("#tdStatusView>font:first", parent.document).attr("class");

		if(empStatus=="close_2" || empStatus=="close_3" || empStatus=="close_4"){
			$("#divSignPad").hide();
			$("#reportPage_ifrmsrc").width('100%');
		}
    }
 	
    //제출여부값 세팅
    getIncomeElcSignMgr();
}

//사인패드 서명 후 리턴 
function returnSignPad(rs){
	getIncomeElcSign();
	openPrint('INCOME');
}

//추가 서류 제출 여부 조회
function getIncomeElcSignMgr(){
	
    signSheet.DoSearch( "<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=selectIncomeElcSignMgr", $("#mainForm").serialize() );
    
   	if(signSheet.GetCellValue(0, "do_submit_yn") != ""){
   		if(signSheet.GetCellValue(0, "do_submit_yn") == "Y"){
   			$("#doSubmitYn1").prop("checked",true);
   		}else if(signSheet.GetCellValue(0, "do_submit_yn") == "N"){
   			$("#doSubmitYn2").prop("checked",true);
   		}
   	}
   	if(signSheet.GetCellValue(0, "income_submit_yn") != ""){
   		if(signSheet.GetCellValue(0, "income_submit_yn") == "Y"){
   			$("#incomeSubmitYn1").prop("checked",true);
   		}else if(signSheet.GetCellValue(0, "income_submit_yn") == "N"){
   			$("#incomeSubmitYn2").prop("checked",true);
   		}
   	}
   	if(signSheet.GetCellValue(0, "for_submit_yn") != ""){
   		if(signSheet.GetCellValue(0, "for_submit_yn") == "Y"){
   			$("#forSubmitYn1").prop("checked",true);
   		}else if(signSheet.GetCellValue(0, "for_submit_yn") == "N"){
   			$("#forSubmitYn2").prop("checked",true);
   		}
   	}
   	if(signSheet.GetCellValue(0, "pen_submit_yn") != ""){
   		if(signSheet.GetCellValue(0, "pen_submit_yn") == "Y"){
   			$("#penSubmitYn1").prop("checked",true);
   		}else if(signSheet.GetCellValue(0, "pen_submit_yn") == "N"){
   			$("#penSubmitYn2").prop("checked",true);
   		}
   	}
   	if(signSheet.GetCellValue(0, "rent_submit_yn") != ""){
   		if(signSheet.GetCellValue(0, "rent_submit_yn") == "Y"){
   			$("#rentSubmitYn1").prop("checked",true);
   		}else if(signSheet.GetCellValue(0, "rent_submit_yn") == "N"){
   			$("#rentSubmitYn2").prop("checked",true);
   		}
   	}
   	if(signSheet.GetCellValue(0, "med_submit_yn") != ""){
   		if(signSheet.GetCellValue(0, "med_submit_yn") == "Y"){
   			$("#medSubmitYn1").prop("checked",true);
   		}else if(signSheet.GetCellValue(0, "med_submit_yn") == "N"){
   			$("#medSubmitYn2").prop("checked",true);
   		}
   	}
}


//(IE)사인패드대체 서명정보 쉬트
function createSignSheet_IE() {
	var initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
	initdata.Cols = [
		{Header:"No", Type:"<%=sNoTy%>",	Hidden:<%=sNoHdn%>,	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:1,	SaveName:"sNo" },
		{Header:"삭제", Type:"<%=sDelTy%>",	Hidden:<%=sDelHdn%>,Width:"<%=sDelWdt%>",	Align:"Center",	ColMerge:1,	SaveName:"sDelete",	Sort:0 },
		{Header:"상태", Type:"<%=sSttTy%>",	Hidden:<%=sSttHdn%>,Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:1,	SaveName:"sStatus",	Sort:0 },
		{Header:"년도", Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"work_yy",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4 },
		{Header:"정산구분", Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"adjust_type",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"사번", Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabun",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"종전원천징수제출여부", Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"income_submit_yn",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"외국인단일세율적용제출여부", Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"for_submit_yn",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
		{Header:"연금저축제출여부", Type:"Text",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"pen_submit_yn",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
		{Header:"월세액제출여부", Type:"Text",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"rent_submit_yn",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
		{Header:"의료비제출여부", Type:"Text",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"med_submit_yn",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
		{Header:"기부금제출여부", Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"do_submit_yn",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"소득공제서본인확정일시", Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"ie_confirm_date",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 }
	]; 
	IBS_InitSheet(signSheet, initdata);signSheet.SetEditable(false);signSheet.SetVisible(true);signSheet.SetCountPosition(4);
}

function finalSubmitChk_IE() {
	if(confirm("본인은 소득공제 자료등록 확인을 완료하였음을 확정합니다.\n제출 이후 수정 할 수 없습니다. 제출하시겠습니까?")){
		
		var forSubmit 	 ="";
		var incomeSubmit ="";
		var penSubmit	 ="";
		var rentSubmit 	 ="";
		var medSubmit 	 ="";
		var doSubmit 	 ="";
		var nullChk = 0;

		if($("#forSubmitYn1").prop("checked")) {
			forSubmit = "Y"; 
		}else if($("#forSubmitYn2").prop("checked")){
			forSubmit = "N";
		}else{
			nullChk++;
		}
		if($("#incomeSubmitYn1").prop("checked")) {
			incomeSubmit = "Y"; 
		}else if($("#incomeSubmitYn2").prop("checked")){
			incomeSubmit = "N";
		}else{
			nullChk++;
		}
		if($("#penSubmitYn1").prop("checked")) {
			penSubmit = "Y"; 
		}else if($("#penSubmitYn2").prop("checked")){
			penSubmit = "N";
		}else{
			nullChk++;
		}
		if($("#rentSubmitYn1").prop("checked")) {
			rentSubmit = "Y"; 
		}else if($("#rentSubmitYn2").prop("checked")){
			rentSubmit = "N";
		}else{
			nullChk++;
		}
		if($("#medSubmitYn1").prop("checked")) {
			medSubmit = "Y"; 
		}else if($("#medSubmitYn2").prop("checked")){
			medSubmit = "N";
		}else{
			nullChk++;
		}
		if($("#doSubmitYn1").prop("checked")) {
			doSubmit = "Y"; 
		}else if($("#doSubmitYn2").prop("checked")){
			doSubmit = "N";
		}else{
			nullChk++;
		}

		if(nullChk > 0){
			alert("추가 제출 서류에 대한 제출 여부를 선택 후 \n버튼을 눌러주세요.");
			return;
		}
		
		if(signSheet.LastRow() < 1)
		{
			var newRow = signSheet.DataInsert(0) ;			
			signSheet.SetCellValue( newRow, "work_yy", $("#searchWorkYy").val() );
			signSheet.SetCellValue( newRow, "adjust_type", $("#searchAdjustType").val() );
			signSheet.SetCellValue( newRow, "sabun", $("#searchSabun").val() );
			signSheet.SetCellValue( newRow, "income_submit_yn", incomeSubmit);
			signSheet.SetCellValue( newRow, "for_submit_yn", forSubmit);
			signSheet.SetCellValue( newRow, "pen_submit_yn", penSubmit);
			signSheet.SetCellValue( newRow, "rent_submit_yn", rentSubmit);
			signSheet.SetCellValue( newRow, "med_submit_yn", medSubmit);
			signSheet.SetCellValue( newRow, "do_submit_yn", doSubmit);
			signSheet.SetCellValue( newRow, "sStatus", "U");
		}
		//2024.10.31
		//DoSave의 세번째 파라미터를 공백으로 넘길 경우 sheet에 있는 데이터가 안넘어감으로 기본값인 -1로 세팅해줌
		//signSheet.DoSave( "<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=saveIncomeElcSign_IE",$("#signSheet").serialize(),"","0");
		signSheet.DoSave( "<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=saveIncomeElcSign_IE",$("#signSheet").serialize(),-1,"0");
	}
	
}
//저장 후 메시지
function signSheet_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try {
		alertMessage(Code, Msg, StCode, StMsg);
		
		if(Code == 1) {
			$("#divSignPad").hide();
			$("#second").hide();
			openPrint('INCOME');
		}
	} catch (ex) {
		alert("OnSaveEnd Event Error " + ex);
	}
}
</script>
<style type="text/css">

a.button_prt {border:none;display: inline-block;line-height: 20px;margin-right: .1em;cursor: pointer;vertical-align: middle;text-align: center;overflow: visible; /* removes extra width in IE */background: #298d99;font-family:NanumGothic,Dotum,돋움,arial;font-weight: bold;padding: 3px 11px 4px 10px;color:#fff;font-size:14px;word-break:keep-all;height: 20px;}
a:hover.button_prt {color:#fff !important}

a.cute_prt {display: inline-block;line-height: normal;margin-right: .1em;cursor: pointer;vertical-align: middle;text-align: center;overflow: visible; /* removes extra width in IE */background: #3ab7c6;border:1px solid #3ab7c6;font-weight: normal;padding: 4px 5px 3px 6px;padding:5px 5px 4px 6px\9;color:#fff;font-size:11px;word-break:keep-all}
a:hover.cute_prt {color:#fff}


/* .flex-container {display: flex;height:100%;justify-content:space-around;}
.flex-container > div {background-color: #f1f1f1; position: inherit; margin: 10px; padding: 1px; width: 100%;}
.first {width: 70%; margin-left: 70%; }
.second {width: 30%; } */
.signPadTable{ width: 100%; border-top: 2px solid #cacdcf; border-bottom: 2px solid #cacdcf; box-sizing: border-box; text-indent: initial; border-spacing: 2px;
    border-color: grey; margin: 0; padding: 0; font-size: 12px; color: #666; border-collapse: collapse; }
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
				
		<input type="hidden" id="RdThem">
		<input type="hidden" id="sKey">
		<input type="hidden" id="gKey">
		<input type="hidden" id="sType">
		<input type="hidden" id="qId">
		
		<input type="hidden" id="fileUploadType" name="fileUploadType" />
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
	<table class="default" style="height: 90%;">
		<tr>
			<td id="first" style="width: 70%;">
			  	<iframe name="reportPage_ifrmsrc" id="reportPage_ifrmsrc" style="width: 100%; height: 90%;"></iframe>
			</td>
			<td id="second" style="width: 30%;">
			  	<div id="divSignPad">
			  		<table class="default">
						<tr> 
		                    <td style="width: 320px; padding-left: 20px">
		 						<span>
		 							<label for="forSubmitChk"><strong>1. 외국인근로자 단일세율적용신청서 제출여부</strong></label>
		 						</span>
		 					</td>
		 					<td>
		 						<input type="radio" class="radio" name="forSubmitYn" id="forSubmitYn1" value = "Y" > <label for="forSubmitYn1">Yes</label>&nbsp;&nbsp;
		 						<input type="radio" class="radio" name="forSubmitYn" id="forSubmitYn2" value = "N" > <label for="forSubmitYn2">No</label>
		 					</td>
	                 	</tr>
						<tr>
		                    <td style="width: 320px; padding-left: 20px">
								<span>
									<label for="incomeSubmitChk"><strong>2. 종(전)근무지 근로소득 원천징수영수증 제출여부</strong></label>
								</span>
							</td>
							<td>
								<input type="radio" class="radio" name="incomeSubmitYn" id="incomeSubmitYn1" value = "Y" > <label for="incomeSubmitYn1">Yes</label>&nbsp;&nbsp;
								<input type="radio" class="radio" name="incomeSubmitYn" id="incomeSubmitYn2" value = "N" > <label for="incomeSubmitYn2">No</label>
							</td>
		                </tr>
						<tr>
		                    <td style="width: 320px; padding-left: 20px">
								<span>
									<label for="penSubmit"><strong>3. 연금, 저축 등 소득, 세액 공제명세서 제출여부</strong></label>
								</span>
							</td>
							<td>
								<input type="radio" class="radio" name="penSubmitYn" id="penSubmitYn1" value = "Y" > <label for="penSubmitYn1">Yes</label>&nbsp;&nbsp;
								<input type="radio" class="radio" name="penSubmitYn" id="penSubmitYn2" value = "N" > <label for="penSubmitYn2">No</label>
							</td>
		                </tr>
						<tr>
		                    <td style="width: 320px; padding-left: 20px">
								<span>
									<label for="rentSubmit"><strong>4. 월세액 거주자 간 주택임차차입금 원리금상환액<br>&nbsp;&nbsp;&nbsp;소득 세액공제 명세서 제출여부</strong></label>
								</span>
							</td>
							<td>
								<input type="radio" class="radio" name="rentSubmitYn" id="rentSubmitYn1" value = "Y" > <label for="rentSubmitYn1">Yes</label>&nbsp;&nbsp;
								<input type="radio" class="radio" name="rentSubmitYn" id="rentSubmitYn2" value = "N" > <label for="rentSubmitYn2">No</label>
							</td>
		                </tr>
						<tr>
		                    <td style="width: 320px; padding-left: 20px">
								<span>
									<label for="medSubmitChk"><strong>5. 의료비지급명세서(그 밖의 추가 제출 서류) 제출여부 </strong></label>
								</span>
							</td>
							<td>
								<input type="radio" class="radio" name="medSubmitYn" id="medSubmitYn1" value = "Y" > <label for="medSubmitYn1">Yes</label>&nbsp;&nbsp;
								<input type="radio" class="radio" name="medSubmitYn" id="medSubmitYn2" value = "N" > <label for="medSubmitYn2">No</label>
							</td>
		                </tr>
						<tr>
		                    <td style="width: 320px; padding-left: 20px">
								<span>
									<label for="doSubmitChk"><strong>6. 기부금명세서(그 밖의 추가 제출 서류) 제출 여부 </strong></label>
								</span>
							</td>
							<td>
								<input type="radio" class="radio" name="doSubmitYn" id="doSubmitYn1" value = "Y" > <label for="doSubmitYn1">Yes</label>&nbsp;&nbsp;
								<input type="radio" class="radio" name="doSubmitYn" id="doSubmitYn2" value = "N" > <label for="doSubmitYn2">No</label>
							</td>
		                </tr>
		                <tr id="finalChk_IE">
		                	<td colspan="2" align="center">
								<a href="javascript:finalSubmitChk_IE();" id="finalChkBtn_IE" class="basic btn-green">소득공제서 최종확인 완료</a>
		                	</td>
		                </tr>
		                <tr>
		                	<td colspan="2">
								<iframe id="ifrmSignPad" name="ifrmSignPad" src="" style="border:0px; width:450px; height:320px;"></iframe>
		                	</td>
		                </tr>
			  		</table>
			  	</div>
			</td>
		</tr>
	</table>

	</div>
	<span class="hide">
		<script type="text/javascript">createIBSheet("signSheet", "450px", "320px"); </script>
	</span>
</body>
