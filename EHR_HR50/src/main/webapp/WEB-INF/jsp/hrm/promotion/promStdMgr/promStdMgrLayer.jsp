<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='114098' mdef='승진기준관리'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {
		const modal = window.top.document.LayerModalUtility.getModal('promStdMgrLayer');

		var userCd = convCodeIdx( ajaxCall("${ctx}/PromStdMgr.do?cmd=getPromStdCodeList","",false).codeList,"선택",0 );
		$("#bPmtCd").html(userCd[2]);
		$("#tPmtCd").html(userCd[2]);
		
	    $(".close, #close").click(function() {
			closeCommonLayer('promStdMgrLayer')
	    });
	    
	    $("#prcCall").click(function() {
	    	if($("#bPmtCd").val() == "") {
	    		alert("<msg:txt mid='109383' mdef='원본을 선택하세요.'/>");
	    		$("#bPmtCd").focus();
	    		return;
	    	}
	    	if($("#tPmtCd").val() == "") {
	    		alert("<msg:txt mid='alertBeTargetCheck' mdef='대상을 선택하세요.'/>");
	    		$("#tPmtCd").focus();
	    		return;
	    	}
	    	if($("#bPmtCd").val() == $("#tPmtCd").val()) {
	    		alert("<msg:txt mid='109717' mdef='원본과 같은 대상을 선택할 수 없습니다.'/>");
	    		$("#tPmtCd").focus();
	    		return;
	    	}
	    	
	    	if(!confirm("복사 하시겠습니까?")) {
	    		return;
	    	}
	    	
	    	var data = ajaxCall("/PromStdMgr.do?cmd=prcPromStdMgr",$("#mySheetForm").serialize(),false);
	    	
	    	if(data.Result.Code == "1") {
	    		alert("<msg:txt mid='110120' mdef='처리되었습니다.'/>");
				modal.fire('promStdMgrLayerTrigger', {}).hide();
	    	} else {
		    	alert(data.Result.Message);
	    	}
	    });
	});	
	

</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<div class="modal_body">
		<form id="mySheetForm" name="mySheetForm" >
		<div class="sheet_search outer">
			<div>
			<table>
			<tr>
				<th><tit:txt mid='113608' mdef='원본'/></th>
				<td>
					<select id="bPmtCd" name="bPmtCd"></select>
				</td>
				<td>
					->
				</td>
				<th><tit:txt mid='112875' mdef='대상'/></th>
				<td>
					<select id="tPmtCd" name="tPmtCd"></select>
				</td>
			</tr>
			</table>
			</div>
		</div>
		</form>
	</div>

	<div class="modal_footer">
		<btn:a id="close" css="btn outline_gray" mid='close' mdef="닫기"/>
		<btn:a id="prcCall" css="btn filled" mid='copy' mdef="복사"/>
	</div>
</div>
</body>
</html>
