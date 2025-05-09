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
			$("#searchAppraisalCd").val(arg["searchAppraisalCd"]);
			$("#searchAppStepCd").val(arg["searchAppStepCd"]);
		}

		$(".close, #close").click(function() {
			p.self.close();
		});

		//조직도 select box
		var searchSdate = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrgSchemeSdate",false).codeList, "");	//조직도
		$("#searchSdate").html(searchSdate[2]);

	});

	function goProc(){
		if(confirm("조직도 복사 작업을 하시겠습니까? \n기존 저장된 데이터가 초기화 됩니다.")){
			var data = ajaxCall("${ctx}/AppOrgSchemeMgr.do?cmd=prcAppOrgSchemeCopy",$("#mySheetForm").serialize(),false);
			if(data.Result.Code == null) {
				top.opener.doAction1("Search");
				alert("처리되었습니다.");
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
<div class="wrapper">
	<div class="popup_title">
	<ul>
		<li>조직도복사</li>
		<li class="close"></li>
	</ul>
	</div>

	<div class="popup_main">

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
					<select id="searchSdate" name="searchSdate" class="${textCss} ${readonly} require"></select>
				</td>
			</tr>
		</table>
		<div class="popup_button">
			<ul>
				<li>
					<a href="javascript:goProc();" class="pink large">복사</a>
					<a href="javascript:p.self.close();" class="gray large">닫기</a>
				</li>
			</ul>
		</div>
	</div>
</div>
</form>
</body>
</html>