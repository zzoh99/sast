<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='104301' mdef='인사기본'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<c:set var="popUpStyle"  value="" />
<c:if test="${fn:length(param.searchSabun) > 0}">
	<c:set var="ssnSabun"  value="${param.searchSabun}" />
	<c:set var="popUpStyle"  value="padding:5px;" />
</c:if>
<script src="/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">
	function setEmpPage() {
		showCommonTab(0);
	}
	function viewTab(pMenuNm) {
		return true;
	}
	function addTabData(pData) {
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper wrapper_main">
	<!-- include 기본정보 page TODO -->
	<!-- include 기본정보 테스트 중.. inchuli -->
	<div style="${popUpStyle}">
	<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>
	</div>
	
	<!-- 공통탭 -->
	<%@ include file="/WEB-INF/jsp/common/include/commonTabInfo.jsp"%>
</div>
</body>
</html>
