<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>퇴직금기본내역 퇴직종합정산</title>
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

	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata1.Cols = [
		{Header:"No",			Type:"${sNoTy}",	Hidden:1,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제",			Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
		{Header:"상태",			Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },
		{Header:"항목명",			Type:"Text",		Hidden:0,	Width:80,			Align:"Center",	ColMerge:0,	SaveName:"elementNm",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },
		{Header:"기준금액",			Type:"Int",			Hidden:0,	Width:80,			Align:"Right",	ColMerge:0,	SaveName:"resultMon",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);

	var initdata2 = {};
	initdata2.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata2.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata2.Cols = [
		{Header:"No",			Type:"${sNoTy}",	Hidden:1,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제",			Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
		{Header:"상태",			Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },
		{Header:"항목명",			Type:"Text",		Hidden:0,	Width:100,			Align:"Center",	ColMerge:0,	SaveName:"elementNm",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },
		{Header:"기준금액",			Type:"Int",			Hidden:0,	Width:100,			Align:"Right",	ColMerge:0,	SaveName:"resultMon",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"항목명",			Type:"Text",		Hidden:0,	Width:100,			Align:"Center",	ColMerge:0,	SaveName:"elementNm2",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },
		{Header:"기준금액",			Type:"Int",			Hidden:0,	Width:100,			Align:"Right",	ColMerge:0,	SaveName:"resultMon2",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
	]; IBS_InitSheet(sheet2, initdata2); sheet2.SetCountPosition(0);

	$(window).smartresize(sheetResize);
	sheetInit();

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

			// 기본정보조회 조회
			var basicInfo = ajaxCall("${ctx}/SepEmpRsMgr.do?cmd=getSepEmpRsMgrBasicMap", $("#sheet1Form").serialize(), false);

			// 지급총액/공제총액/실지급액 display
			if (basicInfo.Map != null) {
				basicInfo = basicInfo.Map;
				$("#sumEarningMon"	).val(basicInfo.sumEarningMon);
				$("#totDedMon"		).val(basicInfo.totDedMon);
				$("#paymentMon"		).val(basicInfo.paymentMon);
			} else if (basicInfo.Message != null && basicInfo.Message != "") {
				alert(basicInfo.Message);
			}

			// 지급내역 조회
			sheet1.DoSearch("${ctx}/SepEmpRsMgr.do?cmd=getSepEmpRsMgrRetireCalcPayList", $("#sheet1Form").serialize());
			break;

		case "Clear":
			sheet1.RemoveAll();
			$("#sumEarningMon"	).val("");
			$("#totDedMon"		).val("");
			$("#paymentMon"		).val("");
			doAction2("Clear");
			break;
	}
}

function doAction2(sAction) {
	switch (sAction) {
		case "Search":
			// 필수값/유효성 체크
			if (!chkInVal()) {
				break;
			}

			//$("#sabun").val(parent.$("#tdSabun").val());
			//$("#payActionCd").val(parent.$("#payActionCd").val());

			// 공제내역 조회
			sheet2.DoSearch("${ctx}/SepEmpRsMgr.do?cmd=getSepEmpRsMgrRetireCalcDeductionList", $("#sheet1Form").serialize());
			break;

		case "Clear":
			sheet2.RemoveAll();
			break;
	}
}

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

// 조회 후 에러 메시지
function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

/* function setEmpPage() {
	if (parent.$("#tdSabun").val() != null && parent.$("#tdSabun").val() != "" && parent.$("#payActionCd").val() != null && parent.$("#payActionCd").val() != "") {
		doAction1("Search");
		doAction2("Search");
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
		doAction2("Search");
	}
}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
	<input type="hidden" id="sabun" name="sabun" value="" />
	<input type="hidden" id="payActionCd" name="payActionCd" value="" />
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<colgroup>
		<col width="30%" />
		<col width="1%" />
		<col width="68%" />
	</colgroup>
		<tr>
			<td class="top">
				<div class="outer">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">지급내역</li>
						</ul>
					</div>
				</div>
				<table border="0" cellpadding="0" cellspacing="0" class="default outer">
				<colgroup>
					<col width="50%" />
					<col width="50%" />
				</colgroup>
				<tr>
					<th class="center">지급총액</th>
					<td class="center"><input type="text" id="sumEarningMon" name="sumEarningMon" value="" readonly class="text readonly right" style="width:100px" /></td>
				</tr>
				</table>
				<script type="text/javascript">createIBSheet("sheet1", "50%", "100%", "kr"); </script>
			</td>
			<td></td>
			<td class="top">
				<div>
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">공제내역</li>
						</ul>
					</div>
				</div>
				<table border="0" cellpadding="0" cellspacing="0" class="default">
				<colgroup>
					<col width="25%" />
					<col width="25%" />
					<col width="25%" />
					<col width="25%" />
				</colgroup>
				<tr>
					<th class="center">공제총액</th>
					<td class="center"><input type="text" id="totDedMon" name="totDedMon" value="" readonly class="text readonly right" style="width:100px" /></td>
					<th class="center">실지급액</th>
					<td class="center"><input type="text" id="paymentMon" name="paymentMon" value="" readonly class="text readonly right" style="width:100px" /></td>
				</tr>
				</table>
				<script type="text/javascript">createIBSheet("sheet2", "50%", "100%", "kr"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>