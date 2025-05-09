<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='114350' mdef='설문지 설명 팝업'/></title>
<script type="text/javascript">
var sheet1 	= null;
var sRow	= null;
$(function(){
	const modal = window.top.document.LayerModalUtility.getModal('researchMgrDescLayer');
	$("#memo").val(modal.parameters.memo);
});

function save() {
	const p = {
		memo : $("#memo").val()
	};

	var modal = window.top.document.LayerModalUtility.getModal('researchMgrDescLayer');
	modal.fire('researchMgrDescLayerTrigger', p).hide();
}
</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<div class="modal_body">
		<form id="sheetForm" name="sheetForm" >
			<table class="table">
				<colgroup>
					<col width="100%" />
				</colgroup>
				<tr>
					<td>
						<textarea id="memo" name="memo" style="width:99%;height:200px"></textarea>
					</td>
				</tr>

			</table>
		</form>
	</div>
	<div class="modal_footer">
		<btn:a href="javascript:closeCommonLayer('researchMgrDescLayer');" css="btn outline_gray" mid='close' mdef="닫기"/>
		<btn:a href="javascript:save();" css="btn filled" mid='ok' mdef="확인"/>
	</div>
</div>

</body>
</html>
