<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>퇴직기타수당/공제</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";

$(function() {
	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22, MergeSheet:msHeaderOnly};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata1.Cols = [
		{Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",		ColMerge:1,		SaveName:"sNo" },
		{Header:"삭제",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",		ColMerge:1,		SaveName:"sDelete",			Sort:0 },
		{Header:"상태",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",		ColMerge:1,		SaveName:"sStatus",			Sort:0 },
		{Header:"퇴직금계산코드",		Type:"Text",		Hidden:1,					Width:80,			Align:"Center",		ColMerge:0,		SaveName:"payActionCd",		KeyField:1,		Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"분류",				Type:"Combo",     	Hidden:0,  					Width:80,   		Align:"Center",  	ColMerge:0,   	SaveName:"sepSubType", 		KeyField:1,   	Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
		//{Header:"분류",				Type:"Text",		Hidden:0,					Width:120,			Align:"Center",		ColMerge:0,		SaveName:"codeNm",			KeyField:0,		Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"관련급여계산코드",		Type:"Text",		Hidden:0,					Width:80,			Align:"Center",		ColMerge:0,		SaveName:"subPayActionCd",	KeyField:1,		Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"관련급여계산코드명",		Type:"Popup",		Hidden:0,					Width:90,			Align:"Center",		ColMerge:0,		SaveName:"payActionNm",		KeyField:1,		Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"사번",				Type:"Text",		Hidden:0,					Width:50,			Align:"Center",		ColMerge:1,		SaveName:"sabun",			KeyField:1,		Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"성명",				Type:"Text",		Hidden:0,					Width:50,			Align:"Center",		ColMerge:1,		SaveName:"name",			KeyField:0,		Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"관련급여\n대상자여부",	Type:"CheckBox",	Hidden:0,					Width:40,			Align:"Center",		ColMerge:0,		SaveName:"payTargetYn",	KeyField:0,		Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	TrueValue:"Y", FalseValue:"N" }

	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);

	
	
	//분류
	var sepSubType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00730"), "");
	sheet1.SetColProperty("sepSubType", 			{ComboText:"|"+sepSubType[0], ComboCode:"|"+sepSubType[1]} );
	
	$(window).smartresize(sheetResize);
	sheetInit();
	
	//퇴직계산일자
	var dayLatestCode = ajaxCall("${ctx}/RetConnectPay.do?cmd=getDayLatestCodePopup", $("#sheetForm").serialize(), false);
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

			sheet1.DoSearch("${ctx}/RetConnectPay.do?cmd=getRetConnectPayList", $("#sheet1Form").serialize());
			break;

		case "Save":

			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave("${ctx}/RetConnectPay.do?cmd=saveRetConnectPay", $("#sheet1Form").serialize());
			break;

		case "Insert":
			var Row = sheet1.DataInsert(0);
			sheet1.SetCellValue(Row, "payActionCd", $("#searchPayActionCd").val());
			//sheet1.SetCellValue(Row, "payActionNm", $("#searchPayActionNm").val());
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

			let layerModal = new window.top.document.LayerModal({
				id : 'payDayLayer'
				, url : '/PayDayPopup.do?cmd=viewPayDayLayer&authPg=${authPg}'
				, parameters : {
					runType: "00001,00002,00003,R0001,R0002,R0003,J0001,ETC,RETRO,Y0001"
				}
				, width : 840
				, height : 520
				, title : '<tit:txt mid='payDayPop' mdef='급여일자 조회'/>'
				, trigger :[
					{
						name : 'payDayTrigger'
						, callback : function(result){
							if (result) {
								sheet1.SetCellValue(Row, "subPayActionCd", result.payActionCd);
								sheet1.SetCellValue(Row, "payActionNm", result.payActionNm);
							} else {
								sheet1.SetCellValue(Row, "subPayActionCd", "");
								sheet1.SetCellValue(Row, "payActionNm", "");
							}
						}
					}
				]
			});
			layerModal.show();
		}
		
		
		if(sheet1.ColSaveName(Col) == "elementNm") {//수당항목

			let layerModal = new window.top.document.LayerModal({
				id : 'payElementLayer',
				url : '/PayElementPopup.do?cmd=viewPayElementLayer&authPg=R',
				parameters : {},
				width : 840,
				height : 520,
				title : '<tit:txt mid='payElementPop4' mdef='수당,공제 항목'/>',
				trigger :[
					{
						name : 'payTrigger',
						callback : function(rv){
							sheet1.SetCellValue(Row, "elementCd", rv["resultElementCd"]);
						}
					}
				]
			});
			layerModal.show();
		}
		
	}catch(ex){alert("OnPopupClick Event Error : " + ex);}
}


//급여일자 검색 팝입
function payActionSearchPopup() {

	let layerModal = new window.top.document.LayerModal({
		id : 'payDayLayer'
		, url : '/PayDayPopup.do?cmd=viewPayDayLayer&authPg=${authPg}'
		, parameters : {
			runType: "00004"
		}
		, width : 900
		, height : 580
		, title : '<tit:txt mid='payDayPop' mdef='급여일자 조회'/>'
		, trigger :[
			{
				name : 'payDayTrigger'
				, callback : function(result){
					if (result) {
						$("#searchPayActionCd").val(result.payActionCd);
						$("#searchPayActionNm").val(result.payActionNm);

						doAction1("Search");
					} else {
						$("#searchPayActionCd").val("");
						$("#searchPayActionNm").val("");
					}
				}
			}
		]
	});
	layerModal.show();
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
							<input type="text" id="searchPayActionNm" name="searchPayActionNm" class="text readonly w180" readonly/>
							<input type="hidden" id="searchPayActionCd" name="searchPayActionCd" />
							<a onclick="javascript:payActionSearchPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
						</td>
						<th>성명/사번</th>
						<td>
							<input id="searchSabunName" name="searchSabunName" type="text" class="text w100" />
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
