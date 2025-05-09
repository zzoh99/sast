<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>이러닝기준관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {
		//TAB
		$("#tabs").tabs();
		$("#tabsIndex").val('0');

		initTabsLine(); //탭 하단 라인 추가
		
		// 숫자만 입력가능
		$("#searchYear").keyup(function() {
			makeNumber(this,'A');
			if( event.keyCode == 13) {
				doAction1("Search");
			}
		});
		
		
		
		//Sheet 초기화
		init_sheet1();
		init_sheet2();
		init_sheet3();
		init_sheet4();

		$(window).smartresize(sheetResize); sheetInit();
		
		doAction1("Search");


	});

	//[이러닝신청기간] Sheet 초기화 
	function init_sheet1(){

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"No|No",			Type:"${sNoTy}",	Hidden:0,				Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",			Type:"${sDelTy}",	Hidden:"${sDelHdn}",	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",			Type:"${sSttTy}",	Hidden:"${sSttHdn}",	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"대상년월|대상년월",		 Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"ym",		KeyField:1,	Format:"Ym",		PointCount:0,	UpdateEdit:0,	InsertEdit:1 },
			{Header:"신청기간|시작일",		 Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"sdate",	KeyField:1,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1, EndDateCol:"edate"},
			{Header:"신청기간|종료일",		 Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"edate",	KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1, StartDateCol:"sdate"},
			{Header:"신청가능\n건수|신청가능\n건수",Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appCnt",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1, EditLen:2 },
			{Header:"비고|비고",			 Type:"Text",		Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"note",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2000 }
			
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
	}

	//[신청건수 에외자] Sheet 초기화 
	function init_sheet2(){

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"No|No",			Type:"${sNoTy}",	Hidden:0,				Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",			Type:"${sDelTy}",	Hidden:"${sDelHdn}",	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",			Type:"${sSttTy}",	Hidden:"${sSttHdn}",	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"사번|사번",		 	 Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"sabun",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"성명|성명",		 	 Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"name",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1},
			{Header:"부서|부서",		 	 Type:"Text",		Hidden:0,	Width:130,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"직위|직위",		 	 Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"시작일|시작일",		 Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"sdate",	KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1, EndDateCol:"edate"},
			{Header:"종료일|종료일",		 Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"edate",	KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1, StartDateCol:"sdate"},
			{Header:"신청가능\n건수|신청가능\n건수",Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appCnt",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1, EditLen:2  },
			{Header:"비고|비고",			 Type:"Text",		Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"note",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2000 }
			
		]; IBS_InitSheet(sheet2, initdata1);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		// 이름 입력 시 자동완성
		$(sheet2).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet2.SetCellValue(gPRow, "sabun", rv["sabun"]);
						sheet2.SetCellValue(gPRow, "name", rv["name"]);
						sheet2.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
						sheet2.SetCellValue(gPRow, "jikweeNm", rv["jikweeNm"]);
					}
				}
			]
		});
	}

	//[이러닝신청항목] Sheet 초기화 
	function init_sheet3(){

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:0,				Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",			Type:"${sDelTy}",	Hidden:"${sDelHdn}",	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",			Type:"${sSttTy}",	Hidden:"${sSttHdn}",	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"코드",		 	Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"code",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1, EditLen:10 },
			{Header:"이러닝항목",		Type:"Text",		Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"codeNm",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1, EditLen:100 },
			{Header:"사용\n여부",		Type:"CheckBox",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"useYn",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y",	FalseValue:"N" },
			{Header:"강좌명\n직접등록",	Type:"CheckBox",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"note2",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y",	FalseValue:"N" },
			{Header:"<sht:txt mid='codeIdx' mdef='코드순번'/>",		Type:"Text",		Hidden:1,	Width:0, Align:"Center",	ColMerge:0,	SaveName:"codeIdx",	UpdateEdit:0, InsertEdit:0},
			{Header:"시작일",		 Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"sdate",	KeyField:1,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1, EndDateCol:"edate"},
			{Header:"종료일",		 Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"edate",	KeyField:1,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1, StartDateCol:"sdate"},
			{Header:"비고",			Type:"Text",		Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"note1",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },

		]; IBS_InitSheet(sheet3, initdata1);sheet3.SetEditable("${editable}");sheet3.SetVisible(true);sheet3.SetCountPosition(4);
		
	}

	//[이러닝신청항목] Sheet 초기화 
	function init_sheet4(){

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:0,				Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",			Type:"${sDelTy}",	Hidden:"${sDelHdn}",	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",			Type:"${sSttTy}",	Hidden:"${sSttHdn}",	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"이러닝항목",		Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"itemNm",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"세부항목",		Type:"Text",		Hidden:0,	Width:200,	Align:"Center",	ColMerge:0,	SaveName:"codeNm",	KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1, EditLen:100},
			{Header:"유효개월",		Type:"Int",			Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"note2",	KeyField:1,	Format:"##\\개월",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2 },
			{Header:"<sht:txt mid='codeIdx' mdef='코드순번'/>",		Type:"Text",		Hidden:1,	Width:0, Align:"Center",	ColMerge:0,	SaveName:"codeIdx",	UpdateEdit:0, InsertEdit:0},
			{Header:"시작일",		 Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"sdate",	KeyField:1,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1, EndDateCol:"edate"},
			{Header:"종료일",		 Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"edate",	KeyField:1,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1, StartDateCol:"sdate"},
			{Header:"비고",			Type:"Text",		Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"note3",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },

			//Hidden
			{Header:"Hidden", Hidden:1, SaveName:"code"},
			{Header:"Hidden", Hidden:1, SaveName:"note1"},
		]; IBS_InitSheet(sheet4, initdata1);sheet4.SetEditable("${editable}");sheet4.SetVisible(true);sheet4.SetCountPosition(4);
		
	}


	function checkList(){
		if( $("#searchYear").val() == "" ){
			alert("기준년도를 입력 해주세요");
			$("#searchYear").focus();
			return false;
		}

		if( $("#searchYear").val().length != 4 ){
			alert("기준년도를 정확히 입력 해주세요");
			$("#searchYear").focus();
			return false;
		}
		return true;
	}

	function chkInVal(sheet) {
		// 시작일자와 종료일자 체크
		for (var i=sheet.HeaderRows(); i<=sheet.LastRow(); i++) {
			if (sheet.GetCellValue(i, "sStatus") == "I" || sheet.GetCellValue(i, "sStatus") == "U") {
				if (sheet.GetCellValue(i, "edate") != null && sheet.GetCellValue(i, "edate") != "") {
					var sdate = sheet.GetCellValue(i, "sdate");
					var edate = sheet.GetCellValue(i, "edate");
					if (parseInt(sdate) > parseInt(edate)) {
						alert("<msg:txt mid='110396' mdef='시작일자가 종료일자보다 큽니다.'/>");
						sheet.SelectCell(i, "edate");
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
				if( !checkList() ) return;
				sheet1.DoSearch( "${ctx}/EduElStd.do?cmd=getEduElStdList", $("#sheet1Form").serialize() );
				
				doAction2("Search");
				doAction3("Search");
				break;
			case "Save":
				if(!chkInVal(sheet1)) {break;}
				IBS_SaveName(document.sheet1Form,sheet1);
				sheet1.DoSave( "${ctx}/EduElStd.do?cmd=saveEduElStdDate", $("#sheet1Form").serialize());
				break;
			case "Insert":
				var row = sheet1.DataInsert(0);
				//sheet1.SetCellValue(row, "useYn", "Y");
				break;
			case "Copy":
				var row = sheet1.DataCopy();
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet1.Down2Excel(param);
				break;
			case "Prc":
				if( !checkList() ) return;

		        if (!confirm("신청기간을 생성 하시겠습니까?\n(삭제 후 다시 생성 됩니다.)")) return;
				
				progressBar(true) ;
				
				setTimeout(
					function(){
				    	
						var data = ajaxCall("${ctx}/EduElStd.do?cmd=prcEduElStd", $("#sheet1Form").serialize(),false);
				    	if(data.Result.Code == null) {
				    		doAction1("Search");
				    		alert("처리되었습니다.");
					    	progressBar(false) ;
				    	} else {
					    	alert("처리중 오류가 발생했습니다.\n"+data.Result.Message);
					    	progressBar(false) ;
				    	}
					}
				, 100);
		}
	}
	
	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
			case "Search":
				sheet2.DoSearch( "${ctx}/EduElStd.do?cmd=getEduElStdEmpList", $("#sheet1Form").serialize() );
				break;
			case "Save":
				if(!chkInVal(sheet2)) {break;}
				IBS_SaveName(document.sheet1Form,sheet2);
				sheet2.DoSave( "${ctx}/EduElStd.do?cmd=saveEduElStdEmp", $("#sheet1Form").serialize());
				break;
			case "Insert":
				var row = sheet2.DataInsert(0);
				sheet2.SetCellValue(row, "sdate", "${curSysYyyyMMddHyphen}");
				sheet2.SetCellValue(row, "appCnt", 2);
				break;
			case "Copy":
				var row = sheet2.DataCopy();
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet2);
				var d = new Date();
				var fName = "신청건수예외자_" + d.getTime();
				var param  = {FileName:fName, DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet2.Down2Excel(param);
				break;
		}
	}


	//Sheet3 Action
	function doAction3(sAction) {
		switch (sAction) {
			case "Search":
				sheet3.DoSearch( "${ctx}/EduElStd.do?cmd=getEduElStdItemList", $("#sheet1Form").serialize() );
				break;
			case "Save":
				if(!chkInVal(sheet3)) {break;}
				IBS_SaveName(document.sheet1Form,sheet3);
				sheet3.DoSave( "${ctx}/EduElStd.do?cmd=saveEduElStdItem", $("#sheet1Form").serialize());
				break;
			case "Insert":
				var row = sheet3.DataInsert(-1);
				sheet3.SetCellValue(row, "useYn", "Y");
				break;
			case "Copy":
				var row = sheet3.DataCopy();
				sheet3.SetCellValue(row, 'code', '');
				sheet3.SetCellValue(row, 'codeIdx', '');
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet3);
				var d = new Date();
				var fName = "이러닝신청항목_" + d.getTime();
				var param  = {FileName:fName, DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet3.Down2Excel(param);
				break;
		}
	}

	//Sheet4 Action
	function doAction4(sAction) {
		switch (sAction) {
			case "Search":
				sheet4.DoSearch( "${ctx}/EduElStd.do?cmd=getEduElStdItemDtlList", $("#sheet1Form").serialize() );
				break;
			case "Save":
				if(!chkInVal(sheet4)) {break;}
				IBS_SaveName(document.sheet1Form,sheet4);
				sheet4.DoSave( "${ctx}/EduElStd.do?cmd=saveEduElStdItemDtl", $("#sheet1Form").serialize());
				break;
			case "Insert":
				var row = sheet4.DataInsert(-1);
				sheet4.SetCellValue(row, "itemNm", sheet3.GetCellValue(sheet3.GetSelectRow(), "codeNm"));
				sheet4.SetCellValue(row, "note1", $("#searchItemCd").val());
				break;
			case "Copy":
				var row = sheet4.DataCopy();
				sheet4.SetCellValue(row, 'code', '');
				sheet4.SetCellValue(row, 'codeIdx', '');
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet4);
				var d = new Date();
				var fName = "이러닝신청세부항목_" + d.getTime();
				var param  = {FileName:fName, DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet4.Down2Excel(param);
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
			alert("sheet1_OnSearchEnd Event Error : " + ex);
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
			alert("sheet1_OnSaveEnd Event Error " + ex);
		}
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
			alert("sheet2_OnSearchEnd Event Error : " + ex);
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
			alert("sheet2_OnSaveEnd Event Error " + ex);
		}
	}

	// 셀 팝업 클릭 시
	function sheet2_OnPopupClick(Row, Col) {
		try {
			if( Row < sheet2.HeaderRows() ) return;
			
			if (sheet2.ColSaveName(Col) == "name") {  //대상자 선택
				if (!isPopup()) {  return; }

				gPRow = Row;
				pGubun = "employeePopup";
	            var rst = openPopup("/Popup.do?cmd=employeePopup&authPg=A", "", "740","520");
				
			}

		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}
	
	//---------------------------------------------------------------------------------------------------------------
	// 팝업 콜백 함수.
	//---------------------------------------------------------------------------------------------------------------
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue + '}');
		if (pGubun == "employeePopup"){
			sheet2.SetCellValue(gPRow, "sabun",		rv["sabun"] );
			sheet2.SetCellValue(gPRow, "name",		rv["name"] );
			sheet2.SetCellValue(gPRow, "orgNm",		rv["orgNm"] );
			//sheet2.SetCellValue(gPRow, "jikchakNm",	rv["jikchakNm"] );
			sheet2.SetCellValue(gPRow, "jikweeNm",	rv["jikweeNm"] );
			//sheet2.SetCellValue(gPRow, "jikgubNm",	rv["jikgubNm"] );
		}

	}
	

	//---------------------------------------------------------------------------------------------------------------
	// sheet3 Event
	//---------------------------------------------------------------------------------------------------------------

	// 조회 후 에러 메시지
	function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) {
			alert("sheet3_OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet3_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			if( Code > -1 ) doAction3("Search");
		} catch (ex) {
			alert("sheet3_OnSaveEnd Event Error " + ex);
		}
	}

	// 셀 선택 시 
	function sheet3_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		try {
			if( sheet3.GetCellValue(NewRow, "sStatus") == "I" ){
				sheet4.RemoveAll();
			}else if( OldRow != NewRow ){
				$("#searchItemCd").val(sheet3.GetCellValue(NewRow, "code"));
				doAction4("Search");
			}
		} catch (ex) {
			alert("sheet3_OnSelectCell Event Error : " + ex);
		}
	}
	//---------------------------------------------------------------------------------------------------------------
	// sheet3 Event
	//---------------------------------------------------------------------------------------------------------------

	// 조회 후 에러 메시지
	function sheet4_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) {
			alert("sheet4_OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet4_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			if( Code > -1 ) doAction4("Search");
		} catch (ex) {
			alert("sheet4_OnSaveEnd Event Error " + ex);
		}
	}


	//---------------------------------------------------------------------------------------------------------------
	// TAB 
	//---------------------------------------------------------------------------------------------------------------
	function moveTab(idx){
		$("#tabsIndex").val(idx);
		$("#tabs").tabs( "option", "active", idx );

		sheetResize();
	}
	
</script>
</head>
<body class="bodywrap">
<div class="wrapper">

<form name="sheet1Form" id="sheet1Form" method="post">
	<input type="hidden" id="searchItemCd" name="searchItemCd" />
	<div class="sheet_search outer">
		<table>
		<tr>
			<th>기준년도</th>
			<td>
				<input type="text" id="searchYear" name="searchYear" class="text required w70 center" value="${curSysYear}" maxlength="4"/>
			</td>
			<td>
				<a href="javascript:doAction1('Search')" class="btn dark">조회</a>
			</td>
		</tr>
		</table>
	</div>
</form>
<div class="h10 outer"></div>	
<div id="tabs" class="tab">
	<div class='ui-tabs-nav-line' style="left:125px"></div> <!-- 탭 하단 라인 -->
	<ul class="tab_bottom outer">
		<li><a href="#tabs-0" onclick="javascript:moveTab(0)" >이러닝신청기간 및 예외자</a></li>
		<li><a href="#tabs-1" onclick="javascript:moveTab(1)" >이러닝신청항목</a></li>
	</ul>
	<div id="tabs-0">
		<div class="sheet_title inner">
			<ul>
				<li class="txt">이러닝신청기간</li>
				<li class="btn">
					<a href="javascript:doAction1('Down2Excel');" 	class="btn outline-gray authR">다운로드</a>
					<a href="javascript:doAction1('Copy')" 			class="btn outline-gray authA">복사</a>
					<a href="javascript:doAction1('Insert')" 		class="btn outline-gray authA">입력</a>
					<a href="javascript:doAction1('Save');" 		class="btn soft authA">저장</a>
					<a href="javascript:doAction1('Prc')" 			class="btn filled authA">자동생성</a>
				</li>
			</ul>
		</div>
		
		<script type="text/javascript"> createIBSheet("sheet1", "100%", "50%"); </script>		
		
		<div class="sheet_title">
			<ul>
				<li class="txt">신청건수 예외자</li>
				<li class="btn">
					<a href="javascript:doAction2('Down2Excel');" 	class="btn outline-gray authR">다운로드</a>
					<a href="javascript:doAction2('Copy')" 			class="btn outline-gray authA">복사</a>
					<a href="javascript:doAction2('Insert')" 		class="btn outline-gray authA">입력</a>
					<a href="javascript:doAction2('Save');" 		class="btn filled authA">저장</a>
				</li>
			</ul>
		</div>
		<script type="text/javascript"> createIBSheet("sheet2", "100%", "50%"); </script>		
	
	</div>
	<div id="tabs-1">
		<table class="sheet_main">
		<colgroup>
			<col width="" />
			<col width="30px" />
			<col width="50%" />
		</colgroup>
		<tr>
			<td class="sheet_left">
				<div class="sheet_title inner">
					<ul>
						<li class="txt">이러닝신청항목</li>
						<li class="btn">
							<a href="javascript:doAction3('Down2Excel');" 	class="btn outline-gray authR">다운로드</a>
							<a href="javascript:doAction3('Copy')" 			class="btn outline-gray authA">복사</a>
							<a href="javascript:doAction3('Insert')" 		class="btn outline-gray authA">입력</a>
							<a href="javascript:doAction3('Save');" 		class="btn filled authA">저장</a>
						</li>
					</ul>
				</div>
				<script type="text/javascript"> createIBSheet("sheet3", "100%", "100%"); </script>		
			</td>
			
			<td class="sheet_right" rowspan="2"><div style="padding-top:200px;" class="setBtn"><img src="/common/images/sub/ico_arrow.png"/></div></td>
			
			<td class="sheet_right">
				<div class="sheet_title inner">
					<ul>
						<li class="txt">이러닝신청세부항목</li>
						<li class="btn">
							<a href="javascript:doAction4('Down2Excel');" 	class="btn outline-gray authR">다운로드</a>
							<a href="javascript:doAction4('Copy')" 			class="btn outline-gray authA">복사</a>
							<a href="javascript:doAction4('Insert')" 		class="btn outline-gray authA">입력</a>
							<a href="javascript:doAction4('Save');" 		class="btn filled authA">저장</a>
						</li>
					</ul>
				</div>
				<script type="text/javascript"> createIBSheet("sheet4", "100%", "100%"); </script>		
			</td>		
		</tr>	
		</table>
	</div>
</div>	
</div>
</body>
</html>
