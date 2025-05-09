<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<style type="text/css">
</style>
<script type="text/javascript">
var expText = "" ;
var title 	= "" ;
var p = eval("${popUpStatus}");
$(function(){
	var arg = p.window.dialogArguments;
	if( arg != undefined ){
		expText 	= arg["expText"];
		title		= arg["title"];
	}else{
		if( p.popDialogArgument("expText") != null ) { expText = p.popDialogArgument("expText"); }
	    if( p.popDialogArgument("title")   != null ) { title   = p.popDialogArgument("title"); }

// 		if(p.window.expText)	expText 	= p.window.expText.value;
// 		if(p.window.title)		title		= p.window.title.value;
	}

	getValue() ;

	//Cancel 버튼 처리
	$(".close").click(function(){
		p.self.close();
	});
});

function getValue() {
	$("#expText").html(expText) ;
	$("#title").html(title) ;
}

function setValue() {
	var rv = new Array(1);
	rv["expText"] = $("#expText").val() ;
	if(p.popReturnValue) p.popReturnValue(rv);
// 	p.window.returnValue 	= rv;
	p.self.close();
}

</script>
</head>
<body class="bodywrap">

<div class="wrapper" >
	<div class="popup_title">
		<ul>
			<li><span id="title"></span></li>
			<li class="close"></li>
		</ul>
	</div>

	<div class="popup_main" >
		<table class="table">
			<colgroup>
				<col width="100%" />
			</colgroup>
			<tr>
				<td>
					<textarea id="expText" rows="6" cols="30" class="w100p" style="overflow:auto"></textarea>
				</td>
			</tr>
		</table>
		<div class="popup_button outer">
			<ul>
				<li>
					<btn:a href="javascript:setValue();" css="pink large authA" mid="save" mdef="저장"/>
					<btn:a href="javascript:p.self.close();" css="gray large authR" mid="close" mdef="닫기"/>
				</li>
			</ul>
		</div>
	</div>
</div>

</body>
</html>