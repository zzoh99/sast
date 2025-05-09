<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='113311' mdef='DB Item관리 팝업'/></title>
<style type="text/css">
</style>
<script type="text/javascript">
$(function(){
	var dataType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00025"), "");	//DATA_TYPE
	var bizCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getCommonMainMenuList&searchMainMenuCd="), "<tit:txt mid='103895' mdef='전체'/>");

	$("#dataType").html(dataType[2]);
	$("#bizCd").html(bizCd[2]);

	const modal = window.top.document.LayerModalUtility.getModal('dbItemLayer');
	var dbItemCd  	= modal.parameters.dbItemCd || '';
	var dbItemNm  	= modal.parameters.dbItemNm || '';
	var description	= modal.parameters.description || '';
	var dataType  	= modal.parameters.dataType || '';
	var sqlSyntax  	= modal.parameters.sqlSyntax || '';
	var bizCd  		= modal.parameters.bizCd || '';
	var sysYn  		= modal.parameters.sysYn || '';

	$("#dbItemCd").val(dbItemCd);
	$("#dbItemNm").val(dbItemNm);
	$("#description").val(description);
	$("#dataType").val(dataType);
	$("#sqlSyntax").val(sqlSyntax);
	$("#bizCd").val(bizCd);
	$("#sysYn").val(sysYn);
});

function setValue() {
	const modal = window.top.document.LayerModalUtility.getModal('dbItemLayer');
	modal.fire('dbItemTrigger', {
		dbItemCd : $("#dbItemCd").val()
		, dbItemNm : $("#dbItemNm").val()
		, description : $("#description").val()
		, dataType : $("#dataType").val()
		, sqlSyntax : $("#sqlSyntax").val()
		, bizCd : $("#bizCd").val()
		, sysYn : $("#sysYn").val()
	}).hide();
}
</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<div class="modal_body">
		<input type="hidden" id="dbItemCd" name="dbItemCd" />
		<inptut type="hidden" id="sysYn" name="sysYn" />
		<table class="table">
			<colgroup>
				<col width="20%" />
				<col width="80%" />
			</colgroup>

			<tr>
				<th><tit:txt mid='114208' mdef='ITEM명'/></th>
				<td>
					<input id="dbItemNm" name="dbItemNm" type="text" class="text" style="width:99%;"/>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='timWorkCount2' mdef='설명'/></th>
				<td>
					<textarea id="description" name="description" style="width:99%;height:100px"></textarea>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='112896' mdef='데이터타입'/></th>
				<td>
					<select id="dataType" name="dataType"></select>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='114394' mdef='업무구분'/></th>
				<td>
					<select id="bizCd" name="bizCd"></select>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='112960' mdef='SQL구문'/></th>
				<td>
					<textarea id="sqlSyntax" name="sqlSyntax" style="width:99%;height:300px"></textarea>
				</td>
			</tr>
		</table>
	</div>
	<div class="modal_footer">
		<ul>
			<li>
				<btn:a href="javascript:setValue();" css="button authA" mid='110716' mdef="확인"/>
				<btn:a href="javascript:closeCommonLayer('dbItemLayer');" css="basic authR" mid='110881' mdef="닫기"/>
			</li>
		</ul>
	</div>
</div>

</body>
</html>
