<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>


<script type="text/javascript">
	$(function() {
		var modal = window.top.document.LayerModalUtility.getModal("perEmpContractSrchLayer");

		const result = ajaxTypeJson('/PerEmpContractSrch.do?cmd=getEncryptRd', modal.parameters.data, false);
		//적용
		var viewer = new m2soft.crownix.Viewer('${rdUrl}/ReportingServer/service', 'crownix-layer-viewer');
		viewer.setParameterEncrypt(11);
		viewer.openFile(result.DATA.path, result.DATA.encryptParameter, modal.parameters.opt);

		//window.top.showRdLayer('crownix-viewer', '/PerEmpContractSrch.do?cmd=getEncryptRd', modal.parameters.data, modal.parameters.opt);

	});

	function signPadLayer(){
		let layerModal = new window.top.document.LayerModal({
			id : 'signPadLayer' //식별자ID
			, url : '/PerEmpContractSrch.do?cmd=viewSignPadLayer' //팝업에 띄울 화면 jsp
			, parameters : {
			}
			, width : 500
			, height : 380
			, title : "서명하기"
			, trigger :[ //콜백
				{
					name : 'signPadLayerTrigger'
					, callback : function(rv){
						var modal = window.top.document.LayerModalUtility.getModal("perEmpContractSrchLayer");
						modal.fire('perEmpContractSrchLayerTrigger', rv).hide();
					}
				}
			]
		});
		layerModal.show();
	}

	//사인패드 서명 후 리턴
	function returnSignPad(rs){
		if(rs.FileSeq !== undefined && rs.FileSeq !== null && rs.FileSeq.length > 0) {
			if( !confirm("동의 하시겠습니까?\n(동의 후에는 본인이 취소할 수 없습니다.") ) return;

			var fileSeq = rs.FileSeq;
			const modal = window.top.document.LayerModalUtility.getModal("perEmpContractSrchLayer");
			const p = { fileSeq };

			modal.fire("perEmpContractSrchLayerTrigger", rs).hide();
		} else {
			alert("처리 중 오류가 발생했습니다.");
		}
	}

</script>
<div class="wrapper modal_layer">
	<div class="modal_body">
<%--		<div style="height: calc(100% - 65px);">--%>
		<div style="height: calc(100% - 200px);">
			<div id="crownix-layer-viewer" class="rd-viewer" style="position:absolute; top:0; left:0; width:100%; height:inherit;"></div>
		</div>
		<div id="divSignPad" style="position:absolute;left:50%;right:0;bottom:0;height:200px;margin-left:-200px;;">
			<iframe id="ifrmSignPad" name="ifrmSignPad" src="/Popup.do?cmd=signPadPopup" style="border:0px; width:400px; height:200px;"></iframe>
		</div>
	</div>
<%--	<div class="modal_footer">--%>
<%--		<a href="javascript:signPadLayer();" class="btn filled"><tit:txt mid='104157' mdef='서명하기'/></a>--%>
<%--		<a href="javascript:closeCommonLayer('perEmpContractSrchLayer');" class="btn outline_gray"><tit:txt mid='104157' mdef='닫기'/></a>--%>
<%--	</div>--%>
</div>