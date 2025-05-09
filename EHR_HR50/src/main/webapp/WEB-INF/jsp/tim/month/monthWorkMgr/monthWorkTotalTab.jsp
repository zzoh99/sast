<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";

$(function() {
	$.extend(doAction, { "tab4Sheet": doActionSheet4 });

	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};
	initdata1.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
		{Header:"<sht:txt mid='statusCd' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
		{Header:"<sht:txt mid='businessPlaceNm' mdef='사업장'/>",		Type:"Text",		Hidden:0,					Width:100,	Align:"Center",	ColMerge:0,	SaveName:"businessPlaceNm",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
		{Header:"<sht:txt mid='locationCd' mdef='근무지'/>",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"locationNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='orgNm' mdef='소속'/>",					Type:"Text",		Hidden:0,					Width:90,	Align:"Left",	ColMerge:0,	SaveName:"qOrgNm",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
		{Header:"<sht:txt mid='sabun' mdef='사번'/>",					Type:"Text",		Hidden:0,					Width:70,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30},
		{Header:"<sht:txt mid='name' mdef='성명'/>",					Type:"Text",		Hidden:0,					Width:70,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:30},
		{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",				Type:"Text",		Hidden:Number("${aliasHdn}"),Width:70,	Align:"Center",	ColMerge:0,	SaveName:"alias",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30},
		{Header:"<sht:txt mid='jikweeCd' mdef='직위'/>",				Type:"Text",		Hidden:Number("${jwHdn}"),	Width:90,	Align:"Left",	ColMerge:0,	SaveName:"jikweeNm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
		{Header:"<sht:txt mid='jikgubNm' mdef='직급'/>",				Type:"Text",		Hidden:Number("${jgHdn}"),	Width:90,	Align:"Left",	ColMerge:0,	SaveName:"jikgubNm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
		{Header:"<sht:txt mid='workType' mdef='직종'/>",				Type:"Text",		Hidden:0,					Width:90,	Align:"Left",	ColMerge:0,	SaveName:"workTypeNm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
		{Header:"<sht:txt mid='payType' mdef='급여유형'/>",			Type:"Text",		Hidden:0,					Width:90,	Align:"Left",	ColMerge:0,	SaveName:"payTypeNm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
		{Header:"<sht:txt mid='ymV2' mdef='년월'/>",					Type:"Date",		Hidden:0,					Width:70,	Align:"Center",	ColMerge:0,	SaveName:"ym",				KeyField:1,	Format:"Ym",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:7},
		{Header:"<sht:txt mid='applyYy' mdef='적용일'/>",				Type:"Text",		Hidden:1,					Width:70,	Align:"Center",	ColMerge:0,	SaveName:"applyYy",			KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:8},
		{Header:"<sht:txt mid='workDdCd' mdef='근무일집계코드'/>",		Type:"Combo",		Hidden:0,					Width:100,	Align:"Center",	ColMerge:0,	SaveName:"workDdCd",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:8},
		{Header:"<sht:txt mid='workDdCnt' mdef='근무일수'/>",			Type:"Int",			Hidden:0,					Width:100,	Align:"Center",	ColMerge:0,	SaveName:"workDdCnt",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
		{Header:"<sht:txt mid='payType' mdef='급여유형'/>",			Type:"Text",		Hidden:1,					Width:100,	Align:"Center",	ColMerge:0,	SaveName:"payType",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
		{Header:"<sht:txt mid='businessPlaceCdV1' mdef='사업장코드'/>",	Type:"Text",		Hidden:1,					Width:100,	Align:"Center",	ColMerge:0,	SaveName:"businessPlaceCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100}
	]; IBS_InitSheet(tab4Sheet, initdata1); tab4Sheet.SetCountPosition(0);
	var workDdCdList = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","T10019"), "<tit:txt mid='103895' mdef='전체'/>");

	tab4Sheet.SetColProperty("workDdCd", {ComboText:"|"+workDdCdList[0], ComboCode:"|"+workDdCdList[1]});

	$(window).smartresize(sheetResize);
	sheetInit();
	// 저장 시 분할 저장 설정 (대량업로드 대비)
	IBS_setChunkedOnSave("tab4Sheet", {chunkSize : 25});
    $(tab4Sheet).sheetAutocomplete({
        Columns: [
            {
                ColSaveName  : "name",
                CallbackFunc : function(returnValue){
                    getTab4ReturnValue(returnValue);
                }
            }
        ]
    }); 
});

const doActionSheet4 = {
	"Search": () => {
		tab4Sheet.DoSearch("${ctx}/MonthWorkMgr.do?cmd=getMonthWorkTotalTab", $("#mainForm").serialize());
	},
	"Save": () => {
		// 중복체크
		if(!dupChk(tab4Sheet, "applyYy|ym|sabun|workDdCd", false, true)) {return;}
		IBS_SaveName(document.mainForm, tab4Sheet);
		tab4Sheet.DoSave("${ctx}/MonthWorkMgr.do?cmd=saveMonthWorkTotalTab",  $("#mainForm").serialize());
	},
	"Insert": () => {
		var Row = tab4Sheet.DataInsert(0);
		tab4Sheet.SetCellValue(Row, "ym", $("#searchYm").val());
		tab4Sheet.SelectCell(Row, 2);
	},
	"Copy": () => {
		var Row = tab4Sheet.DataCopy();
		tab4Sheet.SelectCell(Row, 2);
	},
	"Clear": () => {
		tab4Sheet.RemoveAll();
	},
	"Down2Excel": () => {
		//삭제/상태/hidden 지우고 엑셀내려받기
		var downcol = makeHiddenSkipCol(tab4Sheet);
		var param  = {DownCols:downcol, SheetDesign:1, Merge:1};
		tab4Sheet.Down2Excel(param);
	},
	"LoadExcel": () => {
		// 업로드
		var params = {};
		tab4Sheet.LoadExcel(params);
	},
	"DownTemplate": () => {
		// 양식다운로드
		tab4Sheet.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"sabun|ym|workDdCd|workDdCnt"});
	}
};

function doAction4(sAction) {
	switch (sAction) {
		case "Search":
			tab4Sheet.DoSearch("${ctx}/MonthWorkMgr.do?cmd=getMonthWorkTotalTab", $("#mainForm", parent.document).serialize());
			break;

		case "Save":
			// 중복체크
			if(!dupChk(tab4Sheet, "applyYy|ym|sabun|workDdCd", false, true)) {break;}
			IBS_SaveName(document.mainForm,tab4Sheet);
			tab4Sheet.DoSave("${ctx}/MonthWorkMgr.do?cmd=saveMonthWorkTotalTab",  $("#mainForm").serialize());
			break;

		case "Insert":
			var Row = tab4Sheet.DataInsert(0);
			tab4Sheet.SetCellValue(Row, "ym", $("#searchYm", parent.document).val());
			tab4Sheet.SelectCell(Row, 2);
			break;

		case "Copy":
			var Row = tab4Sheet.DataCopy();
			tab4Sheet.SelectCell(Row, 2);
			break;

		case "Clear":
			tab4Sheet.RemoveAll();
			break;

		case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(tab4Sheet);
			var param  = {DownCols:downcol, SheetDesign:1, Merge:1};
			tab4Sheet.Down2Excel(param);
			break;
		case "LoadExcel":
			// 업로드
			var params = {};
			tab4Sheet.LoadExcel(params);
			break;
		case "DownTemplate":
			// 양식다운로드
			var downcol = makeHiddenSkipCol(tab4Sheet);
			tab4Sheet.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"sabun|ym|workDdCd|workDdCnt"});
			break;
	}
}

function tab4Sheet_OnLoadExcel() {
	for(var i = 1; i < tab4Sheet.RowCount()+1; i++) {
		if(tab4Sheet.GetCellValue(i,"applyYy") == "") {
			tab4Sheet.SetCellValue(i, "applyYy", tab4Sheet.GetCellValue(i, "ym").substring(0,4)) ;
		}
	}
}

function tab4Sheet_OnChange(Row, Col, Value) {
	 try{
		if(Row > 0 && tab4Sheet.ColSaveName(Col) == "ym"){
			tab4Sheet.SetCellValue(Row, "applyYy", tab4Sheet.GetCellValue(Row, "ym").substring(0,4)) ;
		}
	 }catch(ex){alert("OnChange Event Error : " + ex);}
}
// 조회 후 에러 메시지
function tab4Sheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

// 저장 후 메시지
function tab4Sheet_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } doActionSheet4.Search(); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}

function getTab4ReturnValue(returnValue) {
	var rv = $.parseJSON('{' + returnValue+ '}');

    //if(pGubun == "employeePopup"){
        tab4Sheet.SetCellValue(gPRow, "name",			rv["name"] );
        tab4Sheet.SetCellValue(gPRow, "sabun",			rv["sabun"] );
        tab4Sheet.SetCellValue(gPRow, "alias",			rv["alias"] );
        tab4Sheet.SetCellValue(gPRow, "jikgubNm",		rv["jikgubNm"] );
        tab4Sheet.SetCellValue(gPRow, "jikweeNm",		rv["jikweeNm"] );
        tab4Sheet.SetCellValue(gPRow, "qOrgNm",		rv["orgNm"] );
        tab4Sheet.SetCellValue(gPRow, "locationNm",	rv["locationNm"] );
        tab4Sheet.SetCellValue(gPRow, "workTypeNm",	rv["workTypeNm"] );
        tab4Sheet.SetCellValue(gPRow, "payTypeNm",		rv["payTypeNm"] );
    //}
}
</script>
<div class="wrapper">
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td class="top">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='monthWorkDayTab' mdef='월근무일수집계'/></li>
							<li class="btn">
								<btn:a href="javascript:doActionSheet4.Down2Excel()"	css="btn outline-gray authR" mid="download" mdef="다운로드"/>
								<btn:a href="javascript:doActionSheet4.DownTemplate()"	css="btn outline-gray authA" mid="down2ExcelV1" mdef="양식다운로드"/>
								<btn:a href="javascript:doActionSheet4.LoadExcel()" 	css="btn outline-gray authA" mid="upload" mdef="업로드"/>
								<btn:a href="javascript:doActionSheet4.Copy()"			css="btn outline-gray authA" mid="copy" mdef="복사"/>
								<btn:a href="javascript:doActionSheet4.Insert()"		css="btn outline-gray authA" mid="insert" mdef="입력"/>
								<btn:a href="javascript:doActionSheet4.Save()"			css="btn filled authA" mid="save" mdef="저장"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("tab4Sheet", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>