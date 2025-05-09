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
			메뉴 및 권한설정, 코드, 로그 관리 등 인사시스템을 운영하기 위한<br/>
			다양한 기능들을 제공합니다.
			 --%>
			<msg:txt mid='textBase11' mdef='메뉴 및 권한설정, 코드, 로그 관리 등 인사시스템을 운영하기 위한<br/>다양한 기능들을 제공합니다.'/>
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
