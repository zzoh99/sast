<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>역량평가항목정의</title>

<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No"				,Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제"				,Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center", ColMerge:0,	SaveName:"sDelete" },
			{Header:"상태"				,Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center", ColMerge:0,	SaveName:"sStatus" },

			{Header:"보상명",					Type:"Text",		Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"rewardNm",			KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},

			{Header:"최대급여\n보상시간",		Type:"Int",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"rewardMaxTime",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:22},
			{Header:"보상\n제외시간",			Type:"Int",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"rewardExpTime",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:22},
			{Header:"보상\n지급여부",			Type:"CheckBox",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"rewardYn",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1, TrueValue:"Y", FalseValue:"N"},
			{Header:"보상휴가\n생성여부",		Type:"CheckBox",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"rewardVacationYn",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1, TrueValue:"Y", FalseValue:"N"},

			{Header:"유효시작일",				Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sdate",				KeyField:1,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
			{Header:"유효종료일",				Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"edate",				KeyField:0,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
			{Header:"범위구분",				Type:"Combo",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"scopeGubun",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"조직\n범위적용",			Type:"Image",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"scope",				KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"범위기준\n설정여부",		Type:"Text",		Hidden:1,	Width:55,	Align:"Center",	ColMerge:0,	SaveName:"detailYn",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"비고",					Type:"Text",		Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"note",				KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000}

		];IBS_InitSheet(sheet1, initdata); sheet1.SetEditable("${editable}"); sheet1.SetCountPosition(4); sheet1.SetUnicodeByte(3);

		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("scope", 1);

		sheet1.SetColProperty("scopeGubun", {ComboText:"범위적용", ComboCode:"O"} ); // 범위구분

		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata2.Cols = [
			{Header:"No"	,Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
			{Header:"삭제"	,Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center", ColMerge:0,   SaveName:"sDelete" },
			{Header:"상태"	,Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center", ColMerge:0,   SaveName:"sStatus" },

			{Header:"조직코드"		,Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"scopeValue",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
			{Header:"조직명"		,Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"scopeValueNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100}
		]; IBS_InitSheet(sheet2, initdata2); sheet2.SetEditable("${editable}"); sheet2.SetCountPosition(4); sheet2.SetUnicodeByte(3);

		$(window).smartresize(sheetResize); sheetInit();
		doAction("Search");
	});
</script>

<script type="text/javascript">

/**
 * Sheet 각종 처리
 */
function doAction(sAction){
	//removeErrMsg();
	switch(sAction){
		case "Search":		//조회
			sheet1.DoSearch("${ctx}/PayWorkTimeRewardTab.do?cmd=getPayWorkTimeRewardTabList", $("#mySheetForm").serialize());
			break;

		case "Save":		//저장
			IBS_SaveName(document.mySheetForm,sheet1);
			sheet1.DoSave( "${ctx}/PayWorkTimeRewardTab.do?cmd=savePayWorkTimeRewardTab", $("#mySheetForm").serialize()); break;
			break;

		case "Insert":		//입력
			var Row = sheet1.DataInsert(0);
			sheet1.SetCellValue(Row, "scope", "0");
			break;

		case "Copy":		//행복사
			var Row = sheet1.DataCopy();
			sheet1.SetCellValue(Row, "seq", "");
			sheet1.SetCellValue(Row, "scope", "0");
			sheet1.SelectCell(Row, 3);
			break;

		case "Clear":		//Clear
			sheet1.RemoveAll();
			break;

		case "Down2Excel":	//엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;

		case "LoadExcel":	//엑셀업로드
			sheet1.LoadExcel(true,1);
			break;
	}
}

function doAction2(sAction){
	switch (sAction) {
	case "Search2":

		$("#itemValue1").val(sheet1.GetCellValue(sheet1.GetSelectRow(), "rewardNm"));
		$("#itemValue2").val(sheet1.GetCellValue(sheet1.GetSelectRow(), "sdate"));

		sheet2.DoSearch( "${ctx}/PayWorkTimeRewardTab.do?cmd=getPayWorkTimeRewardTabScopeCd", $("#mySheetForm").serialize() );

		break;
	case "Clear":		sheet2.RemoveAll(); break;
	case "Down2Excel":
		var downcol = makeHiddenSkipCol(sheet2);
		var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
		sheet2.Down2Excel(param);

		break;
	case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet2.LoadExcel(params); break;
	}
}

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try{
		if (Msg != ""){
			alert(Msg);
		}
		sheetResize();
		doAction2("Search2");
	}catch(ex){
		alert("OnSearchEnd Event Error : " + ex);
	}
}

// 저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try{
		if(Msg != "")alert(Msg);
		if ( Code != -1 ) doAction("Search");

	}catch(ex){
		alert("OnSaveEnd Event Error " + ex);
	}
}

function sheet1_OnPopupClick(Row, Col){
	try{
		var colName = sheet1.ColSaveName(Col);
		var args	= new Array();
		var rv = null;

	}catch(ex){alert("OnPopupClick Event Error : " + ex);}
}

function sheet1_OnClick(Row, Col, Value) {
	try{

		if( sheet1.ColSaveName(Col) == "scope" 	&& Row >= sheet1.HeaderRows()) {
			if(!isPopup()) {return;}

			if( sheet1.GetCellValue(Row,"sStatus") == "I" ) {
				alert("입력 상태에서는 범위설정을 하실 수 없습니다.");
				return;
			}
			if(sheet1.GetCellValue(Row,"scopeGubun") != "O") {
				alert("범위구분에서 [범위적용]으로 선택했을 경우만 조회를 할 수 있습니다.");
				return;
			}

			var args = new Array();
			args["searchUseGubun"] = "C";
			args["searchItemValue1"] = sheet1.GetCellValue(Row,"rewardNm");
			args["searchItemValue2"] = sheet1.GetCellValue(Row,"sdate");
			args["searchItemValue3"] = 10;
			args["searchItemNm"] = sheet1.GetCellText(Row,"rewardNm");

			gPRow = Row;
			pGubun = "payWorkTimeRewardTabOrgLayer";

			const url = "${ctx}/PayWorkTimeRewardTab.do?cmd=viewPayWorkTimeRewardTabOrgLayer&authPg=${authPg}";

			var searchUseGubun = 'C';
			var searchItemValue1 = sheet1.GetCellValue(Row,"rewardNm");
			var searchItemValue2 = sheet1.GetCellValue(Row,"sdate");
			var searchItemValue3 = 10;
			var searchItemNm = sheet1.GetCellText(Row,"rewardNm");

			const p = {searchUseGubun, searchItemValue1, searchItemValue2, searchItemValue3, searchItemNm};
			let payWorkTimeRewardTabOrgLayer = new window.top.document.LayerModal({
				id : 'payWorkTimeRewardTabOrgLayer',
				url : url,
				parameters : p,
				width : 740,
				height : 700,
				title : '사용자 권한범위 설정(소속)',
				trigger :[
					{
						name : 'payWorkTimeRewardTabOrgTrigger'
						, callback : function(result){
							getReturnValue(result);
						}
					}
				]
			});
			payWorkTimeRewardTabOrgLayer.show();
		}

	}catch(ex){alert("OnClick Event Error : " + ex);}
}

function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
	if( OldRow != NewRow ) {
		doAction2("Search2");
	}
}

//조회 후 에러 메시지
function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try{
		if (Msg != ""){
			alert(Msg);
		}
		sheetResize();
	}catch(ex){
		alert("OnSearchEnd Event Error : " + ex);
	}
}

//팝업 콜백 함수.
function getReturnValue(returnValue) {
	var rv = returnValue;
	if(pGubun == "payWorkTimeRewardTabOrgLayer"){
		doAction2("Search2");
	}

}
</script>

</head>
<body class="bodywrap">

<div class="wrapper">
	<form id="mySheetForm" name="mySheetForm" >
		<input type="hidden" id="itemValue1" name="itemValue1" />
		<input type="hidden" id="itemValue2" name="itemValue2" />
		<input type="hidden" id="itemValue3" name="itemValue3" value="10"/>		<!-- 근무보상기준 조직 세팅 : 10-->
		<input type="hidden" id="tableNm" name="tableNm" />
		<input type="hidden" id="scopeCd" name="scopeCd" value="W10"/>			<!-- 조직 세팅 만 가능 -->
	</form>
		<table class="sheet_main">
		<colgroup>
			<col width="68%" />
			<col width="32%" />
		</colgroup>
		<tr>
			<td class="sheet_left">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li class="txt">근무보상기준관리</li>
							<li class="btn">
								<a href="javascript:doAction('Search');" class="btn dark">조회</a>
								<a href="javascript:doAction('Insert')" class="btn outline_gray authA">입력</a>
								<a href="javascript:doAction('Copy')" 	class="btn outline_gray authA">복사</a>
								<a href="javascript:doAction('Save')" 	class="btn filled authA">저장</a>
								<a href="javascript:doAction('Down2Excel')" 	class="btn outline_gray authR">다운로드</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "70%", "100%","kr"); </script>
			</td>
			<td class="sheet_right">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li class="txt">조직 범위</li>
							<li class="btn hide">
								<a href="javascript:doAction2('Down2Excel')" 	class="btn outline_gray authR">다운로드</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet2", "30%", "100%","kr"); </script>
			</td>
		</tr>
		</table>
</div>
</body>
</html>
