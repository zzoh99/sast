<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<title><tit:txt mid='112691' mdef='성과급업로드'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
    // 1번 그리드에서 선택된 값

    $(function() {
        
        var now = new Date();
        var year = now.getFullYear(); //년
        $("#searchYear").val(year);
        $("#searchBonusGrp").val("PBU");
        $("#searchBonusType").val("UP");
        // 1번 그리드
        var initdata1 = {};
        initdata1.Cfg = {FrozenCol:7, SearchMode:smLazyLoad,Page:22};
        initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
        initdata1.Cols = [
                {Header:"<sht:txt mid='sNo' mdef='No'/>",                            Type:"${sNoTy}",  Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
                {Header:"<sht:txt mid='bonusGrp' mdef='성과급 그룹'/>",              Type:"Combo",     Hidden:0,  Width:100,   Align:"Center",   ColMerge:0,   SaveName:"bonusGrp",             KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                {Header:"<sht:txt mid='bonusResourceMon' mdef='성과급 재원 '/>",     Type:"Float",     Hidden:0,  Width:150,   Align:"Right",    ColMerge:0,   SaveName:"bonusResourceMon",     KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:2,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                {Header:"<sht:txt mid='totMon' mdef='할당금액 '/>",                  Type:"Float",     Hidden:0,  Width:150,   Align:"Right",    ColMerge:0,   SaveName:"totMon",               KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                {Header:"<sht:txt mid='gapMon' mdef='차액 '/>",                      Type:"Float",     Hidden:0,  Width:150,   Align:"Right",    ColMerge:0,   SaveName:"gapMon",               KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:100 }
        ];
        IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
        
        var bonusGrp     = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C99910"), "");  //성과급그룹
        
        sheet1.SetColProperty("bonusGrp",            {ComboText:"|"+bonusGrp[0], ComboCode:"|"+bonusGrp[1]} ); //성과급그룹
        
        $("#searchYear").bind("keyup",function(event){
            if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
        });


        // 2번 그리드
        var initdata2 = {};
        initdata2.Cfg = {SearchMode:smLazyLoad,Page:22};
        initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
        initdata2.Cols = [
            {Header:"No",         Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
            {Header:"삭제",       Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),  Width:"${sDelWdt}", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
            {Header:"상태",       Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),  Width:"${sSttWdt}", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
            
            {Header:"성과급연도", Type:"Text",      Hidden:1,  Width:100,   Align:"Center",    ColMerge:0,   SaveName:"yyyy",          KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"성과급그룹", Type:"Combo",     Hidden:0,  Width:100,   Align:"Center",    ColMerge:0,   SaveName:"bonusGrp",          KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"소속",       Type:"Text",      Hidden:0,  Width:80,    Align:"Center",    ColMerge:0,   SaveName:"orgNm",             KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"사번",       Type:"Text",      Hidden:0,  Width:100,   Align:"Center",    ColMerge:0,   SaveName:"sabun",             KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"성명",       Type:"Text",      Hidden:0,  Width:100,   Align:"Center",    ColMerge:0,   SaveName:"name",              KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"직위",       Type:"Text",      Hidden:0,  Width:60,    Align:"Center",    ColMerge:0,   SaveName:"jikweeNm",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"직책",       Type:"Text",      Hidden:0,  Width:60,    Align:"Center",    ColMerge:0,   SaveName:"jikchakNm",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"할당금액",   Type:"Float",     Hidden:0,  Width:100,   Align:"Right",     ColMerge:0,   SaveName:"planMon",           KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            
        ];
        IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);
        
        var bonusGrp2     = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C99910"), "");  //성과급그룹
        
        sheet2.SetColProperty("bonusGrp",            {ComboText:"|"+bonusGrp2[0], ComboCode:"|"+bonusGrp2[1]} ); //성과급그룹
        
        $(window).smartresize(sheetResize); sheetInit();
        doAction1("Search");
    });

    //Sheet Action First
    function doAction1(sAction) {
        switch (sAction) {
            case "Search":      sheet1.DoSearch( "${ctx}/BonusUpload.do?cmd=getBonusUploadList", $("#srchFrm").serialize() ); break;
        }
    }

    //Sheet Action Second
    function doAction2(sAction) {

        if ( (sheet1.GetCellValue(sheet1.GetSelectRow(),"sStatus")=="I") && !(sAction=="Search") ) {
            alert("<msg:txt mid='109364' mdef='상단의 파일목록에서 \'입력\'작업을 완료한 후에 상세목록 작업을 진행해주시기 바랍니다.'/>");
            return;
        }

           switch (sAction) {
             case "Search":      
               //소계
               var info = [{StdCol:"bonusGrp", SumCols:"planMon", CaptionCol:"bonusGrp"}];
               sheet2.ShowSubSum(info) ;
              
                  sheet2.DoSearch( "${ctx}/BonusUpload.do?cmd=getBonusUploadDetailList", $("#srchFrm").serialize() ); 
                  break;
           case "Create":
               callProcCreate();
               break;
           case "DivExe":
               callProcDivExe();
               break;
           case "Save":       
               IBS_SaveName(document.srchFrm,sheet2);
               sheet2.DoSave( "${ctx}/BonusUpload.do?cmd=saveBonusUpload", $("#srchFrm").serialize() ); 
               break;
           case "Down2Excel":
                var downcol = makeHiddenSkipCol(sheet2);
                var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
                sheet2.Down2Excel(param); 
                break;
           case "LoadExcel":  
               var params = {Mode:"HeaderMatch", WorkSheetNo:1}; 
               sheet2.LoadExcel(params); 
               break;
         }
    }

    // 조회 후 에러 메시지
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
    }

    // 저장 후 메시지
    function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try { if (Msg != "") { alert(Msg); doAction1("Search");}} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
    }

    // 조회 후 에러 메시지
    function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
    }

    // 저장 후 메시지
    function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try { if (Msg != "") { alert(Msg); doAction2("Search"); }} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
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
        //alert("mySheetLeft_OnClick Click : \nRow:"+ Row+" \nCol:"+Col+" \nValue:"+Value+" \nCellX:"+CellX+" \nCellY:"+CellY+" \nCellW:"+CellW+" \nCellH:"+CellH );
        try{
        }catch(ex){alert("OnSelectCell Event Error : " + ex);    }
    }

    function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
        try{
            if(OldRow != NewRow){
                $("#searchBonusGrp").val(sheet1.GetCellValue(NewRow, "bonusGrp"));
                doAction2("Search");
            }
        }catch(ex){alert("OnSelectCell Event Error : " + ex);}
    }

    function callProcCreate() {
        
        if(!confirm("대상자 생성하시겠습니까? \n기존데이터는 지워집니다.")) { return ; }
        
        var params = "searchYear="+$("#searchYear").val()+"&searchBonusGrp="+$("#searchBonusGrp").val() ;
        var ajaxCallCmd = "callP_CPN_BONUS_DIV_EMP_CRE" ;
        
        var data = ajaxCall("/BonusDiv.do?cmd="+ajaxCallCmd,params,false);
        
        if(data.Result.Code == null) {
            msg = "대상자가 생성되었습니다." ;
            doAction2("Search") ;
        } else {
            msg = "대상자 생성도중 : "+data.Result.Message;
        }
        
        alert(msg) ;
    }
    
    function callProcDivExe() {
    
        var params = "searchYear="+$("#searchYear").val()+"&searchBonusGrp="+$("#searchBonusGrp").val() ;
        var ajaxCallCmd = "callP_CPN_BONUS_DIV_MON_CRE" ;
        
        var data = ajaxCall("/BonusDiv.do?cmd="+ajaxCallCmd,params,false);
        
        if(data.Result.Code == null) {
            msg = "배분 실행되었습니다." ;
            doAction2("Search") ;
        } else {
            msg = "배분 실행도중 : "+data.Result.Message;
        }
        
        alert(msg) ;
    }
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
    <form id="srchFrm" name="srchFrm">
    <input id="searchBonusType" name="searchBonusType" type="hidden" />
    <input id="searchBonusGrp" name="searchBonusGrp" type="hidden" />
    <div class="sheet_search outer">
        <table>
            <tr>
                <td>
                    <span><tit:txt mid='103906' mdef='년도'/>  </span> <input id="searchYear" name="searchYear" type="text" size="10" class="date2" value=""/>
                </td>
                <td>
                    <btn:a href="javascript:doAction1('Search');" id="srchBtn" mid="search" mdef="조회" css="button"/>
                </td>
            </tr>
        </table>
    </div>
    </form>

    <table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
        <tr>
            <td>
                <div class="outer">
                    <div class="sheet_title">
                    <ul>
                        <li class="txt"><tit:txt mid='textFileMgr1' mdef='성과급 그룹 목록'/></li>
                    </ul>
                    </div>
                </div>
                <script type="text/javascript"> createIBSheet("sheet1", "60%", "30%", "${ssnLocaleCd}"); </script>
               </td>
        </tr>
        <tr>
            <td> 
                <div class="outer">
                    <div class="sheet_title">
                    <ul>
                        <li class="txt"><tit:txt mid='textFileMgr2' mdef='성과급업로드'/></li>
                        <li class="btn">
                          <a href="javascript:doAction2('LoadExcel')"  class="basic authA">업로드</a>
                          <btn:a href="javascript:doAction2('Save')"   css="basic authA" mid='110708' mdef="저장"/>
                          <a href="javascript:doAction2('Down2Excel')"   class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
                        </li>
                    </ul>
                    </div>
                </div>
                <script type="text/javascript"> createIBSheet("sheet2", "100%", "70%", "${ssnLocaleCd}"); </script>
            </td>
        </tr>
    </table>
</div>
</body>
</html>
