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
			경력개발.
			 --%>
			<msg:txt mid='textBase16' mdef='조직의 Needs와 개인의 Needs를 통합하여 인적자원의 역량강화 및 효율적인 인력운영을 도모하기 위한 제반 활동을 관리합니다.'/>
		</div>
	</c:when>
	<c:otherwise>
		<div class="txt"  style="background: rgba(0,0,0,0)">
			${map.mgrHelp}
		</div>
	</c:otherwise>
</c:choose>

	<div class="btn hide">
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
