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
	<th>### 기타</th>
</tr>
<tr>
	<td><a href="designGuideBase.jsp" target="_blank">1. 서브메인</a></td>
</tr>
<tr>
	<td><a href="designGuideInformation.jsp" target="_blank">2. 인포메이션</a></td>
</tr>
<tr>
	<td><a href="designGuideError.jsp" target="_blank">3. 에러</a></td>
</tr>
<tr>
	<td><a href="javascript:openPopup('designGuideAuthor.html','','900','650')">4. 신청 - 공통 레이아웃</a></td>
</tr>
<tr>
	<td><a href="javascript:openPopup('designGuideAuthorResult.html','','900','650')">5. 결재 - 공통 레이아웃</a></td>
</tr>
<tr>
	<td><a href="designGuidePopup.jsp" target="_blank">6. 팝업</a></td>
</tr>
<tr>
	<td><a href="designGuideResize.jsp" target="_blank">7. 리사이즈</a></td>
</tr>
<tr>
	<td><a href="designGuidePasswordPopup.jsp" target="_blank">8. 비밀번호찾기</a></td>
</tr>
</table>
</body>
</html>
