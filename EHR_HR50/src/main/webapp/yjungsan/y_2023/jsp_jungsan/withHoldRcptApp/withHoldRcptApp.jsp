<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>원천징수영수증/징수부 신청</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

	// 조회, 입력 가능한 최소 년도
	var mininumYear = "2013";

	$(function() {
		$("#searchWorkYy").mask("1111");

		$("#searchWorkYy").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
	});

    $(function() {

        var initdata1 = {};
        initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
        initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata1.Cols = [
            {Header:"No",			Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
            {Header:"삭제",			Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
            {Header:"상태",			Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
            {Header:"사번",			Type:"Text",		Hidden:1,  Width:60,    Align:"Center",	ColMerge:0, SaveName:"sabun",		KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
            {Header:"SEQ",			Type:"Text",		Hidden:1,  Width:80,    Align:"Center",	ColMerge:0, SaveName:"seq",			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:25 },
            {Header:"신청일자",		Type:"Date",		Hidden:0,  Width:100,   Align:"Center",	ColMerge:0, SaveName:"appl_ymd",	KeyField:0,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:8 },
            {Header:"처리상태",		Type:"Combo",		Hidden:0,  Width:80,    Align:"Center",	ColMerge:0, SaveName:"appl_status",	KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"처리일자",		Type:"Date",		Hidden:0,  Width:100,   Align:"Center",	ColMerge:0, SaveName:"appr_ymd",	KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:8 },
            {Header:"귀속년도",		Type:"Int",			Hidden:0,  Width:100,   Align:"Center",	ColMerge:0, SaveName:"work_yy",		KeyField:1,   CalcLogic:"",   Format:"####",    PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:4 },
            {Header:"출력구분",		Type:"Combo",		Hidden:0,  Width:100,   Align:"Center",	ColMerge:0, SaveName:"print_type",	KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:8 },
            {Header:"정산구분",		Type:"Combo",		Hidden:0,  Width:70,    Align:"Center",	ColMerge:0, SaveName:"adjust_type",	KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:13 },
            {Header:"출력여부",		Type:"Combo",		Hidden:0,  Width:100,   Align:"Center",	ColMerge:0, SaveName:"print_yn",	KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:8 },
            {Header:"도장출력",		Type:"Text",		Hidden:1,  Width:100,   Align:"Center",	ColMerge:0, SaveName:"stamp_yn",	KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:8 },
            {Header:"출력",			Type:"DummyCheck",	Hidden:0,  Width:70,    Align:"Center", ColMerge:0, SaveName:"chk",			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100, TrueValue:"Y", FalseValue:"N" },
            {Header:"대상자사번",	Type:"Text",		Hidden:1,  Width:70,    Align:"Center", ColMerge:0, SaveName:"adj_sabun",	KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100}
        ]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);

        sheet1.SetCountPosition(4);

        var applStatus = "";
        sheet1.SetColProperty("appl_status",    {ComboText:"|처리중|처리완료", ComboCode:"|21|99"} );
        sheet1.SetColProperty("print_type",     {ComboText:"원천징수영수증|원천징수부", ComboCode:"1|2"} );
        sheet1.SetColProperty("print_yn",       {ComboText:"출력|미출력", ComboCode:"Y|N"} );

        var purposeCdList   = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00315"), "");
        $("#searchPurposeCd").html(purposeCdList[2]);

        var adjustTypeList 	= stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00303"), "");
        sheet1.SetColProperty("adjust_type",    {ComboText:"|"+adjustTypeList[0], ComboCode:"|"+adjustTypeList[1]} );

        $("#srchSabun").val( $("#searchUserId").val() );

        $(window).smartresize(sheetResize); sheetInit();

        doAction1("Search");
    });

    //Sheet Action First
    function doAction1(sAction) {
        switch (sAction) {
        case "Search":

        	var srchWorkYy = $("#searchWorkYy").val();
        	if( Number(srchWorkYy) < mininumYear ){
        		alert(mininumYear + "년 이후의 자료만 신청/조회 가능합니다.");
        		return;
        	}
        	$("#srchWorkYy").val(srchWorkYy);

            sheet1.DoSearch( "<%=jspPath%>/withHoldRcptApp/withHoldRcptAppRst.jsp?cmd=selectWithHoldRcptAppList", $("#srchFrm").serialize(), 1 );
            break;
        case "Save":

        	for(var i = 1; i < sheet1.RowCount()+1; i++) {
             	if(sheet1.GetCellValue(i,"print_type") == "1" && sheet1.GetCellValue(i,"adjust_type") == "") {
             		alert("출력구분이 원천징수영수증일 경우, \n정산구분은 필수 입력 항목 입니다.");
             		return;
             	}
        	}

       		sheet1.DoSave("<%=jspPath%>/withHoldRcptApp/withHoldRcptAppRst.jsp?cmd=saveWithHoldRcptApp");
            break;
        case "Insert":
           	var newRow = sheet1.DataInsert(0) ;
           	sheet1.SetCellValue(newRow, "sabun",        $("#srchSabun").val());
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
        }
    }

    // 조회 후 에러 메시지
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {
            alertMessage(Code, Msg, StCode, StMsg);
            sheetResize();

            for(var i = 1; i < sheet1.RowCount()+1; i++) {
            	if(sheet1.GetCellValue(i,"appl_status") == "99") {
            		sheet1.SetCellEditable(i, "work_yy", false);
            		sheet1.SetCellEditable(i, "print_type", false);
            		sheet1.SetCellEditable(i, "chk", true);
            	}
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

    		if(sheet1.ColSaveName(Col)	== "sDelete") {
		    	if(sheet1.GetCellValue(Row,"sDelete") == "0" && sheet1.GetCellValue(Row,"appl_status") == "99") {
	     			alert("처리완료된 신청은 삭제할 수 없습니다.");
	     			sheet1.SetAllowCheck(false);
		    	}
    		}

    		if(sheet1.ColSaveName(Col)	== "chk") {
    			var print_type = sheet1.GetCellValue(Row,"print_type");
    			var adjust_type = sheet1.GetCellValue(Row,"adjust_type");

    			if(sheet1.GetCellValue(Row,"chk") == "N"){

	    			// 기출력여부확인
	    			if(sheet1.GetCellValue(Row,"print_yn") == "Y"){
	    				alert("이미 출력된 양식입니다.\n관리자에게 문의해 주시기 바랍니다.");
	    				sheet1.SetCellValue(Row,"chk","N");
	    				sheet1.SetAllowCheck(false);
						return;
	    			}

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

    // 헤더에서 호출
    function setEmpPage() {
        $("#srchSabun").val( $("#searchUserId").val() );
        doAction1("Search");
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

	            	// 이미 출력된 양식은 재출력 불가
	            	if(sheet1.GetCellValue(i, "print_yn") == "Y"){
	            		alert("이미 출력된 양식입니다.\n관리자에게 문의해 주시기 바랍니다.");
	            		sheet1.SetCellValue(i, "chk", "N");
	            		return;
	            	}

	            	// 귀속년도, 출력구분, 정산구분 확인 후 파라미터 설정
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

	            	// 출력 안내문구
	            	if(!confirm("한번 출력된 양식은 다시 출력하실 수 없습니다.\n출력하시겠습니까?")){
	            		return;
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

	        var rdResult = null;

			//call RD!
	        if("1" == $("#srchPrintType").val()){	// 원천징수영수증
	        	rdResult = withHoldRcptStaPopup(sabuns, sortSabuns, /* sortNos,  */stamps) ;
			}else if("2" == $("#srchPrintType").val()){	// 원천징수부
				rdResult = withHoldRcptBkStaPopup(sabuns, sortSabuns, /* sortNos,  */stamps) ;
			}

			if(rdResult){
		      	//출력여부 변경
		        for(i=1; i<=sheet1.LastRow(); i++) {

		            var chk = sheet1.GetCellValue(i, "chk");

		            if (chk == "Y") {
				        var param =   "sabun="		+ sheet1.GetCellValue( i, "sabun" )
									+ "&seq="		+ sheet1.GetCellValue( i, "seq" );

						var result = ajaxCall("<%=jspPath%>/withHoldRcptApp/withHoldRcptAppRst.jsp?cmd=updateWithHoldRcptPrintYn",param,false);
						if(result.Result.Code == "1"){
							sheet1.SetCellValue(i, "print_yn", "Y");
							sheet1.SetCellValue(i, "sStatus", "R");	// 출력여부 저장 후 리스트 데이터만 수정된 것이므로 시트 상태변경 없음.
						}
		            }
		        }
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
		var imgPath = '<%=removeXSS(rdStempImgUrl,"filePathUrl")%>';
		var imgFile = '<%=removeXSS(rdStempImgFile,"fileName")%>';

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

        var imgPath = "<%=removeXSS(rdStempImgUrl,"filePathUrl")%>";
        var imgFile = "<%=removeXSS(rdStempImgFile,"fileName")%>";

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

	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{'+ returnValue+'}');
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">

    <%@ include file="../common/include/employeeHeaderYtax.jsp"%>

    <form id="srchFrm" name="srchFrm" >
		<!-- 출력정보 -->
        <input type="hidden" id="srchSabun" 		name="srchSabun" 		value ="" />
        <input type="hidden" id="srchPrintType" 	name="srchPrintType" 	value ="" />
        <input type="hidden" id="srchWorkYy" 		name="srchWorkYy" 		value ="" />
        <input type="hidden" id="srchAdjustType" 	name="srchAdjustType" 	value ="" />

        <!-- 원천징수영수증 출력 옵션 -->
        <input type="hidden" id="searchPurposeCd" 	name="searchPurposeCd" 		value ="C" /> <!-- 소득자보관용 -->
        <input type="hidden" id="searchOption" 		name="searchOption" 		value ="N" /> <!-- 미출력 -->
        <input type="hidden" id="searchPageLimit" 	name="searchPageLimit" 		value ="3" /> <!-- 3page 까지 -->
 	</form>
    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">원천징수영수증/징수부 신청</li>
            <li class="btn">
            	<strong>귀속년도:</strong>&nbsp;&nbsp;<input class="text center required" type="text" id="searchWorkYy" name="searchWorkYy" size="4" maxlength= "4"  value="<%=yeaYear%>" />
            	<a href="javascript:doAction1('Search')" class="button">조회</a>
              	<a href="javascript:doAction1('Insert')" class="basic authA">입력</a>
              	<a href="javascript:doAction1('Save')"   class="basic authA">저장</a>
              	<a href="javascript:print();" class="basic authA">출력</a>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>