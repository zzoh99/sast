<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='sepExceMgr' mdef='퇴직금예외관리'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 퇴직금예외관리
 * @author JM
-->
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
$(function() {
	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata1.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },
		{Header:"<sht:txt mid='payActionCdV1' mdef='급여계산코드'/>",	Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"payActionCd",	KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='benefitElemCd' mdef='항목코드'/>",		Type:"Text",		Hidden:0,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"elementCd",	KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0},
		{Header:"<sht:txt mid='benefitElemNm' mdef='항목명'/>",		Type:"Popup",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"elementNm",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1},
		{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0},
		{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",		Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1},
		{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",	Type:"Text",		Hidden:Number("${aliasHdn}"),					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"alias",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",	Type:"Text",		Hidden:Number("${jgHdn}"),					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",	Type:"Text",		Hidden:Number("${jwHdn}"),					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='basicMon' mdef='금액'/>",		Type:"Int",			Hidden:0,					Width:90,			Align:"Right",	ColMerge:0,	SaveName:"paymentMon",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",		Type:"Text",		Hidden:0,					Width:100,			Align:"Left",	ColMerge:0,	SaveName:"note",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);

	$(window).smartresize(sheetResize);
	sheetInit();

	$("#sabunName").bind("keyup",function(event) {
		if (event.keyCode == 13) {
			doAction1("Search");
		}
	});
	
	// 이름 입력 시 자동완성
	$(sheet1).sheetAutocomplete({
		Columns: [
			{
				ColSaveName  : "name",
				CallbackFunc : function(returnValue){
					var rv = $.parseJSON('{' + returnValue+ '}');
					sheet1.SetCellValue(gPRow, "name", 		rv["name"]);
					sheet1.SetCellValue(gPRow, "sabun", 	rv["sabun"]);
					sheet1.SetCellValue(gPRow, "alias", 	rv["alias"]);
					sheet1.SetCellValue(gPRow, "jikgubNm", 	rv["jikgubNm"]);
					sheet1.SetCellValue(gPRow, "jikweeNm", 	rv["jikweeNm"]);
				}
			}
		]
	});	

	// 최근급여일자 조회
	getCpnLatestPaymentInfo();
});

function doAction1(sAction) {
	switch (sAction) {
		case "Search":
			sheet1.DoSearch("${ctx}/SepExceMgr.do?cmd=getSepExceMgrList", $("#sheet1Form").serialize());
			break;

		case "Save":
			// 중복체크
			if (!dupChk(sheet1, "payActionCd|elementCd|sabun", false, true)) {break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave("${ctx}/SepExceMgr.do?cmd=saveSepExceMgr", $("#sheet1Form").serialize());
			break;

		case "Insert":
			var Row = sheet1.DataInsert(0);
			sheet1.SetCellValue(Row, "payActionCd", $("#payActionCd").val());
			sheet1.SelectCell(Row, 2);
			break;

		case "Copy":
			var Row = sheet1.DataCopy();
			sheet1.SelectCell(Row, 2);
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

		case "LoadExcel":
			// 업로드
			if($('#payActionNm').val() == ""){
				alert("급여일자를 선택하여 주세요.");
			}
			var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		case "DownTemplate":
			// 양식다운로드
			sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"elementCd|sabun|paymentMon|note"});
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

// 셀에서 키보드가 눌렀을때 발생하는 이벤트
function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
	try {
		var colName = sheet1.ColSaveName(Col);
		if (sheet1.GetCellEditable(Row, Col) == true) {
			if (colName == "elementNm" && KeyCode == 46) {
				// 항목코드 초기화
				sheet1.SetCellValue(Row,"elementCd","");
			}
		}
	} catch (ex) {
		alert("OnKeyDown Event Error : " + ex);
	}
}

function sheet1_OnLoadExcel(){
		for(var i = 1; i <= sheet1.RowCount(); i++){
			sheet1.SetCellValue(i, "payActionCd", $("#payActionCd").val());
		}
}

function sheet1_OnPopupClick(Row, Col) {
	try{
		var colName = sheet1.ColSaveName(Col);
		if (Row > 0) {
			if (colName == "name") {
				// 사원검색 팝업
				empSearchPopup(Row, Col);
			} else if (colName == "elementNm") {
				// 항목검색 팝업
				let layerModal = new window.top.document.LayerModal({
					  id : 'payElementLayer'
					  , url : '/PayElementPopup.do?cmd=viewPayElementLayer&authPg=R'
					  , parameters : {
						  elementCd : sheet1.GetCellValue(Row, "elementCd")
						  , elementNm : sheet1.GetCellValue(Row, "elementNm")
						  , searchElementLinkType: "C"
						  , isSep : 'Y'
					  }
					  , width : 860
					  , height : 520
					  , title : '<tit:txt mid='payElementPop4' mdef='수당,공제 항목'/>'
					  , trigger :[
						  {
							  name : 'payTrigger'
							  , callback : function(result){
								  sheet1.SetCellValue(Row, "elementCd",   result.resultElementCd);
								  sheet1.SetCellValue(Row, "elementNm",   result.resultElementNm);
							  }
						  }
					  ]
				  });
				  layerModal.show();
			}
		}
	} catch(ex) {alert("OnPopupClick Event Error : " + ex);}
}

// 최근급여일자 조회
function getCpnLatestPaymentInfo() {
	var procNm = "최근급여일자";
	// 급여구분(C00001-00004.퇴직금)
	var paymentInfo = ajaxCall("${ctx}/SepExceMgr.do?cmd=getCpnQueryList", "queryId=getCpnLatestPaymentInfoMap&procNm="+procNm+"&runType=00004,", false);

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

//급여일자 조회 팝업
function openPayDayPopup(){
let parameters = {
	runType : '00004'
};

let layerModal = new window.top.document.LayerModal({
	id : 'payDayLayer'
	, url : '/PayDayPopup.do?cmd=viewPayDayLayer&authPg=${authPg}'
	, parameters : parameters
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
			}
		}
	]
});
layerModal.show();
}

//항목명 팝업
function openPayElementPopup(){
	let layerModal = new window.top.document.LayerModal({
		id : 'payElementLayer'
		, url : '/PayElementPopup.do?cmd=viewPayElementLayer&authPg=R'
		, parameters : {
			searchElementLinkType: "C",
			isSep : 'Y'
		}
		, width : 860
		, height : 520
		, title : '<tit:txt mid='payElementPop4' mdef='수당,공제 항목'/>'
		, trigger :[
			{
				name : 'payTrigger'
				, callback : function(result){
					$("#elementCd").val(result.resultElementCd);
					$("#elementNm ").val(result.resultElementNm);
				}
			}
		]
	});
	layerModal.show();

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
						<td colspan="2">
							<input type="hidden" id="payActionCd" name="payActionCd" value="" />
							<input type="text" id="payActionNm" name="payActionNm" class="text required readonly w180" value="" readonly />
							<a onclick="javascript:openPayDayPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
							<input type="hidden" id="payPeopleStatus" name="payPeopleStatus" value="" />
							<input type="hidden" id="payCd" name="payCd" value="" />
							<input type="hidden" id="closeYn" name="closeYn" value="" /></td>
						<th><tit:txt mid='eleGroupMgr2' mdef='항목명'/></th>
						<td> 
							<input type="hidden" id="elementCd" name="elementCd" class="text" value="" />
							<input type="text" id="elementNm" name="elementNm" class="text readonly w120" value="" readonly />
							<a onclick="javascript:openPayElementPopup()" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
							<a onclick="javascript:$('#elementCd,#elementNm').val('');" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a></td>
						<th><tit:txt mid='104330' mdef='사번/성명'/></th>
						<td>
							<input type="text" id="sabunName" name="sabunName" class="text w100" value="" />
						</td>
						<td> <btn:a href="javascript:doAction1('Search')"	css="button authR" mid='110697' mdef="조회"/> </td>
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
							<li id="txt" class="txt"><tit:txt mid='114599' mdef='퇴직금예외관리 '/> </li>
							<li class="btn">
								<btn:a href="javascript:doAction1('DownTemplate')"  css="basic authA" mid='110702' mdef="양식다운로드"/>
								<btn:a href="javascript:doAction1('LoadExcel')"     css="basic authA" mid='110703' mdef="업로드"/>
								<btn:a href="javascript:doAction1('Insert')"		css="basic authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction1('Copy')"			css="basic authA" mid='110696' mdef="복사"/>
								<btn:a href="javascript:doAction1('Save')"			css="basic authA" mid='110708' mdef="저장"/>
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
