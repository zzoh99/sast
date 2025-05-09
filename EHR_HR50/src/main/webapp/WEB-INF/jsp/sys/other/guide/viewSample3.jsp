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
	<th>### 디자인표준</th>
</tr>
<tr>
	<td><a href="designGuideSearch.jsp" target="_blank">- 조회</a></td>
</tr>
<tr>
	<td><a href="designGuideAlign.jsp" target="_blank">- 정렬</a></td>
</tr>
<tr>
	<td><a href="designGuideInput.jsp" target="_blank">- 입력폼</a></td>
</tr>
<tr>
	<td><a href="designGuideButton.jsp" target="_blank">- 버튼</a></td>
</tr>
<tr>
	<td><a href="designGuideText.jsp" target="_blank">- 텍스트</a></td>
</tr>
<tr>
	<td><a href="designGuideIcons.jsp" target="_blank">- 아이콘</a></td>
</tr>
<tr>
	<td><a href="designGuideTable.jsp" target="_blank">- 테이블</a></td>
</tr>
<tr>
	<td><a href="javascript:window.open('designGuidePrint1.html','','width=680,height=700,scrollbars=yes,realzable=yes');void(0);">- 출력물</a></td>
</tr>
<tr>
	<td><a href="designGuideSelect.jsp" target="_blank">- 멀티셀렉트</a></td>
</tr>
<tr>
	<td><a href="designGuideMask.jsp" target="_blank">- 입력박스 마스크</a></td>
</tr>
</table>
</body>
</html>
