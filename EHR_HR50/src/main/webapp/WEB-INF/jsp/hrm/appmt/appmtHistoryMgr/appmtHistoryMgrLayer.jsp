<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<script type="text/javascript">
function fnClose(){
	const modal = window.top.document.LayerModalUtility.getModal('appmtHistoryMgrLayer');
	modal.fire('appmtHistoryMgrLayerTrigger', {}).hide();
}

function fnSave(){
	try{
		const modal = window.top.document.LayerModalUtility.getModal('appmtHistoryMgrLayer');
		const comment = $('#comment').val();
		modal.fire('appmtHistoryMgrLayerTrigger', {comment}).hide();
	}catch(ex) {
		alert("Script Errors Occurred While Saving." + ex);
		return;
	}
}
</script>
<div class="wrapper popup_scroll modal_layer">
	<div class="modal_body">
		<form id="popFrm" name="popFrm" >
			<table class="table">
				<colgroup>
					<col width="15%" />
					<col width="" />
				</colgroup>
				<tr>
					<td>
						<textarea id="comment" name="comment" rows="3" style="height: 200px"></textarea>
					</td>
				</tr>
			</table>
		</form>
	</div>
	<div class="modal_footer">
		<a href="javascript:fnSave();" class="btn filled"><tit:txt mid='104476' mdef='저장'/></a>
		<a href="javascript:fnClose();" class="btn outline_gray"><tit:txt mid='104157' mdef='닫기'/></a>
	</div>
</div>
