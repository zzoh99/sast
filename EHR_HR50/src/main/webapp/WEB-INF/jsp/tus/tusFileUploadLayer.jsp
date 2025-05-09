<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
	<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
	<title><tit:txt mid='prgMng' mdef='업로드'/></title>
<%--	<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>--%>
	<script src="${ctx}/common/plugin/uppy/v3.21.0/uppy.legacy.min.js" type="text/javascript" charset="utf-8"></script>
	<link href="${ctx}/common/plugin/uppy/v3.21.0/uppy.min.css" rel="stylesheet" />

</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<div class="modal_body">
		<div id="uppy"></div>
	</div>
	<div class="modal_footer">
		<a href="javascript:close();" class="btn outline_gray">확인</a>
	</div>
</div>

<script>
	function close() {
		const modal = window.top.document.LayerModalUtility.getModal('tusFileUploadLayer');
		modal.fire('tusFileUploadTrigger', {}).hide();
	}
	$(function() {
		const modal = window.top.document.LayerModalUtility.getModal('tusFileUploadLayer');
		let year = modal.parameters.year;
		if(!/^\d{4}$/.test(year)) modal.hide();
		var MB = 1024 * 1024;

		const { Dashboard, Tus } = Uppy
		const uppy = new Uppy.Uppy({ debug: true, autoProceed: false })
				.use(Dashboard, { target: '#uppy', inline: true })
				.use(Tus, {
					endpoint: "/tus/api/file/upload",
					chunkSize: 10 * MB,
					retryDelays: [0],
					headers:{
						['bucket-path']:year
					},
					addRequestId:true
				});

		uppy.on('success', function (fileCount) {
			close();
		});

		$(".close").click(function() {
			close();
		});
	});
</script>

</body>

</html>
