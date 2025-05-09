<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>연말정산계산</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%String ssnSearchType = (String)session.getAttribute("ssnSearchType");%>

<script type="text/javascript">
	//급여계산중이거나, 급여계산취소 중이면 true
	var waitFlag    = false;
	var msg = "";

	$(function() {

		$("#searchWorkYy").val("<%=yeaYear%>") ;

		$("#searchWorkYy").bind("keyup",function(event){
			makeNumber(this,"A");
			if( event.keyCode == 13){
				getActionCd();
			}
		});

		$("#searchWorkYy").bind("blur",function(event){
			getActionCd() ;
		});

		// 사업장(권한 구분)
		var ssnSearchType  = "<%=removeXSS(ssnSearchType, '1')%>";

		var bizPlaceCdList = "";

		if(ssnSearchType == "A"){
			bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getBizPlaceCdList","",false).codeList, "전체");
		}else{
			bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getBizPlaceCdAuthList&queryId=getBizPlaceCdAuthList","",false).codeList, "");
		}

        $("#searchBizPlaceCd").html(bizPlaceCdList[2]);
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols = [
   			{Header:"No",			Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
   			{Header:"삭제",			Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
   			{Header:"상태",			Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
			{Header:"마감여부",		Type:"Text",		  Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"final_close_yn",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500},
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata2.Cols = [
   			{Header:"No",			Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
   			{Header:"삭제",			Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
   			{Header:"상태",			Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
			{Header:"총인원",			Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"t_cnt",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"대상인원",			Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"all_811_cnt",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"작업대상인원",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"p_cnt",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"작업완료인원",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"j_cnt",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"마감인원",			Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"final_y_cnt",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"미마감인원",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"final_n_cnt",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 }
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("<%=editable%>");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		$(window).smartresize(sheetResize);
		sheetInit();

		getActionCd() ;//연말정산 payActionCd,Nm 가져옴
		/* 2018-07-12 계산 중 Dialog 출력 START */
		$( "#progressCover" ).dialog({
		      resizable: false,
		      height: 90,
		      width: 240,
		      modal: true
	    });
		$(".ui-dialog-titlebar").hide();

		$( "#progressCover" ).dialog('close');

		if($("#searchBizPlaceCd").val() != ""){
			$("#bizPlFont").show();
		} else $("#bizPlFont").hide();
		
		/* 2018-07-12 계산 중 Dialog 출력 END */
	});

	// 연급여생성 조회
	function getCpnMonpay(){

        var monpayYn = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=CPN_MONPAY_RETRY_YN", "queryId=getSystemStdData",false).codeList;
        var monpayReYn = "Y";

		if(monpayYn[0].code_nm != "N") {
			$("input:radio[name='cpn_monpay_return_yn']:input[value='"+monpayReYn+"']").attr("checked",true);
		} else {
			monpayReYn = "N";
			$("input:radio[name='cpn_monpay_return_yn']:input[value='"+monpayReYn+"']").attr("checked",true);
		}
	}

	// 연말정산가족사항추출
	function getCpnYeaFam(){
		var yeaFamYn = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=CPN_YEA_FAMILY", "queryId=getSystemStdData",false).codeList;
		var yeaFamReYn = "-1"

		if(yeaFamYn[0].code_nm != "0") {
			$("input:radio[name='cpn_yea_family_yn']:input[value='"+yeaFamReYn+"']").attr("checked",true);
		} else {
			yeaFamReYn = "0";
			$("input:radio[name='cpn_yea_family_yn']:input[value='"+yeaFamReYn+"']").attr("checked",true);
		}
	}

	// 임직원메뉴오픈 조회
	function getOrgAuthOpen(){
		var OrgAuthStatus = ajaxCall("<%=jspPath%>/yeaCalcCre/yeaCalcCreRst.jsp?cmd=selectOrgAuthStatus", $("#sheetForm").serialize(), false);
		if(OrgAuthStatus.Data.use_yn != "0"){
			$("input:radio[name='org_auth_open_yn']:input[value=Y]").attr("checked",true);
		}else{
			$("input:radio[name='org_auth_open_yn']:input[value=N]").attr("checked",true);
		}
	}

	function doAction1(sAction) {
		switch (sAction) {
	    case "Search":
	    	sheet1.DoSearch( "<%=jspPath%>/yeaCalcCre/yeaCalcCreRst.jsp?cmd=selectYeaCalcCreSheet1List", $("#sheetForm").serialize() );
	    	break;
		}
	}

	function doAction2(sAction) {
		switch (sAction) {
	    case "Search":
	    	sheet2.DoSearch( "<%=jspPath%>/yeaCalcCre/yeaCalcCreRst.jsp?cmd=selectYeaCalcCreSheet2List", $("#sheetForm").serialize() );
	    	break;
		}
	}

	//조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);

			if(Code == 1) {
				setCloseImg();
			}
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	//조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);

			if(Code == 1) {
				setPeopleStatusCnt();
			}
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	//쉬트 조회
	function sheetSearch() {
		doAction1("Search");
		doAction2("Search");
        // 2020-10-16 연급여생성 세팅
        getCpnMonpay();
		// 2020-11-16 연말정산가족사항추출
		getCpnYeaFam();
		// 2020-11-16 임직원메뉴오픈
		getOrgAuthOpen();
		// 급여일자 생성버튼
		if($("#searchPayActionCd").val() != ""){
			$("#saveYeaCalCreBtn").hide();
		}else{
			$("#saveYeaCalCreBtn").show();
		}
	}

	//연말정산 코드 가져오기
	function getActionCd(){
	    //연말정산_급여계산 코드,명칭 초기화
	    $("#searchPayActionCd").val("");
	    $("#searchPayActionNm").val("");
		var paymentInfo = ajaxCall("<%=jspPath%>/yeaCalcCre/yeaCalcCreRst.jsp?cmd=selectYeaPayActionInfo", "searchYear="+$("#searchWorkYy").val(), false);

		//연말정산_급여계산 코드,명칭 세팅
		$("#searchPayActionCd").val(nvl(paymentInfo.Data.pay_action_cd,""));
		$("#searchPayActionNm").val(nvl(paymentInfo.Data.pay_action_nm,""));
		sheetSearch();
	}

	//마감 체크
	function checkClose(){
		if(sheet1.GetCellValue(1, 'final_close_yn') == "Y") {
			alert("이미 마감되었습니다.");
			return true;
		} else{
			return false;
		}
	}

	//연말정산항목이 존재 확인
	function checkPayActionCd(){
		if($("#searchPayActionCd").val() == "") {
			alert($("#searchWorkYy").val()+"년도 연말정산일자가 등록되지 않았습니다.\n\n급여일자관리에서 연말정산 일자를 등록하세요.");
			return false;
		}
		return true;
	}

	//연말정산 마감여부 체크
	function setCloseImg(){
		if(sheet1.GetCellValue(1, 'final_close_yn') == "Y") {
			$(':checkbox[name=calcuFinishedImg]').attr('checked', true);
		} else{
			$(':checkbox[name=calcuFinishedImg]').attr('checked', false);
		}
	}

	//대상 정보
	function setPeopleStatusCnt() {
		$("#peopleTotalCnt").html(sheet2.GetCellText(1, "t_cnt")) ;
		$("#people811Cnt").html(sheet2.GetCellText(1, "all_811_cnt")) ;
		$("#peoplePCnt").html(sheet2.GetCellText(1, "p_cnt")) ;
		$("#peopleJCnt").html(sheet2.GetCellText(1, "j_cnt")) ;
		$("#finalCloseYCnt").html(sheet2.GetCellText(1, "final_y_cnt")) ;
		$("#finalCloseNCnt").html(sheet2.GetCellText(1, "final_n_cnt")) ;

		// 작업대상전체 체크박스 제어
		if(sheet2.GetCellText(1, "all_811_cnt") != "0" && sheet2.GetCellText(1, "all_811_cnt") == sheet2.GetCellText(1, "p_cnt")) {
			$(':checkbox[name=peoplePTotal]').prop('checked', true);
		}
		else {
			$(':checkbox[name=peoplePTotal]').prop('checked', false);
		}
		if($("#payMonChk").is(":checked") == true) $(':checkbox[name=payMonChk]').attr('checked', false);
		if($("#taxMonChk").is(":checked") == true) $(':checkbox[name=taxMonChk]').attr('checked', false);
	}

	var pGubun = "";


	//작업현황 팝업
	function openProcessStatus(){

		var args 	= new Array();
		args["searchWorkYy"]		= $("#searchWorkYy").val() ;
		args["searchPayActionNm"]	= $("#searchPayActionNm").val() ;
		args["searchPayActionCd"]	= $("#searchPayActionCd").val() ;
		args["searchAdjustType"]	= $("#searchAdjustType").val() ;//1 - 연말정산(3은 퇴직)
		args["searchBizPlaceCd"]	= $("#searchBizPlaceCd").val() ;//사업장

		if(!isPopup()) {return;}
		pGubun = "yeaCalcCreOptionPopup";
		var rv = openPopup("<%=jspPath%>/yeaCalcCre/yeaCalcProcessStatusPopup.jsp?authPg=<%=authPg%>",args,"1050","900");
	}

	//FAQ 팝업
	function openFaqPop(){
		var args 	= new Array();
		args["searchWorkYy"]		= $("#searchWorkYy").val() ;
		args["searchAdjustType"]	= $("#searchAdjustType").val() ;//1 - 연말정산(3은 퇴직)

		if(!isPopup()) {return;}
		pGubun = "yeaCalcCreFaqPopup";
		var rv = openPopup("<%=jspPath%>/yeaCalcCre/yeaCalcCreFaqPopup.jsp?authPg=<%=authPg%>",args,"800","800");

	}

	//패치현황 팝업
	function openPatchGuide(){
		var args 	= new Array();
		args["searchWorkYy"]		= $("#searchWorkYy").val() ;
		args["searchAdjustType"]	= $("#searchAdjustType").val() ;//1 - 연말정산(3은 퇴직)

		if(!isPopup()) {return;}
		pGubun = "yeaCalcPatchGuidePopup";
		var rv = openPopup("<%=jspPath%>/yeaCalcCre/yeaCalcPatchGuidePopup.jsp?authPg=<%=authPg%>",args,"800","700");

	}

	// 연급여생성 체크(작업/작업 취소 관련 저장 체크)
	function fn_payMonChkYn(){
		if($("#searchBizPlaceCd").val().length > 0){
			alert("사업장을 전체로 선택해 주십시오.\n연급여생성은 관리자만 할 수 있습니다.");
			if($("#payMonChk").is(":checked") == true) $(':checkbox[name=payMonChk]').attr('checked', false);
			else $(':checkbox[name=payMonChk]').attr('checked', true);
			return;
		}
	}

	// 연급여생성 저장(삭제후생성/신규만 생성 저장 체크)
	function fn_checkMonpayYn(){
		if($("#searchBizPlaceCd").val().length > 0){
			alert("사업장을 전체로 선택해 주십시오.\n연급여생성은 관리자만 할 수 있습니다.");
			if($("input:radio[name='cpn_monpay_return_yn']").filter("input[value='Y']").attr("checked") == "checked"){
				$("input:radio[name='cpn_monpay_return_yn']").filter("input[value='Y']").attr("checked",false);
				$("input:radio[name='cpn_monpay_return_yn']").filter("input[value='N']").attr("checked",true);
			}else{
				$("input:radio[name='cpn_monpay_return_yn']").filter("input[value='Y']").attr("checked",true);
				$("input:radio[name='cpn_monpay_return_yn']").filter("input[value='N']").attr("checked",false);
			}
			return;
		}

		var params = $("#sheetForm").serialize()+ "&std_cd=CPN_MONPAY_RETRY_YN";
		params += "&sStatus=U";
		params += "&std_cd_value="+$("input:radio[name=cpn_monpay_return_yn]:checked").val();
		params += "&work_yy="+$("#searchWorkYy").val();

		ajaxCall("<%=jspPath%>/yeaCalcCre/yeaCalcCreOptionPopupRst.jsp?cmd=saveYeaCalcCreOptionPopup",params,false);

	}

	// 연말정산가족사항추출 저장
	function fn_checkYeaFamYn(){
		if($("#searchBizPlaceCd").val().length > 0){
			alert("사업장을 전체로 선택해 주십시오.\n관리자만 할 수 있습니다.");
			if($("input:radio[name='cpn_yea_family_yn']").filter("input[value='-1']").attr("checked") == "checked"){
				$("input:radio[name='cpn_yea_family_yn']").filter("input[value='-1']").attr("checked",false);
				$("input:radio[name='cpn_yea_family_yn']").filter("input[value='0']").attr("checked",true);
			}else{
				$("input:radio[name='cpn_yea_family_yn']").filter("input[value='-1']").attr("checked",true);
				$("input:radio[name='cpn_yea_family_yn']").filter("input[value='0']").attr("checked",false);			}
			return;
		}
		var params = $("#sheetForm").serialize()+ "&std_cd=CPN_YEA_FAMILY";
		params += "&sStatus=U";
		params += "&std_cd_value="+$("input:radio[name=cpn_yea_family_yn]:checked").val();
		params += "&work_yy="+$("#searchWorkYy").val();

		ajaxCall("<%=jspPath%>/yeaCalcCre/yeaCalcCreOptionPopupRst.jsp?cmd=saveYeaCalcCreOptionPopup",params,false);
	}

	// 임직원메뉴오픈 저장
	function fn_checkOrgAuthYn(){
		if($("#searchBizPlaceCd").val().length > 0){
			alert("사업장을 전체로 선택해 주십시오.\n관리자만 할 수 있습니다.");
			orgAuthOpenChkSet();//임직원메뉴오픈 체크값 세팅
			return;
		}else{
			//메뉴오픈 취소(YES -> NO)
			if($("input:radio[name='org_auth_open_yn']").filter("input[value='N']").attr("checked") == "checked"){
				if(confirm("임직원공통(99) 권한에 대해 연말정산 메뉴 오픈을 취소하시겠습니까?")){
					if($("input:radio[name='org_auth_open_yn']").filter("input[value='N']").attr("checked") == "checked"){
						var params = $("#sheetForm").serialize();
						params += "&useyn="+$("input:radio[name=org_auth_open_yn]:checked").val();
						ajaxCall("<%=jspPath%>/yeaCalcCre/yeaCalcCreRst.jsp?cmd=saveOrgAuthStatus",params,false);
					}
				}else{
					orgAuthOpenChkSet();//임직원메뉴오픈 체크값 세팅
					return;
				}
			}
			//메뉴오픈(NO -> YES)
			else{
				if(confirm("임직원공통(99) 권한에 대해 연말정산 메뉴를 오픈 하시겠습니까?")){
					if($("input:radio[name='org_auth_open_yn']").filter("input[value='Y']").attr("checked") == "checked"){
						var params = $("#sheetForm").serialize();
						params += "&useyn="+$("input:radio[name=org_auth_open_yn]:checked").val();
						ajaxCall("<%=jspPath%>/yeaCalcCre/yeaCalcCreRst.jsp?cmd=saveOrgAuthStatus",params,false);
					}
				}else{
					orgAuthOpenChkSet();//임직원메뉴오픈 체크값 세팅
					return;
				}
			}
		}
	}

	//임직원메뉴오픈 체크값 세팅
	function orgAuthOpenChkSet(){
		if($("input:radio[name='org_auth_open_yn']").filter("input[value='Y']").attr("checked") == "checked"){
			$("input:radio[name='org_auth_open_yn']").filter("input[value='Y']").attr("checked",false);
			$("input:radio[name='org_auth_open_yn']").filter("input[value='N']").attr("checked",true);
		}else{
			$("input:radio[name='org_auth_open_yn']").filter("input[value='Y']").attr("checked",true);
			$("input:radio[name='org_auth_open_yn']").filter("input[value='N']").attr("checked",false);
		}
	}

	function goPatchGuidePopup() {
		//var chk = getCookie('patchGuidePopupInfo');
		var isPatchPopup = true;
		var maxPatchSeq = 0;
		var param = "searchWorkYy="+$("#searchWorkYy").val();
		param += "&searchAdjustType="+$("#searchAdjustType").val();
		var rstData = ajaxCall("<%=jspPath%>/yeaCalcCre/yeaCalcPatchGuidePopupRst.jsp?cmd=selectYeaCalcMaxPatchSeq",param,false);

		if(rstData.Result.Code == "1") {
			if(rstData.Data.cnt > 0) {
				maxPatchSeq = rstData.Data.patch_seq;
			}

			if(maxPatchSeq > 0) {
				/*if(chk != null && chk != undefined){
					var info = chk.split("|");
					if(info.length > 1 && info[0] == 'Y' && info[1] >= maxPatchSeq) {
						isPatchPopup = false;
					}
				}*/
				if(isPatchPopup) {
					openPatchGuide();
				}
			}
		}
	}


	function getCookie(name) {
	   var cookieName = name + "=";
	   var x = 0;
	   while ( x <= document.cookie.length ) {
	      var y = (x+cookieName.length);
	      if ( document.cookie.substring( x, y ) == cookieName) {
	         if ((lastChrCookie=document.cookie.indexOf(";", y)) == -1)
	            lastChrCookie = document.cookie.length;
	         return decodeURI(document.cookie.substring(y, lastChrCookie));
	      }
	      x = document.cookie.indexOf(" ", x ) + 1;
	      if ( x == 0 )
	         break;
	      }
	   return "";
	}


	//대상자 기준 팝업
	function openPeopleSet(){
		if(waitFlag) return;
		if(!checkPayActionCd()) return;

		if(checkSelect()){
			var args 	= new Array();
			args["searchWorkYy"]		= $("#searchWorkYy").val() ;
			args["searchPayActionNm"]	= $("#searchPayActionNm").val() ;
			args["searchPayActionCd"]	= $("#searchPayActionCd").val() ;
			args["searchAdjustType"]	= $("#searchAdjustType").val() ;//1 - 연말정산(3은 퇴직)
			args["searchBizPlaceCd"]	= $("#searchBizPlaceCd").val() ;//사업장

			if(!isPopup()) {return;}
			pGubun = "yeaCalcCrePeoplePopup";
			var rv = openPopup("<%=jspPath%>/yeaCalcCre/yeaCalcCrePeoplePopup.jsp?authPg=<%=authPg%>",args,"900","580");
			//sheetSearch();
		}
	}

	//재계산 대상자 작업 팝업
	function openYEACalRetry() {
		if(waitFlag) return;
		if(!checkPayActionCd()) return;

		if(checkSelect()){
			var args 	= new Array();
			args["searchWorkYy"]		= $("#searchWorkYy").val() ;
			args["searchPayActionNm"]	= $("#searchPayActionNm").val() ;
			args["searchPayActionCd"]	= $("#searchPayActionCd").val() ;
			args["searchAdjustType"]	= $("#searchAdjustType").val() ;//1 - 연말정산(3은 퇴직)
			args["searchBizPlaceCd"]	= $("#searchBizPlaceCd").val() ;//사업장

			if($("#calcuFinishedImg").is(":checked") == true){
				args["popFlag"]	= "true"; // 연말정산여부flag
			}else{
				args["popFlag"]	= "false"; // 연말정산여부flag
			}

			if(!isPopup()) {return;}
			pGubun = "yeaCalcCreRePeoplePopup";
			var rv = openPopup("<%=jspPath%>/yeaCalcCre/yeaCalcCreRePeoplePopup.jsp?authPg=<%=authPg%>",args,"900","580");
			//sheetSearch() ;
		}
	}

	//옵션설정
	function optPop(){
		var args 	= new Array();
		args["searchWorkYy"]		= $("#searchWorkYy").val() ;
		args["searchPayActionNm"]	= $("#searchPayActionNm").val() ;
		args["searchPayActionCd"]	= $("#searchPayActionCd").val() ;
		args["searchAdjustType"]	= $("#searchAdjustType").val() ;//1 - 연말정산(3은 퇴직)
		args["searchBizPlaceCd"]	= $("#searchBizPlaceCd").val() ;//사업장

		if(!isPopup()) {return;}
		pGubun = "yeaCalcCreOptionPopup";
		var rv = openPopup("<%=jspPath%>/yeaCalcCre/yeaCalcCreOptionPopup.jsp?authPg=<%=authPg%>",args,"900","750");
		//sheetSearch() ;
	}

	function optPopBranch() {
		if(waitFlag) return;
        if(!checkPayActionCd()) return;

	    var args    = new Array();
        args["searchWorkYy"]        = $("#searchWorkYy").val() ;
        //args["searchPayActionNm"]   = $("#searchPayActionNm").val() ;
        //args["searchPayActionCd"]   = $("#searchPayActionCd").val() ;
        //args["searchAdjustType"]    = $("#searchAdjustType").val() ;//1 - 연말정산(3은 퇴직)

        if(!isPopup()) {return;}
        pGubun = "yeaCalcBranchOptionPopup";
        var rv = openPopup("<%=jspPath%>/yeaCalcCre/yeaCalcBranchOptionPopup.jsp?authPg=<%=authPg%>",args,"800","450");

	}

	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

		if ( pGubun == "yeaCalcCrePeoplePopup" ){
			sheetSearch();
		} else if ( pGubun == "yeaCalcCreRePeoplePopup" ){
			sheetSearch();
		} else if ( pGubun == "yeaCalcCreOptionPopup" ){
			sheetSearch();
		}
	}

	//연말정산 작업
	function doJob(){

		if(waitFlag) return;
		if(!checkPayActionCd()) return;
		if(checkClose()) return;

		payFlag = "TRUE";
		taxFlag = "TRUE";
		msg		= "";

		if(!$("#payMonChk").is(":checked")){
			if(!$("#taxMonChk").is(":checked")){
				//alert("작업을 선택해주세요.");
				alert("수행할 작업(연급여생성 or 세금계산)을 선택해주세요.");
				return;
			} else {
				msg = "연말정산계산";
				payFlag = "FALSE";
				taxFlag = "TRUE";
			}
		} else {
			msg = "연급여생성";
			if(!$("#taxMonChk").is(":checked")){
				payFlag = "TRUE";
				taxFlag = "FALSE";

			} else {
				msg =  "연급여생성,연말정산계산";
				payFlag = "TRUE";
				taxFlag = "TRUE";
			}
		}

		if(checkSelect()){
			if($("#peoplePCnt").html() == "0"){
				alert("대상인원이 없습니다.");
				return;
			}
			if(confirm($("#searchWorkYy").val()+"년 "+msg+"을 시작하시겠습니까?")){

				if(taxFlag == "TRUE" && payFlag == "TRUE") {
		   	    	ajaxCall("<%=jspPath%>/yeaCalcCre/yeaCalcCreRst.jsp?cmd=prcYearEndMonPayAndTax",$("#sheetForm").serialize()
		   	    			,true
		   	    			,function(){
								waitFlag = true;
								$( "#progressCover" ).dialog('open');
		   	    			}
		   	    			,function(){
								waitFlag = false;
								$( "#progressCover" ).dialog('close');
								doAction2('Search');
		   	    			}
		   	    	);
				} else {
					if(payFlag == "TRUE") {
			   	    	ajaxCall("<%=jspPath%>/yeaCalcCre/yeaCalcCreRst.jsp?cmd=prcYearEndMonPay",$("#sheetForm").serialize()
			   	    			,true
			   	    			,function(){
									waitFlag = true;
									$( "#progressCover" ).dialog('open');
			   	    			}
			   	    			,function(){
									waitFlag = false;
									$( "#progressCover" ).dialog('close');
									doAction2('Search');
			   	    			}
			   	    	);
					};
					if(taxFlag == "TRUE") {
			   	    	ajaxCall("<%=jspPath%>/yeaCalcCre/yeaCalcCreRst.jsp?cmd=prcYearEndTax",$("#sheetForm").serialize()
			   	    			,true
			   	    			,function(){
									waitFlag = true;
									$( "#progressCover" ).dialog('open');
			   	    			}
			   	    			,function(){
									waitFlag = false ;
									$( "#progressCover" ).dialog('close');
									doAction2('Search');
			   	    			}
			   	    	);
					}
				}
			}
		}
	}

	//연말정산 작업 취소
	function cancelJob(){

		if(waitFlag) return;
		if(!checkPayActionCd()) return;
		if(checkClose()) return;

		if( $("#peopleJCnt").html()*1 <= 0){
			alert("작업완료 인원이 존재하지 않습니다.") ;
			return;
		}

		if(checkSelect()){
			if(confirm("연말정산계산취소를 시작하시겠습니까?")){
				waitFlag = true;
				ajaxCall("<%=jspPath%>/yeaCalcCre/yeaCalcCreRst.jsp?cmd=prcYearEndCenCel",$("#sheetForm").serialize(),false);
	   	    	waitFlag = false ;
	   	    	doAction2('Search') ;
			}
		}
	}

	//마감
	function finishAll(){
		if($("#searchBizPlaceCd").val().length > 0){
			alert("사업장을 전체로 선택해 주십시오.\n마감은 관리자만 할 수 있습니다.");
			return;
		}
		if(waitFlag) return;
		if(!checkPayActionCd()) return;
		if(checkClose()) return;

		if($("#people811Cnt").html()*1 == 0){
			alert("대상인원이 존재하지 않습니다.\n마감할 수 없습니다.");
			return;
		}

		if($("#people811Cnt").html() != $("#peopleJCnt").html()){
			alert("대상인원과 작업완료인원이 일치하지 않습니다.\n마감할 수 없습니다.");
			return;
		}

		if(checkSelect()){
			var params = $("#sheetForm").serialize()+"&searchFinalCloseYN=Y";
			//TCPN811 & TCPN983 UPDATE!
			ajaxCall("<%=jspPath%>/yeaCalcCre/yeaCalcCreRst.jsp?cmd=saveFinalCloseYn",params,false);

			sheetSearch();
		}
	}

	//마감취소
	function cancelAll(){
		if($("#searchBizPlaceCd").val().length > 0){
			alert("사업장을 전체로 선택해 주십시오.\n마감취소는 관리자만 할 수 있습니다.");
			return;
		}
		if(waitFlag) return;
		if(!checkPayActionCd()) return;
		if(checkSelect()){

			//if(sheet1.GetCellValue(1, 'final_close_yn') != "Y"){
			//	alert("마감되지않은 연말정산계산작업입니다.");
			//	return;
			//}

			var params = $("#sheetForm").serialize()+"&searchFinalCloseYN=N";
			//TCPN811 & TCPN983 UPDATE!
			ajaxCall("<%=jspPath%>/yeaCalcCre/yeaCalcCreRst.jsp?cmd=saveFinalCloseYn",params,false);

			sheetSearch();
		}

	}

	//급여일자가 선택되었는지 체크
	function checkSelect(){
		if($("#searchPayActionCd").val() == ""){
			alert($("#searchWorkYy").val()+"년도 연말정산일자가 등록되지 않았습니다.\n\n급여일자관리에서 연말정산 일자를 등록하세요.");
			if($("#peoplePTotal").is(":checked") == true) $(':checkbox[name=peoplePTotal]').attr('checked', false);
			else $(':checkbox[name=peoplePTotal]').attr('checked', true);
			return false;
		}else{
			return true;
		}
	}

	//작업대상전체 체크박스 클릭시
	function clickPeoplePTotal(){

		if(waitFlag) return;

		if(sheet1.GetCellValue(1, 'final_close_yn') == "Y") {
			alert("이미 마감되었습니다.");
			if($("#peoplePTotal").is(":checked") == true) $(':checkbox[name=peoplePTotal]').attr('checked', false);
			else $(':checkbox[name=peoplePTotal]').attr('checked', true);
			return;
		}

		if( parseInt($("#peopleJCnt").html(),10) > 0){
			alert("작업완료인원이 존재합니다.\n작업취소를 먼저하세요!");
			if($("#peoplePTotal").is(":checked") == true) $(':checkbox[name=peoplePTotal]').attr('checked', false);
			else $(':checkbox[name=peoplePTotal]').attr('checked', true);
			return;
		}

		var confirmMsg = "";
		if($("#peoplePTotal").is(":checked") == true){
			confirmMsg = "대상인원전체를 작업대상인원으로 변경하시겠습니까?";
		}else{
			confirmMsg = "작업대상인원을 초기화하시겠습니까?";
		}

		if(checkSelect()){
			if(confirm(confirmMsg)){

				waitFlag = true;
				searchPayPeopleStatus   = "";

				if($("#peoplePTotal").is(":checked") == true) {
					searchPayPeopleStatus = "P";
				} else {
					searchPayPeopleStatus = "C";
				}

				var params = $("#sheetForm").serialize()+"&searchPayPeopleStatus="+searchPayPeopleStatus;
				//TCPN811 UPDATE!
				ajaxCall("<%=jspPath%>/yeaCalcCre/yeaCalcCreRst.jsp?cmd=savePayPeopleStatus",params,false);

				waitFlag = false ;
				doAction2("Search");
			} else{
				if($("#peoplePTotal").is(":checked") == true) {
					$(':checkbox[name=peoplePTotal]').attr('checked', false);
				} else {
					$(':checkbox[name=peoplePTotal]').attr('checked', true);
				}
			}
		}
	}

	// 연말정산 급여일자 생성
	function saveYeaCalCre(){

		var confirmMsg = "";
		var ssnSearchType  = "<%=removeXSS(ssnSearchType, '1')%>";

		if(ssnSearchType != "A"){
			alert("관리자만 생성 가능합니다.");
			return;
		}else{
			if($("#searchBizPlaceCd").val().length > 0){
				alert("사업장을 전체로 선택해 주십시오.\n생성은 관리자만 할 수 있습니다.");
				return;
			}else{
				if($("#searchPayActionCd").val() != "" || $("#searchPayActionNm").val() != ""){
					alert("이미 생성되어있습니다.");
					return;
				}else{
					confirmMsg = $("#searchWorkYy").val()+ "년 " +"연말정산을 생성하시겠습니까?";
					if(confirm(confirmMsg)){
						ajaxCall("<%=jspPath%>/yeaCalcCre/yeaCalcCreRst.jsp?cmd=insertYeaPayDayTCPN201", $("#sheetForm").serialize(),false);
					}
					getActionCd();
				}
			}
		}

	}

	// 대상자생성
	function peopleCre(){

	    if($("#searchPayActionCd").val() != ""){

	    	if(sheet2.GetCellText(1, "t_cnt") > 0){
	            alert("이미 대상자가 존재할 때, 대상자 재생성은 진행되지 않습니다."
	                    + "\n 자세한 정보는 대상자정보 버튼을 클릭하여 확인하여 주시기 바랍니다");
	            return;
	        }else{
		        var data = ajaxCall("<%=jspPath%>/yeaCalcCre/yeaCalcCrePeoplePopupRst.jsp?cmd=prcCpnYearEndEmp",$("#sheetForm").serialize(),false);

		        if(data.Result.Code == 1) {
		        	getActionCd();
		        }
		        if(data.Result.Code == null) {
		            alert("작업 완료") ;
		        } else {
		            msg = "처리도중 문제발생 : "+data.Result.Message;
		        }
	        }
	    }else{
	        alert("연말정산 생성 후 대상자 생성이 가능합니다."
	        		+"\n 연말정산을 먼저 생성해 주시기 바랍니다.");
	        return;
	    }
	}

	function bizPlOnChange() {
		if($("#searchBizPlaceCd").val() != ""){
			$("#bizPlFont").show();
		} else $("#bizPlFont").hide();
	}
	
</script>
</head>
<body class="hidden">
<div id="progressCover" style="display:none;top:0;bottom:0;left:0;right:0;background:url(<%=imagePath%>/common/process.png) no-repeat 50% 50%;"></div>
<div class="wrapper">
	<form id="sheetForm" name="sheetForm">
		<input type="hidden" id="searchAdjustType" name="searchAdjustType" value="1" />
		<input type="hidden" id="searchPayActionCd" name="searchPayActionCd" value="">
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td> 연도 :
							<%
							if(!"SH".equals(session.getAttribute("ssnEnterCd")) && !"GT".equals(session.getAttribute("ssnEnterCd")) && !"FMS".equals(session.getAttribute("ssnEnterCd")) && !"CSM".equals(session.getAttribute("ssnEnterCd")) && !"SHN".equals(session.getAttribute("ssnEnterCd"))){
							%>
								<input type="text" id="searchWorkYy" name="searchWorkYy" maxlength="4" class="text w30 readonly" onFocus="this.select()" value=""  readonly/>
							<%}else{%>
								<input type="text" id="searchWorkYy" name="searchWorkYy" maxlength="4" class="text w30 readonly" onFocus="this.select()" value=""  readonly/>
							<%}%>
						</td>
						<td>
							<a href="javascript:getActionCd();" id="btnSearch" class="button">조회</a>
						</td>
						<td>
							<span>사업장</span>
							<select id="searchBizPlaceCd" name ="searchBizPlaceCd" onChange="sheetSearch();bizPlOnChange();" class="box">
								<option value="" selected="selected">전체</option>
							</select>
						</td>
						<td>
							<font id="bizPlFont" style="color:blue;">※ 사업장별 작업은 대상자생성, 세금계산, 작업현황만 하실 수 있습니다.</font>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<colgroup>
			<col width="58%" />
			<col width="1%" />
			<col width="41%" />
		</colgroup>
		<tr>
			<td class="top center">
				<div class="sheet_title">
					<ul>
						<li id="txt" class="txt">작업진행순서</li>
					</ul>
				</div>
				<table border="0" cellpadding="0" cellspacing="0" class="default" style="table-layout: fixed;">
					<colgroup>
						<col width="20%" />
						<col width="30%" />
						<col width="20%" />
						<col width="%" />
					</colgroup>
					<tr>
						<th>연말정산 급여일자</th>
						<td colspan="3" class="left">
							<a href="javascript:saveYeaCalCre();" id="saveYeaCalCreBtn" class="basic authA">생성</a>
							<input type="text" id="searchPayActionNm" name="searchPayActionNm" class="text w150 readonly transparent" value="" readonly/>

						</td>
					</tr>
					<tr>
						<th>대상자관리</th>
						<td colspan="3" class="left">
							<a href="javascript:peopleCre();" class="basic authA">대상자생성</a>&nbsp;&nbsp;&nbsp;
							<input type="radio"	class="radio" name="cpn_yea_family_yn" value="-1" onchange="javascript:fn_checkYeaFamYn();">&nbsp;&nbsp;작년 연말정산 부양가족&nbsp;&nbsp;&nbsp;
							<input type="radio" class="radio" name="cpn_yea_family_yn" value="0" onchange="javascript:fn_checkYeaFamYn();">&nbsp;&nbsp;인사기본 가족사항
						</td>
					</tr>
					<tr>
						<th>연급여생성
							<span id="chkTmp1">
								<input type="checkbox" class="checkbox" id="payMonChk" name="payMonChk" onchange="javascript:fn_payMonChkYn();" value="N" style="vertical-align: middle;">
							</span>
						</th>
						<td colspan="3" class="left">
							<input type="radio"	class="radio" name="cpn_monpay_return_yn" value="Y" onchange="javascript:fn_checkMonpayYn();">&nbsp;&nbsp;삭제후재생성&nbsp;&nbsp;&nbsp;
							<input type="radio" class="radio" name="cpn_monpay_return_yn" value="N" onchange="javascript:fn_checkMonpayYn();">&nbsp;&nbsp;신규만생성
						</td>
					</tr>
					<tr>
						<th>세금계산
							<span id="chkTmp2">
								<input type="checkbox"	class="checkbox" id="taxMonChk" name="taxMonChk" value="N" style="vertical-align: middle;">
							</span>
						</th>
						<td colspan="3" class="left">
						</td>
					</tr>
					<tr>
						<th>임직원메뉴오픈</th>
						<td colspan="3" class="left">
							<input type="radio"	class="radio" name="org_auth_open_yn" value="Y" onchange="javascript:fn_checkOrgAuthYn()">&nbsp;&nbsp;YES&nbsp;&nbsp;&nbsp;
							<input type="radio" class="radio" name="org_auth_open_yn" value="N" onchange="javascript:fn_checkOrgAuthYn()">&nbsp;&nbsp;NO
						</td>
					</tr>
					<tr>
						<th>총인원</th>
						<td id="peopleTotalCnt" class="right"> </td>
						<th>대상인원</th>
						<td id="people811Cnt" class="right"> </td>
					</tr>
					<tr>
						<th>작업대상인원</th>
						<td id="peoplePCnt" class="right"> </td>
						<th>작업완료인원</th>
						<td id="peopleJCnt" class="right"> </td>
					</tr>
					<tr>
						<th>미마감인원</th>
						<td id="finalCloseNCnt" class="right"> </td>
						<th>마감인원</th>
						<td id="finalCloseYCnt" class="right"> </td>
					</tr>
					<tr>
						<th>작업대상전체
							<input type="checkbox" class="checkbox" style="vertical-align:middle;" id="peoplePTotal" name="peoplePTotal" value="N" onClick="javascript:clickPeoplePTotal();">
						</th>
						<td colspan="3" class="left">
							<a href="javascript:doJob();"		class="basic authA">작업</a>
							<a href="javascript:cancelJob();"	class="basic authA">작업취소</a>
						</td>
					</tr>
					<tr>
						<th>연말정산 마감여부</th>
						<td colspan="3" class="left">
							<input type="checkbox" class="checkbox" style="vertical-align:middle;" id="calcuFinishedImg" name="calcuFinishedImg" disabled>
							<a href="javascript:finishAll();"	class="basic authA">마감</a>
							<a href="javascript:cancelAll();"	class="basic authA">마감취소</a>
						</td>
					</tr>
				</table>
				<div class="outer">
					<ul>
						<li id="txt" class="txt"> </li>
						<li class="btn">
							<a href="javascript:openProcessStatus();" class="pink large">작업현황</a>
							<a href="javascript:openPatchGuide();"	  class="pink large">패치현황</a>
							<a href="javascript:openFaqPop();"	  	  class="pink large">FAQ</a>
						</li>
					</ul><br>
					<ul>

						<li id="txt" class="txt"> </li>
						<li class="btn">
							<a href="javascript:optPop();"				class="blue large">연말정산옵션</a>
							<a href="javascript:openPeopleSet();"		class="basic large">대상자정보</a>
							<a href="javascript:openYEACalRetry();"		class="basic large">재계산대상자선정</a>
							<a href="javascript:optPopBranch();"    	class="basic large">사업장관리</a>
						</li>
					</ul>
				</div>
			</td>
			<td>
			</td>
			<td class="top">
				<div class="h25"></div>
				<div class="explain">
					<div class="title">작업설명</div>
					<div class="txt">
						<ul>
							<li>1. 작업할 연도를 선택한 후에 작업을 수행합니다.</li>
					        <li>2. 대상자정보에서 대상자를 등록,작업할 대상자를 선택 저장합니다.</li>
					        <li>3. 연급여생성,세금계산을 체크하여 [작업]을 실행합니다.</li>
					        <li style="padding-left:13px;">연급여생성 : 급여내역을 가져오며 연급여내역관리에서</li>
					        <li style="padding-left:76px;">확인 및 수정을 하실 수 있습니다.</li>

					        <li style="padding-left:13px;">세금계산 : 근로소득세액을 세법에 따라 계산하여</li>
					        <li style="padding-left:63px;"> 기납부세액과의 차감세액을 산출합니다.</li>

					        <li>4. 작업이 종료되면 [마감] 버튼을 클릭하여 마감처리</li>
					        <li>5. 마감후 재작업을 하시려면 [마감취소] 버튼을 눌러</li>
					        <li style="padding-left:13px;">취소 처리후 작업을 하실 수 있습니다.</li>
						</ul>
					</div>
				</div>
			</td>
		</tr>
	</table>
	<span class="hide">
		<script type="text/javascript">createIBSheet("sheet1", "100%", "100px"); </script>
		<script type="text/javascript">createIBSheet("sheet2", "100%", "100px"); </script>
	</span>
</div>
</body>
</html>