<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:5, SearchMode:smLazyLoad,MergeSheet:msHeaderOnly,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",      	Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo"},
			{Header:"삭제",    	Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:45,			Align:"Center",	ColMerge:0,	SaveName:"sDelete", Sort:0 },
			{Header:"상태",    	Type:"${sSttTy}",	Hidden:0,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus", Sort:0 },			
			{Header:"항목구분",	Type:"Text",		Hidden:0,	Width:50,		Align:"Center",	ColMerge:1,	SaveName:"gubun",	KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:50 },
			{Header:"순서",   	Type:"Int",			Hidden:0,	Width:50,		Align:"Center",	ColMerge:0,	SaveName:"sortNo",	KeyField:1,	Format:"NullInteger",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"질의내용",	Type:"Text",		Hidden:0,	Width:200,		Align:"Left",	ColMerge:0,	SaveName:"question",KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"비고",		Type:"Text",		Hidden:0,	Width:100,		Align:"Left",	ColMerge:0,	SaveName:"bigo",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"순번",		Type:"Text",		Hidden:1,	Width:100,		Align:"Center",	ColMerge:0,	SaveName:"seq",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		];IBS_InitSheet(sheet1, initdata);sheet1.SetCountPosition(4);
		
		$(window).smartresize(sheetResize);
		sheetInit();
		doAction1("Search");
	});

	//Sheet Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":		
							sheet1.DoSearch( "${ctx}/RetireMgr.do?cmd=getRetireMgrList", $("#sheetForm").serialize() ); 
							break;
		case "Save":
							if(sheet1.FindStatusRow("I|U") != ""){
								if (!dupChk(sheet1, "gubun|sortNo|question", false, true)) {break;}
							}
							IBS_SaveName(document.sheetForm,sheet1);
							sheet1.DoSave("${ctx}/RetireMgr.do?cmd=saveRetireMgr", $("#sheetForm").serialize() );  
							break;
		case "Copy":      	
							var row = sheet1.DataCopy();
							sheet1.SetCellValue(row, "seq", "");
							break;
		case "Insert":      
							var row = sheet1.DataInsert(0); 
							break;
		case "Down2Excel":
							var downcol = makeHiddenSkipCol(sheet1);
							var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
							sheet1.Down2Excel(param);
							break;
		}
	}
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize();} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doAction1('Search');
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">	
	<form id="sheetForm" name="sheetForm"></form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li class="txt">퇴직설문항목관리 </li>
							<li class="btn">
								<a href="javascript:doAction1('Down2Excel')" class="btn outline-gray authA">다운로드</a>
								<btn:a href="javascript:doAction1('Copy')" css="btn outline-gray authA" mid='copy' mdef="복사"/>
								<btn:a href="javascript:doAction1('Insert')" css="btn outline-gray authA" mid='insert' mdef="입력"/>
								<btn:a href="javascript:doAction1('Save')" css="btn filled authA" mid='save' mdef="저장"/>
								<btn:a href="javascript:doAction1('Search')" id="btnSearch" css="btn dark" mid='search' mdef="조회"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
