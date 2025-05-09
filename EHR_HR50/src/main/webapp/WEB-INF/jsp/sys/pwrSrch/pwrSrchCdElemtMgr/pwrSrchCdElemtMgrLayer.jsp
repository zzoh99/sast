<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp" %>
<title><tit:txt mid='112604' mdef='조건검색코드항목관리 팝업'/></title>
<script type="text/javascript">
var pwrSrchCdElemtMgrLayer = { id: 'pwrSrchCdElemtMgrLayer' };
$(function(){
	var modal = window.top.document.LayerModalUtility.getModal(pwrSrchCdElemtMgrLayer.id);
	var { searchItemCd  	
		, searchItemNm  	
		, searchItemDesc	
		, itemMapType  	
		, prgUrl  		
		, sqlSyntax } = modal.parameters; 
	$("#searchItemCd").val(searchItemCd);
	$("#searchItemNm").val(searchItemNm);
	$("#searchItemDesc").val(searchItemDesc);
	$("#itemMapType").val(itemMapType);
	$("#prgUrl").val(prgUrl);
	$("#sqlSyntax").val(sqlSyntax);
});

function save() {
	var p = {searchItemNm 	: $("#searchItemNm").val(),
			 searchItemDesc: $("#searchItemDesc").val(),
			 itemMapType 	: $("#itemMapType").val(),
			 prgUrl 		: $("#prgUrl").val(),
			 sqlSyntax		: $("#sqlSyntax").val()};
	var modal = window.top.document.LayerModalUtility.getModal(pwrSrchCdElemtMgrLayer.id);
	modal.fire(pwrSrchCdElemtMgrLayer.id + 'Trigger', p).hide();
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
		<tr>
			<th><tit:txt mid='eleGroupMgr2' mdef='항목명'/></th>
			<td>
				<input id="searchItemNm" name="searchItemNm" type="text" class="text" style="width:99%;"/>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='114042' mdef='항목설명'/></th>
			<td>
				<input id="searchItemDesc" name="searchItemDesc" type="text" class="text" style="width:99%;"/>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='112959' mdef='맵핑구분'/></th>
			<td>
				<select id="itemMapType" name="itemMapType">
					<option value="SQL">SQL</option>
                	<option value="URL">URL</option>
				</select> 
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='113334' mdef='프로그램URL'/></th>
			<td>
				<input id="prgUrl" name="prgUrl" type="text" class="text" style="width:99%;" />
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
		<btn:a href="javascript:save();" css="btn filled" mid='save' mdef="확인"/>
		<btn:a href="javascript:closeCommonLayer('pwrSrchCdElemtMgrLayer');" css="btn outline_gray" mid='110881' mdef="닫기"/>
	</div>
</div>

</body>
</html>
