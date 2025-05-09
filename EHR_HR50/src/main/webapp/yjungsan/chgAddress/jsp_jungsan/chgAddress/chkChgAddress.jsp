<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>주소변경대상체크</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

	$(function() {
		var obj = new Object();
		var param = "sabun="+"<%=session.getAttribute("ssnSabun")%>" ;
		var data = ajaxCall("<%=jspPath%>/chgAddress/chgAddressRst.jsp?cmd=getChkChgAddressMap", param,false);
		
		if(data.Data.sabun != undefined) {
			openChgAddressPopup();
		}
		
	});
	
	// 주소변경팝업
	function openChgAddressPopup() {
		
 		var w 		= 900;
		var h 		= 600;
		var url 	= "<%=jspPath%>/chgAddress/chgAddressPopup.jsp";
		var args 	= new Array();
		args["sabun"]		= "<%=session.getAttribute("ssnSabun")%>";
		args["authPg"]		= "A"; //변경요청
		
		if(!isPopup()) {return;}
		openPopup(url,args,w,h);
		
	}
</script>
</head>
<body class="bodywrap">
</body>
</html>