<%@ tag language="java" pageEncoding="UTF-8" body-content="scriptless"
%><%@ tag import="com.hr.common.language.LocaleUtil"
%><%@ attribute name="href"
%><%@ attribute name="id"
%><%@ attribute name="mid" required="true"
%><%@ attribute name="mdef"
%><%@ attribute name="margs"
%><%@ attribute name="css"
%><%@ attribute name="style"
%><%@ attribute name="onclick"
%><%
	String sTag = "<a";
	String eTag = "</a>";

	if(href != null && href.length() > 0) {
		sTag += " href=\""+href+"\"";
	}

	if(id != null && id.length() > 0) {
		sTag += " id=\""+id+"\"";
	}

	if(css != null && css.length() > 0) {
		sTag += " class=\""+css+"\"";
	}

	if(style != null && style.length() > 0) {
		sTag += " style=\""+style+"\"";
	}

	if(onclick != null && onclick.length() > 0) {
		sTag += " onclick=\""+onclick+"\"";
	}
	sTag += ">";
	sTag += LocaleUtil.getMessage(request, "btn", mid, mdef, margs, null);
%><%=sTag%><jsp:doBody /><%=eTag%>