<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>중간정산일자관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
$(function() {

	$("#searchDateFrom").datepicker2({startdate:"searchDateTo"});
	$("#searchDateTo").datepicker2({enddate:"searchDateFrom"});

	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22, MergeSheet:msHeaderOnly};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata1.Cols = [
		{Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",		ColMerge:1,		SaveName:"sNo" },
		{Header:"삭제",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",		ColMerge:1,		SaveName:"sDelete",			Sort:0 },
		{Header:"상태",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",		ColMerge:1,		SaveName:"sStatus",			Sort:0 },
		
		{Header:"사번",				Type:"Text",	Hidden:0, Width:50,	Align:"Center",	ColMerge:0, SaveName:"sabun",		KeyField:1, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"성명",				Type:"Text",	Hidden:0, Width:60,	Align:"Center",	ColMerge:0, SaveName:"name",		KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"중간정산일",			Type:"Date",	Hidden:0, Width:80,	Align:"Center",	ColMerge:0, SaveName:"rmidYmd",		KeyField:1, Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"퇴직금계산코드",		Type:"Text",	Hidden:1, Width:80,	Align:"Center",	ColMerge:0, SaveName:"payActionCd",	KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"퇴직금계산코드",		Type:"Popup",	Hidden:0, Width:80,	Align:"Center",	ColMerge:0, SaveName:"payActionNm",	KeyField:0, Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"지급일",				Type:"Date",	Hidden:0, Width:80,	Align:"Center",	ColMerge:0, SaveName:"paymentYmd",	KeyField:0, Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"근속개월",			Type:"Int",		Hidden:0, Width:50,	Align:"Center",	ColMerge:0, SaveName:"wkpYm",		KeyField:0, Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"평균임금",			Type:"Int",		Hidden:0, Width:60,	Align:"Right",	ColMerge:0, SaveName:"avgMon",		KeyField:0, Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"총퇴직소득",			Type:"Int",		Hidden:0, Width:60,	Align:"Right",	ColMerge:0, SaveName:"earningMon",	KeyField:0, Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"소득세",				Type:"Int",		Hidden:0, Width:60,	Align:"Right",	ColMerge:0, SaveName:"tItaxMon",	KeyField:0, Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"지방소득세",			Type:"Int",		Hidden:0, Width:60,	Align:"Right",	ColMerge:0, SaveName:"tRtaxMon",	KeyField:0, Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"농어촌특별세",		Type:"Int",		Hidden:0, Width:60,	Align:"Right",	ColMerge:0, SaveName:"tStaxMon",	KeyField:0, Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"수정일시",			Type:"Date",	Hidden:0, Width:90,	Align:"Center",	ColMerge:0, SaveName:"chkdate",		KeyField:0, Format:"YmdHm",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"수정자",				Type:"Text",	Hidden:0, Width:60,	Align:"Center",	ColMerge:0, SaveName:"chkid",		KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }

	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);

	$(window).smartresize(sheetResize);
	sheetInit();
	
	$("#searchSabunName, #searchDateFrom, #searchDateTo").on("keyup", function(event) {
		if(event.keyCode === 13) {
			doAction1("Search");
			$(this).focus();
		}
	});
	
	doAction1("Search");
	//setSheetAutocompleteEmp( "sheet1", "name");

	//Autocomplete	
	$(sheet1).sheetAutocomplete({
		Columns: [
			{
				ColSaveName  : "name",
				CallbackFunc : function(returnValue) {
					var rv = $.parseJSON('{' + returnValue+ '}');
					sheet1.SetCellValue(gPRow,"name", rv["name"]);
					sheet1.SetCellValue(gPRow,"sabun", rv["sabun"]);
				}
			}
		]
	});
	
});

function doAction1(sAction) {
	switch (sAction) {
		case "Search":
			sheet1.DoSearch("${ctx}/RetirementMidAdj.do?cmd=getRetirementMidAdjList", $("#sheet1Form").serialize());
			break;

		case "Save":
			if (!dupChk(sheet1, "sabun|rmidYmd|", false, true)) {break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave("${ctx}/RetirementMidAdj.do?cmd=saveRetirementMidAdj", $("#sheet1Form").serialize());
			break;

		case "Insert":
			var Row = sheet1.DataInsert(0);
			break;

		case "Copy":
			sheet1.DataCopy(); break;

		case "Clear":
			sheet1.RemoveAll();
			break;

		case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
			break;

		case "DownTemplate":
			sheet1.Down2Excel({DownCols:"sabun|rmidYmd|wkpYm|avgMon|earningMon|tItaxMon|tRtaxMon|tStaxMon",SheetDesign:1,Merge:1,DownRows:"0"});
			break;
			
		case "LoadExcel":
			sheet1.RemoveAll();
			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params);
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

function sheet1_OnPopupClick(Row, Col){
	try{
		openPayDayPopup(Row, Col);
	}catch(ex){alert("OnPopupClick Event Error : " + ex);}
}


function getReturnValue(returnValue) {

	var result = $.parseJSON('{'+ returnValue+'}');

    if(pGubun == "sheetAutocompleteEmp"){
		sheet1.SetCellValue(gPRow, "sabun", result["sabun"]);
		sheet1.SetCellValue(gPRow, "name", result["name"]);
    }
}

//급여일자 조회 팝업
function openPayDayPopup(Row, Col){
	let layerModal = new window.top.document.LayerModal({
		id : 'payDayLayer'
		, url : '/PayDayPopup.do?cmd=viewPayDayLayer&authPg=${authPg}'
		, parameters : {
			runType : '00004'
		}
		, width : 840
		, height : 520
		, title : '<tit:txt mid='payDayPop' mdef='급여일자 조회'/>'
		, trigger :[
			{
				name : 'payDayTrigger'
				, callback : function(result){
					sheet1.SetCellValue(Row, "payActionCd", result["payActionCd"]);
					sheet1.SetCellValue(Row, "payActionNm", result["payActionNm"]);
					sheet1.SetCellValue(Row, "paymentYmd", result["paymentYmd"]);
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
						<th>중간정산일</th>
						<td>
							<input id="searchDateFrom" name="searchDateFrom" type="text" class="date2" />
							&nbsp;~&nbsp;
							<input id="searchDateTo" name="searchDateTo" type="text" class="date2" />
						</td>
						<th>성명/사번</th>
						<td>
							<input id="searchSabunName" name="searchSabunName" type="text" class="text" />
						</td>
						<td> <a href="javascript:doAction1('Search')"	class="button authR">조회</a> </td>
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
							<li id="txt" class="txt">중간정산일자관리</li>
							<li class="btn">
								<a href="javascript:doAction1('DownTemplate')"	class="basic authA">양식다운로드</a>
								<a href="javascript:doAction1('Insert')"		class="basic authA">입력</a>
								<a href="javascript:doAction1('Copy')"			class="basic authA">복사</a>
								<a href="javascript:doAction1('Save')"			class="basic authA">저장</a>
								<a href="javascript:doAction1('LoadExcel')"		class="basic authA">업로드</a>
								<a href="javascript:doAction1('Down2Excel')"	class="basic authR">다운로드</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "kr"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
