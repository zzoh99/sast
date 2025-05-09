<%@ tag language="java" pageEncoding="UTF-8" body-content="empty"
%><%@ tag import="com.hr.common.language.LocaleUtil"
%><%@ attribute name="mid" required="true"
%><%@ attribute name="mdef"
%><%@ attribute name="margs"
%><%@ attribute name="toolTip"
%><%
	String msg = LocaleUtil.getMessage(request, "tit", mid, mdef, margs, null);
	if(toolTip != null && toolTip.length() > 0) {
		msg = String.format("<span title=\"%s\">%s</span>", msg, msg);
	}
%><%= msg %>