<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='112385' mdef='급여집계(직급/소속별)'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 급여집계(직급/소속별)
 * @author JM
-->
<script type="text/javascript">
//iframe
var newIframe;
var oldIframe;
var iframeIdx;
var gPRow = "";
var pGubun = "";

$(function() {
	newIframe = $('#tabs-1 iframe');
	iframeIdx = 0;

	$( "#tabs" ).tabs({
		beforeActivate: function(event, ui) {
			iframeIdx = ui.newTab.index();
			newIframe = $(ui.newPanel).find('iframe');
			oldIframe = $(ui.oldPanel).find('iframe');
			showIframe();
		}
	});

	newIframe.attr("src","${ctx}/PayAggrSta.do?cmd=viewPayAggrStaAllowanceTotal&authPg=${authPg}");


	//------------------------------------- 조회조건 콤보 -------------------------------------//
	// 사업장
	<c:choose>
		<c:when test="${ssnSearchType == 'A'}">
			var tcpn121Cd = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getTcpn121List", false).codeList, ("${ssnLocaleCd}" != "en_US" ? "<tit:txt mid='103895' mdef='전체'/>" : "All"));
		</c:when>
		<c:otherwise>
			var tcpn121Cd = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getTcpn121List", false).codeList, "");
		</c:otherwise>
	</c:choose>
	$("#businessPlaceCd").html(tcpn121Cd[2]);

	// 화면 리사이즈
	$(window).resize(setIframeHeight);
	setIframeHeight();

	// 최근급여일자 조회
	getCpnLatestPaymentInfo();
});

// 탭 높이 변경
function setIframeHeight() {
	var iframeTop = $("#tabs ul.tab_bottom").height() + 16;
	$(".layout_tabs").each(function() {
		$(this).css("top",iframeTop);
	});
}

function showIframe() {
	if(typeof oldIframe != 'undefined') {
		oldIframe.attr("src","${ctx}/common/hidden.html");
	}
	if(iframeIdx == 0) {
		// 수당집계
		newIframe.attr("src","${ctx}/PayAggrSta.do?cmd=viewPayAggrStaAllowanceTotal&authPg=${authPg}");
	} else if(iframeIdx == 1) {
		// 공제집계
		newIframe.attr("src","${ctx}/PayAggrSta.do?cmd=viewPayAggrStaDeductionTotal&authPg=${authPg}");
	} else if(iframeIdx == 2) {
		<%--// 직급집계--%>
		<%--newIframe.attr("src","${ctx}/PayAggrSta.do?cmd=viewPayAggrStaJikgubTotal&authPg=${authPg}");--%>
		// 소속집계
		newIframe.attr("src","${ctx}/PayAggrSta.do?cmd=viewPayAggrStaOrgTotal&authPg=${authPg}");
	} else if(iframeIdx == 3) {
	}
}

// 필수값/유효성 체크
function chkInVal() {
	if ($("#payActionCd").val() == "") {
		alert("<msg:txt mid='109681' mdef='급여일자를 선택하십시오.'/>");
		$("#payActionNm").focus();
		return false;
	}

	return true;
}

function doAction1() {
	// 필수값/유효성 체크
	if (!chkInVal()) {
		return;
	}

	$('iframe')[iframeIdx].contentWindow.doAction1("Search");
}

// 최근급여일자 조회
function getCpnLatestPaymentInfo() {
	var procNm = "최근급여일자";
	// 급여구분(C00001-00001.급여)
	var paymentInfo = ajaxCall("${ctx}/PayAggrSta.do?cmd=getCpnQueryList", "queryId=getCpnLatestPaymentInfoMap&procNm="+procNm+"&runType=00001,", false);

	if (paymentInfo.DATA != null && paymentInfo.DATA != "" && typeof paymentInfo.DATA[0] != "undefined") {
		$("#payActionCd").val(paymentInfo.DATA[0].payActionCd);
		$("#payActionNm").val(paymentInfo.DATA[0].payActionNm);
	} else if (paymentInfo.Message != null && paymentInfo.Message != "") {
		alert(paymentInfo.Message);
	}
}

// 급여일자 검색 팝입
function payActionSearchPopup() {
	let layerModal = new window.top.document.LayerModal({
		id : 'payDayLayer'
		, url : '/PayDayPopup.do?cmd=viewPayDayLayer&authPg=R'
		, parameters : {
			runType : '00001,00002,ETC,J0001'
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
	//
	// args["runType"] = "00001,00002,ETC,J0001"; // 급여구분(C00001-00001.급여)
	//
	// var result = openPopup(url+"&authPg=R", args, w, h);
	/*
	if (result) {
		var payActionCd	= result["payActionCd"];
		var payActionNm	= result["payActionNm"];

		$("#payActionCd").val(payActionCd);
		$("#payActionNm").val(payActionNm);
	}
	*/
}

function getReturnValue(returnValue) {
	var rv = $.parseJSON('{' + returnValue+ '}');

    if(pGubun == "payDayPopup"){
		$("#payActionCd").val(rv["payActionCd"]);
		$("#payActionNm").val(rv["payActionNm"]);
    }
}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="mainForm" name="mainForm">
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='104477' mdef='급여일자'/></th>
						<td>  <input type="hidden" id="payActionCd" name="payActionCd" value="" /><input type="hidden" id="sabun" name="sabun" class="text" value="" />
												<input type="text" id="payActionNm" name="payActionNm" class="text required readonly" value="" readonly style="width:180px" />
						<a onclick="javascript:payActionSearchPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a> </td>
						<th><tit:txt mid='114399' mdef='사업장'/></th>
						<td>  <select id="businessPlaceCd" name="businessPlaceCd"> </select> </td>
						<td> <btn:a href="javascript:doAction1()"	css="btn dark authR" mid='110697' mdef="조회"/> </td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<div class="innertab inner" style="height:80%;">
		<div id="tabs" class="tab">
			<ul class="tab_bottom">
				<li><btn:a href="#tabs-1" mid='110886' mdef="수당집계"/></li>
				<li><btn:a href="#tabs-2" mid='111313' mdef="공제집계"/></li>
				<!-- <li><btn:a href="#tabs-3" mid='111783' mdef="직급집계"/></li>-->
				<li><btn:a href="#tabs-4" mid='111784' mdef="소속집계"/></li>
			</ul>
			<div id="tabs-1">
				<div class="layout_tabs"><iframe src="${ctx}/common/hidden.html" frameborder="0" class="tab_iframes"></iframe></div>
			</div>
			<div id="tabs-2">
				<div class="layout_tabs"><iframe src="${ctx}/common/hidden.html" frameborder="0" class="tab_iframes"></iframe></div>
			</div>
			<!--
			<div id="tabs-3">
				<div class="layout_tabs"><iframe src="${ctx}/common/hidden.html" frameborder="0" class="tab_iframes"></iframe></div>
			</div>
			 -->
			<div id="tabs-4">
				<div class="layout_tabs"><iframe src="${ctx}/common/hidden.html" frameborder="0" class="tab_iframes"></iframe></div>
			</div>
		</div>
	</div>
</div>
</body>
</html>
