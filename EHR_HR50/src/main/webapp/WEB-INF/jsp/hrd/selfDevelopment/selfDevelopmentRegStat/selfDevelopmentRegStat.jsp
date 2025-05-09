<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>


    <script type="text/javascript">
        $(function() {

            var initdata1 = {};
            initdata1.Cfg = {SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
            initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
            initdata1.Cols = [
                {Header:"<sht:txt mid='sNo'     mdef='No'        />",     Type:"${sNoTy}",  Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
                {Header:"<sht:txt mid='sStatus' mdef='상태'      />",     Type:"${sSttTy}", Hidden:Number("${sSttHdn}"),  Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
                {Header:"<sht:txt mid='BLANK'   mdef='회사구분'  />",     Type:"Text"        ,    Hidden:1, Width:50 ,  Align:"Left"      , ColMerge:0, SaveName:"enterCd"                  ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:4      },
                {Header:"<sht:txt mid='BLANK'   mdef='부코드'    />",     Type:"Text"        ,    Hidden:1, Width:50 ,  Align:"Left"      , ColMerge:0, SaveName:"mainOrgCd"                ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:1      },
                {Header:"<sht:txt mid='BLANK'   mdef='부'        />",     Type:"Text"        ,    Hidden:1, Width:120,  Align:"Center"    , ColMerge:0, SaveName:"mainOrgNm"                ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:13     },
                {Header:"<sht:txt mid='BLANK'   mdef='상위부서'        />",     Type:"Text"        ,    Hidden:0, Width:120,  Align:"Center"    , ColMerge:0, SaveName:"priorOrgNm"                ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:13     },
                {Header:"<sht:txt mid='BLANK'   mdef='팀코드'    />",     Type:"Text"        ,    Hidden:1, Width:50 ,  Align:"Left"      , ColMerge:0, SaveName:"orgCd"                    ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:8      },
                {Header:"<sht:txt mid='BLANK'   mdef='소속'        />",     Type:"Text"        ,    Hidden:0, Width:100,  Align:"Center"    , ColMerge:0, SaveName:"orgNm"                    ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:1      },
                {Header:"<sht:txt mid='BLANK'   mdef='직급'      />",     Type:"Text"        ,    Hidden:0, Width:70 ,  Align:"Center"    , ColMerge:0, SaveName:"jikgubNm"                 ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:10     },
                {Header:"<sht:txt mid='BLANK'   mdef='사번'      />",     Type:"Text"        ,    Hidden:0, Width:50 ,  Align:"Center"    , ColMerge:0, SaveName:"sabun"                     ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:20     },
                {Header:"<sht:txt mid='BLANK'   mdef='성명'      />",     Type:"Text"        ,    Hidden:0, Width:50 ,  Align:"Center"    , ColMerge:0, SaveName:"name"                     ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:20     },
                {Header:"<sht:txt mid='BLANK'   mdef='진행상태'  />",     Type:"Combo"       ,    Hidden:0, Width:100,  Align:"Center"    , ColMerge:0, SaveName:"approvalStatus"           ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:8      },
                {Header:"<sht:txt mid='BLANK'   mdef='계획서'    />",     Type:"Image"       ,    Hidden:1, Width:80 ,  Align:"Center"    , ColMerge:0, SaveName:"approvalNote"             ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:8      },
                {Header:"<sht:txt mid='BLANK'   mdef='요청일'    />",     Type:"Text"        ,    Hidden:0, Width:75 ,  Align:"Center"    , ColMerge:0, SaveName:"approvalReqYmd"           ,    KeyField:0, CalcLogic:"", Format:"Ymd"        ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:10      },
                {Header:"<sht:txt mid='BLANK'   mdef='승인자'    />",     Type:"Text"        ,    Hidden:0, Width:50 ,  Align:"Center"    , ColMerge:0, SaveName:"approvalEmpName"          ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:8      },
                {Header:"<sht:txt mid='BLANK'   mdef='승인일'    />",     Type:"Text"        ,    Hidden:0, Width:75 ,  Align:"Center"    , ColMerge:0, SaveName:"approvalYmd"              ,    KeyField:0, CalcLogic:"", Format:"Ymd"        ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:10      }
            ];

            IBS_InitSheet(sheet1, initdata1);

            sheet1.SetCountPosition(0);
            sheet1.SetEditable(true);
            sheet1.SetVisible(true);
            //sheet1.SetDataLinkMouse("approvalNote", 0);

            $(window).smartresize(sheetResize); sheetInit();

            fnSetCode();
            $("#sYear").change(function () {
                fnSetCode();
            })

            doAction1("Search");
        });


        function fnSetCode() {
            if($("#sYear").val() == "" || $("#sYear").val().length != 4) {
                return;
            }

            let searchYear = $("#sYear").val();
            let baseSYmd = searchYear + "-01-01";
            let baseEYmd = searchYear + "-12-31";

            //상하반기
            var halfGubunTypeCd     = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","D00005", baseSYmd, baseEYmd), "");
            sheet1.SetColProperty("halfGubunType", 	{ComboText:halfGubunTypeCd[0], ComboCode:halfGubunTypeCd[1]} );

            $("#searchHalfGubunTypeCd").html(halfGubunTypeCd[2]);              //.val("1");

            var approvalStatusCd     = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","D00007", baseSYmd, baseEYmd), "");
            sheet1.SetColProperty("approvalStatus", 	{ComboText:approvalStatusCd[0], ComboCode:approvalStatusCd[1]} );

        }

        $(function() {

            $("#sYear").bind("keyup",function(event){
                makeNumber(this,"A");
                if( event.keyCode == 13){
                    doAction1("Search");
                }
            });
//             $("#sYmd").datepicker2({startdate:"eYmd"});

//             $("#sYmd").bind("keydown",function(event){
//                 if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
//             });
        });

        //Sheet1 Action
        function doAction1(sAction) {
            switch (sAction) {
                case "Search":
                    if($("#sYear").val() == "") {
                        alert("<msg:txt mid='alertVacationApp1' mdef='년도를 입력하여 주십시오.'/>");
                        $("#sYear").focus();
                        return;
                    }

                    var param =  "";
                    sheet1.DoSearch( "${ctx}/SelfDevelopmentRegStat.do?cmd=getSelfDevelopmentRegStat",$("#srchFrm").serialize() + param );

                    break;

                case "Down2Excel":
                    var downcol = makeHiddenSkipCol(sheet1);
                    var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
                    sheet1.Down2Excel(param);
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
            } catch (ex) {
                alert("OnSearchEnd Event Error : " + ex);
            }
        }

        // 셀이 선택 되었을때 발생한다
        function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol,isDelete) {
            try {
                //if(OldRow != NewRow) {}
            } catch (ex) {
                alert("OnSelectCell Event Error : " + ex);
            }
        }

        function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
            try {
                /*if (Msg != "") { alert(Msg);}*/
                doAction1("Search");
            } catch (ex) {
                alert("OnSaveEnd Event Error " + ex);
            }
        }

        function getReturnValue(returnValue) {

            if( popGubun == "O"){
                $("#searchOrgCd").val(returnValue[0].orgCd);
                $("#searchOrgNm").val(returnValue[0].orgNm);
                doAction1("Search");
            }else if( popGubun == "E"){
                var rv = $.parseJSON('{'+ returnValue+'}');

                $('#name').val(rv["name"]);
                $('#searchSabun').val(rv["sabun"]);
                doAction1("Search");
            }else if ( popGubun == "insert"){
                var rv = $.parseJSON('{'+ returnValue+'}');

                sheet1.SetCellValue(gPRow, "sabun",			rv["sabun"] );
                sheet1.SetCellValue(gPRow, "name",			rv["name"] );
                sheet1.SetCellValue(gPRow, "orgNm",			rv["orgNm"] );
                sheet1.SetCellValue(gPRow, "alias",			rv["alias"] );
                sheet1.SetCellValue(gPRow, "jikgubNm",		rv["jikgubNm"] );
                sheet1.SetCellValue(gPRow, "jikweeNm",		rv["jikweeNm"] );
                sheet1.SetCellValue(gPRow, "jikchakNm",		rv["jikchakNm"] );
                sheet1.SetCellValue(gPRow, "manageNm",		rv["manageNm"] );
                sheet1.SetCellValue(gPRow, "workTypeNm",	rv["workTypeNm"] );
                sheet1.SetCellValue(gPRow, "payTypeNm",		rv["payTypeNm"] );
            }
        }

        // 소속 팝업
        function showOrgPopup() {
            if(!isPopup()) {return;}

            popGubun = "O";
            // var rst = openPopup("/Popup.do?cmd=orgBasicPopup&authPg=R", "", "740","520");
            let w = 740;
            let h = 520;
            let url = "/Popup.do?cmd=viewOrgBasicLayer&authPg=R";

            const layerModal = new window.top.document.LayerModal({
                id : 'orgLayer'
                , url : url
                , parameters : {}
                , width : w
                , height : h
                , title : '<tit:txt mid='orgSchList' mdef='조직 리스트 조회'/>'
                , trigger :[
                    {
                        name : 'orgTrigger'
                        , callback : function(result){
                            getReturnValue(result);
                        }
                    }
                ]
            });
            layerModal.show();
        }

        function clearCode(num) {

            if(num == 1) {
                $("#searchOrgCd").val("");
                $("#searchOrgNm").val("");
                //doAction1("Search");  // 2014.12.22 막음
            } else {
                $('#name').val("");
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
                        <th><tit:txt mid='BLANK' mdef='년도'/></th>
                        <td>
                            <input id="sYear" name ="sYear" type="text" class="text" maxlength="4"  value="${curSysYear}" />
                        </td>
						<th>반기구분</th>
                        <td>
                            <select id="searchHalfGubunTypeCd" name="searchHalfGubunTypeCd"></select>
                        </td>
                        <th>승인상태</th>
                        <td>
                            <input type="radio" id="searchChartTypeALL" name="searchChartType" value="ALL"  onClick="doAction1('Search');" checked  ><label for="searchChartTypeALL">전체</label>
                            <input type="radio" id="searchChartTypeAPP" name="searchChartType" value="APP"  onClick="doAction1('Search');"><label for="searchChartTypeAPP">승인현황</label>
                            <input type="radio" id="searchChartTypeREG" name="searchChartType" value="REG"  onClick="doAction1('Search');"><label for="searchChartTypeREG">요청현황</label>
                            <input type="radio" id="searchChartTypeNONE" name="searchChartType" value="NONE" onClick="doAction1('Search');"><label for="searchChartTypeNONE">미등록현황</label>
                        </td>
                    </tr>
                    <tr>
                        <th><tit:txt mid='104279' mdef='소속'/></th>
                        <td>

                            <c:choose>
                                <c:when test="${ssnSearchType =='A'}">
                                    <input type="text" id="searchOrgNm" name="searchOrgNm"  class="text readonly w100" />
                                    <input type="hidden" id="searchOrgCd" name="searchOrgCd" />
                                    <a href="javascript:showOrgPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
                                    <a href="javascript:clearCode(1)" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
                                </c:when>
                                <c:otherwise>
                                    <select id="searchOrgCd" name="searchOrgCd" > </select>
                                </c:otherwise>
                            </c:choose>
                            <input id="searchOrgType" name="searchOrgType" type="checkbox" class="checkbox hide" value="N"/><label for="searchOrgType" class="hide"><tit:txt mid='112471' mdef='하위포함'/></label>
                        </td>
                        <th><tit:txt mid='104330' mdef='사번/성명'/></th>
                        <td>
                            <input type="text" id="searchSabunName" name="searchSabunName" class="text" />
<%--
                            <input id="name"  name="name"  type="text" class="text readonly" readonly/>
                            <a href="javascript:showEmployeePopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
--%>
                        </td>
                        <td colspan="2"><btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/></td>
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
                            <li id="txt" class="txt"><tit:txt mid='BLANK' mdef='자기계발계획서등록현황'/></li>
                            <li class="btn">
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
