<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>원천징수영수증/징수부 승인</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<%
	String beforeMonth = DateUtil.addMonth(Integer.parseInt(curSysYear), Integer.parseInt(curSysMon), Integer.parseInt(curSysDay), -3);
	String afterMonth = DateUtil.addMonth(Integer.parseInt(curSysYear), Integer.parseInt(curSysMon), Integer.parseInt(curSysDay), 1);
%>

<script type="text/javascript">
	var templeteTitle1 = "업로드시 이 행은 삭제 합니다\n\n";
	
	// 조회, 입력 가능한 최소 년도
	var mininumYear = "2013";

	$(function() {
		$("#searchSYmd").datepicker2({startdate:"searchEYmd"});
		$("#searchEYmd").datepicker2({enddate:"searchSYmd"});
		$("#searchSYmd").val(<%=beforeMonth%>);
		$("#searchEYmd").val("<%=afterMonth%>");
		$("#searchSYmd").mask("1111-11-11");
		$("#searchEYmd").mask("1111-11-11");
		$("#searchWorkYy").mask("1111");

		$("#searchSbNm,#searchSYmd,#searchEYmd,#searchWorkYy").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
	});
	
	$(function() {
		
		$("#searchWorkYy").val("<%=yeaYear%>") ;

		var initdata1 = {};
		initdata1.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly, FrozenCol:6}; 
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata1.Cols = [
   			{Header:"No",		Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },    
   			{Header:"삭제",			Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
			{Header:"출력",			Type:"DummyCheck",	Hidden:0,  Width:"<%=sDelWdt%>",    Align:"Center",  ColMerge:0,   SaveName:"chk",		  KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:1,   InsertEdit:0,    EditLen:100, TrueValue:"Y", FalseValue:"N" },
   			{Header:"상태",			Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
			{Header:"사번",      	Type:"Text",      	Hidden:0,  Width:80,  	Align:"Center",  ColMerge:0,   SaveName:"sabun",      KeyField:1,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,	EditLen:100 },
			{Header:"성명",      	Type:"Popup",      	Hidden:0,  Width:80,  	Align:"Center",  ColMerge:0,   SaveName:"name",       KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,	EditLen:100 },
			{Header:"SEQ",			Type:"Text",		Hidden:1,  Width:100,   Align:"Center",	 ColMerge:0,   SaveName:"seq",		  KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,    EditLen:25 },
			{Header:"조직명",		Type:"Text",      	Hidden:0,  Width:110, 	Align:"Center",  ColMerge:0,   SaveName:"org_nm",     KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,	EditLen:100 },
			{Header:"퇴직일",       Type:"Date",        Hidden:0,  Width:90,    Align:"Center",  ColMerge:0,   SaveName:"ret_ymd",    KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,    EditLen:100 },
			{Header:"신청일자",		Type:"Date",		Hidden:0,  Width:100,   Align:"Center",	 ColMerge:0,   SaveName:"appl_ymd",	  KeyField:0,   CalcLogic:"",   Format:"Ymd",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,    EditLen:8 },
			{Header:"귀속년도",		Type:"Int",			Hidden:0,  Width:110,   Align:"Center",	 ColMerge:0,   SaveName:"work_yy",	  KeyField:1,   CalcLogic:"",   Format:"####",     PointCount:0,   UpdateEdit:0,   InsertEdit:1,    EditLen:4 },
            {Header:"출력구분",		Type:"Combo",		Hidden:0,  Width:110,   Align:"Center",	 ColMerge:0,   SaveName:"print_type", KeyField:1,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,    EditLen:8 },
			{Header:"정산구분",		Type:"Combo",		Hidden:0,  Width:70,   	Align:"Center",	 ColMerge:0,   SaveName:"adjust_type",KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,    EditLen:13 },
			{Header:"처리상태",		Type:"Combo",		Hidden:0,  Width:100,   Align:"Center",	 ColMerge:0,   SaveName:"appl_status",KeyField:1,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,    EditLen:10 },
			{Header:"처리일자",		Type:"Date",		Hidden:0,  Width:100,   Align:"Center",	 ColMerge:0,   SaveName:"appr_ymd",	  KeyField:0,   CalcLogic:"",   Format:"Ymd",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,    EditLen:8 },
			{Header:"도장출력",     Type:"CheckBox",  	Hidden:0,  Width:70,	Align:"Center",  ColMerge:0,   SaveName:"stamp_yn",   KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,	EditLen:1, TrueValue:"Y", FalseValue:"N"},
			{Header:"출력여부",     Type:"CheckBox",  	Hidden:0,  Width:70,	Align:"Center",  ColMerge:0,   SaveName:"print_yn",   KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,	EditLen:1, TrueValue:"Y", FalseValue:"N"},
			{Header:"담당자 특이사항",	Type:"Text",	Hidden:0,  Width:150,   Align:"Left", 	 ColMerge:0,   SaveName:"memo",		  KeyField:0,   CalcLogic:"",   Format:"",  	   PointCount:0,   UpdateEdit:1,   InsertEdit:1,    EditLen:100 },
			{Header:"대상자사번",	Type:"Text",		Hidden:1,  Width:70,    Align:"Center",  ColMerge:0,   SaveName:"adj_sabun",  KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100}
        ]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
        sheet1.SetColProperty("appl_status",    {ComboText:"처리중|처리완료", ComboCode:"21|99"} );
        sheet1.SetColProperty("print_type",    {ComboText:"원천징수영수증|원천징수부", ComboCode:"1|2"} );        
        
        var adjustTypeList 	= stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00303"), "");
        sheet1.SetColProperty("adjust_type",    {ComboText:"|"+adjustTypeList[0], ComboCode:"|"+adjustTypeList[1]} );
        
		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");
		
		//양식다운로드 title 정의
		templeteTitle1 += "처리상태 : 21 - 처리중 \n";
		templeteTitle1 += "           99 - 처리완료 \n";
		templeteTitle1 += "귀속년도 : YYYY \n";
		templeteTitle1 += "출력구분 : 1 - 원천징수영수증 \n";
		templeteTitle1 += "           2 - 원천징수부 \n";
		templeteTitle1 += "정산구분 : 1 - 연말정산 \n";
		templeteTitle1 += "           3 - 퇴직정산 \n";
		templeteTitle1 += "   * 원친징수영수증일 경우 필수입력 \n";
		templeteTitle1 += "도장출력 : Y / N \n";
		
	});
	
	$(function(){
		$("#searchWorkYy").bind("keyup",function(event){
			makeNumber(this,"A");
			if( event.keyCode == 13){ 
				doAction1("Search"); 
			}
		});	
		
		$("#searchSbNm").bind("keyup",function(event){
			if( event.keyCode == 13){ 
				doAction1("Search");
			}
		}); 
	});	
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			
			var srchWorkYy = $("#searchWorkYy").val();
			if( Number(srchWorkYy) < mininumYear ){
        		alert(mininumYear + "년 이후의 자료만 신청/조회 가능합니다.");
        		return;
        	}
        	
			sheet1.DoSearch( "<%=jspPath%>/withHoldRcptApr/withHoldRcptAprRst.jsp?cmd=selectWithHoldRcptAprList", $("#sheetForm").serialize() );
			break;
		case "Save":
			
			for(var i = 1; i < sheet1.RowCount()+1; i++) {
				var work_yy = sheet1.GetCellValue(i,"work_yy");
				
				if(work_yy == ""){
					alert("귀속년도는 필수입력 값입니다.");
					return;
				} else if (Number(work_yy) < mininumYear) {
					alert(mininumYear + "년 이후의 자료만 신청 가능합니다.");
        			sheet1.SetCellValue(i,"work_yy","");
        			return;
				}
				
				if(sheet1.GetCellValue(i,"print_type") == "1" && sheet1.GetCellValue(i,"adjust_type") == "") {
             		alert("출력구분이 원천징수영수증일 경우, \n정산구분은 필수 입력 항목 입니다.");
             		return;
             	}
			}
			
            sheet1.DoSave( "<%=jspPath%>/withHoldRcptApr/withHoldRcptAprRst.jsp?cmd=saveWithHoldRcptApr");
            break;
        case "Insert":
            var newRow = sheet1.DataInsert(0) ;
            sheet1.SetCellValue(newRow, "work_yy",      $("#searchWorkYy").val());
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
			var param  = {DownCols:"4|10|11|12|13|15|17",SheetDesign:1,Merge:1,DownRows:'0',ExcelFontSize:"9",TitleText:templeteTitle1,UserMerge :"0,0,1,7"};
			sheet1.Down2Excel(param);
			break;
        case "LoadExcel":  
        	doAction1("Clear") ; 
        	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; 
        	sheet1.LoadExcel(params);
			break;
        }
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 
			alertMessage(Code, Msg, StCode, StMsg);
			sheetResize();
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
        } catch(ex) {
            alert("OnSaveEnd Event Error " + ex);
        }
    }

	// 팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "name") {
				openEmployeePopup(Row) ;
			}
		} catch(ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}

	var gPRow  = "";
	var pGubun = "";

	// 사원 조회
	function openEmployeePopup(Row){
	    try{

	    	 if(!isPopup()) {return;}
	    	 gPRow  = Row;
			 pGubun = "employeePopup";

		     var args    = new Array();
		     var rv = openPopup("<%=jspPath%>/common/employeePopup.jsp?authPg=<%=authPg%>", args, "740","520");
	    } catch(ex) {
	    	alert("Open Popup Event Error : " + ex);
	    }
	}
	
	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

		if ( pGubun == "employeePopup" ){
			//사원조회
			sheet1.SetCellValue(gPRow, "name", 		rv["name"] );
			sheet1.SetCellValue(gPRow, "sabun", 	rv["sabun"] );
			sheet1.SetCellValue(gPRow, "org_nm", 	rv["org_nm"] );
		}
	}

    //값이 바뀔때 발생
    function sheet1_OnChange(Row, Col, Value, OldValue) {
        try{
        	if(sheet1.ColSaveName(Col)	== "work_yy") {
        		if(Value != "" && Number(Value) < mininumYear){
        			alert(mininumYear + "년 이후의 자료만 신청 가능합니다.");
        			sheet1.SetCellValue(Row,Col,"");
        			return;
        		}
        	}
        	
        	// 출력구분 별 정산구분 설정
        	if(sheet1.ColSaveName(Col)	== "print_type") {
        		// 원천징수영수증
        		if(Value == "1"){
        			sheet1.SetCellEditable(Row, "adjust_type", true);
        		
        		}else if(Value == "2"){
        			sheet1.SetCellValue(Row, "adjust_type", "");
        			sheet1.SetCellEditable(Row, "adjust_type", false);
        		}
        	}
        } catch(ex) {
            alert("OnChange Event Error : " + ex);
        }
    }
    
    function sheet1_OnBeforeCheck(Row, Col) {
    	try{
    		sheet1.SetAllowCheck(true);
    		
    		if(sheet1.ColSaveName(Col)	== "chk") {
    			var print_type = sheet1.GetCellValue(Row,"print_type");
    			
    			if(sheet1.GetCellValue(Row,"chk") == "N"){
	    			// 신청 후 연말정산 대상자에서 제외된 경우 출력 불가 
	            	if(sheet1.GetCellValue(Row, "adj_sabun") == null || sheet1.GetCellValue(Row, "adj_sabun") == ""){
	            		alert("연말정산 대상자에 포함되지 않은 사번입니다.\n관리자에게 문의해 주시기 바랍니다.");
	            		sheet1.SetCellValue(Row,"chk","N");
	            		sheet1.SetAllowCheck(false);
	            		return;
	            	}
    			}
    		}
    	} catch(ex) {
            alert("OnChange Event Error : " + ex);
        }
	}
    
	//출력
	function print() {
		var sabuns = "";
		var sortSabuns = "";
		//var sortNos = "";
		var stamps = "";
		var checked = "";
		var searchAllCheck = "";
		var sabunCnt = 0;
		
        if(sheet1.RowCount() != 0) {
	        for(i=1; i<=sheet1.LastRow(); i++) {

	            var chk = sheet1.GetCellValue(i, "chk");

	            if (chk == "Y") {
		
			    	// 귀속년도, 출력구분, 정산구분 확인 후 설정
					var rowWorkYy = sheet1.GetCellValue(i, "work_yy");
			    	var rowPrintType = sheet1.GetCellValue(i, "print_type");
			    	var rowAdjustType = sheet1.GetCellValue(i, "adjust_type");
			    	var equalYn = true;
			    	var rowStampYn = "";
			    	
			    	for(var j = 1; j < sheet1.RowCount()+1; j++) {
						
			    		if(sheet1.GetCellValue(j,"chk") == "Y") {
			    			if(rowWorkYy != sheet1.GetCellValue(j, "work_yy") 
			    					|| rowPrintType != sheet1.GetCellValue(j, "print_type") 
			    					|| rowAdjustType != sheet1.GetCellValue(j, "adjust_type")){
			    				equalYn = false;
			    				break;
			    			}
						}
			    	
			    	}
			    	
			    	if(!equalYn){
			    		alert("귀속년도, 정산구분, 출력구분이 동일한 자료만\n연속출력 가능합니다.");
			    		return;
			    	}else{
			    		
			    		if(rowPrintType == "1"){
		            		rowStampYn = (sheet1.GetCellValue( i, "stamp_yn" ) == "Y") ? "1" : "";
		            	}else if(rowPrintType == "2"){
		            		rowStampYn = (sheet1.GetCellValue( i, "stamp_yn" ) == "Y") ? "1" : "0"; 
		            		rowAdjustType = "9";
		            	}
			    		
			    		$("#srchWorkYy").val(rowWorkYy);
			    		$("#srchPrintType").val(rowPrintType);
			    		$("#srchAdjustType").val(rowAdjustType);
			    	}
	            
	                sabuns += "'"+sheet1.GetCellValue( i, "sabun" ) + "',";
	                sortSabuns += sheet1.GetCellValue( i, "sabun" ) + ",";
	                //sortNos += sheet1.GetCellValue( i, "sort_no" ) + ",";
	                stamps += rowStampYn + ",";
	            }
	        }
			
	        if (sabuns.length > 1) {
				sabuns = sabuns.substr(0,sabuns.length-1);
				sortSabuns = sortSabuns.substr(0,sortSabuns.length-1);
				//sortNos = sortNos.substr(0,sortNos.length-1);
				stamps = stamps.substr(0,stamps.length-1);
	        }

	        if (sabuns.length < 1) {
	            alert("선택된 사원이 없습니다.");
	            return;
	        }
	        
			//call RD!
	        if("1" == $("#srchPrintType").val()){	// 원천징수영수증
	        	withHoldRcptStaPopup(sabuns, sortSabuns, /* sortNos,  */stamps) ;	
			}else if("2" == $("#srchPrintType").val()){	// 원천징수부
				withHoldRcptBkStaPopup(sabuns, sortSabuns, /* sortNos,  */stamps) ;	
			}
				
	    } else {

	        alert("선택된 사원이 없습니다.");
	        return;

	    }

	}

	/**
	 * 출력 window open event (원천징수부)
	 * 레포트 공통에 맞춘 개발 코드 템플릿
	 * by JSG
	 */
	function withHoldRcptBkStaPopup(sabuns, sortSabuns, /* sortNos,  */stamps){
  		var w 		= 1040;
		var h 		= 600;
		var url 	= "<%=jspPath%>/common/rdPopup.jsp";
		var args 	= new Array();
		
		var rdFileNm ;
		if($("#srchWorkYy").val() != "" && ( $("#srchWorkYy").val()*1 ) >= 2008 ){
			rdFileNm		= "EmpWorkIncomeWithholdReceiptBook_"+$("#srchWorkYy").val()+".mrd";
		} else {
			rdFileNm		= "EmpWorkIncomeWithholdReceiptBook.mrd";
		}
		
		var printYmd = "<%=curSysYyyyMMdd%>";
		var bpCd = "ALL";
		var searchAdjustType = $("#srchAdjustType").val();
		var sortNos = "";
		/* var bpCd = $("#searchBusinessPlaceCd").val() ;
		if(bpCd == "") bpCd = "ALL" ; */
		var imgPath = "<%=removeXSS(rdStempImgUrl,"filePathUrl")%>";
		var imgFile = "<%=removeXSS(rdStempImgFile,"fileName")%>";

		args["rdTitle"] = "원천징수부" ;//rd Popup제목
		args["rdMrd"] = "<%=cpnYearEndPath%>/"+ rdFileNm; //( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
		args["rdParam"] = "[<%=removeXSS(session.getAttribute("ssnEnterCd"), "1")%>] ["+$("#srchWorkYy").val()+"] ["+ searchAdjustType +"]"+
						  "["+sabuns+"] [] ["+bpCd+"] [<%=curSysYyyyMMdd%>]" +
						  "[4] ["+sortSabuns+"] ["+sortNos+"] ["+printYmd+"] ["+imgPath+"] ["+imgFile+"] ["+stamps+"]";//rd파라매터
		args["rdParamGubun"] = "rp" ;//파라매터구분(rp/rv)
		args["rdToolBarYn"] = "Y" ;//툴바여부
		args["rdZoomRatio"] = "100" ;//확대축소비율
		args["rdSaveYn"] 	= "Y" ;//기능컨트롤_저장
		args["rdPrintYn"] 	= "Y" ;//기능컨트롤_인쇄
		args["rdExcelYn"] 	= "Y" ;//기능컨트롤_엑셀
		args["rdWordYn"] 	= "Y" ;//기능컨트롤_워드
		args["rdPptYn"] 	= "Y" ;//기능컨트롤_파워포인트
		args["rdHwpYn"] 	= "Y" ;//기능컨트롤_한글
		args["rdPdfYn"] 	= "Y" ;//기능컨트롤_PDF

		if(!isPopup()) {return;}
		var rv = openPopup(url,args,w,h);//알디출력을 위한 팝업창
		
		return (rv != null) ? true : false;
	}
	
	/**
     * 출력 window open event (원천징수영수증)
     * 레포트 공통에 맞춘 개발 코드 템플릿
     * by JSG
     */
    function withHoldRcptStaPopup(sabuns, sortSabuns, /* sortNos,  */stamps){
        var w       = 800;
        var h       = 600;
        var url     = "<%=jspPath%>/common/rdPopup.jsp";
        var args    = new Array();
        // args의 Y/N 구분자는 없으면 N과 같음
        var rdFileNm ;
        if($("#srchWorkYy").val() !=null && ( $("#srchWorkYy").val()*1 ) >= 2007 ){
            rdFileNm        = "WorkIncomeWithholdReceipt_"+$("#srchWorkYy").val()+".mrd";
            /* 
			//원천징수영수증 출력시 2014 이후에는 
			//재정산 이전의 결과를 출력할 수 있도록 별도의 작업(이전)버튼이 존재
			//해당 메뉴에서는 제외
			if(printGbn == "printBk" && ( $("#searchWorkYy").val()*1 ) >= 2014 ) {
				rdFileNm = "WorkIncomeWithholdReceipt_"+$("#searchWorkYy").val()+"reCalc.mrd";	
			} */
        } else {
            rdFileNm        = "WorkIncomeWithholdReceipt.mrd";
        }
        
        var printYmd = "<%=curSysYyyyMMdd%>";
		var bpCd = "ALL";
		var searchAdjustType = $("#srchAdjustType").val();
		var sortNos = "";
        
		var imgPath = '<%=removeXSS(rdStempImgUrl,"filePathUrl")%>';
		var imgFile = '<%=removeXSS(rdStempImgFile,"fileName")%>';

        args["rdTitle"] = "원천징수영수증" ;//rd Popup제목
        args["rdMrd"] = "<%=cpnYearEndPath%>/"+ rdFileNm; //( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
        args["rdParam"] = "[<%=removeXSS(session.getAttribute("ssnEnterCd"), "1")%>]"
                         +"["+$("#srchWorkYy").val()+"]"
                         +"["+ searchAdjustType +"]"
                         +"["+sabuns+"]"
                         +"['']"
                         +"["+bpCd+"]"
                         +"["+$("#searchPurposeCd").val()+"]"
                         +"["+imgPath+"]"
                         +"[4]"
                         +"["+sortSabuns+"]"
                         +"["+sortNos+"]"
                         +"["+$("#searchPageLimit").val()+"]"
                         +"["+printYmd+"]"
                         +"["+ imgFile +"]"
                         +"["+stamps+"]"
                         +"["+$("#searchOption").val()+"]";//rd파라매터
                          
        args["rdParamGubun"] = "rp" ;//파라매터구분(rp/rv)
        args["rdToolBarYn"] = "Y" ;//툴바여부
        args["rdZoomRatio"] = "100" ;//확대축소비율

        <%-- 2011년 이후 연말정산 패치가 될 소지가 있어 아래 로직을 추가 반영한다. 이수화학의 경우, 파일로 저장할 수 없도록 설정한다. 출력만 가능. 2012-02-23 김명주씨 요청사항. --%>
        args["rdSaveYn"]    = '<%=("ISU_CH".equals(removeXSS(session.getAttribute("ssnEnterCd"), "1"))) ? "N" : "Y"%>' ;//기능컨트롤_저장

        args["rdPrintYn"]   = "Y" ;//기능컨트롤_인쇄
        args["rdExcelYn"]   = "Y" ;//기능컨트롤_엑셀
        args["rdWordYn"]    = "Y" ;//기능컨트롤_워드
        args["rdPptYn"]     = "Y" ;//기능컨트롤_파워포인트
        args["rdHwpYn"]     = "Y" ;//기능컨트롤_한글
        args["rdPdfYn"]     = "Y" ;//기능컨트롤_PDF

        if(!isPopup()) {return;}
        var rv = openPopup(url,args,w,h);//알디출력을 위한 팝업창
        return (rv != null) ? true : false;
    }
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
		<!-- 출력정보 -->
        <input type="hidden" id="srchPrintType" 	name="srchPrintType" 	value ="" />
        <input type="hidden" id="srchWorkYy" 		name="srchWorkYy" 		value ="" />
        <input type="hidden" id="srchAdjustType" 	name="srchAdjustType" 	value ="" />
        
        <!-- 원천징수영수증 출력 옵션 -->
        <input type="hidden" id="searchPurposeCd" 	name="searchPurposeCd" 		value ="C" /> <!-- 소득자보관용 -->
        <input type="hidden" id="searchOption" 		name="searchOption" 		value ="N" /> <!-- 미출력 -->
        <input type="hidden" id="searchPageLimit" 	name="searchPageLimit" 		value ="3" /> <!-- 3page 까지 -->
	
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
					    	<span>신청기간</span>
							<input id="searchSYmd" name ="searchSYmd" type="text" class="text"/>
							~
							<input id="searchEYmd" name ="searchEYmd" type="text" class="text"/>
						</td>
						<td>
							<span>사번/성명</span>
							<input id="searchSbNm" name ="searchSbNm" type="text" class="text" maxlength="15" style="width:100px"/>
						</td>
						<td>
							<span>처리상태</span>
							<select id="searchApplStatus" name ="searchApplStatus" onChange="" class="box">
								<option value="">전체</option>
								<option value="21">처리중</option>
								<option value="99">처리완료</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>
							<span>출력구분</span>
							<select id="searchPrintType" name ="searchPrintType" class="box">
								<option value="">전체</option>
								<option value="1">원천징수영수증</option>
								<option value="2">원천징수부</option>
							</select>
						</td>
						<td>
							<span>귀속년도&nbsp;</span>
							<input id="searchWorkYy" name ="searchWorkYy" type="text" class="text required"/>
						</td>
						<td>
							<a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a>
						</td>
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
							<li id="txt" class="txt">승인대상자</li>
							<li class="btn">
								<a href="javascript:doAction1('Down2Template')"   class="basic authA ">양식 다운로드</a>
								<a href="javascript:doAction1('LoadExcel')"   class="basic authA ">업로드</a>
								<a href="javascript:doAction1('Insert')" class="basic authA ">입력</a>
								<a href="javascript:doAction1('Save')"   class="basic authA ">저장</a>
								<a href="javascript:doAction1('Down2Excel')" 	class="basic authA ">다운로드</a>
								<a href="javascript:print();" class="basic authA">출력</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>