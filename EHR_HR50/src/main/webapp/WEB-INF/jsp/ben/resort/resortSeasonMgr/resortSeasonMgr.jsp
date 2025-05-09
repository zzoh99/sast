<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>리조트계획관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {
		// 숫자만 입력가능
		$("#searchYear").keyup(function() {
			makeNumber(this,'A');
		});

		$("#searchYear").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
				$(this).focus();
			}
		});
		$("#searchConfYn").bind("change",function(event){
			doAction2("Search");
		});

		//$("#searchSDate").val("${curSysYear}-01-01");
		//$("#searchEDate").val("${curSysYear}-12-31");

		//Sheet 초기화
		init_sheet1(); init_sheet2();
		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");


	});

	function init_sheet1(){

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [

			{Header:"No|No",				Type:"${sNoTy}",  Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	SaveName:"sNo",		Sort:0 },
			{Header:"삭제|삭제",				Type:"${sDelTy}", Hidden:0,						Width:"${sDelWdt}",	Align:"Center",	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",				Type:"${sSttTy}", Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"접수기간|시작일자", 		Type:"Date", 	 Hidden:0, Width:90,  Align:"Center", SaveName:"appSdate", 	KeyField:1, Format:"Ymd", 	UpdateEdit:1, InsertEdit:1 , EndDateCol:"appEdate"},
			{Header:"접수기간|종료일자", 		Type:"Date", 	 Hidden:0, Width:90,  Align:"Center", SaveName:"appEdate", 	KeyField:1, Format:"Ymd", 	UpdateEdit:1, InsertEdit:1 , StartDateCol:"appSdate"},
			{Header:"시즌구분|시즌구분", 		Type:"Combo",    Hidden:0, Width:90,  Align:"Center", SaveName:"seasonCd",	KeyField:1,	Format:"", 		UpdateEdit:1, InsertEdit:1 },
			{Header:"계획명|계획명",			Type:"Text", 	 Hidden:0, Width:200, Align:"Left",   SaveName:"title", 	KeyField:1, Format:"", 		UpdateEdit:1, InsertEdit:1 },
			{Header:"신청(사용)기간|시작일자", 	Type:"Date", 	 Hidden:0, Width:90,  Align:"Center", SaveName:"useSdate", 	KeyField:1, Format:"Ymd", 	UpdateEdit:1, InsertEdit:1 , EndDateCol: "useEdate"},
			{Header:"신청(사용)기간|종료일자", 	Type:"Date", 	 Hidden:0, Width:90,  Align:"Center", SaveName:"useEdate", 	KeyField:1, Format:"Ymd", 	UpdateEdit:1, InsertEdit:1 , StartDateCol: "useSdate"},
			{Header:"신청건수|신청건수",			Type:"Text", 	 Hidden:0, Width:60, Align:"Center",   SaveName:"appCnt", 	KeyField:0, Format:"", 		UpdateEdit:0, InsertEdit:0 },
			{Header:"지원대상자\n사용여부|지원대상자\n사용여부", 
											Type:"CheckBox", Hidden:0, Width:60,  Align:"Center", SaveName:"targetYn", 	KeyField:0, Format:"", 		UpdateEdit:1, InsertEdit:1,	TrueValue:"Y",	FalseValue:"N", DefaultValue:"N" },
			{Header:"마감여부|마감여부", 		Type:"CheckBox", Hidden:0, Width:60,  Align:"Center", SaveName:"closeYn", 	KeyField:0, Format:"", 		UpdateEdit:1, InsertEdit:1,	TrueValue:"Y",	FalseValue:"N", DefaultValue:"N" },
			{Header:"유의사항|유의사항", 		Type:"Text", 	 Hidden:0, Width:200, Align:"Left",   SaveName:"note", 		KeyField:0, Format:"", 		UpdateEdit:1, InsertEdit:1 },

			//Hidden
			{Header:"순번|순번", Type:"Text", Hidden:1, SaveName:"planSeq"},


		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetDataAlternateBackColor(sheet1.GetDataBackColor()); //홀짝 배경색 같게
		sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함

	}

	function getCommonCodeList1() {
		let searchYear = $("#searchYear").val();
		let baseSYmd = "";
		let baseEYmd = "";
		if (searchYear !== '') {
			baseSYmd = searchYear + "-01-01";
			baseEYmd = searchYear + "-12-31";
		}

		//성수기구분
		const seasonCdList = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "B49540", baseSYmd, baseEYmd), "");
		sheet1.SetColProperty("seasonCd", {ComboText:seasonCdList[0], ComboCode:seasonCdList[1]} ); //성수기구분
	}

	function init_sheet2(){

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly,FrozenColRight:4};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [

			{Header:"No",		Type:"${sNoTy}",  Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	SaveName:"sNo",		Sort:0 },
			{Header:"삭제",		Type:"${sDelTy}", Hidden:0,						Width:"${sDelWdt}",	Align:"Center",	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}", Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"객실순번", 	Type:"Text",  Hidden:0, Width:55,  Align:"Center", SaveName:"resortSeq", 	KeyField:0, Format:"", 		UpdateEdit:0, InsertEdit:0 },
			{Header:"리조트명", 	Type:"Combo", Hidden:0, Width:80,  Align:"Center", SaveName:"companyCd", 	KeyField:1, Format:"", 		UpdateEdit:0, InsertEdit:1 },
			{Header:"지점명", 	Type:"Text",  Hidden:0, Width:150, Align:"Left",   SaveName:"resortNm", 	KeyField:1, Format:"", 		UpdateEdit:0, InsertEdit:1 },
			{Header:"객실타입", 	Type:"Text",  Hidden:0, Width:150, Align:"Left", SaveName:"roomType", 	KeyField:1, Format:"", 		UpdateEdit:1, InsertEdit:1 },
			{Header:"체크인", 	Type:"Date",  Hidden:0, Width:80,  Align:"Center", SaveName:"sdate", 		KeyField:1, Format:"Ymd", 	UpdateEdit:1, InsertEdit:1 , EndDateCol:"edate"},
			{Header:"체크아웃", 	Type:"Date",  Hidden:0, Width:80,  Align:"Center", SaveName:"edate", 		KeyField:1, Format:"Ymd", 	UpdateEdit:1, InsertEdit:1 , StartDateCol:"sdate"},
			{Header:"박수", 		Type:"Int",   Hidden:0, Width:60,  Align:"Center", SaveName:"days", 		KeyField:1, Format:"", 		UpdateEdit:1, InsertEdit:1 },
			{Header:"예약번호1", 	Type:"Text",  Hidden:0, Width:100, Align:"Center", SaveName:"rsvNo1", 		KeyField:0, Format:"", 		UpdateEdit:1, InsertEdit:1 },
			{Header:"예약번호2", 	Type:"Text",  Hidden:0, Width:100, Align:"Center", SaveName:"rsvNo2", 		KeyField:0, Format:"", 		UpdateEdit:1, InsertEdit:1 },
			{Header:"이용금액", 	Type:"Int",   Hidden:0, Width:100, Align:"Center", SaveName:"resortMon", 	KeyField:0, Format:"", 		UpdateEdit:1, InsertEdit:1 },
			{Header:"지원금액", 	Type:"Int",   Hidden:0, Width:100, Align:"Center", SaveName:"comMon", 		KeyField:0, Format:"", 		UpdateEdit:1, InsertEdit:1 },
			{Header:"개인부담금", 	Type:"Int",   Hidden:0, Width:100, Align:"Center", SaveName:"psnalMon", 	KeyField:0, Format:"", 		UpdateEdit:1, InsertEdit:1 },

			{Header:"신청건수", 	Type:"Int",   Hidden:0, Width:55, Align:"Center", SaveName:"appCnt", 		KeyField:0, Format:"", 		UpdateEdit:0, InsertEdit:0 },
			{Header:"확정", 		Type:"Image", Hidden:0, Width:45, Align:"Center", SaveName:"confYn", 		KeyField:0, Format:"", 		UpdateEdit:0, InsertEdit:0, Sort:0 },
			{Header:"신청\n내역",	Type:"Image", Hidden:0,	Width:45, Align:"Center", SaveName:"detail",		KeyField:0, Format:"",		UpdateEdit:0, InsertEdit:0, Sort:0, Cursor:"Pointer" },
			
			{Header:"Hidden", Type:"Text", Hidden:1, SaveName:"planSeq"},

		]; IBS_InitSheet(sheet2, initdata1);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);
		sheet2.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet2.SetImageList(1,"/common/images/icon/icon_x.png");
		sheet2.SetImageList(2,"/common/images/icon/icon_o.png");

	}

	function getCommonCodeList2() {

		let searchYear = $("#searchYear").val();
		let baseSYmd = "";
		let baseEYmd = "";
		if (searchYear !== '') {
			baseSYmd = searchYear + "-01-01";
			baseEYmd = searchYear + "-12-31";
		}

		//리조트명
		const companyCdList = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "B49530", baseSYmd, baseEYmd), "");
		sheet2.SetColProperty("companyCd", {ComboText:companyCdList[0], ComboCode:companyCdList[1]} ); //리조트명
	}

	function chkInVal(sheet, sdate, edate) {
		// 시작일자와 종료일자 체크
		for (var i=sheet.HeaderRows(); i<=sheet.LastRow(); i++) {
			if (sheet.GetCellValue(i, "sStatus") == "I" || sheet.GetCellValue(i, "sStatus") == "U") {
				if (sheet.GetCellValue(i, edate) != null && sheet.GetCellValue(i, edate) != "") {
					var sdate = sheet.GetCellValue(i, sdate);
					var edate = sheet.GetCellValue(i, edate);
					if (parseInt(sdate) > parseInt(edate)) {
						alert("<msg:txt mid='110396' mdef='시작일자가 종료일자보다 큽니다.'/>");
						sheet.SelectCell(i, edate);
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
				if ($("#searchYear").val().length < 4) {
					alert("년도를 정확히 입력해주세요.");
					return;
				}
				getCommonCodeList1();
				var sXml = sheet1.GetSearchData("${ctx}/ResortSeasonMgr.do?cmd=getResortSeasonMgrList", $("#sheet1Form").serialize() );
				sheet1.LoadSearchData(sXml );
				break;
			case "Save":
				if(!chkInVal(sheet1, "appSdate", "appEdate")){break;}
				if(!chkInVal(sheet1, "useSdate", "useEdate")){break;}
				IBS_SaveName(document.sheet1Form,sheet1);
				sheet1.DoSave( "${ctx}/ResortSeasonMgr.do?cmd=saveResortSeasonMgr", $("#sheet1Form").serialize());
				break;
			case "Insert":
				var row = sheet1.DataInsert(0);
				sheet1.SetCellValue(row, "title", "["+sheet1.GetCellText(row, "seasonCd")+"] 리조트 신청");
				break;
			case "Copy":
				var row = sheet1.DataCopy();
				sheet1.SetCellValue(row, "planSeq", "");
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet1.Down2Excel(param);
				break;
		}
	}



	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
			case "Search":
				getCommonCodeList2();
				var sXml = sheet2.GetSearchData("${ctx}/ResortSeasonMgr.do?cmd=getResortSeasonMgrRoomList", $("#sheet1Form").serialize() );
				sXml = replaceAll(sXml,"sDeleteEdit", "sDelete#Edit");
				sheet2.LoadSearchData(sXml );
				break;
			case "Save":
				if(!chkInVal(sheet2, "sdate", "edate")){break;}
				IBS_SaveName(document.sheet1Form, sheet2);
				sheet2.DoSave( "${ctx}/ResortSeasonMgr.do?cmd=saveResortSeasonMgrRoom", $("#sheet1Form").serialize());
				break;
			case "Insert":
				var parentRow = sheet1.GetSelectRow();
				var row = sheet2.DataInsert(0);
				sheet2.SetCellValue(row, "planSeq", sheet1.GetCellValue(parentRow, "planSeq"));
				break;
			case "Copy":
				var row = sheet2.DataCopy();
				sheet2.SetCellValue(row, "resortSeq", "");
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet2);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet2.Down2Excel(param);
				break;
			case "DownTemplate":
				// 양식다운로드
				var downcol = makeHiddenSkipCol(sheet2);
				sheet2.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:downcol});
				break;
			case "LoadExcel":
				var params = {Mode:"HeaderMatch", WorkSheetNo:1}; 
				sheet2.LoadExcel(params);
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
	
	// 시트 값 변경 시 
	function sheet1_OnChange(Row, Col, Value, OldValue, RaiseFlag) { 
		try {
			if( sheet1.ColSaveName(Col) == "seasonCd" ){
				 sheet1.SetCellValue(Row, "title", "["+sheet1.GetCellText(Row, "seasonCd")+"] 리조트 신청");
			}
		} catch (ex) {
			alert("OnChange Event Error " + ex);
		}
		
	}
	// 셀 선택시 발생
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		try {
			//sheet1.SetRowBackColor(OldRow, "#FFFFFF");
			//sheet1.SetRowBackColor(NewRow, "#FBE7C3");
			$("#searchPlanSeq").val(sheet1.GetCellValue(NewRow, "planSeq"));
			if( OldRow != NewRow ){
				doAction2("Search");
			}

	    } catch (ex) { alert("OnSelectCell Event Error " + ex); }
	}
	// 삭제 체크 전 발생
	function sheet1_OnBeforeCheck(Row, Col) {
		try{
			sheet1.SetAllowCheck(true);

		    if(sheet1.ColSaveName(Col) == "sDelete") {
		        if(sheet1.GetCellValue(Row, "appCnt") != "0") {
		            alert("신청건수가 있어 삭제 할 수 없습니다.");
					sheet1.SetAllowCheck(false);
		        }
		    }

		}catch(ex){alert("OnBeforeCheck Event Error : " + ex);}
	}
	
	//---------------------------------------------------------------------------------------------------------------
	// sheet2 Event
	//---------------------------------------------------------------------------------------------------------------

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
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
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			if( Code > -1 ) doAction2("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	
	// 셀 클릭시 발생
	function sheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if( Row < sheet2.HeaderRows() ) return;

			if( sheet2.ColSaveName(Col) == "detail" ) {
				// 상세보기 팝업
				showResortSeasonMgrPop(Row);

			}
		}
		catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

	function sheet2_OnLoadExcel() {
		var rowCnt = sheet2.RowCount();
		for (var i=1; i<=rowCnt; i++) {
			var parentRow = sheet1.GetSelectRow();
			sheet2.SetCellValue(i, "planSeq", sheet1.GetCellValue(parentRow, "planSeq"));
		}
	}

	//검색 팝업 오픈
	function showResortSeasonMgrPop(Row) {
		if(!isPopup()) {return;}
		
		//var url    = "${ctx}/ResortSeasonMgrPop.do?cmd=viewResortSeasonMgrPop";
        var args    = new Array();
		
        args["planSeq"] = sheet2.GetCellValue(Row, "planSeq");
        args["resortSeq"] = sheet2.GetCellValue(Row, "resortSeq");
        args["resortNm"] = sheet2.GetCellValue(Row, "resortNm");
        args["companyCd"] = sheet2.GetCellValue(Row, "companyCd");
        
        //openPopup(url, args, "1050","770", function (){  doAction2('Search'); });
        let layerModal = new window.top.document.LayerModal({
            id : 'resortSeasonMgrLayer'
            , url : '${ctx}/ResortSeasonMgr.do?cmd=viewResortSeasonMgrLayer'
            , parameters : args
            , width : 1050
            , height : 770
            , title : '신청리조트관리'
            , trigger :[
                {
                    name : 'resortSeasonMgrTrigger'
                    , callback : function(result){
                    }
                }
            ]
        });
        layerModal.show();
	}
	
</script>
<style type="text/css">
table.table01 th { border:0;padding-right:10px;}
</style>
</head>
<body class="bodywrap">
<div class="wrapper">
<form name="sheet1Form" id="sheet1Form" method="post">
	<input type="hidden" id="searchPlanSeq" name="searchPlanSeq" />
	<div class="sheet_search outer">
		<table>
		<tr>
			<th>기준년도</th>
			<td>
				<input type="text" id="searchYear" name="searchYear" class="date2 w80" value="${curSysYear}" maxlength="4"/>
			</td>
			<td>
				<a href="javascript:doAction1('Search')" class="btn dark">조회</a>
			</td>
		</tr>
		</table>
	</div>

	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">성수기 신청기간 관리</li>
			<li class="btn">
				<a href="javascript:doAction1('Down2Excel');" 	class="btn outline-gray authR">다운로드</a>
				<a href="javascript:doAction1('Copy')" 			class="btn outline-gray authA">복사</a>
				<a href="javascript:doAction1('Insert')" 		class="btn outline-gray authA">입력</a>
				<a href="javascript:doAction1('Save');" 		class="btn filled authA">저장</a>
			</li>
		</ul>
		</div>
		<script type="text/javascript"> createIBSheet("sheet1", "100%", "200px"); </script>
	</div>

	<div class="sheet_title inner">
	<ul>
		<li class="txt">성수기 리조트 객실관리</li>
		<li class="btn">
			<span><b>확정여부</b></span>
			<select id="searchConfYn" name="searchConfYn">
				<option value="">전체</option>
				<option value="Y">확정</option>
				<option value="N">미확정</option>
			</select>
			&nbsp;&nbsp;&nbsp;&nbsp;
			<a href="javascript:doAction2('Down2Excel');" 	class="btn outline-gray authR">다운로드</a>
			<a href="javascript:doAction2('DownTemplate')" 	class="btn outline-gray authR">양식다운로드</a>
			<a href="javascript:doAction2('LoadExcel')" 	class="btn outline-gray authR">업로드</a>
			<a href="javascript:doAction2('Copy')" 			class="btn outline-gray authA">복사</a>
			<a href="javascript:doAction2('Insert')" 		class="btn outline-gray authA">입력</a>
			<a href="javascript:doAction2('Save');" 		class="btn filled authA">저장</a>
		</li>
	</ul>
	</div>
	<script type="text/javascript"> createIBSheet("sheet2", "100%", "100%"); </script>
</form>
</div>
</body>
</html>
