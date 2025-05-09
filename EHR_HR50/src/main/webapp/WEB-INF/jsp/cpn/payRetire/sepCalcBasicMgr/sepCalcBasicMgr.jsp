<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>퇴직금기본내역</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>
<!--
 * 퇴직금기본내역
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

	// 화면 리사이즈
	$(window).resize(setIframeHeight);
	setIframeHeight();

	showIframe();

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
		// 기본사항
		newIframe.attr("src","${ctx}/SepCalcBasicMgr.do?cmd=viewSepCalcBasicMgrBasic&authPg=${authPg}");
	} else if(iframeIdx == 1) {
		// 평균임금
		newIframe.attr("src","${ctx}/SepCalcBasicMgr.do?cmd=viewSepCalcBasicMgrAverageIncome&authPg=${authPg}");
	} else if(iframeIdx == 2) {
		// 퇴직금계산내역
		newIframe.attr("src","${ctx}/SepCalcBasicMgr.do?cmd=viewSepCalcBasicMgrSeverancePayCalc&authPg=${authPg}");
	} else if(iframeIdx == 3) {
		// 퇴직종합정산
		newIframe.attr("src","${ctx}/SepCalcBasicMgr.do?cmd=viewSepCalcBasicMgrRetireCalc&authPg=${authPg}");
	}
}

function setEmpPage() {
	doAction1("Clear");
	getCpnLatestPaymentInfo();
	$('iframe')[iframeIdx].contentWindow.setEmpPage();
}

//최근급여일자 조회
function getCpnLatestPaymentInfo() {
	var procNm = "최근급여일자";
	var sabun = "";
	if ($("#searchUserId").val() != null && $("#searchUserId").val() != "") {
		sabun = $("#searchUserId").val();
	}

	$("#payActionCd").val("");
	$("#payActionNm").val("");

	// 급여구분(C00001-00004.퇴직금)
	var paymentInfo = ajaxCall("${ctx}/SepCalcBasicMgr.do?cmd=getCpnQueryList", "queryId=getCpnLatestPaymentInfoMap&procNm="+procNm+"&runType=00004,&sabun="+sabun, false);

	if (paymentInfo.DATA != null && paymentInfo.DATA != "" && typeof paymentInfo.DATA[0] != "undefined") {
		$("#payActionCd").val(paymentInfo.DATA[0].payActionCd);
		$("#payActionNm").val(paymentInfo.DATA[0].payActionNm);

		if ($("#payActionCd").val() != null && $("#payActionCd").val() != "") {
			//$('iframe')[iframeIdx].contentWindow.setEmpPage();
		}
	} else if (paymentInfo.Message != null && paymentInfo.Message != "") {
		alert(paymentInfo.Message);
	}
}

// 급여일자 검색 팝입
function payActionSearchPopup(){
	if(!isPopup()) {return;}
	gPRow = "";
	pGubun = "payDayPopup";

	let sabun	= "";

	if ($("#searchUserId").val() != null && $("#searchUserId").val() != "") {
		sabun = $("#searchUserId").val();
	}

	let layerModal = new window.top.document.LayerModal({
		id : 'payDayLayer'
		, url : '/PayDayPopup.do?cmd=viewPayDayLayer&authPg=R'
		, parameters : {
			runType : '00004',
			searchSabun : sabun
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
					if ($("#payActionCd").val() != null && $("#payActionCd").val() != "") {
						$('iframe')[iframeIdx].contentWindow.setEmpPage();
					}
				}
			}
		]
	});
	layerModal.show();
}

function getReturnValue(returnValue) {
}

// 필수값/유효성 체크
function chkInVal(sAction) {
	if($("#searchUserId").val() == "") {
		alert("대상자를 선택하십시오.");
		$("#tdSabun").focus();
		return false;
	}
	if($("#payActionCd").val() == "") {
		alert("퇴직일자를 선택하십시오.");
		$("#payActionCd").focus();
		return false;
	}
	return true;
}

function doAction1(sAction) {
	switch (sAction) {
		case "prcP_CPN_SEP_PAY_MAIN":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			// 퇴직금재계산
			if(confirm("퇴직금재계산을 시작하시겠습니까?")){
				var payActionCd = $("#payActionCd").val();
				var sabun = $("#searchUserId").val();

				var prcResult = ajaxCall("${ctx}/SepCalcBasicMgr.do?cmd=prcP_CPN_SEP_PAY_MAIN", "payActionCd="+payActionCd+"&businessPlaceCd=null&sabun="+sabun, false);

				if (prcResult != null && prcResult["Result"] != null && prcResult["Result"]["Code"] != null) {
					if (prcResult["Result"]["Code"] == "0") {
						alert("자료생성 되었습니다.");
						// 프로시저 호출 후 재조회
						if ($("#payActionCd").val() != null && $("#payActionCd").val() != "") {
							$('iframe')[iframeIdx].contentWindow.setEmpPage();
						}
					} else if (prcResult["Result"]["Message"] != null && prcResult["Result"]["Message"] != "") {
						alert(prcResult["Result"]["Message"]);
					}
				} else {
					alert("퇴직금재계산 오류입니다.");
				}
			}
			break;

		case "Clear":
			$('iframe')[iframeIdx].contentWindow.doAction1("Clear");
			break;
	}
}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<!-- include 기본정보 page -->
	<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>
	<form id="mainForm" name="mainForm">
	<div class="sheet_search outer">
		<div>
			<table>
				<tr>
					<th>급여일자</th>
					<td>  <input type="hidden" id="payActionCd" name="payActionCd" value="" />
						 <input type="text" id="payActionNm" name="payActionNm" class="text required readonly" value="" readonly style="width:180px" />
						 <a onclick="javascript:payActionSearchPopup();return false;" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a></td>
					<td> <btn:a href="javascript:doAction1('prcP_CPN_SEP_PAY_MAIN');"	css="basic authA" mid='reCalcV1' mdef="퇴직금재계산"/> </td>
				</tr>
			</table>
		</div>
	</div>
	</form>
	<div class="innertab inner" style="height:70%;">
		<div id="tabs" class="tabs">
			<ul class="tab_bottom">
				<li id="tabs1"><btn:a href="#tabs-1" mid='111330' mdef="기본사항"/></li>
				<li id="tabs2"><btn:a href="#tabs-2" mid='110897' mdef="평균임금"/></li>
				<li id="tabs3"><btn:a href="#tabs-3" mid='111158' mdef="퇴직금계산내역"/></li>
				<li id="tabs4"><btn:a href="#tabs-4" mid='110737' mdef="퇴직종합정산"/></li>
			</ul>
			<div id="tabs-1">
				<div class="layout_tabs"><iframe src="${ctx}/common/hidden.html" frameborder="0" class="tab_iframes"></iframe></div>
			</div>
			<div id="tabs-2">
				<div class="layout_tabs"><iframe src="${ctx}/common/hidden.html" frameborder="0" class="tab_iframes"></iframe></div>
			</div>
			<div id="tabs-3">
				<div class="layout_tabs"><iframe src="${ctx}/common/hidden.html" frameborder="0" class="tab_iframes"></iframe></div>
			</div>
			<div id="tabs-4">
				<div class="layout_tabs"><iframe src="${ctx}/common/hidden.html" frameborder="0" class="tab_iframes"></iframe></div>
			</div>
		</div>
	</div>
</div>
</body>
</html>
