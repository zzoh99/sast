<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp" %>
<!DOCTYPE html><html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<!-- bootstrap -->
<link rel="stylesheet" type="text/css" href="/common/plugin/bootstrap/css/bootstrap.min.css" />
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%><!--common-->
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!-- 근태 css -->
<link rel="stylesheet" type="text/css" href="/assets/css/attendanceNew.css"/>
<script src="/common/plugin/bootstrap/js/bootstrap.min.js"></script>

<script>

    var reportItemList;

    $(function() {
        init();
    });

    async function init() {
        await initSheet();
        doAction1("Search");
    }

    async function initSheet() {

        // Sheet 초기화
        var initdata1 = {};
        initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly,Page:22};
        initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
        initdata1.Cols = [
            {Header:"<sht:txt mid='sNoV1' 		mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",	Sort:0 },
            {Header:"<sht:txt mid='sDeleteV1' 		mdef='삭제'/>",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
            {Header:"<sht:txt mid='sStatusV1' 		mdef='상태'/>",				Type:"${sSttTy}",	Hidden:1,   Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
            {Header:"리포트항목명",		Type:"Combo",	Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"reportItemCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1 },
            {Header:"일집계여부",		    Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"daysCountYn",	        KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 },
            {Header:"수당",			    Type:"Popup",	Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"elementNm",	    KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1 },
            {Header:"elementCd",	    Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"elementCd",	    KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 },
            {Header:"적용비율",			Type:"Float",	Hidden:0,	Width:50,	Align:"Right",	ColMerge:0,	SaveName:"applyRate",	    KeyField:0,	Format:"NullFloat",	PointCount:2,	UpdateEdit:1,	InsertEdit:1, EditLen:5 },
        ]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
        $(window).smartresize(sheetResize); sheetInit();

        reportItemList = await getReportItemCdList();
        const reportItemHtml = convCode(reportItemList);
        sheet1.SetColProperty("reportItemCd", {ComboText:"|"+reportItemHtml[0], ComboCode:"|"+reportItemHtml[1]} );
    }

    async function getReportItemCdList() {
        const data = await callFetch("${ctx}/WtmReportItemPayMgr.do?cmd=getWtmReportItemPayMgrItemCdList", "");
        if (data == null || data.isError) {
            if (data && data.errMsg) alert(data.errMsg);
            else alert("알 수 없는 오류가 발생하였습니다.");
            return null;
        }

        return data.codeList;
    }

    //---------------------------------------------------------------------------------------------------------------
    // sheet1 Event
    //---------------------------------------------------------------------------------------------------------------
    // Sheet1 Action
    function doAction1(sAction) {
        switch (sAction) {
            case "Search":
                sheet1.DoSearch( "${ctx}/WtmReportItemPayMgr.do?cmd=getWtmReportItemPayMgrList", $("#sheet1Form").serialize() );
                break;
            case "Save":
                IBS_SaveName(document.sheet1Form, sheet1);
                sheet1.DoSave( "${ctx}/WtmReportItemPayMgr.do?cmd=saveWtmReportItemPayMgr", $("#sheet1Form").serialize());
                break;
            case "Insert":
                sheet1.DataInsert(0);
                break;
            case "Copy":
                sheet1.DataCopy();
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

            for (let i = sheet1.HeaderRows() ; i < sheet1.HeaderRows() + sheet1.RowCount() ; i++) {
                if (sheet1.GetCellValue(i, "daysCountYn") === "Y")
                    sheet1.SetCellEditable(i, "applyRate", 0);
            }

            sheetResize();
        } catch (ex) {
            alert("OnSearchEnd Event Error : " + ex);
        }
    }

    // 저장 후 메시지
    function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try {
            if (Msg != "") {
                alert(Msg);
            }
            if( Code > -1 ) {
                doAction1("Search");
            }
        } catch (ex) {
            alert("OnSaveEnd Event Error " + ex);
        }
    }

    // 팝업 클릭시 발생
    function sheet1_OnPopupClick(Row, Col) {
        try {
            var gPRow = Row;
            if (sheet1.ColSaveName(Col) === "elementNm") {
                if(!isPopup()) {return;}
                pGubun = "payElementLayer";
                let layerModal = new window.top.document.LayerModal({
                    id : 'payElementLayer',
                    url : '/PayElementPopup.do?cmd=viewPayElementLayer&authPg=${authPg}',
                    parameters : {},
                    width : 860,
                    height : 520,
                    title : '<tit:txt mid='payElementPop4' mdef='수당,공제 항목'/>',
                    trigger :[
                        {
                            name : 'payTrigger',
                            callback : function(result) {
                                const rv = { elementCd: result.resultElementCd, elementNm: result.resultElementNm, sdate: result.sdate };
                                sheet1.SetCellValue(gPRow, "elementCd",		rv["elementCd"] );
                                sheet1.SetCellValue(gPRow, "elementNm",		rv["elementNm"] );
                            }
                        }
                    ]
                });
                layerModal.show();
            }
        } catch (ex) {
            alert("OnPopupClick Event Error : " + ex);
        }
    }

    function sheet1_OnChange(Row, Col, Value, OldValue, RaiseFlag) {
        try {
            const colSaveName = sheet1.ColSaveName(Col);
            if (colSaveName === "reportItemCd") {
                const reportItem = getReportItemById(Value);
                sheet1.SetCellValue(Row, "daysCountYn", reportItem.daysCountYn);

                if (reportItem.daysCountYn === "Y") {
                    sheet1.SetCellEditable(Row, "applyRate", 0);
                } else {
                    sheet1.SetCellEditable(Row, "applyRate", 1);
                }
            }
        } catch (ex) {
            alert("OnChange Event Error : " + ex);
        }
    }

    function getReportItemById(value) {
        return reportItemList.filter(item => item.code == value)[0];
    }
</script>
</head>
<body class="bodywrap">
<form id="sheet1Form" name="sheet1Form"></form>
<div class="wrapper">
    <div class="inner">
        <div class="sheet_title">
            <ul>
                <li class="txt">리포트항목별 지급방법설정</li>
                <li class="btn">
                    <a href="javascript:doAction1('Search');" class="btn dark">조회</a>
                    <a href="javascript:doAction1('Insert');" class="btn outline_gray authA">입력</a>
                    <a href="javascript:doAction1('Copy');" class="btn outline_gray authA">복사</a>
                    <a href="javascript:doAction1('Save');" class="btn filled authA">저장</a>
                    <a href="javascript:doAction1('Down2Excel');" class="btn outline_gray authR">다운로드</a>
                </li>
            </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "kr"); </script>
</div>
</body>
</html>