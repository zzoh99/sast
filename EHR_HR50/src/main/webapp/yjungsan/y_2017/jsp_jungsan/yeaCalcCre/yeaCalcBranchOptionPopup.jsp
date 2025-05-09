<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>대상자기준</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
    var p = eval("<%=popUpStatus%>");
    var zipcodePg = "";
    var codeList;
    
    $(function() {
        
        var arg = p.window.dialogArguments;
        

        if( arg != undefined ) {
            $("#searchWorkYy").val(arg["searchWorkYy"]);        
        }else{
            var searchWorkYy        = "";
            
            searchWorkYy      = p.popDialogArgument("searchWorkYy");
            
            $("#searchWorkYy").val(searchWorkYy);           
        }
        
        var initdata1 = {};
        initdata1.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, DataRowMerge:0};
        initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
        initdata1.Cols = [
            {Header:"No",                    Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
            {Header:"삭제",                  Type:"<%=sDelTy%>",   Hidden:<%=sDelHdn%>,            Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete", Sort:0 },
            {Header:"상태",                  Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus", Sort:0 },
            {Header:"사업장",                Type:"Combo",         Hidden:0,  Width:100,  Align:"Left",          ColMerge:0,   SaveName:"business_place_cd",               KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1 ,  InsertEdit:1,   EditLen:4 },
            {Header:"사업장명",              Type:"Combo",         Hidden:1,  Width:100,  Align:"Left",          ColMerge:0,   SaveName:"business_place_nm",               KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1 ,  InsertEdit:1,   EditLen:4 },
            {Header:"주사업장등록번호",      Type:"Text",          Hidden:0,  Width:100,  Align:"Center",        ColMerge:0,   SaveName:"regino",                          KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10},
            {Header:"단위과세여부",          Type:"CheckBox",      Hidden:0,  Width:100,  Align:"Center",        ColMerge:0,   SaveName:"tax_grp_yn",                      KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"종사업자일련번호",      Type:"Text",          Hidden:0,  Width:100,  Align:"Center",        ColMerge:0,   SaveName:"sub_regino",                      KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10},
            {Header:"시작일",                Type:"Date",          Hidden:0,  Width:100,  Align:"Center",        ColMerge:0,   SaveName:"sdate",                           KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"종료일",                Type:"Date",          Hidden:0,  Width:100,  Align:"Right",         ColMerge:0,   SaveName:"edate",                           KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 }

        ]; IBS_InitSheet(sheet1, initdata1);  sheet1.SetEditable("<%=editable%>"); sheet1.SetCountPosition(4);
        
        <%
        if(!"SH".equals(session.getAttribute("ssnEnterCd")) && !"GT".equals(session.getAttribute("ssnEnterCd")) && !"FMS".equals(session.getAttribute("ssnEnterCd"))){
        %>
        codeList = codeList("<%=jspPath%>/yeaCalcCre/yeaCalcBranchOptionPopupRst.jsp?cmd=selectBranchPlaceCdList", "");
        <%
        }else{
        %>
        codeList = codeList("<%=jspPath%>/yeaCalcCre/yeaCalcBranchOptionPopupRst.jsp?cmd=selectBranchPlaceCdList_SH", "");
        <%
        }
        %>
        
        var payPeopleStatusList = stfConvCode(codeList , "");
        
        sheet1.SetColProperty("business_place_cd",    {ComboText:payPeopleStatusList[0], ComboCode:payPeopleStatusList[1]} );
        
        $(window).smartresize(sheetResize); sheetInit();
        
        var data = ajaxCall("<%=jspPath%>/yeaCalcCre/yeaCalcBranchOptionPopupRst.jsp?cmd=selectBranchDt",$("#sheetForm").serialize(),false);
        
        $("#searchYMD").val(data.dtList[0].ord_eymd.substring(0,4) + "-" + data.dtList[0].ord_eymd.substring(4,6) + "-" + data.dtList[0].ord_eymd.substring(6,8));
        
        
        doAction1("Search");
    });

    $(function(){
        $(".close").click(function() {
            p.self.close();
        });
    });
    
    /*Sheet Action*/
    function doAction1(sAction) {
        switch (sAction) {
        case "Insert":
        	var newRow = sheet1.DataInsert(0);
        	sheet1.SetCellValue(newRow, "business_place_nm", sheet1.GetCellText(newRow, "business_place_cd"));
            break;
        case "Copy":
        	var newRow = sheet1.DataCopy();
            sheet1.SelectCell(newRow, 2);
            break;
        case "Search":      //조회
            
            <%
            if(!"SH".equals(session.getAttribute("ssnEnterCd")) && !"GT".equals(session.getAttribute("ssnEnterCd")) && !"FMS".equals(session.getAttribute("ssnEnterCd"))){
            %>
            sheet1.DoSearch( "<%=jspPath%>/yeaCalcCre/yeaCalcBranchOptionPopupRst.jsp?cmd=selectBranchOptionList", $("#sheetForm").serialize());
            <%
            }else{
            %>
            sheet1.DoSearch( "<%=jspPath%>/yeaCalcCre/yeaCalcBranchOptionPopupRst.jsp?cmd=selectBranchOptionList_SH", $("#sheetForm").serialize());
            <%
            }
            %>
            break;
        case "Save":        //저장
            sheet1.DoSave( "<%=jspPath%>/yeaCalcCre/yeaCalcBranchOptionPopupRst.jsp?cmd=saveBranchOption"); 
            break;
        case "Down2Excel":
            var downcol = makeHiddenSkipCol(sheet1);
            var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
            sheet1.Down2Excel(param); 
            break;
        }
    } 

    //조회 후 에러 메시지 
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {
            alertMessage(Code, Msg, StCode, StMsg);
            
            if(Code == 1) {
                for(var i = 1; i < sheet1.RowCount()+1; i++) {
                }
            }
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
                doAction1("Search") ;
                //return
                if(p.popReturnValue) p.popReturnValue("");
            }
        } catch (ex) { 
            alert("OnSaveEnd Event Error " + ex); 
        }
    }
    
    //값이 바뀔때 발생
    function sheet1_OnChange(Row, Col, Value, OldValue) {
        try { 
        	if(sheet1.ColSaveName(Col) == "business_place_cd") {
                sheet1.SetCellValue(Row, "business_place_nm", sheet1.GetCellText(Row, Col));
                
                for(var i = 0 ; i < codeList.length ; i++) {
                	if(codeList[i].code == sheet1.GetCellValue(Row, Col)){
                		sheet1.SetCellValue(Row, "regino", codeList[i].regino);
                	}
                }
        	}
        } catch (ex) { 
            alert("OnChange Event Error " + ex); 
        }
    } 
    
    function sheet1_OnValidation(Row, Col, Value) {
        try { 
            if(sheet1.GetCellValue(Row, "regino") == "" || sheet1.GetCellValue(Row, "regino").length != 10) {
                alert("주 사업자 등록번호를 확인하시기 바랍니다.");
                sheet1.ValidateFail(2);
            }
            if(sheet1.GetCellValue(Row, "sub_regino") == "" || sheet1.GetCellValue(Row, "sub_regino").length != 4) {
                alert("종 사업자 등록번호를 확인하시기 바랍니다.");
                sheet1.ValidateFail(2);
            }
            if(sheet1.GetCellValue(Row, "sdate") == "") {
                alert("시작일자를 입력하시기 바랍니다.");
                sheet1.ValidateFail(2);
            }
            if(sheet1.GetCellValue(Row, "edate") == "" || sheet1.GetCellValue(Row, "sdate") >= sheet1.GetCellValue(Row, "edate")) {
                alert("종료일자를 입력하시기 바랍니다.");
                sheet1.ValidateFail(2);
            }
            
            var arrCol = sheet1.ColValueDupRows("sub_regino|sdate", false, true).split("|");
            
            if (arrCol[1] && arrCol[1] != "") {
            	alert("종 사업자일련번호와 시작일자가 중복되었습니다.");
            	sheet1.ValidateFail(2);
            }
        } catch (ex) { 
            alert("OnValidation Event Error " + ex); 
        }
    }
</script>

</head>
<body class="bodywrap">
<form id="sheetForm" name="sheetForm" >
    <input type="hidden" id="searchWorkYy" name="searchWorkYy" value="" />
    <input type="hidden" id="searchAdjustType" name="searchAdjustType" value="" />
    <input type="hidden" id="searchPayActionCd" name="searchPayActionCd" value="">
    <div class="wrapper">
        <div class="popup_title">
        <ul>
            <li id="strTitle">사업자 단위과세자 관리</li>
            <!-- <li class="close"></li>  -->
        </ul>
        </div>
    
        <div class="popup_main">
            <table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
                <tr>
                    <td class="top">
                        <div class="outer">
                            <div class="sheet_title">
                                <ul>
                                    <li id="strSheetTitle" class="txt">
                                        <span>* 사업자 단위과세자인 경우 관련 정보를 입력하여 주시기 바랍니다.</span>
                                    </li>
                                    <li class="btn">
                                        <b>기준일자 </b>
                                        <input id="searchYMD" name ="searchYMD" type="text" class="text" "/>
                                        <a href="javascript:doAction1('Search')"        class="basic authA">조회</a>
                                        <a href="javascript:doAction1('Insert')"        class="basic authA">입력</a>
                                        <a href="javascript:doAction1('Copy')"          class="basic authA">복사</a>
                                        <a href="javascript:doAction1('Save')"          class="basic authA">저장</a>
                                        <a href="javascript:doAction1('Down2Excel')"    class="basic authR">다운로드</a>
                                    </li>
                                </ul>
                            </div>
                        </div>
                        <script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script>
                    </td>
                </tr>
            </table>
            <div class="popup_button outer">
                <ul>
                    <li>
                        <a href="javascript:p.self.close();" class="gray large">닫기</a>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</form>
</body>
</html>



