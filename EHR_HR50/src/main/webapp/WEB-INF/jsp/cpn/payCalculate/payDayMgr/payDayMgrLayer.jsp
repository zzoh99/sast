<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<title>이수시스템(주)</title>
<!-- IBSheet -->
<style type="text/css">
</style>
<script type="text/javascript">
var gCheckBtn = false;

$(function(){
	const modal = window.top.document.LayerModalUtility.getModal('payDayMgrLayer');
	let bigo = modal.parameters.bigo || ''
	$("#bigo").val(bigo);
	$("#bigo").maxbyte(4000);
});

//Ok 버튼 처리
function save() {
	const modal = window.top.document.LayerModalUtility.getModal('payDayMgrLayer');
	modal.fire('payDayMgrTrigger', {
		bigo : $("#bigo").val()
	}).hide();
}
</script>
</head>
<body class="bodywrap">
<form id="dataForm" name="dataForm" >
<div class="wrapper modal_layer">
	<div class="modal_body">
		<table class="table">
			<tr>
				<th>비고</th>
				<td>
					<textarea id="bigo" name="bigo" rows="10" class="text w100p" maxlength="4000"></textarea>
				</td>
			</tr>
		</table>
		<div class="modal_footer">
			<a href="javascript:closeCommonLayer('payDayMgrLayer');" class="btn outline_gray">닫기</a>
			<a href="javascript:save();" class="btn filled">저장</a>
		</div>
	</div>
</div>
</form>
</body>
</html>