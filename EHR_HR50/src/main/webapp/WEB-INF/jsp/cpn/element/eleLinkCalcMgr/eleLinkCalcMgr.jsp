<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<title><tit:txt mid='113092' mdef='항목링크(계산식)'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";

var flag = "inte";

// 하위 그리드 조회 조건 및 입력 값
var gridFirstOnClickElementCd = "";
var gridFirstOnClickSearchSeq = "";
var gridFirstOnClickSdate = "";

	$(function() {
		
		var workCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getWorkCdList"), "- 근무명 선택 -");
		$("#workCd").html(workCd[2]);
		
		var initdata0 = {};
		initdata0.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata0.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata0.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),   Width:Number("${sNoWdt}"),  Align:"Center", ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),  Width:Number("${sDelWdt}"), Align:"Center", ColMerge:0,   SaveName:"sDelete" },
			{Header:"<sht:txt mid='resultV2' mdef='결과'/>",				Type:"${sRstTy}",	Hidden:1,  Width:Number("${sRstWdt}"), Align:"Center", ColMerge:0,   SaveName:"sResult" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),  Width:Number("${sSttWdt}"), Align:"Center", ColMerge:0,   SaveName:"sStatus" },
			{Header:"<sht:txt mid='benefitElemCd' mdef='항목코드'/>",		Type:"Text",		Hidden:1,  Width:0,		Align:"Left",	ColMerge:0,   SaveName:"elementCd",   KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='benefitElemNm' mdef='항목명'/>",		Type:"Popup",		Hidden:0,  Width:100,	Align:"Left",	ColMerge:1,   SaveName:"elementNm",   KeyField:1,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:50 },
			{Header:"<sht:txt mid='cRule' mdef='계산식'/>",				Type:"Text",		Hidden:1,  Width:176,	Align:"Left",	ColMerge:0,   SaveName:"cRule",       KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='searchSeqV1' mdef='검색순번'/>",			Type:"Text",		Hidden:1,  Width:0,		Align:"Left",	ColMerge:0,   SaveName:"searchSeq",   KeyField:1,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='searchDescV2' mdef='대상자검색설명'/>",	Type:"Popup",		Hidden:0,  Width:176,	Align:"Left",	ColMerge:0,   SaveName:"searchDesc",  KeyField:1,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:1000 },
			{Header:"<sht:txt mid='workApplyYn' mdef='근로시간\n적용여부'/>",	Type:"Combo",		Hidden:0,  Width:80,	Align:"Center",	ColMerge:0,   SaveName:"workApplyYn", KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
			{Header:"<sht:txt mid='workDdCdV1' mdef='근무일\n적용여부'/>",	Type:"Combo",		Hidden:0,  Width:80,	Align:"Center",	ColMerge:0,   SaveName:"workDdCd",    KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='sYmd' mdef='시작일자'/>",				Type:"Date",		Hidden:0,  Width:80,	Align:"Center",	ColMerge:0,   SaveName:"sdate",       KeyField:1,   CalcLogic:"",   Format:"Ymd",	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='eYmdV1' mdef='종료일'/>",				Type:"Date",		Hidden:0,  Width:80,	Align:"Center",	ColMerge:0,   SaveName:"edate",       KeyField:0,   CalcLogic:"",   Format:"Ymd",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 }
		];
		IBS_InitSheet(mySheet0, initdata0);mySheet0.SetEditable("${editable}");mySheet0.SetVisible(true);mySheet0.SetCountPosition(4);

		// Combo
		mySheet0.SetColProperty("workApplyYn", {ComboText:"NO|YES", ComboCode:"N|Y"} );
		mySheet0.SetColProperty("workDdCd", {ComboText:"NO|YES", ComboCode:"N|Y"} );


		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:Number("${sNoWdt}"),  Align:"Center", ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),  Width:Number("${sDelWdt}"), Align:"Center", ColMerge:0,   SaveName:"sDelete" },
			{Header:"<sht:txt mid='resultV2' mdef='결과'/>",			Type:"${sRstTy}",   Hidden:1,  Width:Number("${sRstWdt}"), Align:"Center", ColMerge:0,   SaveName:"sResult" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),  Width:Number("${sSttWdt}"), Align:"Center", ColMerge:0,   SaveName:"sStatus" },
			{Header:"<sht:txt mid='benefitElemCd' mdef='항목코드'/>",	Type:"Text",	Hidden:1,  Width:0,		Align:"Left",	ColMerge:0,   SaveName:"elementCd",  KeyField:1,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='searchSeqV1' mdef='검색순번'/>",		Type:"Text",	Hidden:1,  Width:0,		Align:"Left",	ColMerge:0,   SaveName:"searchSeq",  KeyField:1,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='sYmd' mdef='시작일자'/>",			Type:"Text",	Hidden:1,  Width:0,		Align:"Left",	ColMerge:0,   SaveName:"sdate",      KeyField:1,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='seqV5' mdef='SEQ'/>",			Type:"Text",	Hidden:1,  Width:0,		Align:"Left",	ColMerge:0,   SaveName:"seq",        KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='calSeq' mdef='계산순서'/>",			Type:"Text",	Hidden:0,  Width:40,	Align:"Center",	ColMerge:0,   SaveName:"calSeq",     KeyField:1,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='eleCalType' mdef='항목구분'/>",		Type:"Combo",	Hidden:0,  Width:60,	Align:"Center",	ColMerge:0,   SaveName:"eleCalType", KeyField:1,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='cRuleType' mdef='기준구분'/>",		Type:"Combo",	Hidden:0,  Width:60,	Align:"Center",	ColMerge:0,   SaveName:"cRuleType",  KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='calValue' mdef='계산식값'/>",		Type:"Text",	Hidden:1,  Width:90,	Align:"Center",	ColMerge:0,   SaveName:"calValue",   KeyField:1,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='calValueNm' mdef='계산식값명'/>",	Type:"Popup",	Hidden:0,  Width:120,	Align:"Center",	ColMerge:0,   SaveName:"calValueNm", KeyField:1,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='updownType' mdef='절상/사\n구분'/>",	Type:"Combo",	Hidden:0,  Width:60,	Align:"Center",	ColMerge:0,   SaveName:"updownType", KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='danwi' mdef='단위'/>",				Type:"Combo",	Hidden:0,  Width:50,	Align:"Center",	ColMerge:0,   SaveName:"updownUnit", KeyField:0,   CalcLogic:"",   Format:"NullFloat",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 }
		];
		IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		//Combo
		// {Header:"<sht:txt mid='eleCalType' mdef='항목구분'/>",   Type:"Combo",	 Hidden:0,  Width:70,   Align:"Left",	ColMerge:0,   SaveName:"eleCalType",  KeyField:1,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
		var eleCalTypeList  = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00040"), "");
		sheet1.SetColProperty("eleCalType",		  {ComboText:"|"+eleCalTypeList[0], ComboCode:"|"+eleCalTypeList[1]} );
		// {Header:"<sht:txt mid='cRuleType' mdef='기준구분'/>",   Type:"Combo",	 Hidden:0,  Width:70,   Align:"Left",	ColMerge:0,   SaveName:"cRuleType",   KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
		var cRuleTypeList  = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00150"), "");
		sheet1.SetColProperty("cRuleType",		  {ComboText:"|"+cRuleTypeList[0], ComboCode:"|"+cRuleTypeList[1]} );
		// {Header:"<sht:txt mid='updownType' mdef='절상/사\n구분'/>",	   Type:"Combo",	 Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"updownType",		KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
		var updownTypeList  = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00005"), "");
		sheet1.SetColProperty("updownType",		  {ComboText:"|"+updownTypeList[0], ComboCode:"|"+updownTypeList[1]} );
		// {Header:"<sht:txt mid='danwi' mdef='단위'/>",				Type:"Combo",	 Hidden:0,  Width:40,   Align:"Center",  ColMerge:0,   SaveName:"updownUnit",		KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
		var updownUnitList  = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00006"), "");
		sheet1.SetColProperty("updownUnit",		  {ComboText:"|"+updownUnitList[0], ComboCode:"|"+updownUnitList[1]} );

		$("#mySheetForm").bind("keyup",function(event){
			if( event.keyCode == 13){ doActionFirst("Search"); $(this).focus(); }
		});

		$(window).smartresize(sheetResize); sheetInit();
		doActionFirst("Search");
	});

	//Sheet Action
	function doActionFirst(sAction) {
		switch (sAction) {
		case "Search": 	 	mySheet0.DoSearch( "${ctx}/EleLinkCalcMgr.do?cmd=getEleLinkCalcMgrFirstList", $("#mySheetForm").serialize() ); break;
		case "Save":
			if(!dupChk(mySheet0,"elementCd|searchDesc|sdate", false, true)){break;}
			IBS_SaveName(document.mySheetForm,mySheet0);
			mySheet0.DoSave( "${ctx}/EleLinkCalcMgr.do?cmd=saveEleLinkCalcMgrFirst", $("#mySheetForm").serialize()); break;
		case "Insert":		mySheet0.SelectCell(mySheet0.DataInsert(0), "elementNm"); break;
		case "Copy":		mySheet0.DataCopy(); break;
		case "Clear":		mySheet0.RemoveAll(); break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(mySheet0);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			mySheet0.Down2Excel(param); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; mySheet0.LoadExcel(params); break;
		}
	}

	//Sheet Action
	function doActionSecond(sAction) {
		switch (sAction) {
		case "Search":	  sheet1.DoSearch( "${ctx}/EleLinkCalcMgr.do?cmd=getEleLinkCalcMgrSecondList", $("#mySheetForm").serialize() ); break;
		case "Save":
			if(!dupChk(sheet1,"calSeq|eleCalType|calValue", false, true)){break;}
			IBS_SaveName(document.mySheetForm,sheet1);
			sheet1.DoSave( "${ctx}/EleLinkCalcMgr.do?cmd=saveEleLinkCalcMgrSecond", $("#mySheetForm").serialize()); break;
		case "Insert":
			var row = mySheet0.GetSelectRow();
			if(mySheet0.GetCellValue(row,"sStatus") == "I"){
				alert("<msg:txt mid='109548' mdef='선택 되어진 항목링크 저장 후 계산식작성 입력이 가능 합니다.'/>");
			}else if(gridFirstOnClickElementCd == ""){
				alert("<msg:txt mid='109549' mdef='계산식의 대상이 될 항목 링크를 선택 하여주세요.	 '/>");
			}else{
				var newRow = sheet1.DataInsert(0);

				sheet1.SetCellValue(newRow, "elementCd", gridFirstOnClickElementCd);
				sheet1.SetCellValue(newRow, "searchSeq", gridFirstOnClickSearchSeq);
				sheet1.SetCellValue(newRow, "sdate",	 gridFirstOnClickSdate);
				sheet1.SelectCell(newRow, "calSeq");
			}
			break;
		case "Copy":		sheet1.DataCopy(); break;
		case "Clear":	   sheet1.RemoveAll(); break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param); break;
		case "LoadExcel":   var params = {Mode:"HeaderMatch", WorkSheetNo:1}; mySheet0.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function mySheet0_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }

			flag = "init";
			var calValue = "";
	
			for(var Row=1; Row <= sheet1.LastRow(); Row++){
				sheet1_OnChange(Row, 9, sheet1.GetCellValue(Row, "eleCalType"));
				sheet1.SetCellValue(Row, "sStatus", "");
				calValue += sheet1.GetCellText(Row, "calValueNm");
			}
	
			flag = "non";
			
			//계산식
			//$("#cRule").html(calValue);
			
			setPayWorkData(mySheet0.GetSelectRow(), calValue);
			
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	// 저장 후 메시지
	function mySheet0_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } doActionFirst('Search');} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } doActionSecond("Search"); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}


	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function mySheet0_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doActionFirst("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && mySheet0.GetCellValue(Row, "sStatus") == "I") {
				mySheet0.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	function mySheet0_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try{
			if(OldRow != NewRow){
				var cellStatus = mySheet0.GetCellValue(NewRow,"sStatus");
				if( cellStatus != "I"){
					
					$("#cRule").html(mySheet0.GetCellValue(NewRow,"cRule"));
					
					// First Grid 의 파일번호의 값 전달 (fileSeq)
					$("#searchElementCd").val(mySheet0.GetCellValue(NewRow,"elementCd"));
					$("#searchSearchSeq").val(mySheet0.GetCellValue(NewRow,"searchSeq"));
					$("#searchSdate").val(mySheet0.GetCellValue(NewRow,"sdate"));

					// 그리드 셀 선택시 값 셋팅
					gridFirstOnClickElementCd = mySheet0.GetCellValue(NewRow,"elementCd");
					gridFirstOnClickSearchSeq = mySheet0.GetCellValue(NewRow,"searchSeq");
					gridFirstOnClickSdate     = mySheet0.GetCellValue(NewRow,"sdate");
				
				}else{
					$("#cRule").html("");

					// First Grid 의 파일번호의 값 전달 (fileSeq)
					$("#searchElementCd").val("");
					$("#searchSearchSeq").val("");
					$("#searchSdate").val("");

					// 그리드 셀 선택시 값 셋팅
					gridFirstOnClickElementCd = "";
					gridFirstOnClickSearchSeq = "";
					gridFirstOnClickSdate     = "";
				}
				
				doActionSecond("Search");
			}
		}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}

	//  Type이 POPUP인 셀에서 팝업버튼을 눌렀을때 발생하는 이벤트
	function mySheet0_OnPopupClick(Row, Col){
		var colName = mySheet0.ColSaveName(Col);

		let layerId = '';
		let title = '';
		let url = '';
		let parameters = {};
		let width = 0;
		let height = 0;
		//항목명
		if(colName === 'elementNm'){
			layerId = 'payElementLayer';
			url = '/PayElementPopup.do?cmd=viewPayElementLayer&authPg=R';
			title = '<tit:txt mid='payElementPop4' mdef='수당,공제 항목'/>';
			parameters = {
				elementCd : mySheet0.GetCellValue(Row, "elementCd")
				, elementNm : mySheet0.GetCellValue(Row, "elementNm")
				, searchElementLinkType: "C"
			};
			width = 860;
			height = 520;
		}
		//대상자검색설명
		else if(colName === 'searchDesc'){
			layerId = 'pwrSrchMgrLayer';
			url = '/Popup.do?cmd=viewPwrSrchMgrLayer&authPg=R';
			title = '<tit:txt mid='112392' mdef='조건 검색 관리'/>';
			parameters = {
				searchDesc : mySheet0.GetCellValue(Row, "searchDesc")
			};
			width = 1100;
			height = 520;
		}
		let layerModal = new window.top.document.LayerModal({
			id : layerId
			, url : url
			, parameters : parameters
			, width : width
			, height : height
			, title : title
			, trigger :[
				{
					name : 'payTrigger'
					, callback : function(result){
						mySheet0.SetCellValue(Row, "elementCd", result.resultElementCd);
						mySheet0.SetCellValue(Row, "elementNm", result.resultElementNm);
					}
				}
				, {
					name : 'pwrTrigger'
					, callback : function(result){
						mySheet0.SetCellValue(Row, "searchDesc", result.searchDesc);
						mySheet0.SetCellValue(Row, "searchSeq", result.searchSeq);
					}
				}
			]
		});
		layerModal.show();

		// try{
		// 	var colName = mySheet0.ColSaveName(Col);
		// 	var args	= new Array();
		//
		// 	// 항목설명
		// 	args["elementCd"]  = mySheet0.GetCellValue(Row, "elementCd");
		// 	args["elementNm"]  = mySheet0.GetCellValue(Row, "elementNm");
		//
		// 	// 대상자검색설명
		// 	args["searchSeq"]   = mySheet0.GetCellValue(Row, "searchSeq");
		// 	args["searchDesc"]  = mySheet0.GetCellValue(Row, "searchDesc");
		//
		// 	var rv = null;
		//
		// 	if(colName == "elementNm") {
		// 		if(!isPopup()) {return;}
		// 		gPRow = Row;
		// 		pGubun = "payElementPopup";
		// 		openPopup("/PayElementPopup.do?cmd=payElementPopup&authPg=R", args, "740","520");
		// 		/*
		// 		if(rv!=null){
		// 			mySheet0.SetCellValue(Row, "elementCd",   rv["elementCd"] );
		// 			mySheet0.SetCellValue(Row, "elementNm",   rv["elementNm"] );
		// 		}
		// 		*/
		// 	}
		//
		// 	if(colName == "searchDesc") {
		// 		if(!isPopup()) {return;}
		// 		gPRow = Row;
		// 		pGubun = "pwrSrchMgrPopup";
		// 		rv = openPopup("/Popup.do?cmd=pwrSrchMgrPopup&authPg=R", args, "1100","520");
		// 		/*
		// 		if(rv!=null){
		// 			mySheet0.SetCellValue(Row, "searchSeq",   rv["searchSeq"] );
		// 			mySheet0.SetCellValue(Row, "searchDesc",  rv["searchDesc"] );
		// 		}
		// 		*/
		// 	}else{}
		// }catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}

	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

		if(pGubun == "payElementPopup"){
			mySheet0.SetCellValue(gPRow, "elementCd",   rv["elementCd"] );
			mySheet0.SetCellValue(gPRow, "elementNm",   rv["elementNm"] );
		}else if(pGubun == "pwrSrchMgrPopup"){
			mySheet0.SetCellValue(gPRow, "searchSeq",   rv["searchSeq"] );
			mySheet0.SetCellValue(gPRow, "searchDesc",  rv["searchDesc"] );
		}else if(pGubun == "payElementPopup2"){
			sheet1.SetCellValue(gPRow, "calValue",	 rv["elementCd"] );
			sheet1.SetCellValue(gPRow, "calValueNm",   rv["elementNm"] );
		}else if(pGubun == "payUdfMasterPopup"){
			sheet1.SetCellValue(gPRow, "calValue",	 rv["udfCd"] );
			sheet1.SetCellValue(gPRow, "calValueNm",   rv["udfName"] );
		}
	}

	//  Type이 POPUP인 셀에서 팝업버튼을 눌렀을때 발생하는 이벤트
	function sheet1_OnPopupClick(Row, Col){

		var colName = sheet1.ColSaveName(Col);
		if(colName !== 'calValueNm') return;

		let layerId = '';
		let parameters = {
			calValue : sheet1.GetCellValue(Row, "calValue")
			, calValueNm : sheet1.GetCellValue(Row, "calValueNm")
		};
		let url = '';
		let title = '';
		if(sheet1.GetCellValue(Row, "eleCalType") === "E"){
			layerId = 'payElementLayer';
			url = '/PayElementPopup.do?cmd=viewPayElementLayer&authPg=R';
			title = '<tit:txt mid='payElementPop4' mdef='수당,공제 항목'/>';
		}else if(sheet1.GetCellValue(Row, "eleCalType") === "F"){
			layerId = 'udfMasterLayer';
			url = '/PayUdfMasterPopup.do?cmd=viewPayUdfMasterLayer&authPg=R';
			title = '<tit:txt mid='payUdfMasterPop' mdef='사용자정의 함수 조회'/>';
		}else{
			return;
		}

		let layerModal = new window.top.document.LayerModal({
			id : layerId
			, url : url
			, parameters : parameters
			, width : 860
			, height : 520
			, title : title
			, trigger :[
				{
					name : 'payTrigger'
					, callback : function(result){
						sheet1.SetCellValue(Row, "calValue", result.resultElementCd);
						sheet1.SetCellValue(Row, "calValueNm", result.resultElementNm);
					}
				}
				, {
					name : 'udfMasterTrigger'
					, callback : function(result){
						sheet1.SetCellValue(Row, "calValue", result.udfCd);
						sheet1.SetCellValue(Row, "calValueNm", result.description);
					}
				}
			]
		});
		layerModal.show();

		// try{
		// 	var colName = sheet1.ColSaveName(Col);
		// 	var args	= new Array();
		// 	// 계산식값명
		// 	args["calValue"]	= sheet1.GetCellValue(Row, "calValue");
		// 	args["calValueNm"]  = sheet1.GetCellValue(Row, "calValueNm");
		//
		// 	var rv = null;
		// 	if(colName == "calValueNm") {
		// 		// Tyep E
		// 		if(sheet1.GetCellValue(Row, "eleCalType") == "E"){
		// 			if(!isPopup()) {return;}
		// 	 		gPRow  = Row;
		// 			pGubun = "payElementPopup2";
		// 			rv     = openPopup("/PayElementPopup.do?cmd=payElementPopup&authPg=R", args, "740","520");
		// 			/*
		// 			if(rv!=null){
		// 				sheet1.SetCellValue(Row, "calValue",	 rv["elementCd"] );
		// 				sheet1.SetCellValue(Row, "calValueNm",   rv["elementNm"] );
		// 			}
		// 			*/
		// 		}
		//
		// 		// Type F
		// 		if(sheet1.GetCellValue(Row, "eleCalType") == "F"){
		// 			if(!isPopup()) {return;}
		// 	 		gPRow  = Row;
		// 			pGubun = "payUdfMasterPopup";
		// 			rv     = openPopup("/PayUdfMasterPopup.do?cmd=payUdfMasterPopup&authPg=R", args, "740","520");
		// 			/*
		// 			if(rv!=null){
		// 				sheet1.SetCellValue(Row, "calValue",	 rv["udfCd"] );
		// 				sheet1.SetCellValue(Row, "calValueNm",   rv["description"] );
		// 			}
		// 			*/
		// 		}
		// 	}
		// }catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}


	function sheet1_OnChange(Row, Col, Value) {
		try{
			var calvalueNm = sheet1.GetCellValue(Row, "calValueNm");

			if(flag == "non"){
				calvalueNm = "";
			}

			if(Row > 0 && sheet1.ColSaveName(Col) == "eleCalType"){
				// Type E 항목코드
				if(sheet1.GetCellValue(Row, "eleCalType") == "E"){
					sheet1.InitCellProperty(Row, "calValueNm", {Type: "Popup", Align: "Left", Edit:1});
					sheet1.SetCellValue(Row, "calValueNm",  calvalueNm);
				}
				
				// Type F 사용자정의함수
				if(sheet1.GetCellValue(Row, "eleCalType") == "F"){
					sheet1.InitCellProperty(Row, "calValueNm", {Type: "Popup", Align: "Left", Edit:1});
					sheet1.SetCellValue(Row, "calValueNm",  calvalueNm);
				}
				
				// Type A 괄호
				if(sheet1.GetCellValue(Row, "eleCalType") == "A"){
					sheet1.InitCellProperty(Row, "calValueNm", {Type: "Combo", Align: "Left", Edit:1});
					sheet1.CellComboItem(Row,"calValueNm", {"ComboCode":"(|)","ComboText":"(|)"});
					sheet1.SetCellValue(Row, "calValueNm",  sheet1.GetCellValue(Row, "calValue"));
				}
				
				// Type B 사칙연산
				if(sheet1.GetCellValue(Row, "eleCalType") == "B"){
					sheet1.InitCellProperty(Row, "calValueNm", {Type: "Combo", Align: "Left", Edit:1});
					sheet1.CellComboItem(Row,"calValueNm", {"ComboCode":"+|-|*|/","ComboText":"+|-|*|/"});
					sheet1.SetCellValue(Row, "calValueNm",  sheet1.GetCellValue(Row, "calValue"));
				}
				
				// Type C 상수
				if(sheet1.GetCellValue(Row, "eleCalType") == "C"){
					sheet1.InitCellProperty(Row, "calValueNm", {Type: "Text", Align: "Left", Edit:1});
					sheet1.SetCellValue(Row, "calValueNm",  sheet1.GetCellValue(Row, "calValue"));
				}
				
				// Type ES 항목그룹
				if(sheet1.GetCellValue(Row, "eleCalType") == "ES"){
					var calValueNmList  = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCpnElementSetCdList",false).codeList, "");
					sheet1.InitCellProperty(Row, "calValueNm", {Type: "Combo", Align: "Left", Edit:1});
					sheet1.CellComboItem(Row,"calValueNm",  {"ComboCode":calValueNmList[1],"ComboText":calValueNmList[0]});
					sheet1.SetCellValue(Row, "calValueNm",  sheet1.GetCellValue(Row, "calValue"));
				}
			}

			// 값 셋팅
			if(sheet1.ColSaveName(Col) == "calValueNm"){
				if(sheet1.GetCellValue(Row, "eleCalType") != "E" && sheet1.GetCellValue(Row, "eleCalType") != "F"){
					sheet1.SetCellValue(Row, "calValue",  sheet1.GetCellValue(Row, "calValueNm"));
				}
			}
		}catch(ex){alert("OnChange Event Error : " + ex);}
	}


	// 검색결과 팝업
	function openPwrSrchResultPopup(){
		<%--try{--%>
		<%--	var args	= new Array();--%>
		<%--	$("#srchSeq").val(mySheet0.GetCellValue(mySheet0.GetSelectRow(), "searchSeq"));--%>
		<%--	var url	= "${ctx}/PwrSrchResultPopup.do?cmd=pwrSrchResultPopup&authPg=${authPg}";--%>
		<%--	var rv 	= openPopup(url, window, "940","580");--%>
		<%--}catch(ex){alert("Open Popup Event Error : " + ex);}--%>
		let layerModal = new window.top.document.LayerModal({
			id : 'pwrResultLayer'
			, url : '${ctx}/PwrSrchResultPopup.do?cmd=viewPwrSrchResultLayer&authPg=${authPg}'
			, parameters : {
				srchSeq : mySheet0.GetCellValue(mySheet0.GetSelectRow(), "searchSeq")
			}
			, width : 940
			, height : 580
			, title : '검색결과 조회'
		});
		layerModal.show();
	}
	

	// 근무지급방법 Action
	function doActionThird(sAction) {
		var Row = mySheet0.GetSelectRow();
		
		switch (sAction) {
		case "Save":
			if( mySheet0.GetCellValue(Row, "workApplyYn") == "Y" ) {
				if( confirm("저장하시겠습니까?") ) {
					if( $("#workCd").val() == "" ) {
						alert("근무명을 입력해주십시오.");
						$("#workCd").focus();
					} else if( $("#payWorkApplyRate").val() == "" ) {
						alert("적용비율을 입력해주십시오.");
						$("#payWorkApplyRate").focus();
					} else {
						var data = ajaxCall("${ctx}/PayWorkWayTab.do?cmd=savePayWorkWayTab", $.param({
							sNo : "1",
							sDelete : "0",
							sStatus : "I",
							workCd : $("#workCd").val(),
							elementNm : mySheet0.GetCellValue(Row, "elementNm"),
							elementCd : mySheet0.GetCellValue(Row, "elementCd"),
							applyRate : $("#payWorkApplyRate").val(),
							s_SAVENAME : "sNo,sDelete,sStatus,workCd,elementNm,elementCd,applyRate"
						}), false);
						
						// 실행 후 처리
						if( data && data != null&& data.Result && data.Result != null ) {
							alert(data.Result.Message);
						} else {
							alert("처리중 오류가 발생하였습니다. 관리자에 문의하시기 바랍니다.");
						}
					}
				}
			} else {
				alert("근로시간 적용대상 항목이 아닙니다.");
			}
			break;
		}
	}
	
	// 근무 지급방법 설정 입력 폼 셋팅
	function setPayWorkData(Row, cRule) {
		
		// 해당 Row의 근로시간적용여부가 'Y'인 경우
		if( mySheet0.GetCellValue(Row, "workApplyYn") == "Y" ) {
			// 근무 지급방법 입력값 초기화
			$("#workCd").val("");
			$("#payWorkApplyRate").val("");
			
			// 데이터 조회
			var data = ajaxCall("${ctx}/PayWorkWayTab.do?cmd=getPayWorkWayTabMap", "searchElementCd=" + mySheet0.GetCellValue(Row, "elementCd"), false);
			//console.log('data', data);
			
			if( data && data != null && data.DATA && data.DATA != null ) {
				$("#workCd").val(data.DATA.workCd);
				$("#payWorkApplyRate").val(data.DATA.applyRate);
				
				// 계산식 내용 추가
				cRule += "<span class='f_point f_bold'>";
				if( data.DATA.workCd && data.DATA.workCd != null && data.DATA.workCd != "" ) {
					cRule += "*" + $("#workCd").find("option:selected").text();
				}
				if( data.DATA.applyRate && data.DATA.applyRate != null && data.DATA.applyRate != "" ) {
					cRule += "*" + data.DATA.applyRate;
				}
				cRule += "</span>";
			}
			
			// 화면 출력 처리
			$("#cRuleCol").attr("width", "650px");
			$("#payWorkWay").removeClass("hide");
		} else {
			// 화면 미출력 처리
			$("#cRuleCol").attr("width", "350px");
			$("#payWorkWay").addClass("hide");
		}
		
		$("#cRule").html(cRule);
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<div class="sheet_search outer">
		<form id="mySheetForm" name="mySheetForm" >
			<input id="srchSeq" name="srchSeq" type="hidden"/>
			<input type="hidden" id="searchElementCd" name="searchElementCd" value=""/>
			<input type="hidden" id="searchSearchSeq" name="searchSearchSeq" value=""/>
			<input type="hidden" id="searchSdate" name="searchSdate" value=""/>
			<div>
				<table>
					<tr>
						<th><tit:txt mid='eleGroupMgr2' mdef='항목명'/></th>
						<td>
							<input id="searchElementNm" name="searchElementNm" type="text" class="text" />
						</td>
						<td>
							<btn:a href="javascript:doActionFirst('Search')" css="button" mid='110697' mdef="조회"/>
						</td>
					</tr>
				</table>
			</div>
		</form>
	</div>
	<div>
		<div class="inner">
			<div class="sheet_title">
			<ul>
				<li class="txt"><tit:txt mid='eleLinkCalcMgr1' mdef='항목링크'/></li>
				<li class="btn">
					<btn:a href="javascript:doActionFirst('Insert')" css="basic authA" mid='110700' mdef="입력"/>
					<btn:a href="javascript:doActionFirst('Copy')"   css="basic authA" mid='110696' mdef="복사"/>
					<btn:a href="javascript:doActionFirst('Save')"   css="basic authA" mid='110708' mdef="저장"/>
					<btn:a href="javascript:openPwrSrchResultPopup()"   css="basic authR" mid='110710' mdef="검색결과"/>
					<a href="javascript:doActionFirst('Down2Excel')" class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
				</li>
			</ul>
			</div>
		</div>
		<script type="text/javascript"> createIBSheet("mySheet0", "100%", "50%", "${ssnLocaleCd}"); </script>
	</div>

	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<colgroup>
			<col width="*" />
			<col width="350px" id="cRuleCol" />
		</colgroup>
		<tr>
			<td class="sheet_left">
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='eleLinkCalcMgr2' mdef='계산식작성'/></li>
						<li class="btn">
							<btn:a href="javascript:doActionSecond('Insert')" css="basic authA" mid='110700' mdef="입력"/>
							<!--  <btn:a href="javascript:doActionSecond('Copy')"   css="basic authA" mid='110696' mdef="복사"/> -->
							<btn:a href="javascript:doActionSecond('Save')"   css="basic authA" mid='110708' mdef="저장"/>
						</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet1", "100%", "50%", "${ssnLocaleCd}"); </script>
			</td>

			<!-- 화면 조정 필요 함 -->
			<td class="top">
				<ul class="disp_flex alignItem_start justify_start mal10">
					<li id="payWorkWay" class="w280 mar20 hide">
						<div class="sheet_title">
							<ul>
								<li class="txt">근무 지급방법 설정</li>
								<li class="btn">
									<btn:a href="javascript:doActionThird('Save')"    css="basic authA" mid='110708' mdef="저장"/>
								</li>
							</ul>
						</div>
						<div class="bd_top_solid bd_bottom_solid">
							<dl class="disp_flex alignItem_start justify_start">
								<dt class="disp_flex alignItem_center w30p h35 point_bg_lite">
									<span class="mal10">근무명</span>
								</dt>
								<dd class="disp_flex alignItem_center w70p h35">
									<select id="workCd" class="mal10 w90p"></select>
								</dd>
							</dl>
							<dl class="disp_flex alignItem_start justify_start bd_top_dash">
								<dt class="disp_flex alignItem_center w30p h35 point_bg_lite">
									<span class="mal10">적용비율</span>
								</dt>
								<dd class="disp_flex alignItem_center w70p h35">
									<input type="text" id="payWorkApplyRate" class="text mal10 w90p h25 alignR" />
								</dd>
							</dl>
						</div>
					</li>
					<li class="w350">
						<div class="sheet_title">
							<ul>
								<li class="txt"><tit:txt mid='112728' mdef='계산식'/></li>
								<li class="btn"></li>
							</ul>
						</div>
						<div id="cRule" class="point_bd point_bg_base pad10 alignC"></div>
						<div class="explain">
							<div class="title"><tit:txt mid='eleLinkCalcMgr' mdef='항목링크(계산식) 사용방법'/></div>
							<div class="txt">
							<ul>
								<li><tit:txt mid='112729' mdef='1. 계산식은 괄호, 항목, 사칙연산 을 모두 각각 등록.'/></li>
								<li><tit:txt mid='112386' mdef='2. 계산식에 사용할  항목코드는 공통지표  항목관리에 등록 되어 있어야 합니다.'/></li>
							</ul>
							</div>
						</div>
					</li>
				</ul>
			</td>
			<!-- 화면 조정 필요 함 -->
		</tr>
	</table>

</div>
</body>
</html>
