<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>발령처리세부내역</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

	var p = eval("${popUpStatus}");
	var arg = p.popDialogArgumentAll();
	var sabun = arg['sabun'];
	var name = arg['name'];
	var ordDetailCd = arg['ordDetailCd'];
	var ordDetailNm = arg['ordDetailNm'];
	var ordYmd = arg['ordYmd'];
	var applySeq = arg['applySeq'];
	var ordEYmd = arg['ordEYmd'];
	var sStatus = arg['sStatus'];
	var ordYnTemp = arg['ordYnTmp'];
	var ordReasonCd_ = arg['ordReasonCd'];
	var ordTypeCd = arg['ordTypeCd'];

	$(function() {

        $(".close").click(function() {
	    	p.self.close();
	    });

		var statusCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10010"), " ");
		var manageCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10030"), " ");
		var locationCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getLocationCdList",false).codeList, "");	//LOCATION
		var jikchakCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20020"), " ");
		var workType = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10050"), " ");
		var paybandCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10120"), " ");
		
		var jikweeCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20030"), " ");
		var payType = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10110"), " ");
		var jikgubCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20010"), " ");
		var payGroupCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20060"), " ");

		var placeWorkCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","T10005"), " ");
		var workTeamCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","T10001"), " ");


		//var ordReasonCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H40110"), " ");
		var ordReasonCd ;
		var ordType = ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdTypeList&searchOrdTypeCd="+ordDetailCd,false) ;
		ordType != null && ordType.codeList.length > 0 && ordType.codeList[0].codeNm != "" ?
		ordReasonCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getComCodeNoteList&searchGrcodeCd=H40110&searchNote1="+ordType.codeList[0].codeNm,false).codeList, " ") : ordReasonCd = "" ;

		var resignReasonCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H40100"), " ");
		var retPathCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H40150"), " ");
		var base1Cd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H90005"), " ");
		//호봉 콤보->입력
// 		var salClass = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C10000"), " ");

		var dispatchEnterCd = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getEnterCdAllList&enterCd=", false).codeList, " ");

		var param = "sabun="+sabun+"&name="+name+"&ordDetailCd="+ordDetailCd+"&ordYmd="+ordYmd+"&applySeq="+applySeq+"&ordTypeCd="+ordTypeCd;

    	var columMap = ajaxCall("/ExecAppmt.do?cmd=getExecAppmtPopColumMap",param,false);

    	var beforeMap = ajaxCall("/ExecAppmt.do?cmd=getExecAppmtPopBeforeMap",param,false);

    	var afterMap = {};

    	if(sStatus == "I") {
        	afterMap = ajaxCall("/ExecAppmt.do?cmd=getExecAppmtPopAfterMap",param,false);
    	} else {
        	afterMap = ajaxCall("/ExecAppmt.do?cmd=getExecAppmtMap",param,false);
    	}

		$('#aDispatchEnterCd').html(dispatchEnterCd[2]);
		$('#aStatusCd').html(statusCd[2]);
		$('#aManageCd').html(manageCd[2]);
		$('#aLocationCd').html(locationCd[2]);
		$('#aJikchakCd').html(jikchakCd[2]);		
		$('#aWorkType').html(workType[2]);
		$('#aPaybandCd').html(paybandCd[2]);
		$('#aJikweeCd').html(jikweeCd[2]);
		$('#aBase1Cd').html(base1Cd[2]);
		$('#aPayType').html(payType[2]);
		$('#aJikgubCd').html(jikgubCd[2]);
		$('#aPayGroupCd').html(payGroupCd[2]);
		//$('#aOrdReasonCd').html(ordReasonCd[2]);
		$('#aResignReasonCd').html(resignReasonCd[2]);
		$('#aRetPathCd').html(retPathCd[2]);
// 		$('#aSalClass').html(salClass[2]);
		$('#aDispatchJikchakCd').html(jikchakCd[2]);

		$('#aPlaceWorkCd').html(placeWorkCd[2]);
		$('#aWorkteamCd').html(workTeamCd[2]);

		$('#sabun').val(sabun);
		$('#name').val(name);
		$('#orgDetailNm').val(ordDetailNm);
		$('#applySeq').val(applySeq);
		$('#orgYmd').val(formatDate(ordYmd,"-"));


		if(beforeMap != null && beforeMap.DATA != null) {
			$("#bStatusNm").val(beforeMap.DATA.statusNm);
			$("#bManageNm").val(beforeMap.DATA.manageNm);
			$("#bLocationNm").val(beforeMap.DATA.locationNm);
			$("#bOrgNm").val(beforeMap.DATA.orgNm);
			$("#bJikchakNm").val(beforeMap.DATA.jikchakNm);
			$("#bWorkTypeNm").val(beforeMap.DATA.workTypeNm);
			$("#bPaybandNm").val(beforeMap.DATA.paybandNm);
			$("#bJobNm").val(beforeMap.DATA.jobNm);
			$("#bJikweeNm").val(beforeMap.DATA.jikweeNm);
			$("#bTraYmd").val(formatDate(beforeMap.DATA.traYmd,"-"));
			$("#bGempYmd").val(formatDate(beforeMap.DATA.gempYmd,"-"));
			$("#bReturnYmd").val(formatDate(beforeMap.DATA.returnYmd,"-"));
			$("#bEmpYmd").val(formatDate(beforeMap.DATA.empYmd,"-"));
			$("#bCtitleChgYmd").val(formatDate(beforeMap.DATA.ctitleChgYmd,"-"));
			$("#bJikgubChgYmd").val(formatDate(beforeMap.DATA.jikgubChgYmd,"-"));
			$("#bFpromYmd").val(formatDate(beforeMap.DATA.fpromYmd,"-"));
			$("#bDispatchEnterNm").val(beforeMap.DATA.dispatchEnterNm);
			$("#bDispatchOrgNm").val(beforeMap.DATA.dispatchOrgNm);
			$("#bDispatchJikchakNm").val(beforeMap.DATA.dispatchJikchakNm);
			$("#bRemoveOrgNm").val(beforeMap.DATA.removeOrgNm);
			$("#bBase1Nm").val(beforeMap.DATA.base1Nm);
			$("#bPayTypeNm").val(beforeMap.DATA.payTypeNm);
			$("#bSalClass").val(beforeMap.DATA.salClass);
			$("#bJikgubNm").val(beforeMap.DATA.jikgubNm);
			$("#bWorkAreaNm").val(beforeMap.DATA.workAreaNm);
			$("#bPayGroupNm").val(beforeMap.DATA.payGroupNm);
			$("#bContractSymd").val(formatDate(beforeMap.DATA.contractSymd,"-"));
			$("#bContractEymd").val(formatDate(beforeMap.DATA.contractEymd,"-"));
			$("#bSgPoint").val(beforeMap.DATA.sgPoint);

			$("#bPlaceWorkNm").val(beforeMap.DATA.placeWorkNm);
			$("#bWorkteamNm").val(beforeMap.DATA.workteamNm);

			$("#bOrdNo").val(beforeMap.DATA.ordNo);
		}

		if(columMap != null && columMap.DATA != null) {

			chgSelect($("#aDispatchEnterCd"), columMap.DATA.dispatchOrgYn, afterMap.DATA.dispatchEnterCd);
			chgSelect($("#aStatusCd"), columMap.DATA.statusYn, afterMap.DATA.statusCd);
			chgSelect($("#aManageCd"), columMap.DATA.manageYn, afterMap.DATA.manageCd);
			chgSelect($("#aLocationCd"), columMap.DATA.locationYn, afterMap.DATA.locationCd);
			chgSelect($("#aJikchakCd"), columMap.DATA.jikchakYn, afterMap.DATA.jikchakCd);
			chgSelect($("#aWorkType"), columMap.DATA.workYn, afterMap.DATA.workType);
			chgSelect($("#aPaybandCd"), columMap.DATA.paybandYn, afterMap.DATA.paybandCd);
			chgSelect($("#aJikweeCd"), columMap.DATA.jikweeYn, afterMap.DATA.jikweeCd);
			chgSelect($("#aBase1Cd"), columMap.DATA.base1CdYn, afterMap.DATA.base1Cd);
			chgSelect($("#aPayType"), columMap.DATA.payTypeYn, afterMap.DATA.payType);
			chgSelect($("#aJikgubCd"), columMap.DATA.jikgubYn, afterMap.DATA.jikgubCd);
			chgSelect($("#aPayGroupCd"), columMap.DATA.payGroupYn, afterMap.DATA.payGroupCd);
			chgSelect($('#aResignReasonCd'), columMap.DATA.retReasonYn, afterMap.DATA.resignReasonCd);
			chgSelect($("#aRetPathCd"), columMap.DATA.retPathYn,afterMap.DATA.retPathCd);

			//호봉 데이터 콤보->입력
// 			chgSelect($("#aSalClass"), columMap.DATA.salClassYn,afterMap.DATA.salClass);
			chgSelect($("#aDispatchJikchakCd"), columMap.DATA.dispatchOrgYn, afterMap.DATA.dispatchJikchakCd);
			chgSelect($("#aDispatchJikchakNm"), columMap.DATA.dispatchOrgYn, afterMap.DATA.dispatchJikchakNm);

			chgSelect($("#aPlaceWorkCd"), columMap.DATA.placeWorkYn, afterMap.DATA.placeWorkCd);
			chgSelect($("#aWorkteamCd"), columMap.DATA.workteamYn, afterMap.DATA.workteamCd);

			chgInput($("#aWorkAreaCd"),$("#aWorkAreaNm"),columMap.DATA.workAreaCdYn, afterMap.DATA.workAreaCd, afterMap.DATA.workAreaNm);

			chgInput($("#aOrgCd"),$("#aOrgNm"),columMap.DATA.orgYn, afterMap.DATA.orgCd, afterMap.DATA.orgNm);
			chgInput($("#aJobCd"),$("#aJobNm"),columMap.DATA.jobYn, afterMap.DATA.jobCd, afterMap.DATA.jobNm);
			chgInput($("#aDispatchOrgCd"),$("#aDispatchOrgNm"),columMap.DATA.dispatchOrgYn, afterMap.DATA.dispatchOrgCd, afterMap.DATA.dispatchOrgNm);
			chgInput($("#aRemoveOrgCd"),$("#aRemoveOrgNm"),columMap.DATA.disOrgYn, afterMap.DATA.removeOrgCd, afterMap.DATA.removeOrgNm);
			chgInput($("#aSgPoint"),$("#aSgPoint"),columMap.DATA.sgPointYn, afterMap.DATA.sgPoint, afterMap.DATA.sgPoint);
			chgInput($("#aSalClass"),$("#aSalClass"),columMap.DATA.salClassYn, afterMap.DATA.salClass, afterMap.DATA.salClass);
			

			chgInput($("#aOrdNo"),$("#aOrdNo"),columMap.DATA.processNoYn, afterMap.DATA.ordNo, afterMap.DATA.ordNo);

			chgDate($("#aTraYmd"),columMap.DATA.traYmdYn, formatDate(afterMap.DATA.traYmd,"-"));
			chgDate($("#aGempYmd"),columMap.DATA.gempYmdYn, formatDate(afterMap.DATA.gempYmd,"-"));
			chgDate($("#aReturnYmd"),columMap.DATA.returnYmdYn, formatDate(afterMap.DATA.returnYmd,"-"));
			chgDate($("#aEmpYmd"),columMap.DATA.empYmdYn, formatDate(afterMap.DATA.empYmd,"-"));
			chgDate($("#aCtitleChgYmd"),columMap.DATA.ctitleChgYmdYn, formatDate(afterMap.DATA.ctitleChgYmd,"-"));
			chgDate($("#aJikgubChgYmd"),columMap.DATA.jikgubChgYmdYn, formatDate(afterMap.DATA.jikgubChgYmd,"-"));
			chgDate($("#aFpromYmd"),columMap.DATA.fpromYmdYn, formatDate(afterMap.DATA.fpromYmd,"-"));
			chgDate($("#aContractSymd"),columMap.DATA.contractYmdYn, formatDate(afterMap.DATA.contractSymd,"-"));
			chgDate($("#aContractEymd"),columMap.DATA.contractYmdYn, formatDate(afterMap.DATA.contractEymd,"-"));
			
			//발령종료예정일
			chgDate($("#ordEYmd"),columMap.DATA.ordEYmdYn, formatDate(ordEYmd,"-"));

			$('#aJikgunNm').val(afterMap.DATA.jikgunNm);
			$('#aJikjongNm').val(afterMap.DATA.jikjongNm);
			$('#memo').val(afterMap.DATA.memo);
			$('#memo2').val(afterMap.DATA.memo2);
			$('#processNo').val(afterMap.DATA.processNo);

			Num_Comma($('#aEnterPay').val(afterMap.DATA.enterPay).get(0));

			if(columMap.DATA.entPayYn == "Y") {
				$('#aEnterPay').attr("class","text right edit").attr("readonly", false);
			} else {
				$('#aEnterPay').attr("class","text right readonly").attr("readonly", true);
			}

	        $("#aEnterPay").bind("keyup",function(event){
	        	makeNumber(this,"A");
	    		Num_Comma(this);
			});

	        if(columMap.DATA.sgPointYn == "Y") {
				$('#aSgPoint').attr("class","text right edit").attr("readonly", false);
			} else {
				$('#aSgPoint').attr("class","text right readonly").attr("readonly", true);
			}
	        
	        
	        //호봉 발령사항 입력
	        if(columMap.DATA.salClassYn == "Y") {
				$('#aSalClass').attr("class","text right edit").attr("readonly", false);
			} else {
				$('#aSalClass').attr("class","text right readonly").attr("readonly", true);
			}

	        $("#aSgPoint, #aSalClass").bind("keyup",function(event){
	        	makeNumber(this,"C");
	    		//Num_Comma(this);
			});

	        if(columMap.DATA.processNoYn == "Y") {
				$('#aOrdNo').attr("class","text right edit").attr("readonly", false);
			} else {
				$('#aOrdNo').attr("class","text right readonly").attr("readonly", true);
			}

		} else {
			alert("항목이 정의되지 않았습니다.");
			p.window.close();
		}
	});

	// 입력박스 형식 CSS 처리
	function chgInput(obj1,obj2,yn,value1,value2) {

		if(yn == "Y") {
			$(obj1).attr("class","text readonly edit").attr("readonly", true);
			$(obj2).attr("class","text edit").attr("readonly", true);
		} else if(yn == "N") {
			$(obj1).attr("class","text readonly").attr("readonly", true);
			$(obj2).attr("class","text readonly").attr("readonly", true);
			$(obj1).parent().find(".button6").addClass("hide");
			$(obj1).parent().find(".button7").addClass("hide");
		}
		$(obj1).val(value1);
		$(obj2).val(value2);
	}

	// DATE 형식 CSS 처리
	function chgDate(obj,yn,value) {

		if(yn == "Y") {
			$(obj).attr("class","date2 edit").attr("readonly", false);
			$(obj).datepicker2();
		} else if(yn == "N") {
			$(obj).attr("class","text readonly").attr("readonly", true);
		}

		$(obj).val(value);
	}

	// 콤보박스 CSS 처리
	function chgSelect(obj,yn,value) {

		if(yn == "Y") {
			$(obj).removeClass().removeAttr("disabled");
			$(obj).attr("class","edit");
		} else if(yn == "N") {
			$(obj).attr("class","readonly").attr("disabled", true);
		}

		$(obj).val(value);
	}

	// 날짜 포맷을 적용한다..
	function formatDate(strDate, saper) {
		if(strDate == "" || strDate == null) {
			return "";
		}

		if(strDate.length == 10) {
			return strDate.substring(0,4)+saper+strDate.substring(5,7)+saper+strDate.substring(8,10);
		} else if(strDate.length == 8) {
			return strDate.substring(0,4)+saper+strDate.substring(4,6)+saper+strDate.substring(6,8);
		}
	}

	// 초기화
	function clearCode(cdId,nmId) {

		$('#'+cdId).val("");
		$('#'+nmId).val("");
	}

	var currOrgCdId = "";
	var currOrgNmId = "";
	var pGubun = "";

	// 소속 팝업
	function showOrgPopup(cdId,nmId) {

		if(!isPopup()) {return;}

		var args    = new Array();

		if ( $("#aDispatchEnterCd").val() == "" ){

			args["enterCd"]   = "${ssnEnterCd}";
		}else {

			args["enterCd"]   = $("#aDispatchEnterCd").val();
		}

		currOrgCdId = cdId;
		currOrgNmId = nmId;
		pGubun = "orgTreePopup";

        var win = openPopup("/Popup.do?cmd=orgTreeEtcPopup&authPg=R", args, "740","520");
	}

	//근무지팝업
	function showWorkAreaPopup() {

		if(!isPopup()) {return;}

    	var args    = new Array();

    	args["grpCd"]   = "H90202";
	  	pGubun = "workAreaPop";

    	var win = openPopup("/Popup.do?cmd=commonCodePopup&authPg=${authPg}", args, "740","520");
	}

	//직급팝업
	function showJikgubPopup(cdId,nmId) {

		if(!isPopup()) {return;}

    	var args    = new Array();

    	args["grpCd"]   = "H20010";
	  	pGubun = "jikgubPop";

    	var win = openPopup("/Popup.do?cmd=commonCodePopup&authPg=${authPg}", args, "740","520");
	}

	//직책팝업
	function showJikchakPopup() {

		if(!isPopup()) {return;}

    	var args    = new Array();

    	args["grpCd"]   = "H20020";
	  	pGubun = "jikchakPop";

    	var win = openPopup("/Popup.do?cmd=commonCodePopup&authPg=${authPg}", args, "740","520");
	}

	//직위팝업
	function showJikweePopup(cdId,nmId) {

		if(!isPopup()) {return;}

    	var args    = new Array();

    	args["grpCd"]   = "H20030";
	  	pGubun = "jikweePop";

    	var win = openPopup("/Popup.do?cmd=commonCodePopup&authPg=${authPg}", args, "740","520");
	}

	var currJobCdId = "";
	var currJobNmId = "";

	// 직무 팝업
	function showJobPopup(cdId,nmId) {

		if(!isPopup()) {return;}

		currJobCdId = cdId;
		currJobNmId = nmId;
		pGubun = "jobSchemePopup";

        var win = openPopup("/Popup.do?cmd=jobSchemePopup&authPg=R", "", "740","520");
	}

	// 값셋팅 및 전달
	function returnExecAppmtValue() {

		var rtnValue = [];

		if("${authPg}" == "R") {
			alert("보기권한은 변경내역이 적용되지 않습니다.");
			p.window.close();
		}else if(ordYnTemp == "2") {
			alert("처리가 완료된 발령은 변경내역이 적용되지 않습니다.");
			p.window.close();
		} else if(ordYnTemp == "4") {
			alert("처리가 취소된 발령은 변경내역이 적용되지 않습니다.");
			p.window.close();
		} else {
			// 입력 가능한 모든값이 입력되었는지 체크
			var chk = true;
			$(".edit").each(function(){
				if ( !chk ) return;

				if ( $(this).attr("readonly") != "readonly"
						&& ( $(this).attr("vtxt") != "파견/겸직회사"
						&& $(this).attr("vtxt") != "파견/겸직소속 직책"
						&& $(this).attr("vtxt") != "근무지"
						&& $(this).attr("vtxt") != "직무"
   					    && $(this).attr("vtxt") != "직위"
						&& $(this).attr("vtxt") != "직급"
						&& $(this).attr("vtxt") != "소속공정"
						&& $(this).attr("vtxt") != "근무조"
						&& $(this).attr("vtxt") != "발령번호"
						&& $(this).attr("vtxt") != "포인트"
						&& $(this).attr("vtxt") != "호봉"
 					    && $(this).attr("vtxt") != "직군"
 					    && $(this).attr("vtxt") != "직무급"
				) ){
					if( $(this).val() == "" ){
						alert("["+ $(this).attr("vtxt") +"]은 필수 입력 항목입니다.");
						$(this).focus();
						chk = false;
					}
				}
			});
			if ( !chk ) return;

			rtnValue["ordEYmd"] = formatDate($("#ordEYmd").val(),"");
			rtnValue["dispatchEnterCd"] = $("#aDispatchEnterCd").val();
			rtnValue["statusCd"] = $("#aStatusCd").val();
			rtnValue["manageCd"] = $("#aManageCd").val();
			rtnValue["locationCd"] = $("#aLocationCd").val();
			rtnValue["jikchakCd"] = $("#aJikchakCd").val();
			rtnValue["workType"] = $("#aWorkType").val();
			rtnValue["paybandCd"] = $("#aPaybandCd").val();
			rtnValue["jikweeCd"] = $("#aJikweeCd").val();
			rtnValue["base1Cd"] = $("#aBase1Cd").val();
			rtnValue["payType"] = $("#aPayType").val();
			rtnValue["jikgubCd"] = $("#aJikgubCd").val();
			rtnValue["payGroupCd"] = $("#aPayGroupCd").val();
			//rtnValue["ordReasonCd"] = $("#aOrdReasonCd").val();
			rtnValue["resignReasonCd"] = $("#aResignReasonCd").val();
			rtnValue["retPathCd"] = $("#aRetPathCd").val();
			rtnValue["orgCd"] = $("#aOrgCd").val();
			rtnValue["jobCd"] = $("#aJobCd").val();
			rtnValue["dispatchOrgCd"] = $("#aDispatchOrgCd").val();
			rtnValue["dispatchJikchakCd"] = $("#aDispatchJikchakCd").val();
			rtnValue["dispatchJikchakNm"] = $("#aDispatchJikchakNm").val();
			rtnValue["removeOrgCd"] = $("#aRemoveOrgCd").val();
			rtnValue["traYmd"] = formatDate($("#aTraYmd").val(),"");
			rtnValue["gempYmd"] = formatDate($("#aGempYmd").val(),"");
			rtnValue["returnYmd"] = formatDate($("#aReturnYmd").val(),"");
			rtnValue["empYmd"] = formatDate($("#aEmpYmd").val(),"");
			rtnValue["ctitleChgYmd"] = formatDate($("#aCtitleChgYmd").val(),"");
			rtnValue["jikgubChgYmd"] = formatDate($("#aJikgubChgYmd").val(),"");
			rtnValue["fpromYmd"] = formatDate($("#aFpromYmd").val(),"");
			rtnValue["contractSymd"] = formatDate($("#aContractSymd").val(),"");
			rtnValue["contractEymd"] = formatDate($("#aContractEymd").val(),"");
			rtnValue["memo"] = $("#memo").val();
			rtnValue["memo2"] = $("#memo2").val();
			rtnValue["processNo"] = $("#processNo").val();
			rtnValue["salClass"] = $("#aSalClass").val();
			rtnValue["enterPay"] = $("#aEnterPay").val();
			rtnValue["sgPoint"] = $("#aSgPoint").val();
			rtnValue["workAreaCd"] = $("#aWorkAreaCd").val();
			rtnValue["workAreaNm"] = $("#aWorkAreaNm").val();

			rtnValue["placeWorkCd"] = $("#aPlaceWorkCd").val();
			rtnValue["workteamCd"] = $("#aWorkteamCd").val();

			rtnValue["inputYn"] = "Y";

			rtnValue["ordNo"] = $("#aOrdNo").val();

			p.window.close();
	 		p.popReturnValue(rtnValue);
		}
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

        if(pGubun == "orgTreePopup"){

        	$("#"+currOrgCdId).val(rv["orgCd"]);
        	$("#"+currOrgNmId).val(rv["orgNm"]);
        	$("#aJobCd").val(rv["keyJobMemo"]);
        	$("#aJobNm").val(rv["jobNm"]);
        	$("#aJikgunNm").val(rv["jikgunNm"]);
        	$("#aJikjongNm").val(rv["jikjongNm"]);
        	$("#aLocationCd").val(rv["locationCd"]);
        	$("#aWorkAreaCd").val(rv["workAreaCd"]);
        	$("#aWorkAreaNm").val(rv["workAreaNm"]);
        } else if(pGubun == "jobSchemePopup") {

        	$("#"+currJobCdId).val(rv["jobCd"]);
        	$("#"+currJobNmId).val(rv["jobNm"]);
        	$("#aJikgunNm").val(rv["jikgunNm"]);
        	$("#aJikjongNm").val(rv["jikjongNm"]);
        } else if(pGubun == "jikchakPop") {

        	$("#aJikchakCd").val(rv["code"]);
        	$("#aJikchakNm").val(rv["codeNm"]);
        } else if(pGubun == "jikweePop") {

        	$("#aJikweeCd").val(rv["code"]);
        	$("#aJikweeNm").val(rv["codeNm"]);
        } else if(pGubun == "jikgubPop") {

        	$("#aJikgubCd").val(rv["code"]);
        	$("#aJikgubNm").val(rv["codeNm"]);
        } else if(pGubun == "workAreaPop") {

        	$("#aWorkAreaCd").val(rv["code"]);
        	$("#aWorkAreaNm").val(rv["codeNm"]);
        }
	}

</script>

</head>
<body class="bodywrap">
<div class="wrapper popup_scroll">
	<div class="popup_title">
		<ul>
			<li>세부내역</li>
			<li class="close"></li>
		</ul>
	</div>
	<div class="popup_main">

		<div class="sheet_title">
			<ul>
				<li id="txt" class="txt">세부내역</li>
			</ul>
		</div>
		<table border="0" cellpadding="0" cellspacing="0" class="table">
			<colgroup>
				<col width="10%" />
				<col width="15%" />
				<col width="10%" />
				<col width="15%" />
				<col width="10%" />
				<col width="15%" />
				<col width="10%" />
				<col width="15%" /> 
			</colgroup>
			<tr>
				<th>발령구분</th>
				<td><input id="orgDetailNm" name="orgDetailNm" type="text" class="text transparent" readonly></td>
				<th style="display:none">발령순번</th>
				<td style="display:none"> <input id="applySeq" name="applySeq" type="text" class="text transparent" readonly></td>
				<th>발령일자</th>
				<td><input id="orgYmd" name="orgYmd" type="text" class="text transparent" readonly></td>
				<th>사번</th>
				<td><input id="sabun" name="sabun" type="text" class="text transparent" readonly></td>
				<th>성명</th>
				<td><input id="name" name="name" type="text" class="text transparent" readonly></td>
			</tr>
			<tr>
				<th>품의번호</th>
				<td colspan="3"><input id="processNo" name="processNo" type="text" class="text w100p"></td>
				<th>발령종료예정일자</th>
				<td colspan="3"><input id="ordEYmd" name="ordEYmd" type="text" class="date2" tabindex="1"></td>
				<%--
				<th>발령상세</th>
				<td>
					<select id="aOrdReasonCd" name="aOrdReasonCd">
					</select>
				</td>
				--%>
			</tr>
		</table>

		<table border="0" cellpadding="0" cellspacing="0" class="table" style="margin-top:10px;">
			<colgroup>
				<col width="20%" />
				<col width="30%" />
				<col width="50%" />
			</colgroup>
			<tr>
				<th></th>
				<th class="center">발령전</th>
				<th class="center">발령후</th>
			</tr>
			<!--<tr style="display: none;">-->
				<th>사업장(Location)</th>
				<td><input id="bLocationNm" name="bLocationNm" type="text" class="text transparent w100p" readonly></td>
				<td>
					<select id="aLocationCd" name="aLocationCd" vtxt="사업장(Location)">
					</select>
				</td>
			</tr 
			<tr>
			<tr>
				<th>소속</th>
				<td><input id="bOrgNm" name="bOrgNm" type="text" class="text transparent w100p" readonly></td>
				<td>
					<input id="aOrgCd" name="aOrgCd" type="text" class="text" readonly vtxt="소속">
					<input id="aOrgNm" name="aOrgNm" type="text" class="text" vtxt="소속" style="width:150px;">
					<a href="javascript:showOrgPopup('aOrgCd','aOrgNm');" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
					<a href="javascript:clearCode('aOrgCd','aOrgNm')" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
				</td>
			</tr>
			<tr>
				<th>파견/겸직회사</th>
				<td><input id="bDispatchEnterNm" name="bDispatchEnterNm" type="text" class="text transparent" readonly></td>
				<td>
					<select id="aDispatchEnterCd" name="aDispatchEnterCd" vtxt="파견/겸직회사" >
					</select>
				</td>
			</tr>
			<tr>
				<th>파견/겸직소속 직책</th>
				<td><input id="bDispatchOrgNm" name="bDispatchOrgNm" type="text" class="text transparent w50p" readonly>&nbsp;
				      <input id="bDispatchJikchakNm" name="bDispatchJikchakNm" type="text" class="text transparent w50" readonly></td>				      
				<td>
					<input id="aDispatchOrgCd" name="aDispatchOrgCd" type="text" class="text" readonly vtxt="파견/겸직소속 직책">
					<input id="aDispatchOrgNm" name="aDispatchOrgNm" type="text" class="text" vtxt="파견/겸직소속 직책">					
					<a href="javascript:showOrgPopup('aDispatchOrgCd','aDispatchOrgNm');" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
					<a href="javascript:clearCode('aDispatchOrgCd','aDispatchOrgNm')" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
					<select id="aDispatchJikchakCd" name="aDispatchJikchakCd" vtxt="파견/겸직소속 직책">
					</select>
				</td>
			</tr>
			<tr>
				<th>재직상태</th>
				<td><input id="bStatusNm" name="bStatusNm" type="text" class="text transparent" readonly></td>
				<td>
					<select id="aStatusCd" name="aStatusCd" vtxt="재직상태">
					</select>
				</td>
			</tr>
			<tr>
				<th>직책</th>
				<td><input id="bJikchakNm" name="bJikchakNm" type="text" class="text transparent" readonly></td>
				<td>
					<select id="aJikchakCd" name="aJikchakCd" vtxt="직책">
					</select>
				</td>
			</tr>
			<tr>
				<th>직위</th>
				<td><input id="bJikweeNm" name="bJikweeNm" type="text" class="text transparent" readonly></td>
				<td>
					<select id="aJikweeCd" name="aJikweeCd" vtxt="직위">
					</select>
				</td>
			</tr>
			<tr>
				<th>직급</th>
				<td><input id="bJikgubNm" name="bJikgubNm" type="text" class="text transparent" readonly></td>
				<td>
					<select id="aJikgubCd" name="aJikgubCd" vtxt="직급">
					</select>
				</td>
			</tr>

			<tr>
				<th>포인트</th>
				<td><input id="bSgPoint" name="bSgPoint" type="text" class="text transparent" readonly></td>
				<td>
					<input id="aSgPoint" name="aSgPoint" type="text" class="text" vtxt="포인트">
				</td>
			</tr>

			<tr>
				<th>직군</th>
				<td><input id="bWorkTypeNm" name="bWorkTypeNm" type="text" class="text transparent" readonly></td>
				<td>
					<select id="aWorkType" name="aWorkType" vtxt="직군">
					</select>
				</td>
			</tr>
			<tr>
				<th>사원구분</th>
				<td><input id="bManageNm" name="bManageNm" type="text" class="text transparent" readonly></td>
				<td>
					<select id="aManageCd" name="aManageCd" vtxt="사원구분">
					</select>
				</td>
			</tr>
			<tr>
				<th>급여유형</th>
				<td><input id="bPayTypeNm" name="bPayTypeNm" type="text" class="text transparent" readonly></td>
				<td>
					<select id="aPayType" name="aPayType" vtxt="급여유형">
					</select>
				</td>
			</tr>
			<tr>
				<th>직무급(PayBand)</th>
				<td><input id="bPaybandNm" name="bPaybandNm" type="text" class="text transparent" readonly></td>
				<td>
					<select id="aPaybandCd" name="aPaybandCd" vtxt="직무급">
					</select>
				</td>
			</tr>			
			<tr>
				<th>호봉</th>
				<!-- <th>급여호봉</th> -->
				<td><input id="bSalClass" name="bSalClass" type="text" class="text transparent" readonly></td>
				<td>
<!-- 					<select id="aSalClass" name="aSalClass" vtxt="호봉"> -->
<!-- 					</select> -->
					<input id="aSalClass" name="aSalClass" type="text" class="text" vtxt="호봉">
				</td>
			</tr>
				<th>근무지</th>
				<td><input id="bWorkAreaNm" name="bWorkAreaNm" type="text" class="text transparent" readonly></td>
				<td>
					<input id="aWorkAreaCd" name="aWorkAreaCd" type="hidden" class="text"  vtxt="근무지">
					<input id="aWorkAreaNm" name="aWorkAreaNm" type="text" class="text" vtxt="근무지">
					<a href="javascript:showWorkAreaPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
					<%--
					<select id="aJikweeCd" name="aJikweeCd">
					</select>
					--%>
				</td>
			</tr>
			<tr>
				<th>직무</th>
				<td><input id="bJobNm" name="bJobNm" type="text" class="text transparent" readonly></td>
				<td>
					<input id="aJobNm" name="aJobNm" type="text" class="text readonly" readonly vtxt="직무">
					<a href="javascript:showJobPopup('aJobCd','aJobNm');" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
					<a href="javascript:clearCode('aJobCd','aJobNm')" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
					<input id="aJobCd" name="aJobCd" type="hidden" class="text readonly" readonly vtxt="직무">
				</td>
			</tr>

			<tr>
				<th>소속공정</th>
				<td><input id="bPlaceWorkNm" name="bSalClassNm" type="text" class="text transparent" readonly></td>
				<td>
					<select id="aPlaceWorkCd" name="aPlaceWorkCd" vtxt="소속공정">
					</select>
				</td>
			</tr>

			<tr>
				<th>근무조</th>
				<td><input id="bWorkteamNm" name="bWorkteamNm" type="text" class="text transparent" readonly></td>
				<td>
					<select id="aWorkteamCd" name="aWorkteamCd" vtxt="근무조">
					</select>
				</td>
			</tr>

			<tr>
				<th>그룹입사일</th>
				<td><input id="bGempYmd" name="bGempYmd" type="text" class="text transparent" readonly></td>
				<td><input id="aGempYmd" name="aGempYmd" type="text" class="date2" vtxt="그룹입사일"></td>
			</tr>
			<tr>
				<th>입사일</th>
				<td><input id="bEmpYmd" name="bEmpYmd" type="text" class="text transparent" readonly></td>
				<td><input id="aEmpYmd" name="aEmpYmd" type="text" class="date2" vtxt="입사일"></td>
			</tr>
			<tr>
				<th>수습종료일</th>
				<td><input id="bTraYmd" name="bTraYmd" type="text" class="text transparent" readonly></td>
				<td><input id="aTraYmd" name="aTraYmd" type="text" class="date2" vtxt="수습종료일"></td>
			</tr>
			<tr>
				<th>발령번호</th>
				<td><input id="bOrdNo" name="bOrdNo" type="text" class="text transparent" readonly></td>
				<td><input id="aOrdNo" name="aOrdNo" type="text" class="text" vtxt="발령번호"></td>
			</tr>
			<tr style="display: none;">
				<th>발령기간</th>
				<td>
					<input id="bContractSymd" name="bContractSymd" type="text" class="text transparent" readonly> ~
					<input id="bContractEymd" name="bContractEymd" type="text" class="text transparent" readonly>
				</td>
				<td>
					<input id="aContractSymd" name="aContractSymd" type="text" class="date2" vtxt="발령기간"> ~
					<input id="aContractEymd" name="aContractEymd" type="text" class="date2" vtxt="발령기간">
				</td>
			</tr>

			<tr style="display:none">
				<th>복직예정일</th>
				<td><input id="bReturnYmd" name="bReturnYmd" type="text" class="text transparent" readonly></td>
				<td><input id="aReturnYmd" name="aReturnYmd" type="text" class="date2" vtxt="복직예정일"></td>
			</tr>

			<tr style="display:none">
				<th>직위변경일</th>
				<td><input id="bCtitleChgYmd" name="bCtitleChgYmd" type="text" class="text transparent" readonly></td>
				<td><input id="aCtitleChgYmd" name="aCtitleChgYmd" type="text" class="date2" vtxt="직위변경일"></td>
			</tr>
			<tr style="display:none">
				<th>직급조정일</th>
				<td><input id="bJikgubChgYmd" name="bJikgubChgYmd" type="text" class="text transparent" readonly></td>
				<td><input id="aJikgubChgYmd" name="aJikgubChgYmd" type="text" class="date2" vtxt="직급조정일"></td>
			</tr>
			<tr style="display:none">
				<th>직급변경일</th>
				<td><input id="bFpromYmd" name="bFpromYmd" type="text" class="text transparent" readonly></td>
				<td><input id="aFpromYmd" name="aFpromYmd" type="text" class="date2" vtxt="직급변경일"></td>
			</tr>

			<tr style="display:none">
				<th>해임소속</th>
				<td><input id="bRemoveOrgNm" name="bRemoveOrgNm" type="text" class="text transparent" readonly></td>
				<td>
					<input id="aRemoveOrgCd" name="aRemoveOrgCd" type="text" class="text readonly" readonly>
					<input id="aRemoveOrgNm" name="aRemoveOrgNm" type="text" class="text" vtxt="해임소속">
					<a href="javascript:showOrgPopup('aRemoveOrgCd','aRemoveOrgNm');" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
					<a href="javascript:clearCode('aRemoveOrgCd','aRemoveOrgNm')" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
				</td>
			</tr>
			<tr style="display:none">
				<th>파견업체</th>
				<td><input id="bBase1Nm" name="bBase1Nm" type="text" class="text transparent" readonly></td>
				<td>
					<select id="aBase1Cd" name="aBase1Cd" vtxt="파견업체">
					</select>
				</td>
			</tr>
			<tr style="display:none">
				<th>Pay그룹</th>
				<td><input id="bPayGroupNm" name="bPayGroupNm" type="text" class="text transparent" readonly></td>
				<td>
					<select id="aPayGroupCd" name="aPayGroupCd" vtxt="Pay그룹">
					</select>
				</td>
			</tr>
			</table>

			<table border="0" cellpadding="0" cellspacing="0" class="table" style="margin-top:10px;">
			<colgroup>
				<col width="20%" />
				<col width="80%" />
			</colgroup>
			<tr style="display:none">
				<th>입사시연봉(만원)</th>
				<td><input id="aEnterPay" name="aEnterPay" type="text" class="text right"></td>
			</tr>
			<tr>
				<th>퇴직사유</th>
				<td>
					<select id="aResignReasonCd" name="aResignReasonCd" vtxt="퇴직사유">
					</select>
				</td>
			</tr>
			<tr style="display:none">
				<th>퇴직후진로</th>
				<td>
					<select id="aRetPathCd" name="aRetPathCd" vtxt="퇴직후진로">
					</select>
				</td>
			</tr>
			<tr>
				<th>발령사항</th>
				<td><textarea id="memo" name="memo" rows="3" class="text w100p" vtxt="발령사항"></textarea></td>
			</tr>
			<tr>
				<th>발령설명</th>
				<td><textarea id="memo2" name="memo2" rows="3" class="text w100p" vtxt="발령설명"></textarea></td>
			</tr>
		</table>

		<div class="popup_button outer">
			<ul>
				<li>
					<a href="javascript:returnExecAppmtValue();" class="pink large">확인</a>
					<a href="javascript:p.self.close();" class="gray large">닫기</a>
				</li>
			</ul>
		</div>
	</div>
</div>
</body>
</html>



