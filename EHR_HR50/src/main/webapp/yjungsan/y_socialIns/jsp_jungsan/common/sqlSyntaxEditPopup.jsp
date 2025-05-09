<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>임직원 팝업</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<script type="text/javascript">
	var p = eval("<%=popUpStatus%>");
	var arg = p.window.dialogArguments;

	$(function() {
		var sqlSyntax = "";
		if( arg != undefined ) {
			sqlSyntax = arg["sqlSyntax"];
		}else{
			sqlSyntax = p.popDialogArgument("sqlSyntax");
		}
		$("#sqlSyntax").val(sqlSyntax);
	});
	
	function setValue(){
		var returnValue = new Array();
		var sqlSyntax = $("#sqlSyntax").val();
			sqlSyntax = sqlSyntax.replace(/\n/g, "\\n");
			sqlSyntax = sqlSyntax.replace(/\r/g, "\\r");
			sqlSyntax = sqlSyntax.replace(/\t/g, "\\t");
		
		returnValue["sqlSyntax"] = sqlSyntax;
		//console.log('returnValue', returnValue);
		if(p.popReturnValue) {
			p.popReturnValue(returnValue);
			p.self.close();
		}
	}
</script>

</head>
<body class="bodywrap">
	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li>SQL Syntax</li>
				<!--<li class="close"></li>-->
			</ul>
		</div>
		<div class="popup_main">
			<div class="inner">
				<p style="margin-bottom:10px;"><strong>변수 처리 문자열</strong> : @@회사코드@@, @@기관구분@@, @@신고유형@@, @@신고일@@, @@사번@@</p>
				<textarea id="sqlSyntax" name="sqlSyntax" class="w100p" rows="35"></textarea>
			</div>

			<div class="popup_button outer">
				<ul>
					<li>
						<a href="javascript:setValue();" class="pink large">확인</a>
						<a href="javascript:p.self.close();" class="gray large">닫기</a>
					</li>
				</ul>
			</div>
		</div>
	</div>
</body>
</html>