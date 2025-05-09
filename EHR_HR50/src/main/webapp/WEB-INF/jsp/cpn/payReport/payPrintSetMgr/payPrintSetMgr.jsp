<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {


		// Gird 1
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:9};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='payCd' mdef='급여구분'/>",   Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"payCd",   		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='eleCalType' mdef='항목구분'/>",   Type:"Combo",      Hidden:0,  Width:50,    Align:"Left",    ColMerge:0,   SaveName:"elementType",   	KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",      Type:"Int",      Hidden:0,  Width:50,    Align:"Left",    ColMerge:0,   SaveName:"seq",   			KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='reportNm' mdef='출력명'/>",     Type:"Text",      Hidden:0,  Width:90,    Align:"Left",    ColMerge:0,   SaveName:"reportNm",   		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:50 },
			{Header:"<sht:txt mid='useYnV3' mdef='사용여부'/>",   Type:"Combo",      Hidden:0,  Width:50,    Align:"Left",    ColMerge:0,   SaveName:"useYn",   		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='elementNmV6' mdef='항목'/>",      Type:"Text",      Hidden:0,  Width:70,    Align:"Left",    ColMerge:0,   SaveName:"elementNms",   	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0 }

			]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var searchPayCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&searchRunType=00001,00002,00003,RETRO,ETC","queryId=getCpnPayCdList",false).codeList, "");	//소속도
		sheet1.SetColProperty("elementType", 	{ComboText:"수당|공제", ComboCode:"A|D"} );
		sheet1.SetColProperty("useYn", 			{ComboText:"Yes|No", ComboCode:"Y|N"} );
		//조회조건
		$("#searchPayCd").html(searchPayCdList[2]);



		// Grid 2
		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,Page:9};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata2.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='useYnV10' mdef='use_yn'/>", 		Type:"Text",      	Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"useYn",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='payCdV6' mdef='pay_cd'/>", 		Type:"Text",      	Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"payCd",    KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='elementTypeV5' mdef='element_type'/>", Type:"Text",      	Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"elementType",      KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:15 },
			{Header:"<sht:txt mid='seqV4' mdef='seq'/>",         	Type:"Int", 		Hidden:1,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"seq",           KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='elementCdV6' mdef='element_cd'/>",   Type:"Text",      	Hidden:1,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"elementCd",          KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:15 },
			{Header:"<sht:txt mid='elementNmV6' mdef='항목'/>",         	Type:"Popup",       Hidden:0,  Width:120,  Align:"Left",   ColMerge:0,   SaveName:"elementNm",      KeyField:1,   CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:50 }
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		$(window).smartresize(sheetResize); sheetInit();
	});


	function doSearch(){
		doAction1('Search');
	}


	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/PayPrintSetMgr.do?cmd=getPayPrintSetMgrFirstList", $("#sheetForm").serialize() ); sheet2.RemoveAll(); break;
		case "Save":
			IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave( "${ctx}/PayPrintSetMgr.do?cmd=savePayPrintSetMgrFirst", $("#sheetForm").serialize()); break;
		case "Insert":
			var newRow = sheet1.DataInsert(0);
			sheet1.SetCellValue(newRow, "payCd", $("#searchPayCd").val() ) ;
			doAction2("Clear") ;
			break;
		case "Copy":		sheet1.DataCopy(); break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":
							var downcol = makeHiddenSkipCol(sheet1);
							var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
							sheet1.Down2Excel(param);
				
							break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}
	//Example Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			$("#searchElementType").val(sheet1.GetCellValue(sheet1.GetSelectRow(), 'elementType')) ;
			$("#searchSeq").val(sheet1.GetCellValue(sheet1.GetSelectRow(), 'seq')) ;
			$("#searchHiddenPayCd").val(sheet1.GetCellValue(sheet1.GetSelectRow(), 'payCd')) ;

			sheet2.DoSearch( "${ctx}/PayPrintSetMgr.do?cmd=getPayPrintSetMgrSecondList", $("#sheetForm").serialize()); break;
		case "Save":
			//if(!dupChk(sheet2,"payActionCd|elementCd|sabun", false, true)){break;}
			IBS_SaveName(document.sheetForm,sheet2);
			sheet2.DoSave( "${ctx}/PayPrintSetMgr.do?cmd=savePayPrintSetMgrSecond", $("#sheetForm").serialize()); break;
		case "Insert":
			if(sheet1.RowCount()==0){
				alert("<msg:txt mid='payPrintSetMgr1' mdef='급/상여대장 항목관리 데이터를 선택 하세요.'/>");
				return;
			}else if ( sheet1.GetCellValue(sheet1.GetSelectRow(), "sStatus") == "I" ) {
				alert("<msg:txt mid='payPrintSetMgr2' mdef='급/상여대장 항목관리 데이터를 먼저 저장하세요.'/>");
				return;
			}else{
		        var newRow = sheet2.DataInsert(0);
                sheet2.SetCellValue(newRow, "payCd",  			sheet1.GetCellValue(sheet1.GetSelectRow(), "payCd") );
                sheet2.SetCellValue(newRow, "elementType",  	sheet1.GetCellValue(sheet1.GetSelectRow(), "elementType") );
                sheet2.SetCellValue(newRow, "seq",  			sheet1.GetCellValue(sheet1.GetSelectRow(), "seq") );
            	searchElementPopup(newRow);
			}
			break;
		case "Copy":		sheet2.DataCopy(); break;
		case "Clear":		sheet2.RemoveAll(); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize();

			if(sheet1.RowCount()!=0){
				sheet1.SelectCell(1, "seq") ;
				doAction2('Search') ;
			}

		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); }  doAction1('Search'); sheet2.RemoveAll(); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
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

	// Detail 항목 검색
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try{
			$("#searchElementType").val(sheet1.GetCellValue(NewRow, "elementType"));
			$("#searchSeq").val(sheet1.GetCellValue(NewRow, "seq"));
			$("#searchHiddenPayCd").val(sheet1.GetCellValue(NewRow, "payCd"));
			if(OldRow != NewRow) doAction2('Search');
		}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } doAction2('Search');} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet2_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction1("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet2.GetCellValue(Row, "sStatus") == "I") {
				sheet2.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

    //  Type이 POPUP인 셀에서 팝업버튼을 눌렀을때 발생하는 이벤트
    function sheet2_OnPopupClick(Row, Col) {
        try {
        	searchElementPopup(Row);
		} catch(ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
    }

    function searchElementPopup(Row) {
		new window.top.document.LayerModal({
			id : 'payElementLayer',
			url : '/PayElementPopup.do?cmd=viewPayElementLayer&authPg=${authPg}',
			parameters : {
				elementCd: sheet2.GetCellValue(Row, "elementCd"),
				elementNm: sheet2.GetCellValue(Row, "elementNm")
			},
			width : 740,
			height : 520,
			title : '수당,공제 항목',
			trigger :[
				{
					name : 'payTrigger',
					callback : function(rv) {
						sheet2.SetCellValue(Row, "elementCd", rv["resultElementCd"]);
						sheet2.SetCellValue(Row, "elementNm", rv["resultElementNm"]);
						const sht1SelectRow = sheet1.GetSelectRow();
						const sStatus = sheet1.GetCellValue(sht1SelectRow, "sStatus");
						if (sStatus !== "D") {
							sheet1.SetCellValue(sht1SelectRow, "elementNms", getElementNms());
							sheet1.SetCellValue(sht1SelectRow, "sStatus", sStatus);
						}
					}
				}
			]
		}).show();
    }

	/**
	 * 급/상여대장 항목관리 내 항목에 표시될 항목 Detail 리스트
	 * @returns {string}
	 */
	function getElementNms() {
		let elementNms = "";
		for (var i = 0; i < Math.min(5, sheet2.RowCount()); i++) {
			const headerRows = sheet2.HeaderRows();
			const value = sheet2.GetCellValue(i+headerRows, "elementNm");

			if (!(value) || value === -1) continue;
			if (i !== 0) elementNms += ", ";
			elementNms += value;
		}
		return elementNms;
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
	<input type="hidden" id="searchElementType" name="searchElementType" value="" />
	<input type="hidden" id="searchSeq" name="searchSeq" value="" />
	<input type="hidden" id="searchHiddenPayCd" name="searchHiddenPayCd" value="" />
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='114519' mdef='급여구분 '/></th>
						<td>  <select id="searchPayCd" name="searchPayCd"></select> </td>
						<td> <a href="javascript:doSearch()" id="btnSearch" class="btn dark"><tit:txt mid='104081' mdef='조회'/></a> </td>
					</tr>
				</table>
			</div>
		</div>
	</form>

	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<colgroup>
		<col width="60%" />
		<col width="40%" />
	</colgroup>
	<tr>
		<td class="sheet_left">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='payPrintSetMgr1' mdef='급/상여대장 항목관리'/></li>
					<li class="btn">
						<a href="javascript:doAction1('Insert')" class="btn outline_gray authA"><tit:txt mid='104267' mdef='입력'/></a>
						<a href="javascript:doAction1('Copy')" 	class="btn outline_gray authA"><tit:txt mid='104335' mdef='복사'/></a>
						<a href="javascript:doAction1('Save')" 	class="btn filled authA"><tit:txt mid='104476' mdef='저장'/></a>
						<a href="javascript:doAction1('Down2Excel')" 	class="btn outline_gray authA"><tit:txt mid='download' mdef='다운로드'/></a>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
		</td>
		<td class="sheet_right">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='payPrintSetMgr2' mdef='항목 Detail'/></li>
					<li class="btn">
						<a href="javascript:doAction2('Insert')" class="btn outline_gray authA"><tit:txt mid='104267' mdef='입력'/></a>
						<a href="javascript:doAction2('Save')" 	class="btn filled authA"><tit:txt mid='104476' mdef='저장'/></a>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet2", "100%", "100%"); </script>
		</td>
	</tr>
	</table>

</div>
</body>
</html>
