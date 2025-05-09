<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<html>
<head>
    <title>세션 정보 확인</title>
</head>
<body>
    <h2>세션 정보</h2>
    <% 
      HttpSession currentSession = request.getSession();
      out.println("<p>세션 ID: " + currentSession.getId() + "</p>");
      out.println("<p>세션 생성 시간: " + new Date(currentSession.getCreationTime()) + "</p>");
      out.println("<p>마지막 접근 시간: " + new Date(currentSession.getLastAccessedTime()) + "</p>");
      out.println("<p>세션 유효 시간(초): " + currentSession.getMaxInactiveInterval() + "</p>");
      
      out.println("<h3>세션 속성:</h3>");
      Enumeration<String> attributeNames = currentSession.getAttributeNames();
      if (!attributeNames.hasMoreElements()) {
        out.println("<p>저장된 속성이 없습니다.</p>");
      } else {
        while (attributeNames.hasMoreElements()) {
          String name = attributeNames.nextElement();
          out.println("<p>" + name + " : " + currentSession.getAttribute(name) + "</p>");
        }
      }
    %>
</body>
</html>
