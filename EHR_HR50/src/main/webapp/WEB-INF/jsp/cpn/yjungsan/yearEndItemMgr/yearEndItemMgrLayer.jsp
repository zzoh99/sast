<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html class="hidden">
<head>
	<title>연말정산항목관리 팝업</title>
	<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
	<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp" %>
	<style>
		.full-size-table {
			height: 500px;
			width: 100%;
		}
	</style>
<script type="text/javascript">
	$(function(){
		const modal = window.top.document.LayerModalUtility.getModal('yearEndItemMgrLayer');

		let itemDtlGuide = modal.parameters.itemDtlGuide || '';
		$('#itemDtlGuide').val(itemDtlGuide);
	});

	function setValue() {
		const modal = window.top.document.LayerModalUtility.getModal('yearEndItemMgrLayer');
		modal.fire('yearEndItemMgrLayerTrigger', {
			itemDtlGuide : $('#itemDtlGuide').val()
		}).hide();
	}

</script>
</head>
<body class="bodywrap">

<div class="wrapper modal_layer">

	<form id="mySheetForm" name="mySheetForm" />

	<div class="modal_body">
		<table class="table full-size-table">
			<colgroup>
				<col width="9%" />
				<col width="91%" />
			</colgroup>
			<tr>
				<th>도움말</th>
				<td>
					<textarea id="itemDtlGuide" name="itemDtlGuide"rows="13" class="w100p" style="height: 100%"></textarea>
				</td>
			</tr>

		</table>
	</div>
	<div class="modal_footer">
		<a href="javascript:setValue();"       class="btn filled" id="addBtn">확인</a>
		<a href="javascript:closeCommonLayer('yearEndItemMgrLayer');"  class="btn outline_gray">닫기</a>
	</div>
</div>

</body>
</html>