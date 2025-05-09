<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
var reportFlag = false ;
	$(function() {
		var businessPalceCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getBusinessPlaceCdList",false).codeList, "전체");	//사업장
		$("#searchBusinessPlaceCd").html(businessPalceCd[2]);

		$("#searchOrgNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
		});

		getCpnLatestPaymentInfo();
		/*기존 로직 그대로 적용 : 레포트 구분을 위한 로직이 된다.
		 */
	    //1.참고사항의 헤더수 출력
		var hdrCnt1 = 0;
	    var hdrCnt2 = 0;
	    var hdrCnt3 = 0;
	    var hdrMaxCnt1 = 8;
	    var hdrMaxCnt2 = 21;
	    var hdrMaxCnt3 = 16;
	    var cnt1 = ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&searchPayActionCd="+$("#searchPayActionCd").val(),"queryId=getSheetHeaderCnt1",false);
		//2.지급내역의 헤더수 출력
		var cnt2 = ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&searchPayActionCd="+$("#searchPayActionCd").val()+"&searchElementType='A'","queryId=getSheetHeaderCnt2",false);
		//3.공제내역의 헤더수 출력
		var cnt3 = ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&searchPayActionCd="+$("#searchPayActionCd").val()+"&searchElementType='D'","queryId=getSheetHeaderCnt2",false);

		var hdrCnt1 = cnt1.codeList[0].cnt ;
		var hdrCnt2 = cnt2.codeList[0].cnt ;
		var hdrCnt3 = cnt3.codeList[0].cnt ;

	    if(hdrCnt1 > hdrMaxCnt1 || hdrCnt2 > hdrMaxCnt2 || hdrCnt3 > hdrMaxCnt3){
	    	reportFlag = true;
	    }
	    
	    setIframeHeight();
	    $(window).resize(function() {
	    	setIframeHeight();
	    });
	});

	//Sheet1 Action
	function doAction(sAction) {
		switch (sAction) {
			case "Search":
				/*
				if( $("#searchDbUser").val() == "" ) {
					alert("OWNER 를 입력하세요.");
					$("#searchDbUser").focus();
					return;
				}*/
				setReportParams("N") ;
				//레포트 공통 IFrame호출
				//레포트 공통 팝업창에서 쓰는 IFRAME으로, 같이 공통으로 사용한다.
				submitCall($("#paramFrm"),"reportPage_ifrmsrc","post","/RdIframe.do");
				break
			case "SignForce" :
				setReportParams("Y") ;
				//레포트 공통 IFrame호출
				//레포트 공통 팝업창에서 쓰는 IFRAME으로, 같이 공통으로 사용한다.
				submitCall($("#paramFrm"),"reportPage_ifrmsrc","post","/RdIframe.do");
				break;
		}
	}

	/**
	 * 출력 iframe setting method
	 * 레포트 공통 IFRAME에 맞춘 개발 코드 템플릿
	 * by JSG
	 */
	function setReportParams(signForceYn){
		$("#Title").val("급상여명세서") ;//rd Popup제목

// 		if(!reportFlag) {
// 			$("#Mrd").val("cpn/payReport/PaySheet_R2.mrd") ;
// 		}
// 		else {
// 			$("#Mrd").val("cpn/payReport/PaySheet_R4.mrd") ;
// 		}
		
		var searchPrintUnit = $("#searchPrintUnit").val();
		
		// 전자서명 ================================== //
		var rdSignUse = "Y";
		var signData = ajaxCall("${ctx}/GetDataMap.do?cmd=PayAppMgrSignPhotoOut", "enterCd=${ssnEnterCd}&payActionCd=" + $("#searchPayActionCd").val(), false);
		//console.log('signData', signData);
		if( signData != null && signData != undefined && signData.DATA != null && signData.DATA != undefined ) {
			rdSignUse = "N";
		}
		
		// 출력단위가 개인별일때 재서명이 체크된 경우 전자서명 기능 활성화함.
		if( searchPrintUnit == "1" && signForceYn == "Y" ) {
			rdSignUse = "Y";
		}
		
		$("#rdSignUse").val(rdSignUse);
		if( rdSignUse == "Y" ) {
			$("#rdSignHandler").val("PayAppMgr");
			$("#rdSignParam").val("[${ssnEnterCd}]["+$("#searchPayActionCd").val()+"]");
		}
		// End 전자서명 ================================== //
		
		//출력단위에 따른 MRD호출 페이지 변경
		var rdParams  = "['${ssnEnterCd}']";
			rdParams += " ['" + $("#searchPayActionCd").val() + "']";
			
		if(searchPrintUnit == "4") {
			$("#Mrd").val("cpn/payReport/PaySheet_R3.mrd") ;
			searchPrintUnit = "2";
			var searchBusinessPlaceCd = $("#searchBusinessPlaceCd").val();
			if(searchBusinessPlaceCd == "") {
				searchBusinessPlaceCd = "%";
			}
			
			var searchOrgCd =  $("#searchOrgCd").val();
			if(searchOrgCd == "") {
				searchOrgCd  = "0";
			}
			
			rdParams += " ['"+ searchBusinessPlaceCd +"']";
			rdParams += " ['"+searchOrgCd+"']";
			rdParams += " ['%']";
			rdParams += " ['ORG']";
			rdParams += " ['3']";
			rdParams += " ['N']";
		} else {
			$("#Mrd").val("cpn/payReport/PaySheet_R2.mrd") ;
			rdParams += " ['"+$("#searchBusinessPlaceCd").val()+"']";
			rdParams += " ['"+$("#searchOrgCd").val()+"']";
			rdParams += " ['"+$("#searchPrintUnit").val()+"']";
			rdParams += " ['CC']";
			rdParams += " ['1']";
			if(searchPrintUnit == "1") {
				rdParams += " ['Y']";
			} else {
				rdParams += " ['N']";
			}
		}
		rdParams += " [${baseURL}]";
		$("#Param").val(rdParams) ;//rd파라매터
		
		//$("#Param").val("['${ssnEnterCd}'] ['"+$("#searchPayActionCd").val()+"'] ['"+$("#searchBusinessPlaceCd").val()+"'] ['"+$("#searchOrgCd").val()+"'] ['"+searchPrintUnit+"'] ['CC'] ['1']") ;//rd파라매터
		$("#ParamGubun").val("rp") ;//파라매터구분(rp/rv)
		$("#ToolbarYn").val("Y") ;//툴바여부
		$("#ZoomRatio").val("100") ;//확대축소비율

		$("#SaveYn").val("Y") ;//기능컨트롤_저장
		$("#PrintYn").val("Y") ;//기능컨트롤_인쇄
		$("#ExcelYn").val("Y") ;//기능컨트롤_엑셀
		$("#WordYn").val("Y") ;//기능컨트롤_워드
		$("#PptYn").val("Y") ;//기능컨트롤_파워포인트
		$("#HwpYn").val("Y") ;//기능컨트롤_한글
		$("#PdfYn").val("Y") ;//기능컨트롤_PDF
	}

	 // 급여일자 검색 팝입
    function payActionSearchPopup() {
    	try{
    		if(!isPopup()) {return;}
    		gPRow = "";
    		pGubun = "payDayPopup";

    		var w		= 940;
    		var h		= 620;
    		var url		= "/PayDayPopup.do?cmd=payDayPopup";
    		var args	= "";

    		var result = openPopup(url+"&authPg=${authPg}", args, w, h);
			/*
    		if (result) {
    			var payActionCd	= result["payActionCd"];
    			var payActionNm	= result["payActionNm"];

    			$("#searchPayActionCd").val(payActionCd);
    			$("#searchPayActionNm").val(payActionNm);
    		}
			*/
    	}catch(ex){alert("Open Popup Event Error : " + ex);}
    }

    function getReturnValue(returnValue) {
    	var rv = $.parseJSON('{' + returnValue+ '}');

        if(pGubun == "payDayPopup"){
    		$("#searchPayActionCd").val(rv["payActionCd"]);
    		$("#searchPayActionNm").val(rv["payActionNm"]);
        }else if(pGubun == "orgBasicPopup"){
            $("#searchOrgCd").val(rv["orgCd"]);
            $("#searchOrgNm").val(rv["orgNm"]);
        }
    }

	// 최근급여일자 조회
	function getCpnLatestPaymentInfo() {
		var procNm = "최근급여일자";
		// 급여구분(C00001-00001.급여)
		var paymentInfo = ajaxCall("${ctx}/CpnQuery.do?cmd=getCpnQueryList", "queryId=getCpnLatestPaymentInfoMap&procNm="+"&runType=00001", false);

		if (paymentInfo.DATA != null && paymentInfo.DATA != "" && typeof paymentInfo.DATA[0] != "undefined") {
			$("#searchPayActionCd").val(paymentInfo.DATA[0].payActionCd);
			$("#searchPayActionNm").val(paymentInfo.DATA[0].payActionNm);

			if ($("#payActionCd").val() != null && $("#payActionCd").val() != "") {
				//	doAction("Search");
			}
		} else if (paymentInfo.Message != null && paymentInfo.Message != "") {
			alert(paymentInfo.Message);
		}
	}

	//  소속 팝업
    function orgSearchPopup(){
        try{

        	if(!isPopup()) {return;}
        	gPRow = "";
        	pGubun = "orgBasicPopup";

        	var args 	= new Array();

    		args["runType"] = "00001,00002,00003,R0001,R0002,R0003";
         	var rv = openPopup("/Popup.do?cmd=orgBasicPopup", args, "700","520");
         	/*
            if(rv!=null){

             $("#searchOrgCd").val(rv["orgCd"]);
             $("#searchOrgNm").val(rv["orgNm"]);

            }
         	*/
        }catch(ex){alert("Open Popup Event Error : " + ex);}
    }
	
	// iframe 높이 조절.
	function setIframeHeight() {
    	var bodyHeight = $("body").outerHeight(true);
    	var sheetSearchHeight = $(".sheet_search").outerHeight(true);
    	var iframeHeight = bodyHeight - sheetSearchHeight;
    	
    	$("#reportPage_ifrmsrc").css("height", iframeHeight);
	}
	
	// 전자서명 제출 완료시 실행
	function returnResultForSign(rv) {
		
		// 전자서명 제출이 정상 처리된 경우 진행
		if( rv["flag"] == "rdSignUse" ) {
			var params  = "payActionCd=" + $("#searchPayActionCd").val();
			var data = ajaxCall("${ctx}/PayAppMgr.do?cmd=savePayAppMgrSignData", params, true);
		}
		
		// 제출완료 메시지창의 OK 버튼 클릭 시 실행됨. 
		if( rv["flag"] == "rdSignComplete" ) {
			// RD 재출력
			doAction("Search");
		}
	}

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="paramFrm" name="paramFrm" >
		<input type="hidden" id="Mrd">
		<input type="hidden" id="Param">
		<input type="hidden" id="ToolbarYn">
		<input type="hidden" id="ZoomRatio">
		<input type="hidden" id="ParamGubun">
		<input type="hidden" id="SaveYn">
		<input type="hidden" id="PrintYn">
		<input type="hidden" id="ExcelYn">
		<input type="hidden" id="WordYn">
		<input type="hidden" id="PptYn">
		<input type="hidden" id="HwpYn">
		<input type="hidden" id="PdfYn">

		<!-- 전자서명 기능 관련 Value -->
		<input type="hidden" id="rdSignUse"     name="rdSignUse">
		<input type="hidden" id="rdSignHandler" name="rdSignHandler">
		<input type="hidden" id="rdSignParam"   name="rdSignParam">
		<!-- 전자서명 기능 관련 Value -->

		<input type="hidden" id="searchOrgCd">
	</form>
	<form id="srchFrm" name="srchFrm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th>급여일자</th>
						<td>
							<input type="hidden" id="searchPayActionCd" name="searchPayActionCd" value="" /><input type="hidden" id="sabun" name="sabun" class="text" value="" />
							<input type="text" id="searchPayActionNm" name="searchPayActionNm" class="text" value="" validator="required" readonly="readonly" style="width:150px" />
							<a href="javascript:payActionSearchPopup();"  class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
						</td>
						<th>사업장</th>
						<td>
							<select id="searchBusinessPlaceCd" name ="searchBusinessPlaceCd" class="box"></select>
						</td>
					</tr>
					<tr>
						<th>소속 </th>
						<td>
							<input id="searchOrgNm" name ="searchOrgNm" type="text" class="text readonly" readOnly style="width:148px"/>
							<a onclick="javascript:orgSearchPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
							<a onclick="$('#searchOrgCd,#searchOrgNm').val('');" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
						</td>
						<th>출력단위</th>
						<td>
							<select id="searchPrintUnit" name ="searchPrintUnit" class="box">
								<option value="1" >개인별</option>
								<option value="2" >팀별</option>
								<option value="4" >팀별2</option>
								<option value="3" >사업장별</option>
								<option value="5" >근무지별</option>
							</select>
						</td>
						<td>
							<a href="javascript:doAction('Search');" id="btnSearch" class="button">조회</a>
							<a href="javascript:doAction('SignForce');" id="btnSearch" class="button">재서명</a>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main" >
		<tr>
			<td>
				<div class="table_rpt">
					<iframe name="reportPage_ifrmsrc" id="reportPage_ifrmsrc" frameborder='0' class='tab_iframes'></iframe>
				</div>
			</td>
		</tr>
	</table>
</div>
</body>
</html>