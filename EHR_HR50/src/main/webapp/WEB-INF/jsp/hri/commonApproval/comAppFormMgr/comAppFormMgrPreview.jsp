<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>공통신청서-미리보기</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->

<script type="text/javascript">
	$(function() {

		const modal = window.top.document.LayerModalUtility.getModal('comAppFormMgrPreviewLayer');
		var arg = modal.parameters;
        if( arg != undefined ) {
            $("#searchApplCd").val(arg["searchApplCd"]);
            $("#searchApplNm").html(arg["searchApplNm"]);
        }

		// $("#iframeComAppFormMgrForm").get(0).contentWindow.init()

		$("#iframeComAppFormMgrForm").on("load", function() {
			var iframe = $(this)[0]; // jQuery로 iframe 요소 선택
			iframe.contentWindow.init(arg); // iframe 내부 함수 호출
		});
	});
	
</script>
</head>
<body class="bodywrap">

    <div class="wrapper modal_layer">
        <div class="modal_body">
        
			<div class="sheet_title">
				<ul>
					<li id="searchApplNm" class="txt">&nbsp;</li>
				</ul>
			</div>

			<iframe src="/ComAppFormMgr.do?cmd=viewIframeComAppFormMgrForm&authPg=A" id="iframeComAppFormMgrForm" name="iframeComAppFormMgrForm" frameborder="0" class="author_iframe" style="height:100%"></iframe>

        </div>
		<div class="modal_footer">
			<a href="javascript:closeCommonLayer('comAppFormMgrPreviewLayer');" class="gray large"><tit:txt mid='104157' mdef='닫기'/></a>
		</div>
	</div>

</div>
</body>
</html>
