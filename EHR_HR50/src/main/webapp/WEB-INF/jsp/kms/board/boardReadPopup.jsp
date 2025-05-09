<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<base target="_self" />
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var p = eval("${popUpStatus}");
	$(function() {
		$(".close").click(function() {
			p.self.close();
		});

		submitCall($("#srchPopFrm"),"iFrame_popup","POST","${ctx}/Board.do?cmd=viewBoardRead");
		jQuery('#iFrame_popup').bind('load', function() { $('#iFrame_popup').contents().find('.btn').hide(); });

	});

</script>

</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="popup_title">
		<ul>
			<li>${map.bbsNm}</li>
			<li class="close"></li>
		</ul>
	</div>
	<div class="popup_main">
		<form id="srchPopFrm" name="srchPopFrm" >
			<input type=hidden id="bbsCd" name="bbsCd" value="${map.bbsCd}">
			<input type=hidden id="bbsSeq" name="bbsSeq" value="${map.bbsSeq}">
		</form>
		<iframe name="iFrame_popup" id="iFrame_popup" src="" scrolling="auto" marginwidth="0" marginheight="0" frameborder="0" style="width:100%;height:650px;"></iframe>

		<div class="popup_button outer">
			<ul>
				<li>
					<a href="javascript:p.self.close();" class="gray large"><tit:txt mid='104157' mdef='닫기'/></a>
				</li>
			</ul>
		</div>
	</div>
</div>
</body>
</html>
