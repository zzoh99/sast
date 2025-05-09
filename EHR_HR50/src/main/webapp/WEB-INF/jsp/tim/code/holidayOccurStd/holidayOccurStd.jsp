<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>휴가발생기준</title>
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
		
		initTabsLine(); //탭 하단 라인 추가
		showIframe();
	});

	function showIframe() {
		
		if(typeof oldIframe != 'undefined') {
			oldIframe.attr("src","${ctx}/common/hidden.html");
		}

		if(iframeIdx == 0) {
			newIframe.attr("src","${ctx}/OccurStd.do?cmd=viewOccurStd&authPg=${authPg}");
		} else if(iframeIdx == 1) {
			newIframe.attr("src","${ctx}/UseStd.do?cmd=viewUseStd&authPg=${authPg}");
		} else if(iframeIdx == 2) {
			newIframe.attr("src","${ctx}/OccurExcStd.do?cmd=viewOccurExcStd&authPg=${authPg}");
			/*
		} else if(iframeIdx == 2) {
			newIframe.attr("src","${ctx}/SumStd.do?cmd=viewSumStd&authPg=${authPg}");*/
		} else if(iframeIdx == 3) {
			newIframe.attr("src","${ctx}/RealOccurStd.do?cmd=viewRealOccurStd&authPg=${authPg}");
		}
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">

	<div class="inner" style="height:100%;">
		<div id="tabs" class="tab">
			<ul class="tab_bottom">
				<li><a href="#tabs-1">발생조건</a></li>
				<li><a href="#tabs-2">사용기준</a></li>
				<li><a href="#tabs-3">하계휴가차감</a></li>
				<!-- li><a href="#tabs-3">연간휴가사용집계기준</a></li>-->
				<li><a href="#tabs-4">발생기준</a></li>
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
			<div id="tabs-4">
				<div  class='layout_tabs'>
					<iframe src='${ctx}/common/hidden.html' frameborder='0' class='tab_iframes'></iframe>
				</div>
			</div>
		</div>
	</div>
</div>
</body>
</html>