<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>승진기준관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->


<script type="text/javascript">
	var p = eval("${popUpStatus}");
	$(function() {

		var modal = window.top.document.LayerModalUtility.getModal('appOrgCopyLayer');

		//var arg = p.popDialogArgumentAll();

		 //if( arg != undefined ) {
			$("#searchAppraisalCd").val(modal.parameters.searchAppraisalCd);
			$("#searchAppStepCd").val(modal.parameters.searchAppStepCd);
		//}


		//조직도 select box
		var searchSdate = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrgSchemeSdate",false).codeList, "");	//조직도
		$("#searchSdate").html(searchSdate[2]);

	});

	function goProc(){
		if(confirm("조직도 복사 작업을 하시겠습니까? \n기존 저장된 데이터가 초기화 됩니다.")){
			var data = ajaxCall("${ctx}/AppOrgSchemeMgr.do?cmd=prcAppOrgSchemeCopy",$("#mySheetForm").serialize(),false);
			if(data.Result.Code == null) {
				alert("처리되었습니다.");
				const modal = window.top.document.LayerModalUtility.getModal('appOrgCopyLayer');
				modal.fire('appOrgCopyLayerTrigger', {}).hide();
			} else {
		    	alert(data.Result.Message);
			}
		}
	}


</script>
</head>
<body class="bodywrap">
		<form id="mySheetForm" name="mySheetForm" >
		<input type="hidden" name="searchAppraisalCd" id="searchAppraisalCd" />
		<input type="hidden" name="searchAppStepCd" id="searchAppStepCd" />
<div class="wrapper modal_layer">

	<div class="modal_body">

		<table class="table">
		<%--
			<colgroup>
				<col width="20%" />
				<col width="20%" />
				<col width="60%" />
			</colgroup>
			--%>
			<tr>
				<th>조직도</th>
				<td>
					<select id="searchSdate" name="searchSdate" class="required" required></select>
				</td>
			</tr>
		</table>
	</div>
	<div class="modal_footer">
		<a href="javascript:goProc();" class="btn filled">복사</a>
		<a href="javascript:closeCommonLayer('appOrgCopyLayer');" class="btn outline_gray">닫기</a>
	</div>
</div>
</form>
</body>
</html>