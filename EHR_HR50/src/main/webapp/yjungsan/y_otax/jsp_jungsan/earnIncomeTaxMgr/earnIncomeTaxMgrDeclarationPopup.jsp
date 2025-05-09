<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>전자신고서 작성</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<!--
 * 원천징수이행상황신고서
 * @author JM
-->
<script type="text/javascript">
var p = eval("<%=popUpStatus%>");
$(function() {
	var taxDocNo = "";
	var businessPlaceCd = "";

	var arg = p.window.dialogArguments;
	if( arg != undefined ) {
		taxDocNo 		= arg["taxDocNo"];
		businessPlaceCd = arg["businessPlaceCd"];
		
	}else{
		taxDocNo        = p.popDialogArgument("taxDocNo");
		businessPlaceCd = p.popDialogArgument("businessPlaceCd");
	}

	// 사업장(TCPN121)
	var tcpn121Cd = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList", "getBizPlaceCdList") , "");
	$("#businessPlaceCd").html(tcpn121Cd[2]);

	$("#taxDocNo").val(taxDocNo);
	$("#businessPlaceCd").val(businessPlaceCd);

	$(".close").click(function() {
		p.self.close();
	});
});

function createDeclaration() {
	if ($("#userId").val() == "") {
		alert("사용자ID를 입력하십시오.");
		return;
	}

	if (confirm("전자신고서를 생성 하시겠습니까?")) {

		var taxDocNo		= $("#taxDocNo").val();
		var businessPlaceCd	= $("#businessPlaceCd").val();
		var userId			= $("#userId").val();
		var result = ajaxCall("<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrRst.jsp?cmd=prcPKG_CPN_OTAX_DISK_2010", "taxDocNo="+taxDocNo+"&businessPlaceCd="+businessPlaceCd+"&userId="+userId, false);

		/*
		if (result != null && result["Result"] != null && result["Result"]["Code"] != null) {
			if (result["Result"]["Code"] == "0") {
				// 전자신고서를 생성 완료후 파일다운로드 호출
				var fileName = result["Result"]["serverFileName"];
				if (fileName != null && fileName != "") {
					ntsFileDownload(fileName);
				}
			} else if (result["Result"]["Message"] != null && result["Result"]["Message"] != "") {
				alert(result["Result"]["Message"]);
			}
		} else {
			alert("전자신고서 생성 오류입니다.");
		}
		*/
		if (result != null && result["Result"] != null && result["Result"]["Code"] != null) {
			if (result["Result"]["Code"] == "1") {
				// 전자신고서를 생성 완료후 파일다운로드 호출
				var fileName = result["Result"]["serverFileName"];
				if (fileName != null && fileName != "") {
					ntsFileDownload(fileName);
				}
			}
		}		
	}
}

function ntsFileDownload(fileName) {
	if(fileName != "") {
		$("iframe").attr("src","<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrDeclarationPopupFileDown.jsp?fileName="+fileName+"&ssnEnterCd=<%=removeXSS(session.getAttribute("ssnEnterCd"), '1')%>");
	}
}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="popup_title">
		<ul>
			<li>전자신고서 작성</li>
			<li class="close"></li>
		</ul>
	</div>
	<div class="popup_main">
		<form id="sheet1Form" name="sheet1Form">
			<input type=hidden id="file" name="file">
			<div class="sheet_title">
			<ul>
				<li id="txt" class="txt"></li>
				<li class="btn">
					<a href="javascript:createDeclaration()"	class="basic authA">생성</a>
				</li>
			</ul>
			</div>
			<table border="0" cellpadding="0" cellspacing="0" class="default outer">
			<colgroup>
				<col width="30%" />
				<col width="70%" />
			</colgroup>
			<tr>
				<th>문서번호</th>
				<td> <input type="text" id="taxDocNo" name="taxDocNo" class="text readonly" value="" style="width:120px" readonly /> </td>
			</tr>
			<tr>
				<th>사업장</th>
				<td> <select id="businessPlaceCd" name="businessPlaceCd" class="readonly" disabled> </select></td>
			</tr>
			<tr>
				<th>사용자ID</th>
				<td> <input type="text" id="userId" name="userId" class="text" value="" style="width:120px" /> </td>
			</tr>
			</table>
			<div class="popup_button outer">
				<ul>
					<li>
						<a href="javascript:p.self.close();" class="gray large">닫기</a>
					</li>
				</ul>
			</div>
		</form>
	</div>
</div>
<iframe src="" frameborder="0" scrolling="no" width="0" height="0" style="display:none"></iframe>
</body>
</html>