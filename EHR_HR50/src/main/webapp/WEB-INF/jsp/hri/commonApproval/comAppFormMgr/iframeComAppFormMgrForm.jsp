<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> <title>공통신청 세부내역</title>
	<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
	<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
</head>
<script type="text/javascript">
	function init(arg) {
		$("#searchApplCd").val(arg["searchApplCd"]);
		$("#searchApplNm").html(arg["searchApplNm"]);
		init_form();
	}
</script>
<body class="bodywrap">
<div>
	<%@ include file="/WEB-INF/jsp/hri/commonApproval/comAppFormMgr/comAppFormMgrForm.jsp"%>
</div>

</body>
</html>