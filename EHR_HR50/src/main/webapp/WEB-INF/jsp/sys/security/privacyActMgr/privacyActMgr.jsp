<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";
	var sheetGubun = null;
	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
            {Header:"<sht:txt mid='infoSeq' mdef='순번'/>",				Type:"Text",     Hidden:0,  Width:0, 	Align:"Center", ColMerge:0,   SaveName:"infoSeq",   	KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='sdateV9' mdef='오픈시작일'/>",			Type:"Date",     Hidden:0,  Width:120,  Align:"Center", ColMerge:0,   SaveName:"sdate", 		KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 , EndDateCol:"edate"},
            {Header:"<sht:txt mid='edateV6' mdef='오픈종료일'/>",			Type:"Date",     Hidden:0,  Width:120, 	Align:"Center", ColMerge:0,   SaveName:"edate",  		KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 , StartDateCol:"sdate"},
            {Header:"<sht:txt mid='subjectView' mdef='개인정보보호법 제목'/>",	Type:"Text",     Hidden:0,  Width:300,  Align:"Left", 	ColMerge:0,   SaveName:"subjectView",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4000,	Cursor:"Pointer" },
            {Header:"<sht:txt mid='subjectView' mdef='개인정보보호법 제목'/>",	Type:"Text",     Hidden:1,  Width:0,  	Align:"Left", 	ColMerge:0,   SaveName:"subject",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
            {Header:"<sht:txt mid='adminInfo' mdef='담당자정보'/>",			Type:"Text",     Hidden:0,  Width:250,  Align:"Left", 	ColMerge:0,   SaveName:"adminInfo",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='view' mdef='미리보기'/>",			Type:"Html",     Hidden:0,  Width:50,  Align:"Center", 	ColMerge:0,   SaveName:"view",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
            {Header:"<sht:txt mid='infoSeq' mdef='순번'/>",		Type:"Text",     Hidden:0,  Width:0, 	Align:"Center", ColMerge:0,   SaveName:"infoSeq",   		KeyField:0,   CalcLogic:"",   Format:"",        	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='eleSeq' mdef='항목순번'/>",	Type:"Text",     Hidden:0,  Width:0, 	Align:"Center", ColMerge:0,   SaveName:"eleSeq",   			KeyField:0,   CalcLogic:"",   Format:"",        	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='eleSummary' mdef='항목개요'/>",	Type:"Text",     Hidden:0,  Width:200,  Align:"Left", 	ColMerge:0,   SaveName:"eleSummary",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
            {Header:"<sht:txt mid='eleContents' mdef='항목내용'/>",	Type:"Text",     Hidden:0,  Width:200,  Align:"Left", 	ColMerge:0,   SaveName:"eleContentsView",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4000,	Cursor:"Pointer" },
            {Header:"<sht:txt mid='eleContents' mdef='항목내용'/>",	Type:"Text",     Hidden:1,  Width:0,  	Align:"Left", 	ColMerge:0,   SaveName:"eleContents",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
            {Header:"<sht:txt mid='eleTypeV1' mdef='항목타입'/>",	Type:"Combo",    Hidden:1,  Width:80,	Align:"Center", ColMerge:0,   SaveName:"eleType",    		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
            {Header:"<sht:txt mid='openYn' mdef='공개여부'/>",	Type:"Combo",    Hidden:0,  Width:80,	Align:"Center", ColMerge:0,   SaveName:"openYn",    		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
            {Header:"<sht:txt mid='grpSort' mdef='출력\n순서'/>",	Type:"Int",      Hidden:0,  Width:40,   Align:"Center", ColMerge:0,   SaveName:"orderSeq",     		KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
            {Header:"입력상자높이\n(미입력 기본 8)",			Type:"Int",     Hidden:0,  Width:100,  	Align:"Center", 	ColMerge:0,   SaveName:"colSize",			KeyField:0,   CalcLogic:"",   Format:"#####",          PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:5 },
            {Header:"빈라인추가\n(위,아래)",				Type:"Combo",   Hidden:0,  Width:80,  	Align:"Center", 	ColMerge:0,   SaveName:"upDown",			KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"빈라인추가\n갯수",					Type:"Int",     Hidden:0,  Width:80,  	Align:"Center", 	ColMerge:0,   SaveName:"whiteSpace",		KeyField:0,   CalcLogic:"",   Format:"#####",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:5 },
            {Header:"동의여부",							Type:"CheckBox",Hidden:0,  Width:80,  	Align:"Center", 	ColMerge:0,   SaveName:"agreeYn",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"Y", FalseValue:"N" }
		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		sheet2.SetColProperty("eleType", 			{ComboText:"체크형|선택형", ComboCode:"1|2"} )
		sheet2.SetColProperty("openYn", 			{ComboText:"Yes|No", ComboCode:"Y|N"} )
		sheet2.SetColProperty("upDown", 			{ComboText:"|위|아래", ComboCode:"|UP|DN"} )

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	function chkInVal() {
		// 시작일자와 종료일자 체크
		var rowCnt = sheet1.RowCount();
		for (var i=1; i<=rowCnt; i++) {
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

	//sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/PrivacyActMgr.do?cmd=getPrivacyActMgrSheet1List", $("#srchFrm").serialize() ); break;
		case "Save":
			if(!chkInVal()){break;}
			sheet1.DoSave( "${ctx}/PrivacyActMgr.do?cmd=savePrivacyActMgrSheet1", $("#srchFrm").serialize()); break;
		case "Insert":		sheet1.SelectCell(sheet1.DataInsert(0), "sdate");
							break;
		case "Copy":
			var Row = sheet1.DataCopy();
			sheet1.SetCellValue(Row, "infoSeq", "");
			break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1, ['Html']);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	//sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet2.DoSearch( "${ctx}/PrivacyActMgr.do?cmd=getPrivacyActMgrSheet2List", $("#srchFrm").serialize(), "1" ); break;
		case "Save": 		sheet2.DoSave( "${ctx}/PrivacyActMgr.do?cmd=savePrivacyActMgrSheet2", $("#srchFrm").serialize()); break;
		case "Insert":		if( sheet1.GetCellValue(sheet1.GetSelectRow(), "sStatus") == "I" ) {
								alert("<msg:txt mid='alertPrivacyActMgr1' mdef='개인정보보호법 제목을 입력 상태에서는 개인정보보호법 항목을 입력 할 수 없습니다.n개인정보보호법 제목을 저장 후 개인정보보호법 항목을 입력해 주세요.'/>");
								return;
							}

							var Row = sheet2.DataInsert(0);
							sheet2.SelectCell(Row, "eleSummary");
							sheet2.SetCellValue(Row, "infoSeq",$("#searchInfoSeq").val());
							break;
		case "Copy":
			var Row = sheet2.DataCopy();
			sheet2.SetCellValue(Row, "eleSeq", "");
			break;
		case "Clear":		sheet2.RemoveAll(); break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2, ['Html']);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet2.Down2Excel(param);
			break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet2.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }
			sheetResize();
			//파일 첨부 시작
			for(var r = sheet1.HeaderRows(); r<sheet1.RowCount()+sheet1.HeaderRows(); r++){
				sheet1.SetCellValue(r, "view", '<a class="basic"><tit:txt mid='104434' mdef='미리보기'/></a>');
				sheet1.SetCellValue(r, "sStatus", "");
			}
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } doAction1("Search"); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
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

	// 셀에 마우스 클릭했을때 발생하는 이벤트
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try{
			if ( sheet1.ColSaveName(NewCol) != "view" ){
		    	$("#searchInfoSeq").val(sheet1.GetCellValue(NewRow, "infoSeq"));
		    	doAction2("Search");
			}
	  	}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
		    if(Row > 0 && sheet1.ColSaveName(Col) == "subjectView"){
		    	sheetGubun = "sheet1";
		    	privacyActMgrPopup(Row);
		    } else if(Row > 0 && sheet1.ColSaveName(Col) == "sDelete"){
		    	if( sheet2.RowCount() > 0 ) {
		    		alert("<msg:txt mid='110353' mdef='개인정보보호법 항목이 존재하는 경우 삭제가 불가 합니다. 개인정보보호법 항목을 먼저 삭제 후 삭제해 주세요.'/>");
		    		sheet1.SetCellValue(Row, "sDelete", "0");
		    		return;
		    	}
		    } else if(Row > 0 && sheet1.ColSaveName(Col) == "view"){
		    	if(!isPopup()) {return;}
		    	var url ="${ctx}/PrivacyActMgr.do?cmd=viewPrivacyLayer";
		    	var title = '개인정보 보호법';
		    	var w = 940, h = 900;
				var p = {enterCd 	: '${ssnEnterCd}',
						infoSeq		: sheet1.GetCellValue(Row, "infoSeq"),
						subject		: sheet1.GetCellValue(Row, "subject"),
						viewMode	: "Y"};
				var layerModal = new window.top.document.LayerModal({
					id : 'privacyAgreementLayer', 
					url : url, 
					parameters: p,
					width : w, 
					height : h, 
					title : title
				});
				layerModal.show();
				
		    }
	  	}catch(ex){alert("OnClick Event Error : " + ex);}
	}

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); }
	    	if( sheet2.RowCount() > 0 && sheet1.GetCellValue(sheet1.GetSelectRow(), "sDelete") == "1" ) {
	    		alert("<msg:txt mid='110353' mdef='개인정보보호법 항목이 존재하는 경우 삭제가 불가 합니다. 개인정보보호법 항목을 먼저 삭제 후 삭제해 주세요.'/>");
	    		sheet1.SetCellValue(sheet1.GetSelectRow(), "sDelete", "0");
	    		return;
	    	}

	    	sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } doAction2("Search"); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	function sheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
		    if(Row > 0 && sheet2.ColSaveName(Col) == "eleContentsView"){
		    	sheetGubun = "sheet2";
		    	privacyActMgrPopup(Row);
		    }
	  	}catch(ex){alert("OnClick Event Error : " + ex);}
	}

	/**
	 * 상세내역 window open event
	 */
	function privacyActMgrPopup(Row){
		if(!isPopup()) {return;}

		var title = "";
  		var w 		= 940;
		var h 		= 550;
		var url 	= "${ctx}/PrivacyActMgr.do?cmd=viewPrivacyActMgrLayer&authPg=${authPg}";
		var subjectContents = null;
		if(sheetGubun == "sheet1") {
			subjectContents = sheet1.GetCellValue(Row, "subject");
			title = "<tit:txt mid='privacyActMgrV2' mdef='개인정보보호법 제목'/>";
		} else if(sheetGubun == "sheet2"){
			subjectContents = sheet2.GetCellValue(Row, "eleContents");
			title = "<tit:txt mid='privacyActMgrV2' mdef='항목내용'/>";
		}
		var p = { infoSeq: sheet1.GetCellValue(Row, "infoSeq"), subjectContents: subjectContents };
		var layerModal = new window.top.document.LayerModal({
			id : 'privacyActMgrLayer', 
			url : url, 
			parameters: p,
			width : w, 
			height : h, 
			title : title,
			trigger: [
				{
					name: 'privacyActMgrLayerTrigger',
					callback: function(rv) {
						if(sheetGubun == "sheet1") {
							sheet1.SetCellValue(Row, "subjectView", rv.subjectContents );
							sheet1.SetCellValue(Row, "subject", 	rv.subjectContents );
						} else if (sheetGubun == 'sheet2'){
							sheet2.SetCellValue(Row, "eleContentsView", 	rv.subjectContents );
							sheet2.SetCellValue(Row, "eleContents", 		rv.subjectContents );
						}
					}
				}
			]
		});
		layerModal.show();
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<input type="hidden" id="searchInfoSeq" name="searchInfoSeq">
	</form>

	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='privacyActMgr' mdef='개인정보보호법관리'/></li>
			<li class="btn">
				<btn:a href="javascript:doAction1('Down2Excel')" 	css="btn outline-gray authR" mid='down2excel' mdef="다운로드"/>
				<btn:a href="javascript:doAction1('Copy')" 	css="btn outline-gray authA" mid='copy' mdef="복사"/>
				<btn:a href="javascript:doAction1('Insert')" css="btn outline-gray authA" mid='insert' mdef="입력"/>
				<btn:a href="javascript:doAction1('Save')" 	css="btn filled authA" mid='save' mdef="저장"/>
				<btn:a href="javascript:doAction1('Search')" 	css="btn dark authR" mid='search' mdef="조회"/>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "50%", "${ssnLocaleCd}"); </script>
	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='privacyActMgrV1' mdef='개인정보보호법항목관리'/></li>
			<li class="btn">
				<btn:a href="javascript:doAction2('Down2Excel')" 	css="btn outline-gray authR" mid='down2excel' mdef="다운로드"/>
				<btn:a href="javascript:doAction2('Copy')" 	css="btn outline-gray authA" mid='copy' mdef="복사"/>
				<btn:a href="javascript:doAction2('Insert')" css="btn outline-gray authA" mid='insert' mdef="입력"/>
				<btn:a href="javascript:doAction2('Save')" 	css="btn filled authA" mid='save' mdef="저장"/>
				<btn:a href="javascript:doAction2('Search')" 	css="btn dark authR" mid='search' mdef="조회"/>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet2", "100%", "50%", "${ssnLocaleCd}"); </script>

</div>
</body>
</html>
