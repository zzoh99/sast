<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<base target="_self" />
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>

<!-- SunEditor -->
<link href="${ctx}/common/plugin/suneditor/suneditor-2.45.1.min.css" rel="stylesheet">
<script src="${ctx}/common/plugin/suneditor/suneditor-2.45.1.min.js"></script>
<script src="${ctx}/common/plugin/suneditor/suneditor-2.45.1.ko.js"></script>
<script src="${ctx}/common/plugin/suneditor/js/SunEditorEvent.js"></script>

<script type="text/javascript">
<%
Map<String, Object> editorMap = new HashMap<String, Object>();
editorMap.put("formNm", "dataForm");
editorMap.put("contentNm", "contents");
request.setAttribute("editor", editorMap);
%>
var LAYER = { id: 'appraisalIdMgrLayer' };
var MAIL_SEND_FLAG = true;
var arg_col = "";
var arg_val = "";
var arg_sender= "";

$(function(){
	const modal = window.top.document.LayerModalUtility.getModal(LAYER.id);
	var contents 	= modal.parameters.content;
	$("#appraisalCd").val( modal.parameters.appraisalCd );
	$("#appStepCd").val( modal.parameters.appStepCd);
	SunEditor.modify(contents);
});

function fnSave(){

	try{
		//RD출력을 위해 editor로 작성된 table에 align="center" attribute를 추가한다.
		$("#hiddenContent").html( $("#content").val() );
		$("#hiddenContent table").attr("align", "center");
		$("#content").val( $("#hiddenContent").html() );
		SunEditor.readySave();
		rtn = ajaxCall("/AppraisalIdMgr.do?cmd=saveAppraisalIdMgrTab1Guide",$("#dataForm").serialize(),false);
		alert(rtn.Result.Message);
		if(rtn.Result.Code < 1) return;

	}catch(ex) {
		alert("Script Errors Occurred While Saving." + ex);
		return;
	}
	closeCommonLayer('appraisalIdMgrLayer');
}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="popup_main">
		<form id="dataForm" name="dataForm" >
		<input type="hidden" id="appraisalCd" name="appraisalCd"  />
		<input type="hidden" id="appStepCd" name="appStepCd"  />
		<input type="hidden" id="sunEditorContentArea" name="content">

		<!-- 
		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<tr>
				<td>
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li id="txt" class="txt">회사명:#회사명# / 직원 성명:#성명# / 직원 입사일:#입사일#</li>
					</ul>
					</div>
				</div>
				</td>
			</tr>
		</table>
		 -->
		<table class="table">
			<colgroup>
				<col width="15%" />
				<col width="" />
			</colgroup>
			<tr id="area_editor">
				<td colspan="2">
					<%@ include file="/WEB-INF/jsp/common/plugin/SunEditor/include_editor.jsp"%>
				</td>
			</tr>
		</table>
		</form>
		<div class="popup_button">
			<ul>
				<li>
					<a href="javascript:fnSave();" class="pink large"><tit:txt mid='104476' mdef='저장'/></a>
					<a href="javascript:closeCommonLayer('appraisalIdMgrLayer');" class="gray large"><tit:txt mid='104157' mdef='닫기'/></a>
				</li>
			</ul>
		</div>
		<div  id="hiddenContent"  Style="display:none" >
		</div>
	</div>
</div>
</body>
</html>
