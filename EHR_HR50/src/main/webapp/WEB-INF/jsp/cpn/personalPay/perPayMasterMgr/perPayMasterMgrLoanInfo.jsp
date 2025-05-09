<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='103992' mdef='급여기본사항 대출현황'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 급여기본사항
 * @author JM
-->
<script type="text/javascript">
$(function() {
	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22, FrozenCol:7};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata1.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },
		{Header:"<sht:txt mid='apApplSeqV2' mdef='신청서순번'/>",	Type:"Text",		Hidden:1,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"applSeq",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='applYmd_V2120' mdef='대출신청일'/>",	Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"applYmd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"대출지급일",	Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"loanYmd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"대출구분코드",	Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"loanCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:200 },
		{Header:"대출구분",		Type:"Text",		Hidden:0,					Width:130,			Align:"Center",	ColMerge:0,	SaveName:"loanNm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:200 },
		{Header:"대출금액",		Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"loanMon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='loanRemain' mdef='미상환금액'/>",	Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"loanRemain",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='cnt_V3187' mdef='상환횟수'/>",		Type:"Int",			Hidden:1,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"cnt",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='mthMon_V4249' mdef='월상환금'/>",		Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mthMon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='expyn' mdef='만료여부'/>",		Type:"Combo",		Hidden:0,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"expyn",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:2 },
		{Header:"<sht:txt mid='expcode' mdef='만료사유'/>",		Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"expcode",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:2 }
	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);

	var initdata2 = {};
	initdata2.Cfg = {SearchMode:smLazyLoad, Page:22, FrozenCol:7};
	initdata2.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata2.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",			Sort:0 },
		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",			Sort:0 },
		{Header:"<sht:txt mid='repayYmd_V3183' mdef='상환일자'/>",		Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"repayYmd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='cnt_V3187' mdef='상환횟수'/>",		Type:"Int",			Hidden:0,					Width:70,			Align:"Right",	ColMerge:0,	SaveName:"repayRepCnt",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='mthMon_V4249' mdef='월상환금'/>",		Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"repayMthMon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='afRepayAmt' mdef='상환후잔액'/>",	Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"repayLoanRemain",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"본인부담이율",	Type:"Text",		Hidden:0,					Width:80,			Align:"Right",	ColMerge:0,	SaveName:"repayPerRate",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
		{Header:"<sht:txt mid='repayPerMon_V2770' mdef='본인부담이자'/>",	Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"repayPerMon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='stdRate' mdef='과표추가이율'/>",	Type:"Text",		Hidden:0,					Width:80,			Align:"Right",	ColMerge:0,	SaveName:"repayStdRate",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
		{Header:"<sht:txt mid='repayStdMon_V1002' mdef='과표추가이자'/>",	Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"repayStdMon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='repayGubun_V3175' mdef='상환방법'/>",		Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"repayGubun",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:2 },
		{Header:"<sht:txt mid='dedYn ' mdef='공제여부'/>",		Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"repayYn",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 }
	]; IBS_InitSheet(sheet2, initdata2); sheet2.SetCountPosition(0);

	//------------------------------------- 그리드 콤보 -------------------------------------//
	// 대부구분(B50630)
	//var loanCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "B50630"), "");
	//sheet1.SetColProperty("loanCd", {ComboText:loanCd[0], ComboCode:loanCd[1]});

	// 대부만료여부(B50610)
	var expyn = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "B50610"), "");
	sheet1.SetColProperty("expyn", {ComboText:expyn[0], ComboCode:expyn[1]});

	// 대부만료사유(B50090)
	var expcode = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "B50090"), "");
	sheet1.SetColProperty("expcode", {ComboText:expcode[0], ComboCode:expcode[1]});

	// 대부상환구분코드(B50050)
	var repayGubun = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "B50050"), "");
	sheet2.SetColProperty("repayGubun", {ComboText:repayGubun[0], ComboCode:repayGubun[1]});

	$(window).smartresize(sheetResize);
	sheetInit();

	if (parent.$("#searchSabunRef").val() != null && parent.$("#searchSabunRef").val() != "") {
		$("#sabun").val(parent.$("#searchSabunRef").val());
		doAction1("Search");
	}
});

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

			$("#sabun").val(parent.$("#searchSabunRef").val());

			// 대출현황 조회
			sheet1.DoSearch("${ctx}/PerPayMasterMgr.do?cmd=getPerPayMasterMgrLoanStateList", $("#sheet1Form").serialize());
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

			// 항목별 상환내역 조회
			sheet2.DoSearch("${ctx}/PerPayMasterMgr.do?cmd=getPerPayMasterMgrRepayList", $("#sheet1Form").serialize());
			break;

		case "Clear":
			sheet2.RemoveAll();
			break;
	}
}

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") {
			alert(Msg);
		} else {
			var rowCnt = sheet1.RowCount();
			if (rowCnt > 0) {
				$("#applSeq").val(sheet1.GetCellValue(1, "applSeq"));
				// 대출현황 조회후 항목별 상환내역 조회
				doAction2("Search");
			}
		}
		sheetResize();
	} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

// 조회 후 에러 메시지
function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	try{
		if (Row > 0) {
			$("#applSeq").val(sheet1.GetCellValue(Row, "applSeq"));
			// 항목별 상환내역 조회
			doAction2("Search");
		}
	}catch(ex) {alert("OnClick Event Error : " + ex);}
}

function setEmpPage() {
	doAction1("Search");
}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form">
	<input type="hidden" id="sabun" name="sabun" value="" />
	<input type="hidden" id="applSeq" name="applSeq" value="" />
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td class="top">
				<div class="outer">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='104099' mdef='대출현황'/></li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "50%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td class="top">
				<div class="outer">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='103993' mdef='항목별 상환내역'/></li>
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
