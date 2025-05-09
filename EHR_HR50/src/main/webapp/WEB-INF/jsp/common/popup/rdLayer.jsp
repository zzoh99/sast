<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->

<script type="text/javascript">
/*
 * RD팝업 뷰어를 호출한다.
 * 20130612 JSG.
 */
	var rdLayer = { id: 'rdLayer' };
	$(function() {
		var rdTitle= "";
		var rdMrd = "";
		var rdParam= "";
		var rdParamGubun = "";

		const modal = window.top.document.LayerModalUtility.getModal(rdLayer.id);
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
		$('#modal-' + rdLayer.id).find('div.layer-modal-header span.layer-modal-title').text(rdTitle);
		
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

		//rd iframe 호출
		submitCall($("#paramFrm"),"reportPage_ifrmsrc","post","/RdIframe.do");

		// 높이 조절에 따라 rd가 짤리는 부분을 위해 높이 조절. kwook
		setIframeHeight();
		$(window).resize(function() {
			setIframeHeight();
		});
	});

	//RD이벤트 결과값을 넘겨준다.
	function returnResult() {
		const modal = window.top.document.LayerModalUtility.getModal(rdLayer.id);
		const p = { printResultYn: $("#printResultYn").val() };
		modal.fire(rdLayer.id + 'Trigger', p).hide();
	}
	
	// rd부분 높이를 구해준다.
	function setIframeHeight() {
		var bodyHeight = $("body").outerHeight(true);
		$("#reportPage_ifrmsrc").css("height", bodyHeight - 48);
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="paramFrm" name="paramFrm" >
		<input type="hidden" id="Mrd"   name="Mrd">
		<input type="hidden" id="Param" name="Param">
		<input type="hidden" id="ParamGubun">
		<input type="hidden" id="SaveYn">
		<input type="hidden" id="PrintYn">
		<input type="hidden" id="ExcelYn">
		<input type="hidden" id="WordYn">
		<input type="hidden" id="PptYn">
		<input type="hidden" id="HwpYn">
		<input type="hidden" id="PdfYn">
		<input type="hidden" id="printResultYn" value="N">
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="common_iframe_rpt" style="padding-bottom:1px">
					<iframe name="reportPage_ifrmsrc" id="reportPage_ifrmsrc" frameborder='0' class='tab_iframes'></iframe>
				</div>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
