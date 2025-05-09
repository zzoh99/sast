<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='113044' mdef='건강보험 고지금액관리'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 건강보험 고지금액관리
 * @author JM
-->
<script type="text/javascript">
$(function() {
	var initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad, Page:22, FrozenCol:6};
	initdata.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",					Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",					Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },
		{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",					Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",					Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='manageCd' mdef='사원구분'/>",				Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"manageCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",					Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='applJobJikgunNmV1' mdef='직군'/>",					Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"workType",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",					Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikchakCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",					Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='accResNoV1' mdef='주민번호'/>",				Type:"Text",		Hidden:0,					Width:120,			Align:"Center",	ColMerge:0,	SaveName:"resNo",		KeyField:0,	Format:"IdNo",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"<sht:txt mid='statusCdV5' mdef='재직상태'/>",				Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"statusCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='empYmd' mdef='입사일'/>",					Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"empYmd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='gempYmd' mdef='그룹입사일'/>",				Type:"Date",		Hidden:1,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"gempYmd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='ym_V869' mdef='고지년월'/>",				Type:"Date",		Hidden:0,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"ym",			KeyField:1,	Format:"Ym",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:7 },
		{Header:"<sht:txt mid='identityNo' mdef='증번호'/>",					Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"identityNo",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:30 },
		{Header:"<sht:txt mid='reason_V567' mdef='감면사유'/>",				Type:"Combo",		Hidden:0,					Width:100,			Align:"Left",	ColMerge:0,	SaveName:"reason",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:2 },
		{Header:"<sht:txt mid='mon1V3' mdef='보수월액'/>",				Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"rewardTotMon",KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='mon1_V633' mdef='건강산출\n보험료'/>",			Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon1",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='reason1' mdef='건강정산사유'/>",				Type:"Combo",		Hidden:0,					Width:100,			Align:"Left",	ColMerge:0,	SaveName:"reason1",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:2 },
		{Header:"<sht:txt mid='sYm_V634' mdef='건강시작월'/>",				Type:"Date",		Hidden:0,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"sYm",			KeyField:0,	Format:"Ym",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:7 },
		{Header:"<sht:txt mid='eYm' mdef='건강종료월'/>",				Type:"Date",		Hidden:0,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"eYm",			KeyField:0,	Format:"Ym",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:7 },
		{Header:"<sht:txt mid='mon2_V636' mdef='건강정산금액'/>",				Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon2",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='mon3_V622' mdef='건강고지금액'/>",				Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon3",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='mon4_V635' mdef='건강연말정산'/>",				Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon4",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='licSYmd' mdef='취득일'/>",					Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"acqYmd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='lossYmd' mdef='상실일'/>",					Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"lossYmd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='mon6_V4137' mdef='요양산출\n보험료'/>",			Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon6",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='reason2' mdef='요양정산\n사유코드'/>",			Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"reason2",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:2 },
		{Header:"<sht:txt mid='sYm2' mdef='요양시작월'/>",				Type:"Date",		Hidden:0,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"sYm2",		KeyField:0,	Format:"Ym",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:7 },
		{Header:"<sht:txt mid='eYm2' mdef='요양종료월'/>",				Type:"Date",		Hidden:0,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"eYm2",		KeyField:0,	Format:"Ym",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:7 },
		{Header:"<sht:txt mid='mon7_V8' mdef='요양정산\n보험료'/>",			Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon7",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='mon8_V7' mdef='요양고지\n보험료'/>",			Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon8",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='mon9_V4' mdef='요양연말정산\n보험료'/>",		Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon9",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='mon11_V3100' mdef='산출보험료계\n(건강+요양)'/>",	Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon11",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='mon12_V4992' mdef='정산보험료계\n(건강+요양)'/>",	Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon12",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='mon13_V1' mdef='고지보험료계\n(건강+요양)'/>",	Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon13",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='mon14_V2' mdef='연말정산보험료계\n(건강+요양)'/>",	Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon14",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='mon5_V639' mdef='건강환급이자'/>",				Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon5",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='mon10_V4143' mdef='요양환급이자'/>",				Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon10",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='mon15' mdef='가입자총납부할\n보험료'/>",		Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon15",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='fileYnV1' mdef='등록여부'/>",				Type:"Combo",		Hidden:0,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"regYn",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:2 },
		{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",					Type:"Text",		Hidden:0,					Width:100,			Align:"Left",	ColMerge:0,	SaveName:"bigo",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:2000 }
	]; IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(0);

	//------------------------------------- 그리드 콤보 -------------------------------------//

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

	// 감면사유코드(H10720)
	var reason = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10720", baseSYmd, baseEYmd), "");
	sheet1.SetColProperty("reason", {ComboText:"|"+reason[0], ComboCode:"|"+reason[1]});

	// 건강정산사유코드(H10730)
	var reason1 = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10730", baseSYmd, baseEYmd), "");
	sheet1.SetColProperty("reason1", {ComboText:"|"+reason1[0], ComboCode:"|"+reason1[1]});

	// 요양정산사유코드(H10720)
	sheet1.SetColProperty("reason2", {ComboText:"|"+reason1[0], ComboCode:"|"+reason1[1]});

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
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			getCommonCodeList();

			$("#multiManageCd").val(getMultiSelect($("#manageCd").val()));
			$("#multiStatusCd").val(getMultiSelect($("#statusCd").val()));

			sheet1.DoSearch("${ctx}/HealthInsEmpMthDataMgr.do?cmd=getHealthInsEmpMthDataMgrList", $("#sheet1Form").serialize());
			break;

		case "Save":
			// 중복체크
			if(!dupChk(sheet1, "ym|sabun", false, true)) {break;}

			sheet1.DoSave("${ctx}/HealthInsEmpMthDataMgr.do?cmd=saveHealthInsEmpMthDataMgr");
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
			sheet1.Down2Excel({ SheetDesign:1, Merge:0, DownRows:"0", DownCols:"3|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36|37|38|39|40"});
			break;
	}
}

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

// 저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") {
			alert(Msg);
		}
		if( Code > -1 ) doAction1("Search");
	} catch (ex) {
		alert("OnSaveEnd Event Error " + ex);
	}
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
						<td> <a href="javascript:doAction('Search')" class="btn dark authR"><tit:txt mid='104081' mdef='조회'/></a> </td>
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
							<li id="txt" class="txt">건강보험 고지금액관리(사번)</li>
							<li class="btn">
								<a href="javascript:doAction('Down2Excel')"		class="btn outline-gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
								<a href="javascript:doAction('DownTemplate')"	class="btn outline-gray authA"><tit:txt mid='113684' mdef='양식다운로드'/></a>
								<a href="javascript:doAction('LoadExcel')"		class="btn outline-gray authA"><tit:txt mid='104242' mdef='업로드'/></a>
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
