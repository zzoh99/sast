<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='114350' mdef='설문지 설명 팝업'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var sheet1 	= null;
var sRow	= null;
var p = eval("${popUpStatus}");
$(function(){
	var arg = p.popDialogArgumentAll();
	$("#memo").val(arg["memo"]);

	$(".close").click(function(){
		p.self.close();
	});
});

function save() {
	var returnValue = [];

	returnValue["memo"] 		= $("#memo").val();

	p.popReturnValue(returnValue);
	p.window.close();
}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="popup_title">
		<ul>
			<li><tit:txt mid='113663' mdef='설문조사 설명'/></li>
			<li class="close"></li>
		</ul>
	</div>
	<div class="popup_main">
		<form id="sheetForm" name="sheetForm" >
			<table class="table">
				<colgroup>
					<col width="100%" />
				</colgroup>
				<tr>
					<td>
						<textarea id="memo" name="memo" style="width:99%;height:200px"></textarea>
					</td>
				</tr>

			</table>
		</form>
		<div class="popup_button">
			<ul>
				<li>
					<btn:a href="javascript:save();" css="pink large" mid='ok' mdef="확인"/>
					<btn:a href="javascript:p.self.close();" css="gray large" mid='close' mdef="닫기"/>
				</li>
			</ul>
		</div>
	</div>
</div>

</body>
</html>
