<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html><head> <title>증빙자료관리 업로드</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {


		$("#fileNm").on("change", function(){

           $("#srchFrm1").attr("action", "nonPaperFileUploadMgr.jsp?updownFlag=UPLOAD&uploadYear="+$("#uploadYear").val());
			$("#srchFrm1").submit();

		});

		//파일업로드 후 ibSheet에 파일 경로 셋팅함수
		parent.callbackGetFilePath();

	});


</script>
<%

	String strFileName = (String)request.getAttribute("fileName");
	String strFilePath = (String)request.getAttribute("fileFullPath");
%>

</head>
<body class="bodywrap" style="overflow-y: auto;">
<div class="wrapper">
	<form id="srchFrm1" name="srchFrm1" action="nonPaperFileUploadMgr.jsp" enctype="multipart/form-data" method="post">
	    <input id="uploadSabun"      name="uploadSabun" type="hidden" value ="" />
		<input id="uploadYear"       name="uploadYear" type="hidden" value=""/>
		<input id="uploadAdjustType" name="uploadAdjustType" type="hidden" value=""/>
		<input id="saveFileName" name="saveFileName" type="hidden" value="<%=strFileName%>"/>
		<input id="saveFilePath" name="saveFilePath" type="hidden" value="<%=strFilePath%>"/>
		<input id="fileNm"       name="fileNm" type='file' />
		<input type="submit" id="fileSubmit" value="upload" >
	</form>

</div>
</body>
</html>