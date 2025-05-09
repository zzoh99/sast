<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>퇴직금결과내역 평균임금</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 퇴직금결과내역
 * @author JM
-->
<script type="text/javascript">
$(function() {
	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0, Hidden:1};
	initdata1.Cols = [
		{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제",			Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",			Sort:0 },
		{Header:"상태",			Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",			Sort:0 },
		{Header:"급여계산코드",		Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"payActionCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"급여년월",		Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"subPayYm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"사번",			Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"계산시작일",		Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"calFymd",			KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"계산종료일",		Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"calTymd",			KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"일수",			Type:"Int",			Hidden:0,					Width:60,			Align:"Right",	ColMerge:0,	SaveName:"workDay",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"총금액",			Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon",				KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);

	var initdata2 = {};
	initdata2.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata2.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata2.Cols = [
		{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제",			Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",			Sort:0 },
		{Header:"상태",			Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",			Sort:0 },
		{Header:"급여계산코드",		Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"payActionCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"사번",			Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"지급일자",			Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"paymentYmd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"급여구분",			Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"payCd",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"금액",			Type:"AutoSum",		Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon",				KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
	]; IBS_InitSheet(sheet2, initdata2); sheet2.SetCountPosition(0);

	var initdata3 = {};
	initdata3.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata3.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata3.Cols = [
		{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제",			Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",			Sort:0 },
		{Header:"상태",			Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",			Sort:0 },
		{Header:"서브퇴직급여계산코드",	Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"subPayActionCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"서브퇴직급여계산명",	Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"subPayActionNm",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"사번",			Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"순서",			Type:"Int",			Hidden:1,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"seq",				KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"지급일자",			Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"paymentYmd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"급여구분",			Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"payCd",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"금액",			Type:"AutoSum",		Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon",				KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
	]; IBS_InitSheet(sheet3, initdata3); sheet3.SetCountPosition(0);

	//------------------------------------- 그리드 콤보 -------------------------------------//
	// 급여구분코드(TCPN051)
	var tcpn051Cd = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getCpnPayCdList", false).codeList, "");
	sheet2.SetColProperty("payCd", {ComboText:tcpn051Cd[0], ComboCode:tcpn051Cd[1]});
	sheet3.SetColProperty("payCd", {ComboText:tcpn051Cd[0], ComboCode:tcpn051Cd[1]});

	//$(window).smartresize(sheetResize);
	sheetInit();

	if (parent.$("#searchUserId").val() != null && parent.$("#searchUserId").val() != "" &&
		parent.$("#payActionCd").val() != null && parent.$("#payActionCd").val() != "") {
		$("#sabun").val(parent.$("#searchUserId").val());
		$("#payActionCd").val(parent.$("#payActionCd").val());
		doAction1("Search");
		doAction2("Search");
		doAction3("Search");
	}
});

// 필수값/유효성 체크
function chkInVal(sAction) {
	if(parent.$("#searchUserId").val() == "") {
		parent.$("#searchUserId").focus();
		return false;
	}
	if(parent.$("#payActionCd").val() == "") {
		parent.$("#payActionCd").focus();
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

			$("#sabun").val(parent.$("#searchUserId").val());
			$("#payActionCd").val(parent.$("#payActionCd").val());

			// 항목리스트 조회
			searchTitleList();

			sheet1.DoSearch("${ctx}/SepCalcResultSta.do?cmd=getSepCalcResultStaAverageIncomePayList", $("#sheet1Form").serialize());
			break;

		case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
			break;
	}
}

function doAction2(sAction) {
	switch (sAction) {
		case "Search":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			$("#sabun").val(parent.$("#searchUserId").val());
			$("#payActionCd").val(parent.$("#payActionCd").val());

			// 상여 조회
			sheet2.DoSearch("${ctx}/SepCalcResultSta.do?cmd=getSepCalcResultStaAverageIncomeBonusList", $("#sheet1Form").serialize());
			break;

		case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet2);
			var param  = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet2.Down2Excel(param);
			break;
	}
}

function doAction3(sAction) {
	switch (sAction) {
		case "Search":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			$("#sabun").val(parent.$("#searchUserId").val());
			$("#payActionCd").val(parent.$("#payActionCd").val());

			// 연차 조회
			sheet3.DoSearch("${ctx}/SepCalcResultSta.do?cmd=getSepCalcResultStaAverageIncomeAnnualList", $("#sheet1Form").serialize());
			break;

		case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet3);
			var param  = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet3.Down2Excel(param);
			break;
	}
}

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") {
			alert(Msg);
		}
		sheetResize();
	} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

//조회 후 에러 메시지
function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") {
			alert(Msg);
		}
		//sheetResize();
	} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

//조회 후 에러 메시지
function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") {
			alert(Msg);
		}
		//sheetResize();
	} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

function searchTitleList() {
	// 퇴직금결과내역 평균임금TAB 급여 항목리스트 조회
	var titleList = ajaxCall("${ctx}/SepCalcResultSta.do?cmd=getSepCalcResultStaAverageIncomePayTitleList", $("#sheet1Form").serialize(), false);

	if(titleList != null && titleList.DATA != null) {

		// IBSheet에 설정된 모든 기본 속성을 제거하고 초기상태로 변경한다.
		sheet1.Reset();

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, Page:22};
		initdata.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};

		initdata.Cols = [];
		initdata.Cols[0] = {Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" };
		initdata.Cols[1] = {Header:"삭제",			Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",			Sort:0 };
		initdata.Cols[2] = {Header:"상태",			Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",			Sort:0 };
		initdata.Cols[3] = {Header:"급여계산코드",		Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"payActionCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 };
		initdata.Cols[4] = {Header:"급여년월",			Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"subPayYm",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 };
		initdata.Cols[5] = {Header:"사번",			Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 };
		initdata.Cols[6] = {Header:"계산시작일",			Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"calFymd",			KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 };
		initdata.Cols[7] = {Header:"계산종료일",			Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"calTymd",			KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 };
		initdata.Cols[8] = {Header:"일수",			Type:"Int",			Hidden:0,					Width:60,			Align:"Right",	ColMerge:0,	SaveName:"workDay",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
		initdata.Cols[9] = {Header:"총금액",			Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon",				KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };

		var elementCd = "";
		for(i=0; i<titleList.DATA.length; i++){
			elementCd = convCamel(titleList.DATA[i].elementCd);
			initdata.Cols[i+10] = {Header:titleList.DATA[i].elementNm,	Type:"AutoSum",	Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:""+elementCd+"",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
		}
		IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(0);
	}
}

function setEmpPage() {
	doAction1("Search");
	doAction2("Search");
	doAction3("Search");
}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form">
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
			<td class="top" colspan="3">
				<div class="outer">
					<div class="sheet_title inner">
						<ul>
							<li class="txt">급여</li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Down2Excel')"	css="basic authR" mid='down2excel' mdef="다운로드"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "50%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
		<tr>
			<td class="top">
				<div class="outer">
					<div class="sheet_title">
						<ul>
							<li class="txt">연차</li>
							<li class="btn">
								<btn:a href="javascript:doAction3('Down2Excel')"	css="basic authR" mid='down2excel' mdef="다운로드"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet3", "50%", "50%", "${ssnLocaleCd}"); </script>
			</td>
			<td></td>
			<td class="top">
				<div>
					<div class="sheet_title">
						<ul>
							<li class="txt">상여</li>
							<li class="btn">
								<btn:a href="javascript:doAction2('Down2Excel')"	css="basic authR" mid='down2excel' mdef="다운로드"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet2", "50%", "50%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>