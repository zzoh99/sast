<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='schLic' mdef='자격증검색'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>

<script type="text/javascript">
    var p = eval("${popUpStatus}");
    var gubun = "";
    
    $(function() {
        const modal = window.top.document.LayerModalUtility.getModal('hrmLicenseLayer');
        gubun = modal.parameters.gubun;
        
        createIBSheet3(document.getElementById('mySheet-wrap'), "sheet1", "100%", "100%", "${ssnLocaleCd}");
        
        var initdata1 = {};
        initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:0, AutoFitColWidth:'init|search|resize|rowtransaction'};
        initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

        initdata1.Cols = [
            {Header:"<sht:txt mid='sNo' mdef='No'/>",        Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),    Width:"${sNoWdt}",    Align:"Center",    ColMerge:0,    SaveName:"sNo" },
            {Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",        Type:"${sDelTy}",    Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",    Align:"Center",    ColMerge:0,    SaveName:"sDelete",    Sort:0 },
            {Header:"<sht:txt mid='sStatus' mdef='상태'/>",        Type:"${sSttTy}",    Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",    Align:"Center",    ColMerge:0,    SaveName:"sStatus",    Sort:0 },
            {Header:"<sht:txt mid='authScopeCd' mdef='코드'/>",        Type:"Text",        Hidden:0,    Width:70,    Align:"Center",    ColMerge:0,    SaveName:"code",        KeyField:0,    Format:"",    CalcLogic:"",    PointCount:0,    UpdateEdit:0,    InsertEdit:1,    EditLen:10 },
            {Header:"<sht:txt mid='codeNm' mdef='코드명'/>",        Type:"Text",        Hidden:0,    Width:150,    Align:"Left",    ColMerge:0,    SaveName:"codeNm",        KeyField:0,    Format:"",    CalcLogic:"",    PointCount:0,    UpdateEdit:0,    InsertEdit:1,    EditLen:100 },
            {Header:"자격구분",        Type:"Combo",        Hidden:0,    Width:70,    Align:"Left",    ColMerge:0,    SaveName:"note1",        KeyField:0,    Format:"",    CalcLogic:"",    PointCount:0,    UpdateEdit:0,    InsertEdit:1,    EditLen:100 },
            {Header:"관련근거",        Type:"Text",        Hidden:0,    Width:150,    Align:"Left",    ColMerge:0,    SaveName:"note2",        KeyField:0,    Format:"",    CalcLogic:"",    PointCount:0,    UpdateEdit:0,    InsertEdit:1,    EditLen:100 },
            {Header:"<sht:txt mid='memoV4' mdef='메모'/>",        Type:"Text",        Hidden:1,    Width:130,    Align:"Left",    ColMerge:0,    SaveName:"memo",        KeyField:0,    Format:"",    CalcLogic:"",    PointCount:0,    UpdateEdit:1,    InsertEdit:1,    EditLen:100 },
            {Header:"<sht:txt mid='codeIdx' mdef='코드순번'/>",		Type:"Text",		Hidden:1,	Width:0, Align:"Center",	ColMerge:0,	SaveName:"codeIdx",	UpdateEdit:0, InsertEdit:0},
        ]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

        $('#gubun').val(gubun);

        var note1 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20170"), "<tit:txt mid='103895' mdef='전체'/>");
        sheet1.SetColProperty("note1",         {ComboText:"|"+note1[0], ComboCode:"|"+note1[1]} );
        
        //sheet1.FocusAfterProcess = false;
        $(window).smartresize(sheetResize); sheetInit();
        
        var sheetHeight = $('.modal_body').height() - $('#sheet1Form').height() - $('.sheet_title').height();
        sheet1.SetSheetHeight(sheetHeight);
        doAction1("Search");
    });

    $(function() {
        $("#codeNm").bind("keyup",function(event){
            if( event.keyCode == 13){
                doAction1("Search");
            }
        });

        $(".close").click(function() {
            closehrmLicenseLayer();
        });
    });
    
    /*Sheet Action*/
    function doAction1(sAction) {
        switch (sAction) {
        case "Search": //조회
            sheet1.DoSearch( "${ctx}/PsnalLicense.do?cmd=getHrmLicensePopupList", $("#sheet1Form").serialize());
            break;
        case "Save":
            if (!dupChk(sheet1, "code", false, true)) {break;}
            IBS_SaveName(document.sheet1Form,sheet1);
            sheet1.DoSave( "${ctx}/PsnalLicense.do?cmd=saveHrmLicensePopup", $("#sheet1Form").serialize());
            break;            
        case "Insert":
            var row = sheet1.DataInsert(0);
            break;
        case "Copy":
            var row = sheet1.DataCopy();
            sheet1.SetCellValue(row,"code","");
            break;    
        case "Clear":        //Clear
            sheet1.RemoveAll();
            break;
        case "Down2Excel":  //엑셀내려받기
            sheet1.Down2Excel();
            break;
        }
    }

    // 조회 후 에러 메시지
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try{
            if(Msg != "") alert(Msg);
            sheetResize();
        }catch(ex){
            alert("OnSearchEnd Event Error : " + ex);
        }
    }
    // 저장 후 메시지
    function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try {
            if (Msg != "") {
                alert(Msg);
            }
        } catch (ex) {
            alert("OnSaveEnd Event Error " + ex);
        }
    }
    // 더블클릭시 발생
    function sheet1_OnDblClick(Row, Col){
        try{
            returnFindUser(Row,Col);
        }catch(ex){
            alert("OnDblClick Event Error : " + ex);
        }
    }
    
    // 키 입력시 발생
    function sheet1_OnKeyUp(Row, Col, KeyCode, Shift) {
        try {
            if(KeyCode == 13) {
                returnFindUser(Row, Col);
            }
        } catch(ex) {
            alert("OnKeyUp Event Error : " + ex);
        }
    }

    function returnFindUser(Row,Col){
        const modal = window.top.document.LayerModalUtility.getModal('hrmLicenseLayer');
        modal.fire('hrmLicenseTrigger', {
              code : sheet1.GetCellValue(Row, "code")
            , codeNm : sheet1.GetCellValue(Row, "codeNm")
            , note1 : sheet1.GetCellValue(Row, "note1")
            , note2 : sheet1.GetCellValue(Row, "note2")
        }).hide();
    }
</script>

</head>
<body class="bodywrap">
    <div class="wrapper modal_layer">
    
        <div class="modal_body">
            <form id="sheet1Form" name="sheet1Form" onsubmit="return false;">
                <input id="gubun" name="gubun" type="hidden" value="">
                <div class="sheet_search outer">
                    <div>
                    <table>
                        <tr>
                            <th><tit:txt mid='104225' mdef='자격증명'/></th>
                            <td>
                                <input id="codeNm" name ="codeNm" type="text" class="text" style="ime-mode:active;" />
                            </td>
                            <td>
                                <btn:a href="javascript:doAction1('Search')" id="btnSearch" css="btn dark" mid='110697' mdef="조회"/>
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
                                     <li id="txt" class="txt"><tit:txt mid='112832' mdef='자격증조회'/></li>
                                     <li class="btn _thrm115">
                                         <c:if test="${authPg == 'A'}">
                                            <btn:a href="javascript:doAction1('Copy');" css="btn outline-gray authA" mid='110696' mdef="복사"/>
                                            <btn:a href="javascript:doAction1('Insert');" css="btn outline-gray authA" mid='110700' mdef="입력"/>
                                            <btn:a href="javascript:doAction1('Save');" css="btn filled authA" mid='110708' mdef="저장"/>
                                         </c:if>
                                      </li> 
                                 </ul>
                             </div>
                         </div>
                         <div id="mySheet-wrap"></div>
                     </td>
                 </tr>
             </table>
         </div>
         <div class="modal_footer">
              <ul>
                  <li>
                      <btn:a href="javascript:closeCommonLayer('hrmLicenseLayer');" css="gray large" mid='110881' mdef="닫기"/>
                  </li>
              </ul>
          </div>
     </div>
</body>
</html>