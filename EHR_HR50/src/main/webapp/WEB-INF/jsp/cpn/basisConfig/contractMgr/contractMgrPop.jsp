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
    	$("#contType").val( arg["contType"] );
    	$("#sdate").val( arg["sdate"] );
    	contents        = arg["contents"];
    }

	Editor.modify({
		"content": contents
	});

	//Cancel 버튼 처리
	$(".close").click(function(){
		p.self.close();
	});
});


function fnSave(){
	
	try{
		if(!saveContent()) {
			alert("<msg:txt mid='alertSaveFail2' mdef='저장에 실패하였습니다.'/>");
			return;
		}
		
		//RD출력을 위해 editor로 작성된 table에 align="center" attribute를 추가한다.
		$("#hiddenContent").html( $("#content").val() );
		$("#hiddenContent table").attr("align", "center");
		$("#content").val( $("#hiddenContent").html() );
		
		rtn = ajaxCall("/ContractMgr.do?cmd=saveContractMgrContents",$("#dataForm").serialize(),false);
		
		alert(rtn.Result.Message);
		
		if(rtn.Result.Code < 1) return;	
		
	}catch(ex) {
		alert("저장중 스크립트 오류발생." + ex);
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
		<li>연봉계약서 상세</li>
		<li class="close"></li>
	</ul>
	</div>
	<div class="popup_main">
		<form id="dataForm" name="dataForm" >
		<input type="hidden" id="contType" name="contType" />
		<input type="hidden" id="sdate" name="sdate"  />
		<table class="table">
			<colgroup>
				<col width="15%" />
				<col width="" />
			</colgroup>
       		<tr>
				<td colspan="2">
					<%@ include file="/WEB-INF/jsp/common/plugin/Editor/include_editor.jsp"%>
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
