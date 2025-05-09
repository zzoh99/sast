<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='payRateTab4Std' mdef='임금피크'/></title>
<link rel="stylesheet" href="/common/${theme}/css/style.css" />
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
    $(function() {
        var initdata = {};
        initdata.Cfg = {SearchMode:smLazyLoad,Page:22, FrozenCol:4};
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata.Cols = [
            {Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",           Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center", ColMerge:1,   SaveName:"sNo" },
            {Header:"<sht:txt mid='sDeleteV1' mdef='삭제|삭제'/>",       Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),  Width:"${sDelWdt}", Align:"Center", ColMerge:1,   SaveName:"sDelete" , Sort:0},
            {Header:"<sht:txt mid='sResultV1' mdef='결과|결과'/>",       Type:"${sRstTy}",   Hidden:Number("${sRstHdn}"),  Width:"${sRstWdt}", Align:"Center", ColMerge:1,   SaveName:"sResult" , Sort:0},
            {Header:"<sht:txt mid='sStatusV1' mdef='상태|상태'/>",       Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),  Width:"${sSttWdt}", Align:"Center", ColMerge:1,   SaveName:"sStatus" , Sort:0},
            {Header:"<sht:txt mid='payCdV2' mdef='급여코드|급여코드'/>",         Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"payCd",            KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='ageV1' mdef='연차|연차'/>",       Type:"Int",       Hidden:0,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"year",       KeyField:1,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:22 },
            {Header:"<sht:txt mid='elementSetCdV2' mdef='적용항목그룹|적용항목그룹'/>", Type:"Combo",     Hidden:0,  Width:120,  Align:"Center",  ColMerge:1,   SaveName:"elementSetCd",     KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='rateV2' mdef='지급율(%)|지급율(%)'/>",           Type:"Float",     Hidden:0,  Width:75,   Align:"Center",  ColMerge:1,   SaveName:"rate",             KeyField:0,   CalcLogic:"",   Format:"Float",       PointCount:5,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='taskTypeV1' mdef='일할유형|일할유형'/>",                     Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"periodType",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='202005190000081' mdef='기간\n반전\n여부|기간\n반전\n여부'/>",  Type:"CheckBox",     Hidden:0,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"reversePeriodYn",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"Y", FalseValue:"N" }
        ];


        IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(4);

        // 급여코드
        var payCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCpnPayCdList",false).codeList, "");
        sheet1.SetColProperty("payCd", {ComboText:"|"+payCdList[0], ComboCode:"|"+payCdList[1]} );

        //적용항목그룹
        var elementSetCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCpnElementSetCdList",false).codeList, "");
        sheet1.SetColProperty("elementSetCd", {ComboText:"|"+elementSetCdList[0], ComboCode:"|"+elementSetCdList[1]} );

        // 일할유형
        var periodTypeList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00013"), "");
        sheet1.SetColProperty("periodType", {ComboText:"|"+periodTypeList[0], ComboCode:"|"+periodTypeList[1]} );


        sheet1.SetMergeSheet( msHeaderOnly);

        $(window).smartresize(sheetResize); sheetInit();

        doAction("Search");

        $(".sheet_search>div>table>tr input[type=text],select").each(function(){

        });
    });

    //Sheet Action
    function doAction(sAction) {

        switch (sAction) {
        case "Search":      sheet1.DoSearch( "${ctx}/PayRateTab4Std.do?cmd=getPayRateTab4StdList", $("#sheet1Form").serialize() ); break;
        case "Save":
        	//if(!dupChk(sheet1,"payCd|ordDetailCd|ordDetailReason", false, true)){break;}
//         	if(!dupChk(sheet1,"payCd|ordDetailCd|ordDetailReason", false, true)){break;}
			IBS_SaveName(document.sheet1Form,sheet1);
        	sheet1.DoSave( "${ctx}/PayRateTab4Std.do?cmd=savePayRateTab4Std", $("#sheet1Form").serialize()); break;
        case "Insert":      sheet1.SelectCell(sheet1.DataInsert(0), ""); break;
        case "Copy":
        	var Row = sheet1.DataCopy();
        	sheet1.SelectCell(Row, 5);
            break;
        case "Clear":       sheet1.RemoveAll(); break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
					var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
					sheet1.Down2Excel(param); break;
        case "LoadExcel":   var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
        }
    }

    // 조회 후 에러 메시지
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
    }

    // 저장 후 메시지
    function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try { if (Msg != "") { alert(Msg); } doAction("Search");} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
    }

    // 셀에서 키보드가 눌렀을때 발생하는 이벤트
    function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
        try {
            // Insert KEY
            if (Shift == 1 && KeyCode == 45) {
                doAction("Insert");
            }
            //Delete KEY
            if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
                sheet1.SetCellValue(Row, "sStatus", "D");
            }
        } catch (ex) {
            alert("OnKeyDown Event Error : " + ex);
        }
    }

    function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
    }
</script>
</head>
<body class="hidden">
<div class="wrapper">
    <form id="sheet1Form" name="sheet1Form" >
    </form>
    <table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
        <tr>
            <td>
                <div class="inner">
                    <div class="sheet_title">
                        <ul>
                            <li id="txt" class="txt"><tit:txt mid='payRateTab4Std' mdef='임금피크'/></li>
                            <li class="btn">
                                <btn:a href="javascript:doAction('Search');" css="button" mid='search' mdef="조회"/>
                                <btn:a href="javascript:doAction('Insert');" css="basic authA" mid='insert' mdef="입력"/>
                                <btn:a href="javascript:doAction('Copy');"  css="basic authA" mid='copy' mdef="복사"/>
                                <btn:a href="javascript:doAction('Save');"  css="basic authA" mid='save' mdef="저장"/>
                                <btn:a href="javascript:doAction('Down2Excel');" css="basic authR" mid='down2excel' mdef="다운로드"/>
                            </li>
                        </ul>
                    </div>
                </div>
                <script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
            </td>
        </tr>
    </table>
</div>
</body>
</html>