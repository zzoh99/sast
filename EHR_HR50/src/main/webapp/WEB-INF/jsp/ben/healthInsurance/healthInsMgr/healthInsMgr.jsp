<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='104270' mdef='건강보험기본사항'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>
<!--
 * 건강보험기본사항
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

	// 화면 리사이즈
	$(window).resize(setIframeHeight);
	setIframeHeight();

	$("#tab1Title").html("기본사항/변동내역");
	$("#tab2Title").html("불입내역");

	showIframe();
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
		// 기본사항/변동내역
		newIframe.attr("src","${ctx}/HealthInsMgr.do?cmd=viewHealthInsMgrBasicChange&authPg=${authPg}");
	} else if(iframeIdx == 1) {
		// 불입내역
		newIframe.attr("src","${ctx}/HealthInsMgr.do?cmd=viewHealthInsMgrPayment&authPg=${authPg}");
	}
}

function setEmpPage() {
	$('iframe')[iframeIdx].contentWindow.doAction1("Search");
}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<!-- include 기본정보 page -->
	<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>
	<div class="innertab inner" style="height:calc(80% - 24px);">
		<div id="tabs" class="tab">
			<ul class="tab_bottom">
				<li><a href="#tabs-1"><span id="tab1Title"></span></a></li>
				<li><a href="#tabs-2"><span id="tab2Title"></span></a></li>
			</ul>
			<div id="tabs-1">
				<div class="layout_tabs"><iframe src="${ctx}/common/hidden.html" frameborder="0" class="tab_iframes"></iframe></div>
			</div>
			<div id="tabs-2">
				<div class="layout_tabs"><iframe src="${ctx}/common/hidden.html" frameborder="0" class="tab_iframes"></iframe></div>
			</div>
		</div>
	</div>
</div>
</body>
</html>
