<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
</head>
<body class="hidden">
<div class="wrapper">
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main" >
		<tr>
			<td>
				<div>
					<iframe src="${front}/vue-app/layout/"  frameborder='0' class='tab_iframes vueLayout'></iframe>
				</div>
			</td>
		</tr>
	</table>
</div>
</body>
</html>