<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='114015' mdef='개인정보보호법관리 sheet1 팝업'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<style type="text/css">
</style>
<script type="text/javascript">
var p = eval("${popUpStatus}");
$(function(){
	var arg = p.window.dialogArguments;

	var infoSeq  		= "";
	var subjectContents = "";

    if( arg != undefined ) {
    	infoSeq 			= arg["infoSeq"];
    	subjectContents 	= arg["subjectContents"];
    }else{
    	if(p.popDialogArgument("infoSeq")!=null)				infoSeq  	= p.popDialogArgument("infoSeq");
    	if(p.popDialogArgument("subjectContents")!=null)		subjectContents  	= p.popDialogArgument("subjectContents");
    }
	$("#infoSeq").val(infoSeq);
	$("#subjectContents").val(subjectContents);

	//Cancel 버튼 처리
	$(".close").click(function(){
		p.self.close();
	});
});

function setValue() {
	var rv = new Array(6);
	rv["infoSeq"] 	= $("#infoSeq").val();
	rv["subjectContents"]	= $("#subjectContents").val();

	//p.window.returnValue = rv;
	if(p.popReturnValue) p.popReturnValue(rv);
	p.window.close();
}
</script>
</head>
<body class="bodywrap">

<div class="wrapper">
	<div class="popup_title">
		<ul>
			<li><tit:txt mid='privacyActMgrV2' mdef='개인정보보호법 제목'/></li>
			<li class="close"></li>
		</ul>
	</div>

	<div class="popup_main">
		<table class="table">
		<colgroup>
			<col width="20%" />
			<col width="80%" />
		</colgroup>
		<inptu type="hidden" id="infoSeq" name="infoSeq">
		<tr>
			<th><tit:txt mid='privacyActMgrV3' mdef='개인정보보호법'/></th>
			<td>
				<textarea id="subjectContents" name="subjectContents" style="width:99%;height:400px"></textarea>
			</td>
		</tr>
		</table>

		<div class="popup_button">
			<ul>
				<li>
					<btn:a href="javascript:setValue();" css="pink large authA" mid='ok' mdef="확인"/>
					<btn:a href="javascript:p.self.close();" css="gray large authR" mid='close' mdef="닫기"/>
				</li>
			</ul>
		</div>
	</div>
</div>

</body>
</html>
