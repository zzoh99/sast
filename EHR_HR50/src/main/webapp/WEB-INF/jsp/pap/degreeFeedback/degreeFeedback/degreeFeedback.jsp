<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<link href="/common/plugin/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<script type="text/javascript" src="/common/plugin/bootstrap/js/bootstrap.bundle.min.js"></script>

<script type="text/javascript">
	$(function() {
		$("#modalAlert").modal("show");
	});

</script>
</head>
<body>
	<div class="layer-wrap">
		<div id="modalAlert" class="modal modal-alert fade">
			<div class="modal-dialog modal-dialog-centered">
				<div class="modal-content">
					<div class="modal-header modal-header-flex">
						<h5 class="modal-title">AI 본문요약</h5>
						<p class="modal-close">
							<button type="button" data-close="modal" class="no-style close"><i class="icon-modal-close">닫기</i></button>
						</p>
					</div>
					<div class="modal-body">
						modal1
					</div>
				</div>
			</div>
			<p class="backdrop-dim"></p>
		</div>
	</div>
</body>
</html>
