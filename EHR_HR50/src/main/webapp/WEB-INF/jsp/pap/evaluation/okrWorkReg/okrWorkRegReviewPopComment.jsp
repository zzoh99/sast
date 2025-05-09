<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>협의요청 의견등록</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("${popUpStatus}");

	$(function() {
		$(".close, #close").click(function() {
			p.self.close();
		});

		var arg = p.popDialogArgumentAll();
		if( arg != undefined ) {
			$("#searchAppraisalCd").val(arg["searchAppraisalCd"]);
			$("#searchAppOrgCd").val(arg["searchAppOrgCd"]); //평가소속
			$("#searchSabun").val(arg["searchSabun"]); //피평가자사번
			$("#searchPriorSeq").val(arg["searchPriorSeq"]);
			$("#searchSeq").val(arg["searchSeq"]);
			$("#searchRegYmd").val(arg["searchRegYmd"]);
			$("#searchRegSeq").val(arg["searchRegSeq"]);
		}
		
	});

	function setValue() {
		if( $("#searchConferMemo").val().trim() == "" ){
			alert("의견은 반드시 입력해 주세요.");
			$("#searchConferMemo").focus();
			return;
		}
		
		if(!confirm("협의요청 하시겠습니까?"))	return;


		var data = ajaxCall("${ctx}/OkrWorkReg.do?cmd=saveOkrWorkRegReviewPopComment",$("#srchFrm").serialize(),false);

		if(data.Result.Code == -1) {
			alert(data.Result.Message);
		} else {
			$("#searchStatusCd").val( "35" );
			var rs = ajaxCall("${ctx}/OkrWorkReg.do?cmd=updateOkrWorkStatusCd",$("#srchFrm").serialize(),false);

			if(data.Result.Code == -1) {
				alert(data.Result.Message);
			} else {
				var rv = new Array();
				rv["Code"] = data.Result.Code;
				
				alert("협의요청 처리되었습니다.");
				p.popReturnValue(rv);
				p.self.close();
			}
		}
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="popup_title">
	<ul>
		<li>협의요청 의견등록</li>
		<li class="close"></li>
	</ul>
	</div>

	<div class="popup_main">
		<form id="srchFrm" name="srchFrm" >
			<input id="searchAppraisalCd" 	name="searchAppraisalCd" 	type="hidden" />
			<input id="searchAppOrgCd" 		name="searchAppOrgCd" 		type="hidden" />
			<input id="searchSabun" 		name="searchSabun" 			type="hidden" />
			<input id="searchPriorSeq" 		name="searchPriorSeq" 		type="hidden" />
			<input id="searchSeq" 			name="searchSeq" 			type="hidden" />
			<input id="searchRegYmd" 		name="searchRegYmd" 		type="hidden" />
			<input id="searchRegSeq" 		name="searchRegSeq" 		type="hidden" />
			<input id="searchStatusCd" 		name="searchStatusCd" 		type="hidden" />
	
			<table class="table">
				<tbody>
					<colgroup>
						<col width="100%" />
					</colgroup>
	
					<tr>
						<td class="content">
							<textarea id="searchConferMemo" name="searchConferMemo" rows="8" class="${textCss} w100p"></textarea>
						</td>
					</tr>
				</tbody>
			</table>
			
		</form>

		<div class="popup_button outer">
		<ul>
			<li>
				<a href="javascript:setValue();" class="pink large">협의요청</a>
				<a id="close" class="gray large">닫기</a>
			</li>
		</ul>
		</div>
	</div>
</div>
</body>
</html>