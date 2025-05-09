<%@ tag language="java" pageEncoding="UTF-8" body-content="empty"
%><%@ tag import="com.hr.common.language.LocaleUtil"
%><%@ attribute name="mlevel" required="true"
%><%@ attribute name="mid" required="true"
%><%@ attribute name="mdef"
%><%@ attribute name="margs"
%><%@ attribute name="margids"
%><%
	String msg = LocaleUtil.getMessage(request, mlevel, mid, mdef, margs, margids);
%><%=msg%>