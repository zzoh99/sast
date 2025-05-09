<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>사회보험신고항목관리</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	
	var today = "<%=curSysYyyyMMdd%>";
	$(function() {
		
		$("#searchDeclarationOrgCd, #searchDeclarationType").change(function(){
			doAction1("Search");
		});

		// 1번 그리드
		var initdata0 = {};
		initdata0.Cfg = {SearchMode:smLazyLoad,Page:22}; 
		initdata0.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata0.Cols = [
				{Header:"No",			Type:"<%=sNoTy%>",	Hidden:Number("<%=sNoHdn%>"),	Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,	SaveName:"sNo" },
				{Header:"삭제",			Type:"<%=sDelTy%>",	Hidden:Number("<%=sDelHdn%>"),	Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,	SaveName:"sDelete" , Sort:0},
				{Header:"상태",			Type:"<%=sSttTy%>",	Hidden:Number("<%=sSttHdn%>"),	Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,	SaveName:"sStatus" , Sort:0},
				{Header:"기관구분",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"declaration_org_cd",	KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
				{Header:"신고유형",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"declaration_type",	KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
				{Header:"사용시작일",		Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"use_sdate",			KeyField:1,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
				{Header:"사용종료일",		Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"use_edate",			KeyField:0,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
				{Header:"출력형태",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"export_type",			KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
				{Header:"EDI파일인코딩",	Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"edi_encoding",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
				{Header:"구분자",			Type:"Text",		Hidden:0,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"delimiter",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
				{Header:"비고",			Type:"Text",		Hidden:0,	Width:180,	Align:"Left",	ColMerge:0,	SaveName:"note",				KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000 },
				{Header:"항목등록수",		Type:"Int",			Hidden:1,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"ele_cnt",				KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000 }
		]; 
		IBS_InitSheet(sheet1, initdata0); sheet1.SetCountPosition(4);

		var declarationOrgCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","BD0001"), "전체");
		sheet1.SetColProperty("declaration_org_cd",	{ComboText:"|"+declarationOrgCdList[0], ComboCode:"|"+declarationOrgCdList[1]} );
		$("#searchDeclarationOrgCd").html(declarationOrgCdList[2]);

		var declarationTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","BD0002"), "전체");
		sheet1.SetColProperty("declaration_type",	{ComboText:"|"+declarationTypeList[0], ComboCode:"|"+declarationTypeList[1]} );
		$("#searchDeclarationType").html(declarationTypeList[2]);
		
		var exportTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","BD0003"), "");
		sheet1.SetColProperty("export_type",		{ComboText:exportTypeList[0], ComboCode:exportTypeList[1]} );

		// 2번 그리드
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22, MergeSheet:msHeaderOnly}; 
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata1.Cols = [
			{Header:"No|No",						Type:"<%=sNoTy%>",	Hidden:Number("<%=sNoHdn%>"),	Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",						Type:"<%=sDelTy%>",	Hidden:Number("<%=sDelHdn%>"),	Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,	SaveName:"sDelete" , Sort:0},
			{Header:"상태|상태",						Type:"<%=sSttTy%>",	Hidden:Number("<%=sSttHdn%>"),	Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,	SaveName:"sStatus" , Sort:0},

			{Header:"항목명|항목명",					Type:"Text",		Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"element_nm",				KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:500 },
			{Header:"순서|순서",						Type:"Int",			Hidden:0,	Width:50,	Align:"Right",	ColMerge:0,	SaveName:"display_seq",				KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"입력유형|입력유형",				Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"element_type",			KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"매핑그룹코드|매핑그룹코드",			Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"mapping_cd",				KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"필수입력|필수입력",				Type:"CheckBox",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"element_required_yn",		KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100,	TrueValue:"Y",	FalseValue:"N" },
			{Header:"전산매체생성설정|길이",			Type:"Text",		Hidden:0,	Width:50,	Align:"Right",	ColMerge:0,	SaveName:"element_length",			KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"전산매체생성설정|정렬",			Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"element_align",			KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"전산매체생성설정|순서",			Type:"Int",			Hidden:0,	Width:50,	Align:"Right",	ColMerge:0,	SaveName:"element_seq",				KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"전산매체생성설정|생성여부",			Type:"CheckBox",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"edi_export_yn",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100,	TrueValue:"Y",	FalseValue:"N" },
			{Header:"전산매체생성설정|공백대체문자",		Type:"Text",		Hidden:0,	Width:70,	Align:"Left",	ColMerge:0,	SaveName:"element_empty_char",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"기본값설정|고정값",				Type:"Text",		Hidden:0,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"element_fix_value",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"기본값설정|기본값",				Type:"Text",		Hidden:0,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"element_default_value",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"기본값설정|기본값(SQL조회)",		Type:"Text",		Hidden:0,	Width:310,	Align:"Left",	ColMerge:0,	SaveName:"sql_syntax",				KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000,	MultiLineText:1 },
			{Header:"설명|설명",						Type:"Text",		Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"element_desc",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"기관구분|기관구분",				Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"declaration_org_cd",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"신고유형|신고유형",				Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"declaration_type",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"사용시작일|사용시작일",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"use_sdate",				KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 }
		];	 
		IBS_InitSheet(sheet2, initdata1); sheet2.SetCountPosition(4);
		
		var elementTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","BD0004"), "");
		sheet2.SetColProperty("element_type",	{ComboText:elementTypeList[0], ComboCode:elementTypeList[1]} );
		sheet2.SetColProperty("element_align",	{ComboText:"왼쪽정렬|오른쪽정렬", ComboCode:"L|R"} );
		
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});
	
	//Sheet Action First
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				sheet1.DoSearch( "<%=jspPath%>/declarationEleMgr/declarationEleMgrRst.jsp?cmd=getDeclarationEleMgrTemplateList", $("#sheet1Form").serialize() ); 
				break;
			case "Save":
				var dupRow = sheet1.ColValueDup("3|4|5", 0);
				if(dupRow > 0) {
					alert("기관구분, 신고유형, 사용시작일이 중복되는 데이터가 존재합니다.");
					return;
				}
				sheet1.DoSave( "<%=jspPath%>/declarationEleMgr/declarationEleMgrRst.jsp?cmd=saveDeclarationEleMgrTemplate", $("#sheet1Form").serialize());
				break;
			case "Insert":
				var row = sheet1.DataInsert(0);
				if( $("#searchDeclarationOrgCd").val() != "" ) {
					sheet1.SetCellValue(row, "declaration_org_cd", $("#searchDeclarationOrgCd").val());
				}
				if( $("#searchDeclarationType").val() != "" ) {
					sheet1.SetCellValue(row, "declaration_type", $("#searchDeclarationType").val());
				}
				sheet1.SetCellValue(row, "use_sdate", today);
				sheet1.SetCellValue(row, "use_edate", "99991231");
				sheet1.SetCellValue(row, "ele_cnt", "0");

				/*
				if( $("#searchDeclarationOrgCd").val() != "" && $("#searchDeclarationType").val() != "" ) {
					var orgCd = $("#searchDeclarationOrgCd").val();
					var useSdate = parseInt(today);
					var lastRow = 0;
					
					// 동일 기관의 신고유형들중 기존 데이터들의 사용종료일 데이터 수정 처리
					for(var i = sheet1.HeaderRows(); i < (sheet1.RowCount() + sheet1.HeaderRows()); i++) {
						if( row != i ) {
							if( orgCd == sheet1.GetCellValue(i, "declaration_org_cd")
									&& $("#searchDeclarationType").val() == sheet1.GetCellValue(i, "declaration_type") ) {
								
								// 입력중인 행의 시작일보다 이전일이며 종료일이 시작일보다 이후인 경우 종료일을 시작일 1일전으로 세팅함.
								if(sheet1.GetCellValue(i, "use_sdate") != ""
										&& parseInt(sheet1.GetCellValue(i, "use_sdate")) < useSdate
										&& sheet1.GetCellValue(i, "use_edate") != ""
										&& parseInt(sheet1.GetCellValue(i, "use_edate")) >= useSdate) {
									
									sheet1.SetCellValue(i, "use_edate", addDate('d', -1, sheet1.GetCellValue(row, "use_sdate"), ""));
								}
							}
						}
					}
				}
				*/
				
				sheet1.SelectCell(row, 3);
				break;
			case "Copy":
				var Row = sheet1.DataCopy();
				sheet1.SelectCell(Row, 5);
				break;
			case "Clear":
				sheet1.RemoveAll();
				break;
			case "Down2Excel":  	
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
				sheet1.Down2Excel(param);
				break;
		}
	}
	
	//Sheet Action Second
	function doAction2(sAction) {
		
		if ( (sheet1.GetCellValue(sheet1.GetSelectRow(),"sStatus") == "I") && !(sAction=="Search") ) {
			alert("상단의 신고서목록에서 \"입력\"작업을 완료한 후에 상세목록 작업을 진행해주시기 바랍니다.	 ");
			return;
		}
		
		switch (sAction) {
			case "Search":
				var row     = sheet1.GetSelectRow();
				var params  = "declaration_org_cd=" + sheet1.GetCellValue(row, "declaration_org_cd");
				    params += "&declaration_type=" + sheet1.GetCellValue(row, "declaration_type");
				    params += "&use_sdate=" + sheet1.GetCellValue(row, "use_sdate");
				sheet2.DoSearch( "<%=jspPath%>/declarationEleMgr/declarationEleMgrRst.jsp?cmd=getDeclarationEleMgrList", params );
				break;
			case "Save":
				var dupRow = sheet2.ColValueDup("3", 0);
				if(dupRow > 0) {
					alert("항목명이 중복되는 데이터가 존재합니다.");
					return;
				}
				var dupSeqRow = sheet2.ColValueDup("4", 0);
				if(dupSeqRow > 0) {
					alert("화면 출력순서가  중복되는 데이터가 존재합니다.");
					return;
				}
				
				var isValid = true;
				for(var row = sheet2.HeaderRows(); row < (sheet2.RowCount() + sheet2.HeaderRows()); row++) {
					if(sheet2.GetCellValue(row, "edi_export_yn") == "Y") {
						if(sheet2.GetCellValue(row, "element_seq") == "") {
							alert("[" + sheet2.GetCellValue(row, "element_nm") + "] 항목의 전산매체생성시 순서가 입력되지 않았습니다.");
							isValid = false;
						}
					}
				}
				
				if(!isValid) {
					return
				}
				
				sheet2.DoSave( "<%=jspPath%>/declarationEleMgr/declarationEleMgrRst.jsp?cmd=saveDeclarationEleMgr", $("#sheet1Form").serialize());
				break;
			case "Insert":	  
				var row    = sheet1.GetSelectRow();
				var newRow = sheet2.DataInsert(0);
				sheet2.SetCellValue(newRow, "declaration_org_cd", sheet1.GetCellValue(row, "declaration_org_cd"));
				sheet2.SetCellValue(newRow, "declaration_type", sheet1.GetCellValue(row, "declaration_type"));
				sheet2.SetCellValue(newRow, "use_sdate", sheet1.GetCellValue(row, "use_sdate"));
				sheet2.SetCellValue(newRow, "edi_export_yn", "Y");
				sheet2.SelectCell(newRow, "element_nm");
				break;
			case "Copy":
				sheet2.DataCopy();
				break;
			case "Down2Excel":  	
				var downcol = makeHiddenSkipCol(sheet2);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
				sheet2.Down2Excel(param);
				break;
		 }
	}
	
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	
	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); doAction1("Search");}} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}
	
	
		// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	
	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); doAction2("Search"); }} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}
	
	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction1("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
				sheet1.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		//alert("mySheetLeft_OnClick Click : \nRow:"+ Row+" \nCol:"+Col+" \nValue:"+Value+" \nCellX:"+CellX+" \nCellY:"+CellY+" \nCellW:"+CellW+" \nCellH:"+CellH );
		try{
		}catch(ex){alert("OnSelectCell Event Error : " + ex);	}
	}
	
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try{
			if(OldRow != NewRow){
				doAction2("Search");
			}
		}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}
	
	function sheet1_OnBeforeCheck(Row, Col) {
		try{
			if(sheet1.ColSaveName(Row, Col) == "sDelete") {
				if(parseInt(sheet1.GetCellValue(Row, "ele_cnt")) > 0) {
					alert("세부항목이 등록되어 있어 삭제할 수 없습니다.");
					sheet1.SetAllowCheck(0);//체크를 막는다.
				} else {
					sheet1.SetAllowCheck(1);
				}
			}
		}catch(ex){alert("sheet1_OnBeforeCheck Event Error : " + ex);	}
	}
	
	function sheet1_OnChange(Row, Col, Value, OldValue, RaiseFlag) {
		try{
			if(sheet1.ColSaveName(Col) == "declaration_type") {
				/*
				var orgCd = sheet1.GetCellValue(Row, "declaration_org_cd");
				var useSdate = parseInt(sheet1.GetCellValue(Row, "use_sdate"));
				var lastRow = 0;
				
				// 동일 기관의 신고유형들중 기존 데이터들의 사용종료일 데이터 수정 처리
				for(var i = sheet1.HeaderRows(); i < (sheet1.RowCount() + sheet1.HeaderRows()); i++) {
					if( Row != i ) {
						if( orgCd == sheet1.GetCellValue(i, "declaration_org_cd") && Value == sheet1.GetCellValue(i, "declaration_type") ) {
							
							// 입력중인 행의 시작일보다 이전일이며 종료일이 시작일보다 이후인 경우 종료일을 시작일 1일전으로 세팅함.
							if(sheet1.GetCellValue(i, "use_sdate") != ""
									&& parseInt(sheet1.GetCellValue(i, "use_sdate")) < useSdate
									&& sheet1.GetCellValue(i, "use_edate") != ""
									&& parseInt(sheet1.GetCellValue(i, "use_edate")) >= useSdate) {
								
								sheet1.SetCellValue(i, "use_edate", addDate('d', -1, sheet1.GetCellValue(Row, "use_sdate"), ""));
							}
						}
					}
				}
				*/
			}
		}catch(ex){alert("sheet1_OnChange Event Error : " + ex);	}
	}

	function sheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			// sqlSyntax
			if(sheet2.ColSaveName(Col) == "sql_syntax") {
				openSQLSyntaxEditPopup(Row, Col);
			}
		} catch(ex) {
			alert("SHEET2's OnSelectCell Event Error : " + ex);
		}
	}
	
	// 기본값(SQL조회) 편집팝업창 출력
	function openSQLSyntaxEditPopup(Row, Col) {
		if(!isPopup()) {return;}
		gPRow = Row;
		pGubun = "sqlSyntaxEditPopup";

  		var w 		= 640;
		var h 		= 690;
		var url 	= "<%=jspPath%>/common/sqlSyntaxEditPopup.jsp";
		var args 	= new Array();
		
		var sqlSyntax = sheet2.GetCellValue(Row, "sql_syntax");
			sqlSyntax = sqlSyntax.replace(/\n/g, "\\n");
			sqlSyntax = sqlSyntax.replace(/\r/g, "\\r");
			sqlSyntax = sqlSyntax.replace(/\t/g, "\\t");
		
		args["sqlSyntax"] = sqlSyntax;

		var rv = openPopup(url,args,w,h);
	}
	
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{'+ returnValue+'}');
		console.log('rv', rv);
		if ( pGubun == "sqlSyntaxEditPopup" ){
			sheet2.SetCellValue(gPRow, "sql_syntax", rv["sqlSyntax"] );
		}
	}
	
</script>
</head>
<body class="bodywrap">
<div class="wrapper">

	<div class="sheet_search outer">
	<form id="sheet1Form" name="sheet1Form" >
	<!-- Second Grid 조회 조건 -->
	<input type="hidden" id="searchFileSeq" name="searchFileSeq" value ="" />
	<!-- Second Grid 조회 조건 -->
		<div>
		<table>
		<tr>
			<td><span>기관구분</span>
				<select id="searchDeclarationOrgCd" name ="searchDeclarationOrgCd"></select>
			</td>
			<td><span>신고유형</span>
				<select id="searchDeclarationType" name ="searchDeclarationType"></select>
			</td>
			<td><a href="javascript:doAction1('Search')" class="button">조회</a></td>
		</tr>
		</table>
		</div>
	</form>
	</div>
	
	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">신고서목록</li>
			<li class="btn">
			  <a href="javascript:doAction1('Insert')"		class="basic authA">입력</a>
			  <a href="javascript:doAction1('Copy')"		class="basic authA">복사</a>
			  <a href="javascript:doAction1('Save')"		class="basic authA">저장</a>
			  <a href="javascript:doAction1('Down2Excel')"	class="basic authR">다운로드</a>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "50%"); </script>
	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">세부항목</li>
			<li class="btn">
			  <a href="javascript:doAction2('Search')"		class="basic authA">조회</a>
			  <a href="javascript:doAction2('Insert')"		class="basic authA">입력</a>
			  <a href="javascript:doAction2('Copy')"		class="basic authA">복사</a>
			  <a href="javascript:doAction2('Save')"		class="basic authA">저장</a>
			  <a href="javascript:doAction2('Down2Excel')"	class="basic authR">다운로드</a>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet2", "100%", "50%"); </script>
	
</div>
</body>
</html>