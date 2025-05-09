<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='113266' mdef='시스템사용기준관리 팝업'/></title>
<script type="text/javascript">
var sysUsingMgrLayer = { id: 'sysUsingMgrLayer' };

$(function(){
	var dataType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00025"), "");	//DATA_TYPE
	var bizCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getCommonMainMenuList&searchMainMenuCd="), "<tit:txt mid='103895' mdef='전체'/>");
	$("#dataType").html(dataType[2]);
	$("#bizCd").html(bizCd[2]);

	const modal = window.top.document.LayerModalUtility.getModal(sysUsingMgrLayer.id);
	var { stdCd
		, stdNm
		, stdCdDesc
		, dataType
		, stdCdValue
		, bizCd } = modal.parameters;
	
	$("#stdCd").val(stdCd);
	$("#stdNm").val(stdNm);
	$("#stdCdDesc").val(stdCdDesc);
	$("#dataType").val(dataType);	
	$("#stdCdValue").val(stdCdValue);
	$("#bizCd").val(bizCd);
});

function setValue() {
	var p = {stdCd 	: $("#stdCd").val(),
			 stdNm	: $("#stdNm").val(),
			 stdCdDesc 	: $("#stdCdDesc").val(),
			 dataType 		: $("#dataType").val(),
			 stdCdValue		: $("#stdCdValue").val(),
			 bizCd		: $("#bizCd").val()};
	const modal = window.top.document.LayerModalUtility.getModal(sysUsingMgrLayer.id);
	modal.fire(sysUsingMgrLayer.id + 'Trigger', p).hide();
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
	</div>
	<div class="modal_footer">
		<btn:a href="javascript:closeCommonLayer('sysUsingMgrLayer');" css="btn outline_gray" mid='110881' mdef="닫기"/>
		<btn:a href="javascript:setValue();" css="btn filled" mid='110716' mdef="확인"/>
	</div>
</div>

</body>
</html>
