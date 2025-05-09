<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='perPayPartiUserSta' mdef='월별급여지급현황'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>
<!--
 * 월별급여지급현황
 * @author JM
-->
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
$(function() {
	$(window).smartresize(sheetResize);
	sheetInit();

	if ($("#searchUserId").val() != null && $("#searchUserId").val() != "null" && $("#searchUserId").val() != "") {
		// 최근급여일자 조회
		searchLatestPaymentInfo();
	}

	$("#tabs-0 iframe").attr("src","${ctx}/RetroPersonal.do?cmd=viewRetroPersonalSub&authPg=${authPg}");
});

// 필수값/유효성 체크
function chkInVal() {
	if ($("#searchUserId").val() == null || $("#searchUserId").val() == "null" || $("#searchUserId").val() == "") {
		alert("<msg:txt mid='alertSepCalcBasicMgr1' mdef='대상자를 선택하십시오.'/>");
		$("#tdSabun").focus();
		return false;
	}
	if ($("#payActionCd").val() == null || $("#payActionCd").val() == "null" || $("#payActionCd").val() == "") {
		alert("<msg:txt mid='109681' mdef='급여일자를 선택하십시오.'/>");
		$("#payActionCd").focus();
		return false;
	}

	return true;
}

function doAction1(sAction) {
	switch (sAction) {
		case "Search":
			// 필수값/유효성 체크
			if (!chkInVal()) {
				break;
			}

			$("#sabun").val($("#searchUserId").val());

			// Sub Main 호출
			iframeSubMain.doAction1("Search");
			break;
	}
}

//최근급여일자 조회
function searchLatestPaymentInfo() {
	var procNm = "최근급여일자";
	var sabun = $("#searchUserId").val();
	// 급여구분(C00001-RETRO.소급)
	var paymentInfo = ajaxCall("${ctx}/RetroPersonal.do?cmd=getCpnQueryList", "queryId=getCpnLatestPaymentInfoMap&sabun="+sabun+"&procNm="+procNm+"&runType=RETRO,", false);

	if (paymentInfo.DATA != null && paymentInfo.DATA != "" && typeof paymentInfo.DATA[0] != "undefined") {
		$("#payActionCd").val(paymentInfo.DATA[0].payActionCd);
		$("#payActionNm").val(paymentInfo.DATA[0].payActionNm);
		/*
		if ($("#payActionCd").val() != null && $("#payActionCd").val() != "") {
			doAction1("Search");
		}
		*/
	} else if (paymentInfo.Message != null && paymentInfo.Message != "") {
		alert(paymentInfo.Message);
	}
}

//급여일자 검색 팝입
function payActionSearchPopup() {
	let layerModal = new window.top.document.LayerModal({
		id : 'payDayLayer'
		, url : '/PayDayPopup.do?cmd=viewPayDayLayer&authPg=R'
		, parameters : {
			runType : 'RETRO'
		}
		, width : 840
		, height : 520
		, title : '<tit:txt mid='payDayPop' mdef='급여일자 조회'/>'
		, trigger :[
			{
				name : 'payDayTrigger'
				, callback : function(result){
					$("#payActionCd").val(result.payActionCd);
					$("#payActionNm").val(result.payActionNm);
					doAction1("Search");
				}
			}
		]
	});
	layerModal.show();



	// if(!isPopup()) {return;}
	// gPRow = "";
	// pGubun = "payDayPopup";
	//
	// var w		= 840;
	// var h		= 520;
	// var url		= "/PayDayPopup.do?cmd=payDayPopup";
	// var args 	= new Array();
	// args["runType"] = "RETRO"; // 급여구분(C00001-RETRO.소급)
	//
	// openPopup(url+"&authPg=R", args, w, h);

}

function getReturnValue(returnValue) {
	var rv = $.parseJSON('{' + returnValue+ '}');

    if(pGubun == "payDayPopup"){

		$("#payActionCd").val(rv["payActionCd"]);
		$("#payActionNm").val(rv["payActionNm"]);
		doAction1("Search");

    }
}

function setEmpPage() {
	$("#sabun").val($("#searchUserId").val());
	searchLatestPaymentInfo();
	if ($("#payActionCd").val() != "") {
		doAction1("Search");
	}
}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<!-- include 기본정보 page -->
	<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>
	<form id="sheet1Form" name="sheet1Form">
		<div class="sheet_search sheet_search_s outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='104477' mdef='급여일자'/></th>
						<td>  <input type="hidden" id="payActionCd" name="payActionCd" value="" /><input type="hidden" id="sabun" name="sabun" class="text" value="" />
						<input type="text" id="payActionNm" name="payActionNm" class="text required readonly" value="" readonly style="width:180px" />
						 <a onclick="javascript:payActionSearchPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a> </td>
						<td> <btn:a href="javascript:doAction1('Search')" css="button authR" mid='110697' mdef="조회"/> </td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<div id="tabs-0" class="pay_tab">
		<iframe name ="iframeSubMain" frameborder="0" class="tab_iframes"></iframe>
	</div>
</div>
</body>
</html>
