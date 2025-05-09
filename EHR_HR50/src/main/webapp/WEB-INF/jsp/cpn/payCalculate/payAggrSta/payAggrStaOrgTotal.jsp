<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='payAggrStaOrgTotal' mdef='소속집계'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 급여집계(직급/소속별)
 * @author JM
-->
<script type="text/javascript">
$(function() {
	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata1.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",	Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",	Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",			Sort:0 },
		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",	Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",			Sort:0 },
		{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",	Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"orgNm",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='sawonCnt' mdef='대상자수'/>",	Type:"Int",			Hidden:0,					Width:80,			Align:"Right",	ColMerge:0,	SaveName:"sawonCnt",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='element13' mdef='지급총액'/>",	Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"totEarningMon",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='element15' mdef='공제총액'/>",	Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"totDedMon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='element16' mdef='실지급액'/>",	Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"paymentMon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);

	$(window).smartresize(sheetResize);
	sheetInit();

	doAction1("Search");
});

function doAction1(sAction) {
	switch (sAction) {
		case "Search":
			if (parent.$("#payActionCd").val() != null && parent.$("#payActionCd").val() != "") {
				$("#payActionCd").val(parent.$("#payActionCd").val());
				if (parent.$("#businessPlaceCd").val() != null && parent.$("#businessPlaceCd").val() != "") {
					$("#businessPlaceCd").val(parent.$("#businessPlaceCd").val());
				}

				sheet1.DoSearch("${ctx}/PayAggrSta.do?cmd=getPayAggrStaOrgTotalList", $("#sheet1Form").serialize());
			}
			break;

		case "Clear":
			sheet1.RemoveAll();
			break;

		case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
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
	<form id="sheet1Form" name="sheet1Form">
		<input type="hidden" id="payActionCd" name="payActionCd" value="" />
		<input type="hidden" id="businessPlaceCd" name="businessPlaceCd" value="" />
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="outer">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='payAggrStaOrgTotal' mdef='소속집계'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Down2Excel')"	css="btn outline-gray authR" mid='110698' mdef="다운로드"/>
							</li>
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
