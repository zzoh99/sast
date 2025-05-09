<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>원천신고서</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<!--
 * 원천징수이행상황신고서
 * @author JM
-->
<script type="text/javascript">
//iframe
var newIframe;
var oldIframe;
var chrIframe;
var chrIFrameGo;
var iframeIdx;
var tab2FirstClickYn = "Y";

var p = eval("<%=popUpStatus%>");

$(function() {
	var taxDocNo        = "";
	var businessPlaceCd = "";
	var reportYmd       = "";
	var belongYm        = "";
	// 2016-09-19 YHCHOI ADD
	var closeYn         = "";

	var arg = p.window.dialogArguments;
	if( arg != undefined ) {
		taxDocNo 		= arg["tax_doc_no"];
		businessPlaceCd = arg["business_place_cd"];
		reportYmd 		= arg["report_ymd"];
		belongYm 		= arg["belong_ym"];
		// 2016-09-19 YHCHOI ADD
		closeYn 		= arg["close_yn"];

	}else{
		taxDocNo        = p.popDialogArgument("tax_doc_no");
		businessPlaceCd = p.popDialogArgument("business_place_cd");
		reportYmd       = p.popDialogArgument("report_ymd");
		belongYm        = p.popDialogArgument("belong_ym");
		// 2016-09-19 YHCHOI ADD
		closeYn         = p.popDialogArgument("close_yn");
	}

	$("#taxDocNo").val(taxDocNo);
	$("#businessPlaceCd").val(businessPlaceCd);
	$("#reportYmd").val(reportYmd);
	$("#belongYm").val(belongYm);
	// 2016-09-19 YHCHOI ADD
	$("#closeYn").val(closeYn);

	newIframe = $('#tabs-1 iframe');
	iframeIdx = 0;
	newIframe.attr("src","<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrDtl1Tab1.jsp?authPg=<%=authPg%>");
	$( "#tabs" ).tabs({
		beforeActivate: function(event, ui) {
			iframeIdx = ui.newTab.index();
			newIframe = $(ui.newPanel).find('iframe');
			oldIframe = $(ui.oldPanel).find('iframe');
			showIframe();
		}
	});

	// 화면 리사이즈
	$(window).resize(setIframeHeight);
	setIframeHeight();

	$(".close").click(function() {
		p.self.close();
	});

	$("#tab1Title").html("원천징수명세서 및 납부세액");
	$("#tab2Title").html("원천징수이행상황신고서 부표");
	$("#tab3Title").html("원천징수세액환급신청서");
	$("#tab4Title").html("기납부세액");
	$("#tab5Title").html("전월미환급조정");
});

$(function() {
	$("#reportGb").bind("change",function(){
		if($("#reportGb").val() == "1") {
			$("#pAddInfo").show();
		} else {
			$("#pAddInfo").hide();
		}
	});
});

//탭 높이 변경
function setIframeHeight() {
	var iframeTop = $("#tabs ul").height() + 16;
	$(".layout_tabs").each(function() {
		$(this).css("top",iframeTop);
	});
}

function showIframe() {
	if (typeof oldIframe != 'undefined') {
		//oldIframe.attr("src","<%=jspPath%>/common/hidden.jsp");
	}
	if (iframeIdx == 0) {
		// 원천징수명세서 및 납부세액
		//newIframe.attr("src","<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrDtl1Tab1.jsp");
	} else if (iframeIdx == 1) {
		if (tab2FirstClickYn == "Y") {
			tab2FirstClickYn = "N";
			// 원천징수이행상황신고서 부표
			newIframe.attr("src","<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrDtl1Tab2.jsp?authPg=<%=authPg%>");
		}
	} else if (iframeIdx == 2) {
		// 원천징수세액환급신청서
		newIframe.attr("src","<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrDtl1Tab3.jsp?authPg=<%=authPg%>");
	} else if (iframeIdx == 3) {
		// 기납부세액
		newIframe.attr("src","<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrDtl1Tab4.jsp?authPg=<%=authPg%>");
	} else if (iframeIdx == 4) {
		// 전월비환급조정
		newIframe.attr("src","<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrDtl1Tab5.jsp?authPg=<%=authPg%>");
	}
}

// 원천징수명세서 및 납부세액 TAB에 값 셋팅
function setValTab1(mTaxEleCd, colName, val) {
	//Chrome에서 Iframe 오류로 수정(2021-11-03) 
	//iframeTab1.setValTab1(mTaxEleCd, colName, val);
	
	chrIframe   = document.getElementById("iframeTab1");                 // 대상 프레임 가져오기
	chrIFrameGo = chrIframe.contentWindow || chrIframe.contentDocument ; // 브라우저 호환성 검사 참인것을 사용함
	chrIFrameGo.setValTab1(mTaxEleCd, colName, val);	                 // 함수 호출
}

// 전자신고서
function createDeclaration() {
	var w		= 500;
	var h		= 260;
	var url		= "";
	var args	= new Array();

	url = "<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrDeclarationPopup.jsp";

	args["taxDocNo"] = $("#taxDocNo").val();
	args["businessPlaceCd"] = $("#businessPlaceCd").val();

	if(!isPopup()) {return;}
	openPopup(url+"?authPg=<%=authPg%>", args, w, h);
}

// 보고서 출력
function callRd() {
	var w 		= 840;
	var h 		= 635;
	var url 	= "<%=jspPath%>/common/rdPopup.jsp";
	var args 	= new Array();
	// args의 Y/N 구분자는 없으면 N과 같음

	var rdTitle = "";
	var reportFileNm = "";
	var reportGb = $("#reportGb").val();
	var imgPath = "<%=rdStempImgUrl%>";

	switch (reportGb) {
		case "1":
		    var ym = $("#belongYm").val();
	    
		    if(Number(ym) >= 202401){
		    	reportFileNm = "WonchunJingSuLeeHangMaster_2024.mrd";
		    }else if(Number(ym) >= 202104){
		    	reportFileNm = "WonchunJingSuLeeHangMaster_2021.mrd";
		    }else if(Number(ym) >= 202004){
		    	reportFileNm = "WonchunJingSuLeeHangMaster_2020.mrd";
		    }else if(Number(ym) >= 201903){
		    	reportFileNm = "WonchunJingSuLeeHangMaster_2019.mrd";
		    }else if(Number(ym) >= 201601){
		    	reportFileNm = "WonchunJingSuLeeHangMaster_2016.mrd";
		    }else if(Number(ym) >= 201401 && Number(ym) < 201601){
				reportFileNm = "WonchunJingSuLeeHangMaster_2015.mrd";
			}else if (Number(ym) >= 201107 && Number(ym) < 201401) {
	    		reportFileNm = "WonchunJingSuLeeHangMaster_20110701.mrd";
	    	}else{
	    		reportFileNm = "WonchunJingSuLeeHangMaster.mrd";
	    	}

			rdTitle = "원천징수이행상황신고서";
			break;

		case "2":
	    	reportFileNm = "earnedIncomeReceipt.mrd";
			rdTitle = "근로소득 지로영수증";
			break;

		case "3":
	    	reportFileNm = "retireIncomeReceipt.mrd";
			rdTitle = "퇴직소득 지로영수증";
			break;

		case "4":
	    	reportFileNm = "corporationTaxReceipt.mrd";
			rdTitle = "법인세 지로영수증";
			break;

		case "5":
	    	reportFileNm = "etcTaxReceipt.mrd";
			rdTitle = "기타소득 지로영수증";
			break;

		case "6":
	    	reportFileNm = "earnedTaxReceipt.mrd";
			rdTitle = "이자소득 지로영수증";
			break;

		case "7":
	    	reportFileNm = "earnedTaxReceipt2.mrd";
			rdTitle = "배당소득 지로영수증";
			break;

		case "8":
	    	reportFileNm = "busTaxReceipt.mrd";
			rdTitle = "사업소득 지로영수증";
			break;

		default:
	    	reportFileNm = "WonchunJingSuLeeHangMaster.mrd";
			rdTitle = "원천징수이행상황신고서";
	}
	
	// 원천징수이행상황신고서인 경우 세션의 정보가 없으면 입력받은 파라메터로 처리 - 2020.02.13
	var pLoginEmail = "<%=session.getAttribute("ssnMailId")==null?"":session.getAttribute("ssnMailId")%>";
	var pLoginTel = "<%=session.getAttribute("ssnOfficeTel")==null?"":session.getAttribute("ssnOfficeTel")%>";
	
	if(reportGb == "1") {
		if(pLoginEmail == "") {
			pLoginEmail = $("#reportEmail").val();
		}
		if(pLoginTel == "") {
			pLoginTel = $("#reportTel").val();
		}
	}

	args["rdTitle"] = rdTitle;
	args["rdMrd"] = "cpn/origintax/" + reportFileNm;
	//args["rdMrd"] = "<%=cpnYearEndPath%>/" + reportFileNm;
	//args["rdParam"] = "['${ssnEnterCd}'] ['"+$("#taxDocNo").val()+"'] ['"+$("#businessPlaceCd").val()+"'] ['"+imgPath+"'] ['"+$("#reportYmd").val()+"'] ['${ssnMailId}'] ['${ssnOfficeTel}']";
	//args["rdParam"] = "P_ENTER_CD[<%=removeXSS(session.getAttribute("ssnEnterCd"), '1')%>] P_TAX_DOC_NO["+$("#taxDocNo").val()+"] P_BIZ_CD["+$("#businessPlaceCd").val()+"] P_IMG_URL["+imgPath+"] P_REPORT_YMD["+$("#reportYmd").val()+"] P_LOGIN_EMAIL[<%=removeXSS(session.getAttribute("ssnMailId"), '1')%>] P_LOGIN_TEL[<%=removeXSS(session.getAttribute("ssnOfficeTel"), '1')%>]";
	//args["rdParam"] = "[<%=removeXSS(session.getAttribute("ssnEnterCd"), '1')%>] ["+$("#taxDocNo").val()+"] ["+$("#businessPlaceCd").val()+"] ["+imgPath+"] ["+$("#reportYmd").val()+"] [<%=removeXSS(session.getAttribute("ssnMailId"), '1')%>] [<%=removeXSS(session.getAttribute("ssnOfficeTel"), '1')%>]";
	args["rdParam"] = "P_ENTER_CD[<%=removeXSS(session.getAttribute("ssnEnterCd"), '1')%>] P_TAX_DOC_NO["+$("#taxDocNo").val()+"] P_BIZ_CD["+$("#businessPlaceCd").val()+"] P_IMG_URL["+imgPath+"] P_REPORT_YMD["+$("#reportYmd").val()+"] P_LOGIN_EMAIL["+pLoginEmail+"] P_LOGIN_TEL["+pLoginTel+"]";

	//args["rdParamGubun"]= "rp";	//파라매터구분(rp/rv)
	args["rdParamGubun"]= "rv";	//파라매터구분(rp/rv)
	args["rdToolBarYn"]	= "Y";	//툴바여부
	args["rdZoomRatio"]	= "100";//확대축소비율
	args["rdSaveYn"]	= "Y" ;	//기능컨트롤_저장
	args["rdPrintYn"]	= "Y" ;	//기능컨트롤_인쇄
	args["rdExcelYn"]	= "Y" ;	//기능컨트롤_엑셀
	args["rdWordYn"]	= "Y" ;	//기능컨트롤_워드
	args["rdPptYn"]		= "Y" ;	//기능컨트롤_파워포인트
	args["rdHwpYn"]		= "Y" ;	//기능컨트롤_한글
	args["rdPdfYn"]		= "Y" ;	//기능컨트롤_PDF

	if(!isPopup()) {return;}
	openPopup(url,args,w,h);
}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="popup_title">
		<ul>
			<li>원천신고서</li>
			<li class="close"></li>
		</ul>
	</div>
	<input type="hidden" id="taxDocNo" name="taxDocNo" value="" />
	<input type="hidden" id="businessPlaceCd" name="businessPlaceCd" class="text" value="" />
	<input type="hidden" id="reportYmd" name="reportYmd" value="" />
	<input type="hidden" id="belongYm" name="belongYm" value="" />
	<input type="hidden" id="closeYn" name="closeYn" value="" />
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="sheet_title outer">
				<ul>
					<li id="txt" class="txt"></li>
					<li class="btn">
						<span id="pAddInfo">
							<span>전화번호 : </span>
							<input type="text" id="reportTel" name="reportTel" class="text" value="<%=session.getAttribute("ssnOfficeTel")==null?"":session.getAttribute("ssnOfficeTel")%>" />&nbsp;
							<span>전자우편주소 : </span>
							<input type="text" id="reportEmail" name="reportEmail" class="text" value="<%=session.getAttribute("ssnMailId")==null?"":session.getAttribute("ssnMailId")%>" />
							<span>&nbsp;&nbsp;&nbsp;&nbsp;</span>
						</span>
						<select id="reportGb" name="reportGb">
							<option value="1">이행신고서</option>
							<option value="2">근로소득지로영수증</option>
							<option value="3">퇴직소득지로영수증</option>
							<option value="4">법인세지로영수증</option>
							<option value="5">기타소득영수증</option>
							<option value="6">이자소득영수증</option>
							<option value="7">배당소득영수증</option>
							<option value="8">사업소득영수증</option>
						</select>
						<a href="javascript:callRd()"				class="basic authA">출력</a>
						<a href="javascript:createDeclaration()"	class="basic authA">전자신고서</a>
					</li>
				</ul>
				</div>
			</td>
		</tr>
	</table>
	<div id="tabs" style="position:absolute;width:100%;top:80px;bottom:0">
		<ul>
			<li><a href="#tabs-1"><span id="tab1Title"></span></a></li>
			<li><a href="#tabs-2"><span id="tab2Title"></span></a></li>
			<li><a href="#tabs-3"><span id="tab3Title"></span></a></li>
			<li><a href="#tabs-4"><span id="tab4Title"></span></a></li>
			<li><a href="#tabs-5"><span id="tab5Title"></span></a></li>
		</ul>
		<div id="tabs-1">
			<div class="layout_tabs"><iframe id="iframeTab1" src="<%=jspPath%>/common/hidden.jsp" frameborder="0" class="tab_iframes"></iframe></div>
		</div>
		<div id="tabs-2">
			<div class="layout_tabs"><iframe src="<%=jspPath%>/common/hidden.jsp" frameborder="0" class="tab_iframes"></iframe></div>
		</div>
		<div id="tabs-3">
			<div class="layout_tabs"><iframe src="<%=jspPath%>/common/hidden.jsp" frameborder="0" class="tab_iframes"></iframe></div>
		</div>
		<div id="tabs-4">
			<div class="layout_tabs"><iframe src="<%=jspPath%>/common/hidden.jsp" frameborder="0" class="tab_iframes"></iframe></div>
		</div>		
		<div id="tabs-5">
			<div class="layout_tabs"><iframe src="<%=jspPath%>/common/hidden.jsp" frameborder="0" class="tab_iframes"></iframe></div>
		</div>		
	</div>
</div>
</body>
</html>