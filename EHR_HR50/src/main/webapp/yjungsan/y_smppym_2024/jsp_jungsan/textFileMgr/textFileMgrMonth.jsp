<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>연말정산항목관리</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<script type="text/javascript">

	$(function() {
		
		// 1번 그리드에서 선택된 값
		var gridFirstOnClickFileSeq = "";
		var gridFirstOnClickWorkYy  = "";
		
		// 1번 그리드
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols = [
			{Header:"No",		Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
			{Header:"삭제",		Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
            {Header:"결과",		Type:"<%=sRstTy%>",   Hidden:Number("<%=sRstHdn%>"),  Width:"<%=sRstWdt%>", Align:"Center", ColMerge:0,   SaveName:"sResult" , Sort:0},
            {Header:"상태",		Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
            {Header:"지급연도",	Type:"Text",     Hidden:1,  Width:100,   Align:"Center", ColMerge:0,   	SaveName:"work_yy",		KeyField:0,   	CalcLogic:"",   Format:"",   		PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:4 },
			{Header:"파일번호",   Type:"Text",      Hidden:0,  Width:80,   Align:"Right",   ColMerge:0,   SaveName:"file_seq",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"파일명",     Type:"Text",      Hidden:0,  Width:200,  Align:"Left",    ColMerge:0,   SaveName:"file_nm",      KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"파일설명",    Type:"Text",      Hidden:0,  Width:235,  Align:"Left",    ColMerge:0,   SaveName:"file_desc",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"길이",       Type:"Float",     Hidden:0,  Width:60,   Align:"Right",   ColMerge:0,   SaveName:"file_length",  KeyField:1,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:5 },  
			{Header:"오류내용",    Type:"Text",     Hidden:0,  Width:60,   Align:"Center",   ColMerge:0,   SaveName:"d_note",  KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:5 },
			{Header:"세부ROW",    Type:"Text",     Hidden:0,  Width:60,   Align:"Center",   ColMerge:0,   SaveName:"rcnt",  KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:5 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);

		sheet1.SetCountPosition(4);
		 /* 현재년도 */
		$("#searchWorkYy").val("<%=yjungsan.util.DateUtil.getDateTime("yyyy")%>") ;
		 
		$("#searchFileNm,#searchFileDesc","#searchWorkYy").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		
		
		// 2번 그리드
        var initdata2 = {};
        initdata2.Cfg = {SearchMode:smLazyLoad,Page:22}; 
        initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
        initdata2.Cols = [
        	{Header:"No",		Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
			{Header:"삭제",		Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
            {Header:"결과",		Type:"<%=sRstTy%>",   Hidden:Number("<%=sRstHdn%>"),  Width:"<%=sRstWdt%>", Align:"Center", ColMerge:0,   SaveName:"sResult" , Sort:0},
            {Header:"상태",		Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
            {Header:"지급연도",	Type:"Text",      	Hidden:1,  	Width:100,   Align:"Center",  	ColMerge:0,   	SaveName:"work_yy",		KeyField:0,   	CalcLogic:"",   Format:"",   		PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:4 },
			{Header:"일련번호",    Type:"Text",      Hidden:1,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"file_seq",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"항목일련번호", Type:"Text",      Hidden:1,  Width:80,   Align:"Left",    ColMerge:0,   SaveName:"file_element_seq",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"세부항목명",     Type:"Text",      Hidden:0,  Width:130,  Align:"Left",    ColMerge:0,   SaveName:"element_nm",        KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"길이",           Type:"Int",     Hidden:0,  Width:60,   Align:"Right",   ColMerge:0,   SaveName:"element_length",    KeyField:1,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:5 },
			{Header:"정렬",           Type:"Combo",     Hidden:0,  Width:85,   Align:"Left",    ColMerge:0,   SaveName:"element_align",     KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"순서",           Type:"Float",     Hidden:0,  Width:60,   Align:"Right",   ColMerge:0,   SaveName:"align_seq",         KeyField:1,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"공백문자",       Type:"Text",      Hidden:0,  Width:70,   Align:"Left",    ColMerge:0,   SaveName:"empty_charactor",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"세부항목설명",   Type:"Text",      Hidden:0,  Width:170,  Align:"Left",    ColMerge:0,   SaveName:"element_desc",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 }  
		];     
        IBS_InitSheet(sheet2, initdata2);
        sheet2.SetEditable("<%=editable%>");
        sheet2.SetVisible(true);
        sheet2.SetCountPosition(4);
        
        sheet2.SetColProperty("element_align", {ComboText:"왼쪽정렬|오른쪽정렬", ComboCode:"좌|우"} );
		
        $(window).smartresize(sheetResize); sheetInit();
        doAction1("Search");
	});
	
    //Sheet Action First
    function doAction1(sAction) {
        switch (sAction) {
	        //case "Search":      sheet1.DoSearch( "${ctx}/GetDataList.do?cmd=getTextFileMgrListFirst", $("#mySheetForm").serialize() ); break;
	        case "Search":      
	        	if($("#searchWorkYy").val() == "") { alert("년도를 입력하여 주십시오."); return ; }
	        	
	        	sheet1.DoSearch("<%=jspPath%>/textFileMgr/textFileMgrMonthRst.jsp?cmd=getTextFileMgrListFirst", $("#mySheetForm").serialize());
	        	break;
	        case "Save":        
	        	//if(!dupChk(sheet1,"fileSeq", false, true)){break;}
	        	//IBS_SaveName(document.mySheetForm,sheet1);
	        	
	        	sheet1.DoSave( "<%=jspPath%>/textFileMgr/textFileMgrMonthRst.jsp?cmd=saveTextFileMgrFirst", $("#mySheetForm").serialize());
	        	break;
	        case "Insert":      
	        	var newRow = sheet1.DataInsert(0) ;
	        	sheet1.SelectCell(newRow, 4)
	        	sheet1.SetCellValue(newRow, "work_yy",$("#searchWorkYy").val());

	        	; break;
	        case "Copy":        
					var Row = sheet1.DataCopy();
		            sheet1.SelectCell(Row, 5);
		            sheet1.SetCellValue(Row, "work_yy",$("#searchWorkYy").val());
		          	sheet1.SetCellValue(Row, "file_seq","");
		          	break;
	        case "Clear":       sheet1.RemoveAll(); break;
	        case "Down2Excel":  	
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
				sheet1.Down2Excel(param); break;
	        case "LoadExcel":   var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
	        case "YearCopy":    
	        	if(confirm($("#searchWorkYy").val()+"년 자료 생성시 기존 내용이 삭제 됩니다. \n실행 하시겠습니까?")){
	        		ajaxCall("<%=jspPath%>/textFileMgr/textFileMgrMonthRst.jsp?cmd=copyTextFileMgr",$("#mySheetForm").serialize()
	        				,true
	    					,function(){
	    						$("#progressCover").dialog('open');
	    					 }
	    					,function(){
	    						$("#progressCover").dialog('close');
	    			    		doAction1("Search");
	    					}
	    			);
	        	}
	        	break;
        }
    }
    
    //Sheet Action Second
    function doAction2(sAction) {
        
    	
    	if ( (sheet1.GetCellValue(sheet1.GetSelectRow(),"sStatus")=="I") && !(sAction=="Search") ) {
            alert("상단의 파일목록에서 \"입력\"작업을 완료한 후에 상세목록 작업을 진행해주시기 바랍니다.     ");
            return;
        }
    	
   		switch (sAction) {
           case "Search":      
   			sheet2.DoSearch( "<%=jspPath%>/textFileMgr/textFileMgrMonthRst.jsp?cmd=getTextFileMgrListSecond", $("#mySheetForm").serialize());
   			
			break;
           case "Save":        
        	   //if(!dupChk(sheet2,"fileElementSeq", false, true)){break;}
        	   //IBS_SaveName(document.mySheetForm,sheet2);
        	   sheet2.DoSave( "<%=jspPath%>/textFileMgr/textFileMgrMonthRst.jsp?cmd=saveTextFileMgrSecond", $("#mySheetForm").serialize()); break;
           case "Insert":      
        	   if(gridFirstOnClickFileSeq == ""){
        		   alert("상단의 파일목록에서 상세항목을 \"입력할 파일\"을 먼저 선택해 주세요.     ");
        	   }else{
        		   var newRow = sheet2.DataInsert(0);
        		   sheet2.SetCellValue(newRow, "file_seq", gridFirstOnClickFileSeq);
        		   sheet2.SetCellValue(newRow, "work_yy", gridFirstOnClickWorkYy);
        		   sheet2.SelectCell(newRow, "element_nm");
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
		
		if(sheet1.RowCount() == 0)
		{
			$("#searchWorkYy2").val($("#searchWorkYy").val());
			doAction2("Search");
		}
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
	            $("#searchFileSeq").val(sheet1.GetCellValue(NewRow,"file_seq"));
	            $("#searchWorkYy2").val(sheet1.GetCellValue(NewRow,"work_yy"));
	            gridFirstOnClickFileSeq = sheet1.GetCellValue(NewRow,"file_seq");
	            gridFirstOnClickWorkYy = sheet1.GetCellValue(NewRow,"work_yy");
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
    <input type="hidden" id="searchWorkYy2" name="searchWorkYy2" value ="" />
    <!-- Second Grid 조회 조건 -->
        <div>
        <table>
        <tr>
        	<td><span>년도</span>
			<input id="searchWorkYy" name ="searchWorkYy" type="text" class="text" maxlength="4" style= "width:40px; padding-left: 10px;"/> </td>
            <td><span>파일명</span><input id="searchFileNm" name ="searchFileNm" type="text" class="text" /></td>
            <td><span>파일설명</span><input id="searchFileDesc" name ="searchFileDesc" type="text" class="text" /></td>
            <td><a href="javascript:doAction1('Search')" class="button">조회</a></td>
        </tr>
        </table>
        </div>
    </form>
    </div>
    
    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">파일목록</li>
            <li class="btn">
              <a href="javascript:doAction1('Insert')" class="basic authA">입력</a>
              <a href="javascript:doAction1('Copy')"   class="basic authA">복사</a>
              <a href="javascript:doAction1('Save')"   class="basic authA">저장</a>
              <a href="javascript:doAction1('Down2Excel')"   class="basic authR">다운로드</a>
              <a href="javascript:doAction1('YearCopy')"   class="pink authA">전년도 항목복사</a>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet1", "100%", "50%"); </script>
    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">세부항목</li>
            <li class="btn">
              <a href="javascript:doAction2('Insert')" class="basic authA">입력</a>
              <a href="javascript:doAction2('Copy')"   class="basic authA">복사</a>
              <a href="javascript:doAction2('Save')"   class="basic authA">저장</a>
              <a href="javascript:doAction2('Down2Excel')"   class="basic authR">다운로드</a>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet2", "100%", "50%"); </script>
    
</div>
</body>
</html>