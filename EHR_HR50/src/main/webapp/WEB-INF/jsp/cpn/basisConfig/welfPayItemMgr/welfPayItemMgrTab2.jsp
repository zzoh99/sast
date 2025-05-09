<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<title><tit:txt mid='114494' mdef='복리후생급여항목코드 '/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
	$(function() {

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
                         {Header:"<sht:txt mid='sNo' mdef='No'/>|<sht:txt mid='sNo' mdef='No'/>",         Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
                         {Header:"<sht:txt mid='sDelete' mdef='삭제'/>|<sht:txt mid='sDelete' mdef='삭제'/>",       Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),  Width:"${sDelWdt}", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
                         {Header:"<sht:txt mid='sResult' mdef='결과'/>|<sht:txt mid='sResult' mdef='결과'/>",       Type:"${sRstTy}",   Hidden:Number("${sRstHdn}"),  Width:"${sRstWdt}", Align:"Center", ColMerge:0,   SaveName:"sResult" , Sort:0},
                         {Header:"<sht:txt mid='statusCd' mdef='상태'/>|<sht:txt mid='statusCd' mdef='상태'/>",       Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),  Width:"${sSttWdt}", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
                         {Header:"<sht:txt mid='payCd' mdef='급여구분'/>|<sht:txt mid='payCd' mdef='급여구분'/>",        Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"payCd",             KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
                         {Header:"<sht:txt mid='benefitBizCdV2' mdef='복리후생업무구분'/>|<sht:txt mid='benefitBizCdV2' mdef='복리후생업무구분'/>", Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"benefitBizCd",   KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
                         {Header:"<sht:txt mid='elementCdV4' mdef='급여항목코드'/>|<sht:txt mid='elementCdV4' mdef='급여항목코드'/>",     Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"elementCd",      KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
                         {Header:"<sht:txt mid='elementNmV3' mdef='급여항목'/>|<sht:txt mid='elementNmV3' mdef='급여항목'/>",         Type:"Popup",     Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"elementNm",      KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
                         {Header:"<sht:txt mid='includeYn' mdef='포함여부'/>|<sht:txt mid='mon' mdef='금액'/>1",       Type:"CheckBox",      Hidden:0,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"mon1Yn",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1, TrueValue:"Y", FalseValue:"N"},
                         {Header:"<sht:txt mid='includeYn' mdef='포함여부'/>|<sht:txt mid='mon' mdef='금액'/>2",       Type:"CheckBox",      Hidden:0,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"mon2Yn",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1, TrueValue:"Y", FalseValue:"N"},
                         {Header:"<sht:txt mid='includeYn' mdef='포함여부'/>|<sht:txt mid='mon' mdef='금액'/>3",       Type:"CheckBox",      Hidden:0,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"mon3Yn",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1, TrueValue:"Y", FalseValue:"N"},
                         {Header:"<sht:txt mid='includeYn' mdef='포함여부'/>|<sht:txt mid='mon' mdef='금액'/>4",       Type:"CheckBox",      Hidden:0,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"mon4Yn",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1, TrueValue:"Y", FalseValue:"N"},
                         {Header:"<sht:txt mid='includeYn' mdef='포함여부'/>|<sht:txt mid='mon' mdef='금액'/>5",       Type:"CheckBox",      Hidden:0,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"mon5Yn",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1, TrueValue:"Y", FalseValue:"N"},
                         {Header:"<sht:txt mid='includeYn' mdef='포함여부'/>|<sht:txt mid='mon' mdef='금액'/>6",       Type:"CheckBox",      Hidden:0,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"mon6Yn",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1, TrueValue:"Y", FalseValue:"N"},
                         {Header:"<sht:txt mid='includeYn' mdef='포함여부'/>|<sht:txt mid='mon' mdef='금액'/>7",       Type:"CheckBox",      Hidden:0,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"mon7Yn",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1, TrueValue:"Y", FalseValue:"N"},
                         {Header:"<sht:txt mid='includeYn' mdef='포함여부'/>|<sht:txt mid='mon' mdef='금액'/>8",       Type:"CheckBox",      Hidden:0,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"mon8Yn",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1, TrueValue:"Y", FalseValue:"N"},
                         {Header:"<sht:txt mid='includeYn' mdef='포함여부'/>|<sht:txt mid='mon' mdef='금액'/>9",       Type:"CheckBox",      Hidden:0,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"mon9Yn",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1, TrueValue:"Y", FalseValue:"N"},
                         {Header:"<sht:txt mid='includeYn' mdef='포함여부'/>|<sht:txt mid='mon' mdef='금액'/>10",       Type:"CheckBox",      Hidden:0,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"mon10Yn",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1, TrueValue:"Y", FalseValue:"N"},
                         {Header:"<sht:txt mid='includeYn' mdef='포함여부'/>|<sht:txt mid='mon' mdef='금액'/>11",       Type:"CheckBox",      Hidden:0,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"mon11Yn",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1, TrueValue:"Y", FalseValue:"N"},
                         {Header:"<sht:txt mid='includeYn' mdef='포함여부'/>|<sht:txt mid='mon' mdef='금액'/>12",       Type:"CheckBox",      Hidden:0,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"mon12Yn",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1, TrueValue:"Y", FalseValue:"N"}
		 ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetCountPosition(4);

		//급여구분
		var payCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCpnPayCdList",false).codeList, "");
        sheet1.SetColProperty("payCd", {ComboText:payCdList[0], ComboCode:payCdList[1]} );


		var benefitBizCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","B10230"), "");
		sheet1.SetColProperty("benefitBizCd", 			{ComboText:benefitBizCdList[0], ComboCode:benefitBizCdList[1]} );

	    $("#searchBenefitElemNm").bind("keyup",function(event){
	        if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }

	    });

		$(window).smartresize(sheetResize); sheetInit();
		doAction("Search");
	});

	//Sheet Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/WelfPayItemMgr.do?cmd=getWelfPayItemMgrList", $("#sheet1Form").serialize() ); break;
		case "Save":
			if(!dupChk(sheet1,"payCd|benefitBizCd|elementNm", true, true)){break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/WelfPayItemMgr.do?cmd=saveWelfPayItemMgr", $("#sheet1Form").serialize()); break;
		case "Insert":		sheet1.SelectCell(sheet1.DataInsert(0), 4); break;
		case "Copy":		sheet1.DataCopy(); break;
		case "Clear":		sheet1.RemoveAll(); break;
        case "Down2Excel":
        			var downcol = makeHiddenSkipCol(sheet1);
					var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
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
		try { if (Msg != "") { alert(Msg); } doAction("Search");} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
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
        try{

          var colName = sheet1.ColSaveName(Col);
          var args    = new Array();

          args["elementCd"]   = sheet1.GetCellValue(Row, "elementCd");
          args["elementNm"]  = sheet1.GetCellValue(Row, "elementNm");

          var rv = null;

          if(colName == "elementNm") {
        	  if(!isPopup()) {return;}
        	  gPRow = Row;
        	  pGubun = "payElementPopup";

			  let layerModal = new window.top.document.LayerModal({
				  id : 'payElementLayer'
				  , url : '/PayElementPopup.do?cmd=viewPayElementLayer&authPg=${authPg}'
				  , parameters : args
				  , width : 1020
				  , height : 520
				  , title : '수당,공제 항목'
				  , trigger :[
					  {
						  name : 'payTrigger'
						  , callback : function(result){
							  getReturnValue(result)
						  }
					  }
				  ]
			  });
			  layerModal.show();

              <%--var rv = openPopup("/PayElementPopup.do?cmd=payElementPopup&authPg=${authPg}", args, "740","520");--%>

          }

        }catch(ex){alert("OnPopupClick Event Error : " + ex);}
    }

	function getReturnValue(rv) {
	    if(pGubun == "payElementPopup"){
            sheet1.SetCellValue(gPRow, "elementCd",   rv["resultElementCd"] );
            sheet1.SetCellValue(gPRow, "elementNm",   rv["resultElementNm"] );
	    }
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
	<input id="searchType" name="searchType" type="hidden" class="" value="E"/>
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='eleGroupMgr2' mdef='항목명'/></th>
						<td>  <input id="searchBenefitElemNm" name ="searchBenefitElemNm" type="text" class="text" /> </td>
						<td> <btn:a href="javascript:doAction('Search')" id="btnSearch" css="button" mid='search' mdef="조회"/> </td>
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
							<li id="txt" class="txt"><tit:txt mid='114494' mdef='복리후생급여항목코드 '/> </li>
							<li class="btn">
								<btn:a href="javascript:doAction('Insert')" css="basic authA" mid='insert' mdef="입력"/>
								<btn:a href="javascript:doAction('Copy')" 	css="basic authA" mid='copy' mdef="복사"/>
								<btn:a href="javascript:doAction('Save')" 	css="basic authA" mid='save' mdef="저장"/>
								<a href="javascript:doAction('Down2Excel')" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "90%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>

</div>
</body>
</html>