<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>연간교육계획작성</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";
	var pGubunSabun = "";

	$(function() {
		
		$("#searchYear").on("change", function(e) {
			doAction1("Search");
			var obj = $("#searchYear option:selected");
			if(obj.val()){
				$("#appDateView").text('신청기간: '+formatDate(obj.attr("sdate"),"-")+' ~ '+formatDate(obj.attr("edate"),"-"));
			}else{
				$("#appDateView").text('신청기간: ');
			}
				
		});
		
		var codeList = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getYearEduAppYearCode", false).codeList
        , "sdate,edate"
        , "");
		$("#searchYear").html(codeList[2]).change();
		
		//Sheet 초기화
		init_sheet1();

		doAction1("Search");
		
		setEmpPage();

	});

	function init_sheet1(){

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [

			{Header:"No|No",						Type:"${sNoTy}",  Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	SaveName:"sNo",		Sort:0 },
			{Header:"삭제|삭제",					Type:"${sDelTy}", Hidden:0,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",					Type:"${sSttTy}", Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"교육과정명|교육과정명", 		Type:"Text", 	 Hidden:0, Width:150,  Align:"Left",   SaveName:"eduCourseNm", 	KeyField:1, Format:"", 	UpdateEdit:1, InsertEdit:1 },
			{Header:"사내/외\n구분|사내/외\n구분", 	Type:"Combo", 	 Hidden:0, Width:100,  Align:"Center", SaveName:"inOutType", 	KeyField:0, Format:"", 	UpdateEdit:1, InsertEdit:1 },
			{Header:"월별교육비용|합계", 			Type:"AutoSum",  Hidden:0, Width:50,   Align:"Center", SaveName:"totMon", 		KeyField:0, Format:"", 	UpdateEdit:1, InsertEdit:1, CalcLogic:"|mon01|+|mon02|+|mon03|+|mon04|+|mon05|+|mon06|+|mon07|+|mon08|+|mon09|+|mon10|+|mon11|+|mon12|" },
			{Header:"월별교육비용|1월", 			Type:"AutoSum",  Hidden:0, Width:50,   Align:"Center", SaveName:"mon01", 		KeyField:0, Format:"", 	UpdateEdit:1, InsertEdit:1 },
			{Header:"월별교육비용|2월", 			Type:"AutoSum",  Hidden:0, Width:50,   Align:"Center", SaveName:"mon02", 		KeyField:0, Format:"", 	UpdateEdit:1, InsertEdit:1 },
			{Header:"월별교육비용|3월", 			Type:"AutoSum",  Hidden:0, Width:50,   Align:"Center", SaveName:"mon03", 		KeyField:0, Format:"", 	UpdateEdit:1, InsertEdit:1 },
			{Header:"월별교육비용|4월", 			Type:"AutoSum",  Hidden:0, Width:50,   Align:"Center", SaveName:"mon04", 		KeyField:0, Format:"", 	UpdateEdit:1, InsertEdit:1 },
			{Header:"월별교육비용|5월", 			Type:"AutoSum",  Hidden:0, Width:50,   Align:"Center", SaveName:"mon05", 		KeyField:0, Format:"", 	UpdateEdit:1, InsertEdit:1 },
			{Header:"월별교육비용|6월", 			Type:"AutoSum",  Hidden:0, Width:50,   Align:"Center", SaveName:"mon06", 		KeyField:0, Format:"", 	UpdateEdit:1, InsertEdit:1 },
			{Header:"월별교육비용|7월", 			Type:"AutoSum",  Hidden:0, Width:50,   Align:"Center", SaveName:"mon07", 		KeyField:0, Format:"", 	UpdateEdit:1, InsertEdit:1 },
			{Header:"월별교육비용|8월", 			Type:"AutoSum",  Hidden:0, Width:50,   Align:"Center", SaveName:"mon08", 		KeyField:0, Format:"", 	UpdateEdit:1, InsertEdit:1 },
			{Header:"월별교육비용|9월", 			Type:"AutoSum",  Hidden:0, Width:50,   Align:"Center", SaveName:"mon09", 		KeyField:0, Format:"", 	UpdateEdit:1, InsertEdit:1 },
			{Header:"월별교육비용|10월", 			Type:"AutoSum",  Hidden:0, Width:50,   Align:"Center", SaveName:"mon10", 		KeyField:0, Format:"", 	UpdateEdit:1, InsertEdit:1 },
			{Header:"월별교육비용|11월", 			Type:"AutoSum",  Hidden:0, Width:50,   Align:"Center", SaveName:"mon11", 		KeyField:0, Format:"", 	UpdateEdit:1, InsertEdit:1 },
			{Header:"월별교육비용|12월", 			Type:"AutoSum",  Hidden:0, Width:50,   Align:"Center", SaveName:"mon12", 		KeyField:0, Format:"", 	UpdateEdit:1, InsertEdit:1 },
			{Header:"교육우선순위|교육우선순위", 	Type:"Combo", 	 Hidden:0, Width:260,  Align:"Left", SaveName:"priorityCd", 	KeyField:1, Format:"", 	UpdateEdit:1, InsertEdit:1 },
			//Hidden
			{Header:"Hidden", Type:"Text", Hidden:1, SaveName:"seq"},
			{Header:"Hidden", Type:"Text", Hidden:1, SaveName:"year"},
			{Header:"Hidden", Type:"Text", Hidden:1, SaveName:"orgCd"},


		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetDataAlternateBackColor(sheet1.GetDataBackColor()); //홀짝 배경색 같게
		
		//==============================================================================================================================
		var grpCds = "L20020,L15010";
 		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grpCds,false).codeList, "");
 		sheet1.SetColProperty("inOutType",  		{ComboText:"|"+codeLists["L20020"][0], ComboCode:"|"+codeLists["L20020"][1]} ); //사내/사외구분
 		sheet1.SetColProperty("priorityCd",  		{ComboText:"|"+codeLists["L15010"][0], ComboCode:"|"+codeLists["L15010"][1]} ); //교육우선순위
		//==============================================================================================================================
		
		$(window).smartresize(sheetResize); sheetInit();

	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				var sXml = sheet1.GetSearchData("${ctx}/YearEduApp.do?cmd=getYearEduAppList", $("#sheet1Form").serialize());
				sheet1.LoadSearchData(sXml );
				getYearEduAppStatus();
				break;
			case "Save":
				var tempSeq = 1;
				for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){
					if (sheet1.GetCellValue(i, "sStatus") != "D") {
						sheet1.SetCellValue(i, "sStatus", "U", 0);
        				sheet1.SetCellValue(i, "seq", tempSeq++, 0);
					}
				}
				IBS_SaveName(document.sheet1Form,sheet1);
				sheet1.DoSave( "${ctx}/YearEduApp.do?cmd=saveYearEduApp", $("#sheet1Form").serialize());
				break;
			case "Insert":
				var row = sheet1.DataInsert(0);
				sheet1.SetCellValue(row, "year",	$("#searchYear").val() );
				break;
			case "Copy":
				var row = sheet1.DataCopy();
				sheet1.SetCellValue(row, "year",	$("#searchYear").val() );
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet1.Down2Excel(param);
				break;
		}
	}
	
	function getYearEduAppStatus() {
		
		var map = ajaxCall( "${ctx}/YearEduApp.do?cmd=getYearEduAppStatus",$("#sheet1Form").serialize(),false);
		$('#appStaView').text('계획상태 : '+map.DATA.status);
		if (map.DATA.status && map.DATA.status == '작성가능') {
			$('.appActView').show();
			sheet1.SetEditable(1);
			/* sheet1.SetColHidden('sStatus', 0);
			sheet1.SetColHidden('sDelete', 0); */
		} else {
			$('.appActView').hide();
			sheet1.SetEditable(0);
			/* sheet1.SetColHidden('sStatus', 1);
			sheet1.SetColHidden('sDelete', 1); */
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
	
	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			/* if(sheet1.ColSaveName(Col) == "sDelete" && Value == 1 ) {
				sheet1.RowDelete(Row);
			} */
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}
	
	//인사헤더
    function setEmpPage() {
    	$("#searchSabun").val($("#searchUserId").val());
    	doAction1("Search");
    }
</script>
<style type="text/css">
table.table01 th { border:0;padding-right:10px;}
</style>
</head>
<body class="bodywrap">
<div class="wrapper">
	<!-- include 기본정보 page TODO -->
	<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>

	<form name="sheet1Form" id="sheet1Form" method="post">
	<input type="hidden" id="searchSabun" name="searchSabun" value=""/>
	
	<div class="sheet_search sheet_search_s outer">
		<table>
		<tr>
			<th>기준년도</th>
			<td>
				<select id="searchYear" name="searchYear">
				</select>
			</td>
			<td>
				<span id="appDateView">신청기간:</span>
			</td>
			<td>
				<span id="appStaView">계획상태:</span>
			<td>
				<a href="javascript:doAction1('Search')" class="btn dark">조회</a>
			</td>
		</tr>
		</table>
	</div>

	<div class="sheet_title inner">
	<ul>
		<li class="txt">연간교육계획작성</li>
		<li class="btn">
			<span>(단위 : 천원)</span>
			<a href="javascript:doAction1('Down2Excel');" 	class="btn outline-gray authR">다운로드</a>
			<a href="javascript:doAction1('Insert')" 		class="btn outline-gray authA appActView" style="display: none;">입력</a>
			<a href="javascript:doAction1('Copy')" 			class="btn outline-gray authA appActView" style="display: none;">복사</a>
			<a href="javascript:doAction1('Save');" 		class="btn filled authA appActView" style="display: none;">저장</a>
		</li>
	</ul>
	</div>
	</form>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>
