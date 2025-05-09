<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='perPayPartiUserSta' mdef='월별급여지급현황'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
	<script src="/assets/js/utility-script.js?ver=7"></script>
<!--
 * 월별급여지급현황
 * @author JM
-->
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
$(function() {
	$(window).smartresize(sheetResize);
	sheetInit();

	//if ($("#searchUserId").val() != null && $("#searchUserId").val() != "null" && $("#searchUserId").val() != "") {
		// 최근급여일자 조회
		searchLatestPaymentInfo();
	//}

	initSheet1();
	initSheet2();
	initSheet3();

	doAction1('Search');

});


function initSheet1() {
	var initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
	initdata.HeaderMode = {Sort:0,ColMove:1,ColResize:1,HeaderCheck:1};
	initdata.Cols = [
		{Header:"<sht:txt mid='reportNm_V5251' mdef='지급내역'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"reportNm",	KeyField:0,	UpdateEdit:0,	InsertEdit:0 },
		{Header:"<sht:txt mid='reportNm_V5251' mdef='지급내역'/>",		Type:"AutoSum",	Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"resultMon",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	Format:"" }

	]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetCountPosition(4); sheet1.SetUnicodeByte(3);
	$(window).smartresize(sheetResize); sheetInit();
}

function initSheet2() {
	var initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
	initdata.HeaderMode = {Sort:0,ColMove:1,ColResize:1,HeaderCheck:1};
	initdata.Cols = [
		{Header:"<sht:txt mid='reportNm_V3346' mdef='세금내역'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"reportNm",	KeyField:0,	UpdateEdit:0,	InsertEdit:0 },
		{Header:"<sht:txt mid='reportNm_V3346' mdef='세금내역'/>",		Type:"AutoSum",	Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"resultMon",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	Format:"" }

	]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetCountPosition(4); sheet2.SetUnicodeByte(3);
	sheet2.SetHeaderBackColor("#FFC31E");
	$(window).smartresize(sheetResize); sheetInit();
}

function initSheet3() {
	var initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
	initdata.HeaderMode = {Sort:0,ColMove:1,ColResize:1,HeaderCheck:1};
	initdata.Cols = [
		{Header:"<sht:txt mid='reportNm_V920' mdef='공제내역'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"reportNm",	KeyField:0,	UpdateEdit:0,	InsertEdit:0 },
		{Header:"<sht:txt mid='reportNm_V920' mdef='공제내역'/>",		Type:"AutoSum",	Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"resultMon",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	Format:"" }

	]; IBS_InitSheet(sheet3, initdata);sheet3.SetEditable("${editable}");sheet3.SetCountPosition(4); sheet3.SetUnicodeByte(3);
	sheet3.SetHeaderBackColor("#FF8C8C");

	$(window).smartresize(sheetResize); sheetInit();
	sheet3.FitColWidth();
}


// 필수값/유효성 체크
function chkInVal() {
	/*if ($("#searchUserId").val() == null || $("#searchUserId").val() == "null" || $("#searchUserId").val() == "") {
		alert("<msg:txt mid='alertSepCalcBasicMgr1' mdef='대상자를 선택하십시오.'/>");
		$("#tdSabun").focus();
		return false;
	}*/
	if ($("#payActionCd").val() == null || $("#payActionCd").val() == "null" || $("#payActionCd").val() == "") {
		alert("<msg:txt mid='109681' mdef='급여일자를 선택하십시오.'/>");
		$("#payActionCd").focus();
		return false;
	}

	return true;
}

function doAction1(sAction) {
	switch (sAction) {
		case "Search":

			// 필수값/유효성 체크
			if (!chkInVal()) {
				break;
			}

			//$("#sabun").val($("#searchUserId").val());

			searchPerPayPartiUserSta1TaxMap();

			sheet1.DoSearch( "${ctx}/PerPayPartiUserSta1.do?cmd=getPerPayPartiUserSta1List1", $("#sheet1Form").serialize() );
			sheet2.DoSearch( "${ctx}/PerPayPartiUserSta1.do?cmd=getPerPayPartiUserSta1List2", "searchListFlag=TAX&operator=IN&"+$("#sheet1Form").serialize() );
			sheet3.DoSearch( "${ctx}/PerPayPartiUserSta1.do?cmd=getPerPayPartiUserSta1List2", "searchListFlag=DEDUCT&operator=NOT IN&"+$("#sheet1Form").serialize() );
			sheet3.FitColWidth();

			break;
	}
}

// 최근급여일자 조회
function searchLatestPaymentInfo() {

	var paymentInfo = ajaxCall("${ctx}/PerPayPartiUserSta.do?cmd=getLatestPaymentInfoMap", $("#sheet1Form").serialize(), false);

	if(paymentInfo.Map != null) {
		paymentInfo = paymentInfo.Map;

		$("#payActionCd").val(paymentInfo.payActionCd);
		$("#payActionNm").val(paymentInfo.payActionNm);
	}
}


//지급총액/공제총액/실지급액
function searchPerPayPartiUserSta1TaxMap() {

	var payInfoMap = ajaxCall("${ctx}/PerPayPartiUserSta1.do?cmd=getPerPayPartiUserSta1TaxMap", $("#sheet1Form").serialize(), false);

	if(payInfoMap.Map != null) {
		payInfoMap = payInfoMap.Map;
		try{
			$("#tdTotEarningMon"	).html(payInfoMap.totEarningMon);
			$("#tdPaymentMon"		).html(payInfoMap.paymentMon);
			$("#tdTotDedMon"		).html(payInfoMap.totDedMon);

			$("#bigo"					).val(payInfoMap.bigo);
			$("#rk").val(payInfoMap.rk);
		} catch(e){
		}
	}
}


// 급여일자 검색 팝입
function payActionSearchPopup() {

	let layerModal = new window.top.document.LayerModal({
		id : 'payDayLayer'
		, url : '/PayDayPopup.do?cmd=viewPayDayLayer&authPg=R'
		, parameters : {
			searchSabun : $("#sabun").val()
			, searchType : 'B' // 월별급여지급현황용 쿼리호출
		}
		, width : 840
		, height : 520
		, title : '<tit:txt mid='payDayPop' mdef='급여일자 조회'/>'
		, trigger :[
			{
				name : 'payDayTrigger'
				, callback : function(result){
					$("#payActionCd").val(result.payActionCd);
					$("#payActionNm").val(result.payActionNm);
					doAction1("Search");
					pGubun = "";
				}
			}
		]
	});
	layerModal.show();
}

// 급여명세서 팝업
function previewPopup() {
	if (!chkInVal()) return;

	let layerModal = new window.top.document.LayerModal({
		id : 'payPartiLayer'
		, url : '/PerPayPartiUserSta.do?cmd=viewPerPayPartiLayer&authPg=R'
		, parameters : {
			sabun : $("#sabun").val()
			, payActionCd : $("#payActionCd").val()
		}
		, width : 680
		, height : 700
		, title : '<tit:txt mid='perPayPartiPopSta' mdef='급여명세서'/>'
	});
	layerModal.show();
}

function setEmpPage() {
	//$("#sabun").val($("#searchUserId").val());
	searchLatestPaymentInfo();
	if ($("#payActionCd").val() != "") {
		doAction1("Search");
	}
}

function print() {

	let rkList = [];
	rkList[0] = $("input#rk").val();

	const data = {
		rk : rkList
	};

	window.top.showRdLayer('/PerPayPartiUserSta1.do?cmd=getEncryptRd', data);

}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">


	<form id="sheet1Form" name="sheet1Form">
		<input type="hidden" id="rk" name="rk"/>
		<div class="outer">
			<div class="sheet_search sheet_search_s">
				<ul>
					<li id="txt" class="txt"><tit:txt mid='114601' mdef='개인별급여내역'/></li>
				</ul>
			</div>
		</div>

		<div class="sheet_search outer">
			<div>
				<div class="inner">
					<div class="sheet_title">

								<table>
									<tr>
										<th class="hide"><tit:txt mid='104470' mdef='사번 '/></th>
										<td class="hide">  <input type="hidden" id="sabun" name="sabun" value="${ssnSabun}" /></td>
										<th><tit:txt mid='104450' mdef='성명 '/></th>
										<td>  <input type="text" id="searchName" name="searchName" class="text w100 readonly" readonly value="${ssnName}" /></td>
										<th><tit:txt mid='104477' mdef='급여일자'/></th>
										<td>
											<input type="hidden" id="payActionCd" name="payActionCd" value="" />
											<input type="text" id="payActionNm" name="payActionNm" class="text required readonly" value="" readonly style="width:180px" />
										 <a onclick="javascript:payActionSearchPopup();" class="ico-btn"><img src="/common/${theme}/images/btn_search2.gif"/></a> </td>
										<td class="text-right">
											<a href="javascript:doAction1('Search')" class="button authR"><tit:txt mid='104081' mdef='조회'/></a>
											<a href="javascript:print();"	    class="basic authR"><tit:txt mid='112105' mdef='명세서'/></a>
										</td>
									</tr>
								</table>
					</div>
				</div>

			</div>
		</div>
	</form>
	<br>
    <table border="0" cellpadding="0" cellspacing="0" class="default outer">
    <colgroup>
        <col width="15%" />
        <col width="18%" />
        <col width="15%" />
        <col width="18%" />
        <col width="15%" />
        <col width="18%" />
    </colgroup>
    <tr>
        <th><tit:txt mid='103984' mdef='지급총액'/></th>
        <td id="tdTotEarningMon"></td>
        <th><tit:txt mid='112801' mdef='공제금액'/></th>
        <td id="tdTotDedMon"> </td>
        <th><tit:txt mid='104374' mdef='실지급액'/></th>
        <td id="tdPaymentMon"> </td>
    </tr>
	</table>

	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<colgroup>
			<col width="35%" />
			<col width="15px" />
			<col width="30%" />
			<col width="15px" />
			<col width="%" />
		</colgroup>
		<tr>
			<td class="sheet_left">
				<div class="inner">
					<div class="sheet_title">
					<ul>
					</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
			</td>
			<td>
				&nbsp;
			</td>
			<td>
				<div class="inner">
					<div class="sheet_title">
					<ul>
					</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet2", "100%", "100%"); </script>
			</td>
			<td >
				&nbsp;
			</td>
			<td>
				<div class="inner">
					<div class="sheet_title">
					<ul>
					</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet3", "100%", "100%"); </script>
			</td>
		</tr>
		<tr height="10">
    	</tr>
		<tr>
		<td colspan=5>
		    <table border="0" cellpadding="0" cellspacing="0" class="default outer">
		    <colgroup>
		        <col width="10%" />
		        <col width="90%" />
		    </colgroup>
		    <tr>
		        <th><tit:txt mid='103783' mdef='비고'/></th>
		        <td >
		        	<textarea id="bigo" rows="4" cols="" readonly class="readonly w100p"></textarea>
		        </td>
		    </tr>
			</table>
		</td>
		</tr>
	</table>
</div>
</body>
</html>
