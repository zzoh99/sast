<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>퇴직금결과내역</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>
<!--
 * 퇴직금결과내역
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
});

//탭 높이 변경
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
	var action = "";

	if(iframeIdx == 0) {
		// 기본사항
		action = "/SepCalcResultSta.do?cmd=viewSepCalcResultStaBasic";
		//newIframe.attr("src","&authPg=${authPg}&vprgCd="+encodeURI("/View.do?cmd=viewSepCalcResultStaBasic"));
	} else if(iframeIdx == 1) {
		// 평균임금
		action = "/SepCalcResultSta.do?cmd=viewSepCalcResultStaAverageIncome";
		//newIframe.attr("src","${ctx}/View.do?cmd=viewSepCalcResultStaAverageIncome&authPg=${authPg}");
	} else if(iframeIdx == 2) {
		// 퇴직금계산내역
		action = "/SepCalcResultSta.do?cmd=viewSepCalcResultStaSeverancePayCalc";
		//newIframe.attr("src","${ctx}/View.do?cmd=viewSepCalcResultStaSeverancePayCalc&authPg=${authPg}");
	} else if(iframeIdx == 3) {
		// 퇴직종합정산
		action = "/SepCalcResultSta.do?cmd=viewSepCalcResultStaRetireCalc";
		//newIframe.attr("src","${ctx}/View.do?cmd=viewSepCalcResultStaRetireCalc&authPg=${authPg}");
	}
	$("#cmTabForm").find("#vprgCd").val(action);
	$("#cmTabForm").attr("action",action)
				.attr("method","post")
				.attr("target",newIframe.get(0).name)
				.submit();
}

function setEmpPage() {
	$('iframe')[iframeIdx].contentWindow.setEmpPage();
	getCpnLatestPaymentInfo();
	showIframe();
}

// 급여일자 검색 팝입
function payActionSearchPopup(){
	if(!isPopup()) {return;}
	gPRow = "";
	pGubun = "payDayPopup";

	let layerModal = new window.top.document.LayerModal({
		id : 'payDayLayer'
		, url : '/PayDayPopup.do?cmd=viewPayDayLayer&authPg=R'
		, parameters : {
			runType : '00004'
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

function getReturnValue(rv) {
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
	var paymentInfo = ajaxCall("${ctx}/SepCalcResultSta.do?cmd=getCpnQueryList", "queryId=getCpnLatestPaymentInfoMap&procNm="+procNm+"&runType=00004,&sabun="+sabun, false);

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
				<div class="layout_tabs"><iframe name="ifr1" src="${ctx}/common/hidden.html" frameborder="0" class="tab_iframes"></iframe></div>
			</div>
			<div id="tabs-2">
				<div class="layout_tabs"><iframe name="ifr2" src="${ctx}/common/hidden.html" frameborder="0" class="tab_iframes"></iframe></div>
			</div>
			<div id="tabs-3">
				<div class="layout_tabs"><iframe name="ifr3" src="${ctx}/common/hidden.html" frameborder="0" class="tab_iframes"></iframe></div>
			</div>
			<div id="tabs-4">
				<div class="layout_tabs"><iframe name="ifr4" src="${ctx}/common/hidden.html" frameborder="0" class="tab_iframes"></iframe></div>
			</div>
		</div>
	</div>
</div>
	<form id="cmTabForm" name="cmTabForm" action="" method="post">
		<input id="surl" name="surl" type="hidden" />
		<input id="dataPrgType" name="dataPrgType" type="hidden" />
		<input id="dataRwType" name="dataRwType" type="hidden" />
		<input id="authPg" name="authPg" type="hidden" value="${authPg}" />
		<input id="vprgCd" name="vprgCd" type="hidden" />
	</form>
</body>
</html>
