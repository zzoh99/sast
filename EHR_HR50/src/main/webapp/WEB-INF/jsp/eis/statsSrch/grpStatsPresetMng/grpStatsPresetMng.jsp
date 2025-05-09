<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>권한그룹별 통계구성 관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="${ctx}/common/plugin/EIS/js/chart.js?ver=<%= System.currentTimeMillis()%>" type="text/javascript"></script>
<script type="text/javascript">
	$(function() {
		$("#searchGrpCd").on("change", function(e){
			doAction1("Search");
		});
		
		$("#searchPresetId, #searchPresetNm").on("keyup",function(event){
			if(event.keyCode == 13) {
				doAction1("Search");
			}
		});
		
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"통계구성구분",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"presetTypeCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1 },
			{Header:"통계구성소유",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"presetOwner",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1 },
			{Header:"통계구성ID",		Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"presetId",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"통계구성명",		Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"presetNm",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"통계구성설명",		Type:"Text",		Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"memo",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"순서",			Type:"Int",			Hidden:0,	Width:60,	Align:"Right",	ColMerge:0,	SaveName:"seq",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"사용여부",			Type:"CheckBox",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"useYn",			KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1,	TrueValue:"Y",	FalseValue:"N" },
			{Header:"통계구성",			Type:"Image",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"layoutDetail",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"미리보기",			Type:"Image",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"previewDetail",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"그룹코드",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"grpCd",			KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1 },
			{Header:"사번",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_setup.png");
		sheet1.SetImageList(1,"${ctx}/common/images/icon/icon_preview.png");
		sheet1.SetDataLinkMouse("layoutDetail", 1);
		sheet1.SetDataLinkMouse("previewDetail", 1);
		
		$(window).smartresize(sheetResize); sheetInit();
		
		var authGrp = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&queryId=getAthGrpMenuMgrGrpCdList","",false).codeList, "");
		$("#searchGrpCd").html(authGrp[2]);
		$("#searchGrpCd").change();
		
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/StatsPresetMng.do?cmd=getStatsPresetMngGrpList", $("#sheetForm").serialize() );
			break;
		case "Save":
			if(!dupChk(sheet1,"presetId", true, true)){break;}
			IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave( "${ctx}/StatsPresetMng.do?cmd=saveStatsPresetMng", $("#sheetForm").serialize());
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			sheet1.SetCellValue(row, "presetTypeCd", "G");
			sheet1.SetCellValue(row, "grpCd", $("#searchGrpCd").val());
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
				if(sheet1.ColSaveName(Col) == "layoutDetail") {
					// 데이터 필수 정의 컬럼 팝업
					if(!isPopup()) {return;}
					var url = "/StatsPresetMng.do?cmd=viewStatsPresetMngLayoutEditLayer&authPg=${authPg}";
					var w = screen.availWidth - 40;
					var h = screen.availHeight;
					var title = '통계 레이아웃 구성';
					var p = { searchPresetTypeCd: sheet1.GetCellValue(Row,"presetTypeCd"),
							  searchPresetOwner: sheet1.GetCellValue(Row, "presetOwner"),
							  searchPresetId: sheet1.GetCellValue(Row,"presetId"),
							  searchPresetNm: sheet1.GetCellValue(Row,"presetNm") };
					var layerModal = new window.top.document.LayerModal({
						id : 'statsPresetMngLayoutEditLayer', 
						url : url, 
						parameters: p,
						width : w,
						height : h,
						title : title
					});
					layerModal.show();
				}
				if(sheet1.ColSaveName(Col) == "previewDetail") {
					// 데이터 필수 정의 컬럼 팝업
					if(!isPopup()) {return;}
					var title = "통계구성 미리보기";
					var url = "/StatsPresetMng.do?cmd=viewStatsPresetMngPreviewLayer&authPg=${authPg}";
					var w = screen.availWidth - 40;
					var h = screen.availHeight;
					var p = {searchPresetTypeCd : sheet1.GetCellValue(Row,"presetTypeCd"),
							 searchPresetOwner : sheet1.GetCellValue(Row, "presetOwner"),
							 searchPresetId : sheet1.GetCellValue(Row,"presetId"),
							 searchPresetNm : sheet1.GetCellValue(Row,"presetNm")};
					var layerModal = new window.top.document.LayerModal({
						id : 'statsPresetMngPreviewLayer', 
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
						<th>권한그룹</th>
						<td>
							<select id="searchGrpCd" name="searchGrpCd"></select>
						</td>
						<th>통계구성ID</th>
						<td>
							<input id="searchPresetId" name="searchPresetId" type="text" class="text" />
						</td>
						<th>통계구성명</th>
						<td>
							<input id="searchPresetNm" name="searchPresetNm" type="text" class="text" />
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
			<li class="txt">권한그룹별 통계구성 관리</li>
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
