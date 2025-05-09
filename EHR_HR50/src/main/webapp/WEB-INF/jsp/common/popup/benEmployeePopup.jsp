<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='112355' mdef='임직원조회'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<c:set var="curSysYyyyMMdd"><fmt:formatDate value="${now}" pattern="yyyy-MM-dd" /></c:set>

<script type="text/javascript">
var p = eval("${popUpStatus}");
$(function() {
	var initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",	Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",	Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",	Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },
		{Header:"<sht:txt mid='compayGb' mdef='회사구분'/>",	Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"companyGubun",KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",	Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
		{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",	Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
		{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",	Type:"Text",		Hidden:0,					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",	Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='empYmdV3' mdef='입사일자'/>",	Type:"Date",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"empYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='retYmdV1' mdef='퇴사일자'/>",	Type:"Date",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"retYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 }
	]; IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(4);

	//------------------------------------- 그리드 콤보 -------------------------------------//
	// 회사구분코드(B80010)
	var companyGubun = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "B80010"), "");
	sheet1.SetColProperty("companyGubun", {ComboText:companyGubun[0], ComboCode:companyGubun[1]});

	//------------------------------------- 조회조건 콤보 -------------------------------------//
	// 회사구분코드(B80010)
	var companyGubun = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "B80010"), "<tit:txt mid='103895' mdef='전체'/>");
	$("#companyGubun").html(companyGubun[2]);

	$(window).smartresize(sheetResize);
	sheetInit();

	$("#fromEmpYmd").datepicker2({startdate:"toEmpYmd"});
	$("#toEmpYmd").datepicker2({enddate:"fromEmpYmd"});

	$("#orgNm").bind("keyup", function(event) {
		if(event.keyCode == 13) {
			doAction("Search");
		}
	});
	$("#sabunName").bind("keyup", function(event) {
		if(event.keyCode == 13) {
			doAction("Search");
		}
	});

	$(".close").click(function() {
		p.self.close();
	});
});

function chkInVal() {
	var inputCnt = 0;

	if ($("#fromEmpYmd").val() != "" && $("#toEmpYmd").val() != "") {
		if (!checkFromToDate($("#fromEmpYmd"),$("#toEmpYmd"),"입사일","입사일","YYYYMMDD")) {
			return false;
		}

		inputCnt++;
	}

	if($("#companyGubun").val() != "") inputCnt++;
	if($("#orgNm").val() != "") inputCnt++;
	if($("#sabunName").val() != "")inputCnt++;

	if (inputCnt == 0) {
		alert("<msg:txt mid='alertSearch' mdef='조회조건을 1개이상 입력하십시오.'/>");
		return false;
	}

	return true;
}

function doAction(sAction) {
	switch (sAction) {
		case "Search":
			// 필수값/유효성 체크
			if (!chkInVal()) {
				break;
			}

			sheet1.DoSearch("/BenComPopup.do?cmd=getBenEmployeeComPopupList", $("#sheet1Form").serialize());
			break;
	}
}

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize(); sheet1.FocusAfterProcess = false; } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

function sheet1_OnDblClick(Row, Col) {
	try{
		returnFindData(Row, Col);
	}catch(ex) {alert("OnDblClick Event Error : " + ex);}
}

function returnFindData(Row, Col) {
	if(Row <= 0) {
	  return;
	}

	var returnValue = new Array(5);
	returnValue["sabun"]	= sheet1.GetCellValue(Row, "sabun");
	returnValue["name"]		= sheet1.GetCellValue(Row, "name");

	p.window.returnValue = returnValue;
	p.window.close();
}
</script>
</head>
<body class="hidden bodywrap">
	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li><tit:txt mid='112355' mdef='임직원조회'/></li>
				<li class="close"></li>
			</ul>
		</div>
		<div class="popup_main">
			<form id="sheet1Form" name="sheet1Form">
				<div class="sheet_search outer">
					<div>
					<table>
					<tr>
						<th><tit:txt mid='114102' mdef='회사구분'/></th>
						<td>  <select id="companyGubun" name="companyGubun"> </select> </td>
						<th><tit:txt mid='104279' mdef='소속'/></th>
						<td>  <input type="text" id="orgNm" name="orgNm" class="text" value="" style="ime-mode:active" /> </td>
						<th><tit:txt mid='104330' mdef='사번/성명'/></th>
						<td>  <input type="text" id="sabunName" name="sabunName" class="text" value="" style="ime-mode:active" /> </td>
					</tr>
					<tr>
						<th><tit:txt mid='104564' mdef='입사일자'/></th>
						<td colspan="4">  <input type="text" id="fromEmpYmd" name="fromEmpYmd" class="date2" /> ~ <input type="text" id="toEmpYmd" name="toEmpYmd" class="date2" /> </td>
						<td> <a href="javascript:doAction('Search')"	class="button authR"><tit:txt mid='104081' mdef='조회'/></a> </td>
					</tr>
					</table>
					</div>
				</div>
			</form>
			<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
				<tr>
					<td>
					<div class="inner">
						<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='112355' mdef='임직원조회'/></li>
						</ul>
						</div>
					</div>
					<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
					</td>
				</tr>
			</table>
			<div class="popup_button outer">
				<ul>
					<li>
						<a href="javascript:p.self.close();" class="gray large"><tit:txt mid='104157' mdef='닫기'/></a>
					</li>
				</ul>
			</div>
		</div>
	</div>
</body>
</html>
