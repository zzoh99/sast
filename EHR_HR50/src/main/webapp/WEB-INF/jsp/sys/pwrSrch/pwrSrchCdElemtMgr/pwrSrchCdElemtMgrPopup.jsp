<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='112604' mdef='조건검색코드항목관리 팝업'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<style type="text/css">
</style>
<script type="text/javascript">
var p = eval("${popUpStatus}");
$(function(){
	var arg = p.window.dialogArguments;
	
	var searchItemCd  	= "";
	var searchItemNm  	= "";
	var searchItemDesc	= "";
	var itemMapType  	= "";
	var prgUrl  		= "";
	var sqlSyntax  		= "";
	
	if( arg != undefined ) {
		searchItemCd  	= arg["searchItemCd"];  
		searchItemNm  	= arg["searchItemNm"];  
		searchItemDesc	= arg["searchItemDesc"];
		itemMapType  	= arg["itemMapType"];   
		prgUrl  		= arg["prgUrl"];        
		sqlSyntax  		= arg["sqlSyntax"];     
	}else{
    	if(p.popDialogArgument("searchItemCd")!=null)		searchItemCd  	= p.popDialogArgument("searchItemCd");
    	if(p.popDialogArgument("searchItemNm")!=null)		searchItemNm  	= p.popDialogArgument("searchItemNm");
    	if(p.popDialogArgument("searchItemDesc")!=null)		searchItemDesc	= p.popDialogArgument("searchItemDesc");
    	if(p.popDialogArgument("itemMapType")!=null)		itemMapType  	= p.popDialogArgument("itemMapType");
    	if(p.popDialogArgument("prgUrl")!=null)				prgUrl  		= p.popDialogArgument("prgUrl");
    	if(p.popDialogArgument("sqlSyntax")!=null)			sqlSyntax  		= p.popDialogArgument("sqlSyntax");
	}
	
	$("#searchItemCd").val(searchItemCd);
	$("#searchItemNm").val(searchItemNm);
	$("#searchItemDesc").val(searchItemDesc);
	$("#itemMapType").val(itemMapType);
	$("#prgUrl").val(prgUrl);
	$("#sqlSyntax").val(sqlSyntax);
	
	//Cancel 버튼 처리 
	$(".close").click(function(){
		p.self.close(); 
	});
});

function save() {
	var rv = new Array(5);
	rv["searchItemNm"] 	= $("#searchItemNm").val();
	rv["searchItemDesc"]= $("#searchItemDesc").val();
	rv["itemMapType"] 	= $("#itemMapType").val();
	rv["prgUrl"] 		= $("#prgUrl").val();
	rv["sqlSyntax"]		= $("#sqlSyntax").val();
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
		
		<div class="popup_button">
			<ul>
				<li>
					<btn:a href="javascript:save();" css="pink large" mid='save' mdef="저장"/>
					<btn:a href="javascript:p.self.close();" css="gray large" mid='110881' mdef="닫기"/>
				</li>
			</ul>
		</div>
	</div>
</div>

</body>
</html>
