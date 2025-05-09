<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='112409' mdef='국민연금 고지금액관리'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 국민연금 고지금액관리
 * @author JM
-->
<script type="text/javascript">
$(function() {
	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22, FrozenCol:6};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};
	initdata1.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },
		{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",			Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",			Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='manageCd' mdef='사원구분'/>",		Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"manageCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",			Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='applJobJikgunNmV1' mdef='직군'/>",			Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"workType",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",			Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikchakCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",			Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='accResNoV1' mdef='주민번호'/>",		Type:"Text",		Hidden:0,					Width:120,			Align:"Center",	ColMerge:0,	SaveName:"resNo",		KeyField:0,	Format:"IdNo",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"<sht:txt mid='statusCdV5' mdef='재직상태'/>",		Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"statusCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='empYmd' mdef='입사일'/>",			Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"empYmd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='gempYmd' mdef='그룹입사일'/>",		Type:"Date",		Hidden:1,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"gempYmd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='ym_V869' mdef='고지년월'/>",		Type:"Date",		Hidden:0,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"ym",			KeyField:1,	Format:"Ym",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:7 },
		{Header:"<sht:txt mid='mon1' mdef='기준소득월액'/>",		Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon1",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='mon2_V4246' mdef='월보험료'/>",		Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon2",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='mon3_V3022' mdef='사용자부담금'/>",		Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon3",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='mon4_V2753' mdef='본인기여금'/>",		Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon4",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='fileYnV1' mdef='등록여부'/>",		Type:"Combo",		Hidden:0,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"regYn",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:2 },
		{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",			Type:"Text",		Hidden:0,					Width:100,			Align:"Left",	ColMerge:0,	SaveName:"bigo",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:2000 }
	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);

	// 등록여부
	sheet1.SetColProperty("regYn", {ComboText:"|예|아니오", ComboCode:"|Y|N"});
	$(window).smartresize(sheetResize);
	sheetInit();

	$("#sabunName").bind("keyup",function(event){
		if (event.keyCode == 13) {
			doAction("Search");
		}
	});

	$("#ym").datepicker2({ymonly:true, onReturn: getComboList});
	$("#ym").val("${curSysYyyyMMHyphen}");

	getComboList();
});

function getCommonCodeList() {
	let searchYm = $("#ym").val();
	let baseSYmd = "";
	let baseEYmd = "";
	if (searchYm !== "") {
		baseSYmd = searchYm + "-01";
		baseEYmd = getLastDayOfMonth(searchYm);
	}


	//------------------------------------- 그리드 콤보 -------------------------------------//
	// 직군코드(H10050)
	var workType = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10050", baseSYmd, baseEYmd), "");
	sheet1.SetColProperty("workType", {ComboText:"|"+workType[0], ComboCode:"|"+workType[1]});

	// 직책코드(H20020)
	var jikchakCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20020", baseSYmd, baseEYmd), "");
	sheet1.SetColProperty("jikchakCd", {ComboText:"|"+jikchakCd[0], ComboCode:"|"+jikchakCd[1]});

	// 직위코드(H20030)
	var jikweeCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20030", baseSYmd, baseEYmd), "");
	sheet1.SetColProperty("jikweeCd", {ComboText:"|"+jikweeCd[0], ComboCode:"|"+jikweeCd[1]});

	// 사원구분코드(H10030)
	var manageCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10030", baseSYmd, baseEYmd), "");
	sheet1.SetColProperty("manageCd", {ComboText:"|"+manageCd[0], ComboCode:"|"+manageCd[1]});

	// 재직상태코드(H10010)
	var statusCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10010", baseSYmd, baseEYmd), "");
	sheet1.SetColProperty("statusCd", {ComboText:"|"+statusCd[0], ComboCode:"|"+statusCd[1]});
}

function getComboList() {
	let searchYm = $("#ym").val();
	let baseSYmd = "";
	let baseEYmd = "";
	if (searchYm !== "") {
		baseSYmd = searchYm + "-01";
		baseEYmd = getLastDayOfMonth(searchYm);
	}

	//------------------------------------- 조회조건 콤보 -------------------------------------//
	// 사원구분코드(H10030)
	var manageCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10030", baseSYmd, baseEYmd), "");
	$("#manageCd").html(manageCd[2]);
	$("#manageCd").select2({placeholder:" 선택"});

	// 재직상태코드(H10010)
	var statusCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10010", baseSYmd, baseEYmd), "");
	$("#statusCd").html(statusCd[2]);
	$("#statusCd").select2({placeholder:" 선택"});
}

function getLastDayOfMonth(yearMonth) {
	const [year, month] = yearMonth.split('-').map(Number);
	const lastDate = new Date(year, month, 0);

	const yearStr = lastDate.getFullYear().toString();
	const monthStr = (lastDate.getMonth() + 1).toString().padStart(2, '0');
	const dayStr = lastDate.getDate().toString().padStart(2, '0');

	return yearStr + '-' + monthStr + '-' + dayStr;
}

function chkInVal(sAction) {
	if($("#ym").val() == "") {
		alert("<msg:txt mid='109327' mdef='대상년월을 입력하십시오.'/>");
		$("#ym").focus();
		return false;
	}

	return true;
}

function doAction(sAction) {
	switch (sAction) {
		case "Search":
			getCommonCodeList();
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			$("#multiManageCd").val(getMultiSelect($("#manageCd").val()));
			$("#multiStatusCd").val(getMultiSelect($("#statusCd").val()));

			sheet1.DoSearch("${ctx}/StaPenEmpMthDataMgr.do?cmd=getStaPenEmpMthDataMgrList", $("#sheet1Form").serialize());
			break;

		case "Save":
			// 중복체크
			if(!dupChk(sheet1, "ym|sabun", false, true)) {break;}

			sheet1.DoSave("${ctx}/StaPenEmpMthDataMgr.do?cmd=saveStaPenEmpMthDataMgr");
			break;

		case "Clear":
			sheet1.RemoveAll();
			break;

		case "LoadExcel":
			// 업로드
			var params = {};
			sheet1.LoadExcel(params);
			break;

		case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
			break;

		case "DownTemplate":
			// 양식다운로드
			sheet1.Down2Excel({ SheetDesign:1, Merge:0, DownRows:"0", DownCols:"3|14|15|16|17|18"});
			break;

		case "DeleteAll":
			//전체삭제
			if (!confirm($("#ym").val() + " 대상년월 전체삭제 하시겠습니까?") ) return;
			var data = ajaxCall("${ctx}/StaPenEmpMthDataMgr.do?cmd=deleteStaPenEmpMthDataMgrAll",$("#sheet1Form").serialize(),false);
			alert(data.Result.Message);
			doAction("Search");
			break;
	}
}

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

// 저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } doAction("Search"); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
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
						<th><tit:txt mid='114444' mdef='대상년월'/></th>
						<td>  <input type="text" id="ym" name="ym" class="date2 required" /> </td>
						<th><tit:txt mid='103784' mdef='사원구분'/></th>
						<td>  <select id="manageCd" name="manageCd" multiple=""> </select> </td>
						<th><tit:txt mid='104472' mdef='재직상태'/></th>
						<td>  <select id="statusCd" name="statusCd" multiple=""> </select> </td>
						<th><tit:txt mid='104330' mdef='사번/성명'/></th>
						<td>  <input type="text" id="sabunName" name="sabunName" class="text" value="" style="ime-mode:active" /> </td>
						<td> <a href="javascript:doAction('Search')"	class="btn dark authR"><tit:txt mid='104081' mdef='조회'/></a> </td>
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
							<li id="txt" class="txt">국민연금 고지금액관리(사번)</li>
							<li class="btn">
								<a href="javascript:doAction('Down2Excel')"		class="btn outline-gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
								<a href="javascript:doAction('DownTemplate')"	class="btn outline-gray authA"><tit:txt mid='113684' mdef='양식다운로드'/></a>
								<a href="javascript:doAction('LoadExcel')"		class="btn outline-gray authA"><tit:txt mid='104242' mdef='업로드'/></a>
							    <a href="javascript:doAction('DeleteAll')"	    class="btn filled authA"><tit:txt mid='113930' mdef='전체삭제'/></a>
								<a href="javascript:doAction('Save')"			class="btn filled authA"><tit:txt mid='104476' mdef='저장'/></a>
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
