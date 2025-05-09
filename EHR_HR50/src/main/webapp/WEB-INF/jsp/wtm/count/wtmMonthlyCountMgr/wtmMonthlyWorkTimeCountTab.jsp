<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {
		$.extend(doAction, { "tab3Sheet": doActionSheet3 });
	});

	async function initTab3Sheet() {

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad, Page:22};
		initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};
		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='businessPlaceNm' mdef='사업장'/>",	Type:"Combo",		Hidden:0,					Width:100,	Align:"Center",	ColMerge:0,	SaveName:"businessPlaceCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen: 100 },
			{Header:"<sht:txt mid='locationCd' mdef='근무지'/>",			Type:"Text",		Hidden:0,					Width:100,	Align:"Center",	ColMerge:0,	SaveName:"locationNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"<sht:txt mid='orgNm' mdef='소속'/>",				Type:"Text",		Hidden:0,					Width:90,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"<sht:txt mid='sabun' mdef='사번'/>",				Type:"Text",		Hidden:0,					Width:70,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"<sht:txt mid='name' mdef='성명'/>",					Type:"Text",		Hidden:0,					Width:70,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:30},
			{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",			Type:"Text",		Hidden:Number("${aliasHdn}"),Width:70,	Align:"Center",	ColMerge:0,	SaveName:"alias",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"<sht:txt mid='jikweeCd' mdef='직위'/>",				Type:"Text",		Hidden:Number("${jwHdn}"),	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"<sht:txt mid='jikgubNm' mdef='직급'/>",				Type:"Text",		Hidden:Number("${jgHdn}"),	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"<sht:txt mid='workType' mdef='직종'/>",				Type:"Text",		Hidden:0,					Width:90,	Align:"Center",	ColMerge:0,	SaveName:"workTypeNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"<sht:txt mid='payType' mdef='급여유형'/>",			Type:"Combo",		Hidden:0,					Width:90,	Align:"Center",	ColMerge:0,	SaveName:"payType",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen: 10 },
			{Header:"<sht:txt mid='ymV2' mdef='년월'/>",					Type:"Date",		Hidden:0,					Width:70,	Align:"Center",	ColMerge:0,	SaveName:"ym",				KeyField:1,	Format:"Ym",PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:7 },
			{Header:"<sht:txt mid='workCd' mdef='근무코드'/>",			Type:"Combo",		Hidden:0,					Width:100,	Align:"Center",	ColMerge:0,	SaveName:"reportItemCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='workHour' mdef='발생시간'/>(분)",		Type:"Text",		Hidden:0,					Width:100,	Align:"Center",	ColMerge:0,	SaveName:"totMnts",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"payType",											Type:"Text",		Hidden:1,					Width:100,	Align:"Center",	ColMerge:0,	SaveName:"payType",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 }
		]; IBS_InitSheet(tab3Sheet, initdata1); tab3Sheet.SetCountPosition(0);

		tab3Sheet.SetColProperty("businessPlaceCd", {ComboText:commonCodes["businessPlaceCd"][0], ComboCode:commonCodes["businessPlaceCd"][1]});
		tab3Sheet.SetColProperty("payType", {ComboText:"|"+commonCodes["payType"][0], ComboCode:"|"+commonCodes["payType"][1]});

		const data = await getReportItemCdList();
		const reportItemCdList = stfConvCode(data, "");
		tab3Sheet.SetColProperty("reportItemCd", {ComboText:"|"+reportItemCdList[0], ComboCode:"|"+reportItemCdList[1]});

		$(window).smartresize(sheetResize);

		sheetInit();
		// 저장 시 분할 저장 설정 (대량업로드 대비)
		IBS_setChunkedOnSave("tab3Sheet", {chunkSize : 25});

		//Autocomplete
		$(tab3Sheet).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue){
						getTab3ReturnValue(returnValue);
					}
				}
			]
		});
	}

	const doActionSheet3 = {
		isInit: false,
		"init": function() {
			if (!doAction.tab3Sheet.isInit) {
				initTab3Sheet();
				doAction.tab3Sheet.isInit = true;
				doAction.tab3Sheet.Search();
			}
		},
		"Search": function() {
			tab3Sheet.DoSearch("${ctx}/WtmMonthlyCountMgr.do?cmd=getWtmMonthlyCountMgrWorkTime", $("#mainForm").serialize());
		},
		"Save": function() {
			// 중복체크
			if(!dupChk(tab3Sheet, "ym|businessPlaceCd|sabun|reportItemCd", false, true)) {return;}
			IBS_SaveName(document.mainForm, tab3Sheet);
			tab3Sheet.DoSave("${ctx}/WtmMonthlyCountMgr.do?cmd=saveWtmMonthlyCountMgrWorkTime", $("#mainForm").serialize());
		},
		"Insert": function() {
			var Row = tab3Sheet.DataInsert(0);
			tab3Sheet.SetCellValue(Row, "ym", $("#searchYm").val());
			tab3Sheet.SelectCell(Row, 2);
		},
		"Copy": function() {
			var Row = tab3Sheet.DataCopy();
			tab3Sheet.SelectCell(Row, 2);
		},
		"Clear": function() {
			tab3Sheet.RemoveAll();
		},
		"Down2Excel": function() {
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(tab3Sheet);
			var param  = {DownCols:downcol, SheetDesign:1, Merge:1};
			tab3Sheet.Down2Excel(param);
		},
		"LoadExcel": function() {
			// 업로드
			var params = {};
			tab3Sheet.LoadExcel(params);
		},
		"DownTemplate": function() {
			// 양식다운로드
			tab3Sheet.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"ym|sabun|reportItemCd"});
		}
	};

	// 조회 후 에러 메시지
	function tab3Sheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function tab3Sheet_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } doActionSheet3.Search();} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	function getTab3ReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

		tab3Sheet.SetCellValue(gPRow, "sabun",				rv["sabun"]);
		tab3Sheet.SetCellValue(gPRow, "name",				rv["name"]);
		tab3Sheet.SetCellValue(gPRow, "alias",				rv["alias"]);
		tab3Sheet.SetCellValue(gPRow, "orgNm",				rv["orgNm"]);
		tab3Sheet.SetCellValue(gPRow, "jikweeNm",			rv["jikweeNm"]);
		tab3Sheet.SetCellValue(gPRow, "jikgubNm",			rv["jikgubNm"]);
		tab3Sheet.SetCellValue(gPRow, "locationNm",			rv["locationNm"]);
		tab3Sheet.SetCellValue(gPRow, "workTypeNm",			rv["workTypeNm"]);
		tab3Sheet.SetCellValue(gPRow, "payTypeNm",			rv["payTypeNm"]);
		tab3Sheet.SetCellValue(gPRow, "businessPlaceCd",	rv["businessPlaceCd"] );
	}
</script>
<div class="wrapper">
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td class="top">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='monthWorkDayTab' mdef='월근무시간'/></li>
							<li class="btn">
								<btn:a href="javascript:doActionSheet3.Down2Excel()"	css="btn outline-gray authR" mid="download" mdef="다운로드"/>
								<btn:a href="javascript:doActionSheet3.DownTemplate()"	css="btn outline-gray authA" mid="down2ExcelV1" mdef="양식다운로드"/>
								<btn:a href="javascript:doActionSheet3.LoadExcel()" 	css="btn outline-gray authA" mid="upload" mdef="업로드"/>
								<btn:a href="javascript:doActionSheet3.Copy()"			css="btn outline-gray authA" mid="copy" mdef="복사"/>
								<btn:a href="javascript:doActionSheet3.Insert()"		css="btn outline-gray authA" mid="insert" mdef="입력"/>
								<btn:a href="javascript:doActionSheet3.Save()"			css="btn filled authA" mid="save" mdef="저장"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("tab3Sheet", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>