<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="hidden">
<head>
<title><tit:txt mid='2017091901154' mdef='사회보험요율관리' /></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {
		$( "#tabs" ).tabs();
		showIframe('1');
	});

	function showIframe(iframeIdx) {
		switch(iframeIdx){
			case "1":  // 국민연금
				$("#tab1").attr("src", "${ctx}/SocInsRatesMgr.do?cmd=viewNatiPenRatioMgr"+"&authPg=${authPg}");
				break;

			case "2":  // 건강보험
				$("#tab2").attr("src", "${ctx}/SocInsRatesMgr.do?cmd=viewHealthRatioMgr"+"&authPg=${authPg}");
				break;

			case "3":  // 고용보험
				$("#tab3").attr("src", "${ctx}/SocInsRatesMgr.do?cmd=viewEmpRatioMgr"+"&authPg=${authPg}");
				break;

			case "4":  // 산재보험
				$("#tab4").attr("src", "${ctx}/SocInsRatesMgr.do?cmd=viewAccRatioMgr"+"&authPg=${authPg}");
				break;

			default:
				$("#tab1").attr("src", "${ctx}/common/hidden.html");
				break;
		}
	}
</script>

</head>
<body class="bodywrap">
	<div class="wrapper">
		<div class="innertab inner" style="height:95%;">
			<div id="tabs" class="tab">
				<ul>
					<li><a href="#tabs-1" onclick="javascript:showIframe('1');"><tit:txt mid='natiPenRatioMgr' mdef='국민연금요율' /></a></li>
					<li><a href="#tabs-2" onclick="javascript:showIframe('2');"><tit:txt mid='healthRatioMgr' mdef='건강보험요율' /></a></li>
					<li><a href="#tabs-3" onclick="javascript:showIframe('3');"><tit:txt mid='empRatioMgr' mdef='고용보험요율' /></a></li>
					<li><a href="#tabs-4" onclick="javascript:showIframe('4');"><tit:txt mid='114388' mdef='산재보험요율' /></a></li>
				</ul>

				<div id="tabs-1">
					<div class='layout_tabs'>
						<iframe id="tab1" name="tab1" src='${ctx}/common/hidden.html' frameborder='0' class='tab_iframes'></iframe>
					</div>
				</div>
				<div id="tabs-2">
					<div class='layout_tabs'>
						<iframe id="tab2" name="tab2" src='${ctx}/common/hidden.html' frameborder='0' class='tab_iframes'></iframe>
					</div>
				</div>
				<div id="tabs-3">
					<div class='layout_tabs'>
						<iframe id="tab3" name="tab3" src='${ctx}/common/hidden.html' frameborder='0' class='tab_iframes'></iframe>
					</div>
				</div>
				<div id="tabs-4">
					<div class='layout_tabs'>
						<iframe id="tab4" name="tab4" src='${ctx}/common/hidden.html' frameborder='0' class='tab_iframes'></iframe>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
