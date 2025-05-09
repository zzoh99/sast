<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='memoV1' mdef='결재 의견'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var p = eval("${popUpStatus}");
var status 	= "";
	$(function() {

        var arg = p.window.dialogArguments;

		if( arg != undefined ) {
			status 	= arg["status"];
		}else{
			if(p.popDialogArgument("status")!=null)		status  	= p.popDialogArgument("status");
		}
	});
	function returnVal(){
		var returnValue = new Array(3);
		returnValue["comment"] 	= $("#comment").val();
		returnValue["rtn"] 		= "ok";
		returnValue["status"] 		= status;
		p.popReturnValue(returnValue);
		p.window.close();
	}
</script>

</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="popup_title">
		<ul>
			<li><tit:txt mid='memoV1' mdef='결재 의견'/></li>
			<li class="close"></li>
		</ul>
	</div>
	<div class="popup_main">
		<table border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<textarea id="comment" style="width:350px;height:40px;"></textarea>
				</td>
			</tr>
		</table>
		<div class="popup_button outer">
			<ul>
				<li>
					<a href="javascript:returnVal();" class="pink large"><tit:txt mid='104435' mdef='확인'/></a>
					<a href="javascript:p.self.close();" class="gray large"><tit:txt mid='104157' mdef='닫기'/></a>
				</li>
			</ul>
		</div>
	</div>
</div>
</body>
</html>
