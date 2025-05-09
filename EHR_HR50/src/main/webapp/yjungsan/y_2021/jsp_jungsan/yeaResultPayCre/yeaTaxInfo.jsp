<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>세금조회</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
    var p = eval("<%=popUpStatus%>");
    var arg = p.window.dialogArguments;
    
    $(function() {
        //엑셀,파일다운 시 화면명 저장(교보증권) - 2021.10.26
        $("#menuNm").val($(document).find("title").text()); //엑셀,CURD
        
        var initdata1 = {};
        initdata1.Cfg = {SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:22, DataRowMerge:0};                                                                                                                                                                                              
        initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};                                                                                                                                                                          
        initdata1.Cols = [
            {Header:"No",       Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:1,   SaveName:"sNo" },    
            {Header:"항목유형",   Type:"Text",    Hidden:1,   Width:20,  Align:"Center", ColMerge:1, SaveName:"element_type",  KeyField:0, CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100},
            {Header:"항목코드",   Type:"Text",    Hidden:0,   Width:50,  Align:"Center", ColMerge:1, SaveName:"element_cd",    KeyField:0, CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100},
            {Header:"항목명",    Type:"Text",    Hidden:0,   Width:100,  Align:"Center", ColMerge:1, SaveName:"element_nm",    KeyField:0, CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100}
        ]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);


        $(window).smartresize(sheetResize); sheetInit();
        doAction1("Search");
    });
    $(function() {
        $("#searchElemNm").bind("keyup",function(event){
            if( event.keyCode == 13){ 
                doAction1('Search'); 
            }
        });
    });
    $(function() {
        $(".close").click(function() {
            p.self.close();
        });
    });
    
    //Sheet1 Action
    function doAction1(sAction) {
        switch (sAction) {
        case "Search":
            sheet1.DoSearch("<%=jspPath%>/yeaResultPayCre/yeaResultPayCreRst.jsp?cmd=selectYeaTaxInfoList",$("#sheetForm").serialize());
            break;
        case "Down2Excel":
            var downcol = makeHiddenSkipCol(sheet1);
            var param = {DownCols : downcol,SheetDesign : 1,Merge : 1};
            sheet1.Down2Excel(param);
            break;
        }
    }

    //조회 후 에러 메시지
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {
            alertMessage(Code, Msg, StCode, StMsg);
            sheetResize();
        } catch (ex) {
            alert("OnSearchEnd Event Error : " + ex);
        }
    }
    
    //더블 클릭시 발생
    function sheet1_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
        try{
            var rv = new Array(5);
            rv["element_cd"]    = sheet1.GetCellValue(Row, "element_cd");
            rv["element_nm"]    = sheet1.GetCellValue(Row, "element_nm");        	
        } catch(ex){
            alert("OnDblClick Event Error : " + ex);
        } finally{
        	if(p.popReturnValue) p.popReturnValue(rv);
            p.self.close();
        }
    }

</script>
</head>
<body class="bodywrap">

    <div class="wrapper">
        <div class="popup_title">
            <ul>
                <li>세금항목 조회</li>
            </ul>
        </div>
        <div class="popup_main">
            <form id="sheetForm" name="sheetForm">
            <input type="hidden" id="menuNm" name="menuNm" value="" />            
                <div class="sheet_search outer">
                    <div>
                        <table>
                            <tr>
                                <td><span>항목코드/명 </span>
                                    <input id="searchElemNm" name ="searchElemNm" type="text" class="text" style="width:160px;"/> 
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
                                    <li id="txt" class="txt">항목 조회</li>
                                </ul>
                            </div>
                        </div> 
                        <script type="text/javascript">createIBSheet("sheet1", "100%", "100%");</script>
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
</div>
</body>
</html>