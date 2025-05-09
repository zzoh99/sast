<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<base target="_self" />
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='emailSend' mdef='MAIL 발신'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

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
var MAIL_SEND_FLAG = true;
var p = eval("${popUpStatus}"); 
var arg_col = "";
var arg_val = "";
var arg_sender= "";

$(function(){
	var contents 	= "";

	var arg = p.popDialogArgumentAll();
    if( arg != undefined ) {
    	$("#appraisalCd").val( arg["appraisalCd"] );
    	$("#appStepCd").val( arg["appStepCd"] );
    	contents        = arg["content"];
    }

	// Editor.modify({
	// 	"content": contents
	// });
	SunEditor.modify(contents);

	//Cancel 버튼 처리
	$(".close").click(function(){
		p.self.close();
	});
});


function fnSave(){

	try{
		 if(!saveContent()) {
			alert("<msg:txt mid='alertSaveFail2' mdef='저장에 실패하였습니다.'/>");
			alert("");
			return;
		}

		//RD출력을 위해 editor로 작성된 table에 align="center" attribute를 추가한다.
		$("#hiddenContent").html( $("#content").val() );
		$("#hiddenContent table").attr("align", "center");
		$("#content").val( $("#hiddenContent").html() );

		rtn = ajaxCall("/AppraisalIdMgr.do?cmd=saveAppraisalIdMgrTab1Guide",$("#dataForm").serialize(),false);

		alert(rtn.Result.Message);

		if(rtn.Result.Code < 1) return;

	}catch(ex) {
		alert("Script Errors Occurred While Saving." + ex);
		return;
	}

	if(p.popReturnValue) p.popReturnValue();
	p.self.close()
}

</script>
</head>
<body class="bodywrap">
<div class="wrapper popup_scroll">
	<div class="popup_title">
	<ul>
		<li>평가가이드 상세</li>
		<li class="close"></li>
	</ul>
	</div>
	<div class="popup_main">
		<form id="dataForm" name="dataForm" >
		<input type="hidden" id="appraisalCd" name="appraisalCd"  />
		<input type="hidden" id="appStepCd" name="appStepCd"  />

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
       		<tr>
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
					<a href="javascript:p.self.close();" class="gray large"><tit:txt mid='104157' mdef='닫기'/></a>
				</li>
			</ul>
		</div>
		<div  id="hiddenContent"  Style="display:none" >
		</div>
	</div>
</div>
</body>
</html>
