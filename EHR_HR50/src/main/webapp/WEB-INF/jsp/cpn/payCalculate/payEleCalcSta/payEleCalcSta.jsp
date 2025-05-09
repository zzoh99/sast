<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='payEleCalcSta' mdef='항목별계산내역'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 항목별계산내역
 * @author JM
-->
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
$(function() {
	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22, MergeSheet:1};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata1.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",	Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",	Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",	Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },
		{Header:"<sht:txt mid='benefitElemNm' mdef='항목명'/>",	Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"elementNm",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",	Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",	Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",	Type:"Text",		Hidden:Number("${aliasHdn}"),					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"alias",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",	Type:"Text",		Hidden:Number("${jgHdn}"),					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",	Type:"Text",		Hidden:Number("${jwHdn}"),					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",	Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",	Type:"Combo",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='basicMon' mdef='금액'/>",	Type:"AutoSum",		Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"resultMon",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);

	//------------------------------------- 그리드 콤보 -------------------------------------//
	// 직급코드(H20010)
	var jikgubCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20010"), "");
	sheet1.SetColProperty("jikgubCd", {ComboText:jikgubCd[0], ComboCode:jikgubCd[1]});

	$(window).smartresize(sheetResize);
	sheetInit();

	$("#sabunName").bind("keyup",function(event) {
		if (event.keyCode == 13) {
			doAction1("Search");
		}
	});

	// 최근급여일자 조회
	getCpnLatestPaymentInfo();
});

// 필수값/유효성 체크
function chkInVal(sAction) {
	if ($("#payActionCd").val() == "") {
		alert("<msg:txt mid='109681' mdef='급여일자를 선택하십시오.'/>");
		$("#payActionNm").focus();
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

			sheet1.DoSearch("${ctx}/PayEleCalcSta.do?cmd=getPayEleCalcStaList", $("#sheet1Form").serialize());
			break;

		case "Clear":
			sheet1.RemoveAll();
			break;

		case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
	}
}

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

// 최근급여일자 조회
function getCpnLatestPaymentInfo() {
	var procNm = "최근급여일자";
	// 급여구분(C00001-00001.급여)
	var paymentInfo = ajaxCall("${ctx}/PayEleCalcSta.do?cmd=getCpnQueryList", "queryId=getCpnLatestPaymentInfoMap&procNm="+procNm+"&runType=00001,", false);

	if (paymentInfo.DATA != null && paymentInfo.DATA != "" && typeof paymentInfo.DATA[0] != "undefined") {
		$("#payActionCd").val(paymentInfo.DATA[0].payActionCd);
		$("#payActionNm").val(paymentInfo.DATA[0].payActionNm);

		if ($("#payActionCd").val() != null && $("#payActionCd").val() != "") {
			doAction1("Search");
		}
	} else if (paymentInfo.Message != null && paymentInfo.Message != "") {
		alert(paymentInfo.Message);
	}
}

// 급여일자 검색 팝입
function payActionSearchPopup() {
	let layerModal = new window.top.document.LayerModal({
		id : 'payDayLayer'
		, url : '/PayDayPopup.do?cmd=viewPayDayLayer&authPg=R'
		, parameters : {
			runType : '00001'
		}
		, width : 900
		, height : 520
		, title : '<tit:txt mid='payDayPop' mdef='급여일자 조회'/>'
		, trigger :[
			{
				name : 'payDayTrigger'
				, callback : function(result){
					$("#payActionCd").val(result.payActionCd);
					$("#payActionNm").val(result.payActionNm);
				}
			}
		]
	});
	layerModal.show();


	// if(!isPopup()) {return;}
	// gPRow = "";
	// pGubun = "payDayPopup";
	//
	// var w		= 840;
	// var h		= 520;
	// var url		= "/PayDayPopup.do?cmd=payDayPopup";
	// var args	= new Array();
	//
	// args["runType"] = "00001"; // 급여구분(C00001-00001.급여)
	//
	// var result = openPopup(url+"&authPg=R", args, w, h);
	/*
	if (result) {
		var payActionCd	= result["payActionCd"];
		var payActionNm	= result["payActionNm"];

		$("#payActionCd").val(payActionCd);
		$("#payActionNm").val(payActionNm);
	}
	*/
}

// 항목 검색 팝입
function elementSearchPopup() {
	let layerModal = new window.top.document.LayerModal({
		id : 'payElementLayer'
		, url : '/PayElementPopup.do?cmd=viewPayElementLayer&authPg=${authPg}'
		, parameters : {}
		, width : 860
		, height : 520
		, title : '<tit:txt mid='payElementPop4' mdef='수당,공제 항목'/>'
		, trigger :[
			{
				name : 'payTrigger'
				, callback : function(result){
					$("#elementCd").val(result.resultElementCd);
					$("#elementNm").val(result.resultElementNm);
				}
			}
		]
	});
	layerModal.show();

	// if(!isPopup()) {return;}
	// gPRow = "";
	// pGubun = "payElementPopup";
	//
	// var w		= 740;
	// var h		= 520;
	// var url		= "/PayElementPopup.do?cmd=payElementPopup";
	// var args	= new Array();
	//
	// var result = openPopup(url+"&authPg=R", args, w, h);
	/*
	if (result) {
		var elementCd	= result["elementCd"];
		var elementNm	= result["elementNm"];

		$("#elementCd").val(elementCd);
		$("#elementNm").val(elementNm);
	}
	*/
}

function getReturnValue(returnValue) {
	var rv = $.parseJSON('{' + returnValue+ '}');

    if(pGubun == "payDayPopup"){
		$("#payActionCd").val(rv["payActionCd"]);
		$("#payActionNm").val(rv["payActionNm"]);
    }else if(pGubun == "payElementPopup"){
		$("#elementCd").val(rv["elementCd"]);
		$("#elementNm").val(rv["elementNm"]);
    }
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
						<th><tit:txt mid='104477' mdef='급여일자'/></th>
						<td>  <input type="hidden" id="payActionCd" name="payActionCd" value="" />
												<input type="text" id="payActionNm" name="payActionNm" class="text required readonly" value="" readOnly style="width:180px;" />
						<a onclick="javascript:payActionSearchPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a> </td>
						<th><tit:txt mid='eleGroupMgr2' mdef='항목명'/></th>
						<td>  <input type="hidden" id="elementCd" name="elementCd" value="" />
														  <input type="text" id="elementNm" name="elementNm" class="text readonly" value="" readonly style="width:150px;" />
						 <a onclick="javascript:elementSearchPopup();return false;" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
						 <a onclick="$('#elementCd,#elementNm').val('');return false;" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a> </td>
					</tr>
					<tr>
						<th><tit:txt mid='104330' mdef='사번/성명'/></th>
						<td>  <input type="text" id="sabunName" name="sabunName" class="text" value="" style="ime-mode:active" /> </td>
						<td> <input id="byReportNmYn" name="byReportNmYn" type="checkbox" checked /><tit:txt mid='113862' mdef='&nbsp;Report명조회 '/> </td>
						<td> <btn:a href="javascript:doAction1('Search')"	css="button authR" mid='110697' mdef="조회"/> </td>
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
							<li id="txt" class="txt"><tit:txt mid='payEleCalcSta' mdef='항목별계산내역'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Down2Excel')"	css="basic authR" mid='110698' mdef="다운로드"/>
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
