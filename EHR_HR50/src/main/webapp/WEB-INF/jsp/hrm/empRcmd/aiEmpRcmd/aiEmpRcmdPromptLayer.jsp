<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="hidden">
<head>
	<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
	<title>요청 프롬프트</title>
	<script type="text/javascript">

		$(function() {
			var modal = window.top.document.LayerModalUtility.getModal('aiEmpRcmdPromptLayer');
			const params = modal.parameters;
			$('#rGubun').val(params.rGubun);
			$('#rType').val(params.jobCd);
			$('#jobNm').val(params.jobNm);

			var prompt = ajaxCall("${ctx}/AiEmpRcmd.do?cmd=getAiEmpRcmdPrompt", $("#sheet1Form").serialize(), false).DATA;
			$('.prompt').html(prompt.replace(/\n/g, "<br>"));
			$('#prompt').val(prompt);
		})

		function requestApi(){
			var modal = window.top.document.LayerModalUtility.getModal('aiEmpRcmdPromptLayer');
			modal.fire('aiEmpRcmdPromptLayerTrigger', $('#prompt').val()).hide();
		}
	</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<div class="modal_body">
		<form id="sheet1Form" name="sheet1Form">
			<input type="hidden" id="rGubun" name="rGubun" value="" />
			<input type="hidden" id="rType" name="rType" value="" />
			<input type="hidden" id="jobNm" name="jobNm" value="" />
			<input type="hidden" id="prompt" name="prompt" value="" />
		</form>
		<div class="prompt"></div>
	</div>
	<div class="modal_footer">
		<a href="javascript:requestApi();" class="btn outline_gray">요청</a>
		<a href="javascript:closeCommonLayer('aiEmpRcmdPromptLayer');" class="btn outline_gray">닫기</a>
	</div>
</div>
</body>
</html>