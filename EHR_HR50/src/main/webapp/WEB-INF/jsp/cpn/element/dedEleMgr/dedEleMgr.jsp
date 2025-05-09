<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<title><tit:txt mid='dedEleMgr' mdef='공제항목관리'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";
	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:6,SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
            {Header:"<sht:txt mid='sNo' mdef='No'/>",        Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
            {Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",      Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),  Width:"${sDelWdt}", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
            {Header:"<sht:txt mid='sStatus' mdef='상태'/>",      Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),  Width:"${sSttWdt}", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
			{Header:"<sht:txt mid='elementType' mdef='항목유형'/>",           Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"elementType",       KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='authScopeCd' mdef='코드'/>",               Type:"Text",      Hidden:0,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"elementCd",         KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='elementNmV2' mdef='공제항목명'/>",         Type:"Text",      Hidden:0,  Width:100,   Align:"Left",    ColMerge:0,   SaveName:"elementNm",         KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:50 },
			{Header:"<sht:txt mid='elementEng' mdef='항목영문명'/>",         Type:"Text",      Hidden:1,  Width:120,  Align:"Left",    ColMerge:0,   SaveName:"elementEng",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:50 },

			{Header:"<sht:txt mid='keyIdV1' mdef='어휘코드'/>",		Type:"Text",		Hidden:1,	Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageCd",	UpdateEdit:0,	InsertEdit:0},
			{Header:"<sht:txt mid='languageNm' mdef='어휘코드명'/>",	Type:"Popup",	Hidden:Number("${sLanHdn}"),Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageNm",	UpdateEdit:1,	InsertEdit:1},

			{Header:"<sht:txt mid='reportNmV1' mdef='Report명'/>",           Type:"Text",      Hidden:0,  Width:100,   Align:"Left",    ColMerge:0,   SaveName:"reportNm",          KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },

			{Header:"<sht:txt mid='keyIdV1' mdef='어휘코드'/>",		Type:"Text",		Hidden:1,	Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageCd2",	UpdateEdit:0,	InsertEdit:0},
			{Header:"<sht:txt mid='languageNm' mdef='어휘코드명'/>",	Type:"Popup",	Hidden:Number("${sLanHdn}"),Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageNm2",	UpdateEdit:1,	InsertEdit:1},

			{Header:"<sht:txt mid='deductionType' mdef='항목분류'/>",           Type:"Combo",     Hidden:0,  Width:80,   Align:"Left",    ColMerge:0,   SaveName:"deductionType",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='priority' mdef='계산\n순위'/>",         Type:"Float",     Hidden:0,  Width:40,   Align:"Right",   ColMerge:0,   SaveName:"priority",          KeyField:1,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
			{Header:"<sht:txt mid='grpSort' mdef='출력\n순서'/>",         Type:"Float",     Hidden:0,  Width:40,   Align:"Right",   ColMerge:0,   SaveName:"grpSort",           KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4 },
			{Header:"<sht:txt mid='updownType' mdef='절상/사\n구분'/>",      Type:"Combo",     Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"updownType",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='danwi' mdef='단위'/>",               Type:"Combo",     Hidden:0,  Width:40,   Align:"Center",  ColMerge:0,   SaveName:"updownUnit",        KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
			{Header:"<sht:txt mid='currency' mdef='통화'/>",               Type:"Combo",     Hidden:0,  Width:40,   Align:"Center",  ColMerge:0,   SaveName:"currencyCd",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='elementLinkTypeV1' mdef='항목Link유형'/>",       Type:"Combo",     Hidden:0,  Width:80,   Align:"Left",    ColMerge:0,   SaveName:"elementLinkType",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='sysYnV1' mdef='시스템자료여부'/>",     Type:"Text",      Hidden:1,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"sysYn",             KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='sYmd' mdef='시작일자'/>",           Type:"Date",      Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"sdate",             KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='eYmd' mdef='종료일자'/>",           Type:"Date",      Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"edate",             KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='attribute8V1' mdef='연말정산코드'/>",       Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"attribute8",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='attribute8Nm' mdef='연말정산'/>",           Type:"Popup",     Hidden:0,  Width:120,  Align:"Left",    ColMerge:0,   SaveName:"attribute8Nm",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 }
		];

		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetCountPosition(4);

		// 항목분류",           Type:"Combo",     Hidden:0,  Width:70,   Align:"Left",    ColMerge:0,   SaveName:"deductionType",
		var deductionTypeList    = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00015"), "");
        sheet1.SetColProperty("deductionType",    {ComboText:"|"+deductionTypeList[0], ComboCode:"|"+deductionTypeList[1]} );

		// 절상/사\n구분",      Type:"Combo",     Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"updownType",
        var updownTypeList    = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00005"), "");
        sheet1.SetColProperty("updownType",    {ComboText:"|"+updownTypeList[0], ComboCode:"|"+updownTypeList[1]} );

		// 단위",               Type:"Combo",     Hidden:0,  Width:40,   Align:"Center",  ColMerge:0,   SaveName:"updownUnit",
        var updownUnitList    = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00006"), "");
        sheet1.SetColProperty("updownUnit",    {ComboText:"|"+updownUnitList[0], ComboCode:"|"+updownUnitList[1]} );

		// 통화",               Type:"Combo",     Hidden:0,  Width:40,   Align:"Center",  ColMerge:0,   SaveName:"currencyCd",
        var currencyCdList    = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S10030"), "");
        sheet1.SetColProperty("currencyCd",    {ComboText:"|"+currencyCdList[0], ComboCode:"|"+currencyCdList[1]} );

		// 항목Link유형",       Type:"Combo",     Hidden:0,  Width:80,   Align:"Left",    ColMerge:0,   SaveName:"elementLinkType",
        var elementLinkTypeList    = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00003"), "");
        sheet1.SetColProperty("elementLinkType",    {ComboText:"|"+elementLinkTypeList[0], ComboCode:"|"+elementLinkTypeList[1]} );

		$("#searchElementNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
		});
		$(window).smartresize(sheetResize); sheetInit();
		doAction("Search");
	});

	//Sheet Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/DedEleMgr.do?cmd=getDedEleMgrList", $("#sheet1Form").serialize() ); break;
		case "Save":
			if(!dupChk(sheet1,"elementCd|sdate", false, true)){break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/DedEleMgr.do?cmd=saveDedEleMgr", $("#sheet1Form").serialize()); break;
		case "Insert":
			var Row = sheet1.DataInsert(0);
            sheet1.SelectCell(Row, 4);
          	sheet1.SetCellValue(Row, "elementType","D");
            break;
		case "Copy":
			var Row = sheet1.DataCopy();
			sheet1.SetCellValue(Row, "languageCd", "" );
			sheet1.SetCellValue(Row, "languageNm", "" );
			sheet1.SetCellValue(Row, "languageCd2", "" );
			sheet1.SetCellValue(Row, "languageNm2", "" );
			break;
		case "Clear":		sheet1.RemoveAll(); break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction("Insert");
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
	}

    //  Type이 POPUP인 셀에서 팝업버튼을 눌렀을때 발생하는 이벤트
    function sheet1_OnPopupClick(Row, Col){

		let layerModal = new window.top.document.LayerModal({
			id : 'viewDedEleLayer'
			, url : '/DedEleMgr.do?cmd=viewDedEleMgrLayer&authPg=${authPg}'
			, parameters : {
				elementCd : sheet1.GetCellValue(Row, "resultElementCd")
				, elementNm : sheet1.GetCellValue(Row, "resultElementNm")
				, elementType :sheet1.GetCellValue(Row, "elementType")
			}
			, width : 860
			, height : 520
			, title : '<tit:txt mid='dedEleMgrPop' mdef='연말정산 코드항목 조회'/>'
			, trigger :[
				{
					name : 'dedTrigger'
					, callback : function(result){
						sheet1.SetCellValue( Row, "attribute8", result.adjElementCd);
						sheet1.SetCellValue( Row, "attribute8Nm", result.adjElementNm);
					}
				}
			]
		});
		layerModal.show();

        <%--try{--%>

        <%--  var colName = sheet1.ColSaveName(Col);--%>
        <%--  var args    = new Array();--%>

        <%--  args["adjElementCd"]  = sheet1.GetCellValue(Row, "attribute8");--%>
        <%--  args["adjElementNm"]  = sheet1.GetCellValue(Row, "attribute8Nm");--%>

        <%--  var rv = null;--%>

        <%--  if(colName == "attribute8Nm") {--%>
        <%--	  if(!isPopup()) {return;}--%>
        <%--	  gPRow = Row;--%>
        <%--	  pGubun = "viewDedEleMgrPopup";--%>
        <%--      openPopup("/DedEleMgr.do?cmd=viewDedEleMgrPopup&authPg=${authPg}", args, "740","520");--%>

        <%--  }else if(colName == "languageNm"){--%>
        <%--	  lanuagePopup(Row, "sheet1", "tcpn011", "languageCd", "languageNm", "elementNm");--%>
        <%--  }else if(colName == "languageNm2"){--%>
        <%--	  lanuagePopup(Row, "sheet1", "tcpn011", "languageCd2", "languageNm2", "reportNm");--%>
        <%--  }--%>

        <%--}catch(ex){alert("OnPopupClick Event Error : " + ex);}--%>
    }
    
	function sheet1_OnChange(Row, Col, Value){
		try {
			if ( sheet1.ColSaveName(Col) == "languageNm" ){
				if ( sheet1.GetCellValue( Row, Col ) == "" ){
					sheet1.SetCellValue( Row, "languageCd", "");
				}
			}
			
			if ( sheet1.ColSaveName(Col) == "languageNm2" ){
				if ( sheet1.GetCellValue( Row, Col ) == "" ){
					sheet1.SetCellValue( Row, "languageCd2", "");
				}
			}

		} catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

	    if(pGubun == "viewDedEleMgrPopup"){
	    	sheet1.SetCellValue(gPRow, "attribute8",   rv["adjElementCd"] );
	        sheet1.SetCellValue(gPRow, "attribute8Nm",  rv["adjElementNm"] );

	    }
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='113798' mdef='공제항목명'/></th>
						<td>  <input id="searchElementNm" name ="searchElementNm" type="text" class="text" /> </td>
						<td> <btn:a href="javascript:doAction('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/> </td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='dedEleMgr' mdef='공제항목관리'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction('Insert')" css="basic authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction('Copy')" 	css="basic authA" mid='110696' mdef="복사"/>
								<btn:a href="javascript:doAction('Save')" 	css="basic authA" mid='110708' mdef="저장"/>
								<btn:a href="javascript:doAction('Down2Excel')"   css="basic authR" mid='110698' mdef="다운로드"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>

</div>
</body>
</html>
