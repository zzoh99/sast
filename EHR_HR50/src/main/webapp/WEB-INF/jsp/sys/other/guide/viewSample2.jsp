<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html><head> 
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<style>
th {text-align:left;padding:20px 0 5px 0;}
td {padding:5px 10px 5px 10px;}
</style>
</head>
<body>
<table>
<tr>
	<th>### 팝업</th>
</tr>
<tr>
	<td><a href="javascript:openPopup('designGuidePpopup.html','','700','600')">- 기본</a></td>
</tr>
<tr>
	<td>
		<a href="javascript:window.showModalDialog('designGuidePopupInfo.html','','dialogWidth=640px; dialogHeight=360px; scroll=no; status=no; help=no; center=yes')">- 도움말</a></td>[openPopup(url, args, width, height); 함수 사용 ]
</tr>
<tr>
	<td><a href="designGuidePopupMain.jsp" target="_blank">- 팝업띄우는 스크립트</a></td>
</tr>
</table>
</body>
</html>
