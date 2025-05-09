<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp" %>

<title><tit:txt mid='114359' mdef='권한범위항목관리 팝업'/></title>
<style type="text/css">
</style>
<script type="text/javascript">
var authScopeMgrLayer = { id: 'authScopeMgrLayer' };

$(function(){
	const modal = window.top.document.LayerModalUtility.getModal(authScopeMgrLayer.id);
	var { authScopeCd
		, authScopeNm
		, scopeType
		, prgUrl
		, sqlSyntax
		, tableNm } = modal.parameters;
	$("#authScopeCd").val(authScopeCd);
	$("#authScopeNm").val(authScopeNm);
	$("#scopeType").val(scopeType);
	$("#prgUrl").val(prgUrl);	
	$("#sqlSyntax").val(sqlSyntax);
	$("#tableNm").val(tableNm);
});

function setValue() {
	const modal = window.top.document.LayerModalUtility.getModal(authScopeMgrLayer.id);
	const p = { authScopeCd : $("#authScopeCd").val(),
				authScopeNm	: $("#authScopeNm").val(),
				scopeType 	: $("#scopeType").val(),
				prgUrl 		: $("#prgUrl").val(),
				sqlSyntax	: $("#sqlSyntax").val(),
				tableNm		: $("#tableNm").val()};
	modal.fire(authScopeMgrLayer.id + 'Trigger', p).hide();
}
</script>
</head>
<body class="bodywrap">

<div class="wrapper modal_layer">
	<div class="modal_body">
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
	</div>
	<div class="modal_footer">
		<btn:a href="javascript:closeCommonLayer('authScopeMgrLayer');" css="btn outline_gray" mid='110881' mdef="닫기"/>
		<btn:a href="javascript:setValue();" css="btn filled" mid='110716' mdef="확인"/>
	</div>
</body>
</html>
