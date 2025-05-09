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
            {Header:"<sht:txt mid='sNo'     mdef='No'             />",  Type:"${sNoTy}",  Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
            {Header:"<sht:txt mid='sStatus' mdef='상태'           />",  Type:"${sSttTy}", Hidden:Number("${sSttHdn}"),  Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
            {Header:"<sht:txt mid='BLANK'   mdef='실행년도'       />",  Type:"Text"     , Hidden:0, Width:0  ,  Align:"Center"    , ColMerge:0, SaveName:"activeYyyy"          , KeyField:1, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:4      },
            {Header:"<sht:txt mid='BLANK'   mdef='반기구분'       />",  Type:"Combo"    , Hidden:0, Width:0  ,  Align:"Center"    , ColMerge:0, SaveName:"halfGubunType"       , KeyField:1, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:1      },
            {Header:"<sht:txt mid='BLANK'   mdef='사번'           />",  Type:"Text"     , Hidden:0, Width:0  ,  Align:"Center"    , ColMerge:0, SaveName:"sabun"               , KeyField:1, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:13     },
            {Header:"<sht:txt mid='BLANK'   mdef='성명'           />",  Type:"Text"     , Hidden:0, Width:70 ,  Align:"Center"    , ColMerge:0, SaveName:"name"                , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100    },
            {Header:"<sht:txt mid='BLANK'   mdef='요청일'         />",  Type:"Text"     , Hidden:0, Width:80 ,  Align:"Center"    , ColMerge:0, SaveName:"approvalReqYmd"      , KeyField:0, CalcLogic:"", Format:"Ymd"        ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10      },
            {Header:"<sht:txt mid='BLANK'   mdef='승인상태'       />",  Type:"Combo"    , Hidden:0, Width:70 ,  Align:"Center"    , ColMerge:0, SaveName:"approvalStatus"      , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:1      },
            {Header:"<sht:txt mid='BLANK'   mdef='승인부서'       />",  Type:"Text"     , Hidden:1, Width:0  ,  Align:"Center"    , ColMerge:0, SaveName:"approvalMainOrgCd"   , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10     },
            {Header:"<sht:txt mid='BLANK'   mdef='승인부서'       />",  Type:"Text"     , Hidden:1, Width:120,  Align:"Left"      , ColMerge:0, SaveName:"mainOrgNm"           , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100    },
            {Header:"<sht:txt mid='BLANK'   mdef='상위부서'       />",  Type:"Text"     , Hidden:0, Width:120,  Align:"Left"      , ColMerge:0, SaveName:"priorOrgNm"           , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100    },
            {Header:"<sht:txt mid='BLANK'   mdef='승인팀'         />",  Type:"Text"     , Hidden:1, Width:0  ,  Align:"Center"    , ColMerge:0, SaveName:"approvalOrgCd"       , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10     },
            {Header:"<sht:txt mid='BLANK'   mdef='승인팀'         />",  Type:"Text"     , Hidden:0, Width:120,  Align:"Left"      , ColMerge:0, SaveName:"orgNm"               , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100    },
            {Header:"<sht:txt mid='BLANK'   mdef='승인자사번'     />",  Type:"Text"     , Hidden:1, Width:0  ,  Align:"Center"    , ColMerge:0, SaveName:"approvalEmpNo"       , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:13     },
            {Header:"<sht:txt mid='BLANK'   mdef='승인자성명'     />",  Type:"Text"     , Hidden:1, Width:0  ,  Align:"Center"    , ColMerge:0, SaveName:"approvalEmpName"     , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:20     },
            {Header:"<sht:txt mid='BLANK'   mdef='승인일'         />",  Type:"Text"     , Hidden:1, Width:0  ,  Align:"Center"    , ColMerge:0, SaveName:"approvalYmd"         , KeyField:0, CalcLogic:"", Format:"Ymd"        ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10      },
            {Header:"<sht:txt mid='BLANK'   mdef='팀원의견'       />",  Type:"Text"     , Hidden:1, Width:0  ,  Align:"Center"    , ColMerge:0, SaveName:"approvalReqMemo"     , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:4000   },
            {Header:"<sht:txt mid='BLANK'   mdef='팀장의견'       />",  Type:"Text"     , Hidden:1, Width:0  ,  Align:"Center"    , ColMerge:0, SaveName:"approvalReturnMemo"  , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:4000   },
            {Header:"<sht:txt mid='BLANK'   mdef='선택'           />",  Type:"Text"     , Hidden:1, Width:0  ,  Align:"Center"    , ColMerge:0, SaveName:"approvalCheck"       , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100    },
            {Header:"<sht:txt mid='BLANK'   mdef='자기개발계획서' />",  Type:"Image"    , Hidden:1, Width:60 ,  Align:"Center"    , ColMerge:0, SaveName:"note"                , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:8      },
            {Header:"<sht:txt mid='BLANK'   mdef='승인취소'       />",  Type:"CheckBox" , Hidden:1, Width:50 ,  Align:"Center"    , ColMerge:0, SaveName:"approvalCancle"      , KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:0, EditLen:20     },
        ];

        IBS_InitSheet(sheet1, initdata1);

        sheet1.SetCountPosition(0);
        sheet1.SetEditable(true);
        sheet1.SetVisible(true);

        sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
        sheet1.SetDataLinkMouse("note", 1);

        fnSetCode();

        $("#sYear,#eYear").change(function (){
            fnSetCode();
        });

        $(window).smartresize(sheetResize); sheetInit();

        doAction1("Search");
    });


    function fnSetCode() {
        if($("#sYear").val() == "") {
            alert("<msg:txt mid='alertVacationApp1' mdef='시작년도를 입력하여 주십시오.'/>");
            $("#sYear").focus();
            return;
        }
        if($("#eYear").val() == "") {
            alert("<msg:txt mid='110116' mdef='종료년도를 입력하여 주십시오.'/>");
            $("#eYear").focus();
            return;
        }

        let baseSYmd = $("#sYear").val() + "-01-01";
        let baseEYmd = $("#eYear").val() + "-12-31";

        //상하반기
        var halfGubunTypeCd     = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","D00005", baseSYmd, baseEYmd), "");
        sheet1.SetColProperty("halfGubunType", 	{ComboText:halfGubunTypeCd[0], ComboCode:halfGubunTypeCd[1]} );

        $("#searchHalfGubunTypeCd").html("<option value=''>전체</option>"+halfGubunTypeCd[2]);              //.val("1");

        var approvalStatusCd     = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","D00007", baseSYmd, baseEYmd), "");
        sheet1.SetColProperty("approvalStatus", 	{ComboText:approvalStatusCd[0], ComboCode:approvalStatusCd[1]} );

        var approvalStatusCdPanel 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&&note1=Y","D00007", baseSYmd, baseEYmd), "");
        $("#searchApprovalStatus").html("<option value=''>전체</option>"+approvalStatusCdPanel[2]);

    }

    $(function() {

        $("#sYear, #eYear").bind("keyup",function(event){
            makeNumber(this,"A");
            if( event.keyCode == 13){
                doAction1("Search");
            }
        });
        $("#sYmd").datepicker2({startdate:"eYmd"});
        $("#eYmd").datepicker2({enddate:"sYmd"});

        $("#sYmd, #eYmd").bind("keydown",function(event){
            if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
        });
    });

    //Sheet1 Action
    function doAction1(sAction) {
        switch (sAction) {
            case "Search":
                if($("#sYear").val() == "") {
                    alert("<msg:txt mid='alertVacationApp1' mdef='시작년도를 입력하여 주십시오.'/>");
                    $("#sYear").focus();
                    return;
                }
                if($("#eYear").val() == "") {
                    alert("<msg:txt mid='110116' mdef='종료년도를 입력하여 주십시오.'/>");
                    $("#eYear").focus();
                    return;
                }
                if($("#sYear").val() > $("#eYear").val() ) {
                    alert("<msg:txt mid='109812' mdef='시작년도는 종료년도보다 작아야 합니다.'/>");
                    $("#sYear").focus();
                    return;
                }

                //var param =  "&searchApprovalEmpNo=${ssnSabun}" + "&searchApprovalOrgCd=IT00069";
                var param =  "&searchApprovalEmpNo=${ssnSabun}" + "&searchApprovalOrgCd=${ssnOrgCd}";



                sheet1.DoSearch( "${ctx}/SelfDevelopmentApr.do?cmd=getSelfDevelopmentArpList",$("#srchFrm").serialize() + param );

                break;
            case "Insert":
                var Row = sheet1.DataInsert(0) ;

                sheet1.SetCellValue(Row,"sabun"             ,$("#searchUserId").val());
                sheet1.SetCellValue(Row,"activeYyyy"        ,"${curSysYear}"         );
                sheet1.SetCellValue(Row,"approvalStatus"    ,"9"                     );

                // Include File 내 함수
                fnClearSheetInc();

                break;

            case "Save":
                if(sheet1.FindStatusRow("I|S|D|U") != ""){
                    IBS_SaveName(document.srchFrm,sheet1);
                    sheet1.DoSave( "${ctx}/SelfDevelopmentApp.do?cmd=saveSelfDevelopment", $("#srchFrm").serialize(),-1,0);

                }
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

            if( sheet1.RowCount() != 0 ) {
                var nSelectRow = sheet1.GetSelectRow();

                fnDoActionInc();        // Include File의 Action 실행
                fnSetData(nSelectRow);  // 기본상태정보 설정
                setAuth(nSelectRow);    // 권한및상태에 따라 DOM 상태 설정

            }else{
                $("#approvalStatus").val("0");
            }

            sheetResize();
        } catch (ex) {
            alert("OnSearchEnd Event Error : " + ex);
        }
    }




    // 셀이 선택 되었을때 발생한다
    function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol,isDelete) {
        try {
            if(OldRow != NewRow) {
                fnDoActionInc();    // Include File의 Action 실행
                fnSetData(NewRow);  // 기본상태정보 설정
                setAuth(NewRow);    // 권한및상태에 따라 DOM 상태 설정

            }
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

    function sheet1_OnClick(Row, Col, Value) {
        try{
            if(sheet1.ColSaveName(Col) == "note" ) {
                selfDevelopPopup(Row);
            }
        }catch(ex){alert("OnClick Event Error : " + ex);}

    }

    function fnSetData(nRow) {
        $("#approvalReqMemo"   ).val(sheet1.GetCellValue(nRow, "approvalReqMemo"    ));
        $("#approvalReturnMemo").val(sheet1.GetCellValue(nRow, "approvalReturnMemo" ));
        $("#approvalStatus"    ).val(sheet1.GetCellValue(nRow, "approvalStatus"     ));
    }

    // 헤더에서 호출
    function setEmpPage() {

        $("#searchSabun").val($("#searchUserId").val());

        doAction1("Search");
    }

    function selfDevelopPopup(Row){
        var w    = 900;
        var h    = 700;
        var url  = "${ctx}/RdPopup.do";
        var args = new Array();

        var rdMrd           = "";
        var rdTitle         = "";
        var rdParam         = "";

        rdMrd   = "cdp/SelfDevelopment.mrd";
        rdTitle = "자기계발계획";

        rdParam += "[${ssnEnterCd}]";
        rdParam += "["+sheet1.GetCellValue(Row,"sabun")+"]";
        rdParam += "["+sheet1.GetCellValue(Row,"activeYyyy")+"]";
        rdParam += "["+sheet1.GetCellValue(Row,"halfGubunType")+"]";
        rdParam += "["+(sheet1.GetCellValue(Row,"halfGubunType") == "1" ? "상반기" : "하반기")+ "]";
        rdParam += "["+sheet1.GetCellValue(Row,"name")+"]";

        var imgPath = " " ;
        args["rdTitle"]      = rdTitle ; // rd Popup제목
        args["rdMrd"]        = rdMrd;    // ( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
        args["rdParam"]      = rdParam;  // rd파라매터
        args["rdParamGubun"] = "rp";     // 파라매터구분(rp/rv)
        args["rdToolBarYn"]  = "Y" ;     // 툴바여부
        args["rdZoomRatio"]  = "100";    // 확대축소비율

        args["rdSaveYn"]  = "Y" ;  // 기능컨트롤_저장
        args["rdPrintYn"] = "Y" ;  // 기능컨트롤_인쇄
        args["rdExcelYn"] = "Y" ;  // 기능컨트롤_엑셀
        args["rdWordYn"]  = "Y" ;  // 기능컨트롤_워드
        args["rdPptYn"]   = "Y" ;  // 기능컨트롤_파워포인트
        args["rdHwpYn"]   = "Y" ;  // 기능컨트롤_한글
        args["rdPdfYn"]   = "Y" ;  // 기능컨트롤_PDF

        var rv = openPopup(url, args, w, h);  // 알디출력을 위한 팝업창
        if(rv!=null && rv["printResultYn"] == "Y"){
        }
    }






</script>
</head>
<body class="bodywrap">
<div class="wrapper">

    <form id="srchFrm" name="srchFrm" >

        <input type="hidden" id="tabsIndex"      name="tabsIndex"       value=""    />
        <input type="hidden" id="approvalStatus" name="approvalStatus"  value=""    />
        <input type="hidden" id="prgType"        name="prgType"         value="Apr" />
        <input type="hidden" id="searchSabun"    name="searchSabun"     value=""    />


        <div class="sheet_search outer">
            <div>
                <table>
                    <tr>
                        <th><tit:txt mid='BLANK' mdef='년도'/></th>
                        <td>
                            <input id="sYear" name ="sYear" type="text" class="text" maxlength="4"  value="${curSysYear}" /> ~
                            <input id="eYear" name ="eYear" type="text" class="text" maxlength="4"  value="${curSysYear}" />
                        </td>
						<th>반기구분</th>
                        <td>
                            <select id="searchHalfGubunTypeCd" name="searchHalfGubunTypeCd"></select>
                        </td>
                        <th>승인상태</th>
                        <td>
                            <select id="searchApprovalStatus" name="searchApprovalStatus"></select>
                        </td>
                        <td><btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/></td>
                    </tr>
                </table>
            </div>
        </div>
    </form>




    <div class="outer">
        <div class="sheet_title">
            <ul>
                <li class="txt"><tit:txt mid='BLANK' mdef='자기계발 계획서'/></li>
                <li class="btn">

                </li>
            </ul>
        </div>
    </div>
    <div class="outer">
        <script type="text/javascript"> createIBSheet("sheet1", "100%", "150px", "${ssnLocaleCd}"); </script>
    </div>

    <%@ include file="/WEB-INF/jsp/hrd/selfDevelopment/selfDevelopmentApp/selfDevelopmentInc.jsp"%>


</div>
</body>
</html>
