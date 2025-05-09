<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<title><tit:txt mid='112691' mdef='텍스트파일생성목록'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	// 1번 그리드에서 선택된 값
	var gridFirstOnClickFileSeq = "";
	$(function() {
		// 1번 그리드
		var initdata0 = {};
		initdata0.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata0.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata0.Cols = [
                {Header:"<sht:txt mid='sNo' mdef='No'/>",        Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
                {Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",      Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),  Width:"${sDelWdt}", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
                {Header:"<sht:txt mid='resultV2' mdef='결과'/>",      Type:"${sRstTy}",   Hidden:Number("${sRstHdn}"),  Width:"${sRstWdt}", Align:"Center", ColMerge:0,   SaveName:"sResult" , Sort:0},
                {Header:"<sht:txt mid='sStatus' mdef='상태'/>",      Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),  Width:"${sSttWdt}", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
				{Header:"<sht:txt mid='fileSeqV1' mdef='파일번호'/>",     Type:"Text",      Hidden:0,  Width:80,   Align:"Right",   ColMerge:0,   SaveName:"fileSeq",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
				{Header:"<sht:txt mid='fileNm' mdef='파일명'/>",       Type:"Text",      Hidden:0,  Width:200,  Align:"Left",    ColMerge:0,   SaveName:"fileNm",      KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
				{Header:"<sht:txt mid='fileDesc' mdef='파일설명'/>",     Type:"Text",      Hidden:0,  Width:235,  Align:"Left",    ColMerge:0,   SaveName:"fileDesc",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
				{Header:"<sht:txt mid='elementLength' mdef='길이'/>",         Type:"Float",     Hidden:0,  Width:60,   Align:"Right",   ColMerge:0,   SaveName:"fileLength",  KeyField:1,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:5 }
		];
		IBS_InitSheet(sheet1, initdata0);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		$("#searchFileNm,#searchFileDesc").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});


		// 2번 그리드
        var initdata1 = {};
        initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
        initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
        initdata1.Cols = [
            {Header:"<sht:txt mid='sNo' mdef='No'/>",        Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
            {Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",      Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),  Width:"${sDelWdt}", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
            {Header:"<sht:txt mid='resultV2' mdef='결과'/>",      Type:"${sRstTy}",   Hidden:Number("${sRstHdn}"),  Width:"${sRstWdt}", Align:"Center", ColMerge:0,   SaveName:"sResult" , Sort:0},
            {Header:"<sht:txt mid='sStatus' mdef='상태'/>",      Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),  Width:"${sSttWdt}", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
			{Header:"<sht:txt mid='fileSeqV5' mdef='일련번호'/>",       Type:"Text",      Hidden:1,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"fileSeq",          KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='fileElementSeq' mdef='항목일련번호'/>",   Type:"Text",      Hidden:1,  Width:80,   Align:"Left",    ColMerge:0,   SaveName:"fileElementSeq",   KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='elementNmV4' mdef='세부항목명'/>",     Type:"Text",      Hidden:0,  Width:130,  Align:"Left",    ColMerge:0,   SaveName:"elementNm",        KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='elementLength' mdef='길이'/>",           Type:"Float",     Hidden:0,  Width:60,   Align:"Right",   ColMerge:0,   SaveName:"elementLength",    KeyField:1,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:5 },
			{Header:"<sht:txt mid='elementAlign' mdef='정렬'/>",           Type:"Combo",     Hidden:0,  Width:85,   Align:"Left",    ColMerge:0,   SaveName:"elementAlign",     KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",           Type:"Float",     Hidden:0,  Width:60,   Align:"Right",   ColMerge:0,   SaveName:"alignSeq",         KeyField:1,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='emptyCharactor' mdef='공백문자'/>",       Type:"Text",      Hidden:0,  Width:70,   Align:"Left",    ColMerge:0,   SaveName:"emptyCharactor",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='elementDesc' mdef='세부항목설명'/>",   Type:"Text",      Hidden:0,  Width:170,  Align:"Left",    ColMerge:0,   SaveName:"elementDesc",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 }
		];
        IBS_InitSheet(sheet2, initdata1);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

        sheet2.SetColProperty("elementAlign", {ComboText:"<sht:txt mid='sortV1' mdef='왼쪽정렬|오른쪽정렬'/>", ComboCode:"좌|우"} );

        $(window).smartresize(sheetResize); sheetInit();
        doAction1("Search");
	});

    //Sheet Action First
    function doAction1(sAction) {
        switch (sAction) {
	        case "Search":      sheet1.DoSearch( "${ctx}/TextFileMgr.do?cmd=getTextFileMgrListFirst", $("#mySheetForm").serialize() ); break;
	        case "Save":
	        	//if(!dupChk(sheet1,"fileSeq", false, true)){break;}
	        	IBS_SaveName(document.mySheetForm,sheet1);
	        	sheet1.DoSave( "${ctx}/TextFileMgr.do?cmd=saveTextFileMgrFirst", $("#mySheetForm").serialize()); break;
	        case "Insert":
	        	sheet1.SelectCell(sheet1.DataInsert(0), 4); break;
	        case "Copy":
					var Row = sheet1.DataCopy();
		            sheet1.SelectCell(Row, 5);
		          	sheet1.SetCellValue(Row, "fileSeq","");
		          	break;
	        case "Clear":       sheet1.RemoveAll(); break;
	        case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet1.Down2Excel(param); break;
	        case "LoadExcel":   var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
        }
    }

    //Sheet Action Second
    function doAction2(sAction) {


    	if ( (sheet1.GetCellValue(sheet1.GetSelectRow(),"sStatus")=="I") && !(sAction=="Search") ) {
    		alert("<msg:txt mid='109364' mdef='상단의 파일목록에서 \'입력\'작업을 완료한 후에 상세목록 작업을 진행해주시기 바랍니다.'/>");
            return;
        }

   		switch (sAction) {
           case "Search":      sheet2.DoSearch( "${ctx}/TextFileMgr.do?cmd=getTextFileMgrListSecond", $("#mySheetForm").serialize() ); break;
           case "Save":
        	   //if(!dupChk(sheet2,"fileElementSeq", false, true)){break;}
        	   IBS_SaveName(document.mySheetForm,sheet2);
        	   sheet2.DoSave( "${ctx}/TextFileMgr.do?cmd=saveTextFileMgrSecond", $("#mySheetForm").serialize()); break;
           case "Insert":
        	   if(gridFirstOnClickFileSeq == ""){
        		   alert("<msg:txt mid='110300' mdef='상단의 파일목록에서 상세항목을 \'입력할 파일\'을 먼저 선택해 주세요.'/>");
        	   }else{
        		   var newRow = sheet2.DataInsert(0);
        		   sheet2.SetCellValue(newRow, "fileSeq", gridFirstOnClickFileSeq);
        		   sheet2.SelectCell(newRow, "elementNm");
        		   //sheet2.SelectCell(sheet2.DataInsert(0), 4);
        	   }
        	   break;
           case "Copy":        var Row = sheet2.DataCopy(); sheet2.SetCellValue(Row, "fileElementSeq",""); break;
           case "Clear":       sheet2.RemoveAll(); break;
           case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet2);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
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
		try { if (Msg != "") { alert(Msg); doAction1("Search");}} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}


	   // 조회 후 에러 메시지
    function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
    }

    // 저장 후 메시지
    function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try { if (Msg != "") { alert(Msg); doAction2("Search"); }} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
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

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		//alert("mySheetLeft_OnClick Click : \nRow:"+ Row+" \nCol:"+Col+" \nValue:"+Value+" \nCellX:"+CellX+" \nCellY:"+CellY+" \nCellW:"+CellW+" \nCellH:"+CellH );
		try{
		}catch(ex){alert("OnSelectCell Event Error : " + ex);	}
	}

	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try{
			if(OldRow != NewRow){
				// First Grid 의 파일번호의 값 전달 (fileSeq)
	            $("#searchFileSeq").val(sheet1.GetCellValue(NewRow,"fileSeq"));
	            gridFirstOnClickFileSeq = sheet1.GetCellValue(NewRow,"fileSeq");
	            doAction2("Search");
			}
		}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}



</script>
</head>
<body class="bodywrap">
<div class="wrapper">

    <div class="sheet_search outer">
    <form id="mySheetForm" name="mySheetForm" >
    <!-- Second Grid 조회 조건 -->
    <input type="hidden" id="searchFileSeq" name="searchFileSeq" value ="" />
    <!-- Second Grid 조회 조건 -->
        <div>
        <table>
        <tr>
        	<th><tit:txt mid='114493' mdef='파일명'/></th>
            <td><input id="searchFileNm" name ="searchFileNm" type="text" class="text" /></td>
            <th><tit:txt mid='113073' mdef='파일설명'/></th>
            <td>
            	<input id="searchFileDesc" name ="searchFileDesc" type="text" class="text" />
            </td>
            <td><btn:a href="javascript:doAction1('Search')" css="button" mid='110697' mdef="조회"/></td>
        </tr>
        </table>
        </div>
    </form>
    </div>

    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt"><tit:txt mid='textFileMgr1' mdef='파일목록'/></li>
            <li class="btn">
              <btn:a href="javascript:doAction1('Insert')" css="basic authA" mid='110700' mdef="입력"/>
              <btn:a href="javascript:doAction1('Copy')"   css="basic authA" mid='110696' mdef="복사"/>
              <btn:a href="javascript:doAction1('Save')"   css="basic authA" mid='110708' mdef="저장"/>
              <a href="javascript:doAction1('Down2Excel')"   class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet1", "100%", "50%", "${ssnLocaleCd}"); </script>
    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt"><tit:txt mid='textFileMgr2' mdef='세부항목'/></li>
            <li class="btn">
              <btn:a href="javascript:doAction2('Insert')" css="basic authA" mid='110700' mdef="입력"/>
              <btn:a href="javascript:doAction2('Copy')"   css="basic authA" mid='110696' mdef="복사"/>
              <btn:a href="javascript:doAction2('Save')"   css="basic authA" mid='110708' mdef="저장"/>
              <a href="javascript:doAction2('Down2Excel')"   class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet2", "100%", "50%", "${ssnLocaleCd}"); </script>

</div>
</body>
</html>
