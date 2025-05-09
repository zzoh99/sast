<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>승진기준관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("${popUpStatus}");
	$(function() {

		$(".close, #close").click(function() {
			p.self.close();
		});

		// 평가명
		var appraisalCdList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getAppraisalCdListAppType&searchAppTypeCd=B,D", false).codeList, "");
	    $("#orgnAppraisalCd").html(appraisalCdList[2]);
	    $("#tgtAppraisalCd").html(appraisalCdList[2]);



		$("#prcCall").click(function() {
			if($("#orgnAppraisalCd").val() == "") {
				alert("원본을 선택하세요.");
				$("#orgnAppraisalCd").focus();
				return;
			}
			if($("#tgtAppraisalCd").val() == "") {
				alert("대상을 선택하세요.");
				$("#tgtAppraisalCd").focus();
				return;
			}
			if($("#orgnAppraisalCd").val() == $("#tgtAppraisalCd").val()) {
				alert("원본과 같은 대상을 선택할 수 없습니다.");
				$("#tgtAppraisalCd").focus();
				return;
			}

			if(!confirm("기존데이터를 삭제하고 원본 데이터로 생성 됩니다. \n 계속하시겠습니까?")) {
				return;
			}



			var data = ajaxCall("/AppCompItemMgr.do?cmd=saveAppCompItemMgrCopyPop",$("#mySheetForm").serialize(),false);
	    	if(data.Result.Code != null && data.Result.Code > 0) {
	    		alert(data.Result.Message);
	    		var returnValue = new Array(1);
	    		returnValue["appraisalCd"]		= $("#tgtAppraisalCd").val();
	    		p.window.returnValue = returnValue;
	    		p.self.close();
	    	} else {
		    	alert(data.Result.Message);
	    	}


		});



	});


</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="popup_title">
	<ul>
		<li>역량평가항목복사</li>
		<li class="close"></li>
	</ul>
	</div>

	<div class="popup_main">
		<form id="mySheetForm" name="mySheetForm" >
		<div class="sheet_search outer">
			<div>
			<table>
			<tr>
				<td>
					<span>원본</span>
					<select id="orgnAppraisalCd" name="orgnAppraisalCd" ></select>

				</td>
				<td>

				</td>
				<td>
					<span>대상</span>
					<select id="tgtAppraisalCd" name="tgtAppraisalCd" ></select>
				</td>
			</tr>
			</table>
			</div>
		</div>
		</form>

		<div class="popup_button outer">
		<ul>
			<li>
				<a id="prcCall" class="pink large">복사</a>
				<a id="close" class="gray large">닫기</a>
			</li>
		</ul>
		</div>
	</div>
</div>
</body>
</html>