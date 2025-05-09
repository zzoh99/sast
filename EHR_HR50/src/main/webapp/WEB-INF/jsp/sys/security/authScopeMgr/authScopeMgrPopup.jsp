<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='114359' mdef='권한범위항목관리 팝업'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<style type="text/css">
</style>
<script type="text/javascript">
var p = eval("${popUpStatus}");
$(function(){
	var arg = p.window.dialogArguments;
	
    var authScopeCd 	= "";
    var authScopeNm 	= "";
    var scopeType 		= "";
    var prgUrl 			= "";
    var sqlSyntax 		="";
    var tableNm 		= "";
	
    if( arg != undefined ) {
	    authScopeCd = arg["authScopeCd"];
        authScopeNm = arg["authScopeNm"];
        scopeType 	= arg["scopeType"];  
        prgUrl 		= arg["prgUrl"];     
        sqlSyntax 	= arg["sqlSyntax"];  
        tableNm 	= arg["tableNm"];    
    }else{
    	if(p.popDialogArgument("authScopeCd")!=null)		authScopeCd = p.popDialogArgument("authScopeCd");
    	if(p.popDialogArgument("authScopeNm")!=null)		authScopeNm = p.popDialogArgument("authScopeNm");
    	if(p.popDialogArgument("scopeType")!=null)			scopeType 	= p.popDialogArgument("scopeType");
    	if(p.popDialogArgument("prgUrl")!=null)				prgUrl 		= p.popDialogArgument("prgUrl");
    	if(p.popDialogArgument("sqlSyntax")!=null)			sqlSyntax 	= p.popDialogArgument("sqlSyntax");
    	if(p.popDialogArgument("tableNm")!=null)			tableNm 	= p.popDialogArgument("tableNm");
    }
	
	$("#authScopeCd").val(authScopeCd);
	$("#authScopeNm").val(authScopeNm);
	$("#scopeType").val(scopeType);
	$("#prgUrl").val(prgUrl);	
	$("#sqlSyntax").val(sqlSyntax);
	$("#tableNm").val(tableNm);
	
	//Cancel 버튼 처리 
	$(".close").click(function(){
		p.self.close(); 
	});
});

function setValue() {
	var rv = new Array(6);
	rv["authScopeCd"] 	= $("#authScopeCd").val();
	rv["authScopeNm"]	= $("#authScopeNm").val();
	rv["scopeType"] 	= $("#scopeType").val();
	rv["prgUrl"] 		= $("#prgUrl").val();
	rv["sqlSyntax"]		= $("#sqlSyntax").val();
	rv["tableNm"]		= $("#tableNm").val();
	
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
			<li><tit:txt mid='authScopeMgrPop' mdef='권한범위항목관리 세부내역'/></li>
			<li class="close"></li>
		</ul>
	</div>
	
	<div class="popup_main">
		<table class="table">
		<colgroup>
			<col width="20%" />
			<col width="80%" />
		</colgroup>
		<inptu type="hidden" id="authScopeCd" name="authScopeCd">
		<tr>
			<th><tit:txt mid='112583' mdef='권한범위항목명'/></th>
			<td>
				<input id="authScopeNm" name="authScopeNm" type="text" class="text" style="width:99%;"/>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='114010' mdef='범위적용구분'/></th>
			<td>
				<select id="scopeType" name="scopeType">
					<option value="SQL">SQL</option>
                	<option value="PROGRAM">PROGRAM</option>
				</select> 
			</td>
		</tr>
		<input id="prgUrl" name="prgUrl" type="hidden"/>
		<tr>
			<th><tit:txt mid='112960' mdef='SQL구문'/></th>
			<td>
				<textarea id="sqlSyntax" name="sqlSyntax" style="width:99%;height:300px"></textarea>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='114011' mdef='사용테이블'/></th>
			<td>
				<input id="tableNm" name="tableNm" type="text" class="text" style="width:99%;"/>
			</td>
		</tr>		
		</table>
		
		<div class="popup_button">
			<ul>
				<li>
					<btn:a href="javascript:setValue();" css="pink large authA" mid='110716' mdef="확인"/>
					<btn:a href="javascript:p.self.close();" css="gray large authR" mid='110881' mdef="닫기"/>
				</li>
			</ul>
		</div>
	</div>
</div>

</body>
</html>
