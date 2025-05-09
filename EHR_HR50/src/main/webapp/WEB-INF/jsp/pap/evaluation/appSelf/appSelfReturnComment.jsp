<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>의견등록</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->

<script type="text/javascript">
	var txt = "";

	$(function() {
		const modal = window.top.document.LayerModalUtility.getModal('appSelfReturnCommentLayer');

		var arg = modal.parameters;
		if ( arg != undefined ) {
			$("#searchAppraisalCd", "#appSelfReturnCommentFrm").val(arg["searchAppraisalCd"]);
			$("#searchEvaSabun", "#appSelfReturnCommentFrm").val(arg["searchEvaSabun"]);
			$("#searchAppOrgCd", "#appSelfReturnCommentFrm").val(arg["searchAppOrgCd"]);
			$("#searchAppStepCd", "#appSelfReturnCommentFrm").val(arg["searchAppStepCd"]);
			$("#searchAppSabun", "#appSelfReturnCommentFrm").val(arg["searchAppSabun"]);
			$("#searchAppYn", "#appSelfReturnCommentFrm").val(arg["searchAppYn"]);
			$("#searchAppSeqCd", "#appSelfReturnCommentFrm").val(arg["searchAppSeqCd"]);
			
			if (arg["lastAppSeqCd"] != null && arg["lastAppSeqCd"] != undefined && arg["lastAppSeqCd"] != "") {
				$("#lastAppSeqCd", "#appSelfReturnCommentFrm").val(arg["lastAppSeqCd"]);
			}
		}
		if ($("#searchAppSeqCd", "#appSelfReturnCommentFrm").val() == "0") { //본인 평가 완료 시
			txt = "평가완료";
			$("#prcCall").html("평가완료");
			$("#li_title").html("본인평가 의견등록");
			$("#searchAppStatusCd", "#appSelfReturnCommentFrm").val("21");
		} else {
			if ( $("#searchAppYn", "#appSelfReturnCommentFrm").val() == "Y" ) {
				txt = "승인";
				switch ($("#searchAppSeqCd", "#appSelfReturnCommentFrm").val()) {
				// 1차평가
				case "1":
					$("#searchAppStatusCd", "#appSelfReturnCommentFrm").val("25");
					break;
				// 2차평가
				case "2":
					$("#searchAppStatusCd", "#appSelfReturnCommentFrm").val("35");
					break;
				// 3차평가
				case "6":
					$("#searchAppStatusCd", "#appSelfReturnCommentFrm").val("99");
					break;
				default:
					break;
				}
				// 마지막 평가차수인 경우 99(최종승인) 처리
				if($("#lastAppSeqCd", "#appSelfReturnCommentFrm").val() == $("#searchAppSeqCd", "#appSelfReturnCommentFrm").val()) {
					$("#searchAppStatusCd", "#appSelfReturnCommentFrm").val("99");
				}
			} else {
				txt = "반려";
				switch ($("#searchAppSeqCd", "#appSelfReturnCommentFrm").val()) {
				// 1차평가
				case "1":
					$("#searchAppStatusCd", "#appSelfReturnCommentFrm").val("23");
					break;
				// 2차평가
				case "2":
					$("#searchAppStatusCd", "#appSelfReturnCommentFrm").val("33");
					break;
				// 3차평가
				case "6":
					$("#searchAppStatusCd", "#appSelfReturnCommentFrm").val("43");
					break;
				default:
					break;
				}
			}
			$("#prcCall").html(txt);
			$("#li_title").html(txt+"의견등록");
		}
	});

	function setValue() {

		if( $("#searchAppComment", "#appSelfReturnCommentFrm").val().trim() == "" ){
			alert("의견은 반드시 입력 해주세요.");
			$("#searchAppComment").focus();
			return;
		}

		if(!confirm(txt+" 하시겠습니까?"))	return;


		var sRegSabun = $("#searchAppSabun", "#appSelfReturnCommentFrm").val();

    	$("#searchRegSabun", "#appSelfReturnCommentFrm").val( sRegSabun );
        //var data = ajaxCall("${ctx}/MboTargetReg.do?cmd=saveMboTargetRegPopCommentReg",$("#appSelfReturnCommentFrm").serialize(),false);

        if ( $("#searchAppComment", "#appSelfReturnCommentFrm").val() == "" ){

        	var rv = new Array();
			rv["Code"] = "1";

			var modal = window.top.document.LayerModalUtility.getModal('appSelfReturnCommentLayer');
			modal.fire('appSelfReturnCommentLayerTrigger', rv).hide();

        }else{

			var data = ajaxCall("${ctx}/EvaMain.do?cmd=saveAppSelfReturnComment",$("#appSelfReturnCommentFrm").serialize(),false);

			if(data.Result.Code == -1) {
				alert(data.Result.Message);
			} else {
				var rv = new Array();
				rv["Code"] = data.Result.Code;

				var modal = window.top.document.LayerModalUtility.getModal('appSelfReturnCommentLayer');
				modal.fire('appSelfReturnCommentLayerTrigger', rv).hide();
	    	}
        }
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<div class="modal_body">
		<form id="appSelfReturnCommentFrm" name="appSelfReturnCommentFrm" >
		<input id="searchAppraisalCd" name="searchAppraisalCd" type="hidden" />
		<input id="searchEvaSabun" name="searchEvaSabun" type="hidden" />
		<input id="searchAppOrgCd" name="searchAppOrgCd" type="hidden" />
		<input id="searchAppStepCd" name="searchAppStepCd" type="hidden" />
		<input id="searchAppSeqCd" name="searchAppSeqCd" type="hidden" />
		<input id="searchAppSabun" name="searchAppSabun" type="hidden" />
		<input id="searchAppYn" name="searchAppSabun" type="hidden" />
		<input id="lastAppSeqCd" name="lastAppSeqCd" type="hidden" />
		<input id="searchAppStatusCd" name="searchAppStatusCd" type="hidden" />
		<input id="searchRegSabun" name="searchRegSabun" type="hidden" />

		<table class="table">
			<tbody>
				<colgroup>
					<col width="100%" />
				</colgroup>

				<tr>
					<td class="content">
						<textarea id="searchAppComment" name="searchAppComment" rows="9" class="${textCss} w100p"></textarea>
					</td>
				</tr>
			</tbody>
		</table>
		</form>

	</div>
	<div class="modal_footer">
		<a href="javascript:setValue();" id="prcCall" class="btn filled">반려</a>
		<a href="javascript:closeCommonLayer('appSelfReturnCommentLayer');" class="btn outline_gray">닫기</a>
	</div>
</div>
</body>
</html>