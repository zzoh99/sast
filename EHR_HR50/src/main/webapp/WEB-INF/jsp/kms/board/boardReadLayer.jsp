<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<base target="_self" />
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>공지사항</title>
<script type="text/javascript">
	$(function() {
		const modal = window.top.document.LayerModalUtility.getModal('boardReadLayer');
		modal.modalWrap.querySelector(".layer-modal-title").innerText = "${map.bbsNm}";
		setIframeHeight();

		submitCall($("#boardReadLayerForm"), "boardReadLayerIframe", "POST", "${ctx}/Board.do?cmd=viewBoardRead");
		jQuery('#boardReadLayerIframe').bind('load', function() { $('#boardReadLayerIframe').contents().find('.btn').hide(); });
	});

	function setIframeHeight() {
		const modal = window.top.document.LayerModalUtility.getModal('boardReadLayer');
		const modalBody = modal.modalWrap.querySelector(".modal_body");
		const modalBodyStyle = getComputedStyle(modalBody);
		const modalBodyH = modalBody.offsetHeight - parseFloat(modalBodyStyle.getPropertyValue("padding-top")) - parseFloat(modalBodyStyle.getPropertyValue("padding-bottom"));
		console.log("modalBodyH: ", modalBodyH);
		document.getElementById("boardReadLayerIframe").style.height = (modalBodyH - 5) + "px";
	}

	(function(makeMini, makeFull) {
		window.top.document.LayerModalUtility.getModal('boardReadLayer').makeMini = function() {
			makeMini.apply(this, arguments);
			setIframeHeight();
		}

		window.top.document.LayerModalUtility.getModal('boardReadLayer').makeFull = function() {
			makeFull.apply(this, arguments);
			setIframeHeight();
		}
	}(window.top.document.LayerModalUtility.getModal('boardReadLayer').makeMini, window.top.document.LayerModalUtility.getModal('boardReadLayer').makeFull));
</script>

</head>
<body class="bodywrap">
	<div class="wrapper modal_layer">
		<div class="modal_body">
			<form id="boardReadLayerForm" name="boardReadLayerForm" >
				<input type=hidden id="bbsCd" name="bbsCd" value="${map.bbsCd}">
				<input type=hidden id="bbsSeq" name="bbsSeq" value="${map.bbsSeq}">
			</form>
			<iframe name="boardReadLayerIframe" id="boardReadLayerIframe" src="" scrolling="auto" marginwidth="0" marginheight="0" frameborder="0" style="width:100%;height:590px;"></iframe>
		</div>
		<div class="modal_footer">
			<btn:a href="javascript:closeCommonLayer('boardReadLayer');" css="btn outline_gray large" mid='110881' mdef="닫기"/>
		</div>
	</div>
</body>
</html>
