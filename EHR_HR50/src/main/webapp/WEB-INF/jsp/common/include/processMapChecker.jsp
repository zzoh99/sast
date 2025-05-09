<%-- WEB-INF/jsp/common/include/jqueryScript.jsp 에 include --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
<%
	request.setCharacterEncoding("utf-8");
	String linkBarProcMapSeq = request.getParameter("linkBarProcMapSeq");
	String linkBarProcSeq = request.getParameter("linkBarProcSeq");
%>
	$(function() {
		let linkBarProcMapSeq= "<%= linkBarProcMapSeq %>";
		let linkBarProcSeq= "<%= linkBarProcSeq %>";
		if(
			linkBarProcMapSeq != undefined &&
			linkBarProcMapSeq != null && 
			linkBarProcMapSeq != "" &&
			linkBarProcMapSeq != "null"
		){
			
			let openedIframeBody=$("body");
			window.top.processMapLinkBarUtil.addLinkBar(linkBarProcMapSeq,linkBarProcSeq,openedIframeBody);
		}
	});
</script>