<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {
		$.extend(doAction, { "tab2Sheet": doActionSheet2 });
	});

	const doActionSheet2 = {
		isInit: false,
		"init": function() {
			if (!doAction.tab2Sheet.isInit) {
				initTab2Sheet();
				doAction.tab2Sheet.isInit = true;
				doAction.tab2Sheet.Search();
			}
		},
		"Search": function() {
			tab2Sheet.DoSearch("${ctx}/WtmMonthlyCountMgr.do?cmd=getWtmMonthlyCountMgrWorkTimeByCodes", $("#mainForm").serialize());
		},
		"Save": function() {
			// 중복체크
			if(!dupChk(tab2Sheet, "ym|businessPlaceCd|sabun", false, true)) {return;}
			IBS_SaveName(document.mainForm, tab2Sheet);
			tab2Sheet.DoSave("${ctx}/WtmMonthlyCountMgr.do?cmd=saveWtmMonthlyCountMgrWorkTimeByCodes", $("#mainForm").serialize());
		},
		"Insert": function() {
			var Row = tab2Sheet.DataInsert(0);
			tab2Sheet.SetCellValue(Row, "ym", $("#searchYm").val());
			tab2Sheet.SelectCell(Row, 2);
		},
		"Copy": function() {
			var Row = tab2Sheet.DataCopy();
			tab2Sheet.SelectCell(Row, 2);
		},
		"Clear": function() {
			tab2Sheet.RemoveAll();
		},
		"Down2Excel": function() {
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(tab2Sheet);
			var param  = {DownCols:downcol, SheetDesign:1, Merge:1};
			tab2Sheet.Down2Excel(param);
		},
		"LoadExcel": function() {
			// 업로드
			var params = {};
			tab2Sheet.LoadExcel(params);
		},
		sdowncols: "ym|sabun",
		"DownTemplate": function() {
			// 양식다운로드
			tab2Sheet.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:doAction.tab2Sheet.sdowncols});
		}
	}

	function initTab2Sheet() {

		var titleList = ajaxCall("${ctx}/WtmMonthlyCountMgr.do?cmd=getWtmMonthlyCountMgrHeaders", $("#sheetForm").serialize() + "&searchReportTypeCd=A", false);
		if (titleList != null && titleList.DATA != null) {

			tab2Sheet.Reset();

			var v=0;
			var initdata1 = {};
			initdata1.Cfg = {SearchMode:smLazyLoad,Page:50, MergeSheet:msNone,FrozenCol:9};
			initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};

			initdata1.Cols = [];
			initdata1.Cols.push({Header:"<sht:txt mid='sNo' mdef='No'/>",					Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:Number("${sNoWdt}"),  Align:"Center", ColMerge:0,   SaveName:"sNo" });
			initdata1.Cols.push({Header:"<sht:txt mid='sDelete' mdef='삭제'/>",				Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),  Width:Number("${sDelWdt}"), Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0});
			initdata1.Cols.push({Header:"<sht:txt mid='statusCd' mdef='상태'/>",				Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),  Width:Number("${sSttWdt}"), Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0});
			initdata1.Cols.push({Header:"<sht:txt mid='businessPlaceNm' mdef='사업장'/>",	Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"businessPlaceCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 });
			initdata1.Cols.push({Header:"<sht:txt mid='locationCd' mdef='근무지'/>",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"locationNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 });

			initdata1.Cols.push({Header:"<sht:txt mid='orgNm' mdef='소속'/>",				Type:"Text",		Hidden:0,	Width:90,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 });
			initdata1.Cols.push({Header:"<sht:txt mid='sabun' mdef='사번'/>",				Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 });
			initdata1.Cols.push({Header:"<sht:txt mid='name' mdef='성명'/>",					Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:30 });
			initdata1.Cols.push({Header:"<sht:txt mid='jikweeCd' mdef='직위'/>",				Type:"Text",		Hidden:Number("${jwHdn}"),	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 });
			initdata1.Cols.push({Header:"<sht:txt mid='jikgubNm' mdef='직급'/>",				Type:"Text",		Hidden:Number("${jgHdn}"),	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 });
			initdata1.Cols.push({Header:"<sht:txt mid='workType' mdef='직종'/>",				Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"workTypeNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 });
			initdata1.Cols.push({Header:"<sht:txt mid='payType' mdef='급여유형'/>",			Type:"Combo",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"payType",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 });
			initdata1.Cols.push({Header:"<sht:txt mid='ymV2' mdef='년월'/>",					Type:"Date",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"ym",				KeyField:1,	Format:"Ym",PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:7 });

			for (const title of titleList.DATA) {
				console.log(title);
				initdata1.Cols.push({Header:title.codeNm,	Type:"Float",	Hidden:0,	Width:55,	Align:"Center",	ColMerge:1,	SaveName:title.saveNameDisp,	KeyField:0,	Format:"",	PointCount:2,	UpdateEdit:1,	InsertEdit:1,	EditLen:22 });
				doAction.tab2Sheet.sdowncols += "|" + title.saveNameDisp;
			}

			IBS_InitSheet(tab2Sheet, initdata1); tab2Sheet.SetEditable("${editable}"); tab2Sheet.SetVisible(true); tab2Sheet.SetCountPosition(4);

			tab2Sheet.SetColProperty("businessPlaceCd", {ComboText:commonCodes["businessPlaceCd"][0], ComboCode:commonCodes["businessPlaceCd"][1]});
			tab2Sheet.SetColProperty("payType", {ComboText:"|"+commonCodes["payType"][0], ComboCode:"|"+commonCodes["payType"][1]});

			$(window).smartresize(sheetResize); sheetInit();
			// 저장 시 분할 저장 설정 (대량업로드 대비)
			IBS_setChunkedOnSave("tab2Sheet", {chunkSize : 25});
			$(tab2Sheet).sheetAutocomplete({
				Columns: [
					{
						ColSaveName  : "name",
						CallbackFunc : function(returnValue){
							getTab2ReturnValue(returnValue);
						}
					}
				]
			});
		}
	}

	// 조회 후 에러 메시지
	function tab2Sheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function tab2Sheet_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } doActionSheet2.Search();} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	function getTab2ReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

		tab2Sheet.SetCellValue(gPRow, "name",				rv["name"] );
		tab2Sheet.SetCellValue(gPRow, "sabun",				rv["sabun"] );
		tab2Sheet.SetCellValue(gPRow, "alias",				rv["alias"] );
		tab2Sheet.SetCellValue(gPRow, "jikgubNm",			rv["jikgubNm"] );
		tab2Sheet.SetCellValue(gPRow, "jikweeNm",			rv["jikweeNm"] );
		tab2Sheet.SetCellValue(gPRow, "orgNm",				rv["orgNm"] );
		tab2Sheet.SetCellValue(gPRow, "locationNm",			rv["locationNm"] );
		tab2Sheet.SetCellValue(gPRow, "workTypeNm",			rv["workTypeNm"] );
		tab2Sheet.SetCellValue(gPRow, "payType",			rv["payType"] );
		tab2Sheet.SetCellValue(gPRow, "businessPlaceCd",	rv["businessPlaceCd"] );
	}
</script>
<div class="wrapper">
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td class="top">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">월근무시간</li>
							<li class="btn">
								<btn:a href="javascript:doActionSheet2.Down2Excel()"	css="btn outline-gray authR" mid="download" mdef="다운로드"/>
								<btn:a href="javascript:doActionSheet2.DownTemplate()"	css="btn outline-gray authA" mid="down2ExcelV1" mdef="양식다운로드"/>
								<btn:a href="javascript:doActionSheet2.LoadExcel()" 	css="btn outline-gray authA" mid="upload" mdef="업로드"/>
								<btn:a href="javascript:doActionSheet2.Copy()"			css="btn outline-gray authA" mid="copy" mdef="복사"/>
								<btn:a href="javascript:doActionSheet2.Insert()"		css="btn outline-gray authA" mid="insert" mdef="입력"/>
								<btn:a href="javascript:doActionSheet2.Save()"			css="btn filled authA" mid="save" mdef="저장"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("tab2Sheet", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>