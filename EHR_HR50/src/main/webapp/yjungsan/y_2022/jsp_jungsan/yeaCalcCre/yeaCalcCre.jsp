<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>연말정산계산</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%String ssnSearchType = (String)session.getAttribute("ssnSearchType");%>

<script type="text/javascript">
	var pGubun = "";

	//급여계산중이거나, 급여계산취소 중이면 true
	var waitFlag    = false;
	var msg = "";

	var newIframe;
	var oldIframe;
	var iframeIdx;
	var tabObj;
	var tabAreaWidthRate = 0;

	$(function() {

        $("#menuNm").val($(document).find("title").text()); //엑셀,CURD
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

		getActionCd("init") ;//연말정산 payActionCd,Nm 가져옴
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


		// Tab 기능 추가
		tabAreaWidthRate = $("#sheet_main_table > colgroup > col").last().attr("width").replace(/[^0-9]/g, "");
		tabObj = $( "#tabs" ).tabs({
			beforeActivate: function(event, ui) {
				if( -1 < ui.oldTab.index() ) {
					try{
						if( $(ui.oldPanel).find('iframe')[0].contentWindow.sheetChangeCheck() ) {
							if ( !confirm("현재 화면에서 저장되지 않은 내역이 있습니다.\n\n무시하고 이동하시겠습니까? ") ) {
								return false;
							}
						}
					} catch(e) {}
				}

				iframeIdx = ui.newTab.index();
				newIframe = $(ui.newPanel).find('iframe');
				oldIframe = $(ui.oldPanel).find('iframe');
				showIframe();
			}
		});

		createTabFrame();
	});

	// 총급여생성 조회
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
		if(OrgAuthStatus.Data.use_yn != "0") {
			$("#org_auth_open_yn").prop("checked", true);
		}
		else {
			$("#org_auth_open_yn").prop("checked", false);
		}
	}

    //담당자마감여부
    function getApprvYn(){
        var getApprvYn = ajaxCall("<%=jspPath%>/yeaCalcCre/yeaCalcCreRst.jsp?cmd=getApprvYn", $("#sheetForm").serialize(), false);
        if(getApprvYn.Data.apprv_yn != "N") {
            $("#apprvYnTotal").prop("checked", true);
        }
        else {
            $("#apprvYnTotal").prop("checked", false);
        }
    }

    //계산결과오픈여부
    function getResOpenYn(){
        var getResOpenYn = ajaxCall("<%=jspPath%>/yeaCalcCre/yeaCalcCreRst.jsp?cmd=getResOpenYn", $("#sheetForm").serialize(), false);
        if(getResOpenYn.Data.result_open_yn != "N") {
            $("#resOpenTotal").prop("checked", true);
        }
        else {
            $("#resOpenTotal").prop("checked", false);
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
        // 2020-10-16 총급여생성 세팅
        getCpnMonpay();
		// 2020-11-16 연말정산가족사항추출
		getCpnYeaFam();
		// 2020-11-16 임직원메뉴오픈
		getOrgAuthOpen();
	    //2021-11.01
        //담당자마감,계산결과오픈
        getApprvYn();
        getResOpenYn();
		// 급여일자 생성버튼
		if($("#searchPayActionCd").val() != ""){
			$("#saveYeaCalCreBtn").hide();
		}else{
			$("#saveYeaCalCreBtn").show();
		}

		if(arguments.length > 0 && arguments[0] == "init") {
			showIframe();
		}
		else {
			getProcessStatus();
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

		if(arguments.length > 0 && arguments[0] == "init") {
			sheetSearch(arguments[0]);
		}
		else {
			sheetSearch();
		}
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
			alert($("#searchWorkYy").val()+"년도 연말정산일자가 등록되지 않았습니다.\n상단에 일자를 등록하세요.");
			return false;
		}
		return true;
	}

	//연말정산 마감여부 체크
	function setCloseImg(){
		if(sheet1.GetCellValue(1, 'final_close_yn') == "Y") {
			$(':checkbox[name=calcuFinishedImg]').prop("checked", true);
		} else{
			$(':checkbox[name=calcuFinishedImg]').prop("checked", false);
		}
	}

	//대상 정보
	function setPeopleStatusCnt() {
        // 변경된 작업 인원 효과
        $("#peopleTotalCnt").removeClass("blue");
        $("#peoplePCnt").removeClass("blue");
        $("#peopleJCnt").removeClass("blue");
        $("#finalCloseYCnt").removeClass("blue");
        $("#finalCloseNCnt").removeClass("blue");

        var prePeopleTotalCnt = $("#peopleTotalCnt").html();
        var prePeoplePCnt = $("#peoplePCnt").html();
        var prePeopleJCnt = $("#peopleJCnt").html();
        var preFinalCloseYCnt = $("#finalCloseYCnt").html();
        var preFinalCloseNCnt = $("#finalCloseNCnt").html();

        $("#peopleTotalCnt").html(comma(sheet2.GetCellValue(1, "t_cnt"))) ;
        $("#peoplePCnt").html(comma(sheet2.GetCellValue(1, "p_cnt"))) ;
        $("#peopleJCnt").html(comma(sheet2.GetCellValue(1, "j_cnt"))) ;
        $("#finalCloseYCnt").html(comma(sheet2.GetCellValue(1, "final_y_cnt"))) ;
        $("#finalCloseNCnt").html(comma(sheet2.GetCellValue(1, "final_n_cnt"))) ;

        var surPeopleTotalCnt   = sheet2.GetCellValue(1, "t_cnt");
        var surPeoplePCnt       = sheet2.GetCellValue(1, "p_cnt");
        var surPeopleJCnt       = sheet2.GetCellValue(1, "j_cnt");
        var surFinalCloseYCnt   = sheet2.GetCellValue(1, "final_y_cnt");
        var surFinalCloseNCnt   = sheet2.GetCellValue(1, "final_n_cnt");

		// 작업대상전체 체크박스 제어
		if(sheet2.GetCellValue(1, "t_cnt") != "0" && sheet2.GetCellValue(1, "t_cnt") == sheet2.GetCellValue(1, "p_cnt")) {
			$(':checkbox[name=peoplePTotal]').prop("checked", true);
		} else {
			$(':checkbox[name=peoplePTotal]').prop("checked", false);
		}
		if($("#payMonChk").is(":checked") == true) $(':checkbox[name=payMonChk]').prop("checked", false);
		if($("#taxMonChk").is(":checked") == true) $(':checkbox[name=taxMonChk]').prop("checked", false);

		if(prePeopleTotalCnt != "" && prePeoplePCnt != "" && prePeopleJCnt != "" && preFinalCloseYCnt != "" && preFinalCloseNCnt != "") {
			if(prePeopleTotalCnt != surPeopleTotalCnt) {
				$("#peopleTotalCnt").addClass("blue");
			}
			if(prePeoplePCnt != surPeoplePCnt) {
				$("#peoplePCnt").addClass("blue");
			}
			if(prePeopleJCnt != surPeopleJCnt) {
				$("#peopleJCnt").addClass("blue");
			}
			if(preFinalCloseYCnt != surFinalCloseYCnt) {
				$("#finalCloseYCnt").addClass("blue");
			}
			if(preFinalCloseNCnt != surFinalCloseNCnt) {
				$("#finalCloseNCnt").addClass("blue");
			}
		}
	}
    //콤마찍기
    function comma(str) {
        str = String(str);
        return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
    }
    //콤마해제
    function reComma(str) {
        str = String(str);
        return str.replace(/,/g, "");
    }
	// 총급여생성 체크(작업/작업 취소 관련 저장 체크)
	function fn_payMonChkYn(){
		if($("#searchBizPlaceCd").val().length > 0){
			alert("사업장을 전체로 선택해 주십시오.\n총급여생성은 관리자만 할 수 있습니다.");
			if($("#payMonChk").is(":checked") == true) $(':checkbox[name=payMonChk]').prop("checked", false);
			else $(':checkbox[name=payMonChk]').prop("checked", true);
			return;
		}
	}

	// 총급여생성 저장(삭제후생성/신규만 생성 저장 체크)
	function fn_checkMonpayYn(){
		if($("#searchBizPlaceCd").val().length > 0){
			alert("사업장을 전체로 선택해 주십시오.\n총급여생성은 관리자만 할 수 있습니다.");
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
				$("input:radio[name='cpn_yea_family_yn']").filter("input[value='0']").attr("checked",false);
			}
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
			if(!$("#org_auth_open_yn").prop("checked")){
				if(confirm("임직원공통 권한에 대해 연말정산 메뉴 오픈을 취소하시겠습니까?")){
					var params = $("#sheetForm").serialize();
					params += "&useyn=N";
					ajaxCall("<%=jspPath%>/yeaCalcCre/yeaCalcCreRst.jsp?cmd=saveOrgAuthStatus",params,false);
				}else{
					orgAuthOpenChkSet();//임직원메뉴오픈 체크값 세팅
					return;
				}
			}
			//메뉴오픈(NO -> YES)
			else{
				if(confirm("임직원공통 권한에 대해 연말정산 메뉴를 오픈 하시겠습니까?")){
					if($("#org_auth_open_yn").prop("checked")){
						var params = $("#sheetForm").serialize();
						params += "&useyn=Y";
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
		if($("#org_auth_open_yn").prop("checked") == true){
			$("#org_auth_open_yn").prop("checked", false);
		}else{
			$("#org_auth_open_yn").prop("checked", true);
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
			var rv = openPopup("<%=jspPath%>/yeaCalcCre/yeaCalcCrePeoplePopup.jsp?authPg=<%=authPg%>",args,"1000","580");
			//sheetSearch();
		}
	}

    //퇴직정산대상자  팝업
    function openRetirePeople(){

        if(checkSelect()){
            var args    = new Array();
            args["searchWorkYy"]        = $("#searchWorkYy").val() ;
            args["searchPayActionNm"]   = $("#searchPayActionNm").val();
            args["searchPayActionCd"]   = $("#searchPayActionCd").val();
            args["searchAdjustType"]    = $("#searchAdjustType").val() ;
            args["searchBizPlaceCd"]    = $("#searchBizPlaceCd").val() ;

            if(!isPopup()) {return;}
            pGubun = "yeaCalcRetirePeoplePopup";
            var rv = openPopup("<%=jspPath%>/yeaCalcCre/yeaCalcRetirePeoplePopup.jsp?authPg=<%=authPg%>",args,"900","580");
        }
    }

	//재계산 대상자 작업 팝업
	function openYEACalRetry() {
// 		if(waitFlag) return;
// 		if(!checkPayActionCd()) return;

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
		var rv = openPopup("<%=jspPath%>/yeaCalcCre/yeaCalcCreOptionPopup.jsp?authPg=<%=authPg%>",args,"910","750");
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
        var rv = openPopup("<%=jspPath%>/yeaCalcCre/yeaCalcBranchOptionPopup.jsp?authPg=<%=authPg%>",args,"850","450");

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
				alert("수행할 작업(총급여생성 or 세금계산)을 선택해주세요.");
				return;
			} else {
				msg = "연말정산계산";
				payFlag = "FALSE";
				taxFlag = "TRUE";
			}
		} else {
			msg = "총급여생성";
			if(!$("#taxMonChk").is(":checked")){
				payFlag = "TRUE";
				taxFlag = "FALSE";

			} else {
				msg =  "총급여생성, 연말정산계산";
				payFlag = "TRUE";
				taxFlag = "TRUE";
			}
		}

		if(checkSelect()){
			if($("#peoplePCnt").html() == "0"){
				alert("대상인원이 없습니다.");
				return;
			}
			if(confirm($("#searchWorkYy").val() + "년 " + msg + " 작업을 시작하시겠습니까?")){

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
			if(confirm("연말정산계산 작업을 취소 하시겠습니까?")){
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

		if(reComma($("#peopleTotalCnt").html())*1 == 0){
			alert("총인원이 존재하지 않습니다.\n마감할 수 없습니다.");
			return;
		}

		if(reComma($("#peopleTotalCnt").html()) != reComma($("#peopleJCnt").html())){
			alert("총인원과 작업완료인원이 일치하지 않습니다.\n마감할 수 없습니다.");
			return;
		}

		if(checkSelect()){
	        if(confirm("최종마감시 임직원들에게 계산내역이 오픈됩니다.\n최종 마감하시겠습니까?")){
				var params = $("#sheetForm").serialize()+"&searchFinalCloseYN=Y";
				//TCPN811 & TCPN983 UPDATE!
				ajaxCall("<%=jspPath%>/yeaCalcCre/yeaCalcCreRst.jsp?cmd=saveFinalCloseYn",params,false);

				sheetSearch();
	        }
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

			if(sheet1.GetCellValue(1, 'final_close_yn') != "Y"){
				alert("마감된 경우만 마감취소할 수 있습니다.");
				return;
			}

			var params = $("#sheetForm").serialize()+"&searchFinalCloseYN=N";
			//TCPN811 & TCPN983 UPDATE!
			ajaxCall("<%=jspPath%>/yeaCalcCre/yeaCalcCreRst.jsp?cmd=saveFinalCloseYn",params,false);

			sheetSearch();
		}

	}

	//급여일자가 선택되었는지 체크
	function checkSelect(){
		if($("#searchPayActionCd").val() == ""){
			alert($("#searchWorkYy").val()+"년도 연말정산일자가 등록되지 않았습니다.\n상단에 일자를 등록하세요.");
			if($("#peoplePTotal").is(":checked") == true) $(':checkbox[name=peoplePTotal]').prop("checked", false);
			else $(':checkbox[name=peoplePTotal]').prop("checked", true);
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
			if($("#peoplePTotal").is(":checked") == true) $(':checkbox[name=peoplePTotal]').prop("checked", false);
			else $(':checkbox[name=peoplePTotal]').prop("checked", true);
			return;
		}

		if( parseInt($("#peopleJCnt").html(),10) > 0){
			alert("작업완료인원이 존재합니다.\n작업취소를 먼저하세요!");
			if($("#peoplePTotal").is(":checked") == true) $(':checkbox[name=peoplePTotal]').prop("checked", false);
			else $(':checkbox[name=peoplePTotal]').prop("checked", true);
			return;
		}

		var confirmMsg = "";
		if($("#peoplePTotal").is(":checked") == true){
			confirmMsg = "총인원 전체를 작업대상인원으로 변경하시겠습니까?";
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
					$(':checkbox[name=peoplePTotal]').prop("checked", false);
				} else {
					$(':checkbox[name=peoplePTotal]').prop("checked", true);
				}
			}
		}
	}

	// 연말정산 급여일자 생성
	function saveYeaCalCre(){

		var confirmMsg = "";
		var ssnSearchType  = "<%=removeXSS(ssnSearchType, '1')%>";
        var sysWorkUpYn = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=SYS_WORKUP_YN", "queryId=getSystemStdData",false).codeList;
        var cmd = "";

        if(sysWorkUpYn.length > 0 && (sysWorkUpYn != "" || sysWorkUpYn != null)){
            if(sysWorkUpYn[0].code_nm == "Y"){
                cmd = "insertYeaPayDayTCPN201_sys";
            }else{
                cmd = "insertYeaPayDayTCPN201";
            }
        }else{
            cmd = "insertYeaPayDayTCPN201";
        }

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
					confirmMsg = $("#searchWorkYy").val()+ "년 연말정산을 생성하시겠습니까?";
					if(confirm(confirmMsg)){
						ajaxCall("<%=jspPath%>/yeaCalcCre/yeaCalcCreRst.jsp?cmd="+cmd, $("#sheetForm").serialize(),false);
					}
					getActionCd();
				}
			}
		}

	}

	// 대상자생성
	function peopleCre(){

	    if($("#searchPayActionCd").val() != ""){

	    	if(sheet2.GetCellValue(1, "t_cnt") > 0){
	            alert("이미 대상자가 존재할 때, 대상자 재생성은 진행되지 않습니다."
	                    + "\n자세한 정보는 대상자관리 버튼을 클릭하여 확인하여 주시기 바랍니다");
	            return;
	        }else{
	        	if(confirm("대상자 생성하시겠습니까?")){
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
	        }
	    }else{
	        alert("연말정산 생성 후 대상자 생성이 가능합니다."
	        		+"\n연말정산을 먼저 생성해 주시기 바랍니다.");
	        return;
	    }
	}

	function bizPlOnChange() {
		if($("#searchBizPlaceCd").val() != ""){
			$("#bizPlFont").show();
		} else $("#bizPlFont").hide();
	}

	//담당자마감 일괄마감,취소(체크박스)
    function apprvYnChk(){

        var chkYn      = "N";
        var confirmMsg  = "";

        if($("#apprvYnTotal").prop("checked")) {
            //마감 취소 -> 마감
            chkYn     = "Y";
            confirmMsg = "마감";
        }
        else {
            //마감 -> 마감 취소
            if($("#resOpenTotal").prop("checked")) {
                //계산결과오픈 취소 후 마감 취소가 가능함.
                alert("계산결과오픈이 되어있습니다.\n계산결과오픈 취소 후 담당자마감 취소가 가능합니다.");
                $("#apprvYnTotal").prop("checked", true);
                return;
            }
            confirmMsg = "마감 취소";
        }

        //담당자 마감
        apprvYnConfirm(chkYn, confirmMsg);
    }

    // 담당자 마감,마감취소
    function apprvYnConfirm(chkYn, msg){
        var bizPlNm = $("#searchBizPlaceCd option:selected").text();

        if(confirm("사업장 " + bizPlNm + " 인원들에 대해 일괄 " + msg + " 하시겠습니까?")) {

            params = $("#sheetForm").serialize();
            params += "&apprvYnTotal="+chkYn;

            var data = ajaxCall("<%=jspPath%>/yeaCalcCre/yeaCalcCreRst.jsp?cmd=saveApprvYn",params,false);

            if(data.Result.Code == 1) {
                if($("#apprvYnTotal").prop("checked")) {
                    $("#apprvYnTotal").prop("checked", false);
                }else{
                    $("#apprvYnTotal").prop("checked", true);
                }
                sheetSearch();
            }
        }
        else {
            if($("#apprvYnTotal").prop("checked")) {
                $("#apprvYnTotal").prop("checked", false);
            }else{
                $("#apprvYnTotal").prop("checked", true);
            }
        }
    }

    // 계산결과오픈,오픈 취소(체크박스)
    function resOpenChk(){

        var chkYn      = "N";
        var confirmMsg  = "";

        if($("#resOpenTotal").is(":checked") == true) {
            //오픈 취소 -> 오픈
            if(!$("#apprvYnTotal").prop("checked")){
                // 담당자마감 후 계산결과오픈이 가능함.
            	alert("담당자마감 되지 않은 건이 있습니다.\n[소득공제자료관리>자료입력/마감현황] 에서 확인해주십시오.");
                $("#resOpenTotal").prop("checked", false);
                return;
            }
            chkYn     = "Y";
            confirmMsg = "오픈";
        }
        if($("#resOpenTotal").is(":checked") != true) {
            //오픈 -> 오픈 취소
            confirmMsg = "오픈취소";
        }

        //담당자 마감
        resOpenConfirm(chkYn, confirmMsg);
    }

    // 계산결과오픈, 오픈취소
    function resOpenConfirm(chkYn, msg){
        var bizPlNm     = $("#searchBizPlaceCd option:checked").text();

        if(confirm("사업장 " + bizPlNm + " 인원들에 대해 일괄 " + msg + " 하시겠습니까?")) {

            params = $("#sheetForm").serialize();
            params += "&resOpenTotal="+chkYn;

            var data = ajaxCall("<%=jspPath%>/yeaCalcCre/yeaCalcCreRst.jsp?cmd=saveResOpenYn",params,false);

            if(data.Result.Code == 1) {
                if($("#resOpenTotal").prop("checked")) {
                    $("#resOpenTotal").prop("checked", false);
                }else{
                    $("#resOpenTotal").prop("checked", true);
                }
                sheetSearch();
            }
        }
        else {
            if($("#resOpenTotal").prop("checked")) {
                $("#resOpenTotal").prop("checked", false);
            }else{
                $("#resOpenTotal").prop("checked", true);
            }
        }
    }

	function getProcessStatus() {
		var iframeObj = $("#tabs-1 iframe")[0];
		var ifrm = iframeObj.contentWindow || iframeObj.contentDocument;

		if(!iframeObj.src.match("hidden.jsp")) {
			ifrm.document.sheetForm.searchBusinessCd.value = $("#searchBizPlaceCd option:selected").val();
			ifrm.hidePopup();
			ifrm.getProcessStatus();
		}

	}

	// 탭 생성
	function createTabFrame() {

		tabObj.find(".ui-tabs-nav")
		.append("<li><a href='#tabs-1' id='tabs1'>작업현황</a></li>")
		.append("<li><a href='#tabs-2' id='tabs2'>FAQ</a></li>")
		.append("<li><a href='#tabs-3' id='tabs3'>패치현황</a></li>")
		;

		// 일부사이트 top:98px 이어야 함.
		tabObj
		.append("<div id='tabs-1'><div class='layout_tabs' style='top:82px;'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
		.append("<div id='tabs-2'><div class='layout_tabs' style='top:82px;'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
		.append("<div id='tabs-3'><div class='layout_tabs' style='top:82px;'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
		;

		$("#tabs")
		.append("<div id='btnProcStaReload'><a href='javascript:getProcessStatus();' class='basic btn-white ico-reload' style='float:right; top:6px;'>새로고침</a></div>")
		;

		newIframe = $('#tabs-1 iframe');
		iframeIdx = 0;

		tabObj.tabs( "refresh" );
		tabObj.tabs( "option", "active", 0 );

		$(".ui-tabs-nav").css("position", "absolute");
	}

	//탭로딩
	function showIframe() {
		if(typeof oldIframe != 'undefined') {
			oldIframe.attr("src","<%=jspPath%>/common/hidden.jsp");
		}

		var authPg = "A";
		//원래권한으로 이페이지는 항상 관리자용으로 A이다.
		var orgAuthPg = "<%=authPg%>";

		if(iframeIdx == 0) {
			$("#btnProcStaReload").show();
			newIframe.attr("src","<%=jspPath%>/yeaCalcCre/yeaCalcProcessStatusPopup.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
		} else if(iframeIdx == 1) {
			$("#btnProcStaReload").hide();
			newIframe.attr("src","<%=jspPath%>/yeaCalcCre/yeaCalcCreFaqPopup.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
		} else if(iframeIdx == 2) {
			$("#btnProcStaReload").hide();
			newIframe.attr("src","<%=jspPath%>/yeaCalcCre/yeaCalcPatchGuidePopup.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
		}

		dynamicResizeTabs($(window).width(), tabAreaWidthRate);
	}

	// Browser Resize시 Tab Width 재셋팅
	function dynamicResizeTabs(windowSize, rate) {
		$(".layout_tabs").width(parseInt(parseInt(windowSize) / 100 * parseInt(rate)));
	}

	$(window).resize(function() {
		var timer = setTimeout(function() {
			dynamicResizeTabs($(window).width(), tabAreaWidthRate);
		}, 100);

		//clearTimeout(timer);
	});

</script>
</head>
<body class="hidden">
<div id="progressCover" style="display:none;top:0;bottom:0;left:0;right:0;background:url(<%=imagePath%>/common/process.png) no-repeat 50% 50%;"></div>
<div class="wrapper">
	<form id="sheetForm" name="sheetForm">
		<input type="hidden" id="searchAdjustType" name="searchAdjustType" value="1" />
		<input type="hidden" id="searchPayActionCd" name="searchPayActionCd" value="">
		<input type="hidden" id="menuNm" name="menuNm" value="" />
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td> <span>연도</span>
							<%
							if(!"SH".equals(session.getAttribute("ssnEnterCd")) && !"GT".equals(session.getAttribute("ssnEnterCd")) && !"FMS".equals(session.getAttribute("ssnEnterCd")) && !"CSM".equals(session.getAttribute("ssnEnterCd")) && !"SHN".equals(session.getAttribute("ssnEnterCd"))){
							%>
								<input type="text" id="searchWorkYy" name="searchWorkYy" maxlength="4" class="text w35 center readonly" onFocus="this.select()" value=""  readonly/>
							<%}else{%>
								<input type="text" id="searchWorkYy" name="searchWorkYy" maxlength="4" class="text w35 center readonly" onFocus="this.select()" value=""  readonly/>
							<%}%>
						</td>
						<td>
							<span>사업장</span>
							<select id="searchBizPlaceCd" name ="searchBizPlaceCd" onChange="sheetSearch();bizPlOnChange();" class="box">
								<option value="" selected="selected">전체</option>
							</select>
						</td>
						<td>
							<a href="javascript:getActionCd();" id="btnSearch" class="button">조회</a>
						</td>
						<td>
							<font id="bizPlFont" class="blue">※ 사업장별 작업은 대상자생성, 세금계산, 작업현황만 하실 수 있습니다.</font>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main" id="sheet_main_table">
		<colgroup>
			<col width="55%" />
			<col width="1%" />
			<col width="44%" />
		</colgroup>
		<tr>
			<td class="top center">
				<div class="sheet_title clearfix">
					<ul class="float-left">
						<li id="txt" class="txt">작업진행</li>
					</ul>
					<ul class="float-right">
						<li class="txt">
							<span><a href="javascript:optPop();" class="basic btn-white">연말정산옵션</a></span>
							<span><a href="javascript:optPopBranch();" class="basic btn-white">사업장 관리</a></span>
							<!-- <span><a class="basic btn-white out-line">대상자 설정</a></span> -->
							<span style="margin-left: 12px;">
								<label for="peoplePTotal"><input type="checkbox" class="checkbox" style="vertical-align:middle;" id="peoplePTotal" name="peoplePTotal" value="N" onClick="javascript:clickPeoplePTotal();"> 작업대상전체</label>
							</span>
							<span><a href="javascript:doJob();" class="basic btn-red ico-calc authA">작업</a></span>
							<span><a href="javascript:cancelJob();"	class="basic authA">작업취소</a></span>
						</li>
					</ul>
				</div>
				<table border="0" cellpadding="0" cellspacing="0" class="default" style="table-layout: fixed;">
					<colgroup>
						<col width="25%" />
						<col width="25%" />
						<col width="20%" />
						<col width="30%" />
					</colgroup>
					<tr>
						<th>연말정산 급여일자</th>
						<td colspan="3" class="left">
							<a href="javascript:saveYeaCalCre();" id="saveYeaCalCreBtn" class="basic authA">생성</a>
							<input type="text" id="searchPayActionNm" name="searchPayActionNm" class="text w150 readonly transparent" value="" readonly/>

						</td>
					</tr>
					<tr>
						<th rowspan="3">대상자관리</th>
						<td colspan="3" class="left">
							<input type="radio"	class="radio" name="cpn_yea_family_yn" id="cpn_yea_family_yn1" value="-1" onchange="javascript:fn_checkYeaFamYn();">
							<label for="cpn_yea_family_yn1">작년 연말정산 부양가족</label>&nbsp;&nbsp;&nbsp;
							<input type="radio" class="radio" name="cpn_yea_family_yn" id="cpn_yea_family_yn2" value="0" onchange="javascript:fn_checkYeaFamYn();">
							<label for="cpn_yea_family_yn2">인사기본 가족사항</label>
						</td>
					</tr>
					<tr>
						<td colspan="3" class="left">
							<a href="javascript:peopleCre();" class="basic btn-white out-line authA">대상자생성</a>&nbsp;&nbsp;
							<a href="javascript:openPeopleSet();" class="basic btn-white out-line ico-popup">대상자 관리</a>&nbsp;&nbsp;
							<a href="javascript:openYEACalRetry();" class="basic btn-white out-line ico-popup">재계산 대상자 선정</a>
						</td>
					</tr>
                    <tr>
                        <td colspan="3" class="left">
                            <a href="javascript:openRetirePeople();" class="basic btn-white ico-popup">퇴직정산 신고인원관리</a>&nbsp;&nbsp;
                        </td>
                    </tr>
					<tr>
						<th>총급여생성</th>
						<td colspan="3" class="left">
							<span id="chkTmp1">
								<input type="checkbox" class="checkbox" id="payMonChk" name="payMonChk" onchange="javascript:fn_payMonChkYn();" value="N" style="vertical-align: middle;">
								<label for="payMonChk" class="red"><strong>총급여 생성하기</strong></label>&nbsp;&nbsp;&nbsp;
							</span>
							<input type="radio"	class="radio" name="cpn_monpay_return_yn" id="cpn_monpay_return_yn1" value="Y" onchange="javascript:fn_checkMonpayYn();">
							<label for="cpn_monpay_return_yn1">삭제후재생성</label>&nbsp;&nbsp;&nbsp;
							<input type="radio" class="radio" name="cpn_monpay_return_yn" id="cpn_monpay_return_yn2" value="N" onchange="javascript:fn_checkMonpayYn();">
							<label for="cpn_monpay_return_yn2">신규인원만생성</label>
						</td>
					</tr>
					<tr>
						<th>세금계산</th>
                        <td colspan="3" class="left">
							<span>
								<input type="checkbox" class="checkbox" id="taxMonChk" name="taxMonChk" value="N" style="vertical-align: middle;">
								<label for="taxMonChk" class="red"><strong>세금 계산하기</strong></label>&nbsp;&nbsp;
							</span>
						</td>
                    </tr>
                    <tr>
						<th>임직원메뉴오픈</th>
                        <td colspan="3" class="left">
							<span>
								<input type="checkbox"class="checkbox" id="org_auth_open_yn" name="org_auth_open_yn" style="vertical-align: middle;" onclick="javascript:fn_checkOrgAuthYn();">
							</span>
						</td>
					</tr>
                    <tr>
                        <th>담당자마감</th>
                        <td colspan="3" class="left">
							<span>
								<input type="checkbox" class="checkbox" id="apprvYnTotal" name="apprvYnTotal" style="vertical-align:middle;" onclick="javascript:apprvYnChk();">
							</span>
						</td>
                    </tr>
                    <tr>
                        <th>계산결과오픈</th>
                        <td colspan="3" class="left">
							<span>
								<input type="checkbox" class="checkbox" id="resOpenTotal" name="resOpenTotal" style="vertical-align:middle;" onclick="javascript:resOpenChk();">
							</span>
						</td>
                    </tr>
				</table>
				<div class="sheet_title clearfix">
					<ul class="float-left">
						<li id="txt" class="txt">작업결과</li>
					</ul>
					<ul class="float-right">
						<li class="txt">
							<span>
								<label for="checkDeadline"><input type="checkbox" class="checkbox" style="vertical-align:middle;" id="calcuFinishedImg" name="calcuFinishedImg" disabled> <b>연말정산 마감여부</b></label>
							</span>
							<span><a href="javascript:finishAll();" class="basic btn-blue ico-finish authA">마감</a></span>
							<span><a href="javascript:cancelAll();"	class="basic authA">마감취소</a></span>
						</li>
					</ul>
				</div>
				<table border="0" cellpadding="0" cellspacing="0" class="status-table" style="table-layout: fixed;">
					<colgroup>
						<col width="20%" />
						<col width="20%" />
						<col width="20%" />
						<col width="20%" />
						<col width="20%" />
					</colgroup>
					<tr>
						<td class="box-item">
							<p class="item-title">총인원</p>
							<div class="item-desc">
								<span id="peopleTotalCnt"></span>
								<span class="unit">명</span>
							</div>
						</td>
						<td class="box-item">
							<p class="item-title">작업대상인원</p>
							<div class="item-desc">
								<span id="peoplePCnt"></span>
								<span class="unit">명</span>
							</div>
						</td>
						<td class="box-item">
							<p class="item-title">작업완료인원</p>
							<div class="item-desc">
								<span id="peopleJCnt"></span>
								<span class="unit">명</span>
							</div>
					</td>
						<td class="box-item">
							<p class="item-title">미마감인원</p>
							<div class="item-desc">
								<span id="finalCloseNCnt"></span>
								<span class="unit">명</span>
							</div>
						</td>
						<td class="box-item">
							<p class="item-title">마감인원</p>
							<div class="item-desc">
								<span id="finalCloseYCnt"></span>
								<span class="unit">명</span>
							</div>
						</td>
					</tr>
				</table>
				<!--
				<div class="status-box">
					<div class="box-item">
						<p class="item-title">총인원</p>
						<div class="item-desc">
							<span id="peopleTotalCnt"></span>
							<span class="unit">명</span>
						</div>
					</div>
					<div class="box-item hide">
						<p class="item-title">대상인원</p>
						<div class="item-desc">
							<span id=people811Cnt></span>
							<span class="unit">명</span>
						</div>
					</div>
					<div class="box-item">
						<p class="item-title">작업대상인원</p>
						<div class="item-desc">
							<span id="peoplePCnt"></span>
							<span class="unit">명</span>
						</div>
					</div>
					<div class="box-item">
						<p class="item-title">작업완료인원</p>
						<div class="item-desc">
							<span id="peopleJCnt"></span>
							<span class="unit">명</span>
						</div>
					</div>
					<div class="box-item">
						<p class="item-title">미마감인원</p>
						<div class="item-desc">
							<span id="finalCloseNCnt"></span>
							<span class="unit">명</span>
						</div>
					</div>
					<div class="box-item">
						<p class="item-title">마감인원</p>
						<div class="item-desc">
							<span id="finalCloseYCnt"></span>
							<span class="unit">명</span>
						</div>
					</div>
				</div>
				-->
			</td>
			<td>
			</td>
			<td class="top">
				<!-- 탭이 들어가야하는 위치 -->
				<div style="top:125px;" id="div_insa_tab">
					<div id="tabs" class="tab"><ul></ul></div>
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