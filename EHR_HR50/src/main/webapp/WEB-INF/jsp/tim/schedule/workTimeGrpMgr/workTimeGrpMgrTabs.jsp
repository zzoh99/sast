<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>조직구분항목</title>
    <%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
    <%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
    <%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

    <script src="${ctx}/assets/js/work_group.js" type="text/javascript" charset="UTF-8"></script>

    <script type="text/javascript">
        let gPRow = "";
        const pGubun = "";
        const weekArr = ["", "일", "월", "화", "수", "목", "금", "토"];
        let isChange = false;
        let sStatus = 'R';

        $(function() {
            $('#workTab a').on('click', function() {
                $('#workTab a').removeClass('active');
                $(this).addClass('active');
                const idx = $(this).index('a');
                if (idx === 0) {
                    goList();
                } else if(idx === 1){
                    const title = $(this).find('div b').text();
                    $('#contentTitle').text(title);
                    $('#work3').hide();
                    $('#work4').hide();
                    $('#work2').show(100, () => { sheetResize(); });
                }else if(idx === 2){
                    const title = $(this).find('div b').text();
                    $('#contentTitle').text(title);
                    $('#work2').hide();
                    $('#work4').hide();
                    $('#work3').show(100, () => { sheetResize(); });
                    // $('main.main_tab_content').hide();
                    // $('main.main_tab_content:eq(' + (idx - 1) + ')').show(100, () => { sheetResize(); });
                } else if(idx === 3){
                    const title = $(this).find('div b').text();
                    $('#contentTitle').text(title);
                    $('#work2').hide();
                    $('#work3').hide();
                    $('#work4').show(100, () => { sheetResize(); });
                }
            });
            $("#searchYmd").datepicker2({
                onReturn:function(date){
                    doAction("Search");
                }
            });
            $("#searchYmd").val("${curSysYyyyMMddHyphen}");

            $("#searchYmd").bind("keyup",function(event){
                if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
            });


            $("#searchDate").datepicker2({
                onReturn:function(date){
                    doAction2("Search");
                }
            });
            $("#searchDate").bind("keydown",function(event){
                if( event.keyCode == 13){ doAction2("Search"); $(this).focus(); }
            });

            init_data();

            init_sheet1(); //근무조관리
            doAction1("Search");

            // init_sheet2(); //근무조패턴관리 근무조
            // doAction2("Search");

            // init_sheet3(); //근무조 반복패턴
            // doAction3("Search");

            init_sheet4(); //근무시간표리스트
            // doAction4("Search");

            init_sheet5(); //사용근무시간표

            doAction5("Search");

            init_sheet6();

            $(window).smartresize(sheetResize); sheetInit();

            $("input, select").change(function(){
                isChange = true;
                sStatus = 'U';
            })
        });

        function init_data(){
            const workGrpData = ajaxCall("${ctx}/WorkTimeGrpMgr.do?cmd=getWorkPattenMgrGrpList", $("#sheet1Form").serialize(), false).DATA;
            const grpCds = "T10002,T90200,T11020";
            const codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists", "grpCd=" + grpCds, false).codeList, "");
            const codeSplit = codeLists['T11020'][0].split("|");

            // let no만큼
            const grpInfo = localStorage.getItem('grpInfo');
            for(let i = 0; i < grpInfo; i++ ){
                $("#sumDayWkLmt").val(workGrpData[i].sumDayWkLmt);
                $("#sumDayOtLmt").val(workGrpData[i].sumDayOtLmt);
                $("#sumWeekWkLmt").val(workGrpData[i].sumWeekWkLmt);
                $("#sumWeekOtLmt").val(workGrpData[i].sumWeekOtLmt);
                $("#avgDayWkLmt").val(workGrpData[i].avgDayWkLmt);
                $("#avgDayOtLmt").val(workGrpData[i].avgDayOtLmt);
                $("#avgWeekWkLmt").val(workGrpData[i].avgWeekWkLmt);
                $("#avgWeekOtLmt").val(workGrpData[i].avgWeekOtLmt);
                $("#sdateWeek").val(weekArr[workGrpData[i].sdateWeek]);
                $("#intervalCd").val(workGrpData[i].intervalCd);
                $("#workOrgTypeCd").val(workGrpData[i].workOrgTypeCd);
                $("#workGrpCd").val(workGrpData[i].workGrpCd);
                $("#memo").val(workGrpData[i].memo);

                if(workGrpData[i].fixStTimeYn === 'Y'){
                    $("#toggle1").prop('checked', true);
                } else {
                    $("#toggle1").prop('checked', false);
                }

                if(workGrpData[i].fixEdTimeYn === 'Y'){
                    $("#toggle2").prop('checked', true);
                } else {
                    $("#toggle2").prop('checked', false);
                }

                $("#searchWorkGrpCd").val(workGrpData[i].workGrpCd);
                $("#searchYmd1").val(workGrpData[i].sdate.replace(/(\d{4})(\d{2})(\d{2})/g, '$1-$2-$3'));
            }


        }

        function goList() {
            const uri = '/WorkTimeGrpMgr.do?cmd=viewWorkTimeGrpMgr';
            const top = window.top;
            const name = window.name;
            if (top.parent) {
                if (typeof top.parent.submitCall != 'undefind') {
                    const form = top.parent.$('#subForm');
                    top.parent.submitCall(form, name, 'post', uri);
                }
            }
        }

        //근무조관리
        function init_sheet1(){
            const initdata = {};
            initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
            initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
            initdata.Cols = [
                {Header:"No",			Type:"Seq",       Hidden:0,  Width:45,  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
                {Header:"삭제",			Type:"DelCheck",  Hidden:0,  Width:45,	Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
                {Header:"상태",			Type:"Status",    Hidden:0,  Width:45,	Align:"Center",  ColMerge:0,   SaveName:"sStatus" },

                {Header:"근무조코드",		Type:"Text",      Hidden:0,  Width:80,  Align:"Center",  ColMerge:0,   SaveName:"mapCd",  KeyField:1,   CalcLogic:"",   Format:"",     UpdateEdit:0,   InsertEdit:1 },
                {Header:"근무조명",		Type:"Text",      Hidden:0,  Width:200, Align:"Left",    ColMerge:0,   SaveName:"mapNm",  KeyField:1,   CalcLogic:"",   Format:"",     UpdateEdit:1,   InsertEdit:1 },
                {Header:"시작일자", 		Type:"Date",      Hidden:0,  Width:100, Align:"Center",  ColMerge:0,   SaveName:"sdate",  KeyField:1,   CalcLogic:"",   Format:"Ymd",  UpdateEdit:0,   InsertEdit:1 },
                {Header:"종료일자", 		Type:"Date",      Hidden:0,  Width:100, Align:"Center",  ColMerge:0,   SaveName:"edate",  KeyField:0,   CalcLogic:"",   Format:"Ymd",  UpdateEdit:0,   InsertEdit:0 },
                {Header:"순서",			Type:"Int",       Hidden:0,  Width:80,  Align:"Center",  ColMerge:0,   SaveName:"sort",   KeyField:0,   CalcLogic:"",   Format:"",     UpdateEdit:1,   InsertEdit:1 },
                {Header:"비고",			Type:"Text",      Hidden:0,  Width:200, Align:"Left",    ColMerge:0,   SaveName:"note",   KeyField:0,   CalcLogic:"",   Format:"",     UpdateEdit:1,   InsertEdit:1 },

                //Hidden
                {Header:"Hidden", Type:"Text", Hidden:1, SaveName:"mapTypeCd"},
                {Header:"Hidden", Type:"Text", Hidden:1, SaveName:"ccType"},
                {Header:"Hidden", Type:"Text", Hidden:1, SaveName:"erpEmpCd"},
                {Header:"Hidden", Type:"Text", Hidden:1, SaveName:"businessPlaceCd"}

            ]; IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(4);

            $(window).smartresize(sheetResize); sheetInit();

        }

        // 근무조패턴관리 근무조
        <%--function init_sheet2(){--%>
        <%--    var initdata1 = {};--%>
        <%--    initdata1.Cfg = {SearchMode:smLazyLoad,Page:22, MergeSheet:5};--%>
        <%--    initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};--%>

        <%--    initdata1.Cols = [--%>
        <%--        {Header:"No|No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },--%>
        <%--        {Header:"\n삭제|\n삭제",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },--%>
        <%--        {Header:"상태|상태",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },--%>
        <%--        {Header:"근무조|근무조",			Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"workOrgCd",		KeyField:1,	Format:"",			UpdateEdit:0,	InsertEdit:1},--%>
        <%--        {Header:"근무그룹|근무그룹",			Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"workGrpCd",		KeyField:1,	Format:"",			UpdateEdit:1,	InsertEdit:1},--%>
        <%--        {Header:"시작일|시작일",			Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"sdate",			KeyField:1,	Format:"Ymd",		UpdateEdit:0,	InsertEdit:1},--%>
        <%--        {Header:"요일|요일",				Type:"Combo",		Hidden:0,	Width:45,	Align:"Center",	ColMerge:0,	SaveName:"sdateWeek",		KeyField:0,	Format:"",			UpdateEdit:0,	InsertEdit:0},--%>
        <%--        {Header:"종료일|종료일",			Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"edate",			KeyField:0,	Format:"Ymd",		UpdateEdit:0,	InsertEdit:0},--%>
        <%--        {Header:"순서|순서",				Type:"Int",			Hidden:0,	Width:45,	Align:"Center",	ColMerge:0,	SaveName:"seq",				KeyField:0,	Format:"",			UpdateEdit:1,	InsertEdit:1},--%>
        <%--        {Header:"유의사항|유의사항",			Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"memo",			KeyField:0,	Format:"",			UpdateEdit:1,	InsertEdit:1},--%>

        <%--    ]; IBS_InitSheet(sheet2, initdata1);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);--%>
        <%--    sheet2.SetDataAlternateBackColor(sheet2.GetDataBackColor()); //홀짝 배경색 같게--%>

        <%--    // 세부내역--%>
        <%--    sheet2.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");--%>
        <%--    sheet2.SetDataLinkMouse("detail", 1);--%>


        <%--    /*(1:일, 2:월, 3:화, 4:수, 5:목, 6:금, 7:토)*/--%>
        <%--    sheet2.SetColProperty("sdateWeek", {ComboText:"|일|월|화|수|목|금|토", ComboCode:"|1|2|3|4|5|6|7"});--%>

        <%--    //공통코드 한번에 조회--%>
        <%--    var grpCds = "T11020";--%>
        <%--    var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists&useYn=Y","grpCd="+grpCds,false).codeList, "");--%>
        <%--    sheet2.SetColProperty("workGrpCd",  	{ComboText:"|"+codeLists["T11020"][0], ComboCode:"|"+codeLists["T11020"][1]} ); //근무조그룹--%>

        <%--}--%>

        //근무조 반복패턴
        <%--function init_sheet3(){--%>

        <%--    var initdata2 = {};--%>
        <%--    initdata2.Cfg = {SearchMode:smLazyLoad,Page:22, MergeSheet:5};--%>
        <%--    initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};--%>

        <%--    initdata2.Cols = [--%>
        <%--        {Header:"No|No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },--%>
        <%--        {Header:"\n삭제|\n삭제",	Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },--%>
        <%--        {Header:"상태|상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },--%>
        <%--        {Header:"근무조|근무조",	Type:"Combo",		Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"workOrgCd",	KeyField:1,	Format:"",		UpdateEdit:0,	InsertEdit:1,	EditLen:10 },--%>
        <%--        {Header:"시작일|시작일",	Type:"Text",		Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:1,	EditLen:10 },--%>
        <%--        {Header:"순서|순서",		Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"seq",			KeyField:1,	Format:"",		UpdateEdit:0,	InsertEdit:1,	EditLen:10 },--%>
        <%--        {Header:"요일|요일",		Type:"Text",		Hidden:0,	Width:45,	Align:"Center",	ColMerge:0,	SaveName:"weekNm",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0},--%>
        <%--        {Header:"근무시간|근무시간",	Type:"Combo",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"timeCd",		KeyField:1,	Format:"",		UpdateEdit:1,	InsertEdit:1,	EditLen:100 },--%>
        <%--    ]; IBS_InitSheet(sheet3, initdata2);sheet3.SetEditable("${editable}");sheet3.SetVisible(true);sheet3.SetCountPosition(4);--%>

        <%--    sheet3.SetDataAlternateBackColor(sheet3.GetDataBackColor()); //홀짝 배경색 같게--%>
        <%--    sheet3.SetFocusAfterProcess(0);--%>

        <%--    var workOrgCdList = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getCommonWorkOrgCdList"), "");--%>
        <%--    sheet2.SetColProperty("workOrgCd", 		{ComboText:"|"+workOrgCdList[0], ComboCode:"|"+workOrgCdList[1]} );--%>
        <%--    sheet3.SetColProperty("workOrgCd", 		{ComboText:"|"+workOrgCdList[0], ComboCode:"|"+workOrgCdList[1]} );--%>

        <%--}--%>

        <%--팝업 근무시간표리스트--%>
        function init_sheet4(){
            const initdata3 = {};
            initdata3.Cfg = {SearchMode:smLazyLoad,Page:22, MergeSheet:5};
            initdata3.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

            initdata3.Cols = [
                {Header:"코드|코드",	Type:"text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"timeCd", 		KeyField:0,	UpdateEdit:0,	InsertEdit:0},
                {Header:"근무시간|근무시간",	Type:"text",		Hidden:0,	Width:220,	Align:"Center",	ColMerge:0,	SaveName:"timeNm", 		KeyField:0,	UpdateEdit:0,	InsertEdit:0},
                {Header:"약어|약어",		Type:"text",		Hidden:0,	Width:170,	Align:"Center",	ColMerge:0,	SaveName:"shortTerm", KeyField:0,	UpdateEdit:0,	InsertEdit:0},

                //Hidden
                // {Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"workGrpCd"}
            <%--]; IBS_InitSheet(sheet4, initdata3);sheet4.SetEditable("${editable}");sheet4.SetVisible(true);sheet4.SetCountPosition(0);--%>
            ]; IBS_InitSheet(sheet4, initdata3);sheet4.SetEditable(0);sheet4.SetVisible(true);sheet4.SetCountPosition(0);
            sheet4.SetDataAlternateBackColor(sheet4.GetDataBackColor()); //홀짝 배경색 같게

        }


        //근무시간 그룹
        function init_sheet5(){
            const initdata4 = {};
            initdata4.Cfg = {SearchMode:smLazyLoad,Page:22, MergeSheet:5};
            initdata4.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

            initdata4.Cols = [
                {Header:"No|No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
                {Header:"\n삭제|\n삭제",	Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
                {Header:"상태|상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

                {Header:"근무시간|근무시간",	Type:"Combo",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"timeCd", 		KeyField:1,	UpdateEdit:0,	InsertEdit:1},
                {Header:"약어|약어",		Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"timeCdShort", KeyField:1,	UpdateEdit:0,	InsertEdit:0},

                //Hidden
                {Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"workGrpCd"},

            ]; IBS_InitSheet(sheet5, initdata4);sheet5.SetEditable("${editable}");sheet5.SetVisible(true);sheet5.SetCountPosition(4);
            sheet5.SetDataAlternateBackColor(sheet5.GetDataBackColor()); //홀짝 배경색 같게
            sheet5.SetFocusAfterProcess(0);

            var timeCdList    = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getWorkTimeCdList", false).codeList, "");
            sheet5.SetColProperty("timeCd",	{ComboText:timeCdList[0], ComboCode:timeCdList[1]} );

            var timeCdList2    = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getWorkTimeCdList&searchShortNameFlag=Y", false).codeList, "");
            sheet5.SetColProperty("timeCdShort",	{ComboText:timeCdList2[0], ComboCode:timeCdList2[1]} );

        }

        function init_sheet6(){
            const initdata3 = {};
            initdata3.Cfg = {SearchMode:smLazyLoad,Page:22, MergeSheet:5};
            initdata3.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

            initdata3.Cols = [
                {Header:"상태|상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
                {Header:"코드|코드",	Type:"text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"timeCd", 		KeyField:0,	UpdateEdit:0,	InsertEdit:0},
                {Header:"근무시간|근무시간",	Type:"text",		Hidden:0,	Width:220,	Align:"Center",	ColMerge:0,	SaveName:"timeNm", 		KeyField:0,	UpdateEdit:0,	InsertEdit:0},
                {Header:"약어|약어",		Type:"text",		Hidden:0,	Width:170,	Align:"Center",	ColMerge:0,	SaveName:"shortTerm", KeyField:0,	UpdateEdit:0,	InsertEdit:0},

                //Hidden
                {Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"workGrpCd"}
            ]; IBS_InitSheet(sheet6, initdata3);sheet6.SetEditable(0);sheet6.SetVisible(true);sheet6.SetCountPosition(0);
            sheet6.SetDataAlternateBackColor(sheet6.GetDataBackColor()); //홀짝 배경색 같게
        }


        //Sheet Action 근무조관리
        function doAction1(sAction) {
            switch (sAction) {

                case "Search":
                    sheet1.DoSearch( "${ctx}/WorkMappingMgr.do?cmd=getWorkMappingMgrList", $("#sheet1Form").serialize() );
                    break;
                case "Save":

                    if(!dupChk(sheet1,"mapTypeCd|mapCd|sdate", true, true)){break;}
                    IBS_SaveName(document.sheet1Form,sheet1);
                    sheet1.DoSave( "${ctx}/OrgMappingItemMngr.do?cmd=saveOrgMappingItemMngr", $("#sheet1Form").serialize());
                    break;
                case "Insert":
                    var row = sheet1.DataInsert(0);
                    sheet1.SetCellValue(row, "mapTypeCd", "500");
                    break;
                case "Copy":
                    var row = sheet1.DataCopy();
                    sheet1.SetCellValue(row, "sdate", "");
                    sheet1.SetCellValue(row, "edate", "");
                    break;
                case "Down2Excel":
                    var downcol = makeHiddenSkipCol(sheet1);
                    var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
                    sheet1.Down2Excel(param);
                    break;

            }
        }

        //sheet3 Action 근무조패턴관리 근무조
        function doAction2(sAction) {
            switch (sAction) {
                case "Search":
                    sheet2.DoSearch( "${ctx}/WorkPattenMgr.do?cmd=getWorkPattenMgrList", $("#sheet1Form").serialize(),1 );
                    break;
                case "Save":

                    if(!dupChk(sheet2,"workOrgCd|sdate", true, true)){break;}

                    IBS_SaveName(document.sheet1Form,sheet2);

                    if(sheet2.RowCount("D") > 0) {
                        if(confirm("<msg:txt mid='alertWorkPattenMgr1' mdef='삭제되는 근무소속에 해당하는 반복패턴이 모두 지워집니다.\n정말 삭제처리를 하시겠습니까?'/>")) {
                            sheet2.DoSave( "${ctx}/WorkPattenMgr.do?cmd=saveWorkPattenMgr", $("#sheet1Form").serialize(), -1, 0);
                        }
                    } else {
                        sheet2.DoSave( "${ctx}/WorkPattenMgr.do?cmd=saveWorkPattenMgr", $("#sheet1Form").serialize());
                    }
                    break;
                case "Save2":
                    sheet2.SetCellValue(gPRow, "memo", $("#note").val());
                    doAction2("Save");
                    break;
                case "Insert":
                    sheet2.SelectCell(sheet2.DataInsert(0), "workOrgCd");
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



        //Sheet3 Action 근무조패턴관리 반복패턴
        function doAction3(sAction) {
            switch (sAction) {
                case "Search":
                    /*입력상태일땐 디테일 조회 안함*/
                    if(sheet2.GetCellValue(sheet2.GetSelectRow(),"sStatus") == "I") {doAction3("Clear");return ;}
                    var param = "searchWorkOrgCd="+sheet2.GetCellValue(gPRow,"workOrgCd")+"&searchSdate="+sheet2.GetCellValue(gPRow,"sdate")+"&searchWorkGrpCd="+sheet2.GetCellValue(gPRow,"workGrpCd")
                    sheet3.DoSearch( "${ctx}/WorkPattenMgr.do?cmd=getWorkPattenUserMgrList", param,1 );
                    break;
                case "Save":

                    if(!dupChk(sheet3,"workOrgCd|seq", true, true)){break;}
                    IBS_SaveName(document.sheet1Form,sheet3);
                    sheet3.DoSave( "${ctx}/WorkPattenMgr.do?cmd=saveWorkPattenUserMgr" , $("#sheet1Form").serialize());
                    break;
                case "Insert":
                    //sheet3.SelectCell(sheet3.DataInsert(0), "seq");

                    var selectRow = sheet2.GetSelectRow();

                    if(sheet2.RowCount("I") > 0 || sheet2.RowCount("U") > 0 || sheet2.RowCount("D") > 0) {
                        alert("근무조를 먼저 저장 후 입력하여 주세요.");
                        return;
                    }
                    if(sheet2.RowCount() <= 0) {
                        alert("근무조가 없습니다.");
                        return;
                    }

                    var row = sheet3.DataInsert();

                    var workOrgCd = sheet2.GetCellValue(selectRow,"workOrgCd");
                    var sdate = sheet2.GetCellValue(selectRow,"sdate");

                    sheet3.SetCellValue(row,"workOrgCd",workOrgCd);
                    sheet3.SetCellValue(row,"sdate",sdate);
                    sheet3.SelectCell(row, "seq");
                    break;
                case "Copy":
                    sheet3.DataCopy();
                    break;
                case "Clear":
                    sheet3.RemoveAll();
                    break;
                case "Down2Excel":
                    var downcol = makeHiddenSkipCol(sheet3);
                    var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
                    sheet3.Down2Excel(param);
                    break;
            }
        }

        //sheet4 Action 근무
        <%--function doAction4(sAction) {--%>
        <%--    switch (sAction) {--%>
        <%--        case "Search":--%>
        <%--            var sXml = sheet4.GetSearchData("${ctx}/WorkTimeGrpMgr.do?cmd=getWorkPattenMgrGrpList", $("#sheet1Form").serialize() );--%>

        <%--            sXml = replaceAll(sXml, "sumDayWkLmtEdit",		"sumDayWkLmt#Edit");--%>
        <%--            sXml = replaceAll(sXml, "sumDayOtLmtEdit",		"sumDayOtLmt#Edit");--%>
        <%--            sXml = replaceAll(sXml, "sumWeekWkLmtEdit",		"sumWeekWkLmt#Edit");--%>
        <%--            sXml = replaceAll(sXml, "sumWeekOtLmtEdit",		"sumWeekOtLmt#Edit");--%>
        <%--            sXml = replaceAll(sXml, "avgDayWkLmtEdit",		"avgDayWkLmt#Edit");--%>
        <%--            sXml = replaceAll(sXml, "avgDayOtLmtEdit",		"avgDayOtLmt#Edit");--%>
        <%--            sXml = replaceAll(sXml, "avgWeekWkLmtEdit",		"avgWeekWkLmt#Edit");--%>
        <%--            sXml = replaceAll(sXml, "avgWeekOtLmtEdit",		"avgWeekOtLmt#Edit");--%>

        <%--            sheet4.LoadSearchData(sXml );--%>
        <%--            break;--%>
        <%--        case "Save":--%>
        <%--            // IBS_SaveName(document.sheet1Form,sheet4);--%>
        <%--            &lt;%&ndash;sheet4.DoSave( "${ctx}/WorkTimeGrpMgr.do?cmd=saveWorkPattenMgrGrp", $("#sheet1Form").serialize());&ndash;%&gt;--%>

        <%--            break;--%>
        <%--    }--%>
        <%--}--%>

        //Sheet3 Action 사용근무시간표
        function doAction5(sAction) {
            switch (sAction) {
                case "Search":

                    /*입력상태일땐 디테일 조회 안함*/
                    if(sheet5.GetCellValue(sheet5.GetSelectRow(),"sStatus") == "I") {doAction5("Clear");return ;}
                    sheet5.DoSearch( "${ctx}/WorkTimeGrpMgr.do?cmd=getWorkPattenMgrTimeGrp", $("#sheet1Form").serialize(),1 );
                    break;
                case "Save":

                    if(!dupChk(sheet5,"timeCd", true, true)){break;}
                    IBS_SaveName(document.sheet1Form,sheet5);
                    sheet5.DoSave( "${ctx}/WorkTimeGrpMgr.do?cmd=saveWorkPattenMgrTimeGrp" , $("#sheet1Form").serialize());
                    break;
                case "Insert":

                    var selectRow = sheet1.GetSelectRow();
                    var row = sheet5.DataInsert(0);

                    sheet5.SetCellValue(row,"workGrpCd",sheet5.GetCellValue(selectRow,"workGrpCd"));

                    break;
                case "Copy":
                    sheet5.DataCopy();
                    break;
                case "Clear":
                    sheet5.RemoveAll();
                    break;
            }
        }

        //-----------------------------------------------------------------------------------
        //		sheet1 이벤트
        //-----------------------------------------------------------------------------------
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
            try {
                if (Msg != "") {
                    alert(Msg);
                }
                if( Code > -1 ) doAction1("Search");
            } catch (ex) {
                alert("OnSaveEnd Event Error " + ex);
            }
        }

        //---------------------------------------------------------------------------------------------------------------
        // sheet2 Event
        //---------------------------------------------------------------------------------------------------------------

        // 조회 후 에러 메시지
        function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
            try {
                if (Msg != "") {
                    alert(Msg);
                }
                sheetResize();
            } catch (ex) {
                alert("OnSearchEnd Event Error : " + ex);
            }
        }

        // 저장 후 메시지
        function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
            try {
                if (Msg != "") {
                    alert(Msg);
                }
                if( Code > -1 ) {
                    doAction3("Clear");
                    doAction2("Search");
                }
            } catch (ex) {
                alert("OnSaveEnd Event Error " + ex);
            }
        }

        // 셀 변경시 발생
        function sheet2_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
            try {
                if(sheet2.GetSelectRow() > 0) {
                    if(OldRow != NewRow) {
                        gPRow = NewRow;
                        $("#note").val(sheet2.GetCellValue(NewRow, "memo"));

                        setPattenTimeCd(NewRow);


                        doAction3("Search");
                    }
                }
            } catch (ex) {
                alert("OnSelectCell Event Error : " + ex);
            }
        }

        function setPattenTimeCd(row){
            //근무조의 근무시간 그룹에서 조회
            var param = "&searchShortNameFlag=Y"
                + "&searchWorkGrpCd="+sheet2.GetCellValue(row,"workGrpCd");

            var timeCdList    = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getWorkOrgTimeCdList"+param,false).codeList, "");
            sheet3.SetColProperty("timeCd",	{ComboText:timeCdList[0], ComboCode:timeCdList[1]} );

        }


        function sheet2_OnChange(Row, Col, Value) {
            try{
                if(sheet2.ColSaveName(Col) == "sdate") {
                    var d = new Date(sheet2.GetCellText(Row, Col)).getDay()+1;
                    sheet2.SetCellValue(Row, "sdateWeek", d);

                }
            }catch(ex){alert("OnChange Event Error : " + ex);}
        }

        function sheet2_OnValidation(Row, Col, Value){
            try{
                if(sheet2.ColSaveName(Col) == "sdateWeek") {
                    //단위기간
                    var ival = parseInt( sheet2.GetCellValue(sheet2.GetSelectRow(), "intervalCd") );

                    if(Value != $("#stdWeek").val() && ival % 7 == 0 ){  //주단위 일때는
                        alert("시작일자는 "+weekArr[$("#stdWeek").val()]+"요일이어야 합니다.");
                        sheet2.ValidateFail(1);
                        sheet2.SelectCell(Row, "sdate");
                        return;
                    }
                }

            }catch(ex){alert("OnValidation Event Error : " + ex);}
        }

        //---------------------------------------------------------------------------------------------------------------
        // sheet3 Event
        //---------------------------------------------------------------------------------------------------------------

        // 조회 후 에러 메시지
        function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
            try {
                if (Msg != "") {
                    alert(Msg);
                }
                sheetResize();
            } catch (ex) {
                alert("OnSearchEnd Event Error : " + ex);
            }
        }

        // 저장 후 메시지
        function sheet3_OnSaveEnd(Code, Msg, StCode, StMsg) {
            try {
                if (Msg != "") {
                    alert(Msg);
                }
                if( Code > -1 ) {
                    doAction3("Search");
                }
            } catch (ex) {
                alert("OnSaveEnd Event Error " + ex);
            }
        }

        function showHelpPop(){
            $("#workLaw").show();
        }
        function closeHelpPop(){
            $("#workLaw").hide();
        }

        function grpSave(){
            if(isChange){
                if(confirm("저장하시겠습니까?")){

                    if($("#sdateWeek").val() === '월'){
                        $("#sdateWeek").val('2');
                    } else if($("#sdateWeek").val() === '화'){
                        $("#sdateWeek").val('3');
                    } else if($("#sdateWeek").val() === '수'){
                        $("#sdateWeek").val('4');
                    } else if($("#sdateWeek").val() === '목'){
                        $("#sdateWeek").val('5');
                    } else if($("#sdateWeek").val() === '금'){
                        $("#sdateWeek").val('6');
                    } else if($("#sdateWeek").val() === '토'){
                        $("#sdateWeek").val('7');
                    } else if($("#sdateWeek").val() === '일'){
                        $("#sdateWeek").val('1');
                    }

                    if($("#toggle1").val() === 'on'){
                        $("#toggle1").val('Y');
                    } else {
                        $("#toggle1").val('N');
                    }

                    if($("#toggle2").val() === 'on'){
                        $("#toggle2").val('Y');
                    } else {
                        $("#toggle2").val('N');
                    }

                    let sdateReplace = $("#searchYmd1").val().replaceAll('-','');
                    $("#searchYmd1").val(sdateReplace);


                    let grpData = $('#grpData').serialize();
                    $.ajax({
                        url : "${ctx}/WorkTimeGrpMgr.do?cmd=saveWorkPattenMgrGrp",
                        type : "post",
                        data : grpData,
                        async : false,
                        success :function(data){
                            let result;
                            alert(data.Result.Message);
                            init_data();
                            isChange = false;
                            // history.go(0);
                        }
                    })
                }
            } else {
                alert("저장할 내역이 없습니다.");
            }

        }

        //---------------------------------------------------------------------------------------------------------------
        // sheet4 Event
        //---------------------------------------------------------------------------------------------------------------
        function sheet4_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {

            if(OldRow > 0){
                let list = document.createElement('div');
                list.className='list';

                let name = document.createElement('span');
                name.className = 'name';

                let code = document.createElement('input');
                code.type = 'hidden';
                code.className = 'code';

                let mdi = document.createElement('i');
                mdi.className = 'mdi-ico filled';

                const timeTable = document.querySelector('.time_table_select');
                timeTable.appendChild(list);
                list.appendChild(name);
                list.appendChild(code);
                name.innerText = sheet4.GetCellValue(NewRow, 'timeNm');
                code.innerText = sheet4.GetCellValue(NewRow, 'timeCd');
                list.appendChild(mdi);
                mdi.innerText = 'cancel';
                mdi.addEventListener('click', function(){
                    list.remove();

                });
                sheet6.DataInsert(2, 0);
                sheet6.SetRowData(2,{'timeCd' : sheet4.GetCellValue(NewRow, 'timeCd')});

            }
        }

        //근무시간표 조건 검색
        function likePattenTimeCd(){
            const param = "&workTimeNm=" + $("#workTimeNm").val()
                + "&searchWorkGrpCd=" + $("#workGrpCd").val()
                + "&dayOff=" + $("#dayOff").val();

            const timeCdList = sheet4.GetSearchData("${ctx}/WorkTimeGrpMgr.do?cmd=getTimeCdList", "queryId=getWorkTimeOrgTimeCdList" + param, false);
            sheet4.LoadSearchData(timeCdList);
        }

        //근무시간표 추가 모달창 close
        function closeAddWorkTimeModal(){
            closeAddWorkTimeTable();
            $('.time_table_select div').remove();
            sheet4.RemoveAll();
            sheet6.RemoveAll();
            $('#workTimeNm').val('');
            $('#dayOff').val('');


        }

        //근무시간표 추가
        function saveWorkTimePattenAdd(){

            if(!dupChk(sheet6,"timeCd", true, true)) return;

            IBS_SaveName(document.sheet1Form,sheet6);
            sheet6.DoSave( "${ctx}/WorkTimeGrpMgr.do?cmd=saveWorkPattenMgrTimeGrp" , $("#sheet1Form").serialize());

        }

        // 저장 후 메시지
        function sheet6_OnSaveEnd(Code, Msg, StCode, StMsg) {
            closeAddWorkTimeModal();

            try {
                if (Msg != "") {
                    alert(Msg);
                }
                if( Code > -1 ) {
                    doAction5("Search");
                }
            } catch (ex) {
                alert("OnSaveEnd Event Error " + ex);
            }
        }


    </script>
    <style type="text/css">
        div.explain .txt ul li {font-size:11px; color:#000;padding-top:3px;}
    </style>
</head>
<body class="hidden">
    <div class="wrapper">
        <form id="sheet1Form" name="sheet1Form">
            <input type="hidden" id="searchMapTypeCd" name="searchMapTypeCd" value="500" /><!-- 근무조 -->
            <input type="hidden" id="stdWeek" name="stdWeek" />
            <input type="hidden" id="searchWorkGrpCd" name="searchWorkGrpCd" />
        </form>

        <header class="header full outer">
            <div class="inner">
                <div id="workTab" class="wizard_wrap">
                    <span id="contentTitle" class="title_text">근무그룹관리</span>
                    <div class="wizard_box">
                        <a href="#" class="wizard_btn">
                            <span>1</span>
                            <div>
                                <b>근무그룹관리</b><br />
                            </div>
                        </a>
                        <i class="mdi-ico">keyboard_arrow_right</i>
                        <a href="#" class="wizard_btn active">
                            <span>2</span>
                            <div>
                                <b>근무그룹설정</b><br />
                            </div>
                        </a>
                        <i class="mdi-ico">keyboard_arrow_right</i>
                        <a href="#" class="wizard_btn" >
                            <span>3</span>
                            <div>
                                <b>근무조 관리</b><br/>
                            </div>
                        </a>
                        <i class="mdi-ico">keyboard_arrow_right</i>
                        <a href="#" class="wizard_btn">
                            <span>4</span>
                            <div><b>근무조패턴관리</b><br/><p></p></div>
                        </a>
                    </div>
                </div>
            </div>
        </header>

<%--        <form action="${ctx}/WorkTimeGrpMgr.do?cdm=saveWorkPattenMgrGrp" id="grpData" method="post">--%>
        <form id="grpData" method="post">
            <main id="work2" class="work_group_setting_wrap">
                <section class="sheet_section">
                    <table class="sheet_main table_top">
                        <colgroup>
                            <col width="">
                            <col width="20px">
                            <col width="540px">
                        </colgroup>
                        <tbody>
                        <tr>
                            <td>
                                <div class="content_box content_box1">
                                    <header>
                                        <p>
                                            <span class="step">Step 01</span>
                                            <span class="name">근무그룹설정</span>

                                        </p>
                                        <div class="btn_wrap">
                                            <button type="button" class="btn outline_gray" onclick="showHelpPop()">근로기준법</button>
                                            <button type="button" class="btn dark check" onclick="grpSave()">저장</button>
                                        </div>
                                    </header>


                                    <table class="basic type5 no_border table_bot">
                                        <colgroup>
                                            <col width="84px">
                                            <col width="182px">
                                            <col width="84px">
                                            <col width>
                                        </colgroup>

                                        <tbody>
                                        <tr>
                                            <th>
                                                <span class="req">근로시간제</span>
                                            </th>
                                            <td>
                                                <select id ="workOrgTypeCd" name="workOrgTypeCd" class="custom_select">
                                                    <option value="A">선택</option>
                                                    <option value="B">시차</option>
                                                    <option value="C">탄력</option>
                                                </select>
                                            </td>
                                            <th>
                                                <span class="req">근로그룹명</span>
                                            </th>
                                            <td>
<%--                                                <input id="workName" name="workGrpCd" class="form-input" type="text">--%>
                                                <select id="workGrpCd" name="workGrpCd" class="custom_select">
                                                    <option value="B3">시차근무그룹(사무직)</option>
                                                    <option value="B1">탄력근무그룹(사무직)</option>
                                                    <option value="B2">탄력근무그룹(생산직)</option>
                                                    <option value="A1">선택근무그룹</option>
                                                    <option value="C1">영업근무그룹</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>
                                                <span class="req">근무주기</span>
                                            </th>
                                            <td>
                                                <select id="intervalCd" name="intervalCd" class="custom_select">
                                                    <option value="">선택</option>
                                                    <option value="7">1주</option>
                                                    <option value="14">2주</option>
                                                    <option value="21">3주</option>
                                                    <option value="28">4주</option>
                                                    <option value="30">1달</option>
                                                    <option value="60">2달</option>
                                                    <option value="90">3달</option>
                                                </select>
                                            </td>
                                            <th>
                                                <span class="req">근무시작일</span>
                                            </th>
                                            <td class="work_start">
                                                <input
                                                        class="date2 bbit-dp-input"
                                                        type="text"
                                                        value=""
                                                        id="searchYmd1"
                                                        name="sdate"
                                                />
                                                <input id="sdateWeek" name="sdateWeek" class="form-input custom_small" type="text">
                                            </td>
                                        </tr>
                                        </tbody>
                                    </table>

                                    <header>
                                        <span class="name">근무한도</span>
                                    </header>
                                    <table class="basic type5 no_border table_bot work_limit">
                                        <colgroup>
                                            <col width="60px">
                                            <col width="84px">
                                            <col width>
                                        </colgroup>
                                        <tbody>
                                        <tr>
                                            <td rowspan="2" class="limit basic_limit">
                                                <span class="bold">기본한도(합계)</span>
                                            </td>
                                            <td>
                                                <span class="bold">일 단위<br/>근무시간</span>
                                            </td>
                                            <td>
                                                1일 근무 시간 합계 한도는
                                                <span class="bold basic_work">기본근무</span>
                                                <input id="sumDayWkLmt" name="sumDayWkLmt" class="form-input custom_small" type="text">
                                                <span class="bold extension_work">연장근무</span>
                                                <input id="sumDayOtLmt" name="sumDayOtLmt" class="form-input custom_small" type="text">
                                                입니다.
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <span class="bold">주 단위<br/>근무시간</span>
                                            </td>
                                            <td>
                                                1주 근무 시간 합계 한도는
                                                <span class="bold basic_work">기본근무</span>
                                                <input id="sumWeekWkLmt" name="sumWeekWkLmt" class="form-input custom_small" type="text">
                                                <span class="bold extension_work">연장근무</span>
                                                <input id="sumWeekOtLmt" name="sumWeekOtLmt" class="form-input custom_small" type="text">
                                                입니다.
                                            </td>
                                        </tr>
                                        <tr>
                                            <td rowspan="2" class="limit average_limit">
                                                <span class="bold">단위기간평균한도</span>
                                            </td>
                                            <td>
                                                <span class="bold">일 단위<br/>평균한도</span>
                                            </td>
                                            <td>
                                                단위기간 내 1일 근무시간 평균 한도
                                                <span class="bold basic_work">기본근무</span>
                                                <input id="avgDayWkLmt" name="avgDayWkLmt"class="form-input custom_small" type="text" disabled>
                                                <span class="bold extension_work">연장근무</span>
                                                <input id="avgDayOtLmt" name="avgDayOtLmt" class="form-input custom_small" type="text" disabled>
                                                입니다.
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <span class="bold">주 단위<br/>평균한도</span>
                                            </td>
                                            <td>
                                                단위기간 내 1주 근무시간 평균 한도
                                                <span class="bold basic_work">기본근무</span>
                                                <input id="avgWeekWkLmt" name="avgWeekWkLmt" class="form-input custom_small" type="text">
                                                <span class="bold extension_work">연장근무</span>
                                                <input id="avgWeekOtLmt" name="avgWeekOtLmt" class="form-input custom_small" type="text">
                                                입니다.
                                            </td>
                                        </tr>
                                        </tbody>
                                    </table>

                                    <header>
                                        <span class="name">상세설정</span>
                                    </header>
                                    <table class="basic type5 no_border table_bot detail_setting">
                                        <colgroup>
                                            <col width="84px">
                                            <col width="260px">
                                            <col width="84px">
                                            <col width>
                                        </colgroup>
                                        <tbody>
                                        <tr>
                                            <th>출근시간<br />고정</th>
                                            <td>
                                                <input type="checkbox" id="toggle1" name="fixStTimeYn" hidden="">
                                                <label for="toggle1" class="toggleSwitch">
                                                    <span id class="toggleButton"></span>
                                                </label>
                                                <span>
                                                            출근 시간이 스케쥴 상의 근무시간으로<br />고정 표시됩니다.
                                                        </span>
                                            </td>
                                            <th>퇴근시간<br />고정</th>
                                            <td>
                                                <input type="checkbox" id="toggle2" name="fixEdTimeYn" hidden="">
                                                <label for="toggle2" class="toggleSwitch">
                                                    <span class="toggleButton"></span>
                                                </label>
                                                <span>
                                                            퇴근 시간이 스케쥴 상의 근무시간으로<br />고정 표시됩니다.
                                                        </span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>비고</th>
                                            <td colspan="3">
                                                <input id="memo" name="memo" class="form-input" type="text">
                                            </td>
                                        </tr>
                                        </tbody>
                                    </table>
                                    <!-- 개발 시 참조 : 추가내용이 없다면 아래의 br태그는 삭제해주세요 -->
                                    <br/><br/><br/><br/>
                                </div>
                            </td>
                            <!-- 여백 -->
                            <td></td>
                            <td>
                                <div class="content_box content_box2">
                                    <header>
                                        <p>
                                            <span class="step">Step 02</span>
                                            <span class="name">사용 근무 시간표</span>
                                        </p>
                                        <div class="btn_wrap">
                                            <button type="button" class="btn outline_gray" onclick="openAddWorkTimeTable()">추가</button>
                                            <button type="button" class="btn outline_gray">복사</button>
                                            <button type="button" class="btn dark check">저장</button>
                                        </div>
                                    </header>
                                    <div class="sheet_area work_time_table">
                                        <script type="text/javascript"> createIBSheet("sheet5", "100%", "100%", "${ssnLocaleCd}"); </script>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3">
                                <header>
                                    <span class="name">근무그룹</span>
                                </header>
                                <div class="sheet_area work_group">

                                </div>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </section>
            </main>
        </form>
        <div id = "work3">
            <main class = "main_tab_content">
                <div class="header" style="justify-content: left">
                    <h3 class="table_title">근무조관리</h3>
                </div>
                <div class="sheet_search outer">
                    <table style="min-height: 40px">
                        <tr>
                            <th>근무조명</th>
                            <td>
                                <input class="form-input" type="text" placeholder="근무조명을 입력하세요">
                            </td>
                            <th>기준일자</th>
                            <td>
                                <input type="text" id="searchYmd" name="searchYmd" class="date2" />
                            </td>
                            <td><a href="javascript:doAction1('Search')" class="button">조회</a></td>
                        </tr>
                    </table>
                </div>
            </main>
            <div class="inner">
                <div class="sheet_title">
                    <ul>
                        <li class="btn">
                            <btn:a href="javascript:doAction1('Insert')" css="basic authA" mid='insert' mdef="입력"/>
                            <btn:a href="javascript:doAction1('Copy')" 	css="basic authA" mid='copy' mdef="복사"/>
                            <btn:a href="javascript:doAction1('Save')" 	css="basic authA" mid='save' mdef="저장"/>
                            <a href="javascript:doAction1('Down2Excel')" 	class="basic authR">다운로드</a>

                        </li>
                    </ul>
                </div>
            </div>
            <script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
        </div>

        <div class="main_tab_content main_content tab_layout white">
            <main class="work_crew_pattern_management_wrap">
                <section class="sheet_section">
                    <div class="header">
                        <h3 class="table_title">근무조패턴관리</h3>
                        <button class="btn filled">저장</button>
                    </div>
                    <table class="basic type5 no_border table_top">
                        <colgroup>
                            <col width="84px">
                            <col width="162px">
                            <col width="84px">
                            <col width="164px">
                            <col width="84px">
                            <col width="164px">
                            <col width="84px">
                            <col width>
                        </colgroup>
                        <tbody>
                        <tr>
                            <th><span class="req">근무조</span></th>
                            <td>
                                <div class="search_input">
                                    <input class="form-input" type="text">
                                    <i class="mdi-ico">search</i>
                                </div>
                            </td>
                            <th><span class="req">근무그룹</span></th>
                            <td>
                                <select class="custom_select">
                                    <option value="">선택</option>
                                    <option value="1">시차근무그룹(사무직)</option>
                                    <option value="2">탄력근무그룹(사무직)</option>
                                    <option value="3">탄력근무그룹(생산직A)</option>
                                    <option value="4">선택근무그룹</option>
                                </select>
                            </td>
                            <th><span class="req">시작일자</span></th>
                            <td>
                                <input
                                        class="date2 bbit-dp-input"
                                        type="text"
                                        value=""
                                        id="searchYmd1"
                                />
                            </td>
                            <th>패턴<br/>반복주기</th>
                            <td class="repeat_pattern">
                                <select class="custom_select">
                                    <option value="">선택</option>
                                    <option value="1">1주</option>
                                    <option value="2">2주</option>
                                    <option value="3">3주</option>
                                    <option value="4">4주</option>
                                </select>
                                <button class="btn dark check">생성</button>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                    <table class="sheet_main table_bot">
                        <colgroup>
                            <col width="276px">
                            <col width="24px">
                            <col width>
                        </colgroup>
                        <tbody>
                        <td>
                            <div class="sheet_top_area">
                                <span class="title">근무시간표</span>
                                <input class="form-input" type="text" placeholder="시간표명 조회">
                            </div>
                            <div class="time_table">
                                <header>
                                    근무시간표
                                </header>
                                <div class="list">
                                    <div class="name">기08H</div>
                                    <span class="time">08:00 - 17:00</span>
                                    <button class="btn_select">선택</button>
                                </div>
                                <div class="list">
                                    <div class="name">기08</div>
                                    <span class="time">08:00 - 17:00</span>
                                    <button class="btn_select">선택</button>
                                </div>
                                <div class="list">
                                    <div class="name">기09</div>
                                    <span class="time">08:00 - 17:00</span>
                                    <button class="btn_select">선택</button>
                                </div>
                                <div class="list">
                                    <div class="name">휴무</div>
                                    <span class="time">08:00 - 17:00</span>
                                    <button class="btn_select">선택</button>
                                </div>
                                <div class="list">
                                    <div class="name">주휴</div>
                                    <span class="time">08:00 - 17:00</span>
                                    <button class="btn_select">선택</button>
                                </div>
                                <div class="list">
                                    <div class="name">기10</div>
                                    <span class="time">08:00 - 17:00</span>
                                    <button class="btn_select">선택</button>
                                </div>
                            </div>
                        </td>
                        <td></td>
                        <td>
                            <div class="sheet_top_area">
                                <div class="standard_ym">
                                    <span class="name">기준년월</span>
                                    <input
                                            class="date2 bbit-dp-input"
                                            type="text"
                                            value=""
                                            id="searchYmd2"
                                    />
                                </div>
                                <div class="box">
                                    <button class="btn dark check" onclick="openWorkCrewCheck()">추가</button>
                                </div>
                                <div style="display: none">
                                    <script type="text/javascript">createIBSheet("sheet6", "100%", "100%", "${ssnLocaleCd}"); </script>
                                </div>
                            </div>
                            <div class="sheet_area"></div>
                        </td>
                        </tbody>
                    </table>
                </section>
            </main>
        </div>

        <div class="modal_add_work_time_table">
            <div class="modal_background" onclick="closeAddWorkTimeModal()"></div>
            <div class="modal wide">
                <div class="modal_header">
                    <span>근무시간표 추가</span><i class="mdi-ico" onclick="closeAddWorkTimeModal()">close</i>
                </div>
                <div class="modal_body">
                    <div class="modal_body_content">
                        <section class="sheet_section">
                            <table class="sheet_main">
                                <colgroup>
                                    <col width="470px">
                                    <col width="12px">
                                    <col width="270px">
                                </colgroup>
                                <tbody>
                                <tr>
                                    <td>
                                        <div class="title">근무시간표리스트</div>
                                        <table class="basic type5 no_border time_table_list">
                                            <colgroup>
                                                <col width="84px">
                                                <col width="150px">
                                                <col width="84px">
                                                <col width>
                                            </colgroup>
                                            <tr>
                                                <th>근무시간명</th>
                                                <td>
                                                    <input id="workTimeNm" class="form-input" type="text">
                                                </td>
                                                <th>휴일여부</th>
                                                <td class="select_dayoff">
                                                    <select id="dayOff" class="custom_select">
                                                        <option value="">선택</option>
                                                        <option value="Y">Y</option>
                                                        <option value="N">N</option>
                                                    </select>
                                                    <button class="btn dark check" onclick="likePattenTimeCd()">조회</button>
                                                </td>
                                            </tr>
                                        </table>
                                        <div class="sheet_area">
                                            <script type="text/javascript"> createIBSheet("sheet4", "100%", "100%", "${ssnLocaleCd}"); </script>
                                        </div>
                                    </td>
                                    <td></td>
                                    <td>
                                        <div class="title">근무시간표선택</div>
                                        <div class="time_table_select">

                                            <div class="list_total_num">
                                                <p>
                                                    총 <span class="num">6</span> 개
                                                </p>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </section>
                    </div>
                </div>
                <div class="modal_footer">
                    <button id="modal_cancel_btn" class="btn outline_gray" onclick="closeAddWorkTimeModal()">취소</button>
                    <button id="modal_submit_btn" class="btn filled" onclick="saveWorkTimePattenAdd()">추가하기</button>
                </div>
            </div>
        </div>
    </div>


    <div id="workLaw" style="position:absolute; top:150px; left:50%; width:100%; margin-left:-300px;height:250px;background-color:transparent;  display:none; z-index:31;">
        <div class="explain spacingN" style="margin:0;padding:5px;letter-spacing:1; width:720px;height:460px;">
            <div class="popup_title">
                <ul>
                    <li id="title-pop">근로기준법 (2020-05-26)</li>
                    <li class="close" onclick="closeHelpPop()"></li>
                </ul>
            </div>
            <div class="h10"></div>
            <div class="noti_icon3"></div>
            <div class="txt" style=" width:700px;height:330px; overflow:auto;">
                <b>제50조(근로시간)</b>
                <br>① 1주 간의 근로시간은 휴게시간을 제외하고 40시간을 초과할 수 없다.
                <br>② 1일의 근로시간은 휴게시간을 제외하고 8시간을 초과할 수 없다.
                <br>③ 제1항 및 제2항에 따라 근로시간을 산정하는 경우 작업을 위하여 근로자가 사용자의 지휘ㆍ감독 아래에 있는 대기시간 등은 근로시간으로 본다. <신설 2012. 2. 1., 2020. 5. 26.>
                <br><br><b>제51조(탄력적 근로시간제)</b>
                <br>① 사용자는 취업규칙(취업규칙에 준하는 것을 포함한l다)에서 정하는 바에 따라 2주 이내의 일정한 단위기간을 평균하여 1주 간의 근로시간이 제50조제1항의 근로시간을 초과하지 아니하는 범위에서 특정한 주에 제50조제1항의 근로시간을, 특정한 날에 제50조제2항의 근로시간을 초과하여 근로하게 할 수 있다. 다만, 특정한 주의 근로시간은 48시간을 초과할 수 없다.
                <br>② 사용자는 근로자대표와의 서면 합의에 따라 다음 각 호의 사항을 정하면 3개월 이내의 단위기간을 평균하여 1주 간의 근로시간이 제50조제1항의 근로시간을 초과하지 아니하는 범위에서 특정한 주에 제50조제1항의 근로시간을, 특정한 날에 제50조제2항의 근로시간을 초과하여 근로하게 할 수 있다. 다만, 특정한 주의 근로시간은 52시간을, 특정한 날의 근로시간은 12시간을 초과할 수 없다.
                <br>1. 대상 근로자의 범위
                <br>2. 단위기간(3개월 이내의 일정한 기간으로 정하여야 한다)
                <br>3. 단위기간의 근로일과 그 근로일별 근로시간
                <br>4. 그 밖에 대통령령으로 정하는 사항
                <br>③ 제1항과 제2항은 15세 이상 18세 미만의 근로자와 임신 중인 여성 근로자에 대하여는 적용하지 아니한다.
                <br>④ 사용자는 제1항 및 제2항에 따라 근로자를 근로시킬 경우에는 기존의 임금 수준이 낮아지지 아니하도록 임금보전방안(임김보전방안)을 강구하여야 한다.
                <br><br><b>제52조(선택적 근로시간제)</b>
                <br>사용자는 취업규칙(취업규칙에 준하는 것을 포함한다)에 따라 업무의 시작 및 종료 시각을 근로자의 결정에 맡기기로 한 근로자에 대하여 근로자대표와의 서면 합의에 따라 다음 각 호의 사항을 정하면 1개월 이내의 정산기간을 평균하여 1주간의 근로시간이 제50조제1항의 근로시간을 초과하지 아니하는 범위에서 1주 간에 제50조제1항의 근로시간을, 1일에 제50조제2항의 근로시간을 초과하여 근로하게 할 수 있다.
                <br>1. 대상 근로자의 범위(15세 이상 18세 미만의 근로자는 제외한다)
                <br>2. 정산기간(1개월 이내의 일정한 기간으로 정하여야 한다)
                <br>3. 정산기간의 총 근로시간
                <br>4. 반드시 근로하여야 할 시간대를 정하는 경우에는 그 시작 및 종료 시각
                <br>5. 근로자가 그의 결정에 따라 근로할 수 있는 시간대를 정하는 경우에는 그 시작 및 종료 시각
                <br>6. 그 밖에 대통령령으로 정하는 사항
                <br><br><b>제53조(연장 근로의 제한)</b>
                <br>① 당사자 간에 합의하면 1주 간에 12시간을 한도로 제50조의 근로시간을 연장할 수 있다.
                <br>② 당사자 간에 합의하면 1주 간에 12시간을 한도로 제51조의 근로시간을 연장할 수 있고, 제52조제2호의 정산기간을 평균하여 1주 간에 12시간을 초과하지 아니하는 범위에서 제52조의 근로시간을 연장할 수 있다.
                <br>③ 상시 30명 미만의 근로자를 사용하는 사용자는 다음 각 호에 대하여 근로자대표와 서면으로 합의한 경우 제1항 또는 제2항에 따라 연장된 근로시간에 더하여 1주 간에 8시간을 초과하지 아니하는 범위에서 근로시간을 연장할 수 있다. <신설 2018ㆍ3ㆍ20>
                <br>1. 제1항 또는 제2항에 따라 연장된 근로시간을 초과할 필요가 있는 사유 및 그 기간
                <br>2. 대상 근로자의 범위
                <br>④ 사용자는 특별한 사정이 있으면 고용노동부장관의 인가와 근로자의 동의를 받아 제1항과 제2항의 근로시간을 연장할 수 있다. 다만, 사태가 급박하여 고용노동부장관의 인가를 받을 시간이 없는 경우에는 사후에 지체 없이 승인을 받아야 한다. <개정 2010·6·4>
                <br>⑤ 노동부장관은 제4항에 따른 근로시간의 연장이 부적당하다고 인정하면 그 후 연장시간에 상당하는 휴게시간이나 휴일을 줄 것을 명할 수 있다. <개정 2018ㆍ3ㆍ20>
                <br>⑥ 제3항은 15세 이상 18세 미만의 근로자에 대하여는 적용하지 아니한다. <신설 2018ㆍ3ㆍ20>
            </div>
        </div>
    </div>
</body>
</html>
