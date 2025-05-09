<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>급여기본사항 기본사항</title>
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
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata1.Cols = [
		{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제",		Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
		{Header:"상태",		Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },
	  //{Header:"수당명",		Type:"Text",		Hidden:0,					Width:120,			Align:"Center",	ColMerge:0,	SaveName:"elementNm",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
		{Header:"수당명",		Type:"Text",		Hidden:0,					Width:120,			Align:"Center",	ColMerge:0,	SaveName:"reportNm",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
		{Header:"수당금액",		Type:"Int",			Hidden:0,				Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 }
	]; //IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);

	var initdata2 = {};
	initdata2.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata2.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata2.Cols = [
		{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
		{Header:"상태",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },
		{Header:"사번",			Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
		{Header:"계좌구분",		Type:"Combo",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"accountType",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"시작일자",    	Type:"Date",    	Hidden:0,  					Width:80,  			Align:"Center",  ColMerge:0,   SaveName:"sdate",    KeyField:1, Format:"Ymd", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
		{Header:"종료일자",    	Type:"Date",  	    Hidden:0,  					Width:80,  			Align:"Center",  ColMerge:0,   SaveName:"edate",    KeyField:0, Format:"Ymd", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
		{Header:"은행명",			Type:"Combo",		Hidden:0,					Width:120,			Align:"Center",	ColMerge:0,	SaveName:"bankCd",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"계좌번호",		Type:"Text",		Hidden:0,					Width:120,			Align:"Center",	ColMerge:0,	SaveName:"accountNo",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:200 },
		{Header:"예금주",			Type:"Text",		Hidden:0,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"accName",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:50 },
		{Header:"예금주주민번호",	Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"accResNo",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:200 },
		{Header:"계좌상태코드",		Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"accStatusCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 }
	]; IBS_InitSheet(sheet2, initdata2); sheet2.SetCountPosition(0);

	//------------------------------------- 그리드 콤보 -------------------------------------//
	// 계좌구분(C00180)
	var accountType = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "C00180"), "");
	sheet2.SetColProperty("accountType", {ComboText:"|"+accountType[0], ComboCode:"|"+accountType[1]});

	// 은행코드(H30001)
	var bankCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H30001"), "");
	sheet2.SetColProperty("bankCd", {ComboText:"|"+bankCd[0], ComboCode:"|"+bankCd[1]});

	//---------------------------------------------------------------------------------//
	var initdata3 = {};
	initdata3.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata3.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata3.Cols = [
		{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),		Width:"${sNoWdt}",		Align:"Center",		ColMerge:0,		SaveName:"sNo" },
		{Header:"삭제",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),	Width:"${sDelWdt}",		Align:"Center",		ColMerge:0,		SaveName:"sDelete",			Sort:0 },
		{Header:"상태",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}",		Align:"Center",		ColMerge:0,		SaveName:"sStatus",			Sort:0 },
		{Header:"사번",			Type:"Text",		Hidden:1,						Width:50,				Align:"Center",		ColMerge:0,		SaveName:"sabun",			KeyField:1,		Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
		{Header:"시작일자",		Type:"Date",		Hidden:0,						Width:100,				Align:"Center",		ColMerge:0,		SaveName:"sdate",			KeyField:1,		Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"종료일자",		Type:"Date",		Hidden:0,						Width:100,				Align:"Center",		ColMerge:0,		SaveName:"edate",			KeyField:0,		Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"외국인 과세구분",	Type:"Combo",		Hidden:0,						Width:120,				Align:"Center",		ColMerge:0,		SaveName:"foreignYn",		KeyField:0,		Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"국외근로비과세",	Type:"Combo",		Hidden:0,						Width:100,				Align:"Center",		ColMerge:0,		SaveName:"abroadYn",		KeyField:0,		Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"배우자공제",		Type:"Combo",		Hidden:0,						Width:100,				Align:"Center",		ColMerge:0,		SaveName:"spouseYn",		KeyField:0,		Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"부양자(60세이상)",	Type:"Int",			Hidden:0,						Width:100,				Align:"Right",		ColMerge:0,		SaveName:"familyCnt1",		KeyField:0,		Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"부양자(20세이하)",	Type:"Int",			Hidden:0,						Width:100,				Align:"Right",		ColMerge:0,		SaveName:"familyCnt2",		KeyField:0,		Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"자녀수",			Type:"Int",			Hidden:0,						Width:100,				Align:"Right",		ColMerge:0,		SaveName:"addChildCnt",		KeyField:0,		Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
	]; IBS_InitSheet(sheet3, initdata3); sheet3.SetCountPosition(0);

	// 외국인과세유형(C00170)
	var foreignYn = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "C00170"), " ");
	$("#foreignYn").html(foreignYn[2]);

	sheet3.SetColProperty("foreignYn", {ComboText:"|"+foreignYn[0], ComboCode:"|"+foreignYn[1]});

	sheet3.SetColProperty("abroadYn",	{ComboText:"|Y|N", ComboCode:"|Y|N"});
	sheet3.SetColProperty("spouseYn",	{ComboText:"|Y|N", ComboCode:"|Y|N"});


	$(window).smartresize(setSheetHeight);
	sheetInit();
	setTimeout(setSheetHeight, 1200);

	$("#familyCnt1").bind("keyup",function(event) {
		makeNumber(this, 'A');
	});
	$("#familyCnt2").bind("keyup",function(event) {
		makeNumber(this, 'A');
	});

	if (parent.$("#searchSabunRef").val() != null && parent.$("#searchSabunRef").val() != "") {
		$("#sabun").val(parent.$("#searchSabunRef").val());
		setEmpPage();
	}
});

// 필수값/유효성 체크
function chkInVal(sAction) {
	if (parent.$("#searchSabunRef").val() == "") {
		alert("대상자를 선택하십시오.");
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

			$("#sabun").val(parent.$("#searchSabunRef").val());

			var dataList = ajaxCall("${ctx}/PerPayMasterMgr.do?cmd=getPerPayYearMgrTitleList", $("#sheet1Form").serialize(), false);

			if (dataList != null && dataList.DATA != null) {

				for(var i=0; i < dataList.DATA.length; i++) {
					titleList["headerListCd"] = dataList.DATA[i].elementCd.split("|");
					titleList["headerListCdCamel"] = dataList.DATA[i].elementCdCamel.split("|");
					titleList["headerListNm"] = dataList.DATA[i].elementNm.split("|");
					//titleList["headerListNm"] = dataList.DATA[i].reportNm.split("|");
				}

				var columnInfo = "";
				var columnAppend ="";

				var payYearInfoHtml = ""
					+"<colgroup>"
					+"	<col width='10%' />"
					+"	<col width='12%' />"
					+"	<col width='10%' />"
					+"	<col width='12%' />"
					+"	<col width='10%' />"
					+"	<col width='12%' />"
					+"	<col width='10%' />"
					+"	<col width='12%' />"
					+"</colgroup>"
					+"<tr>"
					+"	<th>급여구분</th>"
					+"	<td id='tdPayTypeNm'> </td>"
					+"	<th>직급</th>"
					+"	<td id='tdJikgubNm'> </td>"
					+"	<th>연봉적용시작일</th>"
					+"	<td id='tdYearSdate'> </td>"
					+"	<th>연봉적용종료일</th>"
					+"	<td id='tdYearEdate'> </td>";
				$("#payYearInfo").html(payYearInfoHtml);

				for(var i=0; i<titleList["headerListCd"].length; i++){
					if( i % 4 == 0 ){
						if(i != 0) $("#payYearInfo tbody:last").append(columnAppend);
						$("#payYearInfo tbody:last").append("<tr></tr>");
						columnAppend = "";
					}
					columnAppend = columnAppend + "<th>"+titleList["headerListNm"][i]+"</th><td id='"+"ele"+titleList["headerListCdCamel"][i]+"'></td>";
					if(titleList["headerListCd"][i] == "totYearMon" || titleList["headerListCd"][i] == "totMonthMon"){

					}else{
						columnInfo = columnInfo + "'" + titleList["headerListCd"][i] + "' AS " + "ELE_" + titleList["headerListCd"][i]+",";
					}
				}

				$("#payYearInfo tbody:last").append(columnAppend);

				columnInfo = columnInfo.slice(0,columnInfo.length-1);
				// $("#columnInfo").val(columnInfo);

			}

			// 연봉정보조회
			var annualIncomeInfo = ajaxCall("${ctx}/PerPayMasterMgr.do?cmd=getPerPayMasterMgrAnnualIncomeMap", $("#sheet1Form").serialize(), false);

			$("#payYearInfo td").each(function(){$(this).html("");});

			if (annualIncomeInfo.Map != null) {
				annualIncomeInfo = annualIncomeInfo.Map;

				$("#tdPayTypeNm"		).html(annualIncomeInfo.payTypeNm		);
				$("#tdJikgubNm"		).html(annualIncomeInfo.jikgubNm		);
				$("#tdYearSdate"			).html(annualIncomeInfo.yearSdate			);
				$("#tdYearEdate"			).html(annualIncomeInfo.yearEdate			);
				$.each( annualIncomeInfo, function( key, value ){
					if(key.indexOf('ele') != -1){
						if(value){
							$("#"+key).html(value.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));
						}
					}
				});
			}

			/*
			// 과세정보조회
			var taxInfo = ajaxCall("${ctx}/PerPayMasterMgr.do?cmd=getPerPayMasterMgrTaxInfoMap", $("#sheet1Form").serialize(), false);

			//$("#tdNationalNm"	).html("");
			$("#foreignYn"		).val("");
			$("#abroadYn"		).val("");
			//$("#specialYn"		).val("");
			$("#spouseYn"		).val("");
			$("#familyCnt1"		).val("");
			$("#familyCnt2"		).val("");
			$("#addChildCnt"	).val("");
			$("#tdTotCnt"		).html("");
			//$("#specialSymd"	).val("");
			//$("#specialEymd"	).val("");

			if (taxInfo.Map != null) {
				taxInfo = taxInfo.Map;
				//$("#tdNationalNm"	).html(taxInfo.nationalNm);
				$("#foreignYn"		).val(taxInfo.foreignYn);
				$("#abroadYn"		).val(taxInfo.abroadYn);
				//$("#specialYn"		).val(taxInfo.specialYn);
				$("#spouseYn"		).val(taxInfo.spouseYn);
				$("#familyCnt1"		).val(taxInfo.familyCnt1);
				$("#familyCnt2"		).val(taxInfo.familyCnt2);
				$("#addChildCnt"	).val(taxInfo.addChildCnt);
				$("#tdTotCnt"		).html(taxInfo.totCnt);

			}
			*/

			// 고정수당 조회
			//sheet1.DoSearch("${ctx}/PerPayMasterMgr.do?cmd=getPerPayMasterMgrfixAllowanceList", $("#sheet1Form").serialize());
			break;

		case "Save":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			$("#sabun").val(parent.$("#searchSabunRef").val());

			if (confirm("저장하시겠습니까?")) {

				// 과세정보저장
				var result = ajaxCall("${ctx}/PerPayMasterMgr.do?cmd=savePerPayMasterMgrTaxInfo", $("#sheet1Form").serialize(), false);
				//var result = ajaxCall("${ctx}/PerPayMasterMgr.do?cmd=savePerPayMasterMgrTaxInfo", $("#sheet1Form").serialize(), false);

				if (result != null && result["Result"] != null && result["Result"]["Code"] != null) {
					if (result["Result"]["Message"] != null && result["Result"]["Message"] != "") {
						alert(result["Result"]["Message"]);
					}
				} else {
					alert("저장 오류입니다.");
				}

			}
			break;

		case "Clear":
			sheet1.RemoveAll();
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

			$("#sabun").val(parent.$("#searchSabunRef").val());

			// 계좌정보 조회
			sheet2.DoSearch("${ctx}/PerPayMasterMgr.do?cmd=getPerPayMasterMgrAccountInfoList", $("#sheet1Form").serialize());
			break;

		case "Save":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			$("#sabun").val(parent.$("#searchSabunRef").val());

			// 중복체크
			if (!dupChk(sheet2, "sabun|accountType|sdate", false, true)) {break;}
			IBS_SaveName(document.sheet1Form,sheet2);
			sheet2.DoSave("${ctx}/PerPayMasterMgr.do?cmd=savePerPayMasterMgrAccountInfo", $("#sheet1Form").serialize());
			break;

		case "Insert":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			$("#sabun").val(parent.$("#searchSabunRef").val());

			var Row = sheet2.DataInsert(0);
			sheet2.SetCellValue(Row, "sabun", $("#sabun").val());
			sheet2.SelectCell(Row, 2);
			break;

		case "Clear":
			sheet2.RemoveAll();
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

			$("#sabun").val(parent.$("#searchSabunRef").val());

			// 과세정보조회
			//sheet3.DoSearch("${ctx}/GetDataList.do?cmd=getPerPayMasterMgrTaxInfoList", $("#sheet1Form").serialize());
			sheet3.DoSearch("${ctx}/PerPayMasterMgr.do?cmd=getPerPayMasterMgrTaxInfoList", $("#sheet1Form").serialize());
			break;

		case "Save":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			$("#sabun").val(parent.$("#searchSabunRef").val());

			// 중복체크
			if (!dupChk(sheet3, "sabun|sdate", false, true)) {break;}
			IBS_SaveName(document.sheet1Form,sheet3);
			sheet3.DoSave("${ctx}/PerPayMasterMgr.do?cmd=savePerPayMasterMgrTaxInfo", $("#sheet1Form").serialize());
			break;

		case "Insert":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			$("#sabun").val(parent.$("#searchSabunRef").val());

			var Row = sheet3.DataInsert(0);
			sheet3.SetCellValue(Row, "sabun", $("#sabun").val());
			sheet3.SelectCell(Row, 2);
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
	}
}


// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

//조회 후 에러 메시지
function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

//조회 후 에러 메시지
function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

// 저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") {
			alert(Msg);
		}
		if (Code > 0) {
			doAction1("Search");
		}
	} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}

// 저장 후 메시지
function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") {
			alert(Msg);
		}
		if (Code > 0) {
			doAction2("Search");
		}
	} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}

//저장 후 메시지
function sheet3_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") {
			alert(Msg);
		}
		if (Code > 0) {
			doAction3("Search");
		}
	} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}


function setEmpPage() {
	doAction1("Search");
	doAction2("Search");
	doAction3("Search");
}

/**
 * sheet 들의 높이 지정
 */
function setSheetHeight() {
	sheetResize();

	const wrpH = document.querySelector("div.wrapper").offsetHeight;
	const inoutH = Array.from(document.querySelectorAll(".outer, .inner")).reduce((acc, cur) => acc += cur.offsetHeight, 0);
	const enableSheetH = wrpH - inoutH;
	const sheet3Div = document.querySelector("#DIV_sheet3");
	const sheet3Realheight = sheet3Div.getAttribute("realheight");
	const sheet3Fixed = sheet3Div.getAttribute("fixed");
	let sheet3H;
	if (sheet3Fixed === "true") {
		sheet3H = Math.max(parseFloat(sheet3Realheight.replace("px", "")), 65);
	} else if (sheet3Realheight.indexOf("%") > 0) {
		sheet3H = Math.max(enableSheetH * parseFloat(sheet3Realheight.replace("%", "")) / 100 - 0.2, 65);
	} else {
		sheet3H = Math.max(enableSheetH * 30 / 100 - 0.2, 65);
	}
	sheet3.SetSheetHeight(sheet3H);
	const sheet2H = Math.max(enableSheetH - sheet3H, 65);
	sheet2.SetSheetHeight(sheet2H);
}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="outer">
					<div class="sheet_title">
						<ul>
							<li class="txt">연봉정보</li>
						</ul>
					</div>
				</div>
			</td>
		</tr>
	</table>
	<table id="payYearInfo" name="payYearInfo" border="0" cellpadding="0" cellspacing="0" class="default outer">

	</table>
<%--
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="outer">
					<div class="sheet_title">
						<ul>
							<li class="txt">과세정보</li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Save')"	css="basic authA" mid='save' mdef="저장"/>
							</li>
						</ul>
					</div>
				</div>
			</td>
		</tr>
	</table>
	<form id="sheet1Form" name="sheet1Form">


	<input type="hidden" id="elementCd" name="elementCd" value="" />
	<input type="hidden" id="sStatus" name="sStatus" value="U" />


	<input type="hidden" id="sabun" name="sabun" value="" />

	<!-- error 방지  -->
	<input type="hidden" id="womanYn"		name="womanYn" value="">
	<input type="hidden" id="oldCnt1"		name="oldCnt1" value="">
	<input type="hidden" id="oldCnt2"		name="oldCnt2" value="">
	<input type="hidden" id="handicapCnt"	name="handicapCnt" value="">
	<input type="hidden" id="childCnt"		name="childCnt" value="">
	<input type="hidden" id="specialYn"		name="specialYn" value="">
	<input type="hidden" id="specialSymd"	name="specialSymd" value="">
	<input type="hidden" id="specialEymd"	name="specialEymd" value="">

	<table border="0" cellpadding="0" cellspacing="0" class="default outer">
	<colgroup>
		<col width="10%" />
		<col width="12%" />
		<col width="10%" />
		<col width="12%" />
		<col width="10%" />
		<col width="12%" />
		<col width="10%" />
		<col width="12%" />
	</colgroup>
	<!--
	<tr>
		<th>국적</th>
		<td id="tdNationalNm"> </td>
		<th>조특법적용</th>
		<td> <select id="specialYn" name="specialYn" onchange="setSpecialYmd(this.value);">
				<option value=""></option>
				<option value="Y">Y</option>
				<option value="N">N</option>
			</select> </td>
		<td id="tdSpecialymd" colspan="4"> <input type="text" id="specialSymd" name="specialSymd" class="date2" /> ~ <input type="text" id="specialEymd" name="specialEymd" class="date2" /> </td>
	</tr>
	-->
	<tr>
		<th>외국인 과세구분</th>
		<td> <select id="foreignYn" name="foreignYn"> </select> </td>
		<th>국외근로비과세</th>
		<td> <select id="abroadYn" name="abroadYn">
				<option value=""></option>
				<option value="Y">Y</option>
				<option value="N">N</option>
			</select> </td>
		<th>총부양자수(본인포함)</th>
		<td id="tdTotCnt" colspan="3"> </td>
	</tr>
	<tr>
		<th>배우자공제</th>
		<td> <select id="spouseYn" name="spouseYn">
				<option value=""></option>
				<option value="Y">Y</option>
				<option value="N">N</option>
			</select> </td>
		<th>부양자(60세이상)</th>
		<td> <input type="text" id="familyCnt1" name="familyCnt1" class="text right" value="" maxlength="3" style="width:30px" /> <span style="color:#ef519c"></span></td>
		<th>부양자(20세이하)</th>
		<td> <input type="text" id="familyCnt2" name="familyCnt2" class="text right" value="" maxlength="3" style="width:30px" /> <span style="color:#ef519c"></span></td>
		<th>다자녀수</th>
		<td> <input type="text" id="addChildCnt" name="addChildCnt" class="text right" value="" maxlength="3" style="width:30px" /> </td>
	</tr>
	</table>
	</form>
--%>

	<form id="sheet1Form" name="sheet1Form">
		<input type="hidden" id="sabun" name="sabun" value="" />
<%--		<input type="hidden" id="columnInfo" name="columnInfo" value="" />--%>
	</form>


	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td class="top">
				<div class="sheet_title outer">
					<ul>
						<li class="txt"><tit:txt mid='perPayMasterMgrBasic2' mdef='과세정보'/></li>
						<li class="btn">
							<btn:a href="javascript:doAction3('Insert')"	css="basic authA"	mid='insert'	mdef="입력"/>
							<btn:a href="javascript:doAction3('Save')"		css="basic authA"	mid='save'		mdef="저장"/>
						</li>
					</ul>
				</div>
				<script type="text/javascript">createIBSheet("sheet3", "100%", "30%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
		<tr>
			<td class="top">
				<div>
					<div class="sheet_title outer">
						<ul>
							<li class="txt">계좌정보</li>
							<li class="btn">
								<btn:a href="javascript:doAction2('Insert')"	css="basic authA" mid='insert' mdef="입력"/>
								<a href="javascript:doAction2('Save')"		class="basic authA">저장</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet2", "100%", "50%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>