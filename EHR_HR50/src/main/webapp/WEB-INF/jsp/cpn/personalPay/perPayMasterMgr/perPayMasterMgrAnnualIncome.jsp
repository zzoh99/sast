<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='104484' mdef='급여기본사항 연봉이력'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 급여기본사항
 * @author JM
-->
<script type="text/javascript">

var titleList = new Array();

$(function() {
	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22, MergeSheet:msHeaderOnly/* , FrozenCol:11 */};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata1.Cols = [
		{Header:"No",	Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제",	Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
		{Header:"상태",	Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },
		{Header:"시작일",	Type:"Date",		Hidden:0,					Width:90,	Align:"Center",	ColMerge:0,	SaveName:"sdate", KeyField:1, 	Format:"Ymd", PointCount:0,	UpdateEdit:0, InsertEdit:0,	EditLen:10},
		{Header:"종료일",	Type:"Date",		Hidden:0,					Width:90,	Align:"Center",	ColMerge:0,	SaveName:"edate", KeyField:0,	Format:"Ymd", PointCount:0,	UpdateEdit:0, InsertEdit:0,	EditLen:10}
	];

	IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);

	$(window).smartresize(sheetResize);
	sheetInit();

	if (parent.$("#searchSabunRef").val() != null && parent.$("#searchSabunRef").val() != "") {
		$("#sabun").val(parent.$("#searchSabunRef").val());
		doAction1("Search");
	}
});

// 필수값/유효성 체크
function chkInVal(sAction) {
	if(parent.$("#searchSabunRef").val() == "") {
		alert("<msg:txt mid='alertSepCalcBasicMgr1' mdef='대상자를 선택하십시오.'/>");
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

			searchTitleList();

			break;

		case "Clear":
			sheet1.RemoveAll();

			break;
	}
}

function searchTitleList() {

	var dataList = ajaxCall("${ctx}/PerPayMasterMgr.do?cmd=getPerPayYearMgrTitleList", $("#sheet1Form").serialize(), false);

	for(var i=0; i < dataList.DATA.length; i++) {
		titleList["headerListCd"] 	   = dataList.DATA[i].elementCd.split("|");
		titleList["headerListCdCamel"] = dataList.DATA[i].elementCdCamel.split("|");
		titleList["headerListNm"] 	   = dataList.DATA[i].elementNm.split("|");
	}

	sheet1.Reset();

	if (dataList != null && dataList.DATA != null) {

		var v = 0;

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad, Page:22/* , FrozenCol:11 */};
		initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};

		initdata1.Cols = [];

		initdata1.Cols[v++] = {Header:"<sht:txt mid='sNo'        mdef='No'/>",	 Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" };
		initdata1.Cols[v++] = {Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",	 Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0, HeaderCheck:1 };
		initdata1.Cols[v++] = {Header:"<sht:txt mid='sStatus'    mdef='상태'/>",	 Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 };
		initdata1.Cols[v++] = {Header:"<sht:txt mid='eduSYmd'    mdef='시작일'/>", Type:"Date",		Hidden:0,	Width:90,			Align:"Center",	ColMerge:0,	SaveName:"sdate", KeyField:1, Format:"Ymd", PointCount:0, UpdateEdit:0,	InsertEdit:0, EditLen:10};
		initdata1.Cols[v++] = {Header:"<sht:txt mid='eYmdV1'     mdef='종료일'/>", Type:"Date",		Hidden:0,	Width:90,			Align:"Center",	ColMerge:0,	SaveName:"edate", KeyField:0, Format:"Ymd",	PointCount:0, UpdateEdit:0,	InsertEdit:0, EditLen:10};

		var columnInfo = "";

		for(var i=0; i<titleList["headerListCd"].length; i++) {
			if(titleList["headerListCd"][i] == "totYearMon" || titleList["headerListCd"][i] == "totMonthMon") {
				initdata1.Cols[v++]  = { Header:titleList["headerListNm"][i],	Type:"AutoSum", Hidden:0,	Width:100, Align:"Right", ColMerge:0, SaveName:"ele"+titleList["headerListCdCamel"][i],	KeyField:0,	Format:"NullInteger", PointCount:0,	UpdateEdit:0, InsertEdit:0,	EditLen:100 };
			} else {
				initdata1.Cols[v++]  = { Header:titleList["headerListNm"][i],	Type:"AutoSum",	Hidden:0,	Width:100, Align:"Right", ColMerge:0, SaveName:"ele"+titleList["headerListCdCamel"][i],	KeyField:0,	Format:"NullInteger", PointCount:0,	UpdateEdit:0, InsertEdit:0, EditLen:100 };
				columnInfo = columnInfo + "'" + titleList["headerListCd"][i] + "' AS " + "ELE_" + titleList["headerListCd"][i]+",";
			}
			//alert("ELE_"+titleList["headerListCd"][i]);
		}

		columnInfo = columnInfo.slice(0,columnInfo.length);

		// $("#columnInfo").val(columnInfo);

		initdata1.Cols[v++]  = { Header:"<sht:txt mid='armyMemo' mdef='비고'/>",	Type:"Text", Hidden:0,	Width:150,	Align:"Left", ColMerge:0, SaveName:"bigo", KeyField:0, Format:"",	PointCount:0, UpdateEdit:0,	InsertEdit:0, EditLen:1000};

		IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(4);

		$("#sabun").val(parent.$("#searchSabunRef").val());

		sheet1.DoSearch("${ctx}/PerPayMasterMgr.do?cmd=getPerPayMasterMgrAnnualIncomeList", $("#sheet1Form").serialize());
	}
}

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

function setEmpPage() {
	doAction1("Search");
}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
	<input type="hidden" id="searchSDate" name="searchSDate" value="${curSysYyyyMMddHyphen}" />
	<input type="hidden" id="sabun" 	  name="sabun" 		 value="" />
<%--	<input type="hidden" id="columnInfo"  name="columnInfo"  value="" />--%>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td class="top">
				<div class="outer">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='perPayMasterMgrAnnualIncome' mdef='연봉이력'/></li>
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
