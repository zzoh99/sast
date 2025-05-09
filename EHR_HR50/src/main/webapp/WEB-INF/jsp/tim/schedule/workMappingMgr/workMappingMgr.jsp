<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>조직구분항목</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {

		$("#searchYmd").datepicker2({
			onReturn:function(date){
				doAction1("Search");
			}
		});
		$("#searchYmd").val("${curSysYyyyMMddHyphen}");

		$("#searchYmd").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
		});
		
		init_sheet1();

		doAction1("Search");
	});
	
	
	function init_sheet1(){
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",			Type:"Seq",       Hidden:0,  Width:45,  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
			{Header:"삭제",			Type:"DelCheck",  Hidden:0,  Width:45,	Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
			{Header:"상태",			Type:"Status",    Hidden:0,  Width:45,	Align:"Center",  ColMerge:0,   SaveName:"sStatus" },

			{Header:"근무조코드",		Type:"Text",      Hidden:0,  Width:80,  Align:"Center",  ColMerge:0,   SaveName:"mapCd",  KeyField:1,   CalcLogic:"",   Format:"",     UpdateEdit:0,   InsertEdit:1 },
			{Header:"근무조명",		Type:"Text",      Hidden:0,  Width:200, Align:"Left",    ColMerge:0,   SaveName:"mapNm",  KeyField:1,   CalcLogic:"",   Format:"",     UpdateEdit:1,   InsertEdit:1 },
			{Header:"시작일자", 		Type:"Date",      Hidden:0,  Width:100, Align:"Center",  ColMerge:0,   SaveName:"sdate",  KeyField:1,   CalcLogic:"",   Format:"Ymd",  UpdateEdit:0,   InsertEdit:1 },
            {Header:"종료일자", 		Type:"Date",      Hidden:0,  Width:100, Align:"Center",  ColMerge:0,   SaveName:"edate",  KeyField:0,   CalcLogic:"",   Format:"Ymd",  UpdateEdit:0,   InsertEdit:0 },
            {Header:"순서",			Type:"Int",       Hidden:0,  Width:80,  Align:"Center",  ColMerge:0,   SaveName:"sort",   KeyField:0,   CalcLogic:"",   Format:"",     UpdateEdit:1,   InsertEdit:1 },
			{Header:"비고",			Type:"Text",      Hidden:0,  Width:200, Align:"Left",    ColMerge:0,   SaveName:"note",   KeyField:0,   CalcLogic:"",   Format:"",     UpdateEdit:1,   InsertEdit:1 },

			//Hidden
			{Header:"Hidden", Type:"Text", Hidden:1, SaveName:"mapTypeCd"},
			{Header:"Hidden", Type:"Text", Hidden:1, SaveName:"ccType"},
			{Header:"Hidden", Type:"Text", Hidden:1, SaveName:"erpEmpCd"},
			{Header:"Hidden", Type:"Text", Hidden:1, SaveName:"businessPlaceCd"}

		]; IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(4);
	
		$(window).smartresize(sheetResize); sheetInit();

	}
	
	//Sheet Action
	function doAction1(sAction) {
		switch (sAction) {

		case "Search":
			sheet1.DoSearch( "${ctx}/WorkMappingMgr.do?cmd=getWorkMappingMgrList", $("#sheet1Form").serialize() );
			break;
		case "Save":

			if(!dupChk(sheet1,"mapTypeCd|mapCd|sdate", true, true)){break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/OrgMappingItemMngr.do?cmd=saveOrgMappingItemMngr", $("#sheet1Form").serialize());
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			sheet1.SetCellValue(row, "mapTypeCd", "500");
			break;
		case "Copy":
			var row = sheet1.DataCopy();
			sheet1.SetCellValue(row, "sdate", "");
			sheet1.SetCellValue(row, "edate", "");
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
			
		}
	}

	//-----------------------------------------------------------------------------------
	//		sheet1 이벤트
	//-----------------------------------------------------------------------------------
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
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
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
		<input type="hidden" id="searchMapTypeCd" name="searchMapTypeCd" value="500" /><!-- 근무조 -->
		
		<div class="sheet_search outer">
			<table>
				<tr>
					<th>기준일자</th>
					<td>
						<input type="text" id="searchYmd" name="searchYmd" class="date2" />
					</td>
					<td><a href="javascript:doAction1('Search')" class="btn dark">조회</a></td>
				</tr>
			</table>
		</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li id="txt" class="txt">근무조관리</li>
				<li class="btn">
					<btn:a href="javascript:doAction1('Insert')" css="btn outline_gray authA" mid='insert' mdef="입력"/>
					<btn:a href="javascript:doAction1('Copy')" 	css="btn outline_gray authA" mid='copy' mdef="복사"/>
					<btn:a href="javascript:doAction1('Save')" 	css="btn filled authA" mid='save' mdef="저장"/>
					<a href="javascript:doAction1('Down2Excel')" 	class="btn outline_gray authR">다운로드</a>

				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>

</div>
</body>
</html>
