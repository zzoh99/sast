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

		sheet1.SetDataLinkMouse("detail", 1);

		var initdata = {};
		initdata.Cfg = {FrozenCol:7,SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata.Cols = [
                 {Header:"<sht:txt mid='sNo' mdef='No'/>",       Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
                 {Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",       Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 },
                 {Header:"<sht:txt mid='sStatus' mdef='상태'/>",       Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
                 {Header:"<sht:txt mid='dbItemDesc' mdef='세부\n내역'/>",          Type:"Image",     Hidden:0,  Width:40,   Align:"Center",  ColMerge:0,   SaveName:"detail",            KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1 },
                 {Header:"<sht:txt mid='elementType' mdef='항목유형'/>",            Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"elementType",       KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
                 {Header:"<sht:txt mid='authScopeCd' mdef='코드'/>",                Type:"Text",      Hidden:0,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"elementCd",         KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
                 {Header:"<sht:txt mid='benefitElemNm' mdef='항목명'/>",              Type:"Text",      Hidden:0,  Width:150,  Align:"Left",    ColMerge:0,   SaveName:"elementNm",         KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:50 },

                 {Header:"<sht:txt mid='keyIdV1' mdef='어휘코드'/>",		Type:"Text",		Hidden:1,	Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageCd",	UpdateEdit:0,	InsertEdit:0},
     			 {Header:"<sht:txt mid='languageNm' mdef='어휘코드명'/>",	Type:"Popup",	Hidden:Number("${sLanHdn}"),Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageNm",	UpdateEdit:1,	InsertEdit:1},

                 {Header:"<sht:txt mid='elementEng' mdef='항목영문명'/>",          Type:"Text",      Hidden:1,  Width:120,  Align:"Left",    ColMerge:0,   SaveName:"elementEng",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:50 },
                 {Header:"<sht:txt mid='reportNmV1' mdef='Report명'/>",            Type:"Text",      Hidden:0,  Width:150,   Align:"Left",    ColMerge:0,   SaveName:"reportNm",          KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },

                 {Header:"<sht:txt mid='keyIdV1' mdef='어휘코드'/>",		Type:"Text",		Hidden:1,	Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageCd2",	UpdateEdit:0,	InsertEdit:0},
                 {Header:"<sht:txt mid='languageNm' mdef='어휘코드명'/>",	Type:"Popup",	Hidden:Number("${sLanHdn}"),Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageNm2",	UpdateEdit:1,	InsertEdit:1},

                 {Header:"<sht:txt mid='priority' mdef='계산\n순위'/>",          Type:"Float",     Hidden:0,  Width:60,   Align:"Right",   ColMerge:0,   SaveName:"priority",          KeyField:1,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
                 {Header:"<sht:txt mid='grpSort' mdef='출력\n순서'/>",          Type:"Float",     Hidden:0,  Width:60,   Align:"Right",   ColMerge:0,   SaveName:"grpSort",           KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4 },
                 {Header:"<sht:txt mid='updownType' mdef='절상/사\n구분'/>",       Type:"Combo",     Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"updownType",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
                 {Header:"<sht:txt mid='danwi' mdef='단위'/>",                Type:"Combo",     Hidden:0,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"updownUnit",        KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
                 {Header:"<sht:txt mid='currency' mdef='통화'/>",                Type:"Combo",     Hidden:1,  Width:40,   Align:"Center",  ColMerge:0,   SaveName:"currencyCd",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
                 {Header:"<sht:txt mid='elementLinkTypeV1' mdef='항목Link유형'/>",        Type:"Combo",     Hidden:0,  Width:100,   Align:"Left",    ColMerge:0,   SaveName:"elementLinkType",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
                 {Header:"<sht:txt mid='resultElementCd' mdef='하위항목코드'/>",        Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"resultElementCd",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
                 {Header:"<sht:txt mid='resultElementNm' mdef='하위항목'/>",            Type:"Popup",     Hidden:0,  Width:110,   Align:"Left",    ColMerge:0,   SaveName:"resultElementNm",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:50 },
                 {Header:"<sht:txt mid='sysYnV1' mdef='시스템자료여부'/>",      Type:"Text",      Hidden:1,  Width:75,   Align:"Center",  ColMerge:0,   SaveName:"sysYn",             KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:8 },
                 {Header:"<sht:txt mid='sYmd' mdef='시작일자'/>",            Type:"Date",      Hidden:0,  Width:75,   Align:"Center",  ColMerge:0,   SaveName:"sdate",             KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
                 {Header:"<sht:txt mid='eYmd' mdef='종료일자'/>",            Type:"Date",      Hidden:0,  Width:85,   Align:"Center",  ColMerge:0,   SaveName:"edate",             KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
                 {Header:"<sht:txt mid='attribute2' mdef='수습적용율'/>",           Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",    ColMerge:0,   SaveName:"attribute2",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
                 {Header:"<sht:txt mid='attribute3' mdef='과세설정'/>",           Type:"Combo",     Hidden:0,  Width:90,  Align:"Center",    ColMerge:0,   SaveName:"attribute3",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
                 {Header:"<sht:txt mid='attribute4' mdef='신입/복직일할여부'/>",           Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",    ColMerge:0,   SaveName:"attribute4",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
                 {Header:"<sht:txt mid='attribute5' mdef='퇴직일할여부'/>",           Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",    ColMerge:0,   SaveName:"attribute5",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
                 {Header:"<sht:txt mid='attribute6' mdef='발령관련'/>",           Type:"Combo",     Hidden:0,  Width:90,  Align:"Center",    ColMerge:0,   SaveName:"attribute6",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
                 {Header:"<sht:txt mid='attribute7' mdef='징계관련'/>",           Type:"Combo",     Hidden:0,  Width:90,  Align:"Center",    ColMerge:0,   SaveName:"attribute7",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
                 {Header:"<sht:txt mid='attribute9' mdef='근태관련'/>",           Type:"Combo",     Hidden:0,  Width:90,  Align:"Center",    ColMerge:0,   SaveName:"attribute9",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
                 {Header:"<sht:txt mid='attribute11' mdef='산재관련'/>",           Type:"Combo",     Hidden:1,  Width:90,  Align:"Center",    ColMerge:0,   SaveName:"attribute11",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
                 {Header:"연말정산관련",           Type:"Text",     Hidden:1,  Width:90,  Align:"Center",    ColMerge:0,   SaveName:"attribute8",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
                 {Header:"연말정산관련",           Type:"PopupEdit",     Hidden:0,  Width:200,  Align:"Left",    ColMerge:0,   SaveName:"attribute8Nm",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
                 {Header:"<sht:txt mid='attribute10' mdef='상여관련'/>",           Type:"Combo",     Hidden:0,  Width:90,  Align:"Center",    ColMerge:0,   SaveName:"attribute10",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
                 {Header:"<sht:txt mid='gubun1' mdef='통상임금'/>",           Type:"Text",     Hidden:0,  Width:90,  Align:"Center",    ColMerge:0,   SaveName:"gubun1",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
                 {Header:"<sht:txt mid='avgMon' mdef='평균임금'/>",           Type:"Text",     Hidden:0,  Width:90,  Align:"Center",    ColMerge:0,   SaveName:"gubun2",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
                 {Header:"<sht:txt mid='gubun3' mdef='국민연금'/>",           Type:"Text",     Hidden:1,  Width:90,  Align:"Center",    ColMerge:0,   SaveName:"gubun3",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
                 {Header:"<sht:txt mid='gubun4' mdef='건강보험'/>",           Type:"Text",     Hidden:1,  Width:90,  Align:"Center",    ColMerge:0,   SaveName:"gubun4",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
                 {Header:"<sht:txt mid='eiEeMonV1' mdef='고용보험'/>",           Type:"Text",     Hidden:0,  Width:90,  Align:"Center",    ColMerge:0,   SaveName:"gubun5",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
                 {Header:"<sht:txt mid='gubun6' mdef='산재보험'/>",           Type:"Text",     Hidden:1,  Width:90,  Align:"Center",    ColMerge:0,   SaveName:"gubun6",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 }
            ];


		    IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(1);sheet1.SetCountPosition(4);

		    sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
	 		sheet1.SetDataLinkMouse("detail",1);

//         {Header:"<sht:txt mid='updownType' mdef='절상/사\n구분'/>",       Type:"Combo",     Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"updownType",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            var updownTypeList  = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00005"), "");
            sheet1.SetColProperty("updownType",          {ComboText:updownTypeList[0], ComboCode:updownTypeList[1]} );

//         {Header:"<sht:txt mid='danwi' mdef='단위'/>",                Type:"Combo",     Hidden:0,  Width:40,   Align:"Center",  ColMerge:0,   SaveName:"updownUnit",        KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
            var updownUnitList  = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00006"), "");
            sheet1.SetColProperty("updownUnit",          {ComboText:updownUnitList[0], ComboCode:updownUnitList[1]} );

//         {Header:"<sht:txt mid='currency' mdef='통화'/>",                Type:"Combo",     Hidden:0,  Width:40,   Align:"Center",  ColMerge:0,   SaveName:"currencyCd",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            var currencyCdList  = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S10030"), "");
            sheet1.SetColProperty("currencyCd",          {ComboText:currencyCdList[0], ComboCode:currencyCdList[1]} );

//         {Header:"<sht:txt mid='elementLinkTypeV1' mdef='항목Link유형'/>",        Type:"Combo",     Hidden:0,  Width:80,   Align:"Left",    ColMerge:0,   SaveName:"elementLinkType",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            var elementLinkTypeList  = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00003"), "");
            sheet1.SetColProperty("elementLinkType",          {ComboText:elementLinkTypeList[0], ComboCode:elementLinkTypeList[1]} );

// 			수습적용율
            var att2CmbList   = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00009"), "");
            sheet1.SetColProperty("attribute2",          {ComboText:"|"+att2CmbList[0], ComboCode:"|"+att2CmbList[1]} );

// 			// 과세여부
            var att3CmbList   = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00011"), "");
            sheet1.SetColProperty("attribute3",          {ComboText:"|"+att3CmbList[0], ComboCode:"|"+att3CmbList[1]} );

// 			// 신입/복직일할계산
            var att5CmbList   = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00013"), "");
            sheet1.SetColProperty("attribute4",          {ComboText:"|"+att5CmbList[0], ComboCode:"|"+att5CmbList[1]} );

// 			퇴직당월일할계산
            sheet1.SetColProperty("attribute5",          {ComboText:"|"+att5CmbList[0], ComboCode:"|"+att5CmbList[1]} );

// 			발령관련일할계산
            sheet1.SetColProperty("attribute6",          {ComboText:"-|YES|NO", ComboCode:"|Y|N"} );

// 			징계관련일할계산
            sheet1.SetColProperty("attribute7",          {ComboText:"-|YES|NO", ComboCode:"|Y|N"} );

//          근태관련일할계산
            sheet1.SetColProperty("attribute9",          {ComboText:"-|YES|NO", ComboCode:"|Y|N"} );
            
//          상여관련
            var payTypeList  = convCode( codeList("/CommonCode.do?cmd=getCommonCodeList","C00001"), "");
            sheet1.SetColProperty("attribute10",            {ComboText:payTypeList[0], ComboCode:payTypeList[1]} );

//          산재관련일할계산
            sheet1.SetColProperty("attribute11",          {ComboText:"-|YES|NO", ComboCode:"|Y|N"} );


		$("#searchElementType").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
		});
		$(window).smartresize(sheetResize); sheetInit();
		doAction("Search");
	});

	//Sheet Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/AllowEleMgr.do?cmd=getAllowEleMgrList", $("#sheetForm").serialize() ); break;
		case "Save":
			if(!dupChk(sheet1,"elementCd|sdate", false, true)){break;}
			IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave( "${ctx}/AllowEleMgr.do?cmd=saveAllowEleMgr", $("#sheetForm").serialize()); break;
		case "Insert":		var newRow = sheet1.DataInsert(0);
					        sheet1.SetCellValue(newRow, "elementType", "A");
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


    //  Type이 POPUP인 셀에서 팝업버튼을 눌렀을때 발생하는 이벤트
    function sheet1_OnPopupClick(Row, Col){
        // try{

			var colName = sheet1.ColSaveName(Col);
			// var args    = new Array();

          // args["elementCd"]   = sheet1.GetCellValue(Row, "resultElementCd");
          // args["elementNm"]  = sheet1.GetCellValue(Row, "resultElementNm");

			let layerId = '';
			let url = '';
			let title = '';
			if(colName === 'resultElementNm'){
				layerId = 'payElementLayer';
				url = '/PayElementPopup.do?cmd=viewPayElementLayer&authPg=${authPg}';
				title = '<tit:txt mid='payElementPop4' mdef='수당,공제 항목'/>';
			}else if(colName === 'attribute8Nm'){
				layerId = 'viewDedEleLayer';
				url = '/DedEleMgr.do?cmd=viewDedEleMgrLayer&authPg=${authPg}';
				title = '<tit:txt mid='dedEleMgrPop' mdef='연말정산 코드항목 조회'/>';
			}

			let layerModal = new window.top.document.LayerModal({
				id : layerId
				, url : url
				, parameters : {
					elementCd : sheet1.GetCellValue(Row, "resultElementCd")
					, elementNm : sheet1.GetCellValue(Row, "resultElementNm")
					, elementType :sheet1.GetCellValue(Row, "elementType")
				}
				, width : 860
				, height : 520
				, title : title
				, trigger :[
					{
						name : 'payTrigger'
						, callback : function(result){
							sheet1.SetCellValue( Row, "resultElementCd", result.resultElementCd);
							sheet1.SetCellValue( Row, "resultElementNm", result.resultElementNm);
						}
					}
					, {
						name : 'dedTrigger'
						, callback : function(result){
							sheet1.SetCellValue( Row, "attribute8", result.adjElementCd);
							sheet1.SetCellValue( Row, "attribute8Nm", result.adjElementNm);
						}
					}
				]
			});
			layerModal.show();



			<%--return;--%>



			<%--if(colName == "resultElementNm") {--%>
			<%--  if(!isPopup()) {return;}--%>
			<%--  gPRow = Row;--%>
			<%--  pGubun = "payElementPopup";--%>
			<%--  openPopup("/PayElementPopup.do?cmd=payElementPopup&authPg=${authPg}", args, "740","520");--%>
			<%--  /*--%>
			<%--  if(rv!=null){--%>
			<%--	  sheet1.SetCellValue(Row, "resultElementCd",   rv["elementCd"] );--%>
			<%--	  sheet1.SetCellValue(Row, "resultElementNm",   rv["elementNm"] );--%>
			<%--  }--%>
			<%--  */--%>
			<%--}else if(colName == "languageNm"){--%>
			<%--  lanuagePopup(Row, "sheet1", "tcpn011", "languageCd", "languageNm", "elementNm");--%>
			<%--}else if(colName == "languageNm2"){--%>
			<%--  lanuagePopup(Row, "sheet1", "tcpn011", "languageCd2", "languageNm2", "reportNm");--%>
			<%--}else if ( colName == "attribute8Nm"){--%>
			<%--  openPopup("/DedEleMgr.do?cmd=viewDedEleMgrPopup&authPg=${authPg}", args, "740","520", function(rv){--%>
			<%--	sheet1.SetCellValue( Row, "attribute8", rv["adjElementCd"])--%>
			<%--	sheet1.SetCellValue( Row, "attribute8Nm", rv["adjElementNm"])--%>
			<%--});--%>
        // }
		//
        // }catch(ex){alert("OnPopupClick Event Error : " + ex);}
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
			
			if ( sheet1.ColSaveName(Col) == "attribute8Nm" ){
				if ( sheet1.GetCellValue( Row, Col ) == "" ){
					sheet1.SetCellValue( Row, "attribute8", "");
				}
			}

		} catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

	    if(pGubun == "payElementPopup"){
	    	sheet1.SetCellValue(gPRow, "resultElementCd",   rv["elementCd"] );
	        sheet1.SetCellValue(gPRow, "resultElementNm",  rv["elementNm"] );

	    }
	}

    function sheet1_OnClick(Row, Col, Value) {
        try{

            var rv = null;
            var args    = new Array();

            args["elementType"] = sheet1.GetCellValue(Row, "elementType");
            args["elementCd"]   = sheet1.GetCellValue(Row, "elementCd");
            args["elementNm"]   = sheet1.GetCellValue(Row, "elementNm");
            args["sdate"]       = sheet1.GetCellValue(Row, "sdate");

            if(Row > 0 && sheet1.ColSaveName(Col) == "detail"){
            	if(!isPopup()) {return;}
        		gPRow = "";
        		pGubun = "payAllowanceElementPropertyPopup";
            	<%--openPopup("/PayAllowanceElementPropertyPopup.do?cmd=payAllowanceElementPropertyPopup&authPg=${authPg}", args, "1000","640");--%>
				<%--window.top.openLayer('/PayAllowanceElementPropertyPopup.do?cmd=viewPayAllowanceElementPropertyLayer&authPg=${authPg}', args, 1000, 640);--%>
				 /*
            	 if(rv!=null){
                 }
				 */
				let layerModal = new window.top.document.LayerModal({
					id : 'allowModal'
					, url : '/PayAllowanceElementPropertyPopup.do?cmd=viewPayAllowanceElementPropertyLayer&authPg=${authPg}'
					, parameters : {
						elementType : sheet1.GetCellValue(Row, "elementType")
						, elementCd : sheet1.GetCellValue(Row, "elementCd")
						, elementNm : sheet1.GetCellValue(Row, "elementNm")
						, sdate : sheet1.GetCellValue(Row, "sdate")
					}
					, width : 1200
					, height : 640
					, title : '수당, 공제 항목 조회'
					, callback : function(){
						console.log('layer modal init');
					}
				});
				layerModal.show();
            }
        }catch(ex){alert("OnClick Event Error : " + ex);}
    }

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='eleGroupMgr2' mdef='항목명'/></th>
						<td>  <input id="searchElementType" name ="searchElementType" type="text" class="text" /> </td>
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
							<li id="txt" class="txt"><tit:txt mid='allowEleMgr' mdef='지급항목관리'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction('Insert')" css="basic authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction('Copy')" 	css="basic authA" mid='110696' mdef="복사"/>
								<btn:a href="javascript:doAction('Save')" 	css="basic authA" mid='110708' mdef="저장"/>
								<btn:a href="javascript:doAction('Down2Excel')"   css="basic authR" mid='110698' mdef="다운로드"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
