<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='114015' mdef='개인정보보호법관리 sheet1 팝업'/></title>
<style type="text/css">
</style>
<script type="text/javascript">
var privacyActMgrLayer = {id:'privacyActMgrLayer'}; 
$(function(){
	const modal = window.top.document.LayerModalUtility.getModal(privacyActMgrLayer.id);
	var { infoSeq, subjectContents } = modal.parameters; 
	$("#infoSeq").val(infoSeq);
	$("#subjectContents").val(subjectContents);
});

function setValue() {
	var p = { infoSeq: $('#infoSeq').val(), subjectContents: $("#subjectContents").val() };
	const modal = window.top.document.LayerModalUtility.getModal(privacyActMgrLayer.id);
	modal.fire(privacyActMgrLayer.id + 'Trigger', p).hide();
}
</script>
</head>
<body class="bodywrap">

<div class="wrapper modal_layer">
	<div class="modal_body">
		<table class="table">
		<colgroup>
			<col width="20%" />
			<col width="80%" />
		</colgroup>
		<inptu type="hidden" id="infoSeq" name="infoSeq">
		<tr>
			<th><tit:txt mid='privacyActMgrV3' mdef='개인정보보호법'/></th>
			<td>
				<textarea id="subjectContents" name="subjectContents" style="width:99%;height:400px"></textarea>
			</td>
		</tr>
		</table>
	</div>
	<div class="modal_footer">
		<btn:a href="javascript:closeCommonLayer('privacyActMgrLayer');" css="btn outline_gray" mid='close' mdef="닫기"/>
		<btn:a href="javascript:setValue();" css="btn filled" mid='save' mdef="저장"/>
	</div>
</div>

</body>
</html>
