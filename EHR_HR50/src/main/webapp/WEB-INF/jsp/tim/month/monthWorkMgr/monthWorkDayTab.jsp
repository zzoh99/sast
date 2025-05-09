<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";

$(function() {
	$.extend(doAction, { "tab1Sheet": doActionSheet1 });
	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};
	initdata1.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
		{Header:"<sht:txt mid='statusCd' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
		{Header:"<sht:txt mid='businessPlaceNm' mdef='사업장'/>",		Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"businessPlaceNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
		{Header:"<sht:txt mid='locationCd' mdef='근무지'/>",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"locationNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='orgNm' mdef='소속'/>",					Type:"Text",		Hidden:0,	Width:90,	Align:"Left",	ColMerge:0,	SaveName:"qOrgNm",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
		{Header:"<sht:txt mid='sabun' mdef='사번'/>",					Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30},
		{Header:"<sht:txt mid='name' mdef='성명'/>",					Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:30},
		{Header:"<sht:txt mid='jikweeCd' mdef='직위'/>",				Type:"Text",		Hidden:Number("${jwHdn}"),	Width:90,	Align:"Left",	ColMerge:0,	SaveName:"jikweeNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
		{Header:"<sht:txt mid='jikgubNm' mdef='직급'/>",				Type:"Text",		Hidden:Number("${jgHdn}"),	Width:90,	Align:"Left",	ColMerge:0,	SaveName:"jikgubNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
		{Header:"<sht:txt mid='workType' mdef='직종'/>",				Type:"Text",		Hidden:0,	Width:90,	Align:"Left",	ColMerge:0,	SaveName:"workTypeNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
		{Header:"<sht:txt mid='payType' mdef='급여유형'/>",			Type:"Text",		Hidden:0,	Width:90,	Align:"Left",	ColMerge:0,	SaveName:"payTypeNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
		{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",				Type:"Text",		Hidden:Number("${aliasHdn}"),	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"alias",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30},
		{Header:"<sht:txt mid='ymV2' mdef='년월'/>",					Type:"Date",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"ym",				KeyField:1,	Format:"Ym",PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:7},
		{Header:"<sht:txt mid='gntCdV5' mdef='근태코드'/>",				Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"gntCd",			KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:8},
		{Header:"<sht:txt mid='gntCnt' mdef='발생일수'/>",				Type:"Int",			Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"gntCnt",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
		{Header:"<sht:txt mid='payType' mdef='급여유형'/>",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"payType",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
		{Header:"<sht:txt mid='businessPlaceCdV1' mdef='사업장코드'/>",	Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"businessPlaceCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100}
	]; IBS_InitSheet(tab1Sheet, initdata1); tab1Sheet.SetCountPosition(0);
	var gntCdList = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getCpnGntCdList"), "<tit:txt mid='103895' mdef='전체'/>");//getWorkCdList
	tab1Sheet.SetColProperty("gntCd", {ComboText:"|"+gntCdList[0], ComboCode:"|"+gntCdList[1]});

	$(window).smartresize(sheetResize);
	sheetInit();
	IBS_setChunkedOnSave("tab1Sheet", {chunkSize : 25});
	
	pGubun = "employeePopup";
    $(tab1Sheet).sheetAutocomplete({
        Columns: [
            {
                ColSaveName  : "name",
                CallbackFunc : function(returnValue){
					GetTab1ReturnValue(returnValue);
                }
            }
        ]
    });
});

const doActionSheet1 = {
	"Search": () => {
		tab1Sheet.DoSearch("${ctx}/MonthWorkMgr.do?cmd=getMonthWorkDayTab", $("#mainForm").serialize());
	},
	"Save": () => {
		if(!dupChk(tab1Sheet, "ym|sabun|gntCd", false, true)) {return;}
		IBS_SaveName(document.mainForm, tab1Sheet);
		tab1Sheet.DoSave("${ctx}/MonthWorkMgr.do?cmd=saveMonthWorkDayTab", $("#mainForm").serialize());
	},
	"Insert": () => {
		var Row = tab1Sheet.DataInsert(0);
		tab1Sheet.SetCellValue(Row, "ym", $("#searchYm").val());
		tab1Sheet.SelectCell(Row, 2);
	},
	"Copy": () => {
		var Row = tab1Sheet.DataCopy();
		tab1Sheet.SelectCell(Row, 2);
	},
	"Clear": () => {
		tab1Sheet.RemoveAll();
	},
	"Down2Excel": () => {
		//삭제/상태/hidden 지우고 엑셀내려받기
		var downcol = makeHiddenSkipCol(tab1Sheet);
		var param  = {DownCols:downcol, SheetDesign:1, Merge:1};
		tab1Sheet.Down2Excel(param);
	},
	"LoadExcel": () => {
		// 업로드
		var params = {};
		tab1Sheet.LoadExcel(params);
	},
	"DownTemplate": () => {
		// 양식다운로드
		tab1Sheet.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"sabun|ym|gntCd|gntCnt"});
	}
}

function doAction1(sAction) {
	switch (sAction) {
		case "Search":
			tab1Sheet.DoSearch("${ctx}/MonthWorkMgr.do?cmd=getMonthWorkDayTab", $("#mainForm", parent.document).serialize());
			break;

		case "Save":
			// 중복체크
			if(!dupChk(tab1Sheet, "ym|sabun|gntCd", false, true)) {break;}
			IBS_SaveName(document.mainForm,tab1Sheet);
			tab1Sheet.DoSave("${ctx}/MonthWorkMgr.do?cmd=saveMonthWorkDayTab", $("#mainForm").serialize());
			break;

		case "Insert":
			var Row = tab1Sheet.DataInsert(0);
			tab1Sheet.SetCellValue(Row, "ym", $("#searchYm", parent.document).val());
			tab1Sheet.SelectCell(Row, 2);
			break;

		case "Copy":
			var Row = tab1Sheet.DataCopy();
			tab1Sheet.SelectCell(Row, 2);
			break;

		case "Clear":
			tab1Sheet.RemoveAll();
			break;

		case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(tab1Sheet);
			var param  = {DownCols:downcol, SheetDesign:1, Merge:1};
			tab1Sheet.Down2Excel(param);
			break;
		case "LoadExcel":
			// 업로드
			var params = {};
			tab1Sheet.LoadExcel(params);
			break;
		case "DownTemplate":
			// 양식다운로드
			var downcol = makeHiddenSkipCol(tab1Sheet);
			tab1Sheet.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"sabun|ym|gntCd|gntCnt"});
			break;
	}
}

// 조회 후 에러 메시지
function tab1Sheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

// 저장 후 메시지
function tab1Sheet_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try {
			if (Msg != "") {
				alert(Msg);
			}
			doActionSheet1.Search();
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
}

function GetTab1ReturnValue(returnValue) {
	var rv = $.parseJSON('{' + returnValue+ '}');

	tab1Sheet.SetCellValue(gPRow, "name",			rv["name"] );
	tab1Sheet.SetCellValue(gPRow, "sabun",			rv["sabun"] );
	tab1Sheet.SetCellValue(gPRow, "alias",			rv["alias"] );
	tab1Sheet.SetCellValue(gPRow, "jikgubNm",		rv["jikgubNm"] );
	tab1Sheet.SetCellValue(gPRow, "jikweeNm",		rv["jikweeNm"] );
	tab1Sheet.SetCellValue(gPRow, "qOrgNm",		rv["orgNm"] );
	tab1Sheet.SetCellValue(gPRow, "locationNm",	rv["locationNm"] );
	tab1Sheet.SetCellValue(gPRow, "workTypeNm",	rv["workTypeNm"] );
	tab1Sheet.SetCellValue(gPRow, "payTypeNm",		rv["payTypeNm"] );
}
</script>
<div class="wrapper">
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td class="top">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='monthWorkDayTab' mdef='월근태일수'/></li>
							<li class="btn">
								<btn:a href="javascript:doActionSheet1.Down2Excel()"		css="btn outline-gray authR" mid="download" mdef="다운로드"/>
								<btn:a href="javascript:doActionSheet1.DownTemplate()"	css="btn outline-gray authA" mid="down2ExcelV1" mdef="양식다운로드"/>
								<btn:a href="javascript:doActionSheet1.LoadExcel()" 		css="btn outline-gray authA" mid="upload" mdef="업로드"/>
								<btn:a href="javascript:doActionSheet1.Copy()"			css="btn outline-gray authA" mid="copy" mdef="복사"/>
								<btn:a href="javascript:doActionSheet1.Insert()"			css="btn outline-gray authA" mid="insert" mdef="입력"/>
								<btn:a href="javascript:doActionSheet1.Save()"			css="btn filled authA" mid="save" mdef="저장"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("tab1Sheet", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>