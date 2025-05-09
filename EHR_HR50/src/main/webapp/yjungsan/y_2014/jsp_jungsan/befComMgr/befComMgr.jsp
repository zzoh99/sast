<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>종전근무지관리</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {

		// 1번 그리드
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols = [
            {Header:"No",				Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },    
            {Header:"삭제",				Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},    
            {Header:"상태",				Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},    
			{Header:"년도",				Type:"Text",    Hidden:1,  Width:245,	Align:"Left",   ColMerge:0, SaveName:"work_yy",   			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"정산구분",				Type:"Text",    Hidden:1,  Width:245,	Align:"Left",   ColMerge:0, SaveName:"adjust_type",   		KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"사번",				Type:"Text",    Hidden:1,  Width:245,	Align:"Left",   ColMerge:0, SaveName:"sabun",   			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"순서",				Type:"Text",    Hidden:1,  Width:245,	Align:"Left",   ColMerge:0, SaveName:"seq",   				KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"근무처명(1)",				Type:"Text",    Hidden:0,  Width:80,	Align:"Left",	ColMerge:0, SaveName:"enter_nm",   			KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"사업자등록번호(3)",			Type:"Text",    Hidden:0,  Width:120,	Align:"Center",	ColMerge:0, SaveName:"enter_no",   			KeyField:1,   CalcLogic:"",   Format:"SaupNo",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"근무기간\n시작일(11)",		    Type:"Date",    Hidden:0,  Width:90,	Align:"Center", ColMerge:0, SaveName:"work_s_ymd",   		KeyField:1,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:8 },
			{Header:"근무기간\n종료일(11)",		    Type:"Date",    Hidden:0,  Width:90,	Align:"Center", ColMerge:0, SaveName:"work_e_ymd",   		KeyField:1,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:8 },
			{Header:"감면기간\n시작일(12)",		    Type:"Date",    Hidden:0,  Width:90,	Align:"Center", ColMerge:0, SaveName:"reduce_s_ymd",   		KeyField:0,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:8 },
			{Header:"감면기간\n종료일(12)",		    Type:"Date",    Hidden:0,  Width:90,	Align:"Center", ColMerge:0, SaveName:"reduce_e_ymd",   		KeyField:0,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:8 },
			{Header:"급여액(13)",			    Type:"Int",     Hidden:0,  Width:80,	Align:"Right",  ColMerge:0, SaveName:"pay_mon",   			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"상여액(14)",			    Type:"Int",     Hidden:0,  Width:80,	Align:"Right",  ColMerge:0, SaveName:"bonus_mon",   		KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"인정상여(15)",		    	Type:"Int",     Hidden:0,  Width:80,	Align:"Right",  ColMerge:0, SaveName:"etc_bonus_mon",   	KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"주식매수선택권\n행사이익(15-1)",	Type:"Int",		Hidden:0,  Width:100,	Align:"Right", 	ColMerge:0, SaveName:"stock_buy_mon",		KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"우리사주조합\n인출금(15-2)",		Type:"Int",     Hidden:0,  Width:80,	Align:"Right",  ColMerge:0, SaveName:"stock_union_mon",		KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"임원퇴직소득금액\n한도초과액(15-3)",		Type:"Int",     Hidden:0,  Width:100,	Align:"Right",  ColMerge:0, SaveName:"imwon_ret_over_mon",		KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"소득세(64)",			    Type:"Int",     Hidden:0,  Width:80,	Align:"Right",  ColMerge:0, SaveName:"income_tax_mon",   	KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"지방소득세(64)",			    Type:"Int",     Hidden:0,  Width:80,	Align:"Right",  ColMerge:0, SaveName:"inhbt_tax_mon",   	KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"농특세(64)",			    Type:"Int",     Hidden:0,  Width:80,	Align:"Right",  ColMerge:0, SaveName:"rural_tax_mon",   	KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"국민연금",		    	Type:"Int",     Hidden:0,  Width:80,	Align:"Right",  ColMerge:0, SaveName:"pen_mon",   			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"사립학교\n교직원연금",		Type:"Int",     Hidden:0,  Width:80,	Align:"Right",  ColMerge:0, SaveName:"etc_mon1",   			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"공무원연금",		    	Type:"Int",     Hidden:0,  Width:80,	Align:"Right",  ColMerge:0, SaveName:"etc_mon2",   			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"군인연금",		    	Type:"Int",     Hidden:0,  Width:80,	Align:"Right",  ColMerge:0, SaveName:"etc_mon3",   			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"별정우체국연금",		    Type:"Int",     Hidden:0,  Width:80,	Align:"Right",  ColMerge:0, SaveName:"etc_mon4",   			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"건강보험",		    	Type:"Int",     Hidden:0,  Width:80,	Align:"Right",  ColMerge:0, SaveName:"hel_mon",   			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"고용보험",		    	Type:"Int",     Hidden:0,  Width:80,	Align:"Right",  ColMerge:0, SaveName:"emp_mon",   			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"국외비과세(18)",		    Type:"Int",     Hidden:0,  Width:80,	Align:"Right",  ColMerge:0, SaveName:"notax_abroad_mon",  	KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"생산직비과세(18-1)",	    	Type:"Int",     Hidden:0,  Width:80,	Align:"Right",  ColMerge:0, SaveName:"notax_work_mon",   	KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"출산보육\n비과세(18-2)",		Type:"Int",     Hidden:0,  Width:80,	Align:"Right",  ColMerge:0, SaveName:"notax_baby_mon",   	KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"연구보조\n비과세(18-4)",		Type:"Int",     Hidden:0,  Width:80,	Align:"Right",  ColMerge:0, SaveName:"notax_research_mon",	KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"외국인\n비과세",		Type:"Int",     Hidden:1,  Width:80,	Align:"Right",  ColMerge:0, SaveName:"notax_forn_mon",   	KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"취재수당\n비과세",		Type:"Int",     Hidden:1,  Width:80,	Align:"Right",  ColMerge:0, SaveName:"notax_reporter_mon",	KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"수련보조수당\n비과세(19)",			Type:"Int",     Hidden:0,  Width:80,	Align:"Right",  ColMerge:0, SaveName:"notax_etc_mon",   	KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);
		
		sheet1.SetCountPosition(4);

		// 2번 그리드
        var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata2.Cols = [
            {Header:"No",		Type:"<%=sNoTy%>",	Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
            {Header:"삭제",		Type:"<%=sDelTy%>",	Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
            {Header:"상태",		Type:"<%=sSttTy%>",	Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
            {Header:"년도",		Type:"Text",		Hidden:1,  Width:80,	Align:"Center",	ColMerge:0,   SaveName:"work_yy",   	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"정산구분",		Type:"Text",		Hidden:1,  Width:80,	Align:"Center",	ColMerge:0,   SaveName:"adjust_type",   KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"사번",		Type:"Text",		Hidden:1,  Width:80,	Align:"Center",	ColMerge:0,   SaveName:"sabun",   		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"순서",		Type:"Text",		Hidden:1,  Width:80,	Align:"Center",	ColMerge:0,   SaveName:"seq",   		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"정산항목",		Type:"Combo",      	Hidden:0,  Width:80,	Align:"Left",	ColMerge:0,   SaveName:"adj_element_cd",KeyField:1,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"비과세금액",	Type:"Int",      	Hidden:0,  Width:80,	Align:"Right",	ColMerge:0,   SaveName:"notax_mon",   	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 }
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("<%=editable%>");sheet2.SetVisible(true);
		
		sheet2.SetCountPosition(4);
		
		var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00303"), "");
	    var adjTypeCmbList = stfConvCode( codeList("<%=jspPath%>/befComMgr/befComMgrRst.jsp?cmd=selectNoTaxCodeList&srchWorkYy="+$("#srchYear").val(),"") , "");

        sheet2.SetColProperty("adj_element_cd",    {ComboText:"|"+adjTypeCmbList[0], ComboCode:"|"+adjTypeCmbList[1]} );
		$("#srchAdjustType").html(adjustTypeList[2]);
		$("#srchSabun").val( $("#searchUserId").val() );

        $(window).smartresize(sheetResize); sheetInit();
        
        doAction1("Search");
	});
	
	$(function() {
		$("#srchYear").bind("keyup",function(event){
			makeNumber(this,"A");
			if( event.keyCode == 13){ 
				doAction1("Search");
				$(this).focus();
			}
		});
	});

    //Sheet Action First
    function doAction1(sAction) {
        switch (sAction) {
        case "Search":
        	if($("#srchYear").val() == "") {
        		alert("대상년도를 입력하여 주십시오.");
        		return;
        	}
        	
    	    var adjTypeCmbList = stfConvCode( codeList("<%=jspPath%>/befComMgr/befComMgrRst.jsp?cmd=selectNoTaxCodeList&srchWorkYy="+$("#srchYear").val(),"") , "");
			sheet2.SetColProperty("adj_element_cd",    {ComboText:"|"+adjTypeCmbList[0], ComboCode:"|"+adjTypeCmbList[1]} );
        	
        	sheet1.DoSearch( "<%=jspPath%>/befComMgr/befComMgrRst.jsp?cmd=selectBefComMgr", $("#srchFrm").serialize(), 1 ); 
        	break;
        case "Save":
        	sheet1.DoSave( "<%=jspPath%>/befComMgr/befComMgrRst.jsp?cmd=saveBefComMgr"); 
        	break;
        case "Insert":    
        	if($("#srchYear").val() == "") {
        		alert("년도를 입력하여 주십시오.");
        		return ; 
        	}
        	
        	var newRow = sheet1.DataInsert(0) ;
       		sheet1.SetCellValue(newRow, "work_yy", 	$("#srchYear").val()); 
       		sheet1.SetCellValue(newRow, "adjust_type", $("#srchAdjustType").val()); 
       		sheet1.SetCellValue(newRow, "sabun", 		$("#srchSabun").val()); 
       		doAction2("Clear") ;
        	break;
        case "Copy":        
       		sheet1.SetCellValue(sheet1.DataCopy(), "seq", ""); 
        	break;
        case "Clear":       
        	sheet1.RemoveAll();
        	break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param);
			break;
        }
    }

    //Sheet Action Second
    function doAction2(sAction) {

   		switch (sAction) {
        case "Search":      
			var param = "srchWorkYy="+sheet1.GetCellValue(sheet1.GetSelectRow(), "work_yy")
						+"&srchAdjustType="+sheet1.GetCellValue(sheet1.GetSelectRow(), "adjust_type")
						+"&srchSabun="+sheet1.GetCellValue(sheet1.GetSelectRow(), "sabun")
						+"&srchSeq="+sheet1.GetCellValue(sheet1.GetSelectRow(), "seq");
 	   		
        	sheet2.DoSearch( "<%=jspPath%>/befComMgr/befComMgrRst.jsp?cmd=selectBefComMgrNoTax", param, 1 ); 
     	   	break;
        case "Save":
			sheet2.DoSave( "<%=jspPath%>/befComMgr/befComMgrRst.jsp?cmd=saveBefComMgrNoTax"); 
			break;
        case "Insert":
			if( sheet1.GetSelectRow() <= 0 ){
				alert("상단의 종전근무지관리를 선택하여 주십시오.");
			} else if( sheet1.GetCellValue(sheet1.GetSelectRow(), "sStatus") == "I" ) {
				alert("상단의 종전근무지관리 입력상태 데이터에는\n하단의 종전근무지비과세를 입력 할 수 없습니다.");
			} else{
				var newRow = sheet2.DataInsert(0);
			
				sheet2.SetCellValue(newRow, "work_yy", sheet1.GetCellValue(sheet1.GetSelectRow(), "work_yy") );
				sheet2.SetCellValue(newRow, "adjust_type", sheet1.GetCellValue(sheet1.GetSelectRow(), "adjust_type") );
				sheet2.SetCellValue(newRow, "sabun", sheet1.GetCellValue(sheet1.GetSelectRow(), "sabun") );
				sheet2.SetCellValue(newRow, "seq", sheet1.GetCellValue(sheet1.GetSelectRow(), "seq") );
			}
			break;
        case "Copy":
        	sheet2.DataCopy();
        	break;
        case "Clear":
        	sheet2.RemoveAll();
        	break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet2.Down2Excel(param);
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			sheetResize();
			
			if(Code == 1 && sheet1.RowCount() == 0) {
				doAction2("Search");
			}
			
		} catch(ex) { 
			alert("OnSearchEnd Event Error : " + ex); 
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			if(Code == 1) {
				doAction1("Search");
			}
		} catch(ex) {
			alert("OnSaveEnd Event Error " + ex); 
		}
	}
	
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try{
			if(sheet1.GetSelectRow() > 0 && OldRow != NewRow) {
				doAction2('Search');
			}
		} catch(ex){
			alert("OnSelectCell Event Error : " + ex);
		}
	}

	// 조회 후 에러 메시지
    function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try { 
			alertMessage(Code, Msg, StCode, StMsg);
        	sheetResize(); 
        } catch(ex) { 
        	alert("OnSearchEnd Event Error : " + ex); 
        }
    }

    // 저장 후 메시지
    function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try { 
			alertMessage(Code, Msg, StCode, StMsg);
			if(Code == 1) {
        		doAction2("Search"); 
			}
        } catch(ex) { 
        	alert("OnSaveEnd Event Error " + ex); 
        }
    }

	// 헤더에서 호출
	function setEmpPage() { 
		$("#srchSabun").val( $("#searchUserId").val() );
		doAction1("Search");
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">

	<%@ include file="../common/include/employeeHeaderYtax.jsp"%>

    <div class="sheet_search outer">
    <form id="srchFrm" name="srchFrm" >
	    <input type="hidden" id="srchSabun" 		name="srchSabun" 		value ="" />
        <div>
        <table>
        <tr>
            <td>
            	<span>대상년도</span>
				<input id="srchYear" name ="srchYear" type="text" class="text" maxlength="4" style="width:35px" value="<%=yeaYear%>"/>
			</td>
			<td>
				<span>작업구분</span>
				<select id="srchAdjustType" name ="srchAdjustType" onChange="javascript:doAction1('Search')" class="box"></select> 
			</td>
            <td>
            	<a href="javascript:doAction1('Search')" class="button">조회</a>
            </td>
        </tr>
        </table>
        </div>
    </form>
    </div>

    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">종전근무지관리
            <span class="txt">※ 소득세 및 지방소득세는 결정세액을 입력하여 주십시오.(차감징수세액 아님)</span>
            </li>
            <li class="btn">
              <a href="javascript:doAction1('Insert')" class="basic authA">입력</a>
              <a href="javascript:doAction1('Copy')"   class="basic authA">복사</a>
              <a href="javascript:doAction1('Save')"   class="basic authA">저장</a>
              <a href="javascript:doAction1('Down2Excel')"   class="basic authR">다운로드</a>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet1", "100%", "50%"); </script>
    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">종전근무지비과세</li>
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