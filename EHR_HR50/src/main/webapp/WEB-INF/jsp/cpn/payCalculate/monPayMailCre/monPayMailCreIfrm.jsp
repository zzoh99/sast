<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='103788' mdef='월급여메일발송'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<style>th,td{margin:0px; padding:3px;font-size:12px;color:#666666;line-height:18px;}th{text-align:right}</style>

<script type="text/javascript">
	$(function() {
// 		alert( $("#mailHtml", parent.document).html() ) ;
		$("#mailContents").html( $("#mailHtml", parent.document).html() ) ;
	});
</script>

</head>
<body class="bodywrap">
<div class="wrapper" style="overflow:scroll;">
	<span id="mailContents"></span>
</div>
</body>
</html>
