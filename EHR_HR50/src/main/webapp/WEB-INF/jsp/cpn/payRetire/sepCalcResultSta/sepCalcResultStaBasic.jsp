<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>퇴직금결과내역 기본사항</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 퇴직금결과내역
 * @author JM
-->
<script type="text/javascript">
$(function() {
	$(window).smartresize(sheetResize);
	sheetInit();

	if (parent.$("#searchUserId").val() != null && parent.$("#searchUserId").val() != "" &&
		parent.$("#payActionCd").val() != null && parent.$("#payActionCd").val() != "") {
		$("#sabun").val(parent.$("#searchUserId").val());
		$("#payActionCd").val(parent.$("#payActionCd").val());
		doAction1("Search");
	}
});

// 필수값/유효성 체크
function chkInVal(sAction) {
	if (parent.$("#searchUserId").val() == "") {
		parent.$("#searchUserId").focus();
		return false;
	}
	if (parent.$("#payActionCd").val() == "") {
		parent.$("#payActionCd").focus();
		return false;
	}
	return true;
}

function doAction1(sAction) {
	switch (sAction) {
		case "Search":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			$("#sabun").val(parent.$("#searchUserId").val());
			$("#payActionCd").val(parent.$("#payActionCd").val());

			var basicInfo = ajaxCall("${ctx}/SepCalcResultSta.do?cmd=getSepCalcResultStaBasicMap", $("#sheet1Form").serialize(), false);

			$("#tdEmpYmd"	).html("");
			$("#tdRetYmd"	).html("");
			$("#tdRmidYmd"	).html("");
			$("#tdSepSymd"	).html("");
			$("#tdSepEymd"	).html("");

			if (basicInfo.Map != null) {
				basicInfo = basicInfo.Map;
				$("#tdEmpYmd"	).html(basicInfo.empYmd);
				$("#tdRetYmd"	).html(basicInfo.retYmd);
				$("#tdRmidYmd"	).html(basicInfo.rmidYmd);
				$("#tdSepSymd"	).html(basicInfo.sepSymd);
				$("#tdSepEymd"	).html(basicInfo.sepEymd);
			} else if (basicInfo.Message != null && basicInfo.Message != "") {
				alert(basicInfo.Message);
			}
			break;

		case "Clear":
			sheet1.RemoveAll();
			break;
	}
}

function setEmpPage() {
	doAction1("Search");
}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form">
	<input type="hidden" id="sabun" name="sabun" value="" />
	<input type="hidden" id="payActionCd" name="payActionCd" value="" />
	<table border="0" cellpadding="0" cellspacing="0" class="default outer">
	<colgroup>
		<col width="15%" />
		<col width="15%" />
		<col width="15%" />
		<col width="15%" />
		<col width="15%" />
		<col width="15%" />
	</colgroup>
	<tr>
		<th>입사일</th>
		<td id="tdEmpYmd" class="center"> </td>
		<th>퇴사일</th>
		<td id="tdRetYmd" class="center" colspan="3"> </td>
	</tr>
	<tr>
		<th>최종중간정산일</th>
		<td id="tdRmidYmd" class="center"> </td>
		<th>퇴직기산시작일</th>
		<td id="tdSepSymd" class="center"> </td>
		<th>퇴직기산종료일</th>
		<td id="tdSepEymd" class="center"> </td>
	</tr>
	</table>
	</form>
</div>
</body>
</html>