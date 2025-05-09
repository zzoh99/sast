<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='113266' mdef='시스템사용기준관리 팝업'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<style type="text/css">
</style>
<script type="text/javascript">
var p = eval("${popUpStatus}");
$(function(){
	var dataType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00025"), "");	//DATA_TYPE
	var bizCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getCommonMainMenuList&searchMainMenuCd="), "<tit:txt mid='103895' mdef='전체'/>");

	$("#dataType").html(dataType[2]);
	$("#bizCd").html(bizCd[2]);
	
	var arg = p.window.dialogArguments;
	
	var stdCd  		= "";
	var stdNm  		= ""; 
	var stdCdDesc	= ""; 
	var dataType  	= ""; 
	var stdCdValue  = ""; 
	var bizCd  		= ""; 
	
	if( arg != undefined ) {
		stdCd  		= arg["stdCd"];     
		stdNm  		= arg["stdNm"];     
		stdCdDesc	= arg["stdCdDesc"]; 
		dataType  	= arg["dataType"];  
		stdCdValue  = arg["stdCdValue"];
		bizCd  		= arg["bizCd"];     
	}else{
    	if(p.popDialogArgument("stdCd")!=null)		stdCd  		= p.popDialogArgument("stdCd");
    	if(p.popDialogArgument("stdNm")!=null)		stdNm  		= p.popDialogArgument("stdNm");
    	if(p.popDialogArgument("stdCdDesc")!=null)	stdCdDesc	= p.popDialogArgument("stdCdDesc");
    	if(p.popDialogArgument("dataType")!=null)	dataType  	= p.popDialogArgument("dataType");
    	if(p.popDialogArgument("stdCdValue")!=null)	stdCdValue  = p.popDialogArgument("stdCdValue");	
    	if(p.popDialogArgument("bizCd")!=null)		bizCd  		= p.popDialogArgument("bizCd");	
	}
	
	$("#stdCd").val(stdCd);
	$("#stdNm").val(stdNm);
	$("#stdCdDesc").val(stdCdDesc);
	$("#dataType").val(dataType);	
	$("#stdCdValue").val(stdCdValue);
	$("#bizCd").val(bizCd);
	
	//Cancel 버튼 처리 
	$(".close").click(function(){
		p.self.close(); 
	});
});

function setValue() {
	var rv = new Array(6);
	rv["stdCd"] 	= $("#stdCd").val();
	rv["stdNm"]	= $("#stdNm").val();
	rv["stdCdDesc"] 	= $("#stdCdDesc").val();
	rv["dataType"] 		= $("#dataType").val();
	rv["stdCdValue"]		= $("#stdCdValue").val();
	rv["bizCd"]		= $("#bizCd").val();
	
	if(p.popReturnValue) p.popReturnValue(rv);               
	p.window.close(); 
}
</script>
</head>
<body class="bodywrap">

<div class="wrapper">
	<div class="popup_title">
		<ul>
			<li><tit:txt mid='sysUsingMgrPop' mdef='시스템사용기준관리 세부내역'/></li>
			<li class="close"></li>
		</ul>
	</div>
	
	<div class="popup_main">
		<table class="table">
		<colgroup>
			<col width="20%" />
			<col width="80%" />
		</colgroup>
		<inptu type="hidden" id="stdCd" name="stdCd">
		<tr>
			<th><tit:txt mid='114701' mdef='기준코드명'/></th>
			<td>
				<input id="stdNm" name="stdNm" type="text" class="text" style="width:99%;"/>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='timWorkCount2' mdef='설명'/></th>
			<td>
				<textarea id="stdCdDesc" name="stdCdDesc" style="width:99%;height:150px"></textarea>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='112896' mdef='데이터타입'/></th>
			<td>
				<select id="dataType" name="dataType"></select> 	
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='113974' mdef='기준값'/></th>
			<td>
				<input id="stdCdValue" name="stdCdValue" type="text" class="text" style="width:99%;"/>
			</td>
		</tr>			
		<tr>
			<th><tit:txt mid='114394' mdef='업무구분'/></th>
			<td>
				<select id="bizCd" name="bizCd"></select> 	
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
