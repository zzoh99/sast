<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">

var gPRow = "";
var pGubun = "";

	$(function() {
		$.extend(doAction, { "tab5Sheet": doActionSheet5 });

		init_tab5Sheet();
	});

	//Sheet 초기화
	function init_tab5Sheet(){
		var titleList = ajaxCall("${ctx}/DailyWorkMgr.do?cmd=getDailyWorkMgrHeaderList", $("#sheetForm").serialize(), false);
		if (titleList != null && titleList.DATA != null) {

			tab5Sheet.Reset();

			var v=0;
			var initdata1 = {};
			initdata1.Cfg = {SearchMode:smLazyLoad,Page:50, MergeSheet:msNone,FrozenCol:9};
			initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};

			initdata1.Cols = [];
			initdata1.Cols[v++] = {Header:"<sht:txt mid='sNo' mdef='No'/>",						Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:Number("${sNoWdt}"),  Align:"Center", ColMerge:0,   SaveName:"sNo" };
			initdata1.Cols[v++] = {Header:"<sht:txt mid='sDelete' mdef='삭제'/>",					Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),  Width:Number("${sDelWdt}"), Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0};
			initdata1.Cols[v++] = {Header:"<sht:txt mid='statusCd' mdef='상태'/>",				Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),  Width:Number("${sSttWdt}"), Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0};
			initdata1.Cols[v++] = {Header:"<sht:txt mid='businessPlaceNm' mdef='사업장'/>",		Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"businessPlaceNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0};
			initdata1.Cols[v++] = {Header:"<sht:txt mid='businessPlaceCdV1' mdef='사업장코드'/>",	Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"businessPlaceCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1};
			initdata1.Cols[v++] = {Header:"<sht:txt mid='locationCd' mdef='근무지'/>",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"locationNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0 };

			initdata1.Cols[v++] = {Header:"<sht:txt mid='orgNm' mdef='소속'/>",					Type:"Text",		Hidden:0,	Width:90,	Align:"Left",	ColMerge:0,	SaveName:"qOrgNm",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0};
			initdata1.Cols[v++] = {Header:"<sht:txt mid='sabun' mdef='사번'/>",					Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0};
			initdata1.Cols[v++] = {Header:"<sht:txt mid='name' mdef='성명'/>",					Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1};
			initdata1.Cols[v++] = {Header:"<sht:txt mid='jikweeCd' mdef='직위'/>",				Type:"Text",		Hidden:Number("${jwHdn}"),	Width:90,	Align:"Left",	ColMerge:0,	SaveName:"jikweeNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			initdata1.Cols[v++] = {Header:"<sht:txt mid='jikgubNm' mdef='직급'/>",				Type:"Text",		Hidden:Number("${jgHdn}"),	Width:90,	Align:"Left",	ColMerge:0,	SaveName:"jikgubNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			initdata1.Cols[v++] = {Header:"<sht:txt mid='workType' mdef='직종'/>",				Type:"Text",		Hidden:0,	Width:90,	Align:"Left",	ColMerge:0,	SaveName:"workTypeNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0};
			initdata1.Cols[v++] = {Header:"<sht:txt mid='payType' mdef='급여유형'/>",				Type:"Text",		Hidden:0,	Width:90,	Align:"Left",	ColMerge:0,	SaveName:"payTypeNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0};
			initdata1.Cols[v++] = {Header:"<sht:txt mid='ymV2' mdef='년월'/>",					Type:"Date",		Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"ym",				KeyField:0,	Format:"Ym",PointCount:0,	UpdateEdit:0,	InsertEdit:1};
			initdata1.Cols[v++] = {Header:"근무일자",												Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"ymd",				KeyField:1,	Format:"Ymd",  PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10};

			var i = 0 ;
			for(; i<titleList.DATA.length; i++) {
				initdata1.Cols[v++] = {Header:titleList.DATA[i].codeNm,	Type:"Float",	Hidden:0,	Width:55,	Align:"Center",	ColMerge:1,	SaveName:titleList.DATA[i].saveNameDisp,	KeyField:0,	Format:"",	PointCount:2,	UpdateEdit:1,	InsertEdit:1,	EditLen:22 };
			}
			//initdata1.Cols[v++] = {Header:"temp",Type:"AutoSum",		Hidden:1,  Width:50,   Align:"Center", 	ColMerge:1,   SaveName:"temp",		KeyField:0,   CalcLogic:"",   Format:"",       PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 };

			IBS_InitSheet(tab5Sheet, initdata1);tab5Sheet.SetEditable("${editable}");tab5Sheet.SetVisible(true);tab5Sheet.SetCountPosition(4);
			tab5Sheet.SetWaitTimeOut(120);

			$(window).smartresize(sheetResize); sheetInit();
			// 저장 시 분할 저장 설정 (대량업로드 대비)
			IBS_setChunkedOnSave("tab5Sheet", {chunkSize : 25});
		    $(tab5Sheet).sheetAutocomplete({
		        Columns: [
		            {
		                ColSaveName  : "name",
		                CallbackFunc : function(returnValue){
		                    getTab5ReturnValue(returnValue);
		                }
		            }
		        ]
		    }); 
		    
		}else{
			alert("오류");
			return false;
		}
		return true;
	}

const doActionSheet5 = {
	"Search": () => {
		if( !init_tab5Sheet() ) return;
		tab5Sheet.DoSearch("${ctx}/MonthWorkMgr.do?cmd=getMonthWorkTimeTab2", $("#mainForm").serialize());
	},
	"Save": () => {
		// 중복체크
		if(!dupChk(tab5Sheet, "sabun|ymd|workCd", false, true)) {return;}
		IBS_SaveName(document.mainForm, tab5Sheet);
		tab5Sheet.DoSave("${ctx}/MonthWorkMgr.do?cmd=saveMonthWorkTimeTab2", $("#mainForm").serialize());
	},
	"Insert": () => {
		var Row = tab5Sheet.DataInsert(0);
		tab5Sheet.SetCellValue(Row, "ym", $("#searchYm").val());
		tab5Sheet.SelectCell(Row, 2);
	},
	"Copy": () => {
		var Row = tab5Sheet.DataCopy();
		tab5Sheet.SelectCell(Row, 2);
	},
	"Clear": () => {
		tab5Sheet.RemoveAll();
	},
	"Down2Excel": () => {
		//삭제/상태/hidden 지우고 엑셀내려받기
		var downcol = makeHiddenSkipCol(tab5Sheet);
		var param  = {DownCols:downcol, SheetDesign:1, Merge:1};
		tab5Sheet.Down2Excel(param);
	},
	"LoadExcel": () => {
		// 업로드
		var params = {};
		tab5Sheet.LoadExcel(params);
	},
	"DownTemplate": () => {
		// 양식다운로드
		var sdowncols = "sabun";

		for (var i = tab5Sheet.SaveNameCol("ymd"); i <= tab5Sheet.LastCol(); i++) {
			if (tab5Sheet.GetColHidden(i) == 0) sdowncols += "|" + i.toString();
		}
		tab5Sheet.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:sdowncols});
	}
};

	//tab5Sheet Action
	function doAction5(sAction) {
		switch (sAction) {
			case "Search":
				if( !init_tab5Sheet() ) return;
				$("#searchYm").val($("#searchYm", parent.document).val());
				//tab5Sheet.DoSearch("${ctx}/MonthWorkMgr.do?cmd=getMonthWorkTimeTab2", $("#tab5SheetForm").serialize());
				tab5Sheet.DoSearch("${ctx}/MonthWorkMgr.do?cmd=getMonthWorkTimeTab2", $("#mainForm", parent.document).serialize());
				break;

			case "Save":
				// 중복체크
				if(!dupChk(tab5Sheet, "sabun|ymd|workCd", false, true)) {break;}
				$("#searchYm").val($("#searchYm", parent.document).val());
				IBS_SaveName(document.tab5SheetForm,tab5Sheet);
				tab5Sheet.DoSave("${ctx}/MonthWorkMgr.do?cmd=saveMonthWorkTimeTab2", $("#tab5SheetForm").serialize());
				break;

			case "Insert":
				var Row = tab5Sheet.DataInsert(0);
				tab5Sheet.SetCellValue(Row, "ym", $("#searchYm", parent.document).val());
				tab5Sheet.SelectCell(Row, 2);
				break;

			case "Copy":
				var Row = tab5Sheet.DataCopy();
				tab5Sheet.SelectCell(Row, 2);
				break;

			case "Clear":
				tab5Sheet.RemoveAll();
				break;

			case "Down2Excel":
				//삭제/상태/hidden 지우고 엑셀내려받기
				var downcol = makeHiddenSkipCol(tab5Sheet);
				var param  = {DownCols:downcol, SheetDesign:1, Merge:1};
				tab5Sheet.Down2Excel(param);
				break;
			case "LoadExcel":
				// 업로드
				var params = {};
				tab5Sheet.LoadExcel(params);
				break;
			case "DownTemplate":
				// 양식다운로드
				var sdowncols = "sabun";

				for (var i = tab5Sheet.SaveNameCol("ymd"); i <= tab5Sheet.LastCol(); i++) {
					if (tab5Sheet.GetColHidden(i) == 0) sdowncols += "|" + i.toString();
				}
				tab5Sheet.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:sdowncols});
				break;
		}
	}

	//---------------------------------------------------------------------------------------------------------------
	// tab5Sheet Event
	//---------------------------------------------------------------------------------------------------------------

	// 조회 후 에러 메시지
	function tab5Sheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function tab5Sheet_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			if( Code > -1 ) doActionSheet5.Search();
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function getTab5ReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

		tab5Sheet.SetCellValue(gPRow, "name",			rv["name"] );
		tab5Sheet.SetCellValue(gPRow, "sabun",			rv["sabun"] );
		tab5Sheet.SetCellValue(gPRow, "alias",			rv["alias"] );
		tab5Sheet.SetCellValue(gPRow, "jikgubNm",		rv["jikgubNm"] );
		tab5Sheet.SetCellValue(gPRow, "jikweeNm",		rv["jikweeNm"] );
		tab5Sheet.SetCellValue(gPRow, "qOrgNm",		rv["orgNm"] );
		tab5Sheet.SetCellValue(gPRow, "locationNm",	rv["locationNm"] );
		tab5Sheet.SetCellValue(gPRow, "workTypeNm",	rv["workTypeNm"] );
		tab5Sheet.SetCellValue(gPRow, "payTypeNm",		rv["payTypeNm"] );
	}
</script>
<div class="wrapper">
	<div class="sheet_title inner">
		<ul>
			<li class="txt">일근무시간</li>
			<li class="btn">
				<a href="javascript:doActionSheet5.Down2Excel()"	class="btn outline-gray authR">다운로드</a>
				<a href="javascript:doActionSheet5.DownTemplate()"	class="btn outline-gray authA">양식다운로드</a>
				<a href="javascript:doActionSheet5.LoadExcel()" 	class="btn outline-gray authA">업로드</a>
				<a href="javascript:doActionSheet5.Copy()"			class="btn outline-gray authA">복사</a>
				<a href="javascript:doActionSheet5.Insert()"		class="btn outline-gray authA">입력</a>
				<a href="javascript:doActionSheet5.Save()"			class="btn filled authA">저장</a>
			</li>
		</ul>
	</div>
	<script type="text/javascript"> createIBSheet("tab5Sheet", "100%", "100%"); </script>
</div>