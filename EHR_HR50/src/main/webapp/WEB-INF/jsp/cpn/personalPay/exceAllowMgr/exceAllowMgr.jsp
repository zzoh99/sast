<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
var mode = "";
<c:if test="${ !empty param.mode }">
	mode = "${param.mode}";
</c:if>

	$(function() {


		// Gird 1
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata1.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"급여코드",      Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"payActionCd",   KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"급여년월",      Type:"Text",      Hidden:1,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"payYm",         KeyField:0,   CalcLogic:"",   Format:"Ym",          PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:8 },
			{Header:"급여구분코드",  Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"payCd",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"급여구분",      Type:"Text",      Hidden:1,  Width:150,  Align:"Center",  ColMerge:0,   SaveName:"payNm",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"항목코드",      Type:"Text",      Hidden:0,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"elementCd",     KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:20 },
			{Header:"항목명",        Type:"Popup",     Hidden:0,  Width:230,  Align:"Center",  ColMerge:0,   SaveName:"elementNm",     KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:50 },
			{Header:"급여일자",      Type:"Text",      Hidden:0,  Width:150,  Align:"Left",    ColMerge:0,   SaveName:"payActionNm",   KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0 },
			{Header:"마감여부",      Type:"Text",      Hidden:1,  Width:150,  Align:"Center",  ColMerge:0,   SaveName:"closeYn",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var userCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","TST01"), "전체");
		sheet1.SetColProperty("col5", 			{ComboText:"사용|사용안함", ComboCode:"Y|N"} );
		sheet1.SetColProperty("col6", 			{ComboText:userCd[0], ComboCode:userCd[1]} );

		// 저장 시 분할 저장 설정
		IBS_setChunkedOnSave("sheet1", {
			chunkSize : 50
		});

		// Grid 2
		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata2.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"급여계산코드",	Type:"Text",		Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"payActionCd"  ,  KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"항목코드",	Type:"Combo",		Hidden:0,  Width:150,    Align:"Center",  ColMerge:0,   SaveName:"elementCd",      KeyField:1,   CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"성명",		Type:"Text",		Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"name",           KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"사번",		Type:"Text",		Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"sabun",          KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
			{Header:"금액",		Type:"Int",			Hidden:0,  Width:120,  Align:"Right",   ColMerge:0,   SaveName:"paymentMon",     KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:22 },
			{Header:"비고",		Type:"Text",		Hidden:0,  Width:150,  Align:"Center",  ColMerge:0,   SaveName:"note",           KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"비고공지여부",	Type:"CheckBox",	Hidden:0,  Width:80 ,  Align:"Center", 	ColMerge:0,	  SaveName:"noteNotifyYn",	 KeyField:0,   CalcLogic:"",   Format:"",			 PointCount:0,	 UpdateEdit:1, InsertEdit:1, EditLen:50,TrueValue:"Y", FalseValue:"N"},
			{Header:"마감여부",	Type:"Text",		Hidden:1,  Width:150,  Align:"Center",  ColMerge:0,   SaveName:"closeYn",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }  ];
		IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		$(window).smartresize(sheetResize); sheetInit();

		// 저장 시 분할 저장 설정
		IBS_setChunkedOnSave("sheet2", {
			chunkSize : 50
		});
		
		var elementCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getElementCdList",false).codeList, "");	//일반테이블
		sheet2.SetColProperty("elementCd", 			{ComboText:"|"+elementCd[0], ComboCode:"|"+elementCd[1]} );

        $("#searchElementNm, #searchName").bind("keyup",function(event){
            if( event.keyCode == 13){ doSearch(); $(this).focus(); }
        });

		var runType = "00001,00002,00003,R0001,R0002,R0003,J0001,ETC,RETRO";
		var data = ajaxCall("${ctx}/ExceAllowMgr.do?cmd=getExceAllowMgrMap","searchRunType="+runType + "&mode=" + mode, false);

		if(data != null && data.DATA != null) {
        	$("#searchPayActionCdHidden").val(data.DATA.payActionCd);
        	$("#searchPayActionNm").val(data.DATA.payActionNm);

        	doAction1("Search");
		}

		//setSheetAutocompleteEmp( "sheet2", "name");

		//Autocomplete	
		$(sheet2).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue) {
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet2.SetCellValue(gPRow,"name", rv["name"]);
						sheet2.SetCellValue(gPRow,"sabun", rv["sabun"]);
					}
				}
			]
		});
	});


	function doSearch(){


		if($('#searchPayActionNm').val() == ""){
			alert("급여 일자를 선택 하여 주세요.");
		}else{

			if($("#searchName").val() != ""){
				doAction2('Search');
			}else{
				doAction1('Search');
			}
		}
	}


	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/ExceAllowMgr.do?cmd=getExceAllowMgrFirstList", $("#sheetForm").serialize() ); sheet2.RemoveAll();
			break;
		case "Save":
			if(!dupChk(sheet1,"payActionCd|elementCd", false, true)){break;}
			IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave( "${ctx}/ExceAllowMgr.do?cmd=saveExceAllowMgrFirst", $("#sheetForm").serialize()); break;
		case "Insert":
// 			if(sheet1.RowCount()==0){
// 				alert("조회를 먼저 하세요");
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

			$("#searchPayActionCd2").val(sheet1.GetCellValue( sheet1.GetSelectRow(), "payActionCd"));
			$("#searchElementCd2").val(sheet1.GetCellValue( sheet1.GetSelectRow(), "elementCd"));
			
			sheet2.DoSearch( "${ctx}/ExceAllowMgr.do?cmd=getExceAllowMgrSecondList", $("#sheetForm").serialize() ); break;
		case "Save":
			for(var Row = 1; Row <= sheet2.RowCount(); Row++){
				sheet2.SetCellValue(Row, "payActionCd", sheet1.GetCellValue( sheet1.GetSelectRow(), "payActionCd"));
				sheet2.SetCellValue(Row, "elementCd", sheet1.GetCellValue( sheet1.GetSelectRow(), "elementCd"));
			}
			if(!dupChk(sheet2,"payActionCd|elementCd|sabun", false, true)){break;}
			IBS_SaveName(document.sheetForm,sheet2);
			sheet2.DoSave( "${ctx}/ExceAllowMgr.do?cmd=saveExceAllowMgrSecond", $("#sheetForm").serialize()); break;
		case "Insert":
			if(sheet1.RowCount()==0){
				alert("Master 데이터를 선택 하세요.");
				return;
			}else{
		        var newRow = sheet2.DataInsert(0);
				sheet2.SetCellValue(newRow, "payActionCd", sheet1.GetCellValue( sheet1.GetSelectRow(), "payActionCd"));
				sheet2.SetCellValue(newRow, "elementCd", sheet1.GetCellValue( sheet1.GetSelectRow(), "elementCd"));
			}
			break;
		case "Copy":		sheet2.DataCopy(); break;
		case "Clear":		sheet2.RemoveAll(); break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet2.Down2Excel(param); break;
		case "LoadExcel":
			// 업로드
			if(sheet1.RowCount()==0){
        		alert("Master 데이터를 선택 하세요.");
        		return;
        	}
			var params = {};
			sheet2.LoadExcel(params);
			break;
		case "DownTemplate":
			// 양식다운로드
			sheet2.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"sabun|name|paymentMon|note"});
			break;
		}
	}

	function sheet2_OnLoadExcel(){
		if(sheet1.RowCount()==0){
			alert("Master 데이터를 선택 하세요.");
			sheet2.RemoveAll();
			return;
		}else{

			for(var i = 1; i <= sheet2.RowCount(); i++){
				sheet2.SetCellValue(i, "payActionCd", sheet1.GetCellValue( sheet1.GetSelectRow(), "payActionCd"));
				sheet2.SetCellValue(i, "elementCd", sheet1.GetCellValue( sheet1.GetSelectRow(), "elementCd"));
			}

		}
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
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doAction2('Search');
			sheet1.SetCellValue(sheet1.GetSelectRow(),"sStatus","R");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
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

	function sheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
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
			  let layerModal = new window.top.document.LayerModal({
				  id : 'payElementLayer'
				  , url : '/PayElementPopup.do?cmd=viewPayElementLayer&authPg=${authPg}'
				  , parameters : {
					  elementCd : sheet1.GetCellValue(Row, "elementCd")
					  , elementNm : sheet1.GetCellValue(Row, "elementNm")
				  }
				  , width : 860
				  , height : 520
				  , title : '수당,공제 항목'
				  , trigger :[
					  {
						  name : 'payTrigger'
						  , callback : function(result){
							  sheet1.SetCellValue(Row, "elementCd", result.resultElementCd);
							  sheet1.SetCellValue(Row, "elementNm", result.resultElementNm);
						  }
					  }
				  ]
			  });
			  layerModal.show();

          	<%--if(!isPopup()) {return;}--%>
        	<%--gPRow = Row;--%>
        	<%--pGubun = "payElementPopup2";--%>
            <%--  var rv = openPopup("/PayElementPopup.do?cmd=payElementPopup&authPg=${authPg}", args, "840","520");--%>
              /*
              if(rv!=null){
                  sheet1.SetCellValue(Row, "elementCd",   rv["elementCd"] );
                  sheet1.SetCellValue(Row, "elementNm",  rv["elementNm"] );
              }
              */
          }

        }catch(ex){alert("OnPopupClick Event Error : " + ex);}
    }


    //  Type이 POPUP인 셀에서 팝업버튼을 눌렀을때 발생하는 이벤트
    function sheet2_OnPopupClick(Row, Col){
        try{

          var colName = sheet2.ColSaveName(Col);
          var args    = new Array();

          args["name"]   = sheet2.GetCellValue(Row, "name");
          args["sabun"]  = sheet2.GetCellValue(Row, "sabun");

          var rv = null;

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
							  sheet2.SetCellValue(gPRow, "name", result.name);
							  sheet2.SetCellValue(gPRow, "sabun", result.sabun);
						  }
					  }
				  ]
			  });
			  layerModal.show();


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

        }catch(ex){alert("OnPopupClick Event Error : " + ex);}
    }

    //  급여일자 조회 팝업
    function openPayDayPopup(){
		let parameters = {
			runType : '00001,00002,00003,R0001,R0002,R0003,J0001,ETC,RETRO'
		};
		if(mode == "retire") parameters.mode = mode;

		let layerModal = new window.top.document.LayerModal({
			id : 'payDayLayer'
			, url : '/PayDayPopup.do?cmd=viewPayDayLayer&authPg=${authPg}'
			, parameters : parameters
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
						doAction1("Search");
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
        <%--	args["runType"] = "00001,00002,00003,R0001,R0002,R0003,J0001,ETC,RETRO";--%>
        <%--	--%>
        <%--	if(mode == "retire") {--%>
        <%--		args["mode"] = mode;--%>
        <%--	}--%>

        <%--	openPopup("/PayDayPopup.do?cmd=payDayPopup&authPg=${authPg}", args, "840","520");--%>

        <%--}catch(ex){alert("Open Popup Event Error : " + ex);}--%>
    }

    //  항목명 팝업
    function openPayElementPopup(){
		let layerModal = new window.top.document.LayerModal({
			id : 'payElementLayer'
			, url : '/PayElementPopup.do?cmd=viewPayElementLayer&authPg=${authPg}'
			, parameters : {}
			, width : 940
			, height : 520
			, title : '<tit:txt mid='payElementPop4' mdef='수당,공제 항목'/>'
			, trigger :[
				{
					name : 'payTrigger'
					, callback : function(result){
						$("#searchElementCdHidden").val(result.resultElementCd);
						$("#searchElementNm ").val(result.resultElementNm);
						$("#searchName").val("");
						doAction1("Search");
					}
				}
			]
		});
		layerModal.show();


        <%--try{--%>
        <%--	if(!isPopup()) {return;}--%>
        <%--	gPRow = "";--%>
        <%--	pGubun = "payElementPopup";--%>
        <%--	var args    = new Array();--%>
        <%--	var rv = openPopup("/PayElementPopup.do?cmd=payElementPopup&authPg=${authPg}", args, "940","520");--%>
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
        	doAction1("Search");
	    }else if(pGubun == "payElementPopup"){
        	$("#searchElementCdHidden").val(rv["elementCd"]);
        	$("#searchElementNm ").val(rv["elementNm"]);
        	$("#searchName").val("");
        	doAction1("Search");
	    }else if(pGubun == "employeePopup"){

            sheet2.SetCellValue(gPRow, "name",   rv["name"] );
            sheet2.SetCellValue(gPRow, "sabun",  rv["sabun"] );
	    }
	    else if(pGubun == "payElementPopup2"){
            sheet1.SetCellValue(gPRow, "elementCd",   rv["elementCd"] );
            sheet1.SetCellValue(gPRow, "elementNm",  rv["elementNm"] );
	    }
	    
	    if(pGubun == "sheetAutocompleteEmp"){
            sheet2.SetCellValue(gPRow, "name",   rv["name"] );
            sheet2.SetCellValue(gPRow, "sabun",  rv["sabun"] );
	    }
	}



</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
	<input type="hidden" id="searchPayActionCdHidden" name="searchPayActionCdHidden" value="" />
	<input type="hidden" id="searchElementNmHidden" name="searchElementCdHidden" value="" />
	<input type="hidden" id="searchPayActionCd2" name="searchPayActionCd2" value="" />
	<input type="hidden" id="searchElementCd2" name="searchElementCd2" value="" />
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th>급여일자</th>
						<td>
							<input id="searchPayActionNm" name="searchPayActionNm" type="text" class="text" style="width:160px;" readOnly />
							<a onclick="javascript:openPayDayPopup()" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
<!-- 							<a onclick="$('#searchPayActionCdHidden,#searchPayActionNm').val('');" href="#" class="button6"><img src="/common/${theme}/images/icon_undo.gif"/></a> -->
						</td>
						<th>항목명</th>
						<td>
							<input id="searchElementNm" name="searchElementNm" type="text" class="text" readOnly style="width:160px;" />
							<a onclick="javascript:openPayElementPopup()" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
							<a onclick="$('#searchElementCdHidden,#searchElementNm').val('');" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
						</td>
						<th>성명</th>
						<td>
							<input id="searchName" name="searchName" type="text" class="text" style="width:100px;"/>
						</td>
						<td> <a href="javascript:doSearch()" id="btnSearch" class="button">조회</a> </td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<colgroup>
		<col width="40%" />
		<col width="60%" />
	</colgroup>
	<tr>
		<td class="sheet_left">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt">예외관리 Master</li>
					<li class="btn">
						<a href="javascript:doAction1('Insert')" class="basic authA">입력</a>
						<a href="javascript:doAction1('Copy')" 	class="basic authA">복사</a>
						<a href="javascript:doAction1('Save')" 	class="basic authA">저장</a>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet1", "30%", "100%"); </script>
		</td>
		<td class="sheet_right">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt">예외관리 Detail</li>
					<li class="btn">
						<a href="javascript:doAction2('DownTemplate')" class="basic authA">양식다운로드</a>
						<a href="javascript:doAction2('Insert')" class="basic authA">입력</a>
						<a href="javascript:doAction2('Copy')" 	class="basic authA">복사</a>
						<a href="javascript:doAction2('Save')" 	class="basic authA">저장</a>
						<a href="javascript:doAction2('LoadExcel')" class="basic authA">업로드</a>
						<a href="javascript:doAction2('Down2Excel')" class="basic authR">다운로드</a>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet2", "70%", "100%"); </script>
		</td>
	</tr>
	</table>

</div>
</body>
</html>