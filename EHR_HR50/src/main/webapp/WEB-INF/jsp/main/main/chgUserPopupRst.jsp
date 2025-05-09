<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="msg" tagdir="/WEB-INF/tags/message" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" 			prefix="c" %>
<!DOCTYPE html> <html class="hidden"> <head>
<script type="text/javascript">
<c:choose>
<c:when test="${isUser == 'notMatch'}">
alert("<msg:txt mid='110479' mdef='비밀번호가 틀립니다.'/>");
window.top.location.href = '/Main.do';
// parent.close();
</c:when>
<c:when test="${isUser == 'exist'}">
// top.opener.goMain();
// parent.close();
window.top.location.href = '/Main.do';
</c:when>
<c:otherwise>
alert("로그인 할 수 없습니다.");
window.top.location.href = '/Main.do';
// parent.close();
</c:otherwise>
</c:choose>
</script>
</head>
<body>&nbsp;
</body>
</html>
