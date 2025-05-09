<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html class="hidden">
<head>
    <title>연말정산항목관리</title>
    <%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
    <%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
    <%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
    <%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

    <script type="text/javascript">
        $(function () {
            $("#menuNm").val($(document).find("title").text()); //엑셀,CURD

            var now = new Date();
            $("#srchYear").val(now.getFullYear() - 1);
            // 1번 그리드
            let initdata1 = {};
            initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
            initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
            initdata1.Cols = [
                {Header:"No",		Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
                {Header:"삭제",		Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),  Width:"${sDelWdt}", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
                {Header:"상태",		Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),  Width:"${sSttWdt}", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
                {Header:"대상년도",		Type:"Text",	Hidden:0,  Width:80,	Align:"Center",  ColMerge:0,   SaveName:"workYy",         	KeyField:1,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4 },
                {Header:"프로세스코드",	Type:"Text",	Hidden:0,  Width:180,	Align:"Left",    ColMerge:0,   SaveName:"adjProcessCd",	KeyField:1,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
                {Header:"프로세스명",	Type:"Text",	Hidden:0,  Width:245,	Align:"Left",    ColMerge:0,   SaveName:"adjProcessNm",   KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
                {Header:"순서",		Type:"Text",	Hidden:0,  Width:70,  	Align:"Right",   ColMerge:0,   SaveName:"seq",            	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
                {Header:"도움말_1",	Type:"Text",	Hidden:1,  Width:100, 	Align:"Left",    ColMerge:0,   SaveName:"helpText1",      	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
                {Header:"도움말_2",	Type:"Text",	Hidden:1,  Width:100, 	Align:"Left",    ColMerge:0,   SaveName:"helpText2",      	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
                {Header:"도움말_2",	Type:"Text",	Hidden:1,  Width:100, 	Align:"Left",    ColMerge:0,   SaveName:"helpText3",      	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
                {Header:"도움말관리",	Type:"Image",	Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   SaveName:"helpPic",        	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100, Cursor:"Pointer" }
            ]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);

            sheet1.SetCountPosition(4);
            sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

            let initdata2 = {};
            initdata2.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
            initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
            initdata2.Cols = [
                {Header:"No",		Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
                {Header:"삭제",		Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),  Width:"${sDelWdt}", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
                {Header:"상태",		Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),  Width:"${sSttWdt}", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
                {Header:"대상년도",		Type:"Text",	Hidden:1,  Width:0,    	Align:"Left",    ColMerge:0,   SaveName:"workYy",			KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4 },
                {Header:"항목코드",		Type:"Text",	Hidden:0,  Width:80,   	Align:"Left",    ColMerge:0,   SaveName:"adjElementCd",  	KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
                {Header:"항목명",		Type:"Text",	Hidden:0,  Width:165,	Align:"Left",    ColMerge:0,   SaveName:"adjElementNm",  	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
                {Header:"작업\n순서",	Type:"Float",	Hidden:0,  Width:60,   	Align:"Right",   ColMerge:0,   SaveName:"seq",           	KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
                {Header:"세율",		Type:"Combo",	Hidden:0,  Width:130,  	Align:"Left",    ColMerge:0,   SaveName:"taxRateCd",     	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
                {Header:"프로세스코드",	Type:"Text",	Hidden:1,  Width:0,    	Align:"Left",    ColMerge:0,   SaveName:"adjProcessCd",  	KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
                {Header:"작업구분",		Type:"Combo",	Hidden:0,  Width:90,   	Align:"Left",    ColMerge:0,   SaveName:"eleWorkType",   	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
                {Header:"공제자료\n여부",Type:"Combo",	Hidden:0,  Width:60,   	Align:"Center",  ColMerge:0,   SaveName:"dedDataYn",     	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
                {Header:"정산자료\n여부",Type:"Combo",	Hidden:0,  Width:60,   	Align:"Center",  ColMerge:0,   SaveName:"adjDataYn",     	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
                {Header:"소득자료\n여부",Type:"Combo",	Hidden:0,  Width:60,   	Align:"Center",  ColMerge:0,   SaveName:"incomeDataYn",  	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 }
            ]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);

            sheet2.SetCountPosition(4);

            let eleWorkTypeList = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd=C00301",false).codeList, "");
            let taxRateCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&srchWorkYy="+$("#srchYear").val(),"queryId=getTaxList",false).codeList, "");

            sheet2.SetColProperty("eleWorkType",    {ComboText:"|"+eleWorkTypeList["C00301"][0], ComboCode:"|"+eleWorkTypeList["C00301"][1]} );
            sheet2.SetColProperty("taxRateCd",      {ComboText:"|"+taxRateCdList[0], ComboCode:"|"+taxRateCdList[1]} );
            sheet2.SetColProperty("dedDataYn",      {ComboText:"|Yes|No", ComboCode:"|Y|N"} );
            sheet2.SetColProperty("adjDataYn",      {ComboText:"|Yes|No", ComboCode:"|Y|N"} );
            sheet2.SetColProperty("incomeDataYn",   {ComboText:"|Yes|No", ComboCode:"|Y|N"} );

            $(window).smartresize(sheetResize); sheetInit();

            doAction1("Search");
        });


        $(function() {
            $("#srchYear").bind("keyup",function(event){
                makeNumber(this,"A");
                if( event.keyCode == 13){
                    doAction1("Search");
                    $(this).focus();
                }
            });
        });

        //Sheet Action First
        function doAction1(sAction) {
            switch (sAction) {
                case "ChkAjaxPost":
                    var param = $("#srchFrm").serialize();
                    ajaxCall("/YearEndItemMgr.do?cmd=getYearEndItemMgrProcess",param,false);
                    break;
                case "ChkAjaxGet":
                    var param = "adjProcessNm="+ ajaxescape($("#adjProcessNm").val());
                    ajaxCall("/YearEndItemMgr.do?cmd=getYearEndItemMgrProcess&"+param,"",false);
                    break;
                case "ChkFormPost":
                    $("#srchFrm").attr("action","/YearEndItemMgr.do?cmd=getYearEndItemMgrProcess").attr("method","post").submit();
                    break;
                case "ChkSheet":
                    sheet1.DoSave( "/YearEndItemMgr.do?cmd=saveYearEndItemMgrProcess");
                    break;
                case "Search":
                    if($("#srchYear").val() == "") {
                        alert("대상년도를 입력하여 주십시오.");
                        return;
                    }

                    var taxRateCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&srchWorkYy="+$("#srchYear").val(),"queryId=getTaxList",false).codeList, "");
                    sheet2.SetColProperty("taxRateCd",      {ComboText:"|"+taxRateCdList[0], ComboCode:"|"+taxRateCdList[1]} );

                    sheet1.DoSearch( "${ctx}/YearEndItemMgr.do?cmd=getYearEndItemMgrProcess", $("#srchFrm").serialize() );
                    break;
                case "Save":
                    if(!dupChk(sheet1,"adjProcessCd", true, true)){break;}
                    IBS_SaveName(document.srchFrm, sheet1);
                    sheet1.DoSave( "/YearEndItemMgr.do?cmd=saveYearEndItemMgrProcess", $("#srchFrm").serialize());
                    break;
                case "Insert":
                    sheet1.SetCellValue(sheet1.DataInsert(0), "workYy", $("#srchYear").val());
                    doAction2("Clear") ;
                    break;
                case "Copy":
                    sheet1.DataCopy();
                    break;
                case "Clear":
                    sheet1.RemoveAll();
                    break;
                case "Down2Excel":
                    var downcol = makeHiddenSkipCol(sheet1);
                    var param  = {DownCols:downcol,SheetDesign:1,Merge:1, menuNm:$(document).find("title").text()};
                    sheet1.Down2Excel(param);
                    break;
                case "LoadExcel":
                    var params = {Mode:"HeaderMatch", WorkSheetNo:1};
                    sheet1.LoadExcel(params);
                    break;
            }
        }

        //Sheet Action Second
        function doAction2(sAction) {

            switch (sAction) {
                case "Search":
                    var param = $("#srchFrm").serialize()+"&srchYear="+sheet1.GetCellValue(sheet1.GetSelectRow(), "workYy")
                        +"&srchAdjProcessCd="+sheet1.GetCellValue(sheet1.GetSelectRow(), "adjProcessCd");

                    sheet2.DoSearch( "${ctx}/YearEndItemMgr.do?cmd=getYearEndItemMgr", param );
                    break;
                case "Save":
                    if(!dupChk(sheet2,"adjElementCd", true, true)){break;}
                    IBS_SaveName(document.srchFrm, sheet2);
                    sheet2.DoSave( "/YearEndItemMgr.do?cmd=saveYearEndItemMgr", $("#srchFrm").serialize());
                    break;
                case "Insert":
                    if(sheet1.GetSelectRow() <= 0  ){
                        alert("상단의 연말정산 프로세스를 선택하여 주십시오.");
                    } else if( sheet1.GetCellValue(sheet1.GetSelectRow(), "sStatus") == "I" ) {
                        alert("상단의 연말정산프로세스 입력상태 데이터에는\n하단의 연말정산 항목을 입력 할 수 없습니다.");
                    } else {
                        var newRow = sheet2.DataInsert(0);
                        sheet2.SetCellValue(newRow, "workYy", sheet1.GetCellValue(sheet1.GetSelectRow(), "workYy") ) ;
                        sheet2.SetCellValue(newRow, "adjProcessCd", sheet1.GetCellValue(sheet1.GetSelectRow(), "adjProcessCd") ) ;
                    }
                    break;
                case "Copy":
                    sheet2.DataCopy();
                    break;
                case "Clear":
                    sheet2.RemoveAll();
                    break;
                case "Down2Excel":
                    var downcol = makeHiddenSkipCol(sheet2);
                    var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
                    sheet2.Down2Excel(param);
                    break;
            }
        }

        // 조회 후 에러 메시지
        function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
            try {
                if (Msg != "") {
                    alert(Msg);
                }
                sheetResize();
                if(Code == 1 && sheet1.SearchRows() == 0) {
                    doAction2('Search');
                }
            } catch(ex) {
                alert("OnSearchEnd Event Error : " + ex);
            }
        }

        // 저장 후 메시지
        function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
            try {
                if (Msg != "") {
                    alert(Msg);
                }
                if(Code > 0) {
                    doAction1("Search");
                }
            } catch(ex) {
                alert("OnSaveEnd Event Error " + ex);
            }
        }

        // 조회 후 에러 메시지
        function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
            try {
                if (Msg != "") {
                    alert(Msg);
                }
                sheetResize();
            } catch(ex) {
                alert("OnSearchEnd Event Error : " + ex);
            }
        }

        // 저장 후 메시지
        function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
            try {
                if (Msg != "") {
                    alert(Msg);
                }

                if(Code > 0) {
                    doAction2("Search");
                }
            } catch(ex) {
                alert("OnSaveEnd Event Error " + ex);
            }
        }

        function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
            try{
                if(Row > 0 && sheet1.ColSaveName(Col) == "helpPic"){
                    yearEndItemMgrPopup(Row);
                }
            } catch(ex) {
                alert("OnSelectCell Event Error : " + ex);
            }
        }

        function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
            try{
                if(sheet1.GetCellValue(NewRow, "sStatus") != "I"){
                    if(sheet1.GetSelectRow() > 0 && OldRow != NewRow){
                        doAction2('Search');
                    }
                }
            } catch(ex){
                alert("OnSelectCell Event Error : " + ex);
            }
        }

        /**
         *  도움말 window open event
         */
        function yearEndItemMgrPopup(Row){

            var w 		= 1200;
            var h 		= 700;
            var url 	= "/YearEndItemMgr.do?cmd=viewYearEndItemMgrPopup&authPg=${authPg}";
            var args 	= new Array();
            args["sheet1"]          = sheet1;

            if(!isPopup()) {return;}
            openPopup(url,args,w,h);
        }

        /**
         * 전년도 자료 복사
         */
        <%--function doCopy(){--%>
        <%--    if($("#srchYear").val() == "") {--%>
        <%--        alert("대상년도를 입력하여 주십시오.");--%>
        <%--        return;--%>
        <%--    }--%>

        <%--    var copyYear = $("#srchYear").val()*1 ;--%>
        <%--    var msg = copyYear+"년도에 대한 "+(copyYear-1)+"년도 자료 복사를 실행하시겠습니까?\n"+copyYear+"년도 기존자료는 덮어쓰기 됩니다." ;--%>

        <%--    if( confirm( msg ) ) {--%>
        <%--        var rst = ajaxCall("<%=jspPath%>/yearEndItemMgr/yearEndItemMgrRst.jsp?cmd=copyYearEndItemMgr", $("#srchFrm").serialize(), false);--%>
        <%--        alert(rst.Result.Message);--%>
        <%--        doAction1("Search");--%>
        <%--    }--%>
        <%--}--%>
    </script>
</head>
<body class="bodywrap">
<div class="wrapper">
    <form id="srchFrm" name="srchFrm" method="post">
        <input type="hidden" id="menuNm" name="menuNm" />
        <div class="sheet_search outer">
            <div>
                <table>
                    <tr>
                        <td>
                            <span>대상년도</span>
                            <input id="srchYear" name ="srchYear" type="text" class="text center" maxlength="4" style="width:10%"/>
                        </td>
                        <td>
                            <a href="javascript:doAction1('Search')" class="button">조회</a>
                     </td>
                    </tr>
                </table>
            </div>
        </div>
    </form>

    <div class="outer">
        <div class="sheet_title">
            <ul>
                <li class="txt">연말정산 프로세스</li>
                <li class="btn">
                    <a href="javascript:doAction1('LoadExcel')"   class="basic btn-upload authA">업로드</a>
                    <a href="javascript:doAction1('Insert')" class="basic authA">입력</a>
                    <a href="javascript:doAction1('Copy')"   class="basic authA">복사</a>
                    <a href="javascript:doAction1('Save')"   class="basic btn-save authA">저장</a>
                    <a href="javascript:doAction1('Down2Excel')"   class="basic btn-download authR">다운로드</a>
                </li>
            </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet1", "100%", "50%"); </script>
    <div class="outer">
        <div class="sheet_title">
            <ul>
                <li class="txt">연말정산 항목</li>
                <li class="btn">
                    <a href="javascript:doAction2('Insert')" class="basic authA">입력</a>
                    <a href="javascript:doAction2('Copy')"   class="basic authA">복사</a>
                    <a href="javascript:doAction2('Save')"   class="basic btn-save authA">저장</a>
                    <a href="javascript:doAction2('Down2Excel')"   class="basic btn-download authR">다운로드</a>
                </li>
            </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet2", "100%", "50%"); </script>

</div>
</body>
</html>
