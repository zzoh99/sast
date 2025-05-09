<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>질병코드관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {

		//Sheet 초기화
		init_sheet1();

		$(window).smartresize(sheetResize); sheetInit();
		
		doAction1("Search");


	});

	//Sheet 초기화
	function init_sheet1(){

		var initdata1 = {};
		//MergeSheet:msHeaderOnly => 헤더만 머지
		//HeaderCheck => 헤더에 전체 체크 표시 여부
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:0,				Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",			Type:"${sDelTy}",	Hidden:"${sDelHdn}",	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",			Type:"${sSttTy}",	Hidden:"${sSttHdn}",	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"질병코드", 	Type:"Text", 		Hidden:0, 				Width:60, 			Align:"Center", ColMerge:0,	SaveName:"code", 	KeyField:1, Format:"", PointCount:0,	UpdateEdit:0, InsertEdit:1 },
			{Header:"병명", 		Type:"Text", 		Hidden:0, 				Width:300, 			Align:"Left", 	ColMerge:0,	SaveName:"codeNm", 	KeyField:1, Format:"", PointCount:0,	UpdateEdit:1, InsertEdit:1 },
			{Header:"등록일자", 	Type:"Text", 		Hidden:0, 				Width:70, 			Align:"Center", ColMerge:0,	SaveName:"regDate", KeyField:0, Format:"", PointCount:0,	UpdateEdit:0, InsertEdit:0 },
			{Header:"비고", 		Type:"Text", 		Hidden:0, 				Width:300, 			Align:"Left", ColMerge:0,	SaveName:"note", 	KeyField:0, Format:"", PointCount:0, 	UpdateEdit:1, InsertEdit:1 },

		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				sheet1.DoSearch( "${ctx}/MedCodeMgr.do?cmd=getMedCodeMgrList", $("#sheet1Form").serialize() );
				break;
			case "Save":
				if(!dupChk(sheet1,"code", true, true)){break;}
				IBS_SaveName(document.sheet1Form,sheet1);
				sheet1.DoSave( "${ctx}/MedCodeMgr.do?cmd=saveMedCodeMgr", $("#sheet1Form").serialize());
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
			case "DownTemplate":
				sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"code|codeNm|note"});
				break;
			case "LoadExcel":
				var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); //615page
				break;
		}
	}


	//---------------------------------------------------------------------------------------------------------------
	// sheet1 Event
	//---------------------------------------------------------------------------------------------------------------

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
			if( Code > -1 ) doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form name="sheet1Form" id="sheet1Form" method="post">
	<div class="sheet_search outer">
		<table>
		<tr>
			<th>질병코드</th>
			<td>
				<input type="text" id="searchCode" name="searchCode" class="text"/>
			</td>
			<th>질병명</th>
			<td>
				<input type="text" id="searchCodeNm" name="searchCodeNm" class="text"/>
			</td>
			<td>
				<a href="javascript:doAction1('Search')" class="btn dark">조회</a>
			</td>
		</tr>
		</table>
	</div>
	</form>

	<div class="sheet_title inner">
		<ul>
			<li class="txt">질병코드관리</li>
			<li class="btn">
				<btn:a href="javascript:doAction1('Down2Excel');" 	css="btn outline-gray authR" mid="download" mdef="다운로드"/>
				<btn:a href="javascript:doAction1('DownTemplate')" 	css="btn outline-gray authR" mid="down2ExcelV1" mdef="양식다운로드"/>
				<btn:a href="javascript:doAction1('LoadExcel')" 	css="btn outline-gray authR" mid="upload" mdef="업로드"/>
				<btn:a href="javascript:doAction1('Copy');" 		css="btn outline-gray authA" mid="copy" mdef="복사"/>
				<btn:a href="javascript:doAction1('Insert');" 		css="btn outline-gray authA" mid="insert" mdef="입력"/>
				<btn:a href="javascript:doAction1('Save');" 		css="btn filled authA" mid="save" mdef="저장"/>
			</li>
		</ul>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>

</div>
</body>
</html>
