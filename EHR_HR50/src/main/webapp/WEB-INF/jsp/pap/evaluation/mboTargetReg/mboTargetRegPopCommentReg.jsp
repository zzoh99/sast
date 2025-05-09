<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"><head> <title>의견등록</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<script type="text/javascript">
	var authPg	= "";
	var modal = "";
	var popGubun = "";
	$(function() {
		modal = window.top.document.LayerModalUtility.getModal('mboTargetRegPopCommentRegLayer');

		$(".close").click(function() 	{ closeCommonLayer('mboTargetRegPopCommentRegLayer'); });

		$("#middleAppMemo").maxbyte(2000);
		
		if( modal.parameters != undefined ) {
			$("#searchAppraisalCd", "#mboTargetCommentRegFrm").val(modal.parameters.searchAppraisalCd);
			$("#searchEvaSabun", "#mboTargetCommentRegFrm").val(modal.parameters.searchEvaSabun);
			$("#searchAppOrgCd", "#mboTargetCommentRegFrm").val(modal.parameters.searchAppOrgCd);
			$("#searchAppStepCd", "#mboTargetCommentRegFrm").val(modal.parameters.searchAppStepCd);
			$("#searchAppStatusCd", "#mboTargetCommentRegFrm").val(modal.parameters.searchAppStatusCd);
			$("#searchAppSeqCd", "#mboTargetCommentRegFrm").val(modal.parameters.searchAppSeqCd);
			$("#searchAppSabun", "#mboTargetCommentRegFrm").val(modal.parameters.searchAppSabun);
			$("#searchAppYn", "#mboTargetCommentRegFrm").val(modal.parameters.searchAppYn);
			popGubun = modal.parameters.popGubun;
			
			if( $("#searchAppYn", "#mboTargetCommentRegFrm").val() == "" ){
				$("#prcCall").html("승인요청");
				$("#span_title").html("승인요청 의견등록");
			}else if( $("#searchAppYn", "#mboTargetCommentRegFrm").val() == "Y" ){
				$("#prcCall").html("승인");
				$("#span_title").html("승인 의견등록");
			}else if( $("#searchAppYn", "#mboTargetCommentRegFrm").val() == "N" ){
				$("#prcCall").html("반려");
				$("#span_title").html("반려 의견등록");
			}
			
			if( modal.parameters.lastAppSeqCd != undefined && modal.parameters.lastAppSeqCd != "" ) {
				$("#lastAppSeqCd", "#mboTargetCommentRegFrm").val(modal.parameters.lastAppSeqCd);
			}
		}
		
		$("#middleAppBox").hide();
		// 중간점검승인에서 승인 처리인 경우 평가등급 및 의견 입력 폼 출력
		if($("#searchAppStepCd", "#mboTargetCommentRegFrm").val() == "3" && $("#searchAppYn", "#mboTargetCommentRegFrm").val() == "Y" && $("#lastAppSeqCd", "#mboTargetCommentRegFrm").val() == $("#searchAppSeqCd", "#mboTargetCommentRegFrm").val()) {
			$("#lastApprYn", "#mboTargetCommentRegFrm").val("Y");
			var appClassCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00001"), "평가등급"); // 평가등급(P00001)
			$("#middleAppClassCd").html( appClassCdList[2] );
			$("#middleAppBox").show();
			// [IDS] 가장 마지막 평가차수이거나 2차평가차수인 경우 출력 ---> 마지막 차수일 때만 출력하도록 변경 (2차평가자가 입력 후 3차평가자가 입력하게 되면 덮어쓰기 되므로 업무상 2차평가자의 입력이 필요할 경우 각 사이트에서 별도 구현 요망)
			//if($("#lastAppSeqCd", "#mboTargetCommentRegFrm").val() == $("#searchAppSeqCd", "#mboTargetCommentRegFrm").val()
			//		|| $("#searchAppSeqCd", "#mboTargetCommentRegFrm").val() == "2") {
			//}
		} else {
			$("#lastApprYn", "#mboTargetCommentRegFrm").val("N");
		}

	});

	function setValue() {
		if( $("#searchAppComment", "#mboTargetCommentRegFrm").val().trim() == "" ){
			alert("의견은 반드시 입력해 주세요.");
			$("#searchAppComment").focus();
			return;
		}
		
		if($("#searchAppStepCd", "#mboTargetCommentRegFrm").val() == "3" && $("#searchAppYn", "#mboTargetCommentRegFrm").val() == "Y" && $("#lastAppSeqCd", "#mboTargetCommentRegFrm").val() == $("#searchAppSeqCd", "#mboTargetCommentRegFrm").val()) {
			if($("#middleAppClassCd", "#mboTargetCommentRegFrm").val() == "" && $("#middleAppClassCd").is(":visible")) {
				alert("평가등급은 반드시 선택해 주세요.");
				$("#middleAppClassCd").focus();
				return;
			} else if($("#middleAppMemo", "#mboTargetCommentRegFrm").val().trim() == "" && $("#middleAppMemo").is(":visible")) {
				alert("평가의견은 반드시 입력해 주세요.");
				$("#middleAppMemo").focus();
				return;
			}
		}

		if(!confirm($("#prcCall").html()+" 하시겠습니까?"))	return;

	   	if ( $("#searchAppComment", "#mboTargetCommentRegFrm").val().trim() == "" ){
		
	   		const p = {Code : "1"};
	   		
	   		var modal = window.top.document.LayerModalUtility.getModal('mboTargetRegPopCommentRegLayer');
			modal.fire('evaGoalCommentRegTrigger', p).hide();
			/* var rv = new Array();
			rv["Code"] = "1";

			p.popReturnValue(rv);
			p.window.close(); */
			
	  	}else{
			var sAppStatusCd = $("#searchAppStatusCd", "#mboTargetCommentRegFrm").val();
			var sRegSabun = "";

			//승인요청시 진행자 사번은 피평가자사번 / 승인, 반려등에서는 평가자 사번
			//if(sAppStatusCd == "11"||sAppStatusCd == "23"||sAppStatusCd == "33") {
			if ($("#searchAppYn", "#mboTargetCommentRegFrm").val() == "") {
				sRegSabun = $("#searchEvaSabun", "#mboTargetCommentRegFrm").val();
			} else {
				sRegSabun = $("#searchAppSabun", "#mboTargetCommentRegFrm").val();
			}

			//미제출에서 신청시 승인요청 상태
			//if(sAppStatusCd == "11"||sAppStatusCd == "23"||sAppStatusCd == "33") {
			if ($("#searchAppYn", "#mboTargetCommentRegFrm").val() == "") {
				switch (sAppStatusCd) {
				// 11(미제출)
				case "11":
				// 23(1차반려)
				case "23":
					// 21(승인요청)
					sAppStatusCd = "21";
					break;
				// 33(2차반려)
				case "33":
					// 31(2차승인요청)
					sAppStatusCd = "31";
					break;
				// 43(3차반려)
				case "43":
					// 41(3차승인요청)
					sAppStatusCd = "41";
					break;
				default:
					alert($("#prcCall").html() + " 처리중 오류가 발생하였습니다.\n팝업을 닫고 다시 시도해 주세요.1");
					return;
					break;
				}

			//승인요청에서 승인시 완료 상태
			} else if( $("#searchAppYn", "#mboTargetCommentRegFrm").val() == "Y") {
				switch (sAppStatusCd) {
				// 21(승인요청)
				case "21":
					// 25(1차승인)
					sAppStatusCd = "25";
					break;
				// 25(1차승인)
				case "25":
				// 31(2차승인요청)
				case "31":
					// 35(2차승인)
					sAppStatusCd = "35";
					break;
				// 35(2차승인)
				case "35":
				// 41(3차승인요청)
				case "41":
					// 99(최종승인)
					sAppStatusCd = "99";
					break;
				default:
					alert($("#prcCall").html() + " 처리중 오류가 발생하였습니다.\n팝업을 닫고 다시 시도해 주세요.2");
					return;
					break;
				}
				
				// [IDS] 가장 마지막 평가차수인 경우 최종승인 처리
				if($("#lastAppSeqCd", "#mboTargetCommentRegFrm").val() == $("#searchAppSeqCd", "#mboTargetCommentRegFrm").val()) {
					// 99(최종승인)
					sAppStatusCd = "99";
				}

			//승인요청에서 반려시 반려 상태
			} else 	if( $("#searchAppYn", "#mboTargetCommentRegFrm").val() == "N") {
				switch (sAppStatusCd) {
				// 21(승인요청)
				case "21":
					// 23(1차반려)
					sAppStatusCd = "23";
					break;
				// 25(1차승인)
				case "25":
				// 31(2차승인요청)
				case "31":
					// 33(2차반려)
					sAppStatusCd = "33";
					break;
				// 35(2차승인)
				case "35":
				// 41(3차승인요청)
				case "41":
					// 43(3차반려)
					sAppStatusCd = "43";
					break;
				default:
					alert($("#prcCall").html() + " 처리중 오류가 발생하였습니다.\n팝업을 닫고 다시 시도해 주세요.3");
					return;
					break;
				}
			}
			
			$("#searchAppStatusCd", "#mboTargetCommentRegFrm").val( sAppStatusCd );
			$("#searchRegSabun", "#mboTargetCommentRegFrm").val( sRegSabun );

			var data = ajaxCall("${ctx}/EvaMain.do?cmd=saveMboTargetRegPopCommentReg",$("#mboTargetCommentRegFrm").serialize(),false);

			if(data.Result.Code == -1) {
				alert(data.Result.Message);
			} else {
				
				const p = {
						Code : data.Result.Code,
						searchAppStatusCd : sAppStatusCd,
						popGubun : popGubun
				};
				var modal = window.top.document.LayerModalUtility.getModal('mboTargetRegPopCommentRegLayer');
				modal.fire('evaGoalCommentRegTrigger', p).hide();
			}
		}
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<div class="modal_body">
		<form id="mboTargetCommentRegFrm" name="mboTargetCommentRegFrm" >
			<input id="searchAppraisalCd" name="searchAppraisalCd" type="hidden" />
			<input id="searchEvaSabun" name="searchEvaSabun" type="hidden" />
			<input id="searchAppOrgCd" name="searchAppOrgCd" type="hidden" />
			<input id="searchAppStepCd" name="searchAppStepCd" type="hidden" />
			<input id="searchAppStatusCd" name="searchAppStatusCd" type="hidden" />
			<input id="searchAppSeqCd" name="searchAppSeqCd" type="hidden" />
			<input id="searchAppSabun" name="searchAppSabun" type="hidden" />
			<input id="searchAppYn" name="searchAppYn" type="hidden" />
			<input id="searchRegSabun" name="searchRegSabun" type="hidden" />
			<input id="lastAppSeqCd" name="lastAppSeqCd" type="hidden" />
			<input id="lastApprYn" name="lastApprYn" type="hidden" />	<!-- 마지막 승인 여부 -->
			<table class="table">
				<tbody>
					<colgroup>
						<col width="100%" />
					</colgroup>
	
					<tr>
						<td class="content">
							<textarea id="searchAppComment" name="searchAppComment" rows="8" class="${textCss} w100p"></textarea>
						</td>
					</tr>
				</tbody>
			</table>
			
			<div class="mat20" id="middleAppBox">
				<div class="sheet_title">
					<ul>
						<li class="txt">중간점검평가</li>
					</ul>
				</div>
				<table class="table">
					<tbody>
						<colgroup>
							<col width="20%" />
							<col width="80%" />
						</colgroup>
						<tr>
							<th class="">평가등급</th>
							<td><select id="middleAppClassCd" name="middleAppClassCd"></select></td>
						</tr>
						<tr>
							<th class="">평가의견</th>
							<td class="content" >
								<textarea id="middleAppMemo" name="middleAppMemo" rows="6" class="${textCss} w100p"></textarea>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</form>
	</div>
	<div class="modal_footer">
		<a href="javascript:setValue();" id="prcCall" class="btn filled">확인</a>
		<a href="javascript:closeCommonLayer('mboTargetRegPopCommentRegLayer');" class="btn outline_gray">닫기</a>
	</div>
</div>
</body>
</html>