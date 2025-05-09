<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='112100' mdef='개인별 급여 내역'/></title>

<script type="text/javascript">
	$(function() {
		const modal = window.top.document.LayerModalUtility.getModal('payPartiTermLayer');
		let searchTdSabun = modal.parameters.sabun || '';
		let payActionCd = modal.parameters.payActionCd || '';

		/*iframe에서는 html로 받으므로 val에서 html로 변경 by JSG*/
		$("#tdSabun").html(searchTdSabun);
		$("#payActionCd").val(payActionCd);

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
	<div class="wrapper modal_layer">
        <div class="modal_body">
		<iframe id="ifm" name="ifm" src="${ctx}/common/hidden.html" style="width:100%;height:400px" frameborder="0"></iframe>

       </div>
       	<div class="modal_footer">
			<btn:a href="javascript:closeCommonLayer('payPartiTermLayer');" css="btn outline_gray" mid='110881' mdef="닫기"/>
		</div>
	</div>
</body>
</html>



