<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>원천징수세액 조정승인</title>
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

	$(function() {
		$("#searchSYmd").datepicker2({startdate:"searchEYmd"});
		$("#searchEYmd").datepicker2({enddate:"searchSYmd"});
		$("#searchApplYm").datepicker2({ymonly:true});
		$("#searchSYmd").val(<%=beforeMonth%>);
		$("#searchEYmd").val("<%=afterMonth%>");
		$("#searchSYmd").mask("1111-11-11");
		$("#searchEYmd").mask("1111-11-11");
		$("#searchApplYm").mask("1111-11");

		$("#searchSbNm,#searchSYmd,#searchEYmd,#searchApplYm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
	});

    $(function() {

        var initdata1 = {};
        initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly, Page:22, FrozenCol:5, DataRowMerge:0};
        initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
        initdata1.Cols = [
            {Header:"No",			Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
            {Header:"삭제",			Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
            {Header:"상태",			Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
            {Header:"사번",			Type:"Text",		Hidden:0,  Width:100,   Align:"Center",	ColMerge:0, SaveName:"sabun",		KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
            {Header:"성명",			Type:"Popup",		Hidden:0,  Width:100,   Align:"Center",	ColMerge:0, SaveName:"name",		KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:13 },
            {Header:"소속",			Type:"Text",		Hidden:0,  Width:100,   Align:"Center",	ColMerge:0, SaveName:"org_nm",		KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
            {Header:"직위",			Type:"Text",		Hidden:1,  Width:100,   Align:"Center",	ColMerge:0, SaveName:"jikwee_nm",	KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
            {Header:"재직상태",		Type:"Text",		Hidden:1,  Width:100,   Align:"Center",	ColMerge:0, SaveName:"status_nm",	KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
            {Header:"SEQ",			Type:"Text",		Hidden:1,  Width:100,   Align:"Center",	ColMerge:0, SaveName:"seq",			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:25 },
            {Header:"신청일자",		Type:"Date",		Hidden:0,  Width:100,   Align:"Center",	ColMerge:0, SaveName:"appl_ymd",	KeyField:0,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:8 },
            {Header:"처리상태",		Type:"Combo",		Hidden:0,  Width:100,   Align:"Center",	ColMerge:0, SaveName:"appl_status",	KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"처리일자",		Type:"Date",		Hidden:0,  Width:100,   Align:"Center",	ColMerge:0, SaveName:"appr_ymd",	KeyField:0,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:8 },
            {Header:"조정년월",		Type:"Date",		Hidden:0,  Width:100,   Align:"Center",	ColMerge:0, SaveName:"appl_ym",		KeyField:1,   CalcLogic:"",   Format:"Ym",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:6 },
            {Header:"조정세율",		Type:"Combo",		Hidden:0,  Width:100,   Align:"Center",	ColMerge:0, SaveName:"rate",		KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"시작일자",		Type:"Date",		Hidden:0,  Width:100,   Align:"Center",	ColMerge:0, SaveName:"sdate",		KeyField:1,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:8 },
            {Header:"종료일자",		Type:"Date",		Hidden:0,  Width:100,   Align:"Center",	ColMerge:0, SaveName:"edate",		KeyField:1,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:8 },
            {Header:"담당자 특이사항",	Type:"Text",		Hidden:0,  Width:150,   Align:"Left", 	ColMerge:0, SaveName:"memo",		KeyField:0,   CalcLogic:"",   Format:"",  		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"신청서",			Type:"DummyCheck",	Hidden:0,  Width:70,    Align:"Center", ColMerge:0, SaveName:"chk",			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
        ]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);

        sheet1.SetCountPosition(4);

        var applStatus = "";
        var rate = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear="+<%=curSysYear%>, "C00350"), "전체" );

        sheet1.SetColProperty("rate",    {ComboText:"|"+rate[0], ComboCode:"|"+rate[1]} );
        sheet1.SetColProperty("appl_status",    {ComboText:"|처리중|처리완료", ComboCode:"|21|99"} );

		$("#searchRate").html(rate[2]);

        $(window).smartresize(sheetResize); sheetInit();

        doAction1("Search");
        
        //양식다운로드 title 정의
		templeteTitle1 += "처리상태 : 21 - 처리중 \n";
		templeteTitle1 += "       99 - 처리완료 \n";
		templeteTitle1 += "조정년월 : YYYYMM \n";
		templeteTitle1 += "조정세율 : 80/100/120 \n";
		templeteTitle1 += "시작/종료일자 : YYYYMMDD \n";
    });

    //Sheet Action First
    function doAction1(sAction) {
        switch (sAction) {
        case "Search":
            sheet1.DoSearch( "<%=jspPath%>/taxRate/iTaxRateAprRst.jsp?cmd=selectITaxRateApr", $("#srchFrm").serialize(), 1 );
            break;
        case "Save":
            sheet1.DoSave( "<%=jspPath%>/taxRate/iTaxRateAprRst.jsp?cmd=saveITaxRateApr");
            break;
        case "Insert":
            var newRow = sheet1.DataInsert(0) ;
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
			var param  = {DownCols:"3|10|12|13|14|15|16",SheetDesign:1,Merge:1,DownRows:'0',ExcelFontSize:"9",TitleText:templeteTitle1,UserMerge :"0,0,1,7"};
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

            for(var i = 1; i < sheet1.RowCount()+1; i++) {
            	if(sheet1.GetCellValue(i,"appl_status") == "99") {
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

    //값이 바뀔때 발생
    function sheet1_OnChange(Row, Col, Value, OldValue) {
        try{
        	var applYm =  sheet1.GetCellValue(Row, "appl_ym"); //조정년월
        	var subApplYm = applYm.substring(0,4);
        	
        	var sdate = sheet1.GetCellValue(Row, "sdate"); //시작일자
        	var edate = sheet1.GetCellValue(Row, "edate"); //종료일자
        	var subEdate = edate.substring(0,4);
        	        	
        	if(sheet1.ColSaveName(Col)	== "appl_ym") {
        		if(sheet1.GetCellValue(Row, "appl_ym") != "") {
            		sheet1.SetCellValue(Row, "sdate", sheet1.GetCellValue(Row, "appl_ym")+"01");
            		//sheet1.SetCellValue(Row, "edate", "99991231");
            		sheet1.SetCellValue(Row, "edate", subApplYm+"1231");
        		} else {
            		sheet1.SetCellValue(Row, "sdate","");
            		sheet1.SetCellValue(Row, "edate","");
        		}
        	}
        	if(sheet1.ColSaveName(Col)=="edate") {
        		if(sdate != "" && edate != ""){
	        		if(sdate > edate){
	        			alert("종료일자는 시작일자보다 커야합니다.");
	        			sheet1.SetCellValue(Row, "edate", "");
	        			return;
	        		}
        		}
        	}
        	if(sheet1.ColSaveName(Col)=="sdate"){
        		if(sdate != "" && edate != ""){
	        		if(sdate > edate){
	        			alert("시작일자는 종료일자보다 작아야합니다.");
	        			sheet1.SetCellValue(Row, "sdate", sheet1.GetCellValue(Row, "appl_ym")+"01");
	        		}
        		}
        	}                	
        } catch(ex) {
            alert("OnChange Event Error : " + ex);
        }
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

		if ( pGubun == "employeePopup" ){
			//사원조회
			sheet1.SetCellValue(gPRow, "name", 		rv["name"] );
			sheet1.SetCellValue(gPRow, "sabun", 	rv["sabun"] );
			sheet1.SetCellValue(gPRow, "org_nm", 	rv["org_nm"] );
			sheet1.SetCellValue(gPRow, "jikwee_nm", rv["jikwee_nm"] );
			sheet1.SetCellValue(gPRow, "status_nm", rv["status_nm"] );
		}
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">

    <form id="srchFrm" name="srchFrm" >
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
				<td>
					<span>조정년월</span>
					<input id="searchApplYm" name ="searchApplYm" type="text" class="text"/>
				</td>
				<td>
					<span>조정세율</span>
					<select id="searchRate" name ="searchRate" class="box"></select>
				</td>
				<td>
					<a href="javascript:doAction1('Search')" class="button">조회</a>
				</td>
			</tr>
        </table>
        </div>
    </div>
    </form>
    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">원천징수세액 조정승인</li>
            <li class="txt"><B><font color="red">* 원칙은 1년단위 신청이지만 종료일자를 '9999-12-31' 할 지속 적용 됨 </font></B></li>
            <li class="btn">
                <a href="javascript:doAction1('Down2Template')"   class="basic authA ">양식 다운로드</a>
                <a href="javascript:doAction1('LoadExcel')"   class="basic authA ">업로드</a>
              	<a href="javascript:doAction1('Insert')" class="basic authA ">입력</a>
              	<a href="javascript:doAction1('Save')"   class="basic authA ">저장</a>
              	<a href="javascript:rdPrint();" class="button authA ">출력</a>
              	<a href="javascript:doAction1('Down2Excel')" 	class="basic authA ">다운로드</a>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>