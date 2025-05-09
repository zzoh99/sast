<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<style>
	#tabs .tabContent.active {
		display: flex;
		flex-direction: column;
		flex-grow: 1;
	}

	#tabs .tabContent {
		display: none;
		flex-direction: column;
		margin-left: 0;
	}
</style>
<script type="text/javascript">
var doAction = {};
var commonCodes = {};
$(function() {
	init();
});

/**
 * 화면 initialize
 * @returns {Promise<void>}
 */
async function init() {
	await initSearchCondition();
	initTab();
}

/**
 * 검색조건 initialize
 * @returns {Promise<void>}
 */
async function initSearchCondition() {
	//기초 데이터 세팅
	$("#searchYm").datepicker2({ymonly:true});
	$("#searchYm").val("${curSysYyyyMMHyphen}");

	await setBusinessPlaceCdCombo();
	await setLocationCombo();
	await setPayTypeCodes();

	$("#searchText, #searchOrgText, #searchYm").bind("keyup", function(event) {
		if ( event.keyCode == 13 ) {
			excuteFunction("Search");
			$(this).focus();
		}
	});
}

async function setBusinessPlaceCdCombo() {
	const data = await callFetch("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getBusinessPlaceCdList");
	if (data == null || data.isError) {
		if (data && data.errMsg) alert(data.errMsg);
		else alert("알 수 없는 오류가 발생하였습니다.");
		$("#searchBusinessPlaceCd").html("");
		return;
	}

	const codeList = data.codeList;
	const defOptNm = ("${ssnSearchType}" !== "A") ? "" : "전체";
	const businessPlaceCdList = convCode(codeList, defOptNm);
	commonCodes["businessPlaceCd"] = businessPlaceCdList;
	$("#searchBusinessPlaceCd").html(businessPlaceCdList[2]);
}

async function setLocationCombo() {
	const data = await callFetch("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getLocationCdListAuth");
	if (data == null || data.isError) {
		if (data && data.errMsg) alert(data.errMsg);
		else alert("알 수 없는 오류가 발생하였습니다.");
		$("#searchLocationCd").html("");
		return;
	}

	const codeList = data.codeList;
	const defOptNm = ("${ssnSearchType}" !== "A") ? "" : "전체";
	const locationCdList = convCode(codeList, defOptNm);
	commonCodes["locationCd"] = locationCdList;
	$("#searchLocationCd").html(locationCdList[2]);
}

async function setPayTypeCodes() {
	const data = await callFetch("${ctx}/CommonCode.do?cmd=getCommonCodeList", "grpCd=H10110&queryId=H10110");
	if (data == null || data.isError) {
		if (data && data.errMsg) alert(data.errMsg);
		else alert("알 수 없는 오류가 발생하였습니다.");
		return;
	}

	const codeList = data.codeList;
	const defOptNm = ("${ssnSearchType}" !== "A") ? "" : "전체";
	commonCodes["payType"] = convCode(codeList, defOptNm);
}

async function getReportItemCdList() {
	const data = await callFetch("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getWtmReportItemCdMgrCodeList");
	if (data == null || data.isError) {
		if (data && data.errMsg) alert(data.errMsg);
		else alert("알 수 없는 오류가 발생하였습니다.");
		return null;
	}

	return data.codeList;
}

/**
 * 탭 initialize
 */
function initTab() {
	initTabsLine(); //탭 하단 라인 추가

	$("div#tabs ul.tab_bottom li").off("click")
			.on("click", function(e) {
				const idx = $(this).data("id");
				clickTab(idx);
			});

	clickTab(1);
	excuteFunction("init");
}

/**
 * 탭 클릭 이벤트
 * @param idx {string|number} 탭 id
 */
function clickTab(idx) {
	$("div#tabs ul.tab_bottom li.active").removeClass("active");
	$("div#tabs ul.tab_bottom li[data-id=" + idx + "]").addClass("active");

	$("div.tabContent.active").removeClass("active");
	$("div.tabContent#tabs-" + idx).addClass("active");

	excuteFunction("init");
	sheetResize();
}

/**
* multi browsing - use the object reference
* @JSG
*/
function excuteFunction(fName) {
	if (fName === "Search" || fName === "Save") {
		if ($("#searchYm").val() == "") {
			alert("<msg:txt mid='alertYmdCheck' mdef='대상년월을 입력하여 주십시오.'/>");
			return;
		}
	}
	doAction["tab" + getActiveTabId() + "Sheet"][fName]();
}

/**
 * 탭의 ID 조회
 * @returns {*|jQuery}
 */
function getActiveTabId() {
	return $("div#tabs ul.tab_bottom li.active").data("id");
}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="mainForm" name="mainForm">
		<input type="hidden" id="searchSabun" name="searchSabun" value="" />
		<input type="hidden" id="dataAuthority" name="dataAuthority" value="" />
		<div class="sheet_search outer">
			<table>
			<tr>
				<th><tit:txt mid='114444' mdef='대상년월'/></th>
				<td>
					<input id="searchYm" name="searchYm" type="text" class="date2 required"/>
					&nbsp;
				</td>
				<th><tit:txt mid='104279' mdef='소속'/><tit:txt mid='titPerson' mdef='명'/></th>
				<td>
					<input id="searchOrgText" name="searchOrgText" type="text" class="text"/>
					&nbsp;
				</td>
				<th><tit:txt mid='104330' mdef='사번/성명'/></th>
				<td>
					<input id="searchText" name="searchText" type="text" class="text"/>
					&nbsp;
				</td>
				<th><tit:txt mid='104281' mdef='근무지'/></th>
				<td>
					<select id="searchLocationCd" name="searchLocationCd"> </select>
					&nbsp;
				</td>
				<th><tit:txt mid='114399' mdef='사업장'/></th>
				<td>
					<select id="searchBusinessPlaceCd" name="searchBusinessPlaceCd">
					</select>
				</td>
				<td>
					<btn:a href="javascript:excuteFunction('Search');" css="btn dark" mid="search" mdef="조회"/>
				</td>
			</tr>
			</table>
		</div>
		<div class="outer" style="height:16px;"></div>
	</form>

	<div style="position:absolute;width:100%;top:64px;bottom:0;">
		<div id="tabs">
			<ul class="tab_bottom outer">
				<li class="tab_menu active" data-id="1"><a>1. <tit:txt mid='monthWorkDayTab' mdef='월근태일수'/></a></li>
				<li class="tab_menu" data-id="2"><a>2. <tit:txt mid='2017083000997' mdef='월근무시간(근무코드별)'/></a></li>
				<li class="tab_menu" data-id="3"><a>3. <tit:txt mid='monthWorkTimeTab' mdef='월근무시간'/></a></li>
				<li class="tab_menu" data-id="4"><a>4. <tit:txt mid='monthWorkTotalTab' mdef='월근무일수집계'/></a></li>
				<li class="tab_menu" data-id="5"><a>5. 일근무시간(근무코드별)</a></li>
			</ul>
			<div id="tabs-1" class="tabContent active">
				<div class="layout_tabs">
					<%@ include file="wtmMonthlyGntDaysCountTab.jsp" %>
				</div>
			</div>
			<div id="tabs-2" class="tabContent">
				<div class="layout_tabs">
					<%@ include file="wtmMonthlyWorkTimeCountByCodesTab.jsp" %>
				</div>
			</div>
			<div id="tabs-3" class="tabContent">
				<div class="layout_tabs">
					<%@ include file="wtmMonthlyWorkTimeCountTab.jsp" %>
				</div>
			</div>
			<div id="tabs-4" class="tabContent">
				<div class="layout_tabs">
					<%@ include file="wtmMonthlyWorkDaysCountTab.jsp" %>
				</div>
			</div>
			<div id="tabs-5" class="tabContent">
				<div class="layout_tabs">
					<%@ include file="wtmDailyWorkTimeCountByCodesTab.jsp" %>
				</div>
			</div>
		</div>
	</div>

</div>
</body>
</html>