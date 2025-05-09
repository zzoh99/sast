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
	var admCd = "";		// 법정동코드
	var reqDiv = "";	// 신고구분
	
	var arg = p.window.dialogArguments;
	if( arg != undefined ) {
		taxDocNo 		= arg["taxDocNo"];
		businessPlaceCd = arg["businessPlaceCd"];
		admCd 			= arg["admCd"];
		reqDiv 			= arg["reqDiv"];
		locationCd 		= arg["locationCd"];
		
	}else{
		taxDocNo        = p.popDialogArgument("taxDocNo");
		businessPlaceCd = p.popDialogArgument("businessPlaceCd");
		admCd 			= p.popDialogArgument("admCd");
		reqDiv 			= p.popDialogArgument("reqDiv");
		locationCd 		= p.popDialogArgument("locationCd");
	}

	// 사업장(TCPN121)
	var tcpn121Cd = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList", "getBizPlaceCdList") , "");
	$("#businessPlaceCd").html(tcpn121Cd[2]);
	
	// 개인법인 구분코드(O10001)
	var tprCodList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYM=","O10001"), "");
	$("#tprCod").html(tprCodList[2]);

	$("#taxDocNo").val(taxDocNo);
	$("#businessPlaceCd").val(businessPlaceCd);
	$("#admCd").val(admCd);
	$("#reqDiv").val(reqDiv);
	$("#locationCd").val(locationCd);

	$(".close").click(function() {
		p.self.close();
	});
	
	// 개인법인코드 조회
	var tprCod = ajaxCall("<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrRst.jsp?cmd=getTprCod", $("#sheet1Form").serialize(), false);
	$("#tprCod").val("");
	if(tprCod.Data.tpr_cod != null) {
		$("#tprCod").val(tprCod.Data.tpr_cod);
	}
	
	<%-- 
	$("#tprCod").bind("change",function() {
		// 개인 법인 구분 수정
		var rst = ajaxCall("<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrRst.jsp?cmd=updateTprCod",$("#sheet1Form").serialize(),false);
	});
	 --%>
});

function createDeclaration() {
	
	if (confirm("전자신고서를 생성 하시겠습니까?")) {
		var taxDocNo		= $("#taxDocNo").val();
		var businessPlaceCd	= $("#businessPlaceCd").val();
		var reqDiv	= $("#reqDiv").val();
		var locationCd	= $("#locationCd").val();
		var tprCod = $("#tprCod").val();
		
		var result = ajaxCall("<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrRst.jsp?cmd=prcPKG_CPN_OTAX_DISK_2010_DISK_ALL_LOC", "taxDocNo="+taxDocNo+"&businessPlaceCd="+businessPlaceCd+"&reqDiv="+reqDiv+"&locationCd="+locationCd+"&tprCod="+tprCod, false);
		
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
		$("iframe").attr("src","<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrDeclaration2PopupFileDown.jsp?fileName="+fileName+"&ssnEnterCd=<%=removeXSS(session.getAttribute("ssnEnterCd"), '1')%>");
	}
}

// 암호화 파일 다운로드
function downloadTAXFC(){
	window.location.assign("<%=jspPath%>/common/file/setupTAXFC.exe");
}

// 사이트바로가기
function openSite(){
	window.open("https://www.wetax.go.kr", '_blank');
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
			<input type=hidden id="file" name="file" />
			<input type=hidden id="admCd" name="admCd" />
			<input type=hidden id="reqDiv" name="reqDiv" />
			<input type=hidden id="locationCd" name="locationCd" />
			<div class="sheet_title">
			<ul>
				<li id="txt" class="txt"></li>
				<li class="btn">
					<a href="javascript:createDeclaration();"	class="basic authA">생성</a>
					<a href="javascript:downloadTAXFC();"	class="basic authA">암호화파일다운로드</a>
					<a href="javascript:openSite();"	class="basic authA">사이트바로가기</a>
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
				<td> <select id="businessPlaceCd" name="businessPlaceCd" class="readonly"> </select></td>
			</tr>
			<tr>
				<th>개인/법인</th>
				<td> <select id="tprCod" name="tprCod" class=""> </select></td>
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