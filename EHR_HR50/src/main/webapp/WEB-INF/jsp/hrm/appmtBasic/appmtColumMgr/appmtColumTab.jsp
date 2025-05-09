<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='appmtColumMgr' mdef='발령항목정의'/></title>
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
			oldIframe.attr("src","about:blank<%-- /common/hidden.jsp --%>");
		}

		if(iframeIdx == 0) {
			newIframe.attr("src","${ctx}/AppmtColumMgr.do?cmd=viewAppmtColumMgr&authPg=${authPg}");
		} else if(iframeIdx == 1) {
			newIframe.attr("src","${ctx}/AppmtColumMgr.do?cmd=viewAppmtCodeMappingMgr&authPg=${authPg}");
		}
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">

	<div>
		<div id="tabs" class="tab">
			<ul>
				<li><btn:a href="#tabs-1" mid='111804' mdef="발령항목정의"/></li>
				<li><btn:a href="#tabs-2" mid='111672' mdef="인사기본사항매핑"/></li>
			</ul>
			<div id="tabs-1">
				<div  class="layout_tabs">
					<iframe src='about:blank<%-- /common/hidden.jsp --%>' frameborder='0' class='tab_iframes'></iframe>
				</div>
			</div>
			<div id="tabs-2">
				<div  class='layout_tabs'>
					<iframe src='about:blank<%-- /common/hidden.jsp --%>' frameborder='0' class='tab_iframes'></iframe>
				</div>
			</div>
		</div>
	</div>
</div>
</body>
</html>
