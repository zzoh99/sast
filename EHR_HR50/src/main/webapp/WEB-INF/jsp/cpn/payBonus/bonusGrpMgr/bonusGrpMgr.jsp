<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<script type="text/javascript">
    $(function() {
        
        var now = new Date();
        var year = now.getFullYear(); //년
        $("#searchYear").val(year);
        
        $("#searchYear").bind("chage",function(event){
            doAction1("Search");
        });
        
        $("#searchYear").bind("keyup",function(event){
            if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
        });

        var initdata = {};
        initdata.Cfg = {FrozenCol:5,SearchMode:smLazyLoad,Page:22};
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata.Cols = [
            {Header:"<sht:txt mid='sNo' mdef='No'/>",      Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
            {Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",       Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 },
            {Header:"<sht:txt mid='sStatus' mdef='상태'/>",      Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
            
            {Header:"년도",       Type:"Text",  Hidden:0, Width:100, Align:"Center", SaveName:"yyyy", KeyField:1, Format:"", UpdateEdit:1, InsertEdit:1 },
            {Header:"성과급그룹", Type:"Combo", Hidden:0, Width:100, Align:"Center", SaveName:"bonusGrp", KeyField:1, Format:"", UpdateEdit:1, InsertEdit:1 },
            {Header:"성과급유형", Type:"Combo", Hidden:0, Width:100, Align:"Center", SaveName:"bonusType", KeyField:1, Format:"", UpdateEdit:1, InsertEdit:1 },
            {Header:"성과급재원", Type:"Float", Hidden:0, Width:100, Align:"Right", SaveName:"bonusResourceMon", KeyField:1, Format:"", UpdateEdit:1, InsertEdit:1 },
            {Header:"확정여부(Y/N)", Type:"CheckBox", Hidden:0, Width:100, Align:"Center", SaveName:"closeYn", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
        ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

        var bonusGrp    = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C99910"), "");  //성과급그룹
        var bonusType   = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C99920"), "");  //성과급유형
        
        sheet1.SetColProperty("bonusGrp",           {ComboText:"|"+bonusGrp[0], ComboCode:"|"+bonusGrp[1]} ); //성과급그룹
        sheet1.SetColProperty("bonusType",          {ComboText:"|"+bonusType[0], ComboCode:"|"+bonusType[1]} ); //성과급유형


        $(window).smartresize(sheetResize); sheetInit();
        doAction1("Search");
    });

    //Sheet1 Action
    function doAction1(sAction) {
        switch (sAction) {
        case "Search":      
            sheet1.DoSearch( "${ctx}/BonusGrpMgr.do?cmd=getBonusGrpMgrList", $("#srchFrm").serialize() ); 
            break;
        
        case "Save":
            IBS_SaveName(document.srchFrm,sheet1);
            sheet1.DoSave( "${ctx}/BonusGrpMgr.do?cmd=saveBonusGrpMgr", $("#srchFrm").serialize() ); break;
                            
        case "Insert":
            var Row = sheet1.DataInsert(0);
            sheet1.SetCellValue(Row, "yyyy",   $("#searchYear").val() );
            break;
            
        case "Clear":
            sheet1.RemoveAll(); break;
        
        case "Down2Excel":
            var downcol = makeHiddenSkipCol(sheet1);
            var param  = {DownCols:downcol,SheetDesign:1, SheetName : "성과그룹관리"};
            sheet1.Down2Excel(param);
            break;
        }
    }

    // 조회 후 에러 메시지
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {   if (Msg != "") { alert(Msg); }
          sheetResize();
        } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
    }

    // 저장 후 메시지
    function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
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

</script>
</head>
<body class="hidden">
<div class="wrapper">
    <form id="srchFrm" name="srchFrm" >
        <div class="sheet_search outer">
            <div>
                <table>
                    <tr>
                        <td> <span><tit:txt mid='103906' mdef='년도'/>  </span> <input id="searchYear" name="searchYear" type="text" size="10" class="date2" value=""/> </td>

                        <td>  <btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/>  </td>
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
                            <li id="txt" class="txt"><tit:txt mid='BonusGrpMgr' mdef='성과그룹'/></li>
                            <li class="btn">
                                <btn:a href="javascript:doAction1('Insert')" css="basic authA" mid='110700' mdef="입력"/>
                                <btn:a href="javascript:doAction1('Save')"  css="basic authA" mid='110708' mdef="저장"/>
                                <btn:a href="javascript:doAction1('Down2Excel')"    css="basic authR" mid='110698' mdef="다운로드"/>
                            </li>
                        </ul>
                    </div>
                </div>
                <script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr", "${ssnLocaleCd}"); </script>
            </td>
        </tr>
    </table>
</div>
</body>
</html>
