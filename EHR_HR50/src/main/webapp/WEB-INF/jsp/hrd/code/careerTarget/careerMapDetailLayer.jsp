<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
	<base target="_self" />
	<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
	<title><tit:txt mid='emailSend' mdef='MAIL 발신'/></title>
	<script src="${ctx}/common/plugin/ckeditor5/ckeditor.js"></script>
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
		var isProgress = false;

		//var gbRead = 'N'
		$(function(){
			const modal = window.top.document.LayerModalUtility.getModal('careerMapDetailLayer');

			var careerTargetCd 	=  modal.parameters.careerTargetCd || '';
			var contents 	=  modal.parameters.careerMap ;
			var readYn 	=  modal.parameters.readYn ;
			$("#careerTargetCd").val( careerTargetCd );

			if(readYn == 'N'){
				$('#modifyContents').val(contents);
				callIframeBody("authorForm", "authorFrame");
				$('#authorFrame').on("load", function() { setIframeHeight(setIframeHeight("authorFrame");); });
			}else {
				document.querySelector('#initContents').style.display = 'none'
				document.querySelector('#readContents').style.display = ''
				document.querySelector('#btnSave').style.display = 'none'
				// document.querySelector('#btnDel').style.margin = '5px'
				document.querySelector('#readContents').innerHTML = contents
			}

			//Cancel 버튼 처리
			$(".close").click(function(){
				//p.self.close();
				closeCommonLayer('careerMapDetailLayer');
			});
		});

		function fnSave(){
			try{
				isProgress = true;
				progressBar(true, "Please Wait...");
				document.getElementById("authorFrame").contentWindow.setValue();
				setTimeout(function(){
					rtn = ajaxCall("/CareerTarget.do?cmd=saveCareerMapContents",$("#dataForm").serialize(),false);
					alert(rtn.Result.Message);
					progressBar(false);
					isProgress = false;

					var rv = new Array();
					rv["careerMap"] = $("#content").val();

					const modal = window.top.document.LayerModalUtility.getModal('careerMapDetailLayer');
					modal.fire('careerMapDetailLayerTrigger', rv).hide();

					if(rtn.Result.Code < 1) return;
				}, 1000)
			}catch(ex) {
				alert("Script Errors Occurred While Saving." + ex);
				return;
			}
		}

	</script>
</head>
<body class="wrapper">
<div class="wrapper modal_layer">
	<form id="authorForm" name="form">
		<input type="hidden" id="modifyContents" name="modifyContents"	/>
		<input type="hidden" id="height" name="height" value="415" />
	</form>
	<div class="modal_body">
		<form id="dataForm" name="dataForm" >
			<input type="hidden" id="contType" name="contType"  />
			<input type="hidden" id="careerTargetCd" name="careerTargetCd"  />
			<input type="hidden" id="sdate" name="sdate"  />
			<!-- ckEditor -->
			<input type="hidden" id="ckEditorContentArea" name="content">
			<table class="table">
				<colgroup>
					<col width="100%" />
				</colgroup>
				<tr>
					<td colspan="2">
						<div id="initContents">
							<iframe id="authorFrame" name="authorFrame" frameborder="0" class="author_iframe"></iframe>
						</div>
						<div id="readContents" style="display:none;">
					</td>
				</tr>
			</table>
		</form>
		<div  id="hiddenContent"  Style="display:none" >
		</div>
	</div>
	<div class="modal_footer">
		<a id="btnSave" href="javascript:fnSave();" class="btn filled"><tit:txt mid='104476' mdef='저장'/></a>
		<a id="btnDel" href="javascript:closeCommonLayer('careerMapDetailLayer');" class="btn outline_gray"><tit:txt mid='104157' mdef='닫기'/></a>
	</div>
</div>
</body>
</html>
