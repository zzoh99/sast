<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="hidden">
<head>
	<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
	<title>프롬프트</title>
	<script type="text/javascript">

		$(function() {
			var modal = window.top.document.LayerModalUtility.getModal('aiEmpRcmdMgrLayer');
			const params = modal.parameters;

			const data = ajaxCall("${ctx}/AiEmpRcmdMgr.do?cmd=getAiEmpRcmdMgrTypeMap", queryStringToJson(params), false).DATA;
			$('#rGubun').val(data.rGubun);
			$('#rPrompt').val(data.rPrompt);
			$('#useYn').val(data.useYn);
		})

		function savePrompt(){
			const data = ajaxCall("${ctx}/AiEmpRcmdMgr.do?cmd=saveAiEmpRcmdMgrPrompt", $("#sheetForm").serialize(), false);
			if(data.Result.Code < 1) {
				returnValue = false;
			}else{
				returnValue = true;
				alert(data.Result.Message);
				closeCommonLayer('aiEmpRcmdMgrLayer');
			}
			// if(data != null && data.Message != 'undefined') {
			// 	alert(data.Message);
			// 	closeCommonLayer('aiEmpRcmdMgrLayer');
			// }
		}
	</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<div class="modal_body">
		<form id="sheetForm" name="sheetForm">
			<input type="hidden" id="rGubun" name="rGubun" />
			<input type="hidden" id="useYn" name="useYn" />
			<textarea id="rPrompt" name="rPrompt"  rows="13" cols="85" class="w100p" style="resize: none;"></textarea>
		</form>
	</div>
	<div class="modal_footer">
		<a href="javascript:savePrompt();" class="btn outline_gray">저장</a>
		<a href="javascript:closeCommonLayer('aiEmpRcmdMgrLayer');" class="btn outline_gray">닫기</a>
	</div>
</div>
</body>
</html>