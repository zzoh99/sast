<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>퇴직금기본내역 전근무지사항</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 퇴직금기본내역
 * @author JM
-->
<script type="text/javascript">
$(function() {

	$("input[type='text']").keydown(function(event){
		if(event.keyCode == 27){
			return false;
		}
	});

	$(window).smartresize(sheetResize);
	sheetInit();

/* 	if (parent.$("#tdSabun").val() != null && parent.$("#tdSabun").val() != "" &&
		parent.$("#payActionCd").val() != null && parent.$("#payActionCd").val() != "") {
		$("#sabun").val(parent.$("#tdSabun").val());
		$("#payActionCd").val(parent.$("#payActionCd").val());
		doAction1("Search");
	} */
	setEmpPage();
});

// 필수값/유효성 체크
function chkInVal() {
/* 	if(parent.$("#tdSabun").val() == "") {
		alert("대상자를 선택하십시오.");
		parent.$("#tdSabun").focus();
		return false;
	}
	if(parent.$("#payActionCd").val() == "") {
		alert("퇴직일자를 선택하십시오.");
		parent.$("#payActionCd").focus();
		return false;
	} */
	if($("#sabun").val() == "") {
		alert("대상자를 선택하십시오.");
		return false;
	}
	if($("#payActionCd").val() == "") {
		alert("퇴직일자를 선택하십시오.");
		return false;
	}
	return true;
}

function doAction1(sAction) {
	switch (sAction) {
		case "Search":
			// 필수값/유효성 체크
			if (!chkInVal()) {
				break;
			}

			//$("#sabun").val(parent.$("#tdSabun").val());
			//$("#payActionCd").val(parent.$("#payActionCd").val());

			doAction1("Clear");

			var beforeWorkInfo = ajaxCall("${ctx}/SepEmpRsMgr.do?cmd=getSepEmpRsMgrBeforeWorkMap", $("#sheet1Form").serialize(), false);

			if (beforeWorkInfo.Map != null) {
				beforeWorkInfo = beforeWorkInfo.Map;
				$("#payActionNm").val(beforeWorkInfo.payActionNm);
				$("#regino"		).val(beforeWorkInfo.regino		);
				$("#empYmd"		).val(beforeWorkInfo.empYmd		);
				$("#wkpCnt"		).val(beforeWorkInfo.wkpCnt		);
				$("#sepMon"		).val(beforeWorkInfo.sepMon		);
				$("#sepAddMon1"	).val(beforeWorkInfo.sepAddMon1	);
				$("#itaxMon"	).val(beforeWorkInfo.itaxMon	);
				$("#reginm"		).val(beforeWorkInfo.reginm		);
				$("#retYmd"		).val(beforeWorkInfo.retYmd		);
				$("#overWkpM"	).val(beforeWorkInfo.overWkpM	);
				$("#expWkpM"	).val(beforeWorkInfo.expWkpM	);
				$("#hsepMon"	).val(beforeWorkInfo.hsepMon	);
				$("#sepAddMon2"	).val(beforeWorkInfo.sepAddMon2	);
				$("#rtaxMon"	).val(beforeWorkInfo.rtaxMon	);
			} else if (beforeWorkInfo.Message != null && beforeWorkInfo.Message != "") {
				alert(beforeWorkInfo.Message);
			}
			break;

		case "Clear":
			$("#payActionNm").val("");
			$("#regino"		).val("");
			$("#empYmd"		).val("");
			$("#wkpCnt"		).val("");
			$("#sepMon"		).val("");
			$("#sepAddMon1"	).val("");
			$("#itaxMon"	).val("");
			$("#reginm"		).val("");
			$("#retYmd"		).val("");
			$("#overWkpM"	).val("");
			$("#expWkpM"	).val("");
			$("#hsepMon"	).val("");
			$("#sepAddMon2"	).val("");
			$("#rtaxMon"	).val("");
			break;
	}
}

/* function setEmpPage() {
	if (parent.$("#tdSabun").val() != null && parent.$("#tdSabun").val() != "" && parent.$("#payActionCd").val() != null && parent.$("#payActionCd").val() != "") {
		doAction1("Search");
	}
} */
function setEmpPage() {

	var selectRow = parent.sheetLeft.GetSelectRow();

	if ( selectRow > 0 ){
		var tdSabun = parent.sheetLeft.GetCellValue(selectRow, "sabun");
		var payActionCd = parent.sheetLeft.GetCellValue(selectRow, "payActionCd");

		$("#sabun").val(tdSabun);
		$("#payActionCd").val(payActionCd);

		doAction1("Search");
	}
}
</script>
</head>
<body class="hidden">
<div class="wrapper" id="tableDiv" style="overflow:auto;overflow-x:hidden;border:0px;margin-bottom:0px">
	<form id="sheet1Form" name="sheet1Form" >
	<input type="hidden" id="sabun" name="sabun" value="" />
	<input type="hidden" id="payActionCd" name="payActionCd" value="" />
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<colgroup>
		<col width="49%" />
		<col width="2%" />
		<col width="49%" />
	</colgroup>
		<tr>
			<td class="top">
				<table border="0" cellpadding="0" cellspacing="0" class="default outer">
				<colgroup>
					<col width="45%" />
					<col width="55%" />
				</colgroup>
				<tr>
					<th>급여명</th>
					<td> <input type="text" id="payActionNm" name="payActionNm" value="" readonly class="text readonly" style="width:150px" /> </td>
				</tr>
				<tr>
					<th>사업자등록번호</th>
					<td> <input type="text" id="regino" name="regino" value="" readonly class="text readonly" style="width:120px" /> </td>
				</tr>
				<tr>
					<th>입사일</th>
					<td> <input type="text" id="empYmd" name="empYmd" value="" readonly class="text center readonly" style="width:120px" /> </td>
				</tr>
				<tr>
					<th>근속년/개월/일수</th>
					<td> <input type="text" id="wkpCnt" name="wkpCnt" value="" readonly class="text right readonly" style="width:31px" />
						 / <input type="text" id="wkpMCnt" name="wkpCnt" value="" readonly class="text right readonly" style="width:31px" />
						 / <input type="text" id="wkpDCnt" name="wkpCnt" value="" readonly class="text right readonly" style="width:31px" /> </td>
				</tr>
				<tr>
					<th>퇴직급여</th>
					<td> <input type="text" id="sepMon" name="sepMon" value="" readonly class="text right readonly" style="width:120px" /> </td>
				</tr>
				<tr>
					<th>퇴직수당가급액(50)</th>
					<td> <input type="text" id="sepAddMon1" name="sepAddMon1" value="" readonly class="text right readonly" style="width:120px" /> </td>
				</tr>
				<tr>
					<th>소득세</th>
					<td> <input type="text" id="itaxMon" name="itaxMon" value="" readonly class="text right readonly" style="width:120px" /> </td>
				</tr>
				</table>
			</td>
			<td></td>
			<td class="top">
				<table border="0" cellpadding="0" cellspacing="0" class="default outer">
				<colgroup>
					<col width="50%" />
					<col width="50%" />
				</colgroup>
				<tr>
					<th>회사명</th>
					<td> <input type="text" id="reginm" name="reginm" value="" readonly class="text readonly" style="width:120px" /> </td>
				</tr>
				<tr>
					<th>퇴사일</th>
					<td> <input type="text" id="retYmd" name="retYmd" value="" readonly class="text center readonly" style="width:120px" /> </td>
				</tr>
				<tr>
					<th>중복개월</th>
					<td> <input type="text" id="overWkpM" name="overWkpM" value="" readonly class="text right readonly" style="width:120px" /> </td>
				</tr>
				<tr>
					<th>제외개월</th>
					<td> <input type="text" id="expWkpM" name="expWkpM" value="" readonly class="text right readonly" style="width:120px" /> </td>
				</tr>
				<tr>
					<th>명예퇴직수당</th>
					<td> <input type="text" id="hsepMon" name="hsepMon" value="" readonly class="text right readonly" style="width:120px" /> </td>
				</tr>
				<tr>
					<th>퇴직수당가급액(75)</th>
					<td> <input type="text" id="sepAddMon2" name="sepAddMon2" value="" readonly class="text right readonly" style="width:120px" /> </td>
				</tr>
				<tr>
					<th>주민세</th>
					<td> <input type="text" id="rtaxMon" name="rtaxMon" value="" readonly class="text right readonly" style="width:120px" /> </td>
				</tr>
				</table>
			</td>
		</tr>
	</table>
</div>
</body>
</html>