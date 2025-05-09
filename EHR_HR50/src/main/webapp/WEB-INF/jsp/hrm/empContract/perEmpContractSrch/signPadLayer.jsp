<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->

<script type="text/javascript">


	var rdSignLayer = { id: 'signPadLayer' };
	$(function() {


		var rdTitle= "";
		var rdMrd = "";
		var rdParam= "";
		var rdParamGubun = "";
		const modal = window.top.document.LayerModalUtility.getModal(rdSignLayer.id);
		var { rdTitle,
			  rdMrd,
			  rdParam,
			  rdParamGubun,
			  rdSaveYn,
			  rdPrintYn,
			  rdExcelYn,
			  rdWordYn,
			  rdPptYn,
			  rdHwpYn,
			  rdPdfYn } = modal.parameters;

		//title setting
		$('#modal-' + rdSignLayer.id).find('div.layer-modal-header span.layer-modal-title').text(rdTitle);
		$("#Mrd").val(rdMrd) ;
		$("#Param").val(rdParam) ;
		$("#ParamGubun").val(rdParamGubun) ;
		$("#SaveYn").val(rdSaveYn) ;     //기능컨트롤_저장
		$("#PrintYn").val(rdPrintYn) ;   //기능컨트롤_인쇄
		$("#ExcelYn").val(rdExcelYn) ;   //기능컨트롤_엑셀
		$("#WordYn").val(rdWordYn) ;     //기능컨트롤_워드
		$("#PptYn").val(rdPptYn) ;       //기능컨트롤_파워포인트
		$("#HwpYn").val(rdHwpYn) ;       //기능컨트롤_한글
		$("#PdfYn").val(rdPdfYn) ;       //기능컨트롤_PDF
		// 높이 조절에 따라 rd가 짤리는 부분을 위해 높이 조절. kwook
		//setIframeHeight();



	});

	//$("#ifrmSignPad").load( function(){
	//});

	//RD이벤트 결과값을 넘겨준다.
	function returnResult() {
		const modal = window.top.document.LayerModalUtility.getModal(rdSignLayer.id);
		const p = { printResultYn: $("#printResultYn").val() };
		modal.fire(rdSignLayer.id + 'Trigger', p).hide();
	}
	

	
	//사인패드 서명 후 리턴 
	function returnSignPad(rs){
		if(rs.FileSeq !== undefined && rs.FileSeq !== null && rs.FileSeq.length > 0) {
			if( !confirm("동의 하시겠습니까?\n(동의 후에는 본인이 취소할 수 없습니다.") ) return;
			var fileSeq = rs.FileSeq;
			const modal = window.top.document.LayerModalUtility.getModal(rdSignLayer.id);
			const p = { fileSeq };
			modal.fire(rdSignLayer.id + 'Trigger', p).hide();
		} else {
			alert("처리 중 오류가 발생했습니다.");
		}
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<div class="modal_body">
		<div id="divSignPad" style="position:absolute;left:50%;top:24px;height:200px;margin-left:-200px;background-color:#fff;">
			<iframe id="ifrmSignPad" name="ifrmSignPad" src="/Popup.do?cmd=signPadPopup" style="border:0px; width:400px; height:200px;"></iframe>
		</div>
	</div>
	<div class="modal_footer">
		<a href="javascript:closeCommonLayer('signPadLayer');" class="btn outline_gray"><tit:txt mid='104157' mdef='닫기'/></a>
	</div>
</div>
</body>
</html>
