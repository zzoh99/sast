<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='sepTaxDefMgr' mdef='과세이연기초'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 과세이연기초
 * @author JM
-->
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
$(function() {
	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22, MergeSheet:msHeaderOnly};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};
	initdata1.Cols = [
		{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",							Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V1' mdef='삭제|삭제'/>",					Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",			Sort:0 },
		{Header:"<sht:txt mid='sStatus V4' mdef='상태|상태'/>",					Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",			Sort:0 },
		{Header:"<sht:txt mid='payActionCdV3' mdef='급여계산코드|급여계산코드'/>",		Type:"Text",		Hidden:1,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"payActionCd",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='payActionNmV4' mdef='퇴직금일자|퇴직금일자'/>",		Type:"Text",		Hidden:0,					Width:120,			Align:"Center",	ColMerge:0,	SaveName:"payActionNm",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },
		{Header:"<sht:txt mid='sabunV2' mdef='사번|사번'/>",						Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"<sht:txt mid='nameV3' mdef='성명|성명'/>",						Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='appOrgNmV6' mdef='소속|소속'/>",					Type:"Text",		Hidden:0,					Width:90,			Align:"Left",	ColMerge:0,	SaveName:"orgNm",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='jikweeCdV1' mdef='직위|직위'/>",					Type:"Combo",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='2017082500567' mdef='호칭|호칭'/>",					Type:"Text",		Hidden:1,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"alias",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='jikgubCdV1' mdef='직급|직급'/>",					Type:"Text",		Hidden:1,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='curDeferMon' mdef='과세이연금액(현)|법정'/>",			Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"curDeferMon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='hCurDeferMon' mdef='과세이연금액(현)|법정외'/>",		Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"hCurDeferMon",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='preDeferMon' mdef='과세이연금액(전)|법정'/>",			Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"preDeferMon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='hPreDeferMon' mdef='과세이연금액(전)|법정외'/>",		Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"hPreDeferMon",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='deferYmd' mdef='이체일|이체일'/>",					Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"deferYmd",		KeyField:1,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='bankAccount' mdef='계좌번호|계좌번호'/>",				Type:"Text",		Hidden:0,					Width:130,			Align:"Center",	ColMerge:0,	SaveName:"bankAccount",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:200 },
		{Header:"<sht:txt mid='bankNm' mdef='퇴직연금|사업자명'/>",					Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"bankNm",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='bankEnterNo' mdef='퇴직연금|사업자등록번호'/>",			Type:"Text",		Hidden:0,					Width:110,			Align:"Center",	ColMerge:0,	SaveName:"bankEnterNo",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:200 },
		
		{Header:"<sht:txt mid='etc1' mdef='기타1|기타1'/>",						Type:"Int",			Hidden:1,					Width:90,			Align:"Right",	ColMerge:0,	SaveName:"etc1",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='etc2' mdef='기타2|기타2'/>",						Type:"Int",			Hidden:1,					Width:90,			Align:"Right",	ColMerge:0,	SaveName:"etc2",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='etc3' mdef='기타3|기타3'/>",						Type:"Int",			Hidden:1,					Width:90,			Align:"Right",	ColMerge:0,	SaveName:"etc3",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='etc4' mdef='기타4|기타4'/>",						Type:"Int",			Hidden:1,					Width:90,			Align:"Right",	ColMerge:0,	SaveName:"etc4",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='etc5' mdef='기타5|기타5'/>",						Type:"Int",			Hidden:1,					Width:90,			Align:"Right",	ColMerge:0,	SaveName:"etc5",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='endYmdV1' mdef='만기일|만기일'/>",					Type:"Date",		Hidden:1,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"endYmd",			KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='calDeferTaxMon' mdef='과세이연 세액|과세이연세액'/>",	Type:"Int",			Hidden:1,					Width:90,			Align:"Right",	ColMerge:0,	SaveName:"calDeferTaxMon",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='bankEnterNo' mdef='seq|seq'/>",					Type:"Text",		Hidden:1,					Width:110,			Align:"Center",	ColMerge:0,	SaveName:"seq",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:200 }
	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);
												
	var searchJikweeCd  = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20030"), "전체"); //직위
	
	sheet1.SetColProperty("jikweeCd",	{ComboText:"|"+searchJikweeCd[0], ComboCode:"|"+searchJikweeCd[1]} );
	
	$(window).smartresize(sheetResize);
	sheetInit();
	
	// 성명 검색시 자동완성
	$(sheet1).sheetAutocomplete({
		Columns: [
			{
				ColSaveName  : "name",
				CallbackFunc : function(returnValue){
					var rv = $.parseJSON('{' + returnValue+ '}');
					sheet1.SetCellValue(gPRow, "sabun",		rv["sabun"]);
					sheet1.SetCellValue(gPRow, "name",		rv["name"]);
					sheet1.SetCellValue(gPRow, "orgNm",		rv["orgNm"]);
					sheet1.SetCellValue(gPRow, "jikweeCd",	rv["jikweeCd"]);
					sheet1.SetCellValue(gPRow, "jikweeNm",	rv["jikweeNm"]);
				}
			}
		]
	});		

	$("#sabunName").bind("keyup",function(event){
		if (event.keyCode == 13) {
			doAction1("Search");
		}
	});

	// 최근급여일자 조회
	getCpnLatestPaymentInfo();
});

// 필수값/유효성 체크
function chkInVal(sAction) {
	if($("#payActionCd").val() == "") {
		alert("<msg:txt mid='alertPayActionCd' mdef='퇴직금일자를 선택하십시오.'/>");
		$("#payActionCd").focus();
		return false;
	}
	return true;
}

function doAction1(sAction) {
	switch (sAction) {
		case "Search":
			// 필수값/유효성 체크
			if(!checkList()) return ;
			sheet1.DoSearch("${ctx}/SepTaxDefMgr.do?cmd=getSepTaxDefMgrList", $("#sheet1Form").serialize());
			break;

		case "Save":
			// 중복체크
			if(!dupChk(sheet1, "payActionCd|sabun", false, true)) {break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave("${ctx}/SepTaxDefMgr.do?cmd=saveSepTaxDefMgr", $("#sheet1Form").serialize());
			break;

		case "Insert":
			// 필수값/유효성 체크
			if(!checkList()) return ;
			var Row = sheet1.DataInsert(0);
			sheet1.SetCellValue(Row, "payActionCd", $("#payActionCd").val());
			sheet1.SetCellValue(Row, "payActionNm", $("#payActionNm").val());
			sheet1.SelectCell(Row, 2);
			break;

		case "Copy":
			var Row = sheet1.DataCopy();
			sheet1.SelectCell(Row, 2);
			sheet1.SetCellValue(Row, "seq", "");
			break;

		case "Clear":
			sheet1.RemoveAll();
			break;

		case "LoadExcel":
			// 업로드
			if(!checkList()) return ;
			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params);
			break;

		case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;

		case "DownTemplate":
			// 양식다운로드
			sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0|1", DownCols:"sabun|curDeferMon|hCurDeferMon|preDeferMon|hPreDeferMon|deferYmd|bankAccount|bankNm|bankEnterNo"});
			break;
	}
}

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

// 저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } doAction1("Search");} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}

function sheet1_OnPopupClick(Row, Col) {
	try{
		var colName = sheet1.ColSaveName(Col);
		if (Row > 0) {
			if(colName == "name") {
				// 사원검색 팝업
				empSearchPopup(Row, Col);
			}
		}
	}catch(ex) {alert("OnPopupClick Event Error : " + ex);}
}

function sheet1_OnLoadExcel() {

	var searchPayActionCd = $("#payActionCd").val();
	var searchPayActionNm = $("#payActionNm").val();
	sheet1.SetRangeValue(searchPayActionCd, sheet1.HeaderRows(), 3, sheet1.LastRow(), 3);
	sheet1.SetRangeValue(searchPayActionNm, sheet1.HeaderRows(), 4, sheet1.LastRow(), 4);
}

// 최근급여일자 조회
function getCpnLatestPaymentInfo() {
	var procNm = "최근급여일자";
	// 급여구분(C00001-00004.퇴직금)
	var paymentInfo = ajaxCall("${ctx}/SepTaxDefMgr.do?cmd=getCpnQueryList", "queryId=getCpnLatestPaymentInfoMap&procNm="+procNm+"&runType=00004,", false);

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
function payActionSearchPopup(){
	if(!isPopup()) {return;}
	gPRow = "";
	pGubun = "payDayPopup";

	var w	= 840;
	var h	= 520;
	var url= "/PayDayPopup.do?cmd=payDayPopup";
	var args= new Array();

	let layerModal = new window.top.document.LayerModal({
		id : 'payDayLayer'
		, url : '/PayDayPopup.do?cmd=viewPayDayLayer&authPg=R'
		, parameters : {
			runType : '00004' // 급여구분(C00001-00004.퇴직금)
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

					if ($("#payActionCd").val() != null && $("#payActionCd").val() != "") {
						doAction1("Search");
					}
				}
			}
		]
	});
	layerModal.show();

}

function getReturnValue(rv) {
    if(pGubun == "employeePopup"){
		sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
		sheet1.SetCellValue(gPRow, "name", rv["name"]);
		sheet1.SetCellValue(gPRow, "alias", rv["alias"]);
		sheet1.SetCellValue(gPRow, "jikgubNm", rv["jikgubNm"]);
		sheet1.SetCellValue(gPRow, "jikweeNm", rv["jikweeNm"]);
		sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
    }
}

// 사원검색 팝업
function empSearchPopup(Row, Col) {
	if(!isPopup()) {return;}
	gPRow = Row;
	pGubun = "employeePopup";

	let layerModal = new window.top.document.LayerModal({
		id : 'employeeLayer'
		, url : '/Popup.do?cmd=viewEmployeeLayer'
		, parameters : {}
		, width : 840
		, height : 520
		, title : '사원조회'
		, trigger :[
			{
				name : 'employeeTrigger'
				, callback : function(result){
					getReturnValue(result);
				}
			}
		]
	});
	layerModal.show();
}

// 입력시 조건 체크
function checkList(){
	var ch = true;
	var exit = false;
	if(exit){return false;}
		// 화면의 개별 입력 부분 필수값 체크
	$(".required").each(function(index){
		if($(this).val() == null || $(this).val() == ""){
			alert($(this).parent().prepend().find("span:first-child").text()+"은(는) 필수값입니다.");
			$(this).focus();
			ch =  false;
			return false;
		}
	});
	return ch;
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
						<th><tit:txt mid='112445' mdef='퇴직금일자'/></th>
						<td>
							<input type="hidden" id="payActionCd" name="payActionCd" value="" />
							<input type="text" id="payActionNm" name="payActionNm" class="text required readonly w180" value="" readonly />
							<a onclick="javascript:payActionSearchPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
						</td>
						<th><tit:txt mid='104330' mdef='사번/성명'/></th>
						<td>
							<input type="text" id="sabunName" name="sabunName" class="text" value="" />
						</td>
						<td>
							<btn:a href="javascript:doAction1('Search')"	css="button authR" mid='110697' mdef="조회"/>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td class="top">
				<div class="outer">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='112461' mdef='과세이연기초 '/> </li>
							<li class="btn">
								<%-- <btn:a href="javascript:doAction1('DownTemplate')"	css="basic authA" mid='110702' mdef="양식다운로드"/> --%>
								<btn:a href="javascript:doAction1('Insert')"		css="basic authA" mid='110700' mdef="입력"/>
								<%-- <btn:a href="javascript:doAction1('Copy')"			css="basic authA" mid='110696' mdef="복사"/> --%>
								<btn:a href="javascript:doAction1('Save')"			css="basic authA" mid='110708' mdef="저장"/>
								<%-- <btn:a href="javascript:doAction1('LoadExcel')"		css="basic authA" mid='110703' mdef="업로드"/> --%>
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
