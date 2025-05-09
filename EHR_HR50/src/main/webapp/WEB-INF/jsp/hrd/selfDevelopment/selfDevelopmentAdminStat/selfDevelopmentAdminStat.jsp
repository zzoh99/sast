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
            initdata1.Cfg = {SearchMode:smLazyLoad, MergeSheet:msAll, Page:22, FrozenCol:0, DataRowMerge:0};
            initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
            initdata1.Cols = [

                {Header:"<sht:txt mid='sNo'   mdef='No'                  />|<sht:txt mid='sNo'   mdef='No'            />", Type:"${sNoTy}",  Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
                {Header:"<sht:txt mid='BLANK' mdef='부코드'              />|<sht:txt mid='BLANK' mdef='부코드'        />", Type:"Text"        ,    Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"mainOrgCd"              ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:1      },
                {Header:"<sht:txt mid='BLANK' mdef='부'                  />|<sht:txt mid='BLANK' mdef='부'            />", Type:"Text"        ,    Hidden:1, Width:140,  Align:"Center"    , ColMerge:0, SaveName:"mainOrgNm"              ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:13     },
                {Header:"<sht:txt mid='BLANK' mdef='상위부서'                  />|<sht:txt mid='BLANK' mdef='상위부서'            />", Type:"Text"        ,    Hidden:0, Width:140,  Align:"Center"    , ColMerge:0, SaveName:"priorOrgNm"              ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:13     },
                {Header:"<sht:txt mid='BLANK' mdef='팀코드'              />|<sht:txt mid='BLANK' mdef='팀코드'        />", Type:"Text"        ,    Hidden:1, Width:0  ,  Align:"Left"      , ColMerge:0, SaveName:"orgCd"                  ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:8      },
                {Header:"<sht:txt mid='BLANK' mdef='소속'                  />|<sht:txt mid='BLANK' mdef='소속'            />", Type:"Text"        ,    Hidden:0, Width:130,  Align:"Center"    , ColMerge:0, SaveName:"orgNm"                  ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:1      },
                {Header:"<sht:txt mid='BLANK' mdef='직급'                />|<sht:txt mid='BLANK' mdef='직급'          />", Type:"Text"        ,    Hidden:0, Width:70 ,  Align:"Center"    , ColMerge:0, SaveName:"jikgubNm"               ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:10     },
                {Header:"<sht:txt mid='BLANK' mdef='사번'                />|<sht:txt mid='BLANK' mdef='사번'          />", Type:"Text"        ,    Hidden:0, Width:50 ,  Align:"Center"    , ColMerge:0, SaveName:"sabun"                   ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:20     },
                {Header:"<sht:txt mid='BLANK' mdef='성명'                />|<sht:txt mid='BLANK' mdef='성명'          />", Type:"Text"        ,    Hidden:0, Width:50 ,  Align:"Center"    , ColMerge:0, SaveName:"name"                   ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:20     },
                {Header:"<sht:txt mid='BLANK' mdef='등록상태'            />|<sht:txt mid='BLANK' mdef='등록상태'      />", Type:"Text"        ,    Hidden:1, Width:0  ,  Align:"Center"    , ColMerge:0, SaveName:"approvalStatus"         ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:8      },
                {Header:"<sht:txt mid='BLANK' mdef='자기개발실적'        />|<sht:txt mid='BLANK' mdef='자기개발실적'  />", Type:"Image"       ,    Hidden:1, Width:60 ,  Align:"Center"    , ColMerge:0, SaveName:"approvalNote"           ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:8      },
                {Header:"<sht:txt mid='BLANK' mdef='계획대비 실적 달성율'/>|<sht:txt mid='BLANK' mdef='계획시간'      />", Type:"Text"        ,    Hidden:0, Width:90 ,  Align:"Right"     , ColMerge:0, SaveName:"planTime"               ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:8      },
                {Header:"<sht:txt mid='BLANK' mdef='계획대비 실적 달성율'/>|<sht:txt mid='BLANK' mdef='실적시간'      />", Type:"Text"        ,    Hidden:0, Width:90 ,  Align:"Right"     , ColMerge:0, SaveName:"silTime"                ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:8      },
                {Header:"<sht:txt mid='BLANK' mdef='계획대비 실적 달성율'/>|<sht:txt mid='BLANK' mdef='달성율'        />", Type:"Text"        ,    Hidden:0, Width:90 ,  Align:"Right"     , ColMerge:0, SaveName:"achieve"                ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:8      }
            ];

            IBS_InitSheet(sheet1, initdata1);

            sheet1.SetCountPosition(0);
            sheet1.SetEditable(true);
            sheet1.SetVisible(true);
            //sheet1.SetDataLinkMouse("approvalNote", 0);

            $(window).smartresize(sheetResize); sheetInit();

            fnSetCode();

            doAction1("Search");


        });


        function fnSetCode() {
            //상하반기
            var halfGubunTypeCd     = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","D00005"), "");
            sheet1.SetColProperty("halfGubunType", 	{ComboText:halfGubunTypeCd[0], ComboCode:halfGubunTypeCd[1]} );

            $("#searchHalfGubunTypeCd").html(halfGubunTypeCd[2]);              //.val("1");

            var approvalStatusCd     = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","D00007"), "");
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
                    sheet1.DoSearch( "${ctx}/SelfDevelopmentAdminStat.do?cmd=getSelfDevelopmentAdminStat",$("#srchFrm").serialize() + param );

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

            var rv = $.parseJSON('{'+ returnValue+'}');

            if( popGubun == "O"){
                $("#searchOrgCd").val(rv["orgCd"]);
                $("#searchOrgNm").val(rv["orgNm"]);
                doAction1("Search");
            }else if( popGubun == "E"){
                $('#name').val(rv["name"]);
                $('#searchSabun').val(rv["sabun"]);
                doAction1("Search");
            }else if ( popGubun == "insert"){
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
            var rst = openPopup("/Popup.do?cmd=orgBasicPopup&authPg=R", "", "740","520");
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
                        <td><btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/></td>
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
                            <li id="txt" class="txt"><tit:txt mid='BLANK' mdef='자기계발실적조회(부서별)'/></li>
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
