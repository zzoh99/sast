<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>의료비기준관리</title>
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
				doAction1("Search");
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
		//MergeSheet:msHeaderOnly => 헤더만 머지
		//HeaderCheck => 헤더에 전체 체크 표시 여부
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No|No",				Type:"${sNoTy}",	Hidden:0,				Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",			Type:"${sDelTy}",	Hidden:"${sDelHdn}",	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",			Type:"${sSttTy}",	Hidden:"${sSttHdn}",	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			
			{Header:"가족구분|가족구분", Type:"Combo", Hidden:0, Width:100, Align:"Center",	ColMerge:0, SaveName:"famCd", KeyField:1, Format:"", UpdateEdit:0, InsertEdit:1 },
			{Header:"시작일자|시작일자", 	Type:"Date", Hidden:0, Width:100, Align:"Center", ColMerge:0, SaveName:"sdate", KeyField:1, Format:"Ymd", UpdateEdit:0, InsertEdit:1 , EndDateCol:"edate"},
			{Header:"종료일자|종료일자", 	Type:"Date", Hidden:0, Width:100, Align:"Center", ColMerge:0, SaveName:"edate", KeyField:0, Format:"Ymd", UpdateEdit:1, InsertEdit:1 , StartDateCol:"sdate"},
			{Header:"년간한도금액\n(근로자1인기준)|년간한도금액\n(근로자1인기준)", Type:"Int", Hidden:0, Width:100, Align:"Center", ColMerge:0, SaveName:"empYearMon", KeyField:0, Format:"#,###\\원", UpdateEdit:1, InsertEdit:1 },
			{Header:"기준금액\n(초과금액지원)|기준금액\n(초과금액지원)", 	Type:"Int", Hidden:0, Width:100, Align:"Center", ColMerge:0, SaveName:"stdMon", KeyField:0, Format:"#,###\\원", UpdateEdit:1, InsertEdit:1 },
			{Header:"근속년수|근속년수", 	Type:"Int", Hidden:0, Width:70, Align:"Center", ColMerge:0, SaveName:"workYear", KeyField:0, Format:"##\\년이상", UpdateEdit:1, InsertEdit:1 },
			{Header:"연말정산\n부양가족\n체크여부|연말정산\n부양가족\n체크여부", Type:"CheckBox", Hidden:0, Width:100, Align:"Center", ColMerge:0, SaveName:"yearendYn", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1, TrueValue:"Y",	FalseValue:"N"  },
			{Header:"비고|비고", 		Type:"Text", Hidden:0, Width:120, Align:"Center", ColMerge:0, SaveName:"note", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

	}

	function getCommonCodeList() {
		//공통코드 한번에 조회
		var grpCds = "B60030";
		let params = "grpCd=" + grpCds + "&baseSYmd=" + $("#searchYmd").val();
		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists&useYn=Y", params, false).codeList, "");
		sheet1.SetColProperty("famCd",  	{ComboText:"|"+codeLists["B60030"][0], ComboCode:"|"+codeLists["B60030"][1]} ); //가족구분
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
				sheet1.DoSearch( "${ctx}/MedStd.do?cmd=getMedStdList", $("#sheet1Form").serialize() );
				break;
			case "Save":
				if(!chkInVal()){break;}
				IBS_SaveName(document.sheet1Form,sheet1);
				sheet1.DoSave( "${ctx}/MedStd.do?cmd=saveMedStd", $("#sheet1Form").serialize());
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
			<li class="txt">의료비기준관리</li>
			<li class="btn">
				<btn:a href="javascript:doAction1('Down2Excel');" 	css="btn outline-gray authR" mid="download" mdef="다운로드"/>
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
