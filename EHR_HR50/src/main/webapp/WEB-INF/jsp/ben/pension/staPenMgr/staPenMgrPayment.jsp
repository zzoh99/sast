<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='staPenMgrPayment' mdef='불입내역'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 국민연금기본사항
 * @author JM
-->
<script type="text/javascript">
$(function() {
	var initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad, Page:22, MergeSheet:msHeaderOnly};
	initdata.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata.Cols = [
		{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V1' mdef='삭제|삭제'/>",		Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
		{Header:"<sht:txt mid='sStatus V4' mdef='상태|상태'/>",		Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },
		{Header:"<sht:txt mid='sabunV2' mdef='사번|사번'/>",		Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
		{Header:"<sht:txt mid='paymentYmd' mdef='급여일자|급여일자'/>",	Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"paymentYmd",	KeyField:0,	Format:"Ymd",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"급여명|급여명",	Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"payNm",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='socDeductCd' mdef='공제상태|공제상태'/>",	Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"socDeductCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='gradeV2' mdef='등급|등급'/>",		Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"grade",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"월보험료|월보험료",	Type:"AutoSum",		Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"selfMon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='addSelfMon' mdef='본인부담액|환금/추징'/>",	Type:"AutoSum",		Hidden:1,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"addSelfMon",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='retireMon' mdef='본인부담액|퇴직전환금'/>",	Type:"AutoSum",		Hidden:1,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"retireMon",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='totMon' mdef='본인부담액|합계'/>",		Type:"AutoSum",		Hidden:1,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"totMon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 }
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
	});

	$("#year").val("${curSysYear}");

	if (parent.$("#searchUserId").val() != null && parent.$("#searchUserId").val() != "") {
		doAction1("Search");
	}
});

// 필수값/유효성 체크
function chkInVal(sAction) {
	if(sAction == "Search") {
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
	} else if(sAction == "Insert") {
		if(parent.$("#searchUserId").val() == "") {
			alert("<msg:txt mid='alertSepCalcBasicMgr1' mdef='대상자를 선택하십시오.'/>");
			parent.$("#searchUserId").focus();
			return false;
		}
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

			sheet1.DoSearch("${ctx}/StaPenMgr.do?cmd=getStaPenMgrPaymentList", $("#sheet1Form").serialize());
			break;

		case "Save":
			// 중복체크
			if(!dupChk(sheet1, "sabun|payActionCd", false, true)) {break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave("${ctx}/StaPenMgr.do?cmd=saveStaPenMgrPayment", $("#sheet1Form").serialize());
			break;

		case "Insert":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			$("#sabun").val(parent.$("#searchUserId").val());

			var Row = sheet1.DataInsert(0);
			sheet1.SelectCell(Row, 2);
			break;

		case "Copy":
			sheet1.SelectCell(sheet1.DataCopy(), 2);
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
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='114464' mdef='조회년도'/></th>
						<td>  <input type="text" id="year" name="year" class="text required w70 center" value="" maxlength="4" />
								<input type="hidden" id="sabun" name="sabun" class="text" value="" /> </td>
						<td> <a href="javascript:doAction1('Search')"	class="btn dark authR"><tit:txt mid='104081' mdef='조회'/></a> </td>
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
