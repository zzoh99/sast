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
			급여, 상여, 성과급을 비롯하여 퇴직금, 연말정산 등 각종 인건비와 관련한<br/>
			지급 및 공제사항을 관리하고 내용을 조회할 수 있습니다.
			 --%>
			<msg:txt mid='textBase07' mdef='급여, 상여, 성과급을 비롯하여 퇴직금, 연말정산 등 각종 인건비와 관련한<br/>지급 및 공제사항을 관리하고 내용을 조회할 수 있습니다.'/>
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
