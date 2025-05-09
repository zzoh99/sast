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

		$("input[type='text'], textarea").keydown(function(event){
			if(event.keyCode == 27){
				return false;
			}
		});


		// Gird 1
/* 		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='payActionCdV4' mdef='급여코드'/>",      Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"payActionCd",   KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='payYmV2' mdef='급여년월'/>",      Type:"Text",      Hidden:1,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"payYm",         KeyField:0,   CalcLogic:"",   Format:"Ym",          PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:8 },
			{Header:"<sht:txt mid='payCdV5' mdef='급여구분코드'/>",  Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"payCd",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='payCd' mdef='급여구분'/>",      Type:"Text",      Hidden:1,  Width:150,  Align:"Center",  ColMerge:0,   SaveName:"payNm",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='benefitElemCd' mdef='항목코드'/>",      Type:"Text",      Hidden:0,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"elementCd",     KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:20 },
			{Header:"<sht:txt mid='benefitElemNm' mdef='항목명'/>",        Type:"Popup",     Hidden:0,  Width:230,  Align:"Center",  ColMerge:0,   SaveName:"elementNm",     KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:50 },
			{Header:"<sht:txt mid='payActionCd' mdef='급여일자'/>",      Type:"Text",      Hidden:0,  Width:150,  Align:"Left",    ColMerge:0,   SaveName:"payActionNm",   KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
			{Header:"<sht:txt mid='closeYnV1' mdef='마감여부'/>",      Type:"Text",      Hidden:1,  Width:150,  Align:"Center",  ColMerge:0,   SaveName:"closeYn",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var userCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","TST01"), "<tit:txt mid='103895' mdef='전체'/>");
		sheet1.SetColProperty("col5", 			{ComboText:"사용|사용안함", ComboCode:"Y|N"} );
		sheet1.SetColProperty("col6", 			{ComboText:userCd[0], ComboCode:userCd[1]} );

 */

		// Grid 2
		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata2.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='payActionCdV1' mdef='급여계산코드'/>", Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"payActionCd"  ,  KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='benefitElemCd' mdef='항목코드'/>",      Type:"Text",      Hidden:0,  Width:90,    Align:"Center",  ColMerge:0,   SaveName:"elementCd",     KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
			{Header:"<sht:txt mid='benefitElemNm' mdef='항목명'/>",        Type:"Popup",     Hidden:0,  Width:150,  Align:"Center",  ColMerge:0,   SaveName:"elementNm",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:50 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",         Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"sabun",          KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",         Type:"Text", Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"name",           KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",       Type:"Text", Hidden:Number("${aliasHdn}"),  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"alias",           KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",       Type:"Text", Hidden:Number("${jgHdn}"),  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"jikgubNm",           KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",       Type:"Text", Hidden:Number("${jwHdn}"),  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"jikweeNm",           KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='basicMon' mdef='금액'/>",         Type:"Int",       Hidden:0,  Width:120,  Align:"Right",   ColMerge:0,   SaveName:"paymentMon",     KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:22 },
			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",         Type:"Text",      Hidden:0,  Width:230,  Align:"Left",  ColMerge:0,   SaveName:"note",           KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='closeYnV1' mdef='마감여부'/>",     Type:"Text",      Hidden:1,  Width:150,  Align:"Center",  ColMerge:0,   SaveName:"closeYn",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }  ];
		IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		$(window).smartresize(sheetResize); sheetInit();

		IBS_setChunkedOnSave("sheet2", {chunkSize : 25});
		
		var elementCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getElementCdList",false).codeList, "");	//일반테이블
		sheet2.SetColProperty("elementCd", 			{ComboText:"|"+elementCd[0], ComboCode:"|"+elementCd[1]} );

        $("#searchElementNm, #searchName").bind("keyup",function(event){
            if( event.keyCode == 13){ doSearch(); $(this).focus(); }
        });

		// 이름 입력 시 자동완성
		$(sheet2).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet2.SetCellValue(gPRow, "name", rv["name"]);
						sheet2.SetCellValue(gPRow, "sabun", rv["sabun"]);
					}
				}
			]
		});	
        
        var runType = "00001,00002,00003,R0001,R0002,R0003,J0001,ETC";
		var data = ajaxCall("${ctx}/ExceAllowNewMgr.do?cmd=getExceAllowNewMgrMap","searchRunType="+runType,false);

		if(data != null && data.Map != null) {
        	$("#searchPayActionCdHidden").val(data.Map.payActionCd);
        	$("#searchPayActionNm").val(data.Map.payActionNm);

        	doAction2("Search");
		}
	});


	function doSearch(){


		if($('#searchPayActionNm').val() == ""){
			alert("<msg:txt mid='110312' mdef='급여 일자를 선택 하여 주세요.'/>");
		}else{

			if($("#searchName").val() != ""){
				doAction2('Search');
			}else{
				doAction2('Search');
			}
		}
	}


	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/ExceAllowNewMgr.do?cmd=getExceAllowNewMgrFirstList", $("#sheetForm").serialize() ); sheet2.RemoveAll();
			break;
		case "Save":
			if(!dupChk(sheet1,"payActionCd|elementCd", false, true)){break;}
			IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave( "${ctx}/ExceAllowNewMgr.do?cmd=saveExceAllowNewMgrFirst", $("#sheetForm").serialize()); break;
		case "Insert":
// 			if(sheet1.RowCount()==0){
// 				alert("<msg:txt mid='110313' mdef='조회를 먼저 하세요'/>");
// 				return;
// 			}else{
				var newRow = sheet1.DataInsert(0);
				sheet1.SetCellValue(newRow, "payActionCd", $("#searchPayActionCdHidden").val());
				sheet1.SetCellValue(newRow, "payActionNm", $("#searchPayActionNm").val());
// 			}
			break;
		case "Copy":		sheet1.DataCopy(); break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":	sheet1.Down2Excel(); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}
	//Example Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":

/* 			var param = "searchPayActionCdHidden="+sheet1.GetCellValue( sheet1.GetSelectRow(), "payActionCd");
			param += "&searchElementCdHidden="+sheet1.GetCellValue( sheet1.GetSelectRow(), "elementCd"); */
			var param = "searchPayActionCdHidden="+$("#searchPayActionCdHidden").val();
			param += "&searchElementCdHidden="+$("#searchElementCdHidden").val();
			param += "&searchName="+$("#searchName").val();

			sheet2.DoSearch( "${ctx}/ExceAllowNewMgr.do?cmd=getExceAllowNewMgrSecondList", param); break;
		case "Save":
			/* for(var Row = 1; Row <= sheet2.RowCount(); Row++){
				sheet2.SetCellValue(Row, "payActionCd", sheet1.GetCellValue( sheet1.GetSelectRow(), "payActionCd"));
				sheet2.SetCellValue(Row, "elementCd", sheet1.GetCellValue( sheet1.GetSelectRow(), "elementCd"));
			} */
			if(!dupChk(sheet2,"payActionCd|elementCd|sabun", false, true)){break;}
			IBS_SaveName(document.sheetForm,sheet2);
			sheet2.DoSave( "${ctx}/ExceAllowNewMgr.do?cmd=saveExceAllowNewMgrSecond", $("#sheetForm").serialize()); break;
		case "Insert":
/* 			if(sheet1.RowCount()==0){
				alert("<msg:txt mid='alertMasterSelect' mdef='Master 데이터를 선택 하세요.'/>");
				return;
			}else{ */
		        var newRow = sheet2.DataInsert(0);
				sheet2.SetCellValue(newRow, "payActionCd", $("#searchPayActionCdHidden").val() );
/* 				sheet2.SetCellValue(newRow, "payActionCd", sheet1.GetCellValue( sheet1.GetSelectRow(), "payActionCd"));
				sheet2.SetCellValue(newRow, "elementCd", sheet1.GetCellValue( sheet1.GetSelectRow(), "elementCd")); */
			/* } */
			break;
		case "Copy":		sheet2.DataCopy(); break;
		case "Clear":		sheet2.RemoveAll(); break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet2.Down2Excel(param); break;
		case "LoadExcel":
			// 업로드
			if($('#searchPayActionNm').val() == ""){
				alert("<msg:txt mid='110312' mdef='급여 일자를 선택 하여 주세요.'/>");
			}
			var params = {};
			sheet2.LoadExcel(params);
			break;
		case "DownTemplate":
			// 양식다운로드
			sheet2.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"elementCd|sabun|paymentMon|note"});
			break;
		}
	}

	function sheet2_OnLoadExcel(){
/* 		if(sheet1.RowCount()==0){
			alert("<msg:txt mid='alertMasterSelect' mdef='Master 데이터를 선택 하세요.'/>");
			sheet2.RemoveAll();
			return;
		}else{
 */
			for(var i = 1; i <= sheet2.RowCount(); i++){
				sheet2.SetCellValue(i, "payActionCd", $("#searchPayActionCdHidden").val());
/* 				sheet2.SetCellValue(i, "payActionCd", sheet1.GetCellValue( sheet1.GetSelectRow(), "payActionCd"));
				sheet2.SetCellValue(i, "elementCd", sheet1.GetCellValue( sheet1.GetSelectRow(), "elementCd")); */
			}

	/* 	} */
	}


	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize();

			//if(sheet1.RowCount()!=0){
				$("#searchElementNmHidden").val(sheet1.GetCellValue(sheet1.GetSelectRow(), "elementCd"));
				doAction2('Search');
			//}

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
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {

		$("#searchElementNmHidden").val(sheet1.GetCellValue(Row, "elementCd"));
		doAction2('Search');

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
				//doAction1("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet2.GetCellValue(Row, "sStatus") == "I") {
				sheet2.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	function sheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	}

    //  Type이 POPUP인 셀에서 팝업버튼을 눌렀을때 발생하는 이벤트
    function sheet1_OnPopupClick(Row, Col){
        try{
			var colName = sheet1.ColSaveName(Col);
			if(colName !== 'elementNm') return;

			let layerModal = new window.top.document.LayerModal({
				id : 'payElementLayer'
				, url : '/PayElementPopup.do?cmd=viewPayElementLayer&authPg=R'
				, parameters : {
					elementCd : sheet1.GetCellValue(Row, "elementCd")
					, elementNm : sheet1.GetCellValue(Row, "elementNm")
				}
				, width : 860
				, height : 520
				, title : '<tit:txt mid='payElementPop4' mdef='수당,공제 항목'/>'
				, trigger :[
					{
						name : 'payTrigger'
						, callback : function(result){
							sheet2.SetCellValue(Row, "elementCd",   result.resultElementCd);
							sheet2.SetCellValue(Row, "elementNm",   result.resultElementNm);
						}
					}
				]
			});
			layerModal.show();


          <%--var colName = sheet1.ColSaveName(Col);--%>
          <%--var args    = new Array();--%>

          <%--args["elementCd"]   = sheet1.GetCellValue(Row, "elementCd");--%>
          <%--args["elementNm"]  = sheet1.GetCellValue(Row, "elementNm");--%>

          <%--var rv = null;--%>

          <%--if(colName == "elementNm") {--%>
          <%--	if(!isPopup()) {return;}--%>
        	<%--gPRow = Row;--%>
        	<%--pGubun = "payElementPopup2";--%>
          <%--    var rv = openPopup("/PayElementPopup.do?cmd=payElementPopup&authPg=${authPg}", args, "740","520");--%>
          <%--    /*--%>
          <%--    if(rv!=null){--%>
          <%--        sheet1.SetCellValue(Row, "elementCd",   rv["elementCd"] );--%>
          <%--        sheet1.SetCellValue(Row, "elementNm",  rv["elementNm"] );--%>
          <%--    }--%>
          <%--    */--%>
          <%--}--%>

        }catch(ex){alert("OnPopupClick Event Error : " + ex);}
    }


    //  Type이 POPUP인 셀에서 팝업버튼을 눌렀을때 발생하는 이벤트
    function sheet2_OnPopupClick(Row, Col){
        try{

          var colName = sheet2.ColSaveName(Col);
          var args    = new Array();



          if(colName == "name") {

			  let layerModal = new window.top.document.LayerModal({
				  id : 'employeeLayer'
				  , url : '/Popup.do?cmd=viewEmployeeLayer&authPg=${authPg}'
				  , parameters : {
					  name : sheet2.GetCellValue(Row, "name")
					  , sabun : sheet2.GetCellValue(Row, "sabun")
				  }
				  , width : 840
				  , height : 520
				  , title : '사원조회'
				  , trigger :[
					  {
						  name : 'employeeTrigger'
						  , callback : function(result){
							  sheet2.SetCellValue(gPRow, "name",   result.name );
							  sheet2.SetCellValue(gPRow, "alias",   result.alias );
							  sheet2.SetCellValue(gPRow, "jikgubNm",   result.jikgubNm );
							  sheet2.SetCellValue(gPRow, "jikweeNm",   result.jikweeNm );
							  sheet2.SetCellValue(gPRow, "sabun",  result.sabun );
						  }
					  }
				  ]
			  });
			  layerModal.show();


            <%--  args["name"]   = sheet2.GetCellValue(Row, "name");--%>
            <%--  args["sabun"]  = sheet2.GetCellValue(Row, "sabun");--%>

            <%--  var rv = null;--%>
          	<%--if(!isPopup()) {return;}--%>
        	<%--gPRow = Row;--%>
        	<%--pGubun = "employeePopup";--%>
            <%--  var rv = openPopup("/Popup.do?cmd=employeePopup&authPg=${authPg}", args, "840","520");--%>
              /*
              if(rv!=null){
                  sheet2.SetCellValue(Row, "name",   rv["name"] );
                  sheet2.SetCellValue(Row, "sabun",  rv["sabun"] );

              }
              */
          }

          if(colName == "elementNm") {
			  let layerModal = new window.top.document.LayerModal({
				  id : 'payElementLayer'
				  , url : '/PayElementPopup.do?cmd=viewPayElementLayer&authPg=R'
				  , parameters : {
					  elementCd : sheet2.GetCellValue(Row, "elementCd")
					  , elementNm : sheet2.GetCellValue(Row, "elementNm")
				  }
				  , width : 860
				  , height : 520
				  , title : '<tit:txt mid='payElementPop4' mdef='수당,공제 항목'/>'
				  , trigger :[
					  {
						  name : 'payTrigger'
						  , callback : function(result){
							  sheet2.SetCellValue(Row, "elementCd",   result.resultElementCd);
							  sheet2.SetCellValue(Row, "elementNm",   result.resultElementNm);
						  }
					  }
				  ]
			  });
			  layerModal.show();


            <%--  args["elementCd"]   = sheet2.GetCellValue(Row, "elementCd");--%>
            <%--  args["elementNm"]  = sheet2.GetCellValue(Row, "elementNm");--%>

            <%--  var rv = null;--%>

          	<%--if(!isPopup()) {return;}--%>
        	<%--gPRow = Row;--%>
        	<%--pGubun = "payElementPopup2";--%>
            <%--  var rv = openPopup("/PayElementPopup.do?cmd=payElementPopup&authPg=${authPg}", args, "740","520");--%>
              /*
              if(rv!=null){
                  sheet1.SetCellValue(Row, "elementCd",   rv["elementCd"] );
                  sheet1.SetCellValue(Row, "elementNm",  rv["elementNm"] );
              }
              */
          }

        }catch(ex){alert("OnPopupClick Event Error : " + ex);}
    }

    //  급여일자 조회 팝업
    function openPayDayPopup(){
		let layerModal = new window.top.document.LayerModal({
			id : 'payDayLayer'
			, url : '/PayDayPopup.do?cmd=viewPayDayLayer&authPg=${authPg}'
			, parameters : {
				runType : '00001,00002,00003,R0001,R0002,R0003,J0001,ETC'
			}
			, width : 840
			, height : 520
			, title : '<tit:txt mid='payDayPop' mdef='급여일자 조회'/>'
			, trigger :[
				{
					name : 'payDayTrigger'
					, callback : function(result){
						$("#searchPayActionCdHidden").val(result.payActionCd);
						$("#searchPayActionNm").val(result.payActionNm);
						$("#searchName").val("");
						doAction2("Search");
					}
				}
			]
		});
		layerModal.show();

        <%--try{--%>

        <%--	if(!isPopup()) {return;}--%>
        <%--	gPRow = "";--%>
        <%--	pGubun = "payDayPopup";--%>
        <%--	var args    = new Array();--%>
        <%--	args["runType"] = "00001,00002,00003,R0001,R0002,R0003,J0001,ETC";--%>
        <%--	openPopup("/PayDayPopup.do?cmd=payDayPopup&authPg=${authPg}", args, "840","520");--%>

        <%--}catch(ex){alert("Open Popup Event Error : " + ex);}--%>
    }

    //  항목명 팝업
    function openPayElementPopup(){
		let layerModal = new window.top.document.LayerModal({
			id : 'payElementLayer'
			, url : '/PayElementPopup.do?cmd=viewPayElementLayer&authPg=R'
			, parameters : {}
			, width : 860
			, height : 520
			, title : '<tit:txt mid='payElementPop4' mdef='수당,공제 항목'/>'
			, trigger :[
				{
					name : 'payTrigger'
					, callback : function(result){
						$("#searchElementCdHidden").val(result.resultElementCd);
						$("#searchElementNm ").val(result.resultElementNm);
						$("#searchName").val("");
						doAction2("Search");
					}
				}
			]
		});
		layerModal.show();

        <%--try{--%>
		<%--	--%>
        <%--	if(!isPopup()) {return;}--%>
        <%--	gPRow = "";--%>
        <%--	pGubun = "payElementPopup";--%>
        <%--	var args    = new Array();--%>
        <%--	var rv = openPopup("/PayElementPopup.do?cmd=payElementPopup&authPg=${authPg}", args, "740","520");--%>
        <%--    /*--%>
        <%--	if(rv!=null){--%>

        <%--    	$("#searchElementCdHidden").val(rv["elementCd"]);--%>
        <%--    	$("#searchElementNm ").val(rv["elementNm"]);--%>
        <%--    	$("#searchName").val("");--%>

        <%--    }--%>
        <%--    */--%>
        <%--}catch(ex){alert("Open Popup Event Error : " + ex);}--%>
    }

	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

	    if(pGubun == "payDayPopup"){
        	$("#searchPayActionCdHidden").val(rv["payActionCd"]);
        	$("#searchPayActionNm").val(rv["payActionNm"]);
        	$("#searchName").val("");
        	doAction2("Search");
	    }else if(pGubun == "payElementPopup"){
        	$("#searchElementCdHidden").val(rv["elementCd"]);
        	$("#searchElementNm ").val(rv["elementNm"]);
        	$("#searchName").val("");
        	doAction2("Search");
	    }else if(pGubun == "employeePopup"){

            sheet2.SetCellValue(gPRow, "name",   rv["name"] );
            sheet2.SetCellValue(gPRow, "alias",   rv["alias"] );
            sheet2.SetCellValue(gPRow, "jikgubNm",   rv["jikgubNm"] );
            sheet2.SetCellValue(gPRow, "jikweeNm",   rv["jikweeNm"] );
            sheet2.SetCellValue(gPRow, "sabun",  rv["sabun"] );
	    }
	    else if(pGubun == "payElementPopup2"){
            sheet2.SetCellValue(gPRow, "elementCd",   rv["elementCd"] );
            sheet2.SetCellValue(gPRow, "elementNm",  rv["elementNm"] );
	    }
	}



</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
	<input type="hidden" id="searchPayActionCdHidden" name="searchPayActionCdHidden" value="" />
	<input type="hidden" id="searchElementCdHidden" name="searchElementCdHidden" value="" />
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='104477' mdef='급여일자'/></th>
						<td>
							<input id="searchPayActionNm" name="searchPayActionNm" type="text" class="text" style="width:160px;" readOnly />
							<a onclick="javascript:openPayDayPopup()" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
<!-- 							<a onclick="$('#searchPayActionCdHidden,#searchPayActionNm').val('');" class="button6"><img src="/common/${theme}/images/icon_undo.gif"/></a> -->
						</td>
						<th><tit:txt mid='eleGroupMgr2' mdef='항목명'/></th>
						<td>
							<input id="searchElementNm" name="searchElementNm" type="text" class="text" readOnly style="width:160px;" />
							<a onclick="javascript:openPayElementPopup()" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
							<a onclick="$('#searchElementCdHidden,#searchElementNm').val('');" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
						</td>
						<th><tit:txt mid='103880' mdef='성명'/></th>
						<td>
							<input id="searchName" name="searchName" type="text" class="text" style="width:100px;"/>
						</td>
						<td> <btn:a href="javascript:doSearch()" id="btnSearch" css="button" mid='110697' mdef="조회"/> </td>
					</tr>
				</table>
			</div>
		</div>
	</form>

	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<tr>
<!-- 		<td class="sheet_left">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='execAllowMgr1' mdef='예외관리 Master'/></li>
					<li class="btn">
						<btn:a href="javascript:doAction1('Insert')" css="basic authA" mid='110700' mdef="입력"/>
						<btn:a href="javascript:doAction1('Copy')" 	css="basic authA" mid='110696' mdef="복사"/>
						<btn:a href="javascript:doAction1('Save')" 	css="basic authA" mid='110708' mdef="저장"/>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet1", "30%", "100%", "${ssnLocaleCd}"); </script>
		</td> -->
		<!-- <td class="sheet_right"> -->
		<td>
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='113493' mdef='예외관리'/></li>
					<li class="btn">
						<btn:a href="javascript:doAction2('DownTemplate')" css="basic authA" mid='110702' mdef="양식다운로드"/>
						<btn:a href="javascript:doAction2('Insert')" css="basic authA" mid='110700' mdef="입력"/>
						<btn:a href="javascript:doAction2('Copy')" 	css="basic authA" mid='110696' mdef="복사"/>
						<btn:a href="javascript:doAction2('Save')" 	css="basic authA" mid='110708' mdef="저장"/>
						<btn:a href="javascript:doAction2('LoadExcel')" css="basic authA" mid='110703' mdef="업로드"/>
						<a href="javascript:doAction2('Down2Excel')" class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet2", "70%", "100%", "${ssnLocaleCd}"); </script>
		</td>
	</tr>
	</table>

</div>
</body>
</html>
