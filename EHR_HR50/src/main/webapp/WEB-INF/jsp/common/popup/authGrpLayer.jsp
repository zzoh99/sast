<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='114502' mdef='직무 리스트 조회'/></title>

<script type="text/javascript">
    var jobTypeDisp = 0;
    $(function() {
        var modal = window.top.document.LayerModalUtility.getModal('authGrpLayer');
        createIBSheet3(document.getElementById('authGrpLayerSheet-wrap'), "authGrpLayerSheet", "100%", "100%", "${ssnLocaleCd}");
        if( modal != undefined ) {
        }

        //배열 선언
        var initdata = {};
        //SetConfig
        initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:6, DataRowMerge:0, AutoFitColWidth:'init|search|resize|rowtransaction'};
        //HeaderMode
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        //InitColumns + Header Title
        initdata.Cols = [
                {Header:"<sht:txt mid='sNo' mdef='No'/>",                 Type:"${sNoTy}", Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },

                {Header:"<sht:txt mid='grpCd' mdef='그룹코드'/>",    Type:"Text",    Hidden:0,    Width:60,    Align:"Center",    ColMerge:0,    SaveName:"grpCd",    KeyField:1,    CalcLogic:"",    Format:"",               PointCount:0,    UpdateEdit:0,    InsertEdit:0,    EditLen:10 },
                {Header:"<sht:txt mid='grpNm' mdef='그룹명'/>",      Type:"Text",    Hidden:0,    Width:300,    Align:"Left",      ColMerge:0,    SaveName:"grpNm",    KeyField:1,    CalcLogic:"",    Format:"",               PointCount:0,    UpdateEdit:0,    InsertEdit:0,    EditLen:100 },
                {Header:"<sht:txt mid='seq'   mdef='순서'/>",          Type:"Int",     Hidden:1,    Width:100,    Align:"Center",    ColMerge:0,    SaveName:"seq",      KeyField:0,    CalcLogic:"",    Format:"NullInteger",    PointCount:0,    UpdateEdit:0,    InsertEdit:0,    EditLen:3 }
        ];
        IBS_InitSheet(authGrpLayerSheet, initdata);authGrpLayerSheet.SetVisible(true);authGrpLayerSheet.SetCountPosition(4);authGrpLayerSheet.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

        $(window).smartresize(sheetResize); sheetInit();

        var sheetHeigth = $(".modal_body").height() - $("#mySheetForm").height() -  $(".sheet_title").height() -2;
        authGrpLayerSheet.SetSheetHeight(sheetHeigth);

        doAction("Search");

        $(".close").click(function() {
            closeCommonLayer('authGrpLayerSheet');
        });
    });

    /*Sheet Action*/
    function doAction(sAction) {
        switch (sAction) {
        case "Search":         //조회
            authGrpLayerSheet.DoSearch( "${ctx}/Popup.do?cmd=getAuthGrpPopupList", $("#mySheetForm").serialize() );
            break;
        }
    }

    //조회 후 에러 메시지
    function authGrpLayerSheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {
            if(Msg != "") alert(Msg);
            sheetResize();
        } catch (ex) {
            alert("OnSearchEnd Event Error : " + ex);
        }
    }

    function authGrpLayerSheet_OnDblClick(Row, Col){
        var returnValue  = [];

        returnValue["grpCd"] = authGrpLayerSheet.GetCellValue(Row, "grpCd") ;
        returnValue["grpNm"] = authGrpLayerSheet.GetCellValue(Row, "grpNm");

        const modal = window.top.document.LayerModalUtility.getModal('authGrpLayer');
        modal.fire("authGrpTrigger", returnValue).hide();
    }
    
</script>

</head>
<body class="bodywrap">
    <div class="wrapper modal_layer">
        <div class="modal_body">
            <form id="mySheetForm" name="mySheetForm" tabindex="1">
            </form>

            <table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
                <tr>
                    <td>
                    <div class="inner">
                        <div class="sheet_title">
                        <ul>
                            <li id="txt" class="txt"><tit:txt mid='114502' mdef='권한그룹 리스트 조회'/></li>
                        </ul>
                        </div>
                    </div>
                    <div id="authGrpLayerSheet-wrap"></div>
                    </td>
                </tr>
            </table>
        </div>
        <div class="modal_footer">
            <a href="javascript:closeCommonLayer('authGrpLayer');" class="btn outline_gray close"><tit:txt mid='104157' mdef='닫기'/></a>
        </div>
</div>
</body>
</html>



