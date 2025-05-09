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

	$(function() {

        $(".close").click(function() {
	    	p.self.close();
	    });

		var statusCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10010"), " ");
		var manageCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10030"), " ");
		var locationCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getLocationCdList",false).codeList, "");	//LOCATION
		var jikchakCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20020"), " ");
		var workType = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10050"), " ");
		var jikweeCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20030"), " ");
		var payType = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10110"), " ");
		var jikgubCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20010"), " ");
		var payGroupCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20060"), " ");

		//var ordReasonCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H40110"), " ");
		var ordReasonCd ;
		var ordType = ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdTypeList&searchOrdTypeCd="+ordDetailCd,false) ;
		ordType != null && ordType.codeList.length > 0 && ordType.codeList[0].codeNm != "" ?
		ordReasonCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getComCodeNoteList&searchGrcodeCd=H40110&searchNote1="+ordType.codeList[0].codeNm,false).codeList, " ") : ordReasonCd = "" ;

		var resignReasonCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H40100"), " ");
		var retPathCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H40150"), " ");
		var base1Cd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H90005"), " ");
		var salClass = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C10000"), " ");

		var param = "sabun="+sabun+"&name="+name+"&ordDetailCd="+ordDetailCd+"&ordYmd="+ordYmd+"&applySeq="+applySeq;

    	var columMap = ajaxCall("/ExecAppmt.do?cmd=getExecAppmtPopColumMap",param,false);


    	var beforeMap = ajaxCall("/ExecAppmt.do?cmd=getExecAppmtPopBeforeMap",param,false);

    	var afterMap = {};

    	if(sStatus == "I") {
        	afterMap = ajaxCall("/ExecAppmt.do?cmd=getExecAppmtPopAfterMap",param,false);
    	} else {
        	afterMap = ajaxCall("/ExecAppmt.do?cmd=getExecAppmtMap",param,false);
    	}

		$('#aStatusCd').html(statusCd[2]);
		$('#aManageCd').html(manageCd[2]);
		$('#aLocationCd').html(locationCd[2]);
		$('#aJikchakCd').html(jikchakCd[2]);
		$('#aWorkType').html(workType[2]);
		$('#aJikweeCd').html(jikweeCd[2]);
		$('#aBase1Cd').html(base1Cd[2]);
		$('#aPayType').html(payType[2]);
		$('#aJikgubCd').html(jikgubCd[2]);
		$('#aPayGroupCd').html(payGroupCd[2]);
		//$('#aOrdReasonCd').html(ordReasonCd[2]);
		$('#aResignReasonCd').html(resignReasonCd[2]);
		$('#aRetPathCd').html(retPathCd[2]);
		$('#aSalClass').html(salClass[2]);
		$('#aDispatchJikchakCd').html(jikchakCd[2]);

		$('#sabun').val(sabun);
		$('#name').val(name);
		$('#orgDetailNm').val(ordDetailNm);
		$('#applySeq').val(applySeq);
		$('#orgYmd').val(formatDate(ordYmd,"-"));
		$('#ordEYmd').val(formatDate(ordEYmd,"-"));
		//$("#aOrdReasonCd").val(ordReasonCd_) ;
		$('#ordEYmd').datepicker2();

		if(beforeMap != null && beforeMap.DATA != null) {
			$("#bStatusNm").val(beforeMap.DATA.statusNm);
			$("#bManageNm").val(beforeMap.DATA.manageNm);
			$("#bLocationNm").val(beforeMap.DATA.locationNm);
			$("#bOrgNm").val(beforeMap.DATA.orgNm);
			$("#bJikchakNm").val(beforeMap.DATA.jikchakNm);
			$("#bWorkTypeNm").val(beforeMap.DATA.workTypeNm);
			$("#bJobNm").val(beforeMap.DATA.jobNm);
			$("#bJikweeNm").val(beforeMap.DATA.jikweeNm);
			$("#bTraYmd").val(formatDate(beforeMap.DATA.traYmd,"-"));
			$("#bGempYmd").val(formatDate(beforeMap.DATA.gempYmd,"-"));
			$("#bReturnYmd").val(formatDate(beforeMap.DATA.returnYmd,"-"));
			$("#bEmpYmd").val(formatDate(beforeMap.DATA.empYmd,"-"));
			$("#bCtitleChgYmd").val(formatDate(beforeMap.DATA.ctitleChgYmd,"-"));
			$("#bJikgubChgYmd").val(formatDate(beforeMap.DATA.jikgubChgYmd,"-"));
			$("#bFpromYmd").val(formatDate(beforeMap.DATA.fpromYmd,"-"));
			$("#bDispatchOrgNm").val(beforeMap.DATA.dispatchOrgNm);
			$("#bDispatchJikchakNm").val(beforeMap.DATA.dispatchJikchakNm);
			$("#bRemoveOrgNm").val(beforeMap.DATA.removeOrgNm);
			$("#bBase1Nm").val(beforeMap.DATA.base1Nm);
			$("#bPayTypeNm").val(beforeMap.DATA.payTypeNm);
			$("#bSalClassNm").val(beforeMap.DATA.salClassNm);
			$("#bJikgubNm").val(beforeMap.DATA.jikgubNm);
			$("#bPayGroupNm").val(beforeMap.DATA.payGroupNm);
			$("#bContractSymd").val(formatDate(beforeMap.DATA.contractSymd,"-"));
			$("#bContractEymd").val(formatDate(beforeMap.DATA.contractEymd,"-"));
		}


		if(columMap != null && columMap.DATA != null) {
			chgSelect($("#aStatusCd"), columMap.DATA.workTypeYn, afterMap.DATA.statusCd);
			chgSelect($("#aManageCd"), columMap.DATA.manageYn, afterMap.DATA.manageCd);
			chgSelect($("#aLocationCd"), columMap.DATA.locationYn, afterMap.DATA.locationCd);
			chgSelect($("#aJikchakCd"), columMap.DATA.jikchakYn, afterMap.DATA.jikchakCd);
			chgSelect($("#aWorkType"), columMap.DATA.workYn, afterMap.DATA.workType);
			chgSelect($("#aJikweeCd"), columMap.DATA.jikweeYn, afterMap.DATA.jikweeCd);
			chgSelect($("#aBase1Cd"), columMap.DATA.base1CdYn, afterMap.DATA.base1Cd);
			chgSelect($("#aPayType"), columMap.DATA.payTypeYn, afterMap.DATA.payType);
			chgSelect($("#aJikgubCd"), columMap.DATA.jikgubYn, afterMap.DATA.jikgubCd);
			chgSelect($("#aPayGroupCd"), columMap.DATA.payGroupYn, afterMap.DATA.payGroupCd);
			chgSelect($("#aResignReasonCd"), columMap.DATA.retReasonYn,afterMap.DATA.resignReasonCd);
			chgSelect($("#aRetPathCd"), columMap.DATA.retPathYn,afterMap.DATA.retPathCd);
			chgSelect($("#aSalClass"), columMap.DATA.salClassYn,afterMap.DATA.salClass);
			chgSelect($("#aDispatchJikchakCd"), columMap.DATA.dispatchOrgYn, afterMap.DATA.dispatchJikchakNm);

			chgInput($("#aOrgCd"),$("#aOrgNm"),columMap.DATA.orgYn, afterMap.DATA.orgCd, afterMap.DATA.orgNm);
			chgInput($("#aJobCd"),$("#aJobNm"),columMap.DATA.jobYn, afterMap.DATA.jobCd, afterMap.DATA.jobNm);
			chgInput($("#aDispatchOrgCd"),$("#aDispatchOrgNm"),columMap.DATA.dispatchOrgYn, afterMap.DATA.dispatchOrgCd, afterMap.DATA.dispatchOrgNm);
			chgInput($("#aRemoveOrgCd"),$("#aRemoveOrgNm"),columMap.DATA.disOrgYn, afterMap.DATA.removeOrgCd, afterMap.DATA.removeOrgNm);

			chgDate($("#aTraYmd"),columMap.DATA.traYmdYn, formatDate(afterMap.DATA.traYmd,"-"));
			chgDate($("#aGempYmd"),columMap.DATA.gempYmdYn, formatDate(afterMap.DATA.gempYmd,"-"));
			chgDate($("#aReturnYmd"),columMap.DATA.returnYmdYn, formatDate(afterMap.DATA.returnYmd,"-"));
			chgDate($("#aEmpYmd"),columMap.DATA.empYmdYn, formatDate(afterMap.DATA.empYmd,"-"));
			chgDate($("#aCtitleChgYmd"),columMap.DATA.ctitleChgYmdYn, formatDate(afterMap.DATA.ctitleChgYmd,"-"));
			chgDate($("#aJikgubChgYmd"),columMap.DATA.jikgubChgYmdYn, formatDate(afterMap.DATA.jikgubChgYmd,"-"));
			chgDate($("#aFpromYmd"),columMap.DATA.fpromYmdYn, formatDate(afterMap.DATA.fpromYmd,"-"));
			chgDate($("#aContractSymd"),columMap.DATA.contractYmdYn, formatDate(afterMap.DATA.contractSymd,"-"));
			chgDate($("#aContractEymd"),columMap.DATA.contractYmdYn, formatDate(afterMap.DATA.contractEymd,"-"));

			$('#memo').val(afterMap.DATA.memo);
			$('#processNo').val(afterMap.DATA.processNo);
			Num_Comma($('#aEnterPay').val(afterMap.DATA.enterPay).get(0));

			if(columMap.DATA.entPayYn == "Y") {
				$('#aEnterPay').attr("class","text right").attr("readonly", false);
			} else {
				$('#aEnterPay').attr("class","text right readonly").attr("readonly", true);
			}

	        $("#aEnterPay").bind("keyup",function(event){
	        	makeNumber(this,"A");
	    		Num_Comma(this);
			});

		} else {
			alert("항목이 정의되지 않았습니다.");
			p.window.close();
		}
	});

	// 입력박스 형식 CSS 처리
	function chgInput(obj1,obj2,yn,value1,value2) {

		if(yn == "Y") {
			$(obj1).attr("class","text readonly").attr("readonly", true);
			$(obj2).attr("class","text").attr("readonly", true);
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
			$(obj).attr("class","date2").attr("readonly", false);
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
	
		currOrgCdId = cdId;
		currOrgNmId = nmId;
		pGubun = "orgTreePopup";

        var win = openPopup("/Popup.do?cmd=orgTreePopup&authPg=R", "", "740","520");
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
		}else if(ordYnTemp == "2") {
			alert("처리가 완료된 발령은 변경내역이 적용되지 않습니다.");
		} else if(ordYnTemp == "4") {
			alert("처리가 취소된 발령은 변경내역이 적용되지 않습니다.");
		} else {

			rtnValue["ordEYmd"] = formatDate($("#ordEYmd").val(),"");
			rtnValue["statusCd"] = $("#aStatusCd").val();
			rtnValue["manageCd"] = $("#aManageCd").val();
			rtnValue["locationCd"] = $("#aLocationCd").val();
			rtnValue["jikchakCd"] = $("#aJikchakCd").val();
			rtnValue["workType"] = $("#aWorkType").val();
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
			rtnValue["processNo"] = $("#processNo").val();
			rtnValue["salClass"] = $("#aSalClass").val();
			rtnValue["enterPay"] = $("#aEnterPay").val();

			rtnValue["inputYn"] = "Y";

	 		p.popReturnValue(rtnValue);
		}

 		p.window.close();

	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

        if(pGubun == "orgTreePopup"){
        	$("#"+currOrgCdId).val(rv["orgCd"]);
        	$("#"+currOrgNmId).val(rv["orgNm"]);
        } else if(pGubun == "jobSchemePopup") {
        	$("#"+currJobCdId).val(rv["jobCd"]);
        	$("#"+currJobNmId).val(rv["jobNm"]);
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
			<col width="15%" />
			<col width="35%" />
			<col width="15%" />
			<col width="35%" />
		</colgroup>
		<tr>
			<th>발령구분</th>
			<td><input id="orgDetailNm" name="orgDetailNm" type="text" class="text transparent" readonly></td>
			<th style="display:none">발령순번</th>
			<td style="display:none"> <input id="applySeq" name="applySeq" type="text" class="text transparent" readonly></td>
			<th>발령일자</th>
			<td><input id="orgYmd" name="orgYmd" type="text" class="text transparent" readonly></td>
		</tr>
		<tr>
			<th>사번</th>
			<td><input id="sabun" name="sabun" type="text" class="text transparent" readonly></td>
			<th>성명</th>
			<td><input id="name" name="name" type="text" class="text transparent" readonly></td>
		</tr>
		<tr>
			<th>발령번호</th>
			<td colspan="3"><input id="processNo" name="processNo" type="text" class="text w100p"></td>
			<th style="display:none">발령종료일자</th>
			<td style="display:none"><input id="ordEYmd" name="ordEYmd" type="text" class="date2" tabindex="1"></td>
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
		<tr>
			<th>소속</th>
			<td><input id="bOrgNm" name="bOrgNm" type="text" class="text transparent w100p" readonly></td>
			<td>
				<input id="aOrgCd" name="aOrgCd" type="text" class="text" readonly>
				<input id="aOrgNm" name="aOrgNm" type="text" class="text">
				<a href="javascript:showOrgPopup('aOrgCd','aOrgNm');" class="button6"><img src="/common/images/common/btn_search2.gif"/></a>
				<a href="javascript:clearCode('aOrgCd','aOrgNm')" class="button7"><img src="/common/images/icon/icon_undo.png"/></a>
			</td>
		</tr>
		<tr>
			<th>파견/겸직소속 직책</th>
			<td><input id="bDispatchOrgNm" name="bDispatchOrgNm" type="text" class="text transparent w70p" readonly>&nbsp;<input id="bDispatchJikchakNm" name="bDispatchJikchakNm" type="text" class="text transparent w50" readonly></td>
			<td>
				<input id="aDispatchOrgCd" name="aDispatchOrgCd" type="text" class="text" readonly>
				<input id="aDispatchOrgNm" name="aDispatchOrgNm" type="text" class="text">
				<a href="javascript:showOrgPopup('aDispatchOrgCd','aDispatchOrgNm');" class="button6"><img src="/common/images/common/btn_search2.gif"/></a>
				<a href="javascript:clearCode('aDispatchOrgCd','aDispatchOrgNm')" class="button7"><img src="/common/images/icon/icon_undo.png"/></a>
				<select id="aDispatchJikchakCd" name="aDispatchJikchakCd">
				</select>
			</td>
		</tr>
		<tr>
			<th>재직상태</th>
			<td><input id="bStatusNm" name="bStatusNm" type="text" class="text transparent" readonly></td>
			<td>
				<select id="aStatusCd" name="aStatusCd">
				</select>
			</td>
		</tr>
		<tr>
			<th>직책</th>
			<td><input id="bJikchakNm" name="bJikchakNm" type="text" class="text transparent" readonly></td>
			<td>
				<select id="aJikchakCd" name="aJikchakCd">
				</select>
			</td>
		</tr>
		<tr>
			<th>PAYBAND</th>
			<td><input id="bJikweeNm" name="bJikweeNm" type="text" class="text transparent" readonly></td>
			<td>
				<select id="aJikweeCd" name="aJikweeCd">
				</select>
			</td>
		</tr>
		<tr>
			<th>직급</th>
			<td><input id="bJikgubNm" name="bJikgubNm" type="text" class="text transparent" readonly></td>
			<td>
				<select id="aJikgubCd" name="aJikgubCd">
				</select>
			</td>
		</tr>
		<tr>
			<th>직군</th>
			<td><input id="bWorkTypeNm" name="bWorkTypeNm" type="text" class="text transparent" readonly></td>
			<td>
				<select id="aWorkType" name="aWorkType">
				</select>
			</td>
		</tr>
		<tr>
			<th>사원구분</th>
			<td><input id="bManageNm" name="bManageNm" type="text" class="text transparent" readonly></td>
			<td>
				<select id="aManageCd" name="aManageCd">
				</select>
			</td>
		</tr>
		<tr>
			<th>급여유형</th>
			<td><input id="bPayTypeNm" name="bPayTypeNm" type="text" class="text transparent" readonly></td>
			<td>
				<select id="aPayType" name="aPayType">
				</select>
			</td>
		</tr>
		<tr>
			<th>급여호봉</th>
			<td><input id="bSalClassNm" name="bSalClassNm" type="text" class="text transparent" readonly></td>
			<td>
				<select id="aSalClass" name="aSalClass">
				</select>
			</td>
		</tr>
		<tr>
			<th>근무지</th>
			<td><input id="bLocationNm" name="bLocationNm" type="text" class="text transparent w100p" readonly></td>
			<td>
				<select id="aLocationCd" name="aLocationCd">
				</select>
			</td>
		</tr>
		<tr>
			<th>직무</th>
			<td><input id="bJobNm" name="bJobNm" type="text" class="text transparent" readonly></td>
			<td>
				<input id="aJobCd" name="aJobCd" type="text" class="text readonly" readonly>
				<input id="aJobNm" name="aJobNm" type="text" class="text">
				<a href="javascript:showJobPopup('aJobCd','aJobNm');" class="button6"><img src="/common/images/common/btn_search2.gif"/></a>
				<a href="javascript:clearCode('aJobCd','aJobNm')" class="button7"><img src="/common/images/icon/icon_undo.png"/></a>
			</td>
		</tr>
		<tr>
			<th>그룹입사일</th>
			<td><input id="bGempYmd" name="bGempYmd" type="text" class="text transparent" readonly></td>
			<td><input id="aGempYmd" name="aGempYmd" type="text" class="date2"></td>
		</tr>
		<tr>
			<th>입사일</th>
			<td><input id="bEmpYmd" name="bEmpYmd" type="text" class="text transparent" readonly></td>
			<td><input id="aEmpYmd" name="aEmpYmd" type="text" class="date2"></td>
		</tr>
		<tr>
			<th>시용종료일</th>
			<td><input id="bTraYmd" name="bTraYmd" type="text" class="text transparent" readonly></td>
			<td><input id="aTraYmd" name="aTraYmd" type="text" class="date2"></td>
		</tr>
		<tr>
			<th>발령기간</th>
			<td>
				<input id="bContractSymd" name="bContractSymd" type="text" class="text transparent" readonly> ~
				<input id="bContractEymd" name="bContractEymd" type="text" class="text transparent" readonly>
			</td>
			<td>
				<input id="aContractSymd" name="aContractSymd" type="text" class="date2"> ~
				<input id="aContractEymd" name="aContractEymd" type="text" class="date2">
			</td>
		</tr>

		<tr style="display:none">
			<th>복직예정일</th>
			<td><input id="bReturnYmd" name="bReturnYmd" type="text" class="text transparent" readonly></td>
			<td><input id="aReturnYmd" name="aReturnYmd" type="text" class="date2"></td>
		</tr>

		<tr style="display:none">
			<th>PAYBAND변경일</th>
			<td><input id="bCtitleChgYmd" name="bCtitleChgYmd" type="text" class="text transparent" readonly></td>
			<td><input id="aCtitleChgYmd" name="aCtitleChgYmd" type="text" class="date2"></td>
		</tr>
		<tr style="display:none">
			<th>직급조정일</th>
			<td><input id="bJikgubChgYmd" name="bJikgubChgYmd" type="text" class="text transparent" readonly></td>
			<td><input id="aJikgubChgYmd" name="aJikgubChgYmd" type="text" class="date2"></td>
		</tr>
		<tr style="display:none">
			<th>직급변경일</th>
			<td><input id="bFpromYmd" name="bFpromYmd" type="text" class="text transparent" readonly></td>
			<td><input id="aFpromYmd" name="aFpromYmd" type="text" class="date2"></td>
		</tr>

		<tr style="display:none">
			<th>해임소속</th>
			<td><input id="bRemoveOrgNm" name="bRemoveOrgNm" type="text" class="text transparent" readonly></td>
			<td>
				<input id="aRemoveOrgCd" name="aRemoveOrgCd" type="text" class="text readonly" readonly>
				<input id="aRemoveOrgNm" name="aRemoveOrgNm" type="text" class="text">
				<a href="javascript:showOrgPopup('aRemoveOrgCd','aRemoveOrgNm');" class="button6"><img src="/common/images/common/btn_search2.gif"/></a>
				<a href="javascript:clearCode('aRemoveOrgCd','aRemoveOrgNm')" class="button7"><img src="/common/images/icon/icon_undo.png"/></a>
			</td>
		</tr>
		<tr style="display:none">
			<th>파견업체</th>
			<td><input id="bBase1Nm" name="bBase1Nm" type="text" class="text transparent" readonly></td>
			<td>
				<select id="aBase1Cd" name="aBase1Cd">
				</select>
			</td>
		</tr>
		<tr style="display:none">
			<th>Pay그룹</th>
			<td><input id="bPayGroupNm" name="bPayGroupNm" type="text" class="text transparent" readonly></td>
			<td>
				<select id="aPayGroupCd" name="aPayGroupCd">
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
				<select id="aResignReasonCd" name="aResignReasonCd">
				</select>
			</td>
		</tr>
		<tr style="display:none">
			<th>퇴직후진로</th>
			<td>
				<select id="aRetPathCd" name="aRetPathCd">
				</select>
			</td>
		</tr>
		<tr>
			<th>발령사항</th>
			<td><input id="memo" name="memo" type="text" class="text w100p"></td>
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



