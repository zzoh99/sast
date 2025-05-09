<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<base target="_self" />
<script src="${ctx}/common/plugin/ckeditor5/ckeditor.js"></script>
<script type="text/javascript">
<%
Map<String, Object> editorMap = new HashMap<String, Object>();
editorMap.put("formNm", "dataForm");
editorMap.put("contentNm", "contents");
request.setAttribute("editor", editorMap);
%>
var MAIL_SEND_FLAG = true;
var arg_col = "";
var arg_val = "";
var arg_sender= "";

$(function() {
	const modal = window.top.document.LayerModalUtility.getModal('empContractMgrLayer');

	$("#contType").val( '${contType}');
	$("#sdate").val( '${sdate}');

	$('#modifyContents').val(modal.parameters.contents);
	callIframeBody("authorForm", "authorFrame");
	$('#authorFrame').on("load", function() { setIframeHeight("authorFrame"); });

	var eleHtml = "";
	var data = ajaxCall("${ctx}/EmpContractEleMgr.do?cmd=getEmpContractEleMgrList&searchContType=" + $("#contType").val(), null, false);
	//console.log('data', data);

	if(data != null && data != undefined && data.DATA != null && data.DATA != undefined && data.DATA.length > 0) {
		var item = null;
		for(var i = 0; i < data.DATA.length; i++) {
			item = data.DATA[i];
			eleHtml += " / " + item.eleNm + ":" + item.eleCd;
		}

		$("#txt").append(eleHtml);
	}

});

function fnClose(){
	const modal = window.top.document.LayerModalUtility.getModal('empContractMgrLayer');
	modal.fire('empContractMgrTrigger', {}).hide();
}

function fnSave(){
	try{
		//RD출력을 위해 editor로 작성된 table에 align="center" attribute를 추가한다.
		$("#hiddenContent").html( $("#content").val() );
		$("#hiddenContent table").attr("align", "center");
		$("#content").val( $("#hiddenContent").html() );

		ckReadySave("authorFrame");
		rtn = ajaxCall("/EmpContractMgr.do?cmd=saveEmpContractMgrContents",$("#dataForm").serialize(),false);

		alert(rtn.Result.Message);

		if(rtn.Result.Code < 1) return;

	}catch(ex) {
		alert("Script Errors Occurred While Saving." + ex);
		return;
	}
	fnClose();
	// if(p.popReturnValue) p.popReturnValue();
	// p.self.close()
}

</script>
<div class="wrapper popup_scroll modal_layer">
	<!--
	<div class="popup_title">
	<ul>
		<li>계약서 상세</li>
		<li class="close" onclick="fnClose()"></li>
	</ul>
	</div>
	-->
	<div class="modal_body">
		<form id="authorForm" name="form">
			<input type="hidden" id="modifyContents" name="modifyContents"	/>
			<input type="hidden" id="height" name="height" value="485" />
		</form>
		<form id="dataForm" name="dataForm" style="height: 100%;">
		<input type="hidden" id="contType" name="contType"  />
		<input type="hidden" id="sdate" name="sdate"  />
		<!-- CkEditor -->
		<input type="hidden" id="ckEditorContentArea" name="content">

		<table id="tablePopTitle" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
				<div class="layerTitle-wrap">
	            	<p id="txt" class="_popTitle">회사명:#회사명# / 직원 성명:#성명# / 직원 입사일:#입사일#</p>
	            </div>

				</td>
			</tr>
		</table>
		<table class="table">
			<colgroup>
				<col width="15%" />
				<col width="" />
			</colgroup>
       		<tr>
				<td colspan="2">
					<iframe id="authorFrame" name="authorFrame" frameborder="0" class="author_iframe"></iframe>
				</td>
			</tr>
		</table>
		</form>
		<div  id="hiddenContent"  Style="display:none" >
		</div>
	</div>
	<div class="modal_footer">
		<a href="javascript:fnSave();" class="btn filled"><tit:txt mid='104476' mdef='저장'/></a>
		<a href="javascript:fnClose();" class="btn outline_gray"><tit:txt mid='104157' mdef='닫기'/></a>

	</div>
</div>
