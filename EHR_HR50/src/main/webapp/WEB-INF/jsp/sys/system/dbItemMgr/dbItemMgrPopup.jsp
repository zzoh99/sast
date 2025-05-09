<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='113311' mdef='DB Item관리 팝업'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<style type="text/css">
</style>
<script type="text/javascript">
var p = eval("${popUpStatus}");
$(function(){
	var dataType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00025"), "");	//DATA_TYPE
	//var bizCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R10020"), "<tit:txt mid='103895' mdef='전체'/>");	//업무구분
	var bizCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getCommonMainMenuList&searchMainMenuCd="), "<tit:txt mid='103895' mdef='전체'/>");

	$("#dataType").html(dataType[2]);
	$("#bizCd").html(bizCd[2]);

	var arg = p.window.dialogArguments;

	var dbItemCd  	= "";
	var dbItemNm  	= "";
	var description	= "";
	var dataType  	= "";
	var sqlSyntax  	= "";
	var bizCd  		= "";
	var sysYn  		= "";

    if( arg != undefined ) {
    	dbItemCd 	= 	 arg["dbItemCd"];
    	dbItemNm 	= 	 arg["dbItemNm"];
    	description = 	 arg["description"];
    	dataType 	= 	 arg["dataType"];
    	sqlSyntax 	= 	 arg["sqlSyntax"];
    	bizCd 		= 	 arg["bizCd"];
    	sysYn 		= 	 arg["sysYn"];
    }else{
    	if(p.popDialogArgument("dbItemCd")!=null)		dbItemCd  	= p.popDialogArgument("dbItemCd");
    	if(p.popDialogArgument("dbItemNm")!=null)		dbItemNm  	= p.popDialogArgument("dbItemNm");
    	if(p.popDialogArgument("description")!=null)	description  = p.popDialogArgument("description");
    	if(p.popDialogArgument("dataType")!=null)		dataType  	= p.popDialogArgument("dataType");
    	if(p.popDialogArgument("sqlSyntax")!=null)		sqlSyntax  	= p.popDialogArgument("sqlSyntax");
    	if(p.popDialogArgument("bizCd")!=null)			bizCd  	= p.popDialogArgument("bizCd");
    	if(p.popDialogArgument("sysYn")!=null)			sysYn  	= p.popDialogArgument("sysYn");
    }

	$("#dbItemCd").val(dbItemCd);
	$("#dbItemNm").val(dbItemNm);
	$("#description").val(description);
	$("#dataType").val(dataType);
	$("#sqlSyntax").val(sqlSyntax);
	$("#bizCd").val(bizCd);
	$("#sysYn").val(sysYn);

	//Cancel 버튼 처리
	$(".close").click(function(){
		p.self.close();
	});
});

function setValue() {
	var rv = new Array(6);
	rv["dbItemCd"] 	= $("#dbItemCd").val();
	rv["dbItemNm"]	= $("#dbItemNm").val();
	rv["description"] 	= $("#description").val();
	rv["dataType"] 		= $("#dataType").val();
	rv["sqlSyntax"]		= $("#sqlSyntax").val();
	rv["bizCd"]		= $("#bizCd").val();
	rv["sysYn"]		= $("#sysYn").val();

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
			<li><tit:txt mid='dbItemMgrPop' mdef='DB Item관리 세부내역'/></li>
			<li class="close"></li>
		</ul>
	</div>

	<div class="popup_main">
		<table class="table">
		<colgroup>
			<col width="20%" />
			<col width="80%" />
		</colgroup>
		<inptu type="hidden" id="dbItemCd" name="dbItemCd">
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
		<inptu type="hidden" id="sysYn" name="sysYn">
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
