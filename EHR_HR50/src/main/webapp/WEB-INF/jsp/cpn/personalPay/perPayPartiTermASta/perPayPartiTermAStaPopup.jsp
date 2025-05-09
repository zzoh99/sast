<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='112100' mdef='개인별 급여 내역'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var p = eval("${popUpStatus}");
	$(function() {
		var arg = p.window.dialogArguments;
		var searchTdSabun = "";
		var payActionCd = "";

        if( arg != undefined ) {
        	searchTdSabun 	= arg["sabun"];
        	payActionCd 	= arg["payActionCd"];
	    }else{
	    	if(p.popDialogArgument("sabun")!=null)				searchTdSabun  	= p.popDialogArgument("sabun");
	    	if(p.popDialogArgument("payActionCd")!=null)		payActionCd  	= p.popDialogArgument("payActionCd");
	    }

		/*iframe에서는 html로 받으므로 val에서 html로 변경 by JSG*/
		$("#tdSabun").html(searchTdSabun);
		$("#payActionCd").val(payActionCd);

	    $(".close").click(function() {
	    	p.self.close();
	    });

		setTimeout(function(){
	    	submitCall($("#srchFrm"),"ifm","POST","${ctx}/PerPayPartiTermUSta.do?cmd=viewPerPayPartiAdminStaSubMain");
		},100);

	});

</script>


</head>
<body class="bodywrap">

	<form id="srchFrm" name="srchFrm" >
		<span class="hide" id="tdSabun" > </span>
		<input type="hidden" id="payActionCd" name="payActionCd" value=""/>
		<input type="hidden" id="auth" name="auth" value="R"/>
	</form>

	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li><tit:txt mid='perPayPartiTermAStaPop' mdef='개인별 급여 세부내역'/></li>
				<li class="close"></li>
			</ul>
		</div>
        <div class="popup_main">
		<iframe id="ifm" name="ifm" src="${ctx}/common/hidden.html" style="width:100%;height:400px" frameborder="0"></iframe>
		<div class="popup_button outer">
			<ul>
				<li>
					<btn:a href="javascript:p.self.close();" css="gray large" mid='110881' mdef="닫기"/>
				</li>
			</ul>
		</div>
       </div>
	</div>
</body>
</html>



