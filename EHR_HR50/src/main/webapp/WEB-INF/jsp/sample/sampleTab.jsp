<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>★Guide★</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

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

		showIframe();
	});

	function showIframe() {
		if(typeof oldIframe != 'undefined') {
			oldIframe.attr("src","${ctx}/common/hidden.html");
		}

		if(iframeIdx == 0) {
			newIframe.attr("src","${ctx}/Sample.do?cmd=viewSampleDefault");
		} else if(iframeIdx == 1) {
			newIframe.attr("src","${ctx}/Sample.do?cmd=viewSampleApproval&authPg=A");
		} else if(iframeIdx == 2) {
			newIframe.attr("src","${ctx}/html/sample/guide.html");
		}
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper popup_scroll">

	<div class="popup_main innertab inner" style="height:95%;">
		<div id="tabs" class="tab">
			<ul>
				<li><a href="#tabs-1">기본화면 가이드( sampleDefault.jsp )</a></li>
				<li><a href="#tabs-2">신청결재화면 가이드( sampleApproval.jsp )</a></li>
				<li><a href="#tabs-3">디자인가이드</a></li>
			</ul>
			<div id="tabs-1">
				<div  class="layout_tabs">
					<iframe src='${ctx}/common/hidden.html' frameborder='0' class='tab_iframes'></iframe>
				</div>
			</div>
			<div id="tabs-2">
				<div  class='layout_tabs'>
					<iframe src='${ctx}/common/hidden.html' frameborder='0' class='tab_iframes'></iframe>
				</div>
			</div>
			<div id="tabs-3">
				<div  class='layout_tabs'>
					<iframe src='${ctx}/common/hidden.html' frameborder='0' class='tab_iframes'></iframe>
				</div>
			</div>
		</div>
	</div>
</div>
</body>
</html>
