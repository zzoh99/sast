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
        var gPRow;
        var pGubun;
        var gSheet   = "";
        var gSheetNm = "";
        var arg      = p.popDialogArgumentAll();
        var trmNm    = arg['searchCodeNm'];

        $(function() {

            $("#title").html("Tranning Road Map ["+trmNm + "]");

            $('#searchTrmType'  ).val(arg['searchTrmType']  );
            $('#searchCode'     ).val(arg['searchCode']     );
            $('#searchCategory' ).val(arg['searchCategory'] );
            $('#searchCodeNm'   ).val(arg['searchCodeNm']   );

            var initdata = {};
            initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msAll};
            initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
            initdata.Cols = [
                {Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>", Type:"${sDelTy}" , Hidden:Number("${sDelHdn}"), Width:20, Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 },
                {Header:"<sht:txt mid='sStatus'    mdef='상태'/>", Type:"${sSttTy}" , Hidden:Number("${sSttHdn}"), Width:30, Align:"Center", ColMerge:0, SaveName:"sStatus" },
                {Header:"<sht:txt mid='BLANK'      mdef='과정구분'    />", Type:"Combo"     , Hidden:0, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"itemGubun"  , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:10   },
                {Header:"<sht:txt mid='BLANK'      mdef='교육과정코드'/>", Type:"Text"      , Hidden:1, Width:0  , Align:"Left"  , ColMerge:1, SaveName:"education"  , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100  },
                {Header:"<sht:txt mid='BLANK'      mdef='교육과정명'  />", Type:"Popup"     , Hidden:0, Width:200, Align:"Left"  , ColMerge:0, SaveName:"educationnm", KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:1000 },
                {Header:"<sht:txt mid='BLANK'      mdef='선택구분'    />", Type:"Text"      , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"selectType" , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10   },
                {Header:"<sht:txt mid='BLANK'      mdef='등급구분'    />", Type:"Text"      , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"gradeType"  , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10   },
                {Header:"<sht:txt mid='BLANK'      mdef='번호'        />", Type:"Text"      , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"num"        , KeyField:0, CalcLogic:"", Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10   },

            ];
            IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(0);
            IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(0);
            IBS_InitSheet(sheet3, initdata);sheet2.SetEditable("${editable}");sheet3.SetVisible(true);sheet3.SetCountPosition(0);
            IBS_InitSheet(sheet4, initdata);sheet4.SetEditable("${editable}");sheet4.SetVisible(true);sheet4.SetCountPosition(0);
            IBS_InitSheet(sheet5, initdata);sheet5.SetEditable("${editable}");sheet5.SetVisible(true);sheet5.SetCountPosition(0);
            IBS_InitSheet(sheet6, initdata);sheet6.SetEditable("${editable}");sheet6.SetVisible(true);sheet6.SetCountPosition(0);

            $(".close").click(function() {
                p.self.close();
            });

            var itemGubunCd     = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","D00024"), "");
            sheet1.SetColProperty("itemGubun" , {ComboText:itemGubunCd[0], ComboCode:itemGubunCd[1]} );
            sheet2.SetColProperty("itemGubun" , {ComboText:itemGubunCd[0], ComboCode:itemGubunCd[1]} );
            sheet3.SetColProperty("itemGubun" , {ComboText:itemGubunCd[0], ComboCode:itemGubunCd[1]} );
            sheet4.SetColProperty("itemGubun" , {ComboText:itemGubunCd[0], ComboCode:itemGubunCd[1]} );
            sheet5.SetColProperty("itemGubun" , {ComboText:itemGubunCd[0], ComboCode:itemGubunCd[1]} );
            sheet6.SetColProperty("itemGubun" , {ComboText:itemGubunCd[0], ComboCode:itemGubunCd[1]} );

            $(window).smartresize(sheetResize); sheetInit();
            doAction1("Search");
            doAction2("Search");
            doAction3("Search");
            doAction4("Search");
            doAction5("Search");
            doAction6("Search");

            sheetResize();
        });

        //Sheet1 Action
        function doAction1(sAction) {
            switch (sAction) {
                case "Search":
                    sheet1.DoSearch( "${ctx}/TRMManage.do?cmd=getTRMRegList", $("#srchFrm").serialize() + "&searchSelectType=R&searchGradeType=1");
                    break;
                case "Save":
                    IBS_SaveName(document.srchFrm,sheet1);
                    sheet1.DoSave( "${ctx}/TRMManage.do?cmd=saveTRM", $("#srchFrm").serialize()); break;
                case "Insert": //입력
                    var Row = sheet1.DataInsert(0);
                    sheet1.SetCellValue(Row,"selectType","R");
                    sheet1.SetCellValue(Row,"gradeType" ,"1");
                    break;
            }
        }

        //Sheet2 Action
        function doAction2(sAction) {
            switch (sAction) {
                case "Search":
                    sheet2.DoSearch( "${ctx}/TRMManage.do?cmd=getTRMRegList", $("#srchFrm").serialize() + "&searchSelectType=R&searchGradeType=2");
                    break;
                case "Insert": //입력
                    var Row = sheet2.DataInsert(0);
                    sheet2.SetCellValue(Row,"selectType","R");
                    sheet2.SetCellValue(Row,"gradeType" ,"2");
                    break;

                case "Save": //저장
                    IBS_SaveName(document.srchFrm, sheet2);
                    sheet2.DoSave("${ctx}/TRMManage.do?cmd=saveTRM", $("#srchFrm").serialize());
                    break;
            }
        }

        //Sheet3 Action
        function doAction3(sAction) {
            switch (sAction) {
                case "Search":

                    sheet3.DoSearch( "${ctx}/TRMManage.do?cmd=getTRMRegList", $("#srchFrm").serialize() + "&searchSelectType=R&searchGradeType=3");
                    break;
                case "Insert": //입력
                    var Row = sheet3.DataInsert(0);
                    sheet3.SetCellValue(Row,"selectType","R");
                    sheet3.SetCellValue(Row,"gradeType" ,"3");

                    break;

                case "Save": //저장
                    IBS_SaveName(document.srchFrm, sheet3);
                    sheet3.DoSave("${ctx}/TRMManage.do?cmd=saveTRM", $("#srchFrm").serialize());
                    break;
            }
        }

        //Sheet4 Action
        function doAction4(sAction) {
            switch (sAction) {
                case "Search":
                    sheet4.DoSearch( "${ctx}/TRMManage.do?cmd=getTRMRegList", $("#srchFrm").serialize() + "&searchSelectType=O&searchGradeType=1");
                    break;
                case "Insert": //입력
                    var Row = sheet4.DataInsert(0);
                    sheet4.SetCellValue(Row,"selectType","O");
                    sheet4.SetCellValue(Row,"gradeType" ,"1");
                    break;

                case "Save": //저장
                    IBS_SaveName(document.srchFrm, sheet4);
                    sheet4.DoSave("${ctx}/TRMManage.do?cmd=saveTRM", $("#srchFrm").serialize());
                    break;

            }
        }

        //Sheet5 Action
        function doAction5(sAction) {
            switch (sAction) {
                case "Search":
                    sheet5.DoSearch( "${ctx}/TRMManage.do?cmd=getTRMRegList", $("#srchFrm").serialize() + "&searchSelectType=O&searchGradeType=2");
                    break;
                case "Insert": //입력
                    var Row = sheet5.DataInsert(0);
                    sheet5.SetCellValue(Row,"selectType","O");
                    sheet5.SetCellValue(Row,"gradeType" ,"2");

                    break;
                case "Save": //저장
                    IBS_SaveName(document.srchFrm, sheet5);
                    sheet5.DoSave("${ctx}/TRMManage.do?cmd=saveTRM", $("#srchFrm").serialize());
                    break;
            }
        }


        //Sheet6 Action
        function doAction6(sAction) {
            switch (sAction) {
                case "Search":
                    sheet6.DoSearch( "${ctx}/TRMManage.do?cmd=getTRMRegList", $("#srchFrm").serialize() + "&searchSelectType=O&searchGradeType=3");
                    break;
                case "Insert": //입력
                    var Row = sheet6.DataInsert(0);
                    sheet6.SetCellValue(Row,"selectType","O");
                    sheet6.SetCellValue(Row,"gradeType" ,"3");

                    break;
                case "Save": //저장
                    IBS_SaveName(document.srchFrm, sheet6);
                    sheet6.DoSave("${ctx}/TRMManage.do?cmd=saveTRM", $("#srchFrm").serialize());
                    break;
            }
        }


        // 조회 후 에러 메시지
        function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
            try {
                if (Msg != "") { alert(Msg);	}
            } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
        }


        // 조회 후 에러 메시지
        function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
            try {
                if (Msg != "") { alert(Msg);	}
            } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
        }

        // 조회 후 에러 메시지
        function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
            try {
                if (Msg != "") { alert(Msg);	}
            } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
        }

        // 조회 후 에러 메시지
        function sheet4_OnSearchEnd(Code, Msg, StCode, StMsg) {
            try {
                if (Msg != "") { alert(Msg);	}
            } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
        }

        // 조회 후 에러 메시지
        function sheet5_OnSearchEnd(Code, Msg, StCode, StMsg) {
            try {
                if (Msg != "") { alert(Msg);	}
            } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
        }

        // 조회 후 에러 메시지
        function sheet6_OnSearchEnd(Code, Msg, StCode, StMsg) {
            try {
                if (Msg != "") { alert(Msg);	}
            } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
        }

        // 저장 후 메시지
        function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
            try { if (Msg != "") { alert(Msg); } doAction1('Search'); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
        }

        // 저장 후 메시지
        function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
            try { if (Msg != "") { alert(Msg); } doAction2('Search'); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
        }

        // 저장 후 메시지
        function sheet3_OnSaveEnd(Code, Msg, StCode, StMsg) {
            try { if (Msg != "") { alert(Msg); } doAction3('Search'); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
        }

        // 저장 후 메시지
        function sheet4_OnSaveEnd(Code, Msg, StCode, StMsg) {
            try { if (Msg != "") { alert(Msg); } doAction4('Search'); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
        }

        // 저장 후 메시지
        function sheet5_OnSaveEnd(Code, Msg, StCode, StMsg) {
            try { if (Msg != "") { alert(Msg); } doAction5('Search'); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
        }

        // 저장 후 메시지
        function sheet6_OnSaveEnd(Code, Msg, StCode, StMsg) {
            try { if (Msg != "") { alert(Msg); } doAction6('Search'); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
        }

        //팝업 클릭시 발생
        
        function sheet1_OnPopupClick(Row,Col) {
            try {
                if(sheet1.ColSaveName(Col) == "educationnm") {
                    openEducationPopup(sheet1, Row) ;
                }
            } catch(ex) {
                alert("OnPopupClick Event Error : " + ex);
            }
        }

        function sheet2_OnPopupClick(Row,Col) {
            try {
                if(sheet2.ColSaveName(Col) == "educationnm") {
                    openEducationPopup(sheet2, Row) ;
                }
            } catch(ex) {
                alert("OnPopupClick Event Error : " + ex);
            }
        }

        function sheet3_OnPopupClick(Row,Col) {
            try {
                if(sheet3.ColSaveName(Col) == "educationnm") {
                    openEducationPopup(sheet3, Row) ;
                }
            } catch(ex) {
                alert("OnPopupClick Event Error : " + ex);
            }
        }

        function sheet4_OnPopupClick(Row,Col) {
            try {
                if(sheet4.ColSaveName(Col) == "educationnm") {
                    openEducationPopup(sheet4, Row) ;
                }
            } catch(ex) {
                alert("OnPopupClick Event Error : " + ex);
            }
        }

        function sheet5_OnPopupClick(Row,Col) {
            try {
                if(sheet5.ColSaveName(Col) == "educationnm") {
                    openEducationPopup(sheet5, Row) ;
                }
            } catch(ex) {
                alert("OnPopupClick Event Error : " + ex);
            }
        }

        function sheet6_OnPopupClick(Row,Col) {
            try {
                if(sheet6.ColSaveName(Col) == "educationnm") {
                    openEducationPopup(sheet6, Row) ;
                }
            } catch(ex) {
                alert("OnPopupClick Event Error : " + ex);
            }
        }

        function openEducationPopup(pSheet, Row) {

            if (!isPopup()) {
                return;
            }

            //
            //console.log("sStatus : ", pSheet.GetCellValue(Row,"sStatus"));
            var sStatus = pSheet.GetCellValue(Row,"sStatus");

            
            /*//if (sStatus == "R") {



                var w = 900;
                var h = 500;
                var url = "${ctx}/TRMManage.do?cmd=viewTrmEduEventMgrPopup&authPg=${authPg}";
                var args = new Array();

                //args["itemGubun"] = pSheet.GetCellValue(Row,"itemGubun");
                pGubun = "openEducationDetailPopup";

                openPopup(url, args, w, h);
            }*/

            gSheet = pSheet;
            gPRow = Row;

            var w = 900;
            var h = 500;
            var url = "${ctx}/TRMManage.do?cmd=viewTrmEduPopup&authPg=${authPg}";
            var args = new Array();

            args["itemGubun"] = pSheet.GetCellValue(Row,"itemGubun");

/*            args["careerTargetCd"] = $('#searchCareerTargetCd').val();
            args["careerTargetNm"] = careerTargetNm;

            EducationDetail
            OutEducationDetail*/

            pGubun = "openEducationPopup";

            openPopup(url, args, w, h);

        }



        //팝업 콜백 함수.
        function getReturnValue(returnValue) {
            var rv = $.parseJSON('{' + returnValue+ '}');

            if(pGubun == "openEducationPopup") {
                //팝업 더블클릭시 조회해온것 input 에 셋팅
                var education = rv["eduSeq"] + rv["eduEventSeq"];

                gSheet.SetCellValue(gPRow, "education"  , education       );
                gSheet.SetCellValue(gPRow, "educationnm", rv["eduCourseNm"]);


/*                $("#eduSeq").val ( rv["eduSeq"] );
                $("#eduCourseNm").text( rv["eduCourseNm"] );
                $("#eduEventSeq").val ( rv["eduEventSeq"] );
                $("#eduEventNm" ).text( rv["eduEventNm" ] );

                $("#eduBranchNm"    ).text( rv["eduBranchNm"] );
                $("#eduMBranchNm"   ).text( rv["eduMBranchNm"] );

                $("#eduOrgCd"       ).val ( rv["eduOrgCd"] );
                $("#eduOrgNm"       ).text( rv["eduOrgNm"] );
                $("#eduPlace"       ).text( rv["eduPlace"] );

                //$("#eduYmd"         ).text( getDateVal(rv["eduSYmd"]) +" - "+ getDateVal(rv["eduEYmd"]));
                $("#eduHour"        ).text( rv["eduHour"] );

                //$("#perExpenseMon"  ).text( addComma(rv["perExpenseMon"]) );
                //$("#laborMon"       ).text( addComma(rv["laborMon"]) );

                $("#eduSYmd"        ).val ( rv["eduSYmd"] );
                $("#eduEYmd"        ).val ( rv["eduEYmd"] );*/
            }

        }


        function showMessage(Msg) {
            if (Msg != "저장 되었습니다.") {
                alert(Msg);
            }
        }

        function setValue() {
            var rv = [];
            //rv["competencyCd"] 		= $("#competencyCd").val();
            //rv["competencyNm"]		= $("#competencyNm").val();
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

            <form id="srchFrm" name="srchFrm">
                <input id="searchTrmType"   name="searchTrmType"    type="hidden"/>
                <input id="searchCode"      name="searchCode"       type="hidden"/>
                <input id="searchCategory"  name="searchCategory"   type="hidden"/>
                <input id="searchCodeNm"    name="searchCodeNm"     type="hidden"/>
            </form>

            <table border="0" cellspacing="0" cellpadding="0" class="table">
                <colgroup>
                    <col width="20px"  />
                    <col width="45%" />
                    <col width="45%" />
                </colgroup>
                <tr class="hide">
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
                        <div class="sheet_title">
                            <ul>
                                <li class="btn">
                                    <btn:a href="javascript:doAction1('Search');" mid="110697" mdef="조회" css="basic"/>
                                    <btn:a href="javascript:doAction1('Insert');" mid="110700" mdef="입력" css="basic"/>
                                    <btn:a href="javascript:doAction1('Save'  );" mid="110708" mdef="저장" css="basic"/>
                                </li>
                            </ul>
                        </div>
                        <script type="text/javascript">createIBSheet("sheet1", "50%", "24%", "${ssnLocaleCd}"); </script>
                    </td>
                    <td class="top" style="height:100px">
                        <div class="sheet_title">
                            <ul>
                                <li class="btn">
                                    <btn:a href="javascript:doAction4('Search');" mid="110697" mdef="조회" css="basic"/>
                                    <btn:a href="javascript:doAction4('Insert');" mid="110700" mdef="입력" css="basic"/>
                                    <btn:a href="javascript:doAction4('Save'  );" mid="110708" mdef="저장" css="basic"/>
                                </li>
                            </ul>
                        </div>
                        <script type="text/javascript">createIBSheet("sheet4", "50%", "24%", "${ssnLocaleCd}"); </script>
                    </td>
                </tr>

                <tr>
                    <th align="center" style="text-align: center">중급</th>
                    <td class="top">
                        <div class="sheet_title">
                            <ul>
                                <li class="btn">
                                    <btn:a href="javascript:doAction2('Search');" mid="110697" mdef="조회" css="basic"/>
                                    <btn:a href="javascript:doAction2('Insert');" mid="110700" mdef="입력" css="basic"/>
                                    <btn:a href="javascript:doAction2('Save'  );" mid="110708" mdef="저장" css="basic"/>
                                </li>
                            </ul>
                        </div>
                        <script type="text/javascript">createIBSheet("sheet2", "50%", "24%", "${ssnLocaleCd}"); </script>
                    </td>
                    <td>
                        <div class="sheet_title">
                            <ul>
                                <li class="btn">
                                    <btn:a href="javascript:doAction5('Search');" mid="110697" mdef="조회" css="basic"/>
                                    <btn:a href="javascript:doAction5('Insert');" mid="110700" mdef="입력" css="basic"/>
                                    <btn:a href="javascript:doAction5('Save'  );" mid="110708" mdef="저장" css="basic"/>
                                </li>
                            </ul>
                        </div>
                        <script type="text/javascript">createIBSheet("sheet5", "50%", "24%", "${ssnLocaleCd}"); </script>
                    </td>
                </tr>
                <tr>
                    <th align="center" style="text-align: center">고급</th>
                    <td class="top">
                        <div class="sheet_title">
                            <ul>
                                <li class="btn">
                                    <btn:a href="javascript:doAction3('Search');" mid="110697" mdef="조회" css="basic"/>
                                    <btn:a href="javascript:doAction3('Insert');" mid="110700" mdef="입력" css="basic"/>
                                    <btn:a href="javascript:doAction3('Save'  );" mid="110708" mdef="저장" css="basic"/>
                                </li>
                            </ul>
                        </div>
                        <script type="text/javascript">createIBSheet("sheet3", "50%", "24%", "${ssnLocaleCd}"); </script>
                    </td>
                    <td>
                        <div class="sheet_title">
                            <ul>
                                <li class="btn">
                                    <btn:a href="javascript:doAction6('Search');" mid="110697" mdef="조회" css="basic"/>
                                    <btn:a href="javascript:doAction6('Insert');" mid="110700" mdef="입력" css="basic"/>
                                    <btn:a href="javascript:doAction6('Save'  );" mid="110708" mdef="저장" css="basic"/>
                                </li>
                            </ul>
                        </div>
                        <script type="text/javascript">createIBSheet("sheet6", "50%", "24%", "${ssnLocaleCd}"); </script>
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
