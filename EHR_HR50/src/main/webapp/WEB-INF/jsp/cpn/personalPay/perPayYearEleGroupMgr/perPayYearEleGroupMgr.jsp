<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<title>항목그룹관리</title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";

// 1번 그리드에서 선택된 값
var gridFirstOnClickElementSetCd = "";

	$(function() {
		// 1번 그리드
		var initdata0 = {};
		initdata0.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata0.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata0.Cols = [
                {Header:"No",				Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
                {Header:"삭제",				Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),  Width:"${sDelWdt}", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
                {Header:"결과",				Type:"${sRstTy}",   Hidden:Number("${sRstHdn}"),  Width:"${sRstWdt}", Align:"Center", ColMerge:0,   SaveName:"sResult" , Sort:0},
                {Header:"상태",				Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),  Width:"${sSttWdt}", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
				{Header:"연봉그룹\n코드",	Type:"Text",      Hidden:0,  Width:70,   Align:"Left",    ColMerge:0,   SaveName:"payGroupCd",  KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
				{Header:"연봉그룹명",		Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"payGroupNm",  KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:50 },
				{Header:"설명",				Type:"Text",      Hidden:0,  Width:190,  Align:"Left",    ColMerge:0,   SaveName:"description",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
				{Header:"순서",  			Type:"Float",     Hidden:0,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"seq",           KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 }
			];
		IBS_InitSheet(sheet1, initdata0);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		$("#searchPayGroupNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doActionFirst("Search"); $(this).focus(); }
		});


		// 2번 그리드
        var initdata1 = {};
        initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
        initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata1.Cols = [
            {Header:"No",        Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
            {Header:"삭제",      Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),  Width:"${sDelWdt}", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
            {Header:"결과",      Type:"${sRstTy}",   Hidden:Number("${sRstHdn}"),  Width:"${sRstWdt}", Align:"Center", ColMerge:0,   SaveName:"sResult" , Sort:0},
            {Header:"상태",      Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),  Width:"${sSttWdt}", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
			{Header:"항목그룹코드",    Type:"Text",      Hidden:1,  Width:1,    Align:"Left",    ColMerge:0,   SaveName:"payGroupCd",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"항목코드",        Type:"Text",      Hidden:0,  Width:80,    Align:"Left",    ColMerge:0,   SaveName:"elementCd",      KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"항목명",          Type:"Popup",     Hidden:0,  Width:150,  Align:"Left",    ColMerge:0,   SaveName:"elementNm",      KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:50 },
			{Header:"시작일자",        Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"sdate",          KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"종료일자",        Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"edate",          KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"순서",  			Type:"Float",    Hidden:0,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"seq",           KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 }];

        IBS_InitSheet(sheet2, initdata1);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

        $(window).smartresize(sheetResize); sheetInit();
        doActionFirst("Search");
	});

    //Sheet Action First
    function doActionFirst(sAction) {
        switch (sAction) {
	        case "Search":
				sheet1.DoSearch( "${ctx}/PerPayYearEleGroupMgr.do?cmd=getPerPayYearEleGroupMgrListFirst", $("#mySheetForm").serialize() );

				//sheet2 조회 결과 초기화
				$("#searchPayGroupCd").val('');
				gridFirstOnClickElementSetCd = '';
				doActionSecond("Search");

				break;
	        case "Save":
	        	if(!dupChk(sheet1,"payGroupCd", false, true)){break;}
	        	IBS_SaveName(document.mySheetForm,sheet1);
	        	sheet1.DoSave( "${ctx}/PerPayYearEleGroupMgr.do?cmd=savePerPayYearEleGroupMgrFirst", $("#mySheetForm").serialize()); break;
	        case "Insert":      sheet1.SelectCell(sheet1.DataInsert(0), 4); break;
	        case "Copy":        sheet1.DataCopy(); break;
	        case "Clear":       sheet1.RemoveAll(); break;
	        case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
				sheet1.Down2Excel(param); break;
	        case "LoadExcel":   var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
        }
    }

    //Sheet Action Second
    function doActionSecond(sAction) {


    	if ( (sheet1.GetCellValue(sheet1.GetSelectRow(),"sStatus")=="I") && !(sAction=="Search") ) {
            alert("상단의 파일목록에서 \"입력\"작업을 완료한 후에 상세목록 작업을 진행해주시기 바랍니다.     ");
            return;
        }

   		switch (sAction) {
           case "Search":      sheet2.DoSearch( "${ctx}/PerPayYearEleGroupMgr.do?cmd=getPerPayYearEleGroupMgrListSecond", $("#mySheetForm").serialize() ); break;
           case "Save":
        	   if(!dupChk(sheet2,"elementCd|sdate", false, true)){break;}
        	   IBS_SaveName(document.mySheetForm,sheet2);
        	   sheet2.DoSave( "${ctx}/PerPayYearEleGroupMgr.do?cmd=savePerPayYearEleGroupMgrSecond", $("#mySheetForm").serialize()); break;
           case "Insert":
        	   if(gridFirstOnClickElementSetCd == ""){
        		   alert("상단의 파일목록에서 상세항목을 \"입력할 파일\"을 먼저 선택해 주세요.     ");
        	   }else{
        		   var newRow = sheet2.DataInsert(0);
        		   sheet2.SetCellValue(newRow, "payGroupCd", gridFirstOnClickElementSetCd);

        		   sheet2.SelectCell(newRow, "elementNm");
        		   //sheet2.SelectCell(sheet2.DataInsert(0), 4);
        	   }
        	   break;
           case "Copy":        sheet2.DataCopy(); break;
           case "Clear":       sheet2.RemoveAll(); break;
           case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet2);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
				sheet2.Down2Excel(param); break;
           case "LoadExcel":   var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
         }
    }

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } doActionFirst("Search"); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}


	   // 조회 후 에러 메시지
    function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
    }

    // 저장 후 메시지
    function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try { if (Msg != "") { alert(Msg); } doActionSecond("Search"); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
    }

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doActionFirst("Insert");
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
				// First Grid 의 파일번호의 값 전달 (fileSeq)
	            $("#searchPayGroupCd").val(sheet1.GetCellValue(NewRow,"payGroupCd"));
	            gridFirstOnClickElementSetCd = sheet1.GetCellValue(NewRow,"payGroupCd");
	            doActionSecond("Search");
			}
		}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}


//  Type이 POPUP인 셀에서 팝업버튼을 눌렀을때 발생하는 이벤트
    function sheet2_OnPopupClick(Row, Col){

		let layerModal = new window.top.document.LayerModal({
			id : 'payElementLayer'
			, url : '/PayElementPopup.do?cmd=viewPayElementLayer&authPg=${authPg}'
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

        <%--try{--%>

        <%--  var colName = sheet2.ColSaveName(Col);--%>
        <%--  var args    = new Array();--%>

        <%--  args["elementCd"]   = sheet2.GetCellValue(Row, "elementCd");--%>
        <%--  args["elementNm"]   = sheet2.GetCellValue(Row, "elementNm");--%>

        <%--  var rv = null;--%>

        <%--  if(colName == "elementNm") {--%>
        <%--	  if(!isPopup()) {return;}--%>
        <%--	  gPRow = Row;--%>
        <%--	  pGubun = "payElementPopup";--%>

        <%--      var rv = openPopup("/PayElementPopup.do?cmd=payElementPopup&authPg=${authPg}", args, "740","520");--%>
        <%--      /*--%>
        <%--      if(rv!=null){--%>
        <%--          sheet2.SetCellValue(Row, "elementCd",   rv["elementCd"] );--%>
        <%--          sheet2.SetCellValue(Row, "elementNm",   rv["elementNm"] );--%>
        <%--      }--%>
        <%--      */--%>
        <%--  }--%>

        <%--}catch(ex){alert("OnPopupClick Event Error : " + ex);}--%>
    }
    
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

	    if(pGubun == "payElementPopup"){
	    	sheet2.SetCellValue(gPRow, "elementCd",   rv["elementCd"] );
	    	sheet2.SetCellValue(gPRow, "elementNm",   rv["elementNm"] );
	    }
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">

    <div class="sheet_search outer">
    <form id="mySheetForm" name="mySheetForm" >
    <!-- Second Grid 조회 조건 -->
    <input type="hidden" id="searchPayGroupCd" name="searchPayGroupCd" value ="" />
    <!-- Second Grid 조회 조건 -->
        <div>
	        <table>
		        <tr>
		        	<th>항목그룹명</th>
		            <td>
		            	<input id="searchPayGroupNm" name ="searchPayGroupNm" type="text" class="text" />
		            </td>
		            <td><a href="javascript:doActionFirst('Search')" class="button">조회</a></td>
		        </tr>
	        </table>
        </div>
    </form>
    </div>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<colgroup>
			<col width="50%" />
			<col width="50%" />
		</colgroup>
		<tr>
			<td class="sheet_left">
				<div class="inner">
			        <div class="sheet_title">
			        <ul>
			            <li class="txt">항목그룹</li>
			            <li class="btn">
			              <a href="javascript:doActionFirst('Insert')" class="basic authA">입력</a>
			              <a href="javascript:doActionFirst('Copy')"   class="basic authA">복사</a>
			              <a href="javascript:doActionFirst('Save')"   class="basic authA">저장</a>
			              <a href="javascript:doActionFirst('Down2Excel')"   class="basic authR">다운로드</a>
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
				            <li class="txt">항목명</li>
				            <li class="btn">
				              <a href="javascript:doActionSecond('Insert')" class="basic authA">입력</a>
				              <a href="javascript:doActionSecond('Copy')"   class="basic authA">복사</a>
				              <a href="javascript:doActionSecond('Save')"   class="basic authA">저장</a>
				              <a href="javascript:doActionSecond('Down2Excel')"   class="basic authR">다운로드</a>
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
