<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='112787' mdef='급여기본사항'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
<c:choose>
	<c:when test="${authPg == 'A'}">
		<c:set var="authPg"	value="${authPg}" />
	</c:when>
	<c:otherwise>
		<c:set var="authPg"	value="" />
	</c:otherwise>
</c:choose>
 -->
<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>
<!--
 * 급여기본사항
 * @author JM
-->
<script type="text/javascript">
//iframe
var newIframe;
var oldIframe;
var iframeIdx;

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

	newIframe.attr("src","${ctx}/PerPayMasterMgr.do?cmd=viewPerPayMasterMgrBasic&authPg=${authPg}");

	// 화면 리사이즈
	$(window).resize(setIframeHeight);
	setIframeHeight();

});

//탭 높이 변경
function setIframeHeight() {

	// 1. innertab 높이 지정.
	const wrpH = document.querySelector("div.wrapper").offsetHeight;
	const empHeaderH = document.querySelector("#area_employee_header").offsetHeight;
	document.querySelector("div.innertab").style.height = (wrpH - empHeaderH) + "px";

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
		newIframe.attr("src","${ctx}/PerPayMasterMgr.do?cmd=viewPerPayMasterMgrBasic&authPg=${authPg}");
	} else if(iframeIdx == 1) {
		// 지급/공제 예외사항
		newIframe.attr("src","${ctx}/PerPayMasterMgr.do?cmd=viewPerPayMasterMgrException&authPg=${authPg}");
	} else if(iframeIdx == 2) {
		// 연봉이력
		newIframe.attr("src","${ctx}/PerPayMasterMgr.do?cmd=viewPerPayMasterMgrAnnualIncome&authPg=${authPg}");
	} else if(iframeIdx == 3) {
		// 퇴직금중간정산
		newIframe.attr("src","${ctx}/PerPayMasterMgr.do?cmd=viewPerPayMasterMgrSeverancePay&authPg=${authPg}");
	} else if(iframeIdx == 4) {
		// 급여압류
		newIframe.attr("src","${ctx}/PerPayMasterMgr.do?cmd=viewPerPayMasterMgrPayAttach&authPg=${authPg}");
	} else if(iframeIdx == 5) {
		// 사회보험
		newIframe.attr("src","${ctx}/PerPayMasterMgr.do?cmd=viewPerPayMasterMgrSocialInsurance&authPg=${authPg}");
	} else if(iframeIdx == 6) {
		// 임금피크
		newIframe.attr("src","${ctx}/PerPayMasterMgr.do?cmd=viewPerPayMasterMgrSalaryPeak&authPg=${authPg}");
	} 
	/*
	  else if(iframeIdx == 6) {
		// 대출현황
		newIframe.attr("src","${ctx}/PerPayMasterMgr.do?cmd=viewPerPayMasterMgrLoanInfo&authPg=${authPg}");
	}
	*/
}

function setEmpPage() {
	$('iframe')[iframeIdx].contentWindow.setEmpPage();
}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<!-- include 기본정보 page -->
	<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>
	<div class="innertab inner">
		<div id="tabs" class="tab">
			<ul class="tab_bottom">
				<li id="tabs1"><btn:a href="#tabs-1" mid='111330' mdef="기본사항"/></li>
				<c:if test="${authPg == 'A'}">
				<li id="tabs2"><btn:a href="#tabs-2" mid='111161' mdef="지급/공제 예외사항"/></li>
				<li id="tabs3"><btn:a href="#tabs-3" mid='111333' mdef="연봉이력"/></li>
				</c:if>
				<li id="tabs4"><btn:a href="#tabs-4" mid='111494' mdef="퇴직금중간정산"/></li>
				<li id="tabs5"><btn:a href="#tabs-5" mid='111495' mdef="급여압류"/></li>
				<c:if test="${authPg == 'A'}">
				<li id="tabs6"><btn:a href="#tabs-6" mid='110901' mdef="사회보험"/></li>
				</c:if>
				
				<li id="tabs7"><btn:a href="#tabs-7" mid='111796' mdef="임금피크"/></li>
				
			</ul>
			<div id="tabs-1">
				<div class="layout_tabs"><iframe src="${ctx}/common/hidden.html" frameborder="0" class="tab_iframes"></iframe></div>
			</div>
			<c:if test="${authPg == 'A'}">
			<div id="tabs-2">
				<div class="layout_tabs"><iframe src="${ctx}/common/hidden.html" frameborder="0" class="tab_iframes"></iframe></div>
			</div>
			<div id="tabs-3">
				<div class="layout_tabs"><iframe src="${ctx}/common/hidden.html" frameborder="0" class="tab_iframes"></iframe></div>
			</div>
			</c:if>
			<div id="tabs-4">
				<div class="layout_tabs"><iframe src="${ctx}/common/hidden.html" frameborder="0" class="tab_iframes"></iframe></div>
			</div>
			<div id="tabs-5">
				<div class="layout_tabs"><iframe src="${ctx}/common/hidden.html" frameborder="0" class="tab_iframes"></iframe></div>
			</div>
			<c:if test="${authPg == 'A'}">
			<div id="tabs-6">
				<div class="layout_tabs"><iframe src="${ctx}/common/hidden.html" frameborder="0" class="tab_iframes"></iframe></div>
			</div>
			</c:if>
			
			<div id="tabs-7">
				<div class="layout_tabs"><iframe src="${ctx}/common/hidden.html" frameborder="0" class="tab_iframes"></iframe></div>
			</div>
			
		</div>
	</div>
</div>
</body>
</html>
