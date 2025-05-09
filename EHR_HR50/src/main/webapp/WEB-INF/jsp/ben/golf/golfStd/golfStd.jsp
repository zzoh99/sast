<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>골프장기준관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {

		//기준일자 날짜형식, 날짜선택 시 
		$("#searchYmd").datepicker2({
			onReturn:function(){
				doAction1("Search");
			}
		});

		$("#searchYmd").on("keyup", function(event) {
			if( event.keyCode == 13) {
				doAction2("Search");
			}
		});


		//Sheet 초기화
		init_sheet1();

		$(window).smartresize(sheetResize); sheetInit();
		
		doAction1("Search");


	});

	//Sheet 초기화
	function init_sheet1(){

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No|No",			Type:"${sNoTy}",	Hidden:0,				Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",			Type:"${sDelTy}",	Hidden:"${sDelHdn}",	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",			Type:"${sSttTy}",	Hidden:"${sSttHdn}",	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"골프장|골프장",		Type:"Combo",		Hidden:0,				Width:100,	Align:"Center",	ColMerge:0,	SaveName:"golfCd",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1 },
			{Header:"시작일|시작일",		Type:"Date",		Hidden:"${sDelHdn}",	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:1, EndDateCol:"edate"},
			{Header:"종료일|종료일",		Type:"Date",		Hidden:"${sDelHdn}",	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1, StartDateCol:"sdate"},
			
			{Header:"골프장주소|골프장주소",	Type:"Text",		Hidden:0,				Width:200,	Align:"Left",	ColMerge:0,	SaveName:"golfAddr",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:150 },
			{Header:"이용요금|이용요금",		Type:"Text",		Hidden:0,				Width:150,	Align:"Left",	ColMerge:0,	SaveName:"golfMon",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:150 },
			{Header:"유의사항|유의사항",		Type:"Text",		Hidden:0,				Width:300,	Align:"Left",	ColMerge:0,	SaveName:"note",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2000, Wrap:1,  MultiLineText:1},
			{Header:"사용\n여부|사용\n여부",	Type:"CheckBox",	Hidden:"${sDelHdn}",	Width:55,	Align:"Center",	ColMerge:0,	SaveName:"useYn",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y",	FalseValue:"N" },
			{Header:"순서|순서",			Type:"Text",		Hidden:0,				Width:55,	Align:"Center",	ColMerge:0,	SaveName:"seq",			KeyField:0,	Format:"Number",	PointCount:0,	UpdateEdit:1,	InsertEdit:1}, 
			
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetEditEnterBehavior( "newline");
		//var famCdList = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "B60030"), "");
		//sheet1.SetColProperty("famCd", {ComboText:"|"+famCdList[0], ComboCode:"|"+famCdList[1]});


	}

	function getCommonCodeList() {
		//공통코드 한번에 조회
		let grpCds = "B51010";
		let params = "grpCd=" + grpCds + "&baseSYmd=" + $("#searchYmd").val();
		const codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists&useYn=Y", params, false).codeList, "");
		sheet1.SetColProperty("golfCd",  	{ComboText:"|"+codeLists["B51010"][0], ComboCode:"|"+codeLists["B51010"][1]} ); //경조구분
	}

	function chkInVal() {
		// 시작일자와 종료일자 체크
		for (var i=sheet1.HeaderRows(); i<=sheet1.LastRow(); i++) {
			if (sheet1.GetCellValue(i, "sStatus") == "I" || sheet1.GetCellValue(i, "sStatus") == "U") {
				if (sheet1.GetCellValue(i, "edate") != null && sheet1.GetCellValue(i, "edate") != "") {
					var sdate = sheet1.GetCellValue(i, "sdate");
					var edate = sheet1.GetCellValue(i, "edate");
					if (parseInt(sdate) > parseInt(edate)) {
						alert("<msg:txt mid='110396' mdef='시작일자가 종료일자보다 큽니다.'/>");
						sheet1.SelectCell(i, "edate");
						return false;
					}
				}
			}
		}
		return true;
	}
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				getCommonCodeList();
				sheet1.DoSearch( "${ctx}/GolfStd.do?cmd=getGolfStdList", $("#sheet1Form").serialize() );
				break;
			case "Save":
				if(!chkInVal()){break;}
				IBS_SaveName(document.sheet1Form,sheet1);
				sheet1.DoSave( "${ctx}/GolfStd.do?cmd=saveGolfStd", $("#sheet1Form").serialize());
				break;
			case "Insert":
				var row = sheet1.DataInsert(0);
				sheet1.SetCellValue(row, "useYn", "Y");
				break;
			case "Copy":
				var row = sheet1.DataCopy();
				sheet1.SetCellValue(row, "sdate", "");
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet1.Down2Excel(param);
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
			<th>기준일자</th>
			<td>
				<input type="text" id="searchYmd" name="searchYmd" class="date2" value="${curSysYyyyMMddHyphen}"/>
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
			<li class="txt">골프장기준관리</li>
			<li class="btn">
				<a href="javascript:doAction1('Down2Excel');" 	class="btn outline-gray authR">다운로드</a>
				<a href="javascript:doAction1('Copy')" 			class="btn outline-gray authA">복사</a>
				<a href="javascript:doAction1('Insert')" 		class="btn outline-gray authA">입력</a>
				<a href="javascript:doAction1('Save');" 		class="btn filled authA">저장</a>
			</li>
		</ul>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>

</div>
</body>
</html>
