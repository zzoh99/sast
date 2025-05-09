<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<%
	session.setAttribute("authPg", "A");
%>
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp" %>
<title>요구사항 팝업</title>
<style type="text/css">
</style>

	<script type="text/javascript">
	$(function() {
		const modal = window.top.document.LayerModalUtility.getModal('reqDefinitionLayer');

		$('#modal-reqDefinitionLayer').find('div.layer-modal-header span.layer-modal-title').html(modal.title);

		$("input[type='text']").keydown(function(event){ 
			if(event.keyCode == 27){
				return false;
			}
		});

		let surl = parent.$("#surl").val();
		if ( surl != "" ){
			$("#defSurl").val(surl);
		}

		$("#regYmd").val("${curSysYyyyMMddHyphen}");

		$("#regNote").maxbyte(3500);
		
//--------------------------------------------------------------------------------------------------------

		var proNameList	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S99997"), "");
		$("#proName").html("<option value=''></option>"+proNameList[2]);
		$("#regName").html("<option value=''></option><option value='${ssnName}'>${ssnName}</option>"+proNameList[2]);
		$("#regName").val("${ssnName}");


		var searchRegCd	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S99991"), "<tit:txt mid='111914' mdef='선택'/>");
		
		$("#searchRegCd").html(searchRegCd[2]);
		$("#searchRegCd option:eq(1)").prop("selected", true);
		$("#searchRegCd option:not(option:selected)").remove();
		
		$(":checkbox").click(function(event){
			
			$("#searchRegCd option").remove();
			
			if($(this).attr("id") == "searchError" && $(this).is(":checked") == true ){
				
				$("#searchRegCd").html(searchRegCd[2]);
				$("#searchRegCd option:eq(2)").prop("selected", true);
				$("#searchRegCd option:not(option:selected)").remove();
				$("#regNote").val("테스트 결과 정상입니다.");
				//$("#regNote").attr("readonly", true);
				//$("#regNote").addClass("readonly").removeClass("required");
				$("#regNote").attr("readonly", false);
				$("#regNote").removeClass("readonly").addClass("required");
				
			}else{
				
				$("#searchRegCd").html(searchRegCd[2]);
				$("#searchRegCd option:eq(1)").prop("selected", true);
				$("#searchRegCd option:not(option:selected)").remove();
				$("#regNote").val("");
				$("#regNote").attr("readonly", false);
				$("#regNote").removeClass("readonly").addClass("required");;
				
			}
		});

		initFileUploadIframe("reqDefinitionLayerUploadForm", "", "", "${authPg}");
//-------------------------------------------------------------------------------------------------------

	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {

		case "Save":
			if(!checkList()) return ;

			if (confirm( "저장하시겠습니까?")) {

				$("#sendForm>#defFileSeq").val(getFileUploadContentWindow("reqDefinitionLayerUploadForm").getFileSeq());
				try{
					var rtn = ajaxCall("${ctx}/ReqDefinitionPop.do?cmd=saveReqDefinitionPop", $("#sendForm").serialize(), false);

					if(rtn.Result.Code > 0) {
						alert(rtn.Result.Message);
					}else{
						alert(rtn.Result.Message);
						return;
					}
				} catch (ex){
					alert("저장중 스크립트 오류발생." + ex);
				}
				const modal = window.top.document.LayerModalUtility.getModal('reqDefinitionLayer');
				modal.hide();
			}
			break;
		}
	}

	// 입력시 조건 체크
	function checkList(){
		var ch = true;
		// 화면의 개별 입력 부분 필수값 체크
		$(".required").each(function(index){
			if($(this).val() == null || $(this).val() == ""){
				alert($(this).parent().prev().text()+"은(는) 필수값입니다.");
				$(this).focus();
				return false;
				ch = false;
			}
		});
		return ch;
	}
</script>
</head>
<body class="bodywrap">

<div class="wrapper modal_layer">
	<div class="modal_body">
		<form id="sendForm" name="sendForm" method="POST">
			<input type="hidden" id="defSurl" name="surl"/>
			<input type="hidden" id="defFileSeq" name="fileSeq"/>
				<table class="table">
					<colgroup>
						<col width="120px" />
						<col width="30%" />
						<col width="120px" />
						<col width="" />
					</colgroup>
					<tr>
						<th align="center">등록자</th>
						<td>
							<select id="regName" name="regName"></select>
						</td>
						<th align="center">등록일</th>
						<td>
							<input type="text" id="regYmd" name="regYmd" class="text center readonly" maxlength="10" value="" style="width: 80px;" readonly="readonly" />
						</td>
					</tr>
					<tr>
						<th align="center">등록구분</th>
						<td>
							<select id="searchRegCd" name="searchRegCd" class="box required" style="margin-right: 20px;"></select>
							<input type="checkbox" id="searchError" name="searchError" style="position: relative; top: 3px;" /><label for="searchError">오류없음(오류없는경우 체크)</label>
						</td>
						<th align="center">처리자</th>
						<td>
							<select id="proName" name="proName"></select>
						</td>
					</tr>
					<tr>
						<th align="center"><tit:txt mid='104429' mdef='내용'/></th>
						<td colspan="3">
							<textarea id="regNote" name="regNote" class="required" rows="10" cols="10" style="width: 100%; ime-mode:active;"></textarea>
						</td>
					</tr>
				</table>
		</form>
		<div id="uploadDiv">
			<iframe id="reqDefinitionLayerUploadForm" name="reqDefinitionLayerUploadForm" frameborder="0" class="author_iframe" style="height:200px;"></iframe>
		</div>
	</div>
	<div class="modal_footer">
		<a href="javascript:doAction1('Save');" class="btn filled"><tit:txt mid='104476' mdef='저장'/></a>
		<a href="javascript:closeCommonLayer('reqDefinitionLayer');" class="btn outline_gray"><tit:txt mid='104157' mdef='닫기'/></a>
	</div>
</div>

</body>
</html>
