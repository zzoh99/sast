<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>차트 관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="${ctx}/common/plugin/EIS/js/chart.js?ver=<%= System.currentTimeMillis()%>" type="text/javascript"></script>
<script type="text/javascript">

	$(function() {
		var pluginObjNm = HR_CHART_UTIL.getPluginObjCode();
		
		$("#searchPluginObjNm").html("<option value=''>전체</option>" + pluginObjNm[2]);
		
		$("#searchChartCd, #searchChartNm").on("keyup",function(event){
			if(event.keyCode == 13) {
				doAction1("Search");
			}
		});
		
		$("#searchPluginObjNm").on("change", function(e){
			doAction1("Search");
		});
		
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"차트코드",				Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"chartCd",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"차트명",				Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"chartNm",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"차트설명",				Type:"Text",		Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"memo",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"사용 Plug-in 객체명",	Type:"Combo",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"pluginObjNm",	KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:256 },
			{Header:"데이터 필수 정의 컬럼",		Type:"Image",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"detail",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("detail", 1);
		
		// set combo
		sheet1.SetColProperty("pluginObjNm",	{ComboText:pluginObjNm[0], ComboCode:pluginObjNm[1]} );
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/ChartItemMng.do?cmd=getChartItemMngList", $("#sheetForm").serialize() );
			break;
		case "Save":
			if(!dupChk(sheet1,"chartCd", true, true)){break;}
			IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave( "${ctx}/ChartItemMng.do?cmd=saveChartItemMng", $("#sheetForm").serialize());
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);
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
				if(sheet1.ColSaveName(Col) == "detail") {
					// 데이터 필수 정의 컬럼 팝업
					if(!isPopup()) {return;}
					var w = 740, h = 550;
					var url = "/ChartItemMng.do?cmd=viewChartItemMngRequiredColLayer&authPg=${authPg}";
					var p = { pluginObjNm: sheet1.GetCellValue(Row,"pluginObjNm") };
					var title = "데이터 필수 정의 컬럼";
					var layerModal = new window.top.document.LayerModal({
						id : 'chartItemMngRequiredColLayer', 
						url : url, 
						parameters: p,
						width : w,
						height : h,
						title : title
					});
					layerModal.show();
					
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
				<th>차트코드</th>
				<td>
					<input id="searchChartCd" name="searchChartCd" type="text" class="text" />
				</td>
				<th>차트명</th>
				<td>
					<input id="searchChartNm" name="searchChartNm" type="text" class="text" />
				</td>
				<th>사용 Plug-in 객체</th>
				<td>
					<select id="searchPluginObjNm" name="searchPluginObjNm" class="select"></select>
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
			<li class="txt">차트 관리</li>
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
