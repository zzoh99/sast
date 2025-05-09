<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>승진기준관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("${popUpStatus}");
	$(function() {

		var arg = p.popDialogArgumentAll();

		 if( arg != undefined ) {
			$("#appraisalCd").val(arg["searchAppraisalCd"]);
		}


		$(".close, #close").click(function() {
			p.self.close();
		});

		// 평가명
		var appStepCdList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getAppSeqCdList", false).codeList, "");
	    $("#orgnAppStepCd").html(appStepCdList[2]);
	    $("#tgtAppStepCd").html(appStepCdList[2]);



		$("#prcCall").click(function() {
			if($("#orgnAppStepCd").val() == "") {
				alert("원본을 선택하세요.");
				$("#orgnAppStepCd").focus();
				return;
			}
			if($("#tgtAppStepCd").val() == "") {
				alert("대상을 선택하세요.");
				$("#tgtAppStepCd").focus();
				return;
			}
			if($("#orgnAppStepCd").val() == $("#tgtAppStepCd").val()) {
				alert("원본과 같은 대상을 선택할 수 없습니다.");
				$("#tgtAppStepCd").focus();
				return;
			}

			if(!confirm("기존데이터를 삭제하고 원본 데이터로 생성 됩니다. \n 계속하시겠습니까?")) {
				return;
			}



			var data = ajaxCall("/AppGroupMgr.do?cmd=prcAppGroupMgrCopyPop",$("#mySheetForm").serialize(),false);
	    	if(data.Result.Code == null) {
	    		alert("처리되었습니다.");

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
		<li>평가그룹 차수별 복사</li>
		<li class="close"></li>
	</ul>
	</div>

	<div class="popup_main">
		<form id="mySheetForm" name="mySheetForm" >
		<input type="hidden" name="appraisalCd" id="appraisalCd" />
		<div class="sheet_search outer">
			<div>
			<table>
			<tr>
				<td>
					<span>원본</span>
					<select id="orgnAppStepCd" name="orgnAppStepCd" ></select>

				</td>
				<td>

				</td>
				<td>
					<span>대상</span>
					<select id="tgtAppStepCd" name="tgtAppStepCd" ></select>
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