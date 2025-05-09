<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> 
<html class="hidden"><title>sun editor test</title>
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<link rel="stylesheet" href="/common/plugin/suneditor/suneditor-2.45.1.min.css" />
<script src="${ctx}/common/plugin/suneditor/suneditor-2.45.1.min.js" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/plugin/suneditor/suneditor-2.45.1.ko.js" type="text/javascript" charset="utf-8"></script>
  </head>
<body class="bodywrap">
<textarea id="sample"></textarea>
</body>
<script>
const option = {
	buttonList: [
		[
			"undo",
			"redo",
			"font",
			"fontSize",
			"formatBlock",
			"paragraphStyle",
			"blockquote",
			"bold",
			"underline",
			"italic",
			"fontColor",
			"textStyle",
			"outdent",
			"indent",
			"align",
			"horizontalRule",
			"list",
			"lineHeight",
			"table",
			"link",
			"image"
		]
	], 
	width: '100%', 
	height: '100%',
	imageUploadUrl: '/fileuploadJFileUpload.do?cmd=sunupload' 
};
const editor = SUNEDITOR.create(document.getElementById('sample'), option);
</script>
</html>
