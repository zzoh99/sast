<%@ tag language="java" pageEncoding="UTF-8" body-content="empty"
%><%@ taglib prefix="com" tagdir="/WEB-INF/tags/common"
%><%@ attribute name="mid" required="true"
%><%@ attribute name="mdef"
%><%@ attribute name="margs"
%><%@ attribute name="margids"
%><com:msg mlevel="msg" mid="${mid}" mdef="${mdef}" margs="${margs}" margids="${margids}"/>