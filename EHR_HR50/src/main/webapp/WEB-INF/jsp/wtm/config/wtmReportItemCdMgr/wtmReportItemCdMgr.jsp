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
    <!-- 개별 화면 script -->
    let editYn = false;

    $(function() {
        init();
        initEvent();
    });

    function init() {
        initSheet();
        doAction1("Search");
    }

    function initSheet() {

        // Sheet 초기화
        var initdata1 = {};
        initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly,Page:22};
        initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
        initdata1.Cols = [
            {Header:"<sht:txt mid='sDeleteV1' 		mdef='삭제'/>",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
            {Header:"<sht:txt mid='sStatusV1' 		mdef='상태'/>",				Type:"${sSttTy}",	Hidden:1,   Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
            {Header:"리포트항목코드",			Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"reportItemCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 },
            {Header:"리포트항목명",			Type:"Text",	Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"reportItemNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 },
            {Header:"계산순서",			    Type:"Text",	Hidden:0,	Width:50,	Align:"Right",	ColMerge:0,	SaveName:"calcSeq",	        KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 },
        ]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
        $(window).smartresize(sheetResize); sheetInit();
        sheet1.SetSheetHeight(sheet1.GetSheetHeight()-115);
    }

    /**
     * reportCdForm 의 모든 입력 요소 clear
     */
    function clearForm() {
        $('#reportCdForm input').not('[type=radio]').not("[type=checkbox]").val('');

        // text input 초기화
        $('#reportCdForm input[type="text"]').val('');

        // radio 버튼 초기화
        $('#reportCdForm input[type="radio"]').prop('checked', false);

        // checkbox 초기화
        $('#reportCdForm input[type="checkbox"]').prop('checked', false);

        // select 초기화
        $('#reportCdForm select').prop('selectedIndex', 0);
        $('#reportCdForm select[name=methodCd]').html('');
    }

    function isEmptyObject(obj) {
        return Object.keys(obj).length === 0 && obj.constructor === Object;
    }

    /**
     * Sheet 내용을 Form에 입력
     */
    async function renderForm() {
        editYn = false;

        const Row = sheet1.GetSelectRow();
        const reportItemCd = sheet1.GetCellValue(Row, 'reportItemCd');

        const data = await callFetch("${ctx}/WtmReportItemCdMgr.do?cmd=getWtmReportItemCdMgrOne", "reportItemCd=" + reportItemCd);
        if (data == null || data.isError || isEmptyObject(data.DATA)) {
            if (data && data.errMsg) alert(data.errMsg);
            else if (isEmptyObject(data.DATA)) alert(data.Message);
            else alert("알 수 없는 오류가 발생하였습니다.");
            clearForm();
            return;
        }

        const reportItemInfo = data.DATA.itemInfo;

        $('#reportItemCd').val(reportItemInfo.reportItemCd);
        $('#reportItemNm').val(reportItemInfo.reportItemNm);

        const useYn = reportItemInfo.useYn;
        $('input[type="radio"][name="useYn"][value="'+useYn+'"]').prop('checked', true);

        $('#calcSeq').val(reportItemInfo.calcSeq);

        const wgType = reportItemInfo.wgType;
        $('input[type="radio"][name="wgType"][value="'+wgType+'"]').prop('checked', true);

        const calcMethod = reportItemInfo.calcMethod;
        $('input[type="radio"][name="calcMethod"][value="'+calcMethod+'"]').prop('checked', true);

        const methodCdList = convCode(data.DATA.methodCdList, "");
        $("#methodCd").html(methodCdList[2]);
        $('#methodCd').val(reportItemInfo.methodCd);

        const convHourYn = reportItemInfo.convHourYn;
        $('input[type="radio"][name="convHourYn"][value="'+convHourYn+'"]').prop('checked', true);
        setUpbaseThTd($("input[name=convHourYn]:checked").attr("id"));

        if (convHourYn === "Y") {
            const upbase = reportItemInfo.upbase;
            $('input[type="radio"][name="upbase"][value="'+upbase+'"]').prop('checked', true);

            // 올림/반올림/버림 코드 설정
            const unitList = convCode(data.DATA.unitList, "단위 선택");
            $("#unit").html(unitList[2]);
            $('#unit').val(reportItemInfo.unit);
        }

        $('#note').val(reportItemInfo.note);

        const daysCountYn = reportItemInfo.daysCountYn;
        $('input[type="radio"][name="daysCountYn"][value="'+daysCountYn+'"]').prop('checked', true);
        setDaysCountTr($('input[type="radio"][name="daysCountYn"]:checked').attr("id"));

        $('#validHourO').val(reportItemInfo.validHourO);
        $('#validHourU').val(reportItemInfo.validHourU);

        $('#searchSeq').val(reportItemInfo.searchSeq);
        $('#searchDesc').val(reportItemInfo.searchDesc);
    }

    /**
     * 계산방법에 따라 계산방법상세코드 설정
     */
    async function setMethodCd() {

        const data = await callFetch("${ctx}/WtmReportItemCdMgr.do?cmd=getWtmReportItemCdMgrMethodCdList", $("#reportCdForm").serialize());
        if (data == null || data.isError) {
            if (data && data.errMsg) alert(data.errMsg);
            else alert("알 수 없는 오류가 발생하였습니다.");
            $("#methodCd").html("");
            return;
        }

        const methodCdList = convCode(data.codeList, "");
        $("#methodCd").html(methodCdList[2]);
    }

    /**
     * 계산방법에 따라 계산방법상세코드 설정
     */
    async function setUnit() {

        const data = await callFetch("${ctx}/CommonCode.do?cmd=getCommonCodeLists", "grpCd=WT0612");
        if (data == null || data.isError) {
            if (data && data.errMsg) alert(data.errMsg);
            else alert("알 수 없는 오류가 발생하였습니다.");
            $("#unit").html("");
            return;
        }

        const unitList = convCode(data.codeList, "단위 선택");
        $("#unit").html(unitList[2]);
    }

    /**
     * 조건검색 팝업 오픈
     */
    function openSearchSeqLayer() {
        if(!isPopup()) {return;}

        const url = '/Popup.do?cmd=viewPwrSrchMgrLayer&authPg=R';
        const p = { searchDesc: $("#searchDesc").val(), srchBizCd: "08" };
        new window.top.document.LayerModal({
            id : 'pwrSrchMgrLayer',
            url: url,
            parameters: p,
            width: 850,
            height: 620,
            title : '<tit:txt mid='112392' mdef='조건 검색 관리'/>',
            trigger :[
                {
                    name : 'pwrTrigger',
                    callback : function(result) {
                        $("#searchSeq").val(result.searchSeq);
                        $("#searchDesc").val(result.searchDesc);
                    }
                }
            ]
        }).show();
    }

    /**
     * 조건검색 값 clear
     */
    function clearSearchSeqValue() {
        $("#searchSeq").val('');
        $("#searchDesc").val('');
    }


    //---------------------------------------------------------------------------------------------------------------
    // sheet1 Event
    //---------------------------------------------------------------------------------------------------------------
    // Sheet1 Action
    function doAction1(sAction) {
        switch (sAction) {
            case "Search":
                if(editYn) {
                    if (!confirm("저장 되지 않은 항목이 있습니다. 정말 조회하시겠습니까?")) return;
                }
                sheet1.DoSearch( "${ctx}/WtmReportItemCdMgr.do?cmd=getWtmReportItemCdMgrList", $("#reportCdForm").serialize() );
                break;
            case "Delete":
                IBS_SaveName(document.reportCdForm, sheet1);
                sheet1.DoSave( "${ctx}/WtmReportItemCdMgr.do?cmd=deleteWtmReportItemCdMgr", $("#reportCdForm").serialize());
                break;
        }
    }

    // 조회 후 에러 메시지
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {
            if (Msg != "") {
                alert(Msg);
            }

            if (sheet1.RowCount() == 0 || sheet1.GetSelectRow() < sheet1.HeaderRows()) {
                clearForm();
            }
            editYn = false;

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
                editYn = false;
                doAction1("Search");
            }
        } catch (ex) {
            alert("OnSaveEnd Event Error " + ex);
        }
    }

    // Sheet1 클릭 이벤트
    function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
        try {
            if (OldRow == NewRow) return;
            if(editYn) {
                if(!confirm("저장 되지 않은 항목이 있습니다. 정말 이동하시겠습니까?")){
                    sheet1.SetSelectRow(OldRow, 0);
                    return;
                }
            }

            if (sheet1.GetCellValue(NewRow, "sStatus") !== "I")
                renderForm();
        } catch(ex) {
            alert("OnClick Event Error : " + ex);
        }
    }

    function isValidSaveReportItemCd() {
        let isValid = true;

        $("#reportCdForm span.req").each((idx, el) => {
            const elVal = $(el).parent().next().find("input, select, textarea").val();
            isValid = (elVal !== "");

            if (!isValid) {
                alert($(el).parent().text() + "은(는) 필수값입니다.");
                return false;
            }
        })

        return isValid;
    }

    /**
     * 리포트항목 코드 정보 저장
     */
    async function saveReportItemCdMgr() {
        try {
            progressBar(true);

            if (!isValidSaveReportItemCd()) {
                return;
            }

            // 저장 처리
            const data = await callFetch("/WtmReportItemCdMgr.do?cmd=saveWtmReportItemCdMgr", $("#reportCdForm").serialize());
            if (data == null || data.isError) {
                if (data && data.errMsg) alert(data.errMsg);
                else alert("알 수 없는 오류가 발생하였습니다.");
                return;
            }

            if (data.Result.Message) {
                alert(data.Result.Message);
            }

            if (data.Result.Code > 0) {
                editYn = false;
                renderForm();
            }

        } catch (error) {
            console.error('저장 중 오류 발생:', error);
            alert('저장 중 오류가 발생했습니다.');
        } finally {
            progressBar(false);
        }
    }

    function initEvent() {

        // 조회조건 입력 이벤트
        $('#searchUseYn').change(function() {
            doAction1("Search");
        });

        $("#searchReportItemNm").keyup(function(event) {
            if(event.keyCode == 13) {
                doAction1("Search");
            }
        });


        // 새로입력 버튼 클릭 이벤트
        $('#btnClear').on('click', function() {
            sheet1.DataInsert(-1);
            clearForm();
        });

        // 복사저장 버튼 클릭 이벤트
        $('#btnCopy').on('click', async function() {
            if(!confirm('선택한 대상을 복사하여 새로 저장 하시겠습니까?')) {
                return;
            }
            $('#reportItemCd').val('');
            await saveReportItemCdMgr();
        });

        // 저장 버튼 클릭 이벤트
        $('#btnSave').on('click', saveReportItemCdMgr);


        // 시간/일구분 라디오버튼 변경 이벤트
        $('#calcSeq').on("keyup", function() {
            sheet1.SetCellValue(sheet1.GetSelectRow(), 'calcSeq', $(this).val());
        });

        // 계산방법 변경 이벤트
        $('input[name=calcMethod]').on("change", function() {
            setMethodCd();
        });

        // 유효시간 입력 이벤트
        $('#validHourO').on("keyup", function() {
            if ($(this).val() && $('#validHourU').val()
                && Number($(this).val()) > Number($('#validHourU').val())) {
                alert('유효시간(미만)보다 클 수 없습니다.');
            }
        });
        $('#validHourU').on("keyup", function() {
            if($('#validHourO').val() && $(this).val() && Number($('#validHourO').val()) > Number($(this).val())) {
                alert('유효시간(이상)보다 작을 수 없습니다.');
            }
        });

        // 유효시간 숫자만 입력 가능하도록
        $("#validHourO, #validHourU").on("keyup", function() {
            makeNumber(this,'A'); // 숫자만 허용
        });

        // form 의 모든 입력 요소의 값이 변경된 경우
        $('form input:not(#searchUseYn,#searchReportItemNm)').on('change keyup paste', function() {
            editYn = true;
        });

        $("#reportItemNm").on("keyup", function() {
            sheet1.SetCellValue(sheet1.GetSelectRow(), 'reportItemNm', $(this).val());
        })

        // 시간으로 계산 여부 변경 이벤트
        $('input[name=convHourYn]').on("change", function() {
            setUpbaseThTd(this.id);
            if (this.id === "convHourYnY") {
                setUnit();
            }
        });

        // 근무일집계 사용여부 변경 이벤트
        $('input[name=daysCountYn]').on("change", function() {
            setDaysCountTr(this.id);
        });

        $("#btnOpenSearchSeqLayer").on("click", function() {
            openSearchSeqLayer();
        })

        $("#btnClearSearchSeq").on("click", function() {
            clearSearchSeqValue();
        })
    }

    function setUpbaseThTd(id) {
        if (id === "convHourYnY") {
            $("#upbaseTh, #upbaseTd").show();
        } else {
            $("#upbaseTh, #upbaseTd").hide();
            $("#unit").html("");
            $("#unit").val("");
            $('input[type="radio"][name="upbase"][value="N"]').prop('checked', true);
        }
    }

    function setDaysCountTr(id) {
        if (id === "daysCountYnY") {
            $("#daysCountTr").show();
        } else {
            $("#daysCountTr").hide();
            $("#validHourO, #validHourU, #searchSeq, #searchDesc").val("");
        }
    }

</script>
</head>
<body class="iframe_content white attendanceNew">
<form id="reportCdForm" name="reportCdForm">
    <input id="reportItemCd" name="reportItemCd" type="hidden"/>
    <div id="attCode" class="tab-content active">
        <div class="row flex-grow-1">
            <div class="col-3 att-con-wrap wrapper">
                <!-- 타이틀 -->
                <h2 class="inner">
                    <!-- 검색창 -->
                    <div class="search_input">
                        <input id="searchReportItemNm" name="searchReportItemNm" class="form-input" type="text" placeholder="검색" />
                        <i class="mdi-ico"><a href="javascript:doAction1('Search')">search</a></i>
                    </div>
                    <div class="title-wrap sheet_title inner-wrap">
                        <span class="page-title">리포트항목목록</span>
                        <div class="btn-wrap">
                            <input type="checkbox" class="form-checkbox type2" id="searchUseYn" name="searchUseYn" value="Y"/>
                            <label for="searchUseYn">사용</label>
                            <button type="button" onclick="doAction1('Delete')" class="btn filled">삭제</button>
                            <button type="button" onclick="doAction1('Search')" class="btn dark">조회</button>
                        </div>
                    </div>
                </h2>
                <script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
            </div>
            <div class="col-9 att-manage-wrap border-left">
                <!-- 타이틀 -->
                <h2 class="title-wrap">
                    <div class="inner-wrap">
                        <span class="page-title">기본설정</span>
                    </div>
                    <div class="btn-wrap">
                        <button type="button" id="btnClear" class="btn outline_gray">새로입력</button>
                        <button type="button" id="btnCopy" class="btn soft">복사저장</button>
                        <button type="button" id="btnSave" class="btn filled">저장</button>
                    </div>
                </h2>
                <div class="table-wrap mt-2 table-responsive">
                    <table class="basic type5 bt-line bb-line">
                        <colgroup>
                            <col width="15%" />
                            <col width="35%" />
                            <col width="15%" />
                            <col width="35%" />
                        </colgroup>
                        <tbody>
                        <tr>
                            <th>
                                <span class="req"></span>리포트항목명
                            </th>
                            <td>
                                <div class="input-wrap wid-50">
                                    <input id="reportItemNm" name="reportItemNm" class="form-input" type="text" />
                                </div>
                            </td>
                            <th>사용여부</th>
                            <td>
                                <div class="input-wrap">
                                    <input type="radio" name="useYn" id="useY" value="Y" class="form-radio" />
                                    <label for="useY">사용</label>
                                    <input type="radio" name="useYn" id="useN" value="N" class="form-radio" />
                                    <label for="useN">사용안함</label>
                                </div>
                            </td>
                        </tr>
                        <tr></tr>
                        <tr>
                            <th><span class="req"></span>근무/근태구분</th>
                            <td>
                                <div class="input-wrap">
                                    <input type="radio" name="wgType" id="wgTypeW" value="W" class="form-radio" />
                                    <label for="wgTypeW">근무</label>
                                    <input type="radio" name="wgType" id="wgTypeG" value="G" class="form-radio" />
                                    <label for="wgTypeG">근태</label>
                                </div>
                            </td>
                            <th><span class="req"></span>계산순서</th>
                            <td>
                                <div class="input-wrap px-2" style="width: 80px;">
                                    <input id="calcSeq" name="calcSeq" class="form-input" type="text" />
                                </div>번째
                            </td>
                        </tr>
                        <tr>
                            <th><span class="req"></span>계산방법</th>
                            <td>
                                <div class="input-wrap">
                                    <input type="radio" name="calcMethod" id="calcMethodS" value="S" class="form-radio" />
                                    <label for="calcMethodS">시스템코드</label>
                                    <input type="radio" name="calcMethod" id="calcMethodU" value="U" class="form-radio" />
                                    <label for="calcMethodU">사용자함수</label>
                                </div>
                            </td>
                            <th><span class="req"></span>계산방법선택</th>
                            <td>
                                <div class="input-wrap wid-50">
                                    <select id="methodCd" name="methodCd" class="custom_select"></select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th>시간으로 계산 여부</th>
                            <td>
                                <div class="input-wrap">
                                    <input type="radio" name="convHourYn" id="convHourYnN" value="N" class="form-radio" />
                                    <label for="convHourYnN">사용안함</label>
                                    <input type="radio" name="convHourYn" id="convHourYnY" value="Y" class="form-radio" />
                                    <label for="convHourYnY">시간으로 계산</label>
                                    <p class="desc mt-2">시간으로 계산 시 계산된 값 / 60 으로 조회됩니다.</p>
                                </div>
                            </td>
                            <th id="upbaseTh" style="display: none;">올림/반올림/버림</th>
                            <td id="upbaseTd" style="display: none;">
                                <div class="input-wrap">
                                    <select id="unit" name="unit" class="custom_select"></select>
                                    <input type="radio" name="upbase" id="upbaseN" value="N" class="form-radio" />
                                    <label for="upbaseN">사용안함</label>
                                    <input type="radio" name="upbase" id="upbaseC" value="C" class="form-radio" />
                                    <label for="upbaseC">올림</label>
                                    <input type="radio" name="upbase" id="upbaseR" value="R" class="form-radio" />
                                    <label for="upbaseR">반올림</label>
                                    <input type="radio" name="upbase" id="upbaseT" value="T" class="form-radio" />
                                    <label for="upbaseT">버림</label>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th>메모</th>
                            <td colspan="3">
                                <div class="input-wrap wid-50">
                                    <input id="note" name="note" class="form-input" type="text" />
                                </div>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>

                <!--  -->
                <h2 class="title-wrap mt-5">
                    <div class="inner-wrap">
                        <span class="page-title">근무일집계 설정</span>
                        <p class="desc mt-2">&nbsp;&nbsp;최종 결과 값을 바탕으로 아래 옵션에 따라 근무일수 집계를 수행합니다.</p>
                    </div>
                </h2>
                <div class="table-wrap">
                    <table class="basic type5 bt-line bb-line">
                        <colgroup>
                            <col width="15%" />
                            <col width="35%" />
                            <col width="15%" />
                            <col width="35%" />
                        </colgroup>
                        <tr>
                            <th>근무일집계 사용여부</th>
                            <td colspan="3">
                                <div class="input-wrap">
                                    <input type="radio" name="daysCountYn" id="daysCountYnN" value="N" class="form-radio" />
                                    <label for="daysCountYnN">사용안함</label>
                                    <input type="radio" name="daysCountYn" id="daysCountYnY" value="Y" class="form-radio" />
                                    <label for="daysCountYnY">사용</label>
                                </div>
                            </td>
                        </tr>
                        <tr id="daysCountTr" style="display: none;">
                            <th>1일 인정기준</th>
                            <td>
                                <div class="input-wrap px-2" style="width: 80px;">
                                    <input id="validHourO" name="validHourO" class="form-input" type="text" />
                                </div>이상 -
                                <div class="input-wrap px-2" style="width: 80px;">
                                    <input id="validHourU" name="validHourU" class="form-input" type="text" />
                                </div>이하의 계산값만 1일로 인정합니다.
                                <p class="desc mt-2">1일 인정기준을 입력하지 않을 경우 근무를 했다면 무조건 1일로 인정합니다.</p>
                            </td>
                            <th>집계대상자</th>
                            <td>
                                <div class="input-wrap wid-50">
                                    <input id="searchDesc" name="searchDesc" type="text" class="form-input readonly" readOnly/>
                                </div>
                                <input id="searchSeq" name="searchSeq" type="hidden" readOnly/>
                                <a id="btnOpenSearchSeqLayer" class="button6">
                                    <img src="/common/${theme}/images/btn_search2.gif"/>
                                </a>
                                <a id="btnClearSearchSeq" class="button7">
                                    <img src="/common/${theme}/images/icon_undo.gif"/>
                                </a>
                                <p class="desc mt-2">근무일집계 시 해당 대상자만 집계됩니다.</p>
                            </td>
                        </tr>
                    </table>
                </div>

                <!--  -->
                <h2 class="title-wrap mt-5">
                    <div class="inner-wrap">
                        <span class="page-title">급여계산 설정</span>
                        <p class="desc mt-2">&nbsp;&nbsp;급여계산 시 사용됩니다.</p>
                    </div>
                </h2>
                <div class="table-wrap">
                    <table class="basic type5 bt-line bb-line">
                        <colgroup>
                            <col width="15%" />
                            <col width="35%" />
                            <col width="15%" />
                            <col width="35%" />
                        </colgroup>
                        <tr>
                            <th>차감여부</th>
                            <td colspan="3">
                                <div class="input-wrap">
                                    <input type="radio" name="subtractYn" id="subtractYnN" value="N" class="form-radio" />
                                    <label for="subtractYnN">차감안함</label>
                                    <input type="radio" name="subtractYn" id="subtractYnY" value="Y" class="form-radio" />
                                    <label for="subtractYnY">차감</label>
                                    <p class="desc mt-2">계산된 값의 -1을 곱하여 급여계산에 사용합니다.</p>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </div>
</form>
</body>
</html>