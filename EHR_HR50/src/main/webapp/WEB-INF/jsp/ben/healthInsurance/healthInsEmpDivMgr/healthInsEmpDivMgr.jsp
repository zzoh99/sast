<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="hidden">
<head>
<title><tit:txt mid='2017091901154' mdef='건강보험정산관리' /></title>
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
			case "1":  // 연말정산결과업로드
				$("#tab1").attr("src", "${ctx}/HealthInsEmpDivMgr.do?cmd=viewHealthInsEmpDivMgrTab1"+"&authPg=${authPg}");
				break;

			case "2":  // 생성
				$("#tab2").attr("src", "${ctx}/HealthInsEmpDivMgr.do?cmd=viewHealthInsEmpDivMgrTab2"+"&authPg=${authPg}");
				break;
				
			case "3":  // 연말정산보험료납부계획
				$("#tab3").attr("src", "${ctx}/HealthInsEmpDivMgr.do?cmd=viewHealthInsEmpDivMgrTab3"+"&authPg=${authPg}");
				break;

			default:
				$("#tab1").attr("src", "${ctx}/common/hidden.jsp");
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
					<li><a href="#tabs-1" onclick="javascript:showIframe('1');">연말정산결과업로드</a></li>
					<li style="display: none;"><a href="#tabs-2" onclick="javascript:showIframe('2');">생성</a></li>
					<li><a href="#tabs-3" onclick="javascript:showIframe('3');">연말정산보험료납부계획</a></li>
				</ul>

				<div id="tabs-1">
					<div class='layout_tabs'>
						<iframe id="tab1" name="tab1" src='${ctx}/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe>
					</div>
				</div>
				<div id="tabs-2">
					<div class='layout_tabs'>
						<iframe id="tab2" name="tab2" src='${ctx}/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe>
					</div>
				</div>
				<div id="tabs-3">
					<div class='layout_tabs'>
						<iframe id="tab3" name="tab3" src='${ctx}/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
