<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="hidden"><head><title>휴가생성</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!-- 근태 css -->
<link rel="stylesheet" type="text/css" href="/assets/css/attendanceNew.css"/>

<script type="text/javascript">

    $(function() {

        //Sheet 초기화
        initSheet();
        initSearchConditions();
        addBtnEvents();
    });

    //Sheet 초기화
    function initSheet() {

        const initdata1 = {};
        initdata1.Cfg = {SearchMode:smLazyLoad, Page:22, MergeSheet: msFixedMerge + msHeaderOnly};
        initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata1.Cols = [
            [
                {Header:"사진",		    Type:"Image",		Hidden:0, 	Width:60,	Align:"Center", ColMerge:1,	SaveName:"photo",   UpdateEdit:0,   ImgWidth:50,    ImgHeight:60, RowSpan:2 },
                {Header:"성명",		    Type:"Text",		Hidden:0, 	Width:70,	Align:"Center", ColMerge:0,	SaveName:"name",				KeyField:0,	UpdateEdit:0, InsertEdit:0 },
                {Header:"사번",		    Type:"Text",		Hidden:0, 	Width:70,	Align:"Center", ColMerge:0,	SaveName:"sabun",				KeyField:1,	UpdateEdit:0, InsertEdit:1, EditLen:13 },
                {Header:"직위",		    Type:"Text",		Hidden:Number("${jwHdn}"), 	Width:70,	Align:"Center", ColMerge:1,	SaveName:"jikweeNm",    KeyField:0,	UpdateEdit:0, InsertEdit:0, RowSpan:2 },
                {Header:"입사일",	    Type:"Text",		Hidden:0, 	Width:90,	Align:"Center", ColMerge:1,	SaveName:"empYmd",	Format:"Ymd",  KeyField:0, UpdateEdit:0,   InsertEdit:0, RowSpan:2 },
                {Header:"그룹입사일",	    Type:"Text",		Hidden:0, 	Width:90,	Align:"Center", ColMerge:1,	SaveName:"gempYmd",	Format:"Ymd",  KeyField:0, UpdateEdit:0,   InsertEdit:0, RowSpan:2 },

            <%--{Header:"No",			Type:"${sNoTy}",	Hidden:1,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",		Sort:0 },--%>
                {Header:"상태",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0, RowSpan:2 },
                {Header:"삭제",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),    Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0, RowSpan:2 },

                {Header:"휴가ID",	        Type:"Text",	Hidden:1, 	Width:0,	Align:"Center", ColMerge:0,	SaveName:"leaveId",		KeyField:0,	UpdateEdit:0, InsertEdit:0 },
                {Header:"기준년월",	        Type:"Text",	Hidden:1, 	Width:0,	Align:"Center", ColMerge:0,	SaveName:"ym",		    KeyField:0,	UpdateEdit:0, InsertEdit:0 },

                {Header:"근태구분",	        Type:"Combo",	Hidden:0, 	Width:90,	Align:"Center", ColMerge:1,	SaveName:"gntCd",		KeyField:1,	UpdateEdit:0, InsertEdit:1, EditLen:10, RowSpan:2 },

                /* 생성기준 */
                {Header:"생성기준\n시작일",	Type:"Date",	Hidden:0, 	Width:90,	Align:"Center", ColMerge:0,	SaveName:"gntSYmd",		    KeyField:0,	UpdateEdit:0, InsertEdit:0, RowSpan:2, ToolTip:"연차 생성 시 근무의 기준이 되는 구간입니다." },
                {Header:"생성기준\n종료일",	Type:"Date",	Hidden:0, 	Width:90,	Align:"Center", ColMerge:0,	SaveName:"gntEYmd",		    KeyField:0,	UpdateEdit:0, InsertEdit:0, RowSpan:2, ToolTip:"연차 생성 시 근무의 기준이 되는 구간입니다." },
                {Header:"생성기준\n입사일",	Type:"Date",	Hidden:0, 	Width:90,	Align:"Center", ColMerge:0,	SaveName:"creEmpYmd",	    KeyField:0,	UpdateEdit:0, InsertEdit:0, RowSpan:2 },
                {Header:"근속년차",	        Type:"Text",	Hidden:0, 	Width:60,	Align:"Center", ColMerge:0,	SaveName:"workYearCnt",	    KeyField:0,	UpdateEdit:0, InsertEdit:0, RowSpan:2 },
                {Header:"근속년수",	        Type:"Text",	Hidden:0, 	Width:60,	Align:"Center", ColMerge:0,	SaveName:"workCnt",	        KeyField:0,	UpdateEdit:0, InsertEdit:0, RowSpan:2 },
                {Header:"기준기간내\n근무율",	Type:"Text",	Hidden:0, 	Width:80,	Align:"Center", ColMerge:0,	SaveName:"workRate",	    KeyField:0,	UpdateEdit:0, InsertEdit:0, RowSpan:2, ToolTip:"생성기준구간 내 근무율입니다." },
                {Header:"발생\n기준연차",	    Type:"Text",	Hidden:0, 	Width:60,	Align:"Center", ColMerge:0,	SaveName:"creAnnualCnt",	KeyField:0,	UpdateEdit:0, InsertEdit:0, RowSpan:2 },
                {Header:"근속기준\n가산연차",	Type:"Text",	Hidden:0, 	Width:60,	Align:"Center", ColMerge:0,	SaveName:"addAnnualCnt",	KeyField:0,	UpdateEdit:0, InsertEdit:0, RowSpan:2, ToolTip:"근속년수에 따라 가산되는 연차 개수입니다." },
                {Header:"근무율80%\n미만월차",	Type:"Text",	Hidden:0, 	Width:60,	Align:"Center", ColMerge:0,	SaveName:"monthlyCnt",	    KeyField:0,	UpdateEdit:0, InsertEdit:0, RowSpan:2 },
                {Header:"1년미만\n대상자월차",	Type:"Text",	Hidden:0, 	Width:60,	Align:"Center", ColMerge:0,	SaveName:"monthlyU1yCnt",	KeyField:0,	UpdateEdit:0, InsertEdit:0, RowSpan:2 },
                {Header:"이월일수",	        Type:"Text",	Hidden:0, 	Width:60,	Align:"Center", ColMerge:0,	SaveName:"carryOverCnt",	KeyField:0,	UpdateEdit:0, InsertEdit:0, RowSpan:2 },

                /* 사용기준 */
                {Header:"사용가능\n시작일",	Type:"Date",	Hidden:0, 	Width:90,	Align:"Center", ColMerge:0,	SaveName:"useSYmd",		KeyField:1,	UpdateEdit:1, InsertEdit:1, EditLen:10, RowSpan:2 },
                {Header:"사용가능\n종료일",	Type:"Date",	Hidden:0, 	Width:90,	Align:"Center", ColMerge:0,	SaveName:"useEYmd",		KeyField:1,	UpdateEdit:1, InsertEdit:1, EditLen:10, RowSpan:2 },
                {Header:"발생일수",	        Type:"Float",	Hidden:0, 	Width:70,	Align:"Center", ColMerge:0,	SaveName:"creCnt",	    KeyField:1,	PointCount:3,	UpdateEdit:1, InsertEdit:1, EditLen:10, RowSpan:2 },
                {Header:"이월일수",	        Type:"Float",	Hidden:0, 	Width:70,	Align:"Center", ColMerge:0,	SaveName:"frdCnt",	    KeyField:0,	PointCount:3,	UpdateEdit:1, InsertEdit:1, EditLen:10, RowSpan:2 },
                {Header:"사용가능일수\nⓐ",	Type:"Float",	Hidden:0, 	Width:70,	Align:"Center", ColMerge:0,	SaveName:"useCnt",	    KeyField:0,	PointCount:3,	UpdateEdit:1, InsertEdit:1, EditLen:10, RowSpan:2 },
                {Header:"사용일수\nⓑ",	    Type:"Float",	Hidden:0, 	Width:70,	Align:"Center", ColMerge:0,	SaveName:"usedCnt",	    KeyField:0,	PointCount:3,	UpdateEdit:1, InsertEdit:1, EditLen:10, RowSpan:2 },
                {Header:"잔여일수\nⓐ-ⓑ",	    Type:"Float",	Hidden:0, 	Width:70,	Align:"Center", ColMerge:0,	SaveName:"restCnt",	    KeyField:0,	PointCount:3,	UpdateEdit:1, InsertEdit:1, EditLen:10, RowSpan:2 },
                {Header:"보상일수",	        Type:"Float",	Hidden:0, 	Width:70,	Align:"Center", ColMerge:0,	SaveName:"comCnt",	    KeyField:0,	PointCount:3,	UpdateEdit:1, InsertEdit:1, EditLen:10, RowSpan:2 },
                {Header:"1년미만\n연차여부",	Type:"CheckBox",Hidden:0, 	Width:60,	Align:"Center", ColMerge:0,	SaveName:"under1yYn",	KeyField:0,	UpdateEdit:1, InsertEdit:1, EditLen:1, TrueValue:"Y", FalseValue:"N", RowSpan:2 },
                {Header:"비고",	            Type:"Text",    Hidden:0, 	Width:150,	Align:"Center", ColMerge:0,	SaveName:"note",	KeyField:0,	UpdateEdit:1, InsertEdit:1, EditLen:2000, RowSpan:2 }
            ], [
                {Header:"사진"},
                {Header:"소속",       Type:"Text",	Hidden:0, 	Align:"Center", ColMerge:0,	SaveName:"orgNm",	KeyField:0,	UpdateEdit:0, InsertEdit:0, ColSpan:2 },
                {Header:"소속"},
                {Header:"직위"},
                {Header:"입사일"},
                {Header:"그룹입사일"},

                {Header:"상태"},
                {Header:"삭제"},

                {Header:"휴가ID",	 Hidden:1},
                {Header:"기준년월",    Hidden:1},

                {Header:"근태구분"},

                /* 생성기준 */
                {Header:"생성기준\n시작일"},
                {Header:"생성기준\n종료일"},
                {Header:"생성기준\n입사일"},
                {Header:"근속년차"},
                {Header:"근속년수"},
                {Header:"기준기간내\n근무율"},
                {Header:"발생\n기준연차"},
                {Header:"근속기준\n가산연차"},
                {Header:"근무율80%\n미만월차"},
                {Header:"1년미만\n대상자월차"},
                {Header:"이월일수"},

                /* 사용기준 */
                {Header:"사용가능\n시작일"},
                {Header:"사용가능\n종료일"},
                {Header:"발생일수"},
                {Header:"이월일수"},
                {Header:"사용가능일수\nⓐ"},
                {Header:"사용일수\nⓑ"},
                {Header:"잔여일수\nⓐ-ⓑ"},
                {Header:"보상일수"},
                {Header:"1년미만\n연차여부"},
                {Header:"비고"}
            ]
        ];
        IBS_InitSheet(sheet1, initdata1);
        sheet1.SetEditable("${editable}");
        sheet1.SetVisible(true);
        sheet1.SetCountPosition(4);
        sheet1.SetSelectionMode(3);

        $(sheet1).sheetAutocomplete({
            Columns: [
                {
                    ColSaveName  : "sabun",
                    CallbackFunc : function(returnValue){
                        const rv = $.parseJSON('{' + returnValue+ '}');
                        sheet1.SetCellValue(gPRow, "photo",		'/EmpPhotoOut.do?enterCd=' + rv["enterCd"] + '&searchKeyword=' + rv["sabun"] + '&type=1');
                        sheet1.SetCellValue(gPRow, "name",		rv["name"]);
                        sheet1.SetCellValue(gPRow, "sabun",		rv["sabun"]);
                        sheet1.SetCellValue(gPRow, "orgNm",		rv["orgNm"]);
                        sheet1.SetCellValue(gPRow, "jikweeNm",	rv["jikweeNm"]);
                        sheet1.SetCellValue(gPRow, "empYmd",	rv["empYmd"]);
                        sheet1.SetCellValue(gPRow, "gempYmd",	rv["gempYmd"]);
                    }
                }
            ]
        });

        const gntCdList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getWtmLeaveCdList&searchBasicCdYn=Y", false).codeList, "전체");
        sheet1.SetColProperty("gntCd",  {ComboText:"|"+gntCdList[0], ComboCode:"|"+gntCdList[1]} );
        $("#searchGntCd").html(gntCdList[2]);

        $(window).smartresize(sheetResize); sheetInit();
    }

    //Sheet1 Action
    function doAction1(sAction) {

        if (sAction === "Search") {

            sheet1.DoSearch("${ctx}/WtmLeaveCreMgr.do?cmd=getWtmLeaveCreMgrList", $("#sheet1Form").serialize());

        } else if (sAction === "Save") {

            IBS_SaveName(document.sheet1Form,sheet1);
            sheet1.DoSave("${ctx}/WtmLeaveCreMgr.do?cmd=saveWtmLeaveCreMgr", $("#sheet1Form").serialize());

        } else if (sAction === "Insert") {

            const row = sheet1.DataInsert();

        } else if (sAction === "Copy") {

            const row = sheet1.DataCopy();
            sheet1.SetCellValue(row, "leaveId", "");
            sheet1.SetCellValue(row, "useSYmd", "");
            sheet1.SetCellValue(row, "useEYmd", "");
            sheet1.SetCellValue(row, "gntSYmd", "");
            sheet1.SetCellValue(row, "gntEYmd", "");
            sheet1.SetCellValue(row, "creEmpYmd", "");
            sheet1.SetCellValue(row, "workYearCnt", "");
            sheet1.SetCellValue(row, "workCnt", "");
            sheet1.SetCellValue(row, "workRate", "");
            sheet1.SetCellValue(row, "creAnnualCnt", "");
            sheet1.SetCellValue(row, "addAnnualCnt", "");
            sheet1.SetCellValue(row, "monthlyCnt", "");
            sheet1.SetCellValue(row, "monthlyU1yCnt", "");
            sheet1.SetCellValue(row, "carryOverCnt", "");

        } else if (sAction === "Down2Excel") {

            const downCols = makeHiddenSkipCol(sheet1);
            const param = {DownCols: downCols, SheetDesign: 1, Merge: 1, ExcelFontSize: "9", ExcelRowHeight: "20"};
            sheet1.Down2Excel(param);

        } else if (sAction === "Down2Template") {

            const downCols = "sabun|gntCd|useSYmd|useEYmd|creCnt|frdCnt|useCnt|usedCnt|restCnt|comCnt|under1yYn|note";
            const param = {DownCols:downCols,SheetDesign:1,Merge:1,DownRows:'0',ExcelFontSize:"9"};
            sheet1.Down2Excel(param);

        } else if (sAction === "Create") {

            const p = {
                "searchYear": $("#searchYear").val(),
                "searchGntCd": $("#searchGntCd").val()
            };
            new window.top.document.LayerModal({
                id: 'wtmLeaveCreMgrLayer',
                url: "/WtmLeaveCreMgr.do?cmd=viewWtmLeaveCreMgrLayer",
                parameters: p,
                width: 500,
                height: 415,
                title: '휴가생성',
                trigger: [
                    {
                        name: 'wtmLeaveCreMgrLayerTrigger',
                        callback: function(rv) {
                            if (rv.resultCode > 0)
                                doAction1("Search");
                        }
                    }
                ]
            }).show();
        }else if(sAction === "LoadExcel"){
            var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params);
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

            showStatusBanner(isExistsSameData());

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

    function sheet1_OnChange(Row, Col, KeyCode, Shift) {
        try {
            if(sheet1.GetCellValue(Row, "useCnt") >= 0 && sheet1.GetCellValue(Row, "usedCnt") >= 0){
                sheet1.SetCellValue(Row, "restCnt", sheet1.GetCellValue(Row, "useCnt")-sheet1.GetCellValue(Row, "usedCnt"));
            }
        } catch (ex) {
            alert("OnKeyDown Event Error : " + ex);
        }
    }

    /**
     * 검색조건 initialize
     */
    function initSearchConditions() {
        const data = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeList","grpCd=H10010", false).codeList, "전체");
        $("select#searchStatusCd").html(data[2]);

        setGntCreSheet();
        $("#showReasons").off().on("click", setGntCreSheet);

        $("#searchYear, #searchOrgNm, #searchSabunName").off().on("keyup", function(e) {
            if (e.keyCode === 13)  doAction1("Search");
        });
    }

    /**
     * 휴가생성사유보기 체크 상태에 따라 sheet 열 숨김처리
     */
    function setGntCreSheet() {
        const isShowReason = ($("#showReasons:checked").val() === "Y");
        const fIdx = sheet1.SaveNameCol("gntSYmd");
        const lIdx = sheet1.SaveNameCol("carryOverCnt");
        let info = [];

        for (let i = fIdx ; i <= lIdx ; i++) {
            if (isShowReason) {
                info.push({ "Col": i, "Hidden": 0 });
            } else {
                info.push({ "Col": i, "Hidden": 1 });
            }
        }

        sheet1.SetColHidden(info);
    }

    /**
     * 중복 데이터 여부 확인
     * @returns {boolean}
     */
    function isExistsSameData() {
        return !!(sheet1.ColValueDupRows("sabun|gntCd|useSYmd|useEYmd"));
    }

    /**
     * 상태바 클릭 이벤트
     */
    function onClickStatusBanner() {
        const arr = sheet1.ColValueDupRows("sabun|gntCd|useSYmd|useEYmd").split(",");
        if (arr && arr.length > 0) {
            sheet1.SetSelectRow(arr[0]);
        }
    }

    /**
     * 상태바 표시
     * @param isShow 보여줄지 여부
     */
    function showStatusBanner(isShow = true) {
        if (isShow) $(".status-banner").css("display", "block");
        else $(".status-banner").css("display", "none");
    }


    /**
     * 버튼 이벤트 추가
     */
    function addBtnEvents() {
        $("#btnSearch").off().on("click", () => {
            doAction1('Search');
        });

        $("#btnCreate").off().on("click", () => {
            doAction1('Create');
        });

        $("#btnDown2Template").off().on("click", () => {
            doAction1('Down2Template');
        });

        $("#btnUpload").off().on("click", () => {
            doAction1('LoadExcel');
        });

        $("#btnInsert").off().on("click", () => {
            doAction1('Insert');
        });

        $("#btnCopy").off().on("click", () => {
            doAction1('Copy');
        });

        $("#btnSave").off().on("click", () => {
            doAction1('Save');
        });

        $("#btnDown2Excel").off().on("click", () => {
            doAction1('Down2Excel');
        });

        $(".status-banner").off().on("click", onClickStatusBanner);
    }
</script>
</head>
<body class="hidden">
<div class="wrapper">
    <div class="sheet_search outer">
        <form id="sheet1Form" name="sheet1Form" >
            <table>
                <tr>
                    <th><tit:txt mid='112270' mdef='기준년도'/></th>
                    <td>
                        <input id="searchYear" name="searchYear" type="text" class="text w60 required" maxlength="4" value="${curSysYear}" required />
                    </td>
                    <th><tit:txt mid='L1705100000155' mdef='휴가구분'/></th>
                    <td>
                        <select id="searchGntCd" name="searchGntCd"></select>
                    </td>
                    <th>
                        <label for="searchUnder1yYn">&nbsp;1년미만연차&nbsp;</label>
                    </th>
                    <td>
                        <input id="searchUnder1yYn" name="searchUnder1yYn" type="checkbox" class="checkbox" value="Y"/>
                    </td>
                    <th>휴가생성<br/>사유보기</th>
                    <td>
                        <input id="showReasons" name="showReasons" type="checkbox" class="checkbox" value="Y" checked/>
                    </td>
                </tr>
                <tr>
                    <th><tit:txt mid="104279" mdef="소속" /> </th>
                    <td>
                        <input type="text" id="searchOrgNm" name="searchOrgNm" class="text w150" style="ime-mode:active;"/>
                    </td>
                    <th><tit:txt mid='104330' mdef='사번/성명'/></th>
                    <td>
                        <input id="searchSabunName" name="searchSabunName" type="text" class="text"/>
                    </td>
                    <th><tit:txt mid='104472' mdef='재직상태'/></th>
                    <td>
                        <select id="searchStatusCd" name="searchStatusCd"></select>
                    </td>
                    <td colspan="2">
                        <btn:a id="btnSearch" css="button" mid="search" mdef="조회"/>
                    </td>
                </tr>
            </table>
        </form>
    </div>

    <div class="inner">
        <div class="sheet_title">
            <ul>
                <li class="txt"><tit:txt mid='' mdef='휴가생성관리'/></li>
                <li class="btn">
                    <div class="status-banner pointer">
                        사용기간이 중복된 데이터가 존재합니다. 확인하시려면 클릭해주세요.
                    </div>
                    <a id="btnCreate"           class="button authA">연차생성</a>
                    <a id="btnDown2Template"    class="basic authR"><tit:txt mid='113684' mdef='양식다운로드'/></a>
                    <a id="btnUpload"           class="basic authA"><tit:txt mid='104242' mdef='업로드'/></a>
                    <a id="btnInsert"           class="basic authA"><tit:txt mid='104267' mdef='입력'/></a>
<%--                    <a id="btnCopy"             class="basic authA"><tit:txt mid='104335' mdef='복사'/></a> 복사할 때 행이 이상하게 깨짐. 기능비활성화--%>
                    <a id="btnSave"             class="basic authA"><tit:txt mid='104476' mdef='저장'/></a>
                    <a id="btnDown2Excel"       class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
                </li>
            </ul>
        </div>
    </div>
    <script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>