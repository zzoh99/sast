<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html> <html class="hidden"><head> <title>연말정산안내</title>
<%@ page import="yjungsan.util.*"%>
<%@ page import="java.util.Map"%>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var expText = "" ;
	var title 	= "" ;
	
	$(function(){
		//var arg = p.window.dialogArguments;
		//expText 	= arg["expText"];   		
		//title		= arg["title"];   		

		expText 	= "<%=removeXSS(request.getParameter("expText"), '1')%>";
		title		= "<%=removeXSS(request.getParameter("title"), '1')%>";
		getValue() ;
		
		$(".close").click(function(){
			self.close(); 
		});
	});

	function getValue() {
		$("#expText").html(expText) ;
		$("#title").html(title) ;
	}

</script>
</head>
<body class="bodywrap">

<div class="wrapper" style="overflow:scroll;">
	<div class="popup_title">
		<ul>
			<li><span id="title"></span></li>
			<!--<li class="close"></li>-->
		</ul>
	</div>
	
	<div class="popup_main" >
		<table class="table">
			<colgroup>
				<col width="" />
			</colgroup>
			<tr>
				<td id="expText" class="text" valign="top"></td>
			</tr>
		</table>
		<div class="popup_button outer">
			<ul>
				<li>
					<a href="javascript:self.close();" class="gray large authR">닫기</a>
				</li>
			</ul>
		</div>
	</div>
</div>

</body>
</html>