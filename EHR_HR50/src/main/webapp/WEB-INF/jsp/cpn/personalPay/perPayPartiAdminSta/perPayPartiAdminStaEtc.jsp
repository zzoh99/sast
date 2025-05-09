<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='104289' mdef='근태/기타내역'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 개인별급여세부내역(관리자)
 * @author JM
-->
<script type="text/javascript">
$(function() {
	var initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",	Type:"${sNoTy}",	Hidden:1,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",	Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0},
		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",	Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0},
		{Header:"<sht:txt mid='bizCd' mdef='업무구분'/>",	Type:"Text",		Hidden:0,	Width:100,			Align:"Center",	ColMerge:0,	SaveName:"bizNm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='benefitElemNm' mdef='항목명'/>",	Type:"Text",		Hidden:0,	Width:100,			Align:"Center",	ColMerge:0,	SaveName:"elementNm",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='eleValue' mdef='항목값'/>",	Type:"Text",			Hidden:0,	Width:100,			Align:"Center",	ColMerge:0,	SaveName:"eleValue",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='danwi' mdef='단위'/>",	Type:"Text",			Hidden:0,	Width:100,			Align:"Center",	ColMerge:0,	SaveName:"unit",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='bizCd' mdef='업무구분'/>",	Type:"Text",		Hidden:0,	Width:100,			Align:"Center",	ColMerge:0,	SaveName:"bizNm2",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='benefitElemNm' mdef='항목명'/>",	Type:"Text",		Hidden:0,	Width:100,			Align:"Center",	ColMerge:0,	SaveName:"elementNm2",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='eleValue' mdef='항목값'/>",	Type:"Text",			Hidden:0,	Width:100,			Align:"Center",	ColMerge:0,	SaveName:"eleValue2",		KeyField:0,	Format:"",	PointCount:2,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='danwi' mdef='단위'/>",	Type:"Text",			Hidden:0,	Width:100,			Align:"Center",	ColMerge:0,	SaveName:"unit2",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
	]; IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(0);

	$(window).smartresize(sheetResize);
	sheetInit();

	if (parent != null && parent != "null" &&
		parent.$("#sabun").val() != null && parent.$("#sabun").val() != "null" &&
		parent.$("#payActionCd").val() != null && parent.$("#payActionCd").val() != "null" &&
		parent.$("#sabun").val() != "" && parent.$("#payActionCd").val() != "") {

		$("#sabun").val(parent.$("#searchUserId").val());
		$("#payActionCd").val(parent.$("#payActionCd").val());

		doAction1("Search");
	}
});

function doAction1(sAction) {
	switch (sAction) {
		case "Search":
			$("#sabun"		).val("");
			$("#payActionCd").val("");

			if (parent.$("#sabun").val() != null && parent.$("#sabun").val() != "null" &&
				parent.$("#payActionCd").val() != null && parent.$("#payActionCd").val() != "null" &&
				parent.$("#sabun").val() != "" && parent.$("#payActionCd").val() != "") {
				$("#sabun"		).val(parent.$("#sabun").val());
				$("#payActionCd").val(parent.$("#payActionCd").val());

				sheet1.DoSearch("${ctx}/PerPayPartiTermUSta.do?cmd=getPerPayPartiAdminStaEtcList", $("#sheet1Form").serialize());
			}
			break;
	}
}

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
		<input type="hidden" id="sabun" name="sabun" class="text" value="" />
		<input type="hidden" id="payActionCd" name="payActionCd" value="" />
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="outer">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='104289' mdef='근태/기타내역'/></li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
