<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='104384' mdef='개인별급여세부내역(관리자) Sub Main'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 개인별급여세부내역(관리자)
 * @author JM
-->
<script type="text/javascript">
//iframe
var newIframe;
var oldIframe;
var iframeIdx;
var p = eval("${popUpStatus}");
$(function() {

	initTabsLine(); //탭 하단 라인 추가
	
	var arg = p.window.dialogArguments;
	if (arg != null) {
		if (arg["payActionCd"] != null) {
			$("#payActionCd").val(arg["payActionCd"]);
		}
		if (arg["sabun"] != null) {
			$("#sabun").val(arg["sabun"]);
		}
	}

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

	/* parent.$("").html에서 $("", parent.document)형식으로 모든브라우져 커버하도록 변경 by JSG*/
	if (parent != null) {
		if ($("#sabun", parent.document).val() != null && $("#sabun", parent.document).val() !== "") {
			$("#sabun").val($("#sabun", parent.document).val());
		} else if ($("#tdSabun", parent.document).text() != null && $("#tdSabun", parent.document).text() !== "") {
			$("#sabun").val($("#tdSabun", parent.document).text());
		}

		if ($("#payActionCd", parent.document).val() != null && $("#payActionCd", parent.document).val() !== "") {
			$("#payActionCd").val($("#payActionCd", parent.document).val());
		}
	}

	$("#tab1Title").html("<tit:txt mid='104379' mdef='급여내역'/>");
	$("#tab2Title").html("<tit:txt mid='104289' mdef='근태/기타내역'/>");
	$("#tab3Title").html("<tit:txt mid='perPayPartiAdminStaDtl' mdef='항목세부내역'/>");

	newIframe.attr("src","${ctx}/PerPayPartiTermUSta.do?cmd=viewPerPayPartiAdminStaCalc&authPg=${authPg}");
});

//탭 높이 변경
function setIframeHeight() {
	var iframeTop = $("#tabs ul.tab_bottom").height() + 5;
	$(".layout_tabs").each(function() {
		$(this).css("top",iframeTop);
	});
}

function showIframe() {
	if(typeof oldIframe != 'undefined') {
		oldIframe.attr("src","${ctx}/common/hidden.html");
	}
	if(iframeIdx == 0) {
		// 급여내역
		newIframe.attr("src","${ctx}/PerPayPartiTermUSta.do?cmd=viewPerPayPartiAdminStaCalc&authPg=${authPg}");
	} else if(iframeIdx == 1) {
		// 근태/근무내역
		newIframe.attr("src","${ctx}/PerPayPartiTermUSta.do?cmd=viewPerPayPartiAdminStaEtc&authPg=${authPg}");
	} else if(iframeIdx == 2) {
		// 항목세부내역
		newIframe.attr("src","${ctx}/PerPayPartiTermUSta.do?cmd=viewPerPayPartiAdminStaDtl&authPg=${authPg}");
	}
}

function doAction1(sAction) {
	switch (sAction) {
		case "Search":
			if (parent != null && $("#sabun", parent.document).val() != null && $("#payActionCd", parent.document).val() != null &&
				$("#sabun", parent.document).val() != "" && $("#payActionCd", parent.document).val() != "") {

				$("#sabun").val($("#sabun", parent.document).val());
				$("#payActionCd").val($("#payActionCd", parent.document).val());

				$('iframe')[iframeIdx].contentWindow.doAction1("Search");
			}
			break;
	}
}
</script>
</head>
<body class="hidden">
<div class="wrapper">
<div class="inner" style="height:100%;">
	<div id="tabs" class="tab">
		<div class='ui-tabs-nav-line'></div> <!-- 탭 하단 라인 -->
		<ul  class="tab_bottom">
			<li><a href="#tabs-1"><span id="tab1Title"></span></a></li>
			<li><a href="#tabs-2"><span id="tab2Title"></span></a></li>
			<li><a href="#tabs-3"><span id="tab3Title"></span></a></li>
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
	</div>
	<input type="hidden" id="sabun" name="sabun" class="text" value="" />
	<input type="hidden" id="payActionCd" name="payActionCd" value="" />
	</div>
</div>
</body>
</html>
