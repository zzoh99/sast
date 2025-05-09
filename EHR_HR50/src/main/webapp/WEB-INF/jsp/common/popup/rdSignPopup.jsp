<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
/*
 * RD팝업 뷰어를 호출한다.
 * 20130612 JSG.
 */
	var p = eval("${popUpStatus}");
	$(function() {

		var rdTitle= "";
		var rdMrd = "";
		var rdParam= "";
		//var rdToolBarYn = "";
		//var rdZoomRatio = "";
		var rdParamGubun = "";
		//var rdSaveYn= "";     //기능컨트롤_저장
		//var rdPrintYn= ""; 	 //기능컨트롤_인쇄
		//var rdExcelYn= "" ;   //기능컨트롤_엑셀
		//var rdWordYn= "" ;     //기능컨트롤_워드
		//var rdPptYn= "" ;       //기능컨트롤_파워포인트
		//var rdHwpYn= "" ;       //기능컨트롤_한글
		//var rdPdfYn= "" ;       //기능컨트롤_PDF


		var arg = p.popDialogArgumentAll();

		if( arg != undefined ) {
			rdTitle         = arg["rdTitle"] ;
			rdMrd           = arg["rdMrd"] ;
			rdParam			= arg["rdParam"];
			//rdToolBarYn		= arg["rdToolBarYn"] ;
			//rdZoomRatio		= arg["rdZoomRatio"] ;
			rdParamGubun	= arg["rdParamGubun"] ;
			rdSaveYn		= arg["rdSaveYn"] ;     //기능컨트롤_저장
			rdPrintYn		= arg["rdPrintYn"] ; 	 //기능컨트롤_인쇄
			rdExcelYn		= arg["rdExcelYn"] ;   //기능컨트롤_엑셀
			rdWordYn		= arg["rdWordYn"] ;     //기능컨트롤_워드
			rdPptYn			= arg["rdPptYn"] ;       //기능컨트롤_파워포인트
			rdHwpYn 		= arg["rdHwpYn"] ;       //기능컨트롤_한글
			rdPdfYn 		= arg["rdPdfYn"] ;       //기능컨트롤_PDF

		}

		$("#Title").text(rdTitle) ;
		$("#Mrd").val(rdMrd) ;
		$("#Param").val(rdParam) ;
		//$("#ToolbarYn").val(rdToolBarYn) ;
		//$("#ZoomRatio").val(rdZoomRatio) ;
		$("#ParamGubun").val(rdParamGubun) ;
		$("#SaveYn").val(rdSaveYn) ;     //기능컨트롤_저장
		$("#PrintYn").val(rdPrintYn) ;   //기능컨트롤_인쇄
		$("#ExcelYn").val(rdExcelYn) ;   //기능컨트롤_엑셀
		$("#WordYn").val(rdWordYn) ;     //기능컨트롤_워드
		$("#PptYn").val(rdPptYn) ;       //기능컨트롤_파워포인트
		$("#HwpYn").val(rdHwpYn) ;       //기능컨트롤_한글
		$("#PdfYn").val(rdPdfYn) ;       //기능컨트롤_PDF

	    $(".close").click(function() {
	    	p.self.close();
	    });
		//rd iframe 호출
		submitCall($("#paramFrm"),"reportPage_ifrmsrc","post","/RdIframe.do");

		// 높이 조절에 따라 rd가 짤리는 부분을 위해 높이 조절. kwook
		setIframeHeight();
		$(window).resize(function() {
			setIframeHeight();
		});
		
		$("#ifrmSignPad").load( function(){
			$("#ifrmSignPad").contents().find("#description").html("동의하시면 서명을 해주세요.");
			$("#ifrmSignPad").contents().find("#btnSave").html("동의");
		});

		
	});
	//RD이벤트 결과값을 넘겨준다.
	function returnResult() {
 		var rv = new Array(1);
		rv["printResultYn"] = $("#printResultYn").val() ;
		p.popReturnValue(rv);
	}
	
	// rd부분 높이를 구해준다.
	function setIframeHeight() {
		var bodyHeight = $("body").outerHeight(true);
		var divSignPad = $("#divSignPad").outerHeight();
		$("#reportPage_ifrmsrc").css("height", bodyHeight - 48 - divSignPad);
	}
	
	//사인패드 서명 후 리턴 
	function returnSignPad(rs){
		if(rs.FileSeq !== undefined && rs.FileSeq !== null && rs.FileSeq.length > 0) {
			
			if( !confirm("동의 하시겠습니까?\n(동의 후에는 본인이 취소할 수 없습니다.") ) return;
			var fileSeq=rs.FileSeq;

	    	var returnValue = new Array(1);
	 		returnValue["fileSeq"] = fileSeq;
	 		
	 		p.popReturnValue(returnValue);
	 		p.window.close();
	 		
		}else{
			alert("처리 중 오류가 발생했습니다.");
		}
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="popup_title">
		<ul>
			<li><span id="Title"></span></li>
			<li class="close"></li>
		</ul>
	</div>

	<form id="paramFrm" name="paramFrm" >
		<input type="hidden" id="Mrd"   name="Mrd">
		<input type="hidden" id="Param" name="Param">
<!--
		<input type="hidden" id="ToolbarYn">
		<input type="hidden" id="ZoomRatio">
-->
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

	<div class="common_iframe_rpt">
		<iframe name="reportPage_ifrmsrc" id="reportPage_ifrmsrc" frameborder='0' class='tab_iframes'></iframe>
	</div>
	<div id="divSignPad" style="position:absolute;left:50%;right:0;bottom:0;height:200px;margin-left:-200px;background-color:#fff;">
		<iframe id="ifrmSignPad" name="ifrmSignPad" src="/Popup.do?cmd=signPadPopup" style="border:0px; width:400px; height:200px;"></iframe>
	</div>
</div>
</body>
</html>
