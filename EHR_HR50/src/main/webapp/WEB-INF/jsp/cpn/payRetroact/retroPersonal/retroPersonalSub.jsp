<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='104487' mdef='월별급여지급현황 Sub Main'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 월별급여지급현황
 * @author JM
-->
<script type="text/javascript">
//iframe
var newIframe;
var oldIframe;
var iframeIdx;
var p = eval("${popUpStatus}");
$(function() {
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

	if (parent != null && parent.$("#searchUserId").val() != null && parent.$("#payActionCd").val() != null &&
		parent.$("#searchUserId").val() != "" && parent.$("#payActionCd").val() != "") {
		$("#sabun").val(parent.$("#searchUserId").val());
		$("#payActionCd").val(parent.$("#payActionCd").val());
	}

	$("#tab1Title").html("<tit:txt mid='104097' mdef='계산내역'/>");
	$("#tab2Title").html("<tit:txt mid='104191' mdef='소급대상 급여일자별 조회'/>");

	newIframe.attr("src","${ctx}/RetroPersonal.do?cmd=viewRetroPersonalSubLst&authPg=${authPg}");
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
	if(iframeIdx == 0) {
		// 급여내역
		newIframe.attr("src","${ctx}/RetroPersonal.do?cmd=viewRetroPersonalSubLst&authPg=${authPg}");
	} else if(iframeIdx == 1) {
		// 소급대상 급여일자별 조회
		newIframe.attr("src","${ctx}/RetroPersonal.do?cmd=viewRetroPersonalSubDtl&authPg=${authPg}");
	}
}

function doAction1(sAction) {
	switch (sAction) {
		case "Search":
			if (parent != null && parent.$("#searchUserId").val() != null && parent.$("#payActionCd").val() != null &&
				parent.$("#searchUserId").val() != "" && parent.$("#payActionCd").val() != "") {

				$("#sabun").val(parent.$("#searchUserId").val());
				$("#payActionCd").val(parent.$("#payActionCd").val());

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
		<div id="tabs">
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
	<input type="hidden" id="sabun" name="sabun" class="text" value="" />
	<input type="hidden" id="payActionCd" name="payActionCd" value="" />
	</div>
</div>
</body>
</html>
