<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!-- 날짜 콤보 박스 생성을 위함 -->
<%@ page import="java.util.GregorianCalendar" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<!-- 날짜 콤보 박스 생성을 위함 -->

<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>


<script type="text/javascript">
    $(function() {


        var initdata = {};
        initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata.Cols = [
            {Header:"<sht:txt mid='sNo' mdef='No'/>",       Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
            {Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",       Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 },
            {Header:"<sht:txt mid='sStatus' mdef='상태'/>",       Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },

            {Header:"<sht:txt mid='apApplSeqV1' mdef='신청순번'/>",       Type:"Text",      Hidden:1,  Width:40,   Align:"Center",  ColMerge:0,   SaveName:"reqSeq",           KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='applYmdV6' mdef='신청일자'/>",       Type:"Date",      Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"reqDate",          KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10},
            {Header:"<sht:txt mid='accountType' mdef='계좌구분'/>",       Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"accountType",      KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='bankCdV2' mdef='금융사'/>",         Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"bankCd",           KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='accountNo' mdef='계좌번호'/>",       Type:"Text",      Hidden:0,  Width:120,  Align:"Left",  ColMerge:0,   SaveName:"accountNo",        KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:66 },
            {Header:"<sht:txt mid='accName' mdef='예금주'/>",         Type:"Text",      Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"accName",          KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:17 },
            {Header:"<sht:txt mid='applStatusCd_V5692' mdef='처리\n상태'/>",     Type:"Combo",     Hidden:0,  Width:55,   Align:"Center",  ColMerge:0,   SaveName:"status",           KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10},
            {Header:"<sht:txt mid='agreeDate' mdef='처리일자'/>",       Type:"Date",      Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"agreeDate",        KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10},
            {Header:"<sht:txt mid='bigo_V5697' mdef='처리내용'/>",		 Type:"Text",      Hidden:0,  Width:175,  Align:"Left",    ColMerge:0,   SaveName:"bigo",             KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:666 }
            ];
        IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

        var accountTypeList     = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00180"), "");
        sheet1.SetColProperty("accountType",        {ComboText:"|"+accountTypeList[0], ComboCode:"|"+accountTypeList[1]} );

        var bankCdList  = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H30001"), "");
        sheet1.SetColProperty("bankCd",             {ComboText:"|"+bankCdList[0],      ComboCode:"|"+bankCdList[1]} );

        sheet1.SetColProperty("status",         {ComboText:"|처리요청|처리완료", ComboCode:"|N|Y"} );

        $("#searchNm").bind("keyup",function(event){
            if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
        });

        $(window).smartresize(sheetResize); sheetInit();



        setEmpPage();
//         doAction1("Search");
    });

    //Sheet1 Action
    function doAction1(sAction) {
        switch (sAction) {
        case "Search":
            sheet1.DoSearch( "${ctx}/PerlAccChgApp.do?cmd=getPerlAccChgAppList", $("#sheet1Form").serialize() ); break;
        case "Save":
            //if(!dupChk(sheet1,"reqDate|accountType", false, true)){break;}
            IBS_SaveName(document.sheet1Form,sheet1);
            sheet1.DoSave( "${ctx}/PerlAccChgApp.do?cmd=savePerlAccChgApp", $("#sheet1Form").serialize()); break;
        case "Insert":
            var newRow = sheet1.DataInsert(0);
            sheet1.SetCellValue(newRow, "sabun", $("#searchSabun").val());
            break;
        case "Copy":        sheet1.DataCopy(); break;
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
        try {
            if (Msg != "") {
                alert(Msg);
            }

            sheetResize();
        } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
    }

    // 저장 후 메시지
    function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try { if (Msg != "") {
        	   alert(Msg);
        	}
            doAction1("Search");
        } catch (ex) {
        	alert("OnSaveEnd Event Error " + ex);
        }
    }

    // 셀에서 키보드가 눌렀을때 발생하는 이벤트
    function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
        try {
            // Insert KEY
            if (Shift == 1 && KeyCode == 45) {
                doAction1("Insert");
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


    function setEmpPage() {

        $("#searchSabun").val($("#searchUserId").val());

        $("#searchName").val($("#searchKeyword").val());


        doAction1("Search");
    }

    // 체크 되기 직전 발생.
    function sheet1_OnBeforeCheck(Row, Col) {
        try{
            sheet1.SetAllowCheck(true);
            if(sheet1.ColSaveName(Col) == "sDelete") {
                if(sheet1.GetCellValue(Row, "status") == "Y") {
                    alert("<msg:txt mid='110439' mdef='처리된 신청 건은 삭제 하실 수 없습니다.'/>");
                	sheet1.SetAllowCheck(false);
                    return;
                }
            }
        }catch(ex){
            alert("OnBeforeCheck Event Error : " + ex);
        }
    }

</script>
</head>
<body class="hidden">
<div class="wrapper">
    <!-- include 기본정보 page TODO -->
    <!-- include 기본정보 테스트 중.. inchuli -->
    <%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>

    <form id="sheet1Form" name="sheet1Form" >
    <input type="hidden" id="searchSabun" name="searchSabun" />
    </form>
    <table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
        <tr>
            <td>
                <div class="inner">
                    <div class="sheet_title">
                        <ul>
                            <li id="txt" class="txt"><tit:txt mid='112786' mdef='은행계좌변경신청'/></li>
                            <li class="btn">
                                <a href="javascript:doAction1('Search')" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a>
                                <a href="javascript:doAction1('Insert')"                class="basic authA"><tit:txt mid='104267' mdef='입력'/></a>
                                <a href="javascript:doAction1('Save')"                  class="basic authA"><tit:txt mid='104476' mdef='저장'/></a>
                            </li>
                        </ul>
                    </div>
                </div>
                <script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
            </td>
        </tr>
    </table>
</div>
</body>
</html>
