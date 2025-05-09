<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html> <html class="hidden"><head> <title>리포트팝업</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
/*
 * RD팝업 뷰어를 호출한다. 
 * 20130612 JSG.
 */
	var p = eval("<%=popUpStatus%>");
	$(function() {
		
		var rdTitle= "";
		var rdMrd = "";
		var rdParam= "";
		var rdToolBarYn = "";
		var rdZoomRatio = "";
		var rdParamGubun = "";
		var rdSaveYn= "";     //기능컨트롤_저장      
		var rdPrintYn= ""; 	 //기능컨트롤_인쇄      
		var rdExcelYn= "" ;   //기능컨트롤_엑셀      
		var rdWordYn= "" ;     //기능컨트롤_워드      
		var rdPptYn= "" ;       //기능컨트롤_파워포인트   
		var rdHwpYn= "" ;       //기능컨트롤_한글      
		var rdPdfYn= "" ;       //기능컨트롤_PDF
		

		var arg = p.window.dialogArguments;

		if( arg != undefined ) {
			rdTitle         = arg["rdTitle"] ;
			rdMrd           = arg["rdMrd"] ;
			rdParam			= arg["rdParam"] ;
			rdToolBarYn		= arg["rdToolBarYn"] ;
			rdZoomRatio		= arg["rdZoomRatio"] ;
			rdParamGubun	= arg["rdParamGubun"] ;
			rdSaveYn		= arg["rdSaveYn"] ;     //기능컨트롤_저장      
			rdPrintYn		= arg["rdPrintYn"] ; 	 //기능컨트롤_인쇄      
			rdExcelYn		= arg["rdExcelYn"] ;   //기능컨트롤_엑셀      
			rdWordYn		= arg["rdWordYn"] ;     //기능컨트롤_워드      
			rdPptYn			= arg["rdPptYn"] ;       //기능컨트롤_파워포인트   
			rdHwpYn 		= arg["rdHwpYn"] ;       //기능컨트롤_한글      
			rdPdfYn 		= arg["rdPdfYn"] ;       //기능컨트롤_PDF
			
		}else{
			rdTitle 	 = p.popDialogArgument("rdTitle");
			rdMrd 		 = p.popDialogArgument("rdMrd");
			rdParam 	 = p.popDialogArgument("rdParam");
			rdToolBarYn  = p.popDialogArgument("rdToolBarYn");
			rdZoomRatio  = p.popDialogArgument("rdZoomRatio");
			rdParamGubun = p.popDialogArgument("rdParamGubun");
			rdSaveYn 	 = p.popDialogArgument("rdSaveYn");
			rdPrintYn  	 = p.popDialogArgument("rdPrintYn");
			rdExcelYn  	 = p.popDialogArgument("rdExcelYn");
			rdWordYn 	 = p.popDialogArgument("rdWordYn");
			rdPptYn 	 = p.popDialogArgument("rdPptYn");
			rdHwpYn  	 = p.popDialogArgument("rdHwpYn");
			rdPdfYn 	 = p.popDialogArgument("rdPdfYn");
			
			// 크롬 RD 팝업에 rdParam 일 경우 
			//rdParam = rdParam.replace(/@#/gi, "'");
		}		

		$("#Title").text(rdTitle) ;
		$("#Mrd").val(rdMrd) ;
		$("#Param").val(rdParam+" ") ;
		$("#ToolbarYn").val(rdToolBarYn) ;
		$("#ZoomRatio").val(rdZoomRatio) ;
		$("#ParamGubun").val(rdParamGubun) ;
		$("#SaveYn").val(rdSaveYn) ;     //기능컨트롤_저장      
		$("#PrintYn").val(rdPrintYn) ; 	 //기능컨트롤_인쇄      
		$("#ExcelYn").val(rdExcelYn) ;   //기능컨트롤_엑셀      
		$("#WordYn").val(rdWordYn) ;     //기능컨트롤_워드      
		$("#PptYn").val(rdPptYn) ;       //기능컨트롤_파워포인트   
		$("#HwpYn").val(rdHwpYn) ;       //기능컨트롤_한글      
		$("#PdfYn").val(rdPdfYn) ;       //기능컨트롤_PDF
		
	    $(".close").click(function() {
	    	p.self.close();
	    });    
		//rd iframe 호출
		submitCall($("#paramFrm"),"reportPage_ifrmsrc","post","./rdPopupIframe.jsp");
	});
	//RD이벤트 결과값을 넘겨준다.
	function returnResult() {
 		var rv = new Array(1);
		rv["printResultYn"] = $("#printResultYn").val() ;
		//p.window.returnValue 	= rv;    
		if(p.popReturnValue) p.popReturnValue(rv);
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="popup_title">
		<ul>
			<li><span id="Title"></span></li>
			<!--<li class="close"></li>-->
		</ul>
	</div>
	<form id="paramFrm" name="paramFrm" >
		<input type="hidden" id="Mrd">
		<input type="hidden" id="Param">
		<input type="hidden" id="ToolbarYn">
		<input type="hidden" id="ZoomRatio">
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
