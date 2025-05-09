<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>원천징수세액 조정신청</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
    $(function() {

        var initdata1 = {};
        initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
        initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata1.Cols = [
            {Header:"No",			Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
            {Header:"삭제",			Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
            {Header:"상태",			Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
            {Header:"사번",			Type:"Text",		Hidden:1,  Width:100,   Align:"Center",	ColMerge:0, SaveName:"sabun",		KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
            {Header:"SEQ",			Type:"Text",		Hidden:1,  Width:100,   Align:"Center",	ColMerge:0, SaveName:"seq",			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:25 },
            {Header:"신청일자",		Type:"Date",		Hidden:0,  Width:100,   Align:"Center",	ColMerge:0, SaveName:"appl_ymd",	KeyField:0,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:8 },
            {Header:"처리상태",		Type:"Combo",		Hidden:0,  Width:100,   Align:"Center",	ColMerge:0, SaveName:"appl_status",	KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"처리일자",		Type:"Date",		Hidden:0,  Width:100,   Align:"Center",	ColMerge:0, SaveName:"appr_ymd",	KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:8 },
            {Header:"조정년월 ( ~ 부터)",	Type:"Date",		Hidden:0,  Width:100,   Align:"Center",	ColMerge:0, SaveName:"appl_ym",		KeyField:1,   CalcLogic:"",   Format:"Ym",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:6 },
            {Header:"시작일자",		Type:"Date",		Hidden:1,  Width:100,   Align:"Center",	ColMerge:0, SaveName:"sdate",		KeyField:0,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:8 },
            {Header:"종료일자",		Type:"Date",		Hidden:1,  Width:100,   Align:"Center",	ColMerge:0, SaveName:"edate",		KeyField:0,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:8 },
            {Header:"조정세율",		Type:"Combo",		Hidden:0,  Width:100,   Align:"Center",	ColMerge:0, SaveName:"rate",		KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"담당자 특이사항",	Type:"Text",		Hidden:0,  Width:150,   Align:"Left", 	ColMerge:0, SaveName:"memo",		KeyField:0,   CalcLogic:"",   Format:"",  		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"신청서",			Type:"DummyCheck",	Hidden:0,  Width:70,    Align:"Center", ColMerge:0, SaveName:"chk",			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
        ]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);

        sheet1.SetCountPosition(4);

        var applStatus = "";
        var rate = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear="+<%=curSysYear%>, "C00350"), "" );

        sheet1.SetColProperty("rate",    {ComboText:"|"+rate[0], ComboCode:"|"+rate[1]} );
        sheet1.SetColProperty("appl_status",    {ComboText:"|처리중|처리완료", ComboCode:"|21|99"} );

        $("#srchSabun").val( $("#searchUserId").val() );

        $(window).smartresize(sheetResize); sheetInit();

        doAction1("Search");
    });

    //Sheet Action First
    function doAction1(sAction) {
        switch (sAction) {
        case "Search":
            sheet1.DoSearch( "<%=jspPath%>/taxRate/iTaxRateAppRst.jsp?cmd=selectITaxRateApp", $("#srchFrm").serialize(), 1 );
            break;
        case "Save":
        	var applYm = sheet1.GetCellValue(1,"appl_ym");
        	var applYear = applYm.substring(0,4);
        	var rate = sheet1.GetCellValue(1,"rate");
        	
        	if(confirm(applYear+"년도 과세기간종료일(12.31)까지는\n선택한 원천징수방식("+rate+"%)을 변경할 수 없습니다.\n신청 하시겠습니까?")){
        		sheet1.DoSave( "<%=jspPath%>/taxRate/iTaxRateAppRst.jsp?cmd=saveITaxRateApp");
            }
            
            break;
        case "Insert":
        	if(sheet1.GetCellValue(1,"sStatus") != "I") {
            	var newRow = sheet1.DataInsert(0) ;
            	sheet1.SetCellValue(newRow, "sabun",        $("#srchSabun").val());
        	} else {
        		alert("입력 진행중인 건이 있습니다.");
        	}
        	
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
            		sheet1.SetCellEditable(i, "appl_ym", false);
            		sheet1.SetCellEditable(i, "rate", false);
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
        	var applYm =  sheet1.GetCellValue(Row, "appl_ym");
        	var subApplYm = applYm.substring(0,4);
        	
        	if(sheet1.ColSaveName(Col)	== "appl_ym") {
    			var dupYear = Value.substring(0,4);
        		for(var i = 1; i < sheet1.RowCount()+1; i++) {
        			if(Row != i) {
        				var applYear = sheet1.GetCellValue(i, "appl_ym").substring(0,4);
        				if(dupYear == applYear) {
        					if(!confirm("같은년도의 데이터가 존재합니다.\n\n1년 1회에 한하여 변경 가능합니다.\n같은년도 자료가 변경 자료인지 꼭 확인 후 입력 바랍니다.\n\n입력하시겠습니까?"))
        						sheet1.SetCellValue(Row, "appl_ym", "");
        				}
        			}
        		}

        		if(sheet1.GetCellValue(Row, "appl_ym") != "") {
            		sheet1.SetCellValue(Row, "sdate", sheet1.GetCellValue(Row, "appl_ym")+"01");
            		//sheet1.SetCellValue(Row, "edate", "99991231");
            		sheet1.SetCellValue(Row, "edate", subApplYm+"1231");
        		} else {
            		sheet1.SetCellValue(Row, "sdate","");
            		sheet1.SetCellValue(Row, "edate","");
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
	     			alert("처리완료인 상태에서는 삭제할 수 없습니다.");
	     			sheet1.SetAllowCheck(false);
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

    /**
     * 출력 window open event
     * 레포트 공통에 맞춘 개발 코드 템플릿
     * by JSG
     */
	function rdPrint(){

    	var sabunSeq = "";
    	var checkYn = "N";
		for (var i = 1; i < sheet1.RowCount()+1; i++) {
			if (sheet1.GetCellValue(i, "chk") == "1") {
				sabunSeq += "'" + sheet1.GetCellValue(i, "sabun") +""+ sheet1.GetCellValue(i, "seq")+"',";
				checkYn = "Y";
			}
		}

		if (checkYn == "N") {
			alert("선택된 대상이 없습니다.");
			return;
		}

		if (sabunSeq.length > 1) {
			sabunSeq = sabunSeq.substr(0,sabunSeq.length-1);
		} else {
			alert("선택된 대상이 없습니다.");
			return;
		}

		var rdFileNm = "ITaxRateApplication.mrd" ;
		var popupTitle = "소득세 원천징수세액 조정신청서" ;
		//rd option and params setting
		var w 		= 800;
		var h 		= 600;
		var url 	= "<%=jspPath%>/common/rdPopup.jsp";
		var args 	= new Array();
		// args의 Y/N 구분자는 없으면 N과 같음
		var baseDate = "<%=curSysYyyyMMdd%>";
		var imgPath = " " ;
		args["rdTitle"] = popupTitle ;//rd Popup제목
		args["rdMrd"] = "cpn/taxRate/" + rdFileNm;
		//args["rdParam"] = "[<%=removeXSS(session.getAttribute("ssnEnterCd"), '1')%>] ["+$("#searchWorkYy").val()+"] ["+$("#searchAdjustType").val()+"] ['"+$("#searchSabun").val()+"'] ["+baseDate+"]";//rd파라매터
		args["rdParam"] = "P_ENTER_CD[<%=removeXSS(session.getAttribute("ssnEnterCd"), '1')%>] P_SABUN_SEQ["+sabunSeq+"]";

		args["rdParamGubun"] = "rv" ;//파라매터구분(rp/rv)
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
		openPopup(url,args,w,h);//알디출력을 위한 팝업창
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
        <input type="hidden" id="srchSabun" name="srchSabun" value ="" />
    </form>

    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">원천징수세액 조정신청</li>
            <li class="txt"><B><font color="red">* 처리가 완료되면 해당년도 12/31까지는 선택한 원천징수방식(조정세율)을 변경할 수 없습니다. </font></B></li>
            <li class="btn">
            	<a href="javascript:doAction1('Search')" class="button">조회</a>
              	<a href="javascript:doAction1('Insert')" class="basic authA">입력</a>
              	<a href="javascript:doAction1('Save')"   class="basic authA">저장</a>
              	<a href="javascript:rdPrint();" class="basic authA">출력</a>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>