<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>퇴직기산시작일관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 퇴직기산시작일관리
 * @author JM
-->
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
$(function() {
	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22, FrozenCol:6};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata1.Cols = [
		{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제",			Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
		{Header:"상태",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },
		{Header:"사번",			Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"성명",			Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"계약유형",		Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"manageCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"소속",			Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"직구분",			Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"workType",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"직책",			Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikchakCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"직위",			Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"주민번호",		Type:"Text",		Hidden:1,					Width:120,			Align:"Center",	ColMerge:0,	SaveName:"resNo",		KeyField:0,	Format:"IdNo",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"재직상태",		Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"statusCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"입사일",			Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"empYmd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"그룹입사일",		Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"gempYmd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"퇴직기산시작일",	Type:"Date",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"base1Ymd",	KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 }
	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);

	//------------------------------------- 그리드 콤보 -------------------------------------//
	// 직구분코드(H10050)
	var workType = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10050"), "");
	sheet1.SetColProperty("workType", {ComboText:"|"+workType[0], ComboCode:"|"+workType[1]});

	// 직책코드(H20020)
	var jikchakCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20020"), "");
	sheet1.SetColProperty("jikchakCd", {ComboText:"|"+jikchakCd[0], ComboCode:"|"+jikchakCd[1]});

	// 직위코드(H20030)
	var jikweeCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20030"), "");
	sheet1.SetColProperty("jikweeCd", {ComboText:"|"+jikweeCd[0], ComboCode:"|"+jikweeCd[1]});

	// 계약유형코드(H10030)
	var manageCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10030"), "");
	sheet1.SetColProperty("manageCd", {ComboText:"|"+manageCd[0], ComboCode:"|"+manageCd[1]});

	// 재직상태코드(H10010)
	var statusCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10010"), "");
	sheet1.SetColProperty("statusCd", {ComboText:"|"+statusCd[0], ComboCode:"|"+statusCd[1]});

	//------------------------------------- 조회조건 콤보 -------------------------------------//
	// 계약유형코드(H10030)
	var manageCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10030"), "");
	$("#manageCd").html(manageCd[2]);
	$("#manageCd").select2({placeholder:" 선택"});

	// 재직상태코드(H10010)
	var statusCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10010"), "");
	$("#statusCd").html(statusCd[2]);
	$("#statusCd").select2({placeholder:" 선택"});

	$(window).smartresize(sheetResize);
	sheetInit();

	$("#sabunName").bind("keyup",function(event) {
		if (event.keyCode == 13) {
			doAction1("Search");
		}
	});
	
	//Autocomplete
	$(sheet1).sheetAutocomplete({
		Columns: [
			{
				ColSaveName  : "name",
				CallbackFunc : function(returnValue) {
					var rv = $.parseJSON('{' + returnValue+ '}');
					sheet1.SetCellValue(gPRow,"name", rv["name"]);
					sheet1.SetCellValue(gPRow,"sabun", rv["sabun"]);
					sheet1.SetCellValue(gPRow,"orgNm", rv["orgNm"]);
					sheet1.SetCellValue(gPRow,"workType", rv["workType"]);
					sheet1.SetCellValue(gPRow,"jikchakCd", rv["jikchakCd"]);
					sheet1.SetCellValue(gPRow,"jikweeCd", rv["jikweeCd"]);
					sheet1.SetCellValue(gPRow,"manageCd", rv["manageCd"]);
					sheet1.SetCellValue(gPRow,"statusCd", rv["statusCd"]);
					sheet1.SetCellValue(gPRow,"empYmd", rv["empYmd"]);
					sheet1.SetCellValue(gPRow,"gempYmd", rv["gempYmd"]);
					sheet1.SetCellValue(gPRow,"resNo", rv["resNo"]);
				}
			}
		]
	});
});


function doAction1(sAction) {
	switch (sAction) {
		case "Search":
			$("#multiManageCd").val(getMultiSelect($("#manageCd").val()));
			$("#multiStatusCd").val(getMultiSelect($("#statusCd").val()));

			sheet1.DoSearch("${ctx}/SepBase1YmdMgr.do?cmd=getSepBase1YmdMgrList", $("#sheet1Form").serialize());
			break;

		case "Save":

			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave("${ctx}/SepBase1YmdMgr.do?cmd=saveSepBase1YmdMgr", $("#sheet1Form").serialize());
			break;

		case "Clear":
			sheet1.RemoveAll();
			break;

		case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
			break;
	}
}

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

// 저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}

// 소속 팝입
function orgSearchPopup() {

	let orgLayer = new window.top.document.LayerModal({
		id : 'orgLayer'
		, url : '/Popup.do?cmd=viewOrgBasicLayer&authPg=R'
		, parameters : {
			searchOrgNm : $("#orgNm").val()
		}
		, width : 840
		, height : 800
		, title : '조직 리스트 조회'
		, trigger :[
			{
				name : 'orgTrigger'
				, callback : function(result) {
					if (result && result[0]) {
						$("#orgCd").val(result[0].orgCd);
						$("#orgNm").val(result[0].orgNm);
					} else {
						$("#orgCd").val("");
						$("#orgNm").val("");
					}
				}
			}
		]
	});
	orgLayer.show();
}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form">
		<input type="hidden" id="multiManageCd" name="multiManageCd" value="" />
		<input type="hidden" id="multiStatusCd" name="multiStatusCd" value="" />
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th>소속</th>
						<td>
							<input type="hidden" id="orgCd" name="orgCd" class="text" value="" />
							<input type="text" id="orgNm" name="orgNm" class="text readonly" value="" readonly style="width:120px" />
							<a onclick="javascript:orgSearchPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
							<a onclick="$('#orgCd,#orgNm').val('');" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
						</td>
						<th>계약유형</th>
						<td>
							<select id="manageCd" name="manageCd" multiple=""></select>
						</td>
						<th>재직상태</th>
						<td>
							<select id="statusCd" name="statusCd" multiple=""></select>
						</td>
						<th>사번/성명</th>
						<td>
							<input type="text" id="sabunName" name="sabunName" class="text" value="" style="ime-mode:active" />
						</td>
						<td>
							<a href="javascript:doAction1('Search')"	class="button authR">조회</a>
						</td>
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
							<li id="txt" class="txt">퇴직기산시작일관리</li>
							<li class="btn">
								<a href="javascript:doAction1('Save')"			class="btn authA">저장</a>
								<a href="javascript:doAction1('Down2Excel')"	class="btn authR">다운로드</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "kr"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
