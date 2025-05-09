<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
    <%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
    <%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
    <%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
    <script type="text/javascript">
        var p = eval("${popUpStatus}");
        var gSheet = "";
        var gSheetNm = "";

        var arg = p.popDialogArgumentAll();

        var trmCd       = arg['trmCd'];
        var trmType     = arg['trmType'];
        var trmNm       = arg['trmNm'];
        var searchSabun = arg['searchSabun'];
        var eduList     = arg['eduList'];

        $(function() {

            console.log(arg);

            $("#title").html("Tranning Road Map ["+trmNm + "]");

            $('#searchSabun').val(searchSabun);
            $('#searchTrmType').val(trmType);
            $('#searchTrmCode').val(trmCd);

            var initdata = {};
            initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msAll};
            initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
            initdata.Cols = [
                {Header:"선택"                                   , 	    Type:"CheckBox",Hidden:0, Width:45 ,  Align:"Center", ColMerge:0, SaveName:"sel"        , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:1, InsertEdit:0, EditLen:1  },
                {Header:"<sht:txt mid='BLANK' mdef='직렬코드' />",      Type:"Text",    Hidden:1, Width:0  ,  Align:"Left"  , ColMerge:0, SaveName:"itemGubun"  , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10 },
                {Header:"<sht:txt mid='BLANK' mdef='직렬'     />",      Type:"Text",    Hidden:1, Width:150,  Align:"Left"  , ColMerge:1, SaveName:"education"  , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10 },
                {Header:"<sht:txt mid='BLANK' mdef='교육명'   />",      Type:"Text",    Hidden:0, Width:0  ,  Align:"Left"  , ColMerge:0, SaveName:"educationnm", KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10 },
                {Header:"<sht:txt mid='BLANK' mdef='직무'     />",      Type:"Text",    Hidden:1, Width:200,  Align:"Left"  , ColMerge:0, SaveName:"num"        , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10 },
                {Header:"<sht:txt mid='BLANK' mdef='직무'     />",      Type:"Text",    Hidden:1, Width:200,  Align:"Left"  , ColMerge:0, SaveName:"time"       , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10 },
                {Header:"<sht:txt mid='BLANK' mdef='직무'     />",      Type:"Text",    Hidden:1, Width:200,  Align:"Left"  , ColMerge:0, SaveName:"useYn"      , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10 },
            ];
            IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(0);

            var initdata2 = {};
            initdata2.Cfg = {SearchMode:smLazyLoad, Page:22,MergeSheet:msAll};
            initdata2.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
            initdata2.Cols = [
                {Header:"선택"                                   , 	    Type:"CheckBox",Hidden:0, Width:45 ,  Align:"Center", ColMerge:0, SaveName:"sel"        , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:1, InsertEdit:0, EditLen:1  },
                {Header:"<sht:txt mid='BLANK' mdef='직렬코드' />",      Type:"Text",    Hidden:1, Width:0  ,  Align:"Left", ColMerge:0, SaveName:"itemGubun"  , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10 },
                {Header:"<sht:txt mid='BLANK' mdef='직렬'     />",      Type:"Text",    Hidden:1, Width:150,  Align:"Left", ColMerge:1, SaveName:"education"  , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10 },
                {Header:"<sht:txt mid='BLANK' mdef='교육명'   />",      Type:"Text",    Hidden:0, Width:0  ,  Align:"Left", ColMerge:0, SaveName:"educationnm", KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10 },
                {Header:"<sht:txt mid='BLANK' mdef='직무'     />",      Type:"Text",    Hidden:1, Width:200,  Align:"Left", ColMerge:0, SaveName:"num"        , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10 },
                {Header:"<sht:txt mid='BLANK' mdef='직무'     />",      Type:"Text",    Hidden:1, Width:200,  Align:"Left", ColMerge:0, SaveName:"time"       , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10 },
                {Header:"<sht:txt mid='BLANK' mdef='직무'     />",      Type:"Text",    Hidden:1, Width:200,  Align:"Left", ColMerge:0, SaveName:"useYn"      , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10 },            ]; IBS_InitSheet(sheet2, initdata2); sheet2.SetCountPosition(0);

            var initdata3 = {};
            initdata3.Cfg = {SearchMode:smLazyLoad, Page:22,MergeSheet:msAll};
            initdata3.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
            initdata3.Cols = [
                {Header:"선택"                                   , 	    Type:"CheckBox",Hidden:0, Width:45 ,  Align:"Center", ColMerge:0, SaveName:"sel"        , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:1, InsertEdit:0, EditLen:1  },
                {Header:"<sht:txt mid='BLANK' mdef='직렬코드' />",      Type:"Text",    Hidden:1, Width:0  ,  Align:"Left", ColMerge:0, SaveName:"itemGubun"  , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10 },
                {Header:"<sht:txt mid='BLANK' mdef='직렬'     />",      Type:"Text",    Hidden:1, Width:150,  Align:"Left", ColMerge:1, SaveName:"education"  , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10 },
                {Header:"<sht:txt mid='BLANK' mdef='교육명'   />",      Type:"Text",    Hidden:0, Width:0  ,  Align:"Left", ColMerge:0, SaveName:"educationnm", KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10 },
                {Header:"<sht:txt mid='BLANK' mdef='직무'     />",      Type:"Text",    Hidden:1, Width:200,  Align:"Left", ColMerge:0, SaveName:"num"        , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10 },
                {Header:"<sht:txt mid='BLANK' mdef='직무'     />",      Type:"Text",    Hidden:1, Width:200,  Align:"Left", ColMerge:0, SaveName:"time"       , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10 },
                {Header:"<sht:txt mid='BLANK' mdef='직무'     />",      Type:"Text",    Hidden:1, Width:200,  Align:"Left", ColMerge:0, SaveName:"useYn"      , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10 },
            ]; IBS_InitSheet(sheet3, initdata3); sheet3.SetCountPosition(0);



            var initdata4 = {};
            initdata4.Cfg = {SearchMode:smLazyLoad, Page:22};
            initdata4.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
            initdata4.Cols = [
                {Header:"선택"                                   , 	    Type:"CheckBox",Hidden:0, Width:45 ,  Align:"Center", ColMerge:0, SaveName:"sel"        , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:1, InsertEdit:0, EditLen:1  },
                {Header:"<sht:txt mid='BLANK' mdef='직렬코드' />",      Type:"Text",    Hidden:1, Width:0  ,  Align:"Left", ColMerge:0, SaveName:"itemGubun"  , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10 },
                {Header:"<sht:txt mid='BLANK' mdef='직렬'     />",      Type:"Text",    Hidden:1, Width:150,  Align:"Left", ColMerge:1, SaveName:"education"  , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10 },
                {Header:"<sht:txt mid='BLANK' mdef='교육명'   />",      Type:"Text",    Hidden:0, Width:0  ,  Align:"Left", ColMerge:0, SaveName:"educationnm", KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10 },
                {Header:"<sht:txt mid='BLANK' mdef='직무'     />",      Type:"Text",    Hidden:1, Width:200,  Align:"Left", ColMerge:0, SaveName:"num"        , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10 },
                {Header:"<sht:txt mid='BLANK' mdef='직무'     />",      Type:"Text",    Hidden:1, Width:200,  Align:"Left", ColMerge:0, SaveName:"time"       , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10 },
                {Header:"<sht:txt mid='BLANK' mdef='직무'     />",      Type:"Text",    Hidden:1, Width:200,  Align:"Left", ColMerge:0, SaveName:"useYn"      , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10 },
            ]; IBS_InitSheet(sheet4, initdata4); sheet4.SetCountPosition(0);


            var initdata5 = {};
            initdata5.Cfg = {SearchMode:smLazyLoad, Page:22};
            initdata5.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
            initdata5.Cols = [
                {Header:"선택"                                   , 	    Type:"CheckBox",Hidden:0, Width:45 ,  Align:"Center", ColMerge:0, SaveName:"sel"        , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:1, InsertEdit:0, EditLen:1  },
                {Header:"<sht:txt mid='BLANK' mdef='직렬코드' />",      Type:"Text",    Hidden:1, Width:0  ,  Align:"Left", ColMerge:0, SaveName:"itemGubun"  , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10 },
                {Header:"<sht:txt mid='BLANK' mdef='직렬'     />",      Type:"Text",    Hidden:1, Width:150,  Align:"Left", ColMerge:1, SaveName:"education"  , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10 },
                {Header:"<sht:txt mid='BLANK' mdef='교육명'   />",      Type:"Text",    Hidden:0, Width:0  ,  Align:"Left", ColMerge:0, SaveName:"educationnm", KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10 },
                {Header:"<sht:txt mid='BLANK' mdef='직무'     />",      Type:"Text",    Hidden:1, Width:200,  Align:"Left", ColMerge:0, SaveName:"num"        , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10 },
                {Header:"<sht:txt mid='BLANK' mdef='직무'     />",      Type:"Text",    Hidden:1, Width:200,  Align:"Left", ColMerge:0, SaveName:"time"       , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10 },
                {Header:"<sht:txt mid='BLANK' mdef='직무'     />",      Type:"Text",    Hidden:1, Width:200,  Align:"Left", ColMerge:0, SaveName:"useYn"      , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10 },
            ]; IBS_InitSheet(sheet5, initdata5); sheet5.SetCountPosition(0);

            var initdata6 = {};
            initdata6.Cfg = {SearchMode:smLazyLoad, Page:22};
            initdata6.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
            initdata6.Cols = [
                {Header:"선택"                                   , 	    Type:"CheckBox",Hidden:0, Width:45 ,  Align:"Center", ColMerge:0, SaveName:"sel"        , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:1, InsertEdit:0, EditLen:1  },
                {Header:"<sht:txt mid='BLANK' mdef='직렬코드' />",      Type:"Text",    Hidden:1, Width:0  ,  Align:"Left", ColMerge:0, SaveName:"itemGubun"  , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10 },
                {Header:"<sht:txt mid='BLANK' mdef='직렬'     />",      Type:"Text",    Hidden:1, Width:150,  Align:"Left", ColMerge:1, SaveName:"education"  , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10 },
                {Header:"<sht:txt mid='BLANK' mdef='교육명'   />",      Type:"Text",    Hidden:0, Width:0  ,  Align:"Left", ColMerge:0, SaveName:"educationnm", KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10 },
                {Header:"<sht:txt mid='BLANK' mdef='직무'     />",      Type:"Text",    Hidden:1, Width:200,  Align:"Left", ColMerge:0, SaveName:"num"        , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10 },
                {Header:"<sht:txt mid='BLANK' mdef='직무'     />",      Type:"Text",    Hidden:1, Width:200,  Align:"Left", ColMerge:0, SaveName:"time"       , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10 },
                {Header:"<sht:txt mid='BLANK' mdef='직무'     />",      Type:"Text",    Hidden:1, Width:200,  Align:"Left", ColMerge:0, SaveName:"useYn"      , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10 },
            ]; IBS_InitSheet(sheet6, initdata6); sheet6.SetCountPosition(0);


            $(".close").click(function() {
                p.self.close();
            });

            $(window).smartresize(sheetResize); sheetInit();
            doAction1("Search");
            doAction2("Search");
            doAction3("Search");
            doAction4("Search");
            doAction5("Search");
            doAction6("Search");
        });



        function fnDupCheck(sht) {

            var arrEdu = new Array();
            var strEduList = eduList;

            if (strEduList !== "") {
                arrEdu = strEduList.split(",");
            }

            if (arrEdu.length > 0 && sht.RowCount() > 0) {
                for (var i=0, nICnt=sht.RowCount(); i<=nICnt; i++) {
                    if (arrEdu.indexOf(sht.GetCellValue(i,"education")) >= 0) {
                        sht.SetCellValue(i,"sel","1");
                        sht.SetCellEditable(i, "sel",false);
                    }
                }
            }

        }

        //Sheet1 Action
        function doAction1(sAction) {
            switch (sAction) {
                case "Search":
                    sheet1.DoSearch( "${ctx}/SelfDevelopmentTRM.do?cmd=getSelfDevelopmentTRM", $("#mySheetForm").serialize() + "&searchSelectType=R&searchGradeType=1");
                    break;
                case "Insert": //입력
                    var Row = sheet1.DataInsert(0);
                    break;

            }
        }

        // 조회 후 에러 메시지
        function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
            try {
                if (Msg != "") { alert(Msg);	}
                sheetResize();

                fnDupCheck(sheet1);

            } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
        }

        // 저장 후 메시지
        function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
            try { if (Msg != "") { alert(Msg); } doAction1('Search'); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
        }

        //Sheet2 Action
        function doAction2(sAction) {
            switch (sAction) {
                case "Search":
                    sheet2.DoSearch( "${ctx}/SelfDevelopmentTRM.do?cmd=getSelfDevelopmentTRM", $("#mySheetForm").serialize() + "&searchSelectType=R&searchGradeType=2");
                    break;
                case "Insert": //입력
                    var Row = sheet2.DataInsert(0);
                    break;

                case "Save": //저장
                    IBS_SaveName(document.mySheetForm, sheet2);
                    sheet2.DoSave("${ctx}/CareerTarget.do?cmd=saveCareerPathDetailSHT2", $("#mySheetForm").serialize(), -1, 0);
                    break;

            }
        }

        // 조회 후 에러 메시지
        function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
            try {
                if (Msg != "") { alert(Msg);	}
                sheetResize();

                fnDupCheck(sheet2);

            } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
        }

        // 저장 후 메시지
        function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
            try { if (Msg != "") { showMessage(Msg); } doAction2('Search'); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
        }


        //Sheet3 Action
        function doAction3(sAction) {
            switch (sAction) {
                case "Search":

                    sheet3.DoSearch( "${ctx}/SelfDevelopmentTRM.do?cmd=getSelfDevelopmentTRM", $("#mySheetForm").serialize() + "&searchSelectType=R&searchGradeType=3");
                    break;
                case "Insert": //입력
                    var Row = sheet3.DataInsert(0);
                    break;

                case "Save": //저장
                    IBS_SaveName(document.mySheetForm, sheet3);
                    sheet3.DoSave("${ctx}/CareerTarget.do?cmd=saveCareerPathDetailSHT2", $("#mySheetForm").serialize(), -1, 0);
                    break;

            }
        }

        // 조회 후 에러 메시지
        function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
            try {
                if (Msg != "") { alert(Msg);	}
                sheetResize();

                fnDupCheck(sheet3);

            } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
        }

        // 저장 후 메시지
        function sheet3_OnSaveEnd(Code, Msg, StCode, StMsg) {
            try { if (Msg != "") { showMessage(Msg); } doAction3('Search'); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
        }

        //Sheet4 Action
        function doAction4(sAction) {
            switch (sAction) {
                case "Search":
                    sheet4.DoSearch( "${ctx}/SelfDevelopmentTRM.do?cmd=getSelfDevelopmentTRM", $("#mySheetForm").serialize() + "&searchSelectType=O&searchGradeType=1");
                    break;
                case "Insert": //입력
                    var Row = sheet4.DataInsert(0);
                    break;

                case "Save": //저장
                    IBS_SaveName(document.mySheetForm, sheet4);
                    sheet4.DoSave("${ctx}/CareerTarget.do?cmd=saveCareerPathDetailSHT2", $("#mySheetForm").serialize(), -1, 0);




                    break;

            }
        }

        // 조회 후 에러 메시지
        function sheet4_OnSearchEnd(Code, Msg, StCode, StMsg) {
            try {
                if (Msg != "") { alert(Msg);	}
                sheetResize();

                fnDupCheck(sheet4);

            } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
        }

        // 저장 후 메시지
        function sheet4_OnSaveEnd(Code, Msg, StCode, StMsg) {
            try { if (Msg != "") { showMessage(Msg); } doAction4('Search'); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
        }


        //Sheet5 Action
        function doAction5(sAction) {
            switch (sAction) {
                case "Search":
                    sheet5.DoSearch( "${ctx}/SelfDevelopmentTRM.do?cmd=getSelfDevelopmentTRM", $("#mySheetForm").serialize() + "&searchSelectType=O&searchGradeType=2");
                    break;
                case "Insert": //입력
                    var Row = sheet5.DataInsert(0);
                    break;
                case "Save": //저장
                    IBS_SaveName(document.mySheetForm, sheet5);
                    sheet5.DoSave("${ctx}/CareerTarget.do?cmd=saveCareerPathDetailSHT2", $("#mySheetForm").serialize(),-1,0);
                    break;
            }
        }

        // 조회 후 에러 메시지
        function sheet5_OnSearchEnd(Code, Msg, StCode, StMsg) {
            try {
                if (Msg != "") { alert(Msg);	}
                sheetResize();

                fnDupCheck(sheet5);

            } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
        }

        // 저장 후 메시지
        function sheet5_OnSaveEnd(Code, Msg, StCode, StMsg) {
            try {
                if (Msg != "") { showMessage(Msg); }

                switch (gSheetNm) {
                    case "sheet2" : doAction2("Search"); break;
                    case "sheet3" : doAction3("Search"); break;
                    case "sheet4" : doAction4("Search"); break;
                }

            } catch (ex) {
                alert("OnSaveEnd Event Error " + ex);
            }
        }


        //Sheet6 Action
        function doAction6(sAction) {
            switch (sAction) {
                case "Search":
                    sheet6.DoSearch( "${ctx}/SelfDevelopmentTRM.do?cmd=getSelfDevelopmentTRM", $("#mySheetForm").serialize() + "&searchSelectType=O&searchGradeType=3");
                    break;
                case "Insert": //입력
                    var Row = sheet6.DataInsert(0);
                    break;
                case "Save": //저장
                    IBS_SaveName(document.mySheetForm, sheet6);
                    sheet6.DoSave("${ctx}/CareerTarget.do?cmd=saveCareerPathDetailSHT2", $("#mySheetForm").serialize(),-1,0);
                    break;
            }
        }

        // 조회 후 에러 메시지
        function sheet6_OnSearchEnd(Code, Msg, StCode, StMsg) {
            try {
                if (Msg != "") { alert(Msg);	}
                sheetResize();

                fnDupCheck(sheet6);

            } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
        }

        // 저장 후 메시지
        function sheet6_OnSaveEnd(Code, Msg, StCode, StMsg) {
            try {
                if (Msg != "") { showMessage(Msg); }

                switch (gSheetNm) {
                    case "sheet2" : doAction2("Search"); break;
                    case "sheet3" : doAction3("Search"); break;
                    case "sheet4" : doAction4("Search"); break;
                }

            } catch (ex) {
                alert("OnSaveEnd Event Error " + ex);
            }
        }

        function showMessage(Msg) {
            if (Msg != "저장 되었습니다.") {
                alert(Msg);
            }
        }

    </script>


    <script language="JavaScript">
/*
        function doSave1()
        {
            gSheetNm = "sheet2";


            if ( fnChkDupStep(sheet2) ) return;

            doAction5("Insert");

            setSHT5Data("G1");

            doAction5("Save");

        }

        function doSave2()
        {
            gSheetNm = "sheet3";

            if ( fnChkDupStep(sheet3) ) return;

            doAction5("Insert");

            setSHT5Data("G2");

            doAction5("Save");
        }

        function doSave3()
        {
            gSheetNm = "sheet4";

            if ( fnChkDupStep(sheet4) ) return;

            doAction5("Insert");

            setSHT5Data("G3");

            doAction5("Save");
        }

        function doDelete1()
        {
            sheet2.SetCellValue(sheet2.GetSelectRow(),"sStatus","D");
            doAction2("Save");
        }

        function doDelete2()
        {
            sheet3.SetCellValue(sheet3.GetSelectRow(),"sStatus","D");
            doAction3("Save");
        }

        function doDelete3()
        {
            sheet4.SetCellValue(sheet4.GetSelectRow(),"sStatus","D");
            doAction4("Save");
        }


        function setSHT5Data(pCareerPathCd)
        {
            sheet5.SetCellValue(sheet5.GetSelectRow(),"careerTargetCd"  ,$('#searchCareerTargetCd').val());
            sheet5.SetCellValue(sheet5.GetSelectRow(),"careerPathCd"    ,pCareerPathCd);
            sheet5.SetCellValue(sheet5.GetSelectRow(),"jobCd"           ,sheet1.GetCellValue(sheet1.GetSelectRow(), "jobCd"));
            sheet5.SetCellValue(sheet5.GetSelectRow(),"exeTerm"         ,"1");
        }

        function fnChkDupStep(pSheet)
        {
            var bResult = false;

            var szJobCd = sheet1.GetCellValue(sheet1.GetSelectRow(), "jobCd");

            for ( i=1; i <= pSheet.LastRow(); i++ ) {

                if (  pSheet.GetCellValue(i, "jobCd") == szJobCd ) {
                    alert('1단계 데이터와 중복입니다.');
                    bResult = true;
                    break;
                }

            }

            return bResult;
        }


        function doOpenCareerPath(Row) {
            if (!isPopup()) {
                return;
            }

            var w = 900;
            var h = 500;
            var url = "${ctx}/CareerPathPreView.do?cmd=viewCareerPathPreView&authPg=${authPg}";
            var args = new Array();

            args["careerTargetCd"] = $('#searchCareerTargetCd').val();
            args["careerTargetNm"] = careerTargetNm;

            gPRow = Row;
            pGubun = "careerPathPreViewPopup";

            openPopup(url, args, w, h);
        }
*/
        function setValue() {

            var rv = new Array();

            var arrSheet = [sheet1,sheet2,sheet3,sheet4,sheet5,sheet6];

            var rtnArray = new Array();
            var nRowCnt  = 0;

            for (var i=0,nICnt=arrSheet.length;i<nICnt;i++) {
                var sht = arrSheet[i];

                if (sht.RowCount() != 0) {

                    for (var j=1,nJCnt=sht.RowCount();j<=nJCnt;j++) {

                        if (sht.GetCellValue(j,"sel") == "1" && sht.GetCellEditable(j, "sel") ) {

                            rtnArray[nRowCnt] = new Array();

                            rtnArray[nRowCnt][0] = sht.GetCellValue(j,"education"  );
                            rtnArray[nRowCnt][1] = sht.GetCellValue(j,"educationnm");
                            rtnArray[nRowCnt][2] = sht.GetCellValue(j,"time"       );
                            rtnArray[nRowCnt][3] = sht.GetCellValue(j,"num"        );
                            rtnArray[nRowCnt][4] = sht.GetCellValue(j,"itemGubun"  );

                            nRowCnt++;
                        }
                    }

                }
            }

            rv["eduList"] = rtnArray;

            p.popReturnValue(rv);
            p.window.close();

        }

    </script>

</head>
<div class="wrapper">

    <div class="wrapper">
        <div class="popup_title">
            <ul>
                <li><span id="title"><tit:txt mid='113792' mdef='금융사 조회'/></span></li>
                <li class="close"></li>
            </ul>
        </div>
        <div class="popup_main">
            <form id="mySheetForm" name="mySheetForm">
                <input id="searchCareerTargetCd" name="searchCareerTargetCd" type="hidden"/>
                <input id="searchSabun" name="searchSabun" type="hidden"/>
                <input id="searchTrmType" name="searchTrmType" type="hidden"/>
                <input id="searchTrmCode" name="searchTrmCode" type="hidden"/>
            </form>



            <table border="0" cellspacing="0" cellpadding="0" class="table">
                <colgroup>
                    <col width="20px"  />
                    <col width="45%" />
                    <col width="45%" />
                </colgroup>
                <tr>
                    <td colspan="3"><span>*<font color="red" >붉은색</font> 표시는 기존에 수강완료한 교육과정입니다.</span></td>
                </tr>
                <tr>
                    <th align="center" style="text-align: center">구분</th>
                    <th align="center" style="text-align: center">필수</th>
                    <th align="center" style="text-align: center">선택</th>
                </tr>

                <tr>
                    <th align="center" style="text-align: center">초급</th>
                    <td class="top">
                        <script type="text/javascript">createIBSheet("sheet1", "50%", "29%", "${ssnLocaleCd}"); </script>
                    </td>
                    <td class="top" style="height:100px">
                        <script type="text/javascript">createIBSheet("sheet4", "50%", "29%", "${ssnLocaleCd}"); </script>
                    </td>
                </tr>

                <tr>
                    <th align="center" style="text-align: center">중급</th>
                    <td class="top">
                        <script type="text/javascript">createIBSheet("sheet2", "50%", "29%", "${ssnLocaleCd}"); </script>
                    </td>
                    <td>
                        <script type="text/javascript">createIBSheet("sheet5", "50%", "29%", "${ssnLocaleCd}"); </script>
                    </td>
                </tr>
                <tr>
                    <th align="center" style="text-align: center">고급</th>
                    <td class="top">
                        <script type="text/javascript">createIBSheet("sheet3", "50%", "29%", "${ssnLocaleCd}"); </script>
                    </td>
                    <td>
                        <script type="text/javascript">createIBSheet("sheet6", "50%", "29%", "${ssnLocaleCd}"); </script>
                    </td>
                </tr>
            </table>

            <div class="popup_button outer">
                <ul>
                    <li>
                        <a href="javascript:setValue();p.self.close();"		class="pink large"><tit:txt mid='104435' mdef='확인'/></a>
                        <a href="javascript:p.self.close();"                class="gray large"><tit:txt mid='104157' mdef='닫기'/></a>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</div>
</html>
