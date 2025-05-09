<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html><head> <title>연간소득_개별</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var templeteTitle1 = "업로드시 이 행은 삭제 합니다\n\n";
	
	$(function() {

		// 1번 그리드
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata1.Cols = [
			{Header:"No",				Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },    
			{Header:"삭제",				Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},    
			{Header:"상태",				Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},    
			{Header:"년도",				Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,   SaveName:"work_yy",			KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"정산구분",				Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,   SaveName:"adjust_type",		KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"사번",				Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,   SaveName:"sabun",   			KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"년월",				Type:"Date",      	Hidden:0,  	Width:80,	Align:"Center",	ColMerge:0,   SaveName:"ym",   				KeyField:1,   CalcLogic:"",   Format:"Ym",		PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:6 },
			{Header:"급여액",				Type:"AutoSum",		Hidden:0,  	Width:80,	Align:"Right", 	ColMerge:0,   SaveName:"pay_mon",   		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"상여액",			    Type:"AutoSum",		Hidden:0,  	Width:80,	Align:"Right", 	ColMerge:0,   SaveName:"bonus_mon",   		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"인정상여",		    	Type:"AutoSum",		Hidden:0,  	Width:80,	Align:"Right", 	ColMerge:0,   SaveName:"etc_bonus_mon",   	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"주식매수선택권\n행사이익",	Type:"AutoSum",		Hidden:0,  	Width:100,	Align:"Right", 	ColMerge:0,   SaveName:"stock_buy_mon",		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"우리사주조합\n인출금",		Type:"AutoSum",     Hidden:0,  	Width:80,	Align:"Right", 	ColMerge:0,   SaveName:"stock_union_mon",  	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"임원퇴직소득금액\n한도초과액",		Type:"AutoSum",     Hidden:0,  	Width:100,	Align:"Right", 	ColMerge:0,   SaveName:"imwon_ret_over_mon",  	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"총급여",				Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right", 	ColMerge:0,   SaveName:"total",				KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35, CalcLogic:"|pay_mon|+|bonus_mon|+|etc_bonus_mon|+|stock_buy_mon|+|stock_union_mon|+|imwon_ret_over_mon|" },
			{Header:"생산\n비과세",	    	Type:"AutoSum",     Hidden:0,  	Width:80,	Align:"Right", 	ColMerge:0,   SaveName:"notax_work_mon",   	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"국외\n비과세",	    	Type:"AutoSum",     Hidden:0,  	Width:80,	Align:"Right", 	ColMerge:0,   SaveName:"notax_abroad_mon",  KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"식대\n비과세",	    	Type:"AutoSum",     Hidden:0,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"notax_food_mon",   	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"차량\n비과세",	    	Type:"AutoSum",     Hidden:0,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"notax_car_mon",   	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"외국인\n비과세",		Type:"AutoSum",		Hidden:0,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"notax_forn_mon",   	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"연구활동\n비과세",		Type:"AutoSum",     Hidden:0,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"notax_research_mon",KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"출산보육\n비과세",		Type:"AutoSum",		Hidden:0,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"notax_baby_mon",   	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"지정\n비과세",			Type:"AutoSum",		Hidden:0,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"notax_etc_mon",   	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"일직료\n비과세",		Type:"AutoSum",		Hidden:0,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"notax_nightduty_mon",KeyField:0,  CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"비과세계",				Type:"AutoSum",		Hidden:0,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"notax_total",		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35, CalcLogic:"|notax_work_mon|+|notax_abroad_mon|+|notax_food_mon|+|notax_car_mon|+|notax_forn_mon|+|notax_research_mon|+|notax_baby_mon|+|notax_etc_mon|+|notax_nightduty_mon|" },
			{Header:"국민연금",		    	Type:"AutoSum",     Hidden:0,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"pen_mon",   		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"사립학교교직원연금",		    Type:"AutoSum",     Hidden:0,  	Width:120,	Align:"Right",	ColMerge:0,   SaveName:"etc_mon1",   		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"공무원연금",		    	Type:"AutoSum",     Hidden:0,  	Width:120,	Align:"Right",	ColMerge:0,   SaveName:"etc_mon2",   		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"군인연금",		    	Type:"AutoSum",     Hidden:0,  	Width:120,	Align:"Right",	ColMerge:0,   SaveName:"etc_mon3",   		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"별정우체국연금",		    Type:"AutoSum",     Hidden:0,  	Width:120,	Align:"Right",	ColMerge:0,   SaveName:"etc_mon4",   		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"건강보험",		    	Type:"AutoSum",     Hidden:0,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"hel_mon",   		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"고용보험",		    	Type:"AutoSum",     Hidden:0,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"emp_mon",   		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"소득세",			    Type:"AutoSum",     Hidden:0,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"income_tax_mon",   	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"지방소득세",			    Type:"AutoSum",     Hidden:0,  	Width:80,	Align:"Right",  ColMerge:0,   SaveName:"inhbt_tax_mon",   	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"농특세",			    Type:"AutoSum",     Hidden:0,  	Width:80,	Align:"Right",  ColMerge:0,   SaveName:"rural_tax_mon",   	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"감면\n세액",			Type:"AutoSum",     Hidden:1,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"exmpt_tax_mon",   	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"외국인납세보전",			Type:"AutoSum",     Hidden:1,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"frgn_tax_plus_mon", KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"국외지급일자",			Type:"Date",     	Hidden:1,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"frgn_pay_ymd",   	KeyField:0,   CalcLogic:"",   Format:"Ymd",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:8 },
			{Header:"외화",			    Type:"AutoSum",     Hidden:1,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"frgn_mon",   		KeyField:0,   CalcLogic:"",   Format:"Integer", tCount:0,   	UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"원화",			    Type:"AutoSum",     Hidden:1,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"frgn_ntax_mon",   	KeyField:0,   CalcLogic:"",   Format:"Integer", tCount:0,   	UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			//{Header:"기타금액2",			Type:"AutoSum",     Hidden:1,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"etc_mon2",   		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			//{Header:"기타금액3",			Type:"AutoSum",     Hidden:1,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"etc_mon3",   		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"기부금",				Type:"AutoSum",     Hidden:0, 	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"labor_mon",   		KeyField:0,   CalcLogic:"",   Format:"Integer", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);
		
		sheet1.SetCountPosition(0);

		// 2번 그리드
        var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
        initdata2.Cols = [
            {Header:"No",		Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
            {Header:"삭제",		Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
            {Header:"상태",		Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
            {Header:"년도",		Type:"Text",      	Hidden:1,  Width:80,	Align:"Center",	ColMerge:0,   SaveName:"work_yy",   	KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"정산구분",		Type:"Text",      	Hidden:1,  Width:80,	Align:"Center",	ColMerge:0,   SaveName:"adjust_type",   KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"사번",		Type:"Text",      	Hidden:1,  Width:80,	Align:"Center",	ColMerge:0,   SaveName:"sabun",   		KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"소득구분명",	Type:"Combo",      	Hidden:0,  Width:90,	Align:"Center",	ColMerge:0,   SaveName:"adj_element_cd",KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"지급월",		Type:"Date",      	Hidden:0,  Width:70,	Align:"Center",	ColMerge:0,   SaveName:"ym",   			KeyField:1,   CalcLogic:"",   Format:"Ym",		PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:6 },
			{Header:"총액",		Type:"AutoSum",		Hidden:0,  Width:80,	Align:"Right",  ColMerge:0,   SaveName:"mon",   		KeyField:0,   CalcLogic:"",   Format:"Integer", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"비과세액",		Type:"AutoSum",		Hidden:0,  Width:80,	Align:"Right",  ColMerge:0,   SaveName:"notax_mon",  	KeyField:0,   CalcLogic:"",   Format:"Integer", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"과세액",		Type:"AutoSum",		Hidden:0,  Width:80,	Align:"Right",  ColMerge:0,   SaveName:"tax_mon",		KeyField:0,   CalcLogic:"",   Format:"Integer", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35 }
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("<%=editable%>");sheet2.SetVisible(true);
		
		sheet2.SetCountPosition(0);
		
		var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00303"), "");
	    var adjTypeCmbList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&srchWorkYy="+$("#srchYear").val(),"getYearEndItemList") , "");
	       
        sheet2.SetColProperty("adj_element_cd",	{ComboText:"|"+adjTypeCmbList[0], ComboCode:"|"+adjTypeCmbList[1]} );

        $("#srchAdjustType").html(adjustTypeList[2]);

        $(window).smartresize(sheetResize); sheetInit();
        
        $("#srchSabun").val( $("#searchUserId").val() ) ;
        
		doAction1("Search");
		
		//양식다운로드 title 정의
		templeteTitle1 += "년월 : YYYY-MM   예)2013-01 \n";
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

    //Sheet Action1
    function doAction1(sAction) {
        switch (sAction) {
        case "Search":
			var param = "cmd=selectYearIncomeEachMgr&"+$("#srchFrm").serialize();
			sheet1.DoSearch( "<%=jspPath%>/yearIncomeEachMgr/yearIncomeEachMgrRst.jsp", param, 1 );
        	break;
        case "Save":
			// 중복체크
			if (!dupChk(sheet1, "work_yy|adjust_type|sabun|ym", true, true)) {break;}
        	sheet1.DoSave( "<%=jspPath%>/yearIncomeEachMgr/yearIncomeEachMgrRst.jsp?cmd=saveYearIncomeEachMgr"); 
        	break;
        case "Insert":    
        	if($("#srchYear").val() == "") { 
        		alert("년도를 입력하여 주십시오.");
        		return ; 
        	}
        	
        	var newRow = sheet1.DataInsert(0) ;
       		sheet1.SetCellValue(newRow, "work_yy",		$("#srchYear").val()); 
       		sheet1.SetCellValue(newRow, "adjust_type",	$("#srchAdjustType").val()); 
       		sheet1.SetCellValue(newRow, "sabun",		$("#srchSabun").val()); 
       		sheet1.SetCellValue(newRow, "sStatus",		"I");
        	break;
        case "Copy":        
        	sheet1.DataCopy();
        	break;
        case "Clear":
        	sheet1.RemoveAll(); 
        	break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param); 
			break;
        case "Down2Template":
			var param  = {DownCols:"6|7|8|9|10|11|12|14|15|16|17|18|19|20|21|22|24|25|26|27|28|29|30|38",SheetDesign:1,Merge:1,DownRows:'0',ExcelFontSize:"9"
				,TitleText:templeteTitle1,UserMerge :"0,0,1,24"};
			sheet1.Down2Excel(param); 
			break;
        case "LoadExcel":  
        	doAction1("Clear") ; 
        	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; 
        	sheet1.LoadExcel(params);
        break;
        }
    }

    //Sheet Action2
    function doAction2(sAction) {

   		switch (sAction) {
        case "Search":      
		    var adjElementCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&srchWorkYy="+$("#srchYear").val(),"getYearEndItemList") , "");

			sheet2.SetColProperty("adj_element_cd",    {ComboText:"|"+adjElementCdList[0], ComboCode:"|"+adjElementCdList[1]} );
			
			var param = "cmd=selectYearIncomeEachMgrEtc&"+$("#srchFrm").serialize();
			sheet2.DoSearch( "<%=jspPath%>/yearIncomeEachMgr/yearIncomeEachMgrRst.jsp", param, 1 );
     	   	break;
        case "Save":
        	// 중복체크
			if (!dupChk(sheet1, "work_yy|adjust_type|sabun|adj_element_cd|ym", true, true)) {break;}
        	sheet2.DoSave( "<%=jspPath%>/yearIncomeEachMgr/yearIncomeEachMgrRst.jsp?cmd=saveYearIncomeEachMgrEtc");
			break;
        case "Insert":
			var newRow = sheet2.DataInsert(0);
			sheet2.SetCellValue(newRow, "work_yy",		$("#srchYear").val()); 
			sheet2.SetCellValue(newRow, "adjust_type",	$("#srchAdjustType").val()); 
			sheet2.SetCellValue(newRow, "sabun",		$("#srchSabun").val()); 
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
        case "LoadExcel":   
        	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet2.LoadExcel(params);
        	break;
		}
    }

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 
			alertMessage(Code, Msg, StCode, StMsg);
			sheetResize();
			
			if(Code == 1) {
				doAction2("Search");
			}
		} catch (ex) { 
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
		} catch (ex) { 
			alert("OnSaveEnd Event Error " + ex); 
		}
	}

	// 로드 후 메시지
	function sheet1_OnLoadExcel() { 
		//엑셀로부터 업로드 된 데이터에 대하여 히든 key값을 세팅한다.
		for(var i = 1; i < sheet1.RowCount()+1; i++) {
			if( sheet1.GetCellValue(i, "sStatus") == "I") {
        		sheet1.SetCellValue(i, "work_yy",		$("#srchYear").val()); 
        		sheet1.SetCellValue(i, "adjust_type",	$("#srchAdjustType").val()); 
        		sheet1.SetCellValue(i, "sabun",			$("#srchSabun").val()); 
			}
		}
	}
	
	// 조회 후 에러 메시지
    function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try { 
			alertMessage(Code, Msg, StCode, StMsg);
			sheetResize(); 
        } catch (ex) { 
        	alert("OnSearchEnd Event Error : " + ex); 
        }
    }

    // 저장 후 메시지
    function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try { 
			alertMessage(Code, Msg, StCode, StMsg);
			if(Code == 1) {
				doAction2('Search'); 
			}
        } catch (ex) { 
        	alert("OnSaveEnd Event Error " + ex); 
        }
    }

	function sheet2_OnChange(Row, Col, Value) {
		try{
			if(Row > 0 && (sheet2.ColSaveName(Col) == "mon" || sheet2.ColSaveName(Col) == "notax_mon")){
				var mon 		= 0;
				var noTaxMon 	= 0;
				if(sheet2.GetCellValue(Row, "mon") != ""){
					mon = parseInt(sheet2.GetCellValue(Row, "mon"), 10);
				}
				if(mon == 0){
					sheet2.SetCellValue(Row, "notax_mon",	"0");
					sheet2.SetCellValue(Row, "tax_mon",		"0");
				}else{
					if(sheet2.GetCellValue(Row, "notax_mon") != ""){
						noTaxMon = parseInt(sheet2.GetCellValue(Row, "notax_mon"), 10);
					}
					if(mon < noTaxMon){
						alert("총액액보다 비과세액이 큽니다.");
						sheet2.SetCellValue(Row, "notax_mon",	"0");
						noTaxMon = 0;
					}
					sheet2.SetCellValue(Row, "tax_mon", mon - noTaxMon);
				}
			}
		} catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

	// 헤더에서 호출
	function setEmpPage() { 
		$("#srchSabun").val( $("#searchUserId").val() ) ;
		doAction1("Search");
	}
</script>
</head>
<body class="bodywrap" style="overflow-y: auto;">
<div class="wrapper">

	<%@ include file="../common/include/employeeHeaderYtax.jsp"%>

    <div class="sheet_search outer">
    <form id="srchFrm" name="srchFrm" >
    	<input type="hidden" id="srchSabun" name="srchSabun" value ="" />
        <div>
        <table>
        <tr>
            <td>
            	<span>년도</span>
				<input id="srchYear" name ="srchYear" type="text" class="text center" maxlength="4" style="width:35px" value="<%=yeaYear%>"/>
			</td>
			<td>
				<span>작업구분</span>
				<select id="srchAdjustType" name ="srchAdjustType" onChange="javascript:doAction1('Search')" class="box"></select> 
			</td>
            <td>
            	<a href="javascript:doAction1('Search');" class="button">조회</a>
            </td>
        </tr>
        </table>
        </div>
    </form>
    </div>

    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">연간소득_개별</li>
            <li class="btn">
              <a href="javascript:doAction1('Down2Template')"   class="basic authA">양식 다운로드</a>
              <a href="javascript:doAction1('LoadExcel')"   class="basic authA">업로드</a>
              <a href="javascript:doAction1('Insert')" class="basic authA">입력</a>
              <a href="javascript:doAction1('Copy')"   class="basic authA">복사</a>
              <a href="javascript:doAction1('Save')"   class="basic authA">저장</a>
              <a href="javascript:doAction1('Down2Excel')"   class="basic authR">다운로드</a>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet1", "100%", "400px"); </script>
    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">기타소득사항
            	<span class="txt">- 비과세항목을 제외한 나머지 항목(건강,고용, 국민, 노조회비 등)에 대해서는 비과세액칸에 금액을 입력하지 마십시오.</span>
            </li>
            <li class="btn">
              <a href="javascript:doAction2('Insert')" class="basic authA">입력</a>
              <a href="javascript:doAction2('Copy')"   class="basic authA">복사</a>
              <a href="javascript:doAction2('Save')"   class="basic authA">저장</a>
              <a href="javascript:doAction2('Down2Excel')"   class="basic authR">다운로드</a>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet2", "100%", "200px"); </script>

</div>
</body>
</html>