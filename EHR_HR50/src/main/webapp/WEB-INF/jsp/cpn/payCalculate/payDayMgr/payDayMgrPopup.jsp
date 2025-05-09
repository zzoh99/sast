<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<title>이수시스템(주)</title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%><!-- Jquery -->
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%><!-- IBSheet -->
<style type="text/css">
</style>
<script type="text/javascript">
var p = eval("${popUpStatus}");
var gCheckBtn = false;

$(function(){
	var bigo			= "";
	
	var arg = p.window.dialogArguments;
	if( arg != undefined ) {
		bigo 	= arg["bigo"];
	}else{
	    if(p.popDialogArgument("bigo")!=null)		bigo  	= p.popDialogArgument("bigo");
    }

	$("#bigo").val(bigo);

	//Cancel 버튼 처리
	
	$(".close").click(function(){
		p.self.close();
	});
	
	$("#bigo").maxbyte(4000);

});




//Ok 버튼 처리
function save() {
	var rv = new Array(5);

	rv["bigo"] = $("#bigo").val();
	if(p.popReturnValue) p.popReturnValue(rv);
	
	p.window.close();
}




</script>
</head>
<body class="bodywrap">
<form id="dataForm" name="dataForm" >
<div class="wrapper">
	<div class="popup_title">
	<ul>
		<li>비고</li>
		<li class="close"></li>
	</ul>
	</div>

	<div class="popup_main">

		<table class="table">
			<tr>
				<th>비고</th>
				<td>
					<textarea id="bigo" name="bigo" rows="10" class="text w100p" maxlength="4000"></textarea>
				</td>
			</tr>
		</table>
		
		<div class="popup_button">
			<ul>
				<li>
					<a href="javascript:save();" class="pink large">저장</a>
					<a href="javascript:p.self.close();" class="gray large">닫기</a>
				</li>
			</ul>
		</div>
	</div>
</div>
</form>
</body>
</html>