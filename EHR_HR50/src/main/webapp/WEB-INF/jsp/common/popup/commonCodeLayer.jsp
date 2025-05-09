<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='114485' mdef='코드검색'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<!-- 
include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
 -->


<script type="text/javascript">
    var p = eval("${popUpStatus}");
    
    //var arrParam = window.dialogArguments;
    //var grpCd = arrParam['grpCd']||"";
    //var codeNm = arrParam['codeNm']||"";
    //var note1 = arrParam['note1']||"";
    //var note2 = arrParam['note2']||"";
    //var note3 = arrParam['note3']||"";
    var arg = null ;
    
    $(function() {
    	const modal = window.top.document.LayerModalUtility.getModal('commonCodeLayer');
        arg =  modal.parameters;
        
        var grpCd = arg.grpCd || '';
        var codeNm= arg.codeNm || '';
        var note1 = arg.note1 || '';
        var note2 = arg.note2 || '';
        var note3 = arg.note3 || '';

       // var arg = p.window.dialogArguments;

       /*
        if( arg != undefined ) {
            grpCd = arg['grpCd']||"";
            codeNm= arg['codeNm']||"";
            note1 = arg['note1']||"";
            note2 = arg['note2']||"";
            note3 = arg['note3']||"";
        }else{
            if(p.popDialogArgument("grpCd")!=null)      grpCd   = p.popDialogArgument("grpCd")||"";
            if(p.popDialogArgument("codeNm")!=null)     codeNm      = p.popDialogArgument("codeNm")||"";
            if(p.popDialogArgument("note1")!=null)      note1  = p.popDialogArgument("note1")||"";
            if(p.popDialogArgument("note2")!=null)      note2   = p.popDialogArgument("note2")||"";
            if(p.popDialogArgument("note3")!=null)      note3   = p.popDialogArgument("note3")||"";
        }*/
                
        createIBSheet3(document.getElementById('commonCodeSheet-wrap'), "commonCodeSheet", "100%", "100%", "${ssnLocaleCd}");
        
        var initdata1 = {};
        initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:0, DataRowMerge:0, ChildPage:5, AutoFitColWidth:'init|search|resize|rowtransaction'};
        initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        
        initdata1.Cols = [
            {Header:"<sht:txt mid='sNo' mdef='No'/>",       Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
            {Header:"<sht:txt mid='authScopeCd' mdef='코드'/>",       Type:"Text",        Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"code",        KeyField:0, Format:"",  CalcLogic:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"<sht:txt mid='codeNm' mdef='코드명'/>",       Type:"Text",        Hidden:0,   Width:70,   Align:"Left",   ColMerge:0, SaveName:"codeNm",      KeyField:0, Format:"",  CalcLogic:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='memoV4' mdef='메모'/>",        Type:"Text",        Hidden:1,   Width:70,   Align:"Center", ColMerge:0, SaveName:"memo",        KeyField:0, Format:"",  CalcLogic:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"note1",    Type:"Text",        Hidden:1,   Width:70,   Align:"Center", ColMerge:0, SaveName:"note1",       KeyField:0, Format:"",  CalcLogic:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"note2",    Type:"Text",        Hidden:1,   Width:70,   Align:"Center", ColMerge:0, SaveName:"note2",       KeyField:0, Format:"",  CalcLogic:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"note3",    Type:"Text",        Hidden:1,   Width:70,   Align:"Center", ColMerge:0, SaveName:"note3",       KeyField:0, Format:"",  CalcLogic:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
        ]; IBS_InitSheet(commonCodeSheet, initdata1);commonCodeSheet.SetEditable(false);commonCodeSheet.SetVisible(true);commonCodeSheet.SetCountPosition(4);
        
        commonCodeSheet.FocusAfterProcess = false;
        
        $("#grpCd").val(grpCd);
        $("#codeNm").val(codeNm);
        $("#note1").val(note1);
        $("#note2").val(note2);
        $("#note3").val(note3);
        
        $(window).smartresize(sheetResize); sheetInit();
        doAction1("Search");
    });
    
    $(function() {
        $("#codeNm").bind("keyup",function(event){
            if( event.keyCode == 13){
                doAction1("Search");
            }
        });
        
        $(".close").click(function() {
            p.self.close();
        });
    });
    
    /*Sheet Action*/
    function doAction1(sAction) {
        switch (sAction) {
        case "Search": //조회
            commonCodeSheet.DoSearch( "${ctx}/Popup.do?cmd=getCommonCodePopupList", $("#commonCodeSheetForm").serialize());
            break;
        case "Clear":        //Clear
            commonCodeSheet.RemoveAll();
            break;
        case "Down2Excel":  //엑셀내려받기
            commonCodeSheet.Down2Excel();
            break;
        }
    } 
    
    // 조회 후 에러 메시지 
    function commonCodeSheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try{
            if(Msg != "") alert(Msg);
            sheetResize();
        }catch(ex){
            alert("OnSearchEnd Event Error : " + ex);
        }
    }
    
    // 더블클릭시 발생
    function commonCodeSheet_OnDblClick(Row, Col){
        try{
            returnFindUser(Row,Col);
        }catch(ex){
            alert("OnDblClick Event Error : " + ex);
        }
    }
    
    function returnFindUser(Row,Col){
        
        /*
        var returnValue = new Array(1);
        returnValue["code"] = commonCodeSheet.GetCellValue(Row,"code");
        returnValue["codeNm"] = commonCodeSheet.GetCellValue(Row,"codeNm");
        returnValue["memo"] = commonCodeSheet.GetCellValue(Row,"memo");
        returnValue["note1"] = commonCodeSheet.GetCellValue(Row,"note1");
        returnValue["note2"] = commonCodeSheet.GetCellValue(Row,"note2");
        returnValue["note3"] = commonCodeSheet.GetCellValue(Row,"note3");
        
        //p.window.returnValue = returnValue;
        if(p.popReturnValue) p.popReturnValue(returnValue);
        p.window.close();
        */
        
        const modal = window.top.document.LayerModalUtility.getModal('commonCodeLayer');
        modal.fire('commonCodeTrigger', {
              prgCd : commonCodeSheet.GetCellValue(Row, "prgCd")
            , code : commonCodeSheet.GetCellValue(Row,"code")
            , codeNm : commonCodeSheet.GetCellValue(Row,"codeNm")
            , memo : commonCodeSheet.GetCellValue(Row,"memo")
            , note1 : commonCodeSheet.GetCellValue(Row,"note1")
            , note2 : commonCodeSheet.GetCellValue(Row,"note2")
            , note3 : commonCodeSheet.GetCellValue(Row,"note3")
        }).hide();
    }
    
    function closeLayerModal(){
        const modal = window.top.document.LayerModalUtility.getModal('commonCodeLayer');
        modal.hide();
    }
</script>

</head>
<body class="bodywrap">
    <div class="wrapper modal_layer">
        <div class="modal_body">
            <form id="commonCodeSheetForm" name="commonCodeSheetForm" onsubmit="return false;">
                <input id="grpCd" name="grpCd" type="hidden" value="">
                <input id="note1" name="note1" type="hidden" value="">
                <input id="note2" name="note2" type="hidden" value="">
                <input id="note3" name="note3" type="hidden" value="">
                <div class="sheet_search outer">
                    <div>
                    <table>
                    <tr>
                        <th><tit:txt mid='114486' mdef='코드명'/></th>
                        <td> 
                            <input id="codeNm" name ="codeNm" type="text" class="text" />
                        </td>
                        <td>
                            <a href="javascript:doAction1('Search')" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a>
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
                            <li id="txt" class="txt"><tit:txt mid='113767' mdef='코드조회'/></li>
                        </ul>
                        </div>
                    </div>
                    <div id="commonCodeSheet-wrap"></div>
                    <!-- <script type="text/javascript">createIBSheet("commonCodeSheet", "100%", "100%","${ssnLocaleCd}"); </script> -->
                    </td>
                </tr>
            </table>
        </div>
        <div class="modal_footer">
            <a href="javascript:closeLayerModal();" class="btn outline_gray"><tit:txt mid='104157' mdef='닫기'/></a>
        </div>
    </div>
</body>
</html>



