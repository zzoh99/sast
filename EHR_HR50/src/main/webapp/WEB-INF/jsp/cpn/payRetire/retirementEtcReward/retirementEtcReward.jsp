<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>퇴직기타수당/공제</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
$(function() {
	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22, MergeSheet:msHeaderOnly};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata1.Cols = [
		{Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",		ColMerge:1,		SaveName:"sNo" },
		{Header:"삭제",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",		ColMerge:1,		SaveName:"sDelete",			Sort:0 },
		{Header:"상태",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",		ColMerge:1,		SaveName:"sStatus",			Sort:0 },
		{Header:"급여계산코드",			Type:"Text",		Hidden:1,					Width:100,			Align:"Center",		ColMerge:0,		SaveName:"payActionCd",		KeyField:0,		Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"퇴직계산일자",			Type:"Popup",     	Hidden:0,  					Width:100,   		Align:"Center",  	ColMerge:0,   	SaveName:"payActionNm", 	KeyField:1,   	Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
		{Header:"사번",				Type:"Text",		Hidden:0,					Width:50,			Align:"Center",		ColMerge:1,		SaveName:"sabun",			KeyField:1,		Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"성명",				Type:"Text",		Hidden:0,					Width:50,			Align:"Center",		ColMerge:1,		SaveName:"name",			KeyField:1,		Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"조직",				Type:"Text",		Hidden:0,					Width:120,			Align:"Center",		ColMerge:0,		SaveName:"orgNm",			KeyField:0,		Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"직급",				Type:"Text",		Hidden:0,					Width:70,			Align:"Center",		ColMerge:0,		SaveName:"jikgubNm",		KeyField:0,		Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"수당항목코드",			Type:"Text",		Hidden:1,					Width:90,			Align:"Center",		ColMerge:0,		SaveName:"elementCd",		KeyField:1,		Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"수당항목",			Type:"Popup",      	Hidden:0,  					Width:80,   		Align:"Center",  	ColMerge:0,   	SaveName:"elementNm", 		KeyField:1,   	Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
		{Header:"기초금액",			Type:"Text",		Hidden:1,					Width:50,			Align:"Center",		ColMerge:0,		SaveName:"baseMon",			KeyField:0,		Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"지급율(%)",			Type:"Text",		Hidden:1,					Width:50,			Align:"Center",		ColMerge:0,		SaveName:"baseRate",		KeyField:0,		Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"지급총액",			Type:"Int",			Hidden:0,					Width:50,			Align:"Center",		ColMerge:0,		SaveName:"bonMon",			KeyField:0,		Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }

	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);

	$(window).smartresize(sheetResize);
	sheetInit();
	
	//퇴직계산일자
	var dayLatestCode = ajaxCall("${ctx}/RetirementEtcReward.do?cmd=getDayLatestCodePopup", $("#sheetForm").serialize(), false);
	if(dayLatestCode.DATA !=""){
		
		$("#searchPayActionNm").val("");
		$("#searchPayActionCd").val("");
		
		$.each(dayLatestCode.DATA, function(idx, value){
			$("#searchPayActionNm").val(value.payActionNm);
			$("#searchPayActionCd").val(value.payActionCd);			
		});
	}

	
	$("#searchSabunName").bind("keyup",function(event){
		if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
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
					sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
					sheet1.SetCellValue(gPRow, "name", rv["name"]);
					sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
					sheet1.SetCellValue(gPRow, "jikgubNm", rv["jikgubNm"]);
					sheet1.SetCellValue(gPRow, "resNo", rv["resNo"]);
				}
			}
		]
	});
	
});

function doAction1(sAction) {
	switch (sAction) {
		case "Search":

			sheet1.DoSearch("${ctx}/RetirementEtcReward.do?cmd=getRetirementEtcRewardList", $("#sheet1Form").serialize());
			break;

		case "Save":

			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave("${ctx}/RetirementEtcReward.do?cmd=saveRetirementEtcReward", $("#sheet1Form").serialize());
			break;

		case "Insert":
			var Row = sheet1.DataInsert(0);
			sheet1.SetCellValue(Row, "payActionCd", $("#searchPayActionCd").val());
			sheet1.SetCellValue(Row, "payActionNm", $("#searchPayActionNm").val());
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
		
		if(sheet1.ColSaveName(Col) == "payActionNm") {//퇴직계산일자
			
			if(!isPopup()) {return;}
			pGubun = "retCalcPayDayViewPopup";
			var w		= 900;
			var h		= 580;
			var url		= "/yjungsan/y_ret_common/jsp_jungsan/retCalc/retCalcPayDayViewPopup.jsp?authPg=${authPg}";
			var args	= new Array();
			
			openPopup(url+"&authPg=${authPg}", args, w, h, function(rv) {
				var payActionCd	= rv["payActionCd"];
				var payActionNm	= rv["payActionNm"];

				sheet1.SetCellValue(Row, "payActionCd", payActionCd);
				sheet1.SetCellValue(Row, "payActionNm", payActionNm);
			});
		}
		
		
		if(sheet1.ColSaveName(Col) == "elementNm") {//수당항목
			
			if(!isPopup()) {return;}
			var w		= 840;
			var h		= 520;
			var url		= "/PayElementPopup.do?cmd=payElementPopup";
			var args	= new Array();

			openPopup(url+"&authPg=R", args, w, h, function(rv) {
				var elementCd	= rv["elementCd"];
				var elementNm	= rv["elementNm"];

				sheet1.SetCellValue(Row, "elementCd", elementCd);
				sheet1.SetCellValue(Row, "elementNm", elementNm);
			});
			
		}
		
	}catch(ex){alert("OnPopupClick Event Error : " + ex);}
}


//급여일자 검색 팝입
function payActionSearchPopup() {

	if(!isPopup()) {return;}
	pGubun = "retCalcPayDayViewPopup";
	
	var arg = new Array();
	
	openPopup("/yjungsan/y_ret_common/jsp_jungsan/retCalc/retCalcPayDayViewPopup.jsp?authPg=${authPg}", arg, "900","580");
}


function getReturnValue(returnValue) {

	var result = $.parseJSON('{'+ returnValue+'}');

	if ( pGubun == "retCalcPayDayViewPopup" ){
		$("#searchPayActionCd").val(result["payActionCd"]);
		$("#searchPayActionNm").val(result["payActionNm"]);
		//$("#payYM").val(result["payYm"].substring(0,4) + "-" + result["payYm"].substring(4,6)) ;
		//$("#ordYmd").val(result["ordSymd"].substring(0,4) +"-"+result["ordSymd"].substring(4,6)+"-"+result["ordSymd"].substring(6,8) + " ~ " + result["ordEymd"].substring(0,4) +"-"+result["ordEymd"].substring(4,6)+"-"+result["ordEymd"].substring(6,8)) ;
		
		doAction1("Search");
	}
	
    if(pGubun == "sheetAutocompleteEmp"){
		sheet1.SetCellValue(gPRow, "sabun", result["sabun"]);
		sheet1.SetCellValue(gPRow, "name", result["name"]);
		sheet1.SetCellValue(gPRow, "orgNm", result["orgNm"]);
		sheet1.SetCellValue(gPRow, "jikgubNm", result["jikgubNm"]);
		sheet1.SetCellValue(gPRow, "resNo", result["resNo"]);
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
						<th>퇴직계산일자</th>
						<td> 
							 <input type="text" id="searchPayActionNm" name="searchPayActionNm" readonly="readonly"/>
							<input type="hidden" id="searchPayActionCd" name="searchPayActionCd" />
							<a onclick="javascript:payActionSearchPopup();" class="button6"><img src="/common/images/common/btn_search2.gif"/></a> 
						</td>
						<th>성명/사번</th>
						<td>
							<input id="searchSabunName" name="searchSabunName" type="text" class="text" style="ime-mode:active"/>
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
							<li id="txt" class="txt">퇴직기타수당/공제 </li>
							<li class="btn">
								<a href="javascript:doAction1('Insert')"		class="basic authA">입력</a>
								<a href="javascript:doAction1('Copy')"			class="basic authA">복사</a>
								<a href="javascript:doAction1('Save')"			class="basic authA">저장</a>
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
