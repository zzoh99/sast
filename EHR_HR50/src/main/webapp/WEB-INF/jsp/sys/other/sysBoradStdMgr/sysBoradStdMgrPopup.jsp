<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='111911' mdef='기준관리 팝업'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<style type="text/css">
</style>
<script type="text/javascript">
var p = eval("${popUpStatus}");
$(function(){
	var arg = p.window.dialogArguments;
	var schGubunCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S90008"), "");	//일정구분
	$("#schGubunCd").html(schGubunCd[2]);
	
	var seq  		= arg["seq"];
	var schGubunCd  = arg["schGubunCd"];
	var sdate  		= arg["sdate"];
	var edate  		= arg["edate"];
	var title  		= arg["title"];
	var memo		= arg["memo"];
	
	$("#seq").val(seq);
	$("#schGubunCd").val(schGubunCd);
	$("#sdate").val(sdate);
	$("#edate").val(edate);
	$("#title").val(title);	
	$("#memo").val(memo);
	
	$( "#sdate" ).datepicker2();
	$( "#edate" ).datepicker2();
	
	//Cancel 버튼 처리 
	$(".close").click(function(){
		p.self.close(); 
	});
});

function setValue() {
	var rv = new Array(6);
	rv["seq"] 	= $("#seq").val();
	rv["schGubunCd"]		= $("#schGubunCd").val();
	rv["sdate"]	= $("#sdate").val();
	rv["edate"]		= $("#edate").val();
	rv["title"] 		= $("#title").val();
	rv["memo"] 	= $("#memo").val();
	
	p.window.returnValue = rv;                   
	p.window.close(); 
}
</script>
</head>
<body class="bodywrap">

<div class="wrapper">
	<div class="popup_title">
		<ul>
			<li><tit:txt mid='111912' mdef='기준관리 세부내역'/></li>
			<li class="close"></li>
		</ul>
	</div>
	
	<div class="popup_main">
		<table class="table">
		<colgroup>
			<col width="20%" />
			<col width="80%" />
		</colgroup>
		<inptu type="hidden" id="seq" name="seq">
		<tr>
			<th><tit:txt mid='114393' mdef='일정구분'/></th>
			<td>
				<select id="schGubunCd" name="schGubunCd"></select> 	
			</td>
		</tr>		
		<tr>
			<th><tit:txt mid='104497' mdef='시작일'/></th>
			<td>
				<input id="sdate" name="sdate" type="text" class="date2"/>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='111909' mdef='종료일'/></th>
			<td>
				<input id="edate" name="edate" type="text" class="date2"/>
			</td>
		</tr>	
		<tr>
			<th><tit:txt mid='104082' mdef='일정'/></th>
			<td>
				<input id="title" name="title" type="text" class="text" style="width:99%;"/>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='timWorkCount2' mdef='설명'/></th>
			<td>
				<textarea id="memo" name="memo" style="width:99%;height:200px"></textarea>
			</td>
		</tr>
		</table>
		
		<div class="popup_button">
			<ul>
				<li>
					<btn:a href="javascript:setValue();" css="pink large" mid='110716' mdef="확인"/>
					<btn:a href="javascript:p.self.close();" css="gray large" mid='110881' mdef="닫기"/>
				</li>
			</ul>
		</div>
	</div>
</div>

</body>
</html>
