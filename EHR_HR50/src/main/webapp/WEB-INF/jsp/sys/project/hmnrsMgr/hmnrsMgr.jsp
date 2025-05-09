<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>수행인력관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%><!-- Jquery -->
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%><!-- IBSheet -->
</head>

<script type="text/javascript">
    $(function () {
        var searchWorkCdList = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "S20010"), "전체");
        $("#searchWorkCd").html(searchWorkCdList[2]);

        $("#searchWorkCd, #searchName").on("keyup", function(event) {
            if( event.keyCode == 13) {
                doAction1("Search");
            }
        });

        initSheet();

        doAction1('Search');
    })

    function initSheet() {
        var initdata = {};
        initdata.Cfg = {FrozenCol:3, MergeSheet:msHeaderOnly, SearchMode:smLazyLoad,Page:22};
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata.Cols = [
            {Header:"No|No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
            {Header:"상태|상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
            {Header:"삭제|삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
            {Header:"구분|구분",		Type:"Combo",		Hidden:0,  Width:50,  	Align:"Center",   ColMerge:0,	SaveName:"workCd", KeyField:1, UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
            {Header:"성명|성명",			Type:"Text",   	Hidden:0, Width:80,		Align:"Center", ColMerge:0,  SaveName:"name", 	KeyField:1, UpdateEdit:0,   InsertEdit:1,		Edit:200},
            {Header:"담당모듈|담당모듈",		    Type:"Text",		Hidden:0,  Width:150,  	Align:"Left",   ColMerge:0,	SaveName:"rspnsModule", UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
            {Header:"투입일정|시작일",		    Type:"Date",		Hidden:0,  Width:80,  	Align:"Center",   ColMerge:0,	SaveName:"partSdate", Format:"Ymd",   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
            {Header:"투입일정|종료일",		    Type:"Date",		Hidden:0,  Width:80,  	Align:"Center",   ColMerge:0,	SaveName:"partEdate", Format:"Ymd",   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
            {Header:"휴가사용일수|휴가사용일수",		    Type:"Text",		Hidden:0,  Width:50,  	Align:"Center",   ColMerge:0,	SaveName:"useCnt", UpdateEdit:0,   InsertEdit:0},
            {Header:"분석|전체",		                    Type:"Text",		Hidden:0,  Width:50,  	Align:"Center",   ColMerge:0,	SaveName:"analyzeAllCnt",  UpdateEdit:0,   InsertEdit:0},
            {Header:"분석|계획",		                    Type:"Text",		Hidden:0,  Width:50,  	Align:"Center",   ColMerge:0,	SaveName:"analyzeCnt",  UpdateEdit:0,   InsertEdit:0},
            {Header:"분석|완료",		                    Type:"Text",		Hidden:0,  Width:50,  	Align:"Center",   ColMerge:0,	SaveName:"analyzeDoneCnt",  UpdateEdit:0,   InsertEdit:0},
            {Header:"설계|전체",		                    Type:"Text",		Hidden:0,  Width:50,  	Align:"Center",   ColMerge:0,	SaveName:"designAllCnt",  UpdateEdit:0,   InsertEdit:0},
            {Header:"설계|계획",		                    Type:"Text",		Hidden:0,  Width:50,  	Align:"Center",   ColMerge:0,	SaveName:"designCnt",  UpdateEdit:0,   InsertEdit:0},
            {Header:"설계|완료",		                    Type:"Text",		Hidden:0,  Width:50,  	Align:"Center",   ColMerge:0,	SaveName:"designDoneCnt",  UpdateEdit:0,   InsertEdit:0},
            {Header:"개발|전체",		                    Type:"Text",		Hidden:0,  Width:50,  	Align:"Center",   ColMerge:0,	SaveName:"planAllCnt",  UpdateEdit:0,   InsertEdit:0},
            {Header:"개발|계획",		                    Type:"Text",		Hidden:0,  Width:50,  	Align:"Center",   ColMerge:0,	SaveName:"planCnt",  UpdateEdit:0,   InsertEdit:0},
            {Header:"개발|완료",		                    Type:"Text",		Hidden:0,  Width:50,  	Align:"Center",   ColMerge:0,	SaveName:"planDoneCnt",  UpdateEdit:0,   InsertEdit:0},
        ];IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);


        var workCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "S20010"), "");
        sheet1.SetColProperty("workCd", {ComboText:"|"+workCd[0], ComboCode:"|"+workCd[1]} );

        $(window).smartresize(sheetResize); sheetInit();
    }

    //Sheet1 Action
    function doAction1(sAction) {
        switch (sAction) {
            case "Search":
                sheet1.DoSearch("${ctx}/HmnrsMgr.do?cmd=getHmnrsMgr", $("#srchFrm").serialize());
                break;
            case "Save":
                // if(!dupChk(sheet1,"ptCd", true, true)){break;}
                IBS_SaveName(document.srchFrm,sheet1);
                sheet1.DoSave("${ctx}/HmnrsMgr.do?cmd=saveHmnrsMgr", $("#srchFrm").serialize());
                break;
            case "Insert":
                sheet1.DataInsert(0);
                break;
            case "Copy":
                var row = sheet1.DataCopy();
                sheet1.SetCellValue(row, "useCnt", "0");
                break;
        }
    }

    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {
            if(Msg != '') {
                alert(Msg);
            }
            sheetResize();
        } catch (ex) {
            alert("OnSearchEnd Event Error : " + ex);
        }
    }

    function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try {
            if(Msg != '') {
                alert(Msg);
                doAction1("Search");
            }
        } catch (ex) {
            alert("OnSaveEnd Event Error " + ex);
        }
    }
</script>

<body>
    <div class="wrapper">
        <form id="srchFrm" name="srchFrm">
            <div class="sheet_search outer">
                <div>
                    <table>
                        <tr>
                            <th>구분</th>
                            <td>
                                <select name="searchWorkCd" id="searchWorkCd"></select>
                            </td>
                            <th>성명</th>
                            <td>
                                <input id="searchName" name="searchName" type="text" class="text">
                            </td>
                            <td> <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a> </td>
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
                                <li id="txt" class="txt">수행인력관리</li>
                                <li class="btn">
                                    <a href="javascript:doAction1('Insert')" 	 class="basic authA">입력</a>
                                    <a href="javascript:doAction1('Copy')" 	 class="basic authA">복사</a>
                                    <a href="javascript:doAction1('Save')" 	     class="basic authA">저장</a>
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