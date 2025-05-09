<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>학자금기준관리-직책별 지원금액</title>
<link rel="stylesheet" href="/common/${theme}/css/style.css" />
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

	$(function() {
		
		$("#searchSchTypeCd").val("${param.schTypeCd}");
		$("#searchSchSupTypeCd").val("${param.schSupTypeCd}");
		$("#searchFamCd").val("${param.famCd}");
		$("#searchSdate").val("${param.sdate}");
		$("#searchYmd").val("${param.searchYmd}");

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22, MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColLoan:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			
			{Header:"직책",		Type:"Combo",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"jikchakCd",	KeyField:1,	Format:"",			UpdateEdit:0,	InsertEdit:1 },
			{Header:"시작일",		Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"useSYmd",		KeyField:1,	Format:"Ymd",		UpdateEdit:0,	InsertEdit:1 , EndDateCol:"useEYmd"},
			{Header:"종료일",		Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"useEYmd",		KeyField:0,	Format:"Ymd",		UpdateEdit:1,	InsertEdit:1 , StartDateCol:"useSYmd"},
			{Header:"지원금액",	Type:"Int",			Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"applMon",		KeyField:0,	Format:"#,###\\원",	PointCount:0,	UpdateEdit:1,	InsertEdit:1},
			{Header:"사용여부",	Type:"CheckBox",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"useYn",		KeyField:0,	Format:"",			UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y",	FalseValue:"N" },
			{Header:"비고",		Type:"Text",		Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"note",		KeyField:0,	Format:"",			UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			
			// hidden
			{Header:"Hidden",	Hidden:1, SaveName:"schTypeCd"},
			{Header:"Hidden",	Hidden:1, SaveName:"schSupTypeCd"},
			{Header:"Hidden",	Hidden:1, SaveName:"famCd"},
			{Header:"Hidden",	Hidden:1, SaveName:"sdate"}
		];
		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		$(window).smartresize(sheetResize); sheetInit();

		doAction("Search");

	});

	function getCommonCodeList() {
		//공통코드 한번에 조회
		var grpCds = "H20020";
		let params = "grpCd=" + grpCds + "&baseSYmd=" + $("#searchYmd").val();
		codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists&useYn=Y", params, false).codeList, "전체");
		sheet1.SetColProperty("jikchakCd",  	{ComboText:"|"+codeLists["H20020"][0], ComboCode:"|"+codeLists["H20020"][1]} );	// 직책코드
	}

	function chkInVal() {
		// 시작일자와 종료일자 체크
		for (var i=sheet1.HeaderRows(); i<=sheet1.LastRow(); i++) {
			if (sheet1.GetCellValue(i, "sStatus") == "I" || sheet1.GetCellValue(i, "sStatus") == "U") {
				if (sheet1.GetCellValue(i, "useEYmd") != null && sheet1.GetCellValue(i, "useEYmd") != "") {
					var useSYmd = sheet1.GetCellValue(i, "useSYmd");
					var useEYmd = sheet1.GetCellValue(i, "useEYmd");
					if (parseInt(useSYmd) > parseInt(useEYmd)) {
						alert("<msg:txt mid='110396' mdef='시작일자가 종료일자보다 큽니다.'/>");
						sheet1.SelectCell(i, "useEYmd");
						return false;
					}
				}
			}
		}
		return true;
	}
	
	//Sheet Action
	function doAction(sAction) {

		switch (sAction) {
			case "Search":
				getCommonCodeList();
				sheet1.DoSearch( "${ctx}/SchStd.do?cmd=getSchTab1StdList", $("#sheet1Form").serialize() );
				break;
				
			case "Save":
				if(!chkInVal()){break;}
				if(!dupChk(sheet1,"jikchakCd|useSYmd", false, true)){break;}
				IBS_SaveName(document.sheet1Form,sheet1);
				sheet1.DoSave( "${ctx}/SchStd.do?cmd=saveSchTab1Std", $("#sheet1Form").serialize());
				break;
				
			case "Insert":
				var Row = sheet1.DataInsert(0);
				sheet1.SetCellValue(Row, "schTypeCd",    $("#searchSchTypeCd").val());
				sheet1.SetCellValue(Row, "schSupTypeCd", $("#searchSchSupTypeCd").val());
				sheet1.SetCellValue(Row, "famCd",        $("#searchFamCd").val());
				sheet1.SetCellValue(Row, "sdate",        $("#searchSdate").val());
				sheet1.SelectCell(Row, "");
				break;
				
			case "Copy":
				var Row = sheet1.DataCopy();
				break;
				
			case "Clear":
				sheet1.RemoveAll();
				break;
				
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet1.Down2Excel(param);
				break;
				
			case "LoadExcel":
				var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params);
				break;
				
			case "DownTemplate":
				// 양식다운로드
				sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"3|4|5|6|7|8"});
				break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }
			doAction("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
		<input type="hidden" id="searchSchTypeCd"    name="searchSchTypeCd" />
		<input type="hidden" id="searchSchSupTypeCd" name="searchSchSupTypeCd" />
		<input type="hidden" id="searchFamCd"        name="searchFamCd" />
		<input type="hidden" id="searchSdate"        name="searchSdate" />
		<input type="hidden" id="searchYmd"        	 name="searchYmd" />
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">직책별 지원금액 기준관리</li>
							<li class="btn">
								<a href="javascript:doAction('Down2Excel')" 	class="btn outline-gray authR">다운로드</a>
								<a href="javascript:doAction('DownTemplate')"	class="btn outline-gray authA">양식다운로드</a>
								<a href="javascript:doAction('LoadExcel')"		class="btn outline-gray authA">업로드</a>
								<a href="javascript:doAction('Copy')" 			class="btn outline-gray authA">복사</a>
								<a href="javascript:doAction('Insert')" 		class="btn outline-gray authA">입력</a>
								<a href="javascript:doAction('Save');" 			class="btn filled authA">저장</a>
								<a href="javascript:doAction('Search')"			class="btn dark">조회</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
