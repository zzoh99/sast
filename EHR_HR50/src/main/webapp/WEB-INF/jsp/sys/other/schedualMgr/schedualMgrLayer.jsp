<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='112603' mdef='일정관리 팝업'/></title>
<style type="text/css">
</style>
<script type="text/javascript">
var p = eval("${popUpStatus}");
var schedualMgrLayer = { id: 'schedualMgrLayer' }

$(function(){

	const modal = window.top.document.LayerModalUtility.getModal('schedualMgrLayer');

	// var arg = p.window.dialogArguments;
	var schGubunCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S90008"), "");	//일정구분
	$("#schGubunCd").html(schGubunCd[2]);
	
	var seq  		= "";
	var schGubunCd  = ""; 
	var sdate  		= "";
	var edate  		= ""; 
	var title  		= ""; 
	var memo		= ""; 
	
    if( modal != undefined ) {
    	seq  		= modal.parameters.seq;
    	schGubunCd  = modal.parameters.schGubunCd;
		yy 			= modal.parameters.yy;
    	sdate  		= modal.parameters.sdate;
    	edate  		= modal.parameters.edate;
    	title  		= modal.parameters.title;
    	memo		= modal.parameters.memo;
    }else{
    	if(modal.parameters.seq!=null)				seq  		= modal.parameters.seq;
    	if(modal.parameters.schGubunCd!=null)		schGubunCd  = modal.parameters.schGubunCd;
		if(modal.parameters.yy!=null)				yy  		= modal.parameters.yy;
    	if(modal.parameters.sdate!=null)			sdate  		= modal.parameters.sdate;
    	if(modal.parameters.edate!=null)			edate  		= modal.parameters.edate;
    	if(modal.parameters.title!=null)			title  		= modal.parameters.title;
    	if(modal.parameters.memo=null)				memo		= modal.parameters.memo;
    }
	
	$("#seq").val(seq);
	$("#schGubunCd").val(schGubunCd);
	$("#yy").val(yy);
	$("#sdate").val(sdate);
	$("#edate").val(edate);
	$("#title").val(title);	
	$("#memo").val(memo);
	
	$( "#edate" ).datepicker2();

	$("#schGubunCd").attr("disabled", true);
	$("#yy").attr("disabled", true);
	$("#sdate").attr("disabled", true);

});

function setValue() {
	const modal = window.top.document.LayerModalUtility.getModal(schedualMgrLayer.id);

	modal.fire('schedualMgrLayer', {
		seq : $("#seq").val()
		, schGubunCd : $("#schGubunCd").val()
		, yy : $("#yy").val()
		, sdate : $("#sdate").val()
		, edate : $("#edate").val()
		, title : $("#title").val()
		, memo : $("#memo").val()
	}).hide();

}
</script>
</head>
<body class="bodywrap">

<div class="wrapper modal_layer">
<%--	<div class="popup_title">
		<ul>
			<li><tit:txt mid='schedualMgrPop' mdef='일정관리 세부내역'/></li>
			<li class="close"></li>
		</ul>
	</div>--%>
	
	<div class="modal_body">
		<table class="table">
		<colgroup>
			<col width="20%" />
			<col width="80%" />
		</colgroup>
		<input type="hidden" id="seq" name="seq">
		<tr>
			<th><tit:txt mid='114393' mdef='일정구분'/></th>
			<td>
				<select id="schGubunCd" name="schGubunCd"  ></select>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='114393' mdef='년도'/></th>
			<td>
				<input id="yy" name="yy" type="text" class="text" readonly="readonly" style="width:29%;"/>
			</td>
		</tr>
			<tr>
			<th><tit:txt mid='104497' mdef='시작일'/></th>
			<td>
				<input id="sdate" name="sdate" type="text" class="text" readonly="readonly"/>
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
	</div>
	<div class="modal_footer">
		<btn:a href="javascript:setValue();" css="btn filled" mid='110716' mdef="확인"/>
		<btn:a href="javascript:closeCommonLayer('schedualMgrLayer');" css="btn outline_gray" mid='110881' mdef="닫기"/>
	</div>
</div>

</body>
</html>
