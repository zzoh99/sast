<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>종전근무지 기타소득</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%String ssnSearchType = (String)session.getAttribute("ssnSearchType");%>
<script type="text/javascript">
    var templeteTitle1 = "업로드시 이 행은 삭제 합니다\n\n";

    $(function() {  

        var initdata = {};
        initdata.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
        initdata.Cols = [
            {Header:"No",              Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",    Align:"Center", ColMerge:0, SaveName:"sNo" },
            {Header:"년도",            Type:"Text",        Hidden:0,  Width:50,    Align:"Center", ColMerge:1,   SaveName:"work_yy",           KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:4 },
            {Header:"정산구분",        Type:"Combo",       Hidden:0,  Width:70,    Align:"Center", ColMerge:1,   SaveName:"adjust_type",       KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:160 },
            {Header:"부서명",          Type:"Text",        Hidden:0,  Width:70,    Align:"Center", ColMerge:1,   SaveName:"org_nm",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:160 },
            {Header:"성명",            Type:"Popup",       Hidden:0,  Width:70,    Align:"Center", ColMerge:1,   SaveName:"name",              KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:160 },
            {Header:"사번",            Type:"Text",        Hidden:0,  Width:70,    Align:"Center", ColMerge:1,   SaveName:"sabun",             KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:160 },
            {Header:"근무처명",        Type:"Text",        Hidden:0,  Width:80,    Align:"Left",   ColMerge:0,   SaveName:"enter_nm",          KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"사업자등록번호",  Type:"Text",        Hidden:0,  Width:120,   Align:"Center", ColMerge:0,   SaveName:"enter_no",          KeyField:1,   CalcLogic:"",   Format:"SaupNo",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"소득구분명",      Type:"Combo",       Hidden:0,  Width:145,   Align:"Left",   ColMerge:1,   SaveName:"adj_element_cd",    KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:160 },
            {Header:"비과세액or감면세액",        Type:"AutoSum",     Hidden:0,  Width:110,   Align:"Right",  ColMerge:1,   SaveName:"notax_mon",         KeyField:0,   CalcLogic:"",   Format:"Integer", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:160 }
        ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);
        
        sheet1.SetCountPosition(4);
        
        //작업구분
        var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00303"), "전체");
        var adjTypeCmbList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&srchWorkYy="+$("#srchYear").val(),"getYearEndItemList") , "전체");

    	// 사업장(권한 구분)
    	var ssnSearchType  = "<%=removeXSS(ssnSearchType, '1')%>";
    	var bizPlaceCdList = "";
    	
    	if(ssnSearchType == "A"){
    		bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getBizPlaceCdList","",false).codeList, "전체");	
    	}else{
    		bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getBizPlaceCdAuthList&queryId=getBizPlaceCdAuthList","",false).codeList, "");
    	}        
                
        $("#searchBizPlaceCd").html(bizPlaceCdList[2]); 
           
        sheet1.SetColProperty("adj_element_cd", {ComboText:"|"+adjTypeCmbList[0], ComboCode:"|"+adjTypeCmbList[1]} );
        sheet1.SetColProperty("adjust_type",    {ComboText:"|"+adjustTypeList[0], ComboCode:"|"+adjustTypeList[1]});
        
        $("#srchAdjustType").html(adjustTypeList[2]).val("1");
        $("#srchIncomeType").html(adjTypeCmbList[2]);
        
        $(window).smartresize(sheetResize); sheetInit();
        doAction1("Search");

        //양식다운로드 title 정의
        var codeCdNm = "", codeCd = "", codeNm = "";
        
        codeCdNm = "";
        codeNm = adjustTypeList[0].split("|"); codeCd = adjustTypeList[1].split("|");
        for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
        templeteTitle1 += "정산구분 : " + codeCdNm + "\n";

        codeCdNm = "";
        codeNm = adjTypeCmbList[0].split("|"); codeCd = adjTypeCmbList[1].split("|");
        for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
        templeteTitle1 += "소득구분명 : " + codeCdNm + "\n";
        
        templeteTitle1 += "지급월 : YYYY-MM   예)2013-01 \n";
    });
    
    $(function() {  

        $("#srchYear").bind("keyup",function(event){
            makeNumber(this,"A");
            if( event.keyCode == 13){ 
                doAction1("Search");
            }
            
            if( $("#srchYear").val().length == 4 ) {
                var adjTypeCmbList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&srchWorkYy="+$("#srchYear").val(),"getYearEndItemList") , "전체"); 
                $("#srchIncomeType").html(adjTypeCmbList[2]);
                sheet1.SetColProperty("adj_element_cd", {ComboText:"|"+adjTypeCmbList[0], ComboCode:"|"+adjTypeCmbList[1]} );       
            }
        });

        $("#srchSbNm").bind("keyup",function(event){
            if( event.keyCode == 13){ 
                doAction1("Search");
            }
        });
        
    });
    
    //Sheet1 Action
    function doAction1(sAction) {
        switch (sAction) {
        case "Search":   
            var param = "cmd=search&"+$("#srchFrm").serialize();
            sheet1.DoSearch( "<%=jspPath%>/befYearEtcMgr/befYearEtcMgrRst.jsp", param );
            break;
        case "Save":        
            // 중복체크
            if (!dupChk(sheet1, "work_yy|adjust_type|sabun|adj_element_cd|ym", true, true)) {break;}
            sheet1.DoSave( "<%=jspPath%>/befYearEtcMgr/befYearEtcMgrRst.jsp","cmd=save"); 
            break;
        case "Insert":
        	
        	if(chkRqr()){
	       		 break;
	       	}
        	
            var Row = sheet1.DataInsert(0) ;
            sheet1.SetCellValue(Row, "work_yy", $("#srchYear").val() ) ;
            sheet1.SetCellValue(Row, "adjust_type", $("#srchAdjustType").val() ) ;
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
            var param  = {DownCols:"3|4|5|6|7|8|9|10|11|12",SheetDesign:1,Merge:1,DownRows:'0',ExcelFontSize:"9"
                                    ,TitleText:templeteTitle1,UserMerge :"0,0,1,10"};
            sheet1.Down2Excel(param); 
            break;
        case "LoadExcel":  
        	
        	if(chkRqr()){
	       		 break;
	       	}
        	
            var params = {Mode:"HeaderMatch", WorkSheetNo:1}; 
            sheet1.LoadExcel(params); 
            break;
        }
    }
    
    function chkRqr(){
        
        var chkSearchAdjustType    = $("#srchAdjustType").val();
        
        var chkValue = false;
        
        if(chkSearchAdjustType == ''){
            alert("정산구분을 선택 후 입력 할 수 있습니다.");
            chkValue = true;
        }
        
        return chkValue;
    }
    
    // 조회 후 에러 메시지
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try { 
            alertMessage(Code, Msg, StCode, StMsg);
            sheetResize();
        } catch(ex) { 
            alert("OnSearchEnd Event Error : " + ex); 
        }
    }
    
    // 저장 후 메시지
    function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try {
            alertMessage(Code, Msg, StCode, StMsg);
            if(Code == 1) {
                doAction1('Search'); 
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

    function sheet1_OnChange(Row, Col, Value) {
        try{
            if(Row > 0 && (sheet1.ColSaveName(Col) == "mon" || sheet1.ColSaveName(Col) == "notax_mon")){
                var mon         = 0;
                var noTaxMon    = 0;
                if(sheet1.GetCellValue(Row, "mon") != ""){
                    mon = parseInt(sheet1.GetCellValue(Row, "mon"), 10);
                }
                if(mon == 0){
                    sheet1.SetCellValue(Row, "notax_mon", "0") ;
                    sheet1.SetCellValue(Row, "tax_mon", "0") ;
                } else {
                    if(sheet1.GetCellValue(Row, "notax_mon") != ""){
                        noTaxMon = parseInt(sheet1.GetCellValue(Row, "notax_mon"), 10);
                    }
                    if(mon < noTaxMon){
                        alert("총액액보다 비과세액이 큽니다.");
                        sheet1.SetCellValue( Row, "notax_mon", "0" ) ;
                        noTaxMon = 0;
                    }
                    sheet1.SetCellValue( Row, "tax_mon", (mon - noTaxMon) ) ;
                }
            }
        } catch(ex) {
            alert("OnChange Event Error : " + ex);
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
         /*
            if(rv!=null){
                sheet1.SetCellValue(Row, "name",        rv["name"] );
                sheet1.SetCellValue(Row, "sabun",       rv["sabun"] );
                sheet1.SetCellValue(Row, "org_nm",      rv["org_nm"] );
            }
         */
        } catch(ex) {
            alert("Open Popup Event Error : " + ex);
        }
    }
    
    function getReturnValue(returnValue) {

        var rv = $.parseJSON('{'+ returnValue+'}');

        if ( pGubun == "employeePopup" ){
            //사원조회
            sheet1.SetCellValue(gPRow, "name",      rv["name"] );
            sheet1.SetCellValue(gPRow, "sabun",     rv["sabun"] );
            sheet1.SetCellValue(gPRow, "org_nm",    rv["org_nm"] );
        }
    }
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
    <form id="srchFrm" name="srchFrm" >
        <input type="hidden" id="srchOrgCd" name="srchOrgCd" value =""/>
        <div class="sheet_search outer">
            <div>
                <table>
                    <tr>
                        <td>
                            <span>년도</span>
							<%
							if(!"SH".equals(session.getAttribute("ssnEnterCd")) && !"GT".equals(session.getAttribute("ssnEnterCd")) && !"FMS".equals(session.getAttribute("ssnEnterCd")) && !"CSM".equals(session.getAttribute("ssnEnterCd")) && !"SHN".equals(session.getAttribute("ssnEnterCd"))){
							%>
								<input id="srchYear" name ="srchYear" type="text" class="text" maxlength="4" style="width:35px" value="<%=yeaYear%>" />
							<%}else{%>
								<input id="srchYear" name ="srchYear" type="text" class="text readonly" maxlength="4" style="width:35px" value="<%=yeaYear%>" readonly/>
							<%}%>                                                        
                        </td>
                        <td>
                            <span>작업구분</span>
                            <select id="srchAdjustType" name ="srchAdjustType" onChange="javascript:doAction1('Search')" class="box"></select> 
                        </td>
                        <td>
                            <span>구분</span>
                            <select id="srchIncomeType" name ="srchIncomeType" onChange="javascript:doAction1('Search')" class="box"></select> 
                        </td>
                        <td>
                            <span>사업장</span>
                            <select id="searchBizPlaceCd" name ="searchBizPlaceCd" class="box" onChange="javascript:doAction1('Search')"></select>
                        </td>
                        <td>
                            <span>사번/성명</span>
                            <input id="srchSbNm" name ="srchSbNm" type="text" class="text" maxlength="15" style="width:100px"/>
                        </td>
                        <td> 
                            <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a> 
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </form>
    
    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li id="txt" class="txt">종전근무지 기타소득</li>
            <li class="btn">
                <a href="javascript:doAction1('Down2Excel')"    class="basic authA">다운로드</a>
            </li>
        </ul>
        </div>
    </div>
    
    <script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>