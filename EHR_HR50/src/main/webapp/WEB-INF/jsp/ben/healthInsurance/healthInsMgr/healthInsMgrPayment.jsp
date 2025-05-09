<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='staPenMgrPayment' mdef='불입내역'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 건강보험기본사항
 * @author JM
-->
<script type="text/javascript">
$(function() {
	var initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad, Page:22, MergeSheet:msHeaderOnly};
	initdata.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata.Cols = [
		{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V1' mdef='삭제|삭제'/>",		Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",			Sort:0 },
		{Header:"<sht:txt mid='sStatus V4' mdef='상태|상태'/>",		Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",			Sort:0 },
		{Header:"<sht:txt mid='sabunV2' mdef='사번|사번'/>",		Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
		{Header:"<sht:txt mid='paymentYmd' mdef='급여일자|급여일자'/>",	Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"paymentYmd",		KeyField:1,	Format:"Ymd",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"급여명|급여명",	Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"payNm",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='socDeductCd' mdef='공제상태|공제상태'/>",	Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"socDeductCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='gradeV2' mdef='등급|등급'/>",		Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"grade",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"건강보험료|건강보험료",	Type:"AutoSum",		Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"selfMon",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='addSelfMonV1' mdef='건강보험료|환급/추징'/>",	Type:"AutoSum",		Hidden:1,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"addSelfMon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='mon1V2' mdef='건강보험료|정산금'/>",	Type:"AutoSum",		Hidden:1,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon1",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='mon3V1' mdef='건강보험료|환급이자'/>",	Type:"AutoSum",		Hidden:1,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon3",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='totHealth' mdef='건강보험료|건강계'/>",	Type:"AutoSum",		Hidden:1,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"totHealth",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"요양보험료|요양보험료",	Type:"AutoSum",		Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"selfMon2",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='addSelfMon2' mdef='요양보험료|환급/추징'/>",	Type:"AutoSum",		Hidden:1,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"addSelfMon2",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='mon2V2' mdef='요양보험료|정산금'/>",	Type:"AutoSum",		Hidden:1,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon2",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='mon4V1' mdef='요양보험료|환급이자'/>",	Type:"AutoSum",		Hidden:1,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon4",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='totConval' mdef='요양보험료|건강계'/>",	Type:"AutoSum",		Hidden:1,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"totConval",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='totSelfMon' mdef='총보험료|월보험료'/>",	Type:"AutoSum",		Hidden:1,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"totSelfMon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='totAddSelfMon' mdef='총보험료|환급/추징'/>",	Type:"AutoSum",		Hidden:1,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"totAddSelfMon",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='totAdjust' mdef='총보험료|정산금'/>",		Type:"AutoSum",		Hidden:1,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"totAdjust",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='totRefund' mdef='총보험료|환급이자'/>",	Type:"AutoSum",		Hidden:1,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"totRefund",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"총보험료|총보험료",		Type:"AutoSum",		Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"sumTot",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
	]; IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(0);

	//------------------------------------- 그리드 콤보 -------------------------------------//
	// 급여계산코드(TCPN201)
	var payActionCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "TCPN201"), "");
	sheet1.SetColProperty("payActionCd", {ComboText:"|"+payActionCd[0], ComboCode:"|"+payActionCd[1]});

	// 사회보험공제처리코드(B10210)
	var socDeductCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "B10210"), "");
	sheet1.SetColProperty("socDeductCd", {ComboText:"|"+socDeductCd[0], ComboCode:"|"+socDeductCd[1]});

	$(window).smartresize(sheetResize);
	sheetInit();

	$("#year").bind("keyup",function(event){
		makeNumber(this, 'A');
		if(event.keyCode === 13)
			doAction1("Search");
	});

	$("#year").val("${curSysYear}");

	if (parent.$("#searchUserId").val() != null && parent.$("#searchUserId").val() != "") {
		$("#sabun").val(parent.$("#searchUserId").val());
		doAction1("Search");
	}
});

// 필수값/유효성 체크
function chkInVal(sAction) {
	if(parent.$("#searchUserId").val() == "") {
		alert("<msg:txt mid='alertSepCalcBasicMgr1' mdef='대상자를 선택하십시오.'/>");
		parent.$("#searchUserId").focus();
		return false;
	}
	if($("#year").val() == "") {
		alert("<msg:txt mid='alertBeYearCheckV1' mdef='조회년도를 입력하십시오.'/>");
		$("#year").focus();
		return false;
	}
	var year = $("#year").val();
	if(year.length != 4) {
		alert("<msg:txt mid='alertBeYearCheckV2' mdef='조회년도를 바르게 입력하십시오.'/>");
		$("#year").focus();
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

			sheet1.DoSearch("${ctx}/HealthInsMgr.do?cmd=getHealthInsMgrPaymentList", $("#sheet1Form").serialize());
			break;

		case "Clear":
			sheet1.RemoveAll();
			break;

		case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
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
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form">
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='114464' mdef='조회년도'/></th>
						<td>  <input type="text" id="year" name="year" class="text required w70 center" value="" maxlength="4" />
								<input type="hidden" id="sabun" name="sabun" class="text" value="" /> </td>
						<td> <a href="javascript:doAction1('Search')" class="btn dark authR"><tit:txt mid='104081' mdef='조회'/></a> </td>
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
							<li id="txt" class="txt"><tit:txt mid='staPenMgrPayment' mdef='불입내역'/></li>
							<li class="btn">
								<a href="javascript:doAction1('Down2Excel')"	class="btn outline-gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
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
