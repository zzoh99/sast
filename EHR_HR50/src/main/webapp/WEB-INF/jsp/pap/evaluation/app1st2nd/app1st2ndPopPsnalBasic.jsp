<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head><title>인사정보</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<c:set var="popUpStyle"  value="" />
<c:if test="${fn:length(param.searchSabun) > 0}">
	<c:set var="ssnSabun"  value="${param.searchSabun}" />
	<c:set var="popUpStyle"  value="padding:5px;margin-right:5px;" />
</c:if>

<script src="/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">
var p = eval("${popUpStatus}");
var comBtnAuthPg = "R";
$(function() {

	$(".close").click(function() {
		p.self.close();
	});
});


function setEmpPage() {
	showCommonTab(0);
}
function viewTab(pMenuNm) {
	var rtn = "none";

	if ( pMenuNm == "기본" || pMenuNm == "발령" || pMenuNm == "교육" || pMenuNm == "학력" || pMenuNm == "자격" || pMenuNm == "경력" || pMenuNm == "상벌" || pMenuNm == "평가"   ) rtn = "";

	return rtn;
	//return true;
}

function addTabData(pData) {
	pData.DATA.push({prgPath:"/pap/progress/", prgCd:"/AppFeedBackLst.do?cmd=viewAppFeedBackLstTab", menuNm:"평가", dataPrgType:"P", dataRwType:"R"});
}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="subForm" name="subForm">
	<input type="hidden" id="surl" name="surl" value=""/>
	</form>
	<!-- include 기본정보 page TODO -->
	<!-- include 기본정보 테스트 중.. inchuli -->
	<div style="${popUpStyle}">
	<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>
	</div>

	<!-- 공통탭 -->
	<%@ include file="/WEB-INF/jsp/common/include/commonTabInfo.jsp"%>
</div>
<script type="text/javascript">

function getTopWindow(){
	return this;
}
</script>
</body>
</html>