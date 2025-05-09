<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><tit:txt mid='appComLayout' mdef='신청'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<style>
th {text-align:left;padding:20px 0 5px 0;}
td {padding:5px 10px 5px 10px;}
</style>
<script>
function test1(cd,seq,gubun,auth){
	//appCd : 결재코드
	//searchApplSeq : 결재순번
	//searchRegGubun : 문서상태 
	//ahthPg : 기존 searchAdminYn 값 대신 
	
	var args = new Array();
	args["applCd"] = cd;
	args["applSeq"] = seq;
	args["searchRegGubun"] = gubun;
	
	url ="/ApprovalMgr.do?cmd=viewApprovalMgr&applCd=63&applSeq=&auth=A";
 	var result = openPopup(url,args,900,600);
}

</script>

</head>
<body>
<table>
<tr><td><a href="javascript:test1('63','','I','A')" >1. 신청</a></td></tr>
<tr><td><a href="designGuideInformation.jsp">2. 결재</a></td></tr>
</table>
<form id="srchForm" name="sheet1Form">
<input id="appCd" name ="appCd" type="hidden" class="text"/>
</form>
	<br>


<P><BR>개발할때 호출할 URL <BR>/ApprovalMgr.do?cmd=viewApprovalMgr&amp;applCd=<STRONG>신청서코드</STRONG>&amp;applSeq=<STRONG>신청서순번</STRONG>&amp;auth=A </P>
<P><BR>업무부분은 신청결재 &gt; 신청결재관리 &gt; 신청서코드관리 신청서코드명에 입력하면 됩니다. <BR><BR></P>
<P>onLoad 할때 함수 호출 <BR><STRONG>parent.iframeOnLoad($(document).height()); <BR></STRONG>
<BR>저장후 리턴함수 <BR>function setValue(){ <BR>&nbsp;&nbsp;&nbsp;&nbsp;return true; <BR>} </P>



</body>
</html>
