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
			회사의 구성원들이 목표를 효과적으로 달성하기 위해서는 체계화된 구조를 필요로 합니다.<br/>
			시스템에서는 업무조직구조 및 그에 따른 역할과 책임을 효율적으로 배분하고 체계화합니다.
			 --%>
			<msg:txt mid='textBase03' mdef='회사의 구성원들이 목표를 효과적으로 달성하기 위해서는 체계화된 구조를 필요로 합니다.<br/>시스템에서는 업무조직구조 및 그에 따른 역할과 책임을 효율적으로 배분하고 체계화합니다.'/>
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
