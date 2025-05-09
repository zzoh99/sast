<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>통계 관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="${ctx}/common/plugin/EIS/js/chart.js?ver=<%= System.currentTimeMillis()%>" type="text/javascript"></script>
<script type="text/javascript">
	var pGubun = "";

	$(function() {
		
		var sizeCodeList = "1|2|3|4|5|6";
		var chartCdList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getChartItemMngCodeList", false).codeList, "");
		
		$("#searchChartCd").html("<option value=''>전체</option>" + chartCdList[2]);
		
		$("#searchStatsCd, #searchStatsNm").on("keyup",function(event){
			if(event.keyCode == 13) {
				doAction1("Search");
			}
		});
		
		$("#searchChartCd").on("change", function(e){
			doAction1("Search");
		});
		
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"통계코드",			Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"statsCd",			KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"통계명",			Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"statsNm",			KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"통계설명",			Type:"Text",		Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"memo",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"차트",			Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"chartCd",			KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"차트 가로 사이즈",	Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"chartSizeW",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"차트 세로 사이즈",	Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"chartSizeH",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"사용여부",			Type:"CheckBox",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"useYn",			KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1,	TrueValue:"Y",	FalseValue:"N" },
			{Header:"차트 옵션",		Type:"Image",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"chartOptDetail",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"데이터 SQL",		Type:"Image",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sqlSyntaxDetail",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"관리",			Type:"Image",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"manageDetail",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"미리보기",			Type:"Image",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"previewDetail",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_setup.png");
		sheet1.SetImageList(1,"${ctx}/common/images/icon/icon_preview.png");
		sheet1.SetDataLinkMouse("manageDetail", 1);
		sheet1.SetDataLinkMouse("chartOptDetail", 1);
		sheet1.SetDataLinkMouse("sqlSyntaxDetail", 1);
		sheet1.SetDataLinkMouse("previewDetail", 1);
		
		// set combo
		sheet1.SetColProperty("chartCd",	{ComboText:chartCdList[0], ComboCode:chartCdList[1]} );
		sheet1.SetColProperty("chartSizeW",	{ComboText:sizeCodeList  , ComboCode:sizeCodeList} );
		sheet1.SetColProperty("chartSizeH",	{ComboText:sizeCodeList  , ComboCode:sizeCodeList} );
		
		$(window).smartresize(sheetResize); sheetInit();
		
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/StatsMng.do?cmd=getStatsMngList", $("#sheetForm").serialize() );
			break;
		case "Save":
			if(!dupChk(sheet1,"statsCd", true, true)){break;}
			IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave( "${ctx}/StatsMng.do?cmd=saveStatsMng", $("#sheetForm").serialize());
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			sheet1.SetCellValue(row, "useYn", "Y");
			break;
		case "Copy":
			var row = sheet1.DataCopy();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
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
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			if(Code >= 1) {
				doAction1("Search");
			}
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function sheet1_OnClick(Row, Col){
		try{
			if(Row > 0 && (sheet1.GetCellValue(Row, "sStatus") == "U" || sheet1.GetCellValue(Row, "sStatus") == "R")) {
				if(sheet1.ColSaveName(Col) == "manageDetail") {
					// 데이터 필수 정의 컬럼 팝업
					if(!isPopup()) {return;}
					<%--var url = "/StatsMng.do?cmd=viewStatsMngLayer&authPg=${authPg}";--%>
					<%--var w = screen.availWidth - 40;--%>
					<%--var h = screen.availHeight;--%>
					<%--var p = {searchStatsCd: sheet1.GetCellValue(Row,"statsCd"), searchStatsNm: sheet1.GetCellValue(Row,"statsNm")};--%>
					<%--var title = '통계 설정 (' + p.searchStatsNm + ')';--%>
					<%--var layerModal = new window.top.document.LayerModal({--%>
					<%--	id : 'statsMngLayer', --%>
					<%--	url : url, --%>
					<%--	parameters: p,--%>
					<%--	width : w,--%>
					<%--	height : h,--%>
					<%--	title : title,--%>
					<%--	trigger: [--%>
					<%--		{name: 'statsMngLayerTrigger', callback: function(r) { doAction1("Search"); }}--%>
					<%--	]--%>
					<%--});--%>
					<%--layerModal.show();--%>
					pGubun = "StatsMngPop";
					var param = [];
					param["searchStatsCd"] = sheet1.GetCellValue(Row,"statsCd");
					param["searchStatsNm"] = sheet1.GetCellValue(Row,"statsNm");
					var layerModal = new window.top.document.LayerModal({
						id : 'statsMngLayer',
						url : '/StatsMng.do?cmd=viewStatsMngLayer&authPg=${authPg}',
						parameters: param,
						width : screen.availWidth,
						height : screen.height,
						title: '통계 설정',
						trigger: [
							{
								name: 'statsMngLayerTrigger',
								callback: function(rv) {
									doAction1("Search");
								}
							}
						]
					});
					layerModal.show();
				}
				if(sheet1.ColSaveName(Col) == "chartOptDetail") {
					// 데이터 필수 정의 컬럼 팝업
					if(!isPopup()) {return;}
					var url = "/StatsMng.do?cmd=viewStatsMngChartOptEditLayer&authPg=${authPg}";
					var p = { searchStatsCd: sheet1.GetCellValue(Row,"statsCd"), searchStatsNm: sheet1.GetCellValue(Row,"statsNm") };
					var title = '차트 옵션 설정 (' + p.searchStatsNm + ')';
					var w = 1400, h = 900;
					var layerModal = new window.top.document.LayerModal({
						id : 'statsMngChartOptEditLayer', 
						url : url, 
						parameters: p,
						width : w,
						height : h,
						title : title
					});
					layerModal.show();
				}
				if(sheet1.ColSaveName(Col) == "sqlSyntaxDetail") {
					// 데이터 필수 정의 컬럼 팝업
					if(!isPopup()) {return;}
					var url = "/StatsMng.do?cmd=viewStatsMngSQLSyntaxEditLayer&authPg=${authPg}";
					var w = 1400, h = 900;
					var p = {searchStatsCd:sheet1.GetCellValue(Row,"statsCd"), searchStatsNm:sheet1.GetCellValue(Row,"statsNm")};
					var title = "데이터 SQL 설정";
					var layerModal = new window.top.document.LayerModal({
						id : 'statsMngChartOptEditLayer', 
						url : url, 
						parameters: p,
						width : w,
						height : h,
						title : title
					});
					layerModal.show();
				}
				if(sheet1.ColSaveName(Col) == "previewDetail") {
					HR_CHART_UTIL.openChartPreviewPop(
						  sheet1.GetCellValue(Row,"statsCd")
						, sheet1.GetCellValue(Row,"statsNm")
						, parseInt(sheet1.GetCellValue(Row,"chartSizeW"))
						, parseInt(sheet1.GetCellValue(Row,"chartSizeH"))
					);
				}
			}
		} catch(ex){
			alert("OnClick Event Error : " + ex);
		}
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th>통계코드</th>
						<td>
							<input id="searchStatsCd" name="searchStatsCd" type="text" class="text" />
						</td>
						<th>통계명</th>
						<td>
							<input id="searchStatsNm" name="searchStatsNm" type="text" class="text" />
						</td>
						<th>차트</th>
						<td>
							<select id="searchChartCd" name="searchChartCd" class="select"></select>
						</td>
						<td>
							<btn:a href="javascript:doAction1('Search');" css="btn dark" mid='110697' mdef="조회"/>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt">통계 관리</li>
			<li class="btn">
				<btn:a href="javascript:doAction1('Down2Excel');" css="btn outline-gray authR" mid='110698' mdef="다운로드"/>
				<btn:a href="javascript:doAction1('Copy');" css="btn outline-gray authA" mid='110696' mdef="복사"/>
				<btn:a href="javascript:doAction1('Insert');" css="btn outline-gray authA" mid='110700' mdef="입력"/>
				<btn:a href="javascript:doAction1('Save');" css="btn filled authA" mid='110708' mdef="저장"/>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
