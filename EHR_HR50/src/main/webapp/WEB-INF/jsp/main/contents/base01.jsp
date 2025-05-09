<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(document).ready(function() {
		var result = Math.floor(secureRandom() * 10);
		$(".btn li:eq("+result+")").addClass("on");
		$("#subMain").addClass("bg"+result);
		$(".btn li").click(function() {
			$(".btn li").each(function() {
				$(this).removeClass("on");
			});
			$(this).addClass("on");
			$("#subMain").attr("class", "");
			$("#subMain").addClass("bg"+$(this).index());
		});
	});
</script>

</head>
<body>
<div id="subMain">
<c:choose>
	<c:when test="${map.mgrHelp == null}">
		<div class="txt" style="background: rgba(0,0,0,0)">
			<%--
			기업성장의 원동력이 되는 인재채용과 관련한 진행절차를 시스템으로 지원합니다.<br/>
			홈페이지의 채용시스템에서 접수받는 지원자 정보가 인사시스템과 연계되며,<br/>
			최종 합격자 정보는 인사시스템으로 넘어오게 됩니다.
			--%>
			<msg:txt mid='textBase01' mdef='기업성장의 원동력이 되는 인재채용과 관련한 진행절차를 시스템으로 지원합니다.<br/>홈페이지의 채용시스템에서 접수받는 지원자 정보가 인사시스템과 연계되며,<br/>최종 합격자 정보는 인사시스템으로 넘어오게 됩니다.'/>
		</div>
	</c:when>
	<c:otherwise>
		<div class="txt"  style="background: rgba(0,0,0,0)">
			${map.mgrHelp}
		</div>
	</c:otherwise>
</c:choose>

	<div class="btn">
	<ul>
		<li></li>
		<li></li>
		<li></li>
		<li></li>
		<li></li>
		<li></li>
		<li></li>
		<li></li>
		<li></li>
		<li></li>
	</ul>
	</div>
</div>
</body>
</html>
