<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">

var gPRow = "";
var pGubun = "";

	$(function() {
		$.extend(doAction, { "tab5Sheet": doActionSheet5 });
	});

	//Sheet 초기화
	function initTab5Sheet() {
		var titleList = ajaxCall("${ctx}/WtmMonthlyCountMgr.do?cmd=getWtmMonthlyCountMgrHeaders", $("#sheetForm").serialize() + "&searchReportTypeCd=A", false);
		if (titleList != null && titleList.DATA != null) {

			tab5Sheet.Reset();

			var v=0;
			var initdata1 = {};
			initdata1.Cfg = {SearchMode:smLazyLoad,Page:50, MergeSheet:msNone,FrozenCol:9};
			initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};

			initdata1.Cols = [];
			initdata1.Cols.push({Header:"<sht:txt mid='sNo' mdef='No'/>",					Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:Number("${sNoWdt}"),  Align:"Center", ColMerge:0,   SaveName:"sNo" });
			initdata1.Cols.push({Header:"<sht:txt mid='sDelete' mdef='삭제'/>",				Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),  Width:Number("${sDelWdt}"), Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0 });
			initdata1.Cols.push({Header:"<sht:txt mid='statusCd' mdef='상태'/>",				Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),  Width:Number("${sSttWdt}"), Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0 });
			initdata1.Cols.push({Header:"<sht:txt mid='businessPlaceNm' mdef='사업장'/>",	Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"businessPlaceCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen: 100 });
			initdata1.Cols.push({Header:"<sht:txt mid='locationCd' mdef='근무지'/>",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"locationNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0 });

			initdata1.Cols.push({Header:"<sht:txt mid='orgNm' mdef='소속'/>",				Type:"Text",		Hidden:0,	Width:90,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 });
			initdata1.Cols.push({Header:"<sht:txt mid='sabun' mdef='사번'/>",				Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 });
			initdata1.Cols.push({Header:"<sht:txt mid='name' mdef='성명'/>",					Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen: 30 });
			initdata1.Cols.push({Header:"<sht:txt mid='jikweeCd' mdef='직위'/>",				Type:"Text",		Hidden:Number("${jwHdn}"),	Width:90,	Align:"Left",	ColMerge:0,	SaveName:"jikweeNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 });
			initdata1.Cols.push({Header:"<sht:txt mid='jikgubNm' mdef='직급'/>",				Type:"Text",		Hidden:Number("${jgHdn}"),	Width:90,	Align:"Left",	ColMerge:0,	SaveName:"jikgubNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 });
			initdata1.Cols.push({Header:"<sht:txt mid='workType' mdef='직종'/>",				Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"workTypeNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 });
			initdata1.Cols.push({Header:"<sht:txt mid='payType' mdef='급여유형'/>",			Type:"Combo",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"payType",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen: 10 });
			initdata1.Cols.push({Header:"<sht:txt mid='ymV2' mdef='년월'/>",					Type:"Date",		Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"ym",				KeyField:0,	Format:"Ym",PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen: 7 });
			initdata1.Cols.push({Header:"근무일자",											Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"ymd",				KeyField:1,	Format:"Ymd",  PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 });

			var i = 0 ;
			for(; i<titleList.DATA.length; i++) {
				initdata1.Cols.push({Header:titleList.DATA[i].codeNm,	Type:"Float",	Hidden:0,	Width:55,	Align:"Center",	ColMerge:1,	SaveName:titleList.DATA[i].saveNameDisp,	KeyField:0,	Format:"",	PointCount:2,	UpdateEdit:1,	InsertEdit:1,	EditLen:22 });
				doAction.tab5Sheet.sdowncols += "|" + titleList.DATA[i].saveNameDisp;
			}

			IBS_InitSheet(tab5Sheet, initdata1);tab5Sheet.SetEditable("${editable}");tab5Sheet.SetVisible(true);tab5Sheet.SetCountPosition(4);
			tab5Sheet.SetWaitTimeOut(120);

			tab5Sheet.SetColProperty("businessPlaceCd", {ComboText:commonCodes["businessPlaceCd"][0], ComboCode:commonCodes["businessPlaceCd"][1]});
			tab5Sheet.SetColProperty("payType", {ComboText:"|"+commonCodes["payType"][0], ComboCode:"|"+commonCodes["payType"][1]});

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
		isInit: false,
		"init": function() {
			if (!doAction.tab5Sheet.isInit) {
				initTab5Sheet();
				doAction.tab5Sheet.isInit = true;
				doAction.tab5Sheet.Search();
			}
		},
		"Search": function() {
			tab5Sheet.DoSearch("${ctx}/WtmMonthlyCountMgr.do?cmd=getWtmMonthlyCountMgrDailyWorkTimeByCodes", $("#mainForm").serialize());
		},
		"Save": function() {
			// 중복체크
			if(!dupChk(tab5Sheet, "ym|businessPlaceCd|sabun|ymd|reportItemCd", false, true)) {return;}
			IBS_SaveName(document.mainForm, tab5Sheet);
			tab5Sheet.DoSave("${ctx}/WtmMonthlyCountMgr.do?cmd=saveWtmMonthlyCountMgrDailyWorkTimeByCodes", $("#mainForm").serialize());
		},
		"Insert": function() {
			var Row = tab5Sheet.DataInsert(0);
			tab5Sheet.SetCellValue(Row, "ym", $("#searchYm").val());
			tab5Sheet.SelectCell(Row, 2);
		},
		"Copy": function() {
			var Row = tab5Sheet.DataCopy();
			tab5Sheet.SelectCell(Row, 2);
		},
		"Clear": function() {
			tab5Sheet.RemoveAll();
		},
		"Down2Excel": function() {
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(tab5Sheet);
			var param  = {DownCols:downcol, SheetDesign:1, Merge:1};
			tab5Sheet.Down2Excel(param);
		},
		"LoadExcel": function() {
			// 업로드
			var params = {};
			tab5Sheet.LoadExcel(params);
		},
		sdowncols: "ym|sabun|ymd|reportItemCd",
		"DownTemplate": function() {
			// 양식다운로드
			tab5Sheet.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:doAction.tab5Sheet.sdowncols});
		}
	};

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

		tab5Sheet.SetCellValue(gPRow, "name",				rv["name"] );
		tab5Sheet.SetCellValue(gPRow, "sabun",				rv["sabun"] );
		tab5Sheet.SetCellValue(gPRow, "alias",				rv["alias"] );
		tab5Sheet.SetCellValue(gPRow, "jikgubNm",			rv["jikgubNm"] );
		tab5Sheet.SetCellValue(gPRow, "jikweeNm",			rv["jikweeNm"] );
		tab5Sheet.SetCellValue(gPRow, "orgNm",				rv["orgNm"] );
		tab5Sheet.SetCellValue(gPRow, "locationNm",			rv["locationNm"] );
		tab5Sheet.SetCellValue(gPRow, "workTypeNm",			rv["workTypeNm"] );
		tab5Sheet.SetCellValue(gPRow, "payTypeNm",			rv["payTypeNm"] );
		tab5Sheet.SetCellValue(gPRow, "businessPlaceCd",	rv["businessPlaceCd"] );
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