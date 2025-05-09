<%@ page import="com.nhncorp.lucy.security.xss.XssPreventer" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("UTF-8"); 
response.setContentType("application; charset=UTF-8");
response.setHeader("Content-Disposition", "attachment; filename="+ java.net.URLEncoder.encode(request.getParameter("fileName"),"UTF-8"));
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
<%=XssPreventer.unescape(request.getParameter("contents"))%>
</body>
</html>