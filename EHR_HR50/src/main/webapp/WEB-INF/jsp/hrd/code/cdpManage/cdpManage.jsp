<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
    <%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
    <%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
    <%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
    <script type="text/javascript">
        var gPRow = "";
        var pGubun = "";

        $(function() {
            var initdata = {};
            initdata.Cfg = {FrozenCol:6,SearchMode:smLazyLoad,Page:22,MergeSheet:msAll};
            initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
            initdata.Cols = [
                {Header:"<sht:txt mid='sNo'         mdef='No'           />",     Type:"${sNoTy}" , Hidden:Number("${sNoHdn}") , Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
                {Header:"<sht:txt mid='sDelete V5'  mdef='삭제'         />",     Type:"${sDelTy}", Hidden:Number("${sDelHdn}"),  Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 },
                {Header:"<sht:txt mid='sStatus'     mdef='상태'         />",     Type:"${sSttTy}", Hidden:Number("${sSttHdn}"),  Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
                {Header:"<sht:txt mid='BLANK'       mdef='활동년도'     />",     Type:"Text"     , Hidden:0, Width:50 ,  Align:"Center", ColMerge:0, SaveName:"activeYyyy"    ,    KeyField:1, CalcLogic:"", Format:"Integer",  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:4 },
                {Header:"<sht:txt mid='BLANK'       mdef='반기구분'     />",     Type:"Combo"    , Hidden:0, Width:50 ,  Align:"Left"  , ColMerge:0, SaveName:"halfGubunType" ,    KeyField:1, CalcLogic:"", Format:""       ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:1 },
                {Header:"<sht:txt mid='BLANK'       mdef='실행시작일'   />",     Type:"Date"     , Hidden:0, Width:80 ,  Align:"Center", ColMerge:0, SaveName:"activeStartYmd", EndDateCol: "activeEndYmd",   KeyField:0, CalcLogic:"", Format:"Ymd"    ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:10 },
                {Header:"<sht:txt mid='BLANK'       mdef='실행종료일'   />",     Type:"Date"     , Hidden:0, Width:80 ,  Align:"Center", ColMerge:0, SaveName:"activeEndYmd"  , StartDateCol: "activeStartYmd",   KeyField:0, CalcLogic:"", Format:"Ymd"    ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:10 },
                {Header:"<sht:txt mid='BLANK'       mdef='비고'         />",     Type:"Text"     , Hidden:0, Width:100,  Align:"Left"  , ColMerge:0, SaveName:"activeDesc"    ,    KeyField:0, CalcLogic:"", Format:""       ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:4000 },
            ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");


            $("#searchActiveYyyy").bind("keyup",function(event){
                if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
            });

            $(window).smartresize(sheetResize); sheetInit();


            doAction1("Search");
        });



        function fnSetCode() {
            let searchYear = $("#searchActiveYyyy").val();

            let baseSYmd;
            let baseEYmd;

            if (searchYear != null && searchYear !== '') {
                baseSYmd = $("#searchActiveYyyy").val() + "-01-01";
                baseEYmd = $("#searchActiveYyyy").val() + "-12-31";
            }

            const halfGubunTypeCd     = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","D00005", baseSYmd, baseEYmd), "");
            sheet1.SetColProperty("halfGubunType", 	{ComboText:halfGubunTypeCd[0], ComboCode:halfGubunTypeCd[1]} );
        }




        /**
         * Sheet 각종 처리
         */
        function doAction1(sAction) {
            switch (sAction) {
                case "Search": //조회
                    fnSetCode();
                    sheet1.DoSearch("${ctx}/CDPManage.do?cmd=getCDPManageList", $("#srchFrm").serialize());
                    break;
                case "Save": //저장
                    if(!dupChk(sheet1,"activeYyyy|halfGubunType", true, true)){break;}
                    IBS_SaveName(document.srchFrm, sheet1);
                    sheet1.DoSave("${ctx}/CDPManage.do?cmd=saveCDPManageList", $("#srchFrm").serialize());
                    break;

                case "Insert": //입력

                    var Row = sheet1.DataInsert(0);
                    break;
                    
    			case "Copy":
    				var row = sheet1.DataCopy();
    				break;

                case "Down2Excel": //엑셀내려받기

                    sheet1.Down2Excel({ DownCols : makeHiddenSkipCol(sheet1), SheetDesign : 1, Merge : 1 });
                    break;

                case "LoadExcel": //엑셀업로드

                    var params = { Mode : "HeaderMatch", WorkSheetNo : 1 };
                    sheet1.LoadExcel(params);
                    break;

            }
        }

        function sheet1_OnSearchEnd(Code, ErrMsg, StCode, StMsg) {
            try {
                if (ErrMsg != "") {
                    alert(ErrMsg);
                }
                //setSheetSize(this);
            } catch (ex) {
                alert("OnSearchEnd Event Error : " + ex);
            }
        }

        function sheet1_OnSaveEnd(Code, ErrMsg, StCode, StMsg) {
            try {
                if (ErrMsg != "") {
                    alert(ErrMsg);
                }

                if (Code > 0) {
                    doAction1("Search");
                }

            } catch (ex) {
                alert("OnSaveEnd Event Error : " + ex);
            }
        }


        function sheet1_OnClick(Row, Col, Value) {
            try {
            } catch (ex) {
                alert("OnClick Event Error : " + ex);
            }
        }

        function sheet1_OnPopupClick(Row, Col) {
            try {
                if (sheet1.ColSaveName(Col) == "zip") {
                    if (!isPopup()) {
                        return;
                    }

                    gPRow = Row;
                    pGubun = "ZipCodePopup";
                    openPopup("/ZipCodePopup.do?cmd=viewZipCodePopup&authPg=${authPg}", "", "740", "620");

                }
            } catch (ex) {
                alert("OnPopupClick Event Error : " + ex);
            }
        }

        function sheet1_OnValidation(Row, Col, Value) {
            try {
            } catch (ex) {
                alert("OnValidation Event Error : " + ex);
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
                    	<th>활동년도</th>
                        <td>  <input id="searchActiveYyyy" name ="searchActiveYyyy" type="text" class="text w100" /> </td>
                        <td><btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/> </td>
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
                            <li id="txt" class="txt"><tit:txt mid='BLANK' mdef='CDP차수'/></li>
                            <li class="btn">
                                <btn:a href="javascript:doAction1('Insert')" css="basic authA" mid='110700' mdef="입력"/>
                                <btn:a href="javascript:doAction1('Copy')" 	css="basic authA" mid='110696' mdef="복사"/>
                                <btn:a href="javascript:doAction1('Save')" 	css="basic authA" mid='110708' mdef="저장"/>
                                <btn:a href="javascript:doAction1('Down2Excel')" 	css="basic authR" mid='110698' mdef="다운로드"/>
                            </li>
                        </ul>
                    </div>
                </div>
                <script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
            </td>
        </tr>
    </table>
</div>
</body>
</html>
