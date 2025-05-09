<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>필수교육과정 기준관리</title>
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

		//Sheet 초기화
		init_sheet1(); init_sheet2();

		$(window).smartresize(sheetResize); sheetInit();
		
		doAction1("Search");

	});

	function getCommonCodeList() {
		//공통코드 한번에 조회
		var grpCds = "B50010";
		let params = "grpCd=" + grpCds + "&baseSYmd=" + $("#searchYmd").val();
		const codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists&useYn=Y", params, false).codeList, "전체");
		sheet1.SetColProperty("loanCd",  	{ComboText:"|"+codeLists["B50010"][0], ComboCode:"|"+codeLists["B50010"][1]} );
		sheet2.SetColProperty("loanCd",  	{ComboText:"|"+codeLists["B50010"][0], ComboCode:"|"+codeLists["B50010"][1]} );
	}

	//Sheet 초기화
	function init_sheet1(){

		var initdata1 = {};
		initdata1.Cfg = {FrozenCol:6,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		
		initdata1.Cols = [
			{Header:"No|No",				Type:"${sNoTy}",	Hidden:0,				Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",				Type:"${sDelTy}",	Hidden:"${sDelHdn}",	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",				Type:"${sSttTy}",	Hidden:"${sSttHdn}",	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"대출구분|대출구분",			Type:"Combo",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"loanCd",		KeyField:1,	Format:"",			UpdateEdit:1,	InsertEdit:1 },
			
			{Header:"유효시작일|유효시작일",		Type:"Date",		Hidden:"${sDelHdn}",	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"sdate",	EndDateCol:"edate",	KeyField:1,	Format:"Ymd",		UpdateEdit:0,	InsertEdit:1},
			{Header:"유효종료일|유효종료일",		Type:"Date",		Hidden:"${sDelHdn}",	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"edate",	StartDateCol:"sdate",	KeyField:0,	Format:"Ymd",		UpdateEdit:1,	InsertEdit:1},
			
			{Header:"대출처|대출처",				Type:"Text",		Hidden:0, 	Width:120,  Align:"Center",	ColMerge:0,	SaveName:"loanOrgNm",			KeyField:0,	Format:"", 			UpdateEdit:1,   InsertEdit:1,	EditLen:30 },
			{Header:"대출한도|대출한도",			Type:"Int",			Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"loanLmtMon",			KeyField:0,	Format:"",			UpdateEdit:1,	InsertEdit:1,	EditLen:20 },
			{Header:"이자율|이자율",				Type:"Float",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"intRate",				KeyField:0,	Format:"##.#\\%",	UpdateEdit:1,	InsertEdit:1,	EditLen:4 },
			{Header:"최대상환\n기간(개월)|최대상환\n기간(개월)",
												Type:"Int",			Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"loanPeriod",			KeyField:0,	Format:"##\\개월",	UpdateEdit:1,	InsertEdit:1,	EditLen:2 },
			/* 2020.10.12 무신사 [대상자기준] 사용안함 */
			{Header:"대상자기준|조건검색명",		Type:"Popup",		Hidden:1, 	Width:200,  Align:"Left",	ColMerge:0,	SaveName:"searchDesc",			KeyField:0,	Format:"", 			UpdateEdit:1,   InsertEdit:1 },
  			{Header:"대상자기준|조건검색\n코드",		Type:"Text",		Hidden:1, 	Width:60,  	Align:"Center",	ColMerge:0,	SaveName:"searchSeq",			KeyField:0,	Format:"", 			UpdateEdit:1,   InsertEdit:1,	EditLen:20 },
			
			{Header:"제출서류|제출서류",			Type:"Text",		Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"loanDoc",				KeyField:0,	Format:"",			UpdateEdit:1,	InsertEdit:1,	EditLen:1000, MultiLineText:1, Wrap:1 },
			{Header:"유의사항|유의사항",			Type:"Text",		Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"loanNote",			KeyField:0,	Format:"",			UpdateEdit:1,	InsertEdit:1,	EditLen:1000, MultiLineText:1, Wrap:1 },
			
			{Header:"복리후생마감 급여항목|원금",	Type:"Popup",		Hidden:0, 	Width:150,  Align:"Center",	ColMerge:0,	SaveName:"elementNm1",			KeyField:0,	Format:"", 			UpdateEdit:1,   InsertEdit:1 },
  			{Header:"복리후생마감 급여항목|원금",	Type:"Text",		Hidden:1, 	Width:100,  Align:"Center",	ColMerge:0,	SaveName:"elementCd1",			KeyField:0,	Format:"", 			UpdateEdit:1,   InsertEdit:1 },
  			{Header:"복리후생마감 급여항목|이자",	Type:"Popup",		Hidden:0, 	Width:150,  Align:"Center",	ColMerge:0,	SaveName:"elementNm2",			KeyField:0,	Format:"", 			UpdateEdit:1,   InsertEdit:1 },
  			{Header:"복리후생마감 급여항목|이자",	Type:"Text",		Hidden:1, 	Width:100,  Align:"Center",	ColMerge:0,	SaveName:"elementCd2",			KeyField:0,	Format:"", 			UpdateEdit:1,   InsertEdit:1 },

  			{Header:"대출이자지원\n적용여부|대출이자지원\n적용여부",
  												Type:"CheckBox",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"interestSupportYn",	KeyField:0,	Format:"",			UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y",	FalseValue:"N" },
  			{Header:"사용\n여부|사용\n여부",		Type:"CheckBox",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"useYn",				KeyField:0,	Format:"",			UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y",	FalseValue:"N" },
			{Header:"비고|비고",				Type:"Text",		Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"note",					KeyField:0,	Format:"",			UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },

  			
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

	}
	

	//Sheet 초기화
	function init_sheet2(){

		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,Page:22, MergeSheet:msHeaderOnly};
		initdata2.HeaderMode = {Sort:1,ColLoan:1,ColResize:1,HeaderCheck:0};
		initdata2.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			
			{Header:"대출구분",		Type:"Combo",		Hidden:1,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"loanCd",		KeyField:1,	Format:"",			UpdateEdit:0,	InsertEdit:1 },
			{Header:"유효시작일",		Type:"Text",		Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	Format:"",			UpdateEdit:0,	InsertEdit:1 },

			{Header:"근속개월",		Type:"Int",			Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"workMonth",	KeyField:1,	Format:"##\\개월",	UpdateEdit:0,	InsertEdit:1 },
			{Header:"사용시작일",		Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"useSYmd",	EndDateCol:"useEYmd",		KeyField:1,	Format:"Ymd",		UpdateEdit:0,	InsertEdit:1 },
			{Header:"사용종료일",		Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"useEYmd",	StartDateCol:"useSYmd",	KeyField:0,	Format:"Ymd",		UpdateEdit:1,	InsertEdit:1 },
			{Header:"대출한도비율",	Type:"Float",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"loanLmtRate",	KeyField:1,	Format:"##.#\\%",	UpdateEdit:1,	InsertEdit:1,	EditLen:20 },
			{Header:"이자율",			Type:"Float",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"intRate",		KeyField:1,	Format:"##.#\\%",	UpdateEdit:1,	InsertEdit:1,	EditLen:4 },
			{Header:"대출기간(개월)",	Type:"Int",			Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"loanPeriod",	KeyField:1,	Format:"##\\개월",	UpdateEdit:1,	InsertEdit:1,	EditLen:2 },
			{Header:"사용여부",		Type:"CheckBox",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"useYn",		KeyField:0,	Format:"",			UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y",	FalseValue:"N" },
			{Header:"비고",			Type:"Text",		Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"note",		KeyField:0,	Format:"",			UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },

		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

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
				getCommonCodeList();
				sheet1.DoSearch( "${ctx}/LoanStd.do?cmd=getLoanStdList", $("#sheet1Form").serialize() );
				break;
			case "Save":
				if(!chkInVal(sheet1, "sdate", "edate")){break;}
				if(!dupChk(sheet1,"loanCd|sdate", true, true, true)){break;}
				IBS_SaveName(document.sheet1Form,sheet1);
				sheet1.DoSave( "${ctx}/LoanStd.do?cmd=saveLoanStd", $("#sheet1Form").serialize());
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
			alert("[sheet1] OnSearchEnd Event Error : " + ex);
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
			alert("[sheet1] OnSaveEnd Event Error " + ex);
		}
	}
	
	// 셀 변경 시 
	function sheet1_OnChange(Row, Col, Value) {
		try {
			if (sheet1.ColSaveName(Col) == "searchSeq") {
				sheet1.SetCellValue(Row, "searchDesc", "");
			}
		} catch (ex) {
			alert("[sheet1] OnChange Event Error : " + ex);
		}
	}
	
	// 셀 팝업 클릭 시
	function sheet1_OnPopupClick(Row, Col) {
		try {
			if(sheet1.ColSaveName(Col) == "searchDesc") { //조건검색
				if(!isPopup()) {return;}
				gPRow = Row;
				pGubun = "pwrSrchMgrPopup";

				var args 	= new Array();
				args["srchBizCd"] = "09";
				args["srchType"] = "3";
				args["srchDesc"] = "대상";

				let layerModal = new window.top.document.LayerModal({
					id : 'pwrSrchMgrLayer'
					, url : '/Popup.do?cmd=viewPwrSrchMgrLayer&authPg=R'
					, parameters : args
					, width : 1100
					, height : 520
					, title : '조건 검색 관리'
					, trigger :[
						{
							name : 'pwrTrigger'
							, callback : function(result){
								sheet1.SetCellValue(Row, "searchSeq", result.searchSeq);
								sheet1.SetCellValue(Row, "searchDesc", result.searchDesc);
							}
						}
					]
				});
				layerModal.show();

			}else if(sheet1.ColSaveName(Col) == "elementNm1") { //급여항목

				if(!isPopup()) {return;}

				var args 	= new Array();
				gPRow = Row;
				pGubun = "payElementPopup1";

				let layerModal = new window.top.document.LayerModal({
					id : 'payElementLayer'
					, url : '/PayElementPopup.do?cmd=viewPayElementLayer&authPg=R'
					, parameters : args
					, width : 1020
					, height : 520
					, title : '수당,공제 항목'
					, trigger :[
						{
							name : 'payTrigger'
							, callback : function(result){
								sheet1.SetCellValue(Row, "elementCd1",   result.resultElementCd);
								sheet1.SetCellValue(Row, "elementNm1",   result.resultElementNm);
							}
						}
					]
				});
				layerModal.show();
				
			}else if(sheet1.ColSaveName(Col) == "elementNm2") { //급여항목

				if(!isPopup()) {return;}

				var args 	= new Array();
				gPRow = Row;
				pGubun = "payElementPopup2";

				let layerModal = new window.top.document.LayerModal({
					id : 'payElementLayer'
					, url : '/PayElementPopup.do?cmd=viewPayElementLayer&authPg=R'
					, parameters : args
					, width : 1020
					, height : 520
					, title : '수당,공제 항목'
					, trigger :[
						{
							name : 'payTrigger'
							, callback : function(result){
								sheet1.SetCellValue(Row, "elementCd2",   result.resultElementCd);
								sheet1.SetCellValue(Row, "elementNm2",   result.resultElementNm);
							}
						}
					]
				});
				layerModal.show();
			}

			

		} catch (ex) {
			alert("[sheet1] OnPopupClick Event Error : " + ex);
		}
	}
	
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol,isDelete) {
		try {
			if(OldRow == NewRow || sheet1.GetCellValue(NewRow, "sStatus") == "I") return;
			
			if( sheet1.RowCount() > 0 ){
				doAction2('Search');
			}
			//$("#searchAppraisalCd").val(sheet1.GetCellValue(NewRow, "appraisalCd"));
			// 조회...
		} catch (ex) {
			alert("[sheet1] OnSelectCell Event Error : " + ex);
		}
	}

	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
			case "Search":
				var row = sheet1.GetSelectRow();
				if(row > 0) {
					var param = $("#sheet1Form").serialize();
					param += "&searchLoanCd=" + sheet1.GetCellValue(row, "loanCd");
					param += "&searchSdate=" + sheet1.GetCellValue(row, "sdate");
					sheet2.DoSearch( "${ctx}/LoanStd.do?cmd=getLoanStdDetailList", param );
				}
				break;	
			case "Save":
				if(!chkInVal(sheet2, "useSYmd", "useEYmd")){break;}
				if(!dupChk(sheet2,"loanCd|sdate|workMonth|useSYmd", true, true, true)){break;}
				IBS_SaveName(document.sheet1Form,sheet2);
				sheet2.DoSave( "${ctx}/LoanStd.do?cmd=saveLoanStdDetail", $("#sheet1Form").serialize());
				break;
			case "Insert":
				var parentRow = sheet1.GetSelectRow();
				var row = sheet2.DataInsert(0);
				sheet2.SetCellValue(row, "loanCd", sheet1.GetCellValue(parentRow, "loanCd"));
				sheet2.SetCellValue(row, "sdate", sheet1.GetCellValue(parentRow, "sdate"));
				break;
			case "Copy":
				var row = sheet2.DataCopy();
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet2);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet2.Down2Excel(param);
				break;
			case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet2.LoadExcel(params); break;
			case "DownTemplate":
				// 양식다운로드
				sheet2.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"5|6|7|8|9|10|11|12"});
				break;
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
			alert("[sheet2] OnSearchEnd Event Error : " + ex);
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
			alert("[sheet2] OnSaveEnd Event Error " + ex);
		}
	}

	function sheet2_OnLoadExcel() {
		var rowCnt = sheet2.RowCount();
		for (var i=1; i<=rowCnt; i++) {
			sheet2.SetCellValue(i, "loanCd", sheet1.GetCellValue(sheet1.GetSelectRow(), "loanCd"));
			sheet2.SetCellValue(i, "sdate", sheet1.GetCellValue(sheet1.GetSelectRow(), "sdate"));
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
					<input type="text" id="searchYmd" name="searchYmd" class="date2 required w70" value="${curSysYyyyMMdd}"/>
				</td>
				<td>
					<a href="javascript:doAction1('Search')" class="btn dark">조회</a>
				</td>
			</tr>
			</table>
		</div>
	</form>

	<div class="outer">
		<div class="sheet_title">
			<ul>
				<li class="txt">대출금기준관리</li>
				<li class="btn">
					<span style="font-style:Italic;">( ※셀에서 줄바꿈 : Shift + Enter ) &nbsp;&nbsp;&nbsp;&nbsp;</span>
					<a href="javascript:doAction1('Down2Excel');" 	class="btn outline-gray authR">다운로드</a>
					<a href="javascript:doAction1('Copy')" 			class="btn outline-gray authA">복사</a>
					<a href="javascript:doAction1('Insert')" 		class="btn outline-gray authA">입력</a>
					<a href="javascript:doAction1('Save');" 		class="btn filled authA">저장</a>
				</li>
			</ul>
		</div>
		<script type="text/javascript"> createIBSheet("sheet1", "100%", "300px", "${ssnLocaleCd}"); </script>
	</div>
	
	<div class="outer mat20">
		<div class="sheet_title">
		<ul>
			<li class="txt">근속개월에 따른 기준관리</li>
			<li class="btn">
				<a href="javascript:doAction2('Down2Excel')" 	class="btn outline-gray authR">다운로드</a>
				<a href="javascript:doAction2('DownTemplate')"	class="btn outline-gray authA">양식다운로드</a>
				<a href="javascript:doAction2('LoadExcel')"		class="btn outline-gray authA">업로드</a>
				<a href="javascript:doAction2('Copy')" 			class="btn outline-gray authA">복사</a>
				<a href="javascript:doAction2('Insert')" 		class="btn outline-gray authA">입력</a>
				<a href="javascript:doAction2('Save');" 		class="btn filled authA">저장</a>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet2", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
