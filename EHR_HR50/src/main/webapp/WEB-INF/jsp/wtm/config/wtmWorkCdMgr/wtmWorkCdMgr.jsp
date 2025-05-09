<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp" %>
<!DOCTYPE html><html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<!-- bootstrap -->
<link rel="stylesheet" type="text/css" href="/common/plugin/bootstrap/css/bootstrap.min.css" />
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%><!--common-->
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!-- 근무 css -->
<link rel="stylesheet" type="text/css" href="/assets/css/attendanceNew.css"/>
<script src="/common/plugin/bootstrap/js/bootstrap.min.js"></script>

<script>
    <!-- 개별 화면 script -->
    let reqUseTypeList;
    let editYn = false;
    var gPRow = "";
    $(function() {
        init();
        initEvent();
        doAction1("Search");
    });

    function init() {
        // 근무시간종류 콤보박스
        var grpCds = "WT0511,WT0512";
        const workTimeTypeList = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grpCds,false).codeList, "");
        $('#workTimeType').html(workTimeTypeList["WT0511"][2]+"|"+workTimeTypeList["WT0512"][2]);

        // 근무신청 세부설정 - 신청단위 라디오버튼 생성
        reqUseTypeList = codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","WT0513")
        let html = '';
        reqUseTypeList.forEach((reqUseType, idx) => {
            html += `<div class="radio-wrap"><input type="radio" name="requestUseType" id="reqUseTypeCd_${'${idx}'}" value="${'${reqUseType.code}'}" class="form-radio">
                     <label for="reqUseTypeCd_${'${idx}'}">${'${reqUseType.codeNm}'}</label></div>`
        })

        html += `<div class="radio-wrap"><input type="radio" name="requestUseType" id="reqUseTypeCd_none" value="NA" class="form-radio">
                 <label for="reqUseTypeCd_none">신청안함</label></div>`

        $("#reqUseTypeDiv").html(html);

        // 신청요일구분 콤보박스
        const requestDayTypeList = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","WT0514"), "선택");
        $('#requestDayType').html(requestDayTypeList[2]);

        // 근무신청 세부설정 - 결재 예외선
        const orgLevelCdList = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W82020"), "");
        $('#orgLevelCd').html(("<option value='N'>결재선 유지</option>"+orgLevelCdList[2]));

        // Sheet 초기화
        var initdata1 = {};
        initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly,Page:22};
        initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
        initdata1.Cols = [
            {Header:"삭제",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
            {Header:"상태",				Type:"${sSttTy}",	Hidden:1,   Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
            {Header:"근무명",			Type:"Text",		Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"workNm",		KeyField:1,	Format:"",		    PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
            {Header:"근무명약어",			Type:"Html",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"workSNmHtml",	KeyField:1,	Format:"",		    PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
            {Header:"순서",			    Type:"Int",			Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"seq",	        KeyField:1,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },

            /* Hidden */
            {Header:"근무코드",          Type:"Text",      Hidden:1,  SaveName:"workCd"},
            {Header:"간주근로여부",		    Type:"Text",	Hidden:1,	SaveName:"deemedYn", },
            {Header:"근무시간종류",		    Type:"Text",	Hidden:1,	SaveName:"workTimeType", },
            {Header:"약어",             Type:"Text",      Hidden:1,  SaveName:"workSNm"},
            {Header:"사용여부",          Type:"Text",      Hidden:1,  SaveName:"useYn"},
            {Header:"색상",	            Type:"Text",      Hidden:1,  SaveName:"color"},
            {Header:"메모",	            Type:"Text",      Hidden:1,  SaveName:"note"},
            {Header:"신청단위",          Type:"Text",      Hidden:1,  SaveName:"requestUseType"},
            {Header:"신청최소일수",       Type:"Text",      Hidden:1,  SaveName:"baseCnt"},
            {Header:"신청최대일수",       Type:"Text",      Hidden:1,  SaveName:"maxCnt"},
            {Header:"근무신청요일구분",    Type:"Text",      Hidden:1,  SaveName:"requestDayType"},
            {Header:"근무적용시간",       Type:"Text",      Hidden:1,  SaveName:"applyHour"},
            {Header:"결재예외선",         Type:"Text",      Hidden:1,  SaveName:"orgLevelCd"},
            {Header:"신청제외대상",       Type:"Text",      Hidden:1,  SaveName:"excpSearchSeq"},
            {Header:"신청제외대상명",      Type:"Text",      Hidden:1,  SaveName:"searchDesc"},
            {Header:"신청제외대상명",      Type:"Text",      Hidden:1,  SaveName:"baseCodeYn"},
            {Header:"하위등록여부",       Type:"Text",      Hidden:1,  SaveName:"regYn"},
        ]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
        $(window).smartresize(sheetResize); sheetInit();
        sheet1.SetSheetHeight(sheet1.GetSheetHeight());
    }

    function initEvent() {

        // 조회조건 입력 이벤트
        $('#searchUseYn').change(function() {
            doAction1("Search");
        });

        $("#searchWorkNm").keyup(function(event) {
            if(event.keyCode == 13) {
                doAction1("Search");
            }
        });

        // 새로입력 버튼 클릭 이벤트
        $('#btnClear').on('click', function() {
            clearForm();
        });

        // 복사저장 버튼 클릭 이벤트
        $('#btnCopy').on('click', async function() {
            if(!confirm('선택한 대상을 복사하여 새로 저장 하시겠습니까?')) {
                return;
            }
            $('#workCd').val('');
            await saveWorkCdMgr();
        });

        // 저장 버튼 클릭 이벤트
        $('#btnSave').on('click', saveWorkCdMgr);

        // 근무신청-신청단위 라디오버튼 변경 이벤트
        $('input[type=radio][name=requestUseType]').change(function() {
            if(this.id === 'reqUseTypeCd_none') {
                // 근무신청 사용하지 않는 경우, 근무신청 세부 설정 값 초기화 및 비활성화 처리
                $('#reqDetailDiv input[type="text"]').val('');
                $('#reqDetailDiv input[type="radio"]').not('[name="requestUseType"]').prop('checked', false);
                $('#reqDetailDiv input[type="checkbox"]').prop('checked', false);
                $('#reqDetailDiv select').prop('selectedIndex', 0);
            } else {
                // 공통코드(T10006)의 비고 값으로 신청가능일수, 근무적용시간 default 값 세팅
                const idx = replaceAll(this.id, 'reqUseTypeCd_', '');
                $('#baseCnt').val(reqUseTypeList[idx].note1);
                $('#maxCnt').val(reqUseTypeList[idx].note2);
                $('#applyHour').val(reqUseTypeList[idx].note3);
            }
            setEditable('requestUseType');
        });

        // 근무신청 세부설정 - 일수 및 시간 입력 항목 숫자만 입력 가능하도록
        $("#baseCnt, #maxCnt").on("keyup", function(event) {
            makeNumber(this,'C'); // 소수점 허용
        });
        $("#applyHour").on("keyup", function(event) {
            makeNumber(this,'A'); // 숫자만 허용
        });

        // form 의 모든 입력 요소의 값이 변경된 경우
        $('form :input').on('change keyup paste', function() {
            editYn = true;
        });
    }

    function isValidSaveWorkCd() {
        let isValid = true;

        $("#workCdMgrForm span.req").each((idx, el) => {
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
     * 근무 코드 정보 저장
     */
    async function saveWorkCdMgr() {
        try {
            progressBar(true);

            if (!isValidSaveWorkCd()) {
                return;
            }

            // 저장 처리
            const response = await fetch("/WtmWorkCdMgr.do?cmd=saveWtmWorkCdMgr", {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: $("#workCdMgrForm").serialize()
            });

            const data = await response.json();
            if (data.Result.Message) {
                alert(data.Result.Message);
            }

            await doAction1("Search");

        } catch (error) {
            console.error('저장 중 오류 발생:', error);
            alert('저장 중 오류가 발생했습니다.');
        } finally {
            progressBar(false);
        }
    }

    /**
     * workCdMgrForm 의 모든 입력 요소 clear
     */
    function clearForm() {
        $('#workCdMgrForm input').not('[type=radio], [type="checkbox"]').val('');

        // text input 초기화
        $('#workCdMgrForm input[type="text"]').val('');

        // radio 버튼 초기화
        $('#workCdMgrForm input[type="radio"]').prop('checked', false);

        // checkbox 초기화
        $('#workCdMgrForm input[type="checkbox"]').prop('checked', false);

        // select 초기화
        $('#workCdMgrForm select').prop('selectedIndex', 0);
    }

    /**
     * Sheet 내용을 Form에 입력
     */
    function sheetToForm(Row) {
        gPRow = Row;

        $('#workCd').val(sheet1.GetCellValue(Row, 'workCd'));
        $('#workTimeType').val(sheet1.GetCellValue(Row, 'workTimeType'));
        $('#workSNm').val(sheet1.GetCellValue(Row, 'workSNm'));
        $('#workNm').val(sheet1.GetCellValue(Row, 'workNm'));
        $('#note').val(sheet1.GetCellValue(Row, 'note'));
        $('#baseCnt').val(sheet1.GetCellValue(Row, 'baseCnt'));
        $('#maxCnt').val(sheet1.GetCellValue(Row, 'maxCnt'));
        $('#applyHour').val(sheet1.GetCellValue(Row, 'applyHour'));
        $('#orgLevelCd').val(sheet1.GetCellValue(Row, 'orgLevelCd'));
        $('#excpSearchSeq').val(sheet1.GetCellValue(Row, 'excpSearchSeq'));
        $('#searchDesc').val(sheet1.GetCellValue(Row, 'searchDesc'));
        $('#requestDayType').val(sheet1.GetCellValue(Row, 'requestDayType'));

        const deemedYn = sheet1.GetCellValue(Row, 'deemedYn');
        $('input[type="radio"][name="deemedYn"][value="'+deemedYn+'"]').prop('checked', true);

        const useYn = sheet1.GetCellValue(Row, 'useYn');
        $('input[type="radio"][name="useYn"][value="'+useYn+'"]').prop('checked', true);

        const color = sheet1.GetCellValue(Row, 'color');
        $('input[type="radio"][name="color"][value="'+color+'"]').prop('checked', true);

        const requestUseType = sheet1.GetCellValue(Row, 'requestUseType');
        $('input[type="radio"][name="requestUseType"][value="'+requestUseType+'"]').prop('checked', true);

        const holInclYn = sheet1.GetCellValue(Row, 'holInclYn');
        $('input[type="radio"][name="holInclYn"][value="'+holInclYn+'"]').prop('checked', true);

        setEditable('requestUseType');
    }

    /**
     * Form 근무신청 세부설정 입력 항목 readOnly 처리
     */
    function setEditable(type) {

        if(type === 'requestUseType') {
            const id = $(`input[type="radio"][name="requestUseType"]:checked`).attr('id');
            if(id === undefined) return;

            if(id === 'reqUseTypeCd_none') {
                $('#reqDetailDiv :input, #reqDetailDiv select').prop('disabled', true)
                $('input[type=radio][name="requestUseType"]').prop('disabled', false);
            } else {
                // 근무신청 세부설정 모든 항목 활성화
                $('#reqDetailDiv :input, #reqDetailDiv select').prop('disabled', false)

                // 신청단위에 따른 입력 항목 비활성화 처리
                const idx = replaceAll(id, 'reqUseTypeCd_', '');
                const fixYn = reqUseTypeList[idx].note4.split('');
                const [baseCntFixYn, maxCntFixYn, applyHourFixYn] = fixYn;
                if(baseCntFixYn === 'Y') {
                    $('#baseCnt').addClass('readonly')
                    $('#baseCnt').attr('readonly', true)
                } else {
                    $('#baseCnt').removeClass('readonly')
                    $('#baseCnt').attr('readonly', false)
                }

                if(maxCntFixYn === 'Y') {
                    $('#maxCnt').addClass('readonly')
                    $('#maxCnt').attr('readonly', true)
                } else {
                    $('#maxCnt').removeClass('readonly')
                    $('#maxCnt').attr('readonly', false)
                }

                if(applyHourFixYn === 'Y') {
                    $('#applyHour').addClass('readonly')
                    $('#applyHour').attr('readonly', true)
                } else {
                    $('#applyHour').removeClass('readonly')
                    $('#applyHour').attr('readonly', false)
                }
            }
        }

        //신청제외대상
        selectedRequestUseType();
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
                        $("#excpSearchSeq").val(result.searchSeq);
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
        $("#excpSearchSeq").val('');
        $("#searchDesc").val('');
    }


    //---------------------------------------------------------------------------------------------------------------
    // sheet1 Event
    //---------------------------------------------------------------------------------------------------------------
    // Sheet1 Action
    function doAction1(sAction) {
        switch (sAction) {
            case "Search":
                sheet1.DoSearch( "${ctx}/WtmWorkCdMgr.do?cmd=getWtmWorkCdMgrList",$("#workCdMgrForm").serialize() );
                break;
            case "SaveSeq":
                IBS_SaveName(document.workCdMgrForm,sheet1);
                sheet1.DoSave( "${ctx}/WtmWorkCdMgr.do?cmd=saveWtmWorkCdSeq", $("#workCdMgrForm").serialize());
                break;
            case "Delete":
                IBS_SaveName(document.workCdMgrForm,sheet1);
                sheet1.DoSave( "${ctx}/WtmWorkCdMgr.do?cmd=deleteWtmWorkCdMgr", $("#workCdMgrForm").serialize());
                break;
        }
    }

    // 조회 후 에러 메시지
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {
            if (Msg != "") {
                alert(Msg);
            }
            // sheetResize();
            editYn = false;


            for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows(); i++) {
                if(sheet1.GetCellValue(i, "baseCodeYn") === 'Y') {
                    sheet1.SetCellEditable(i,"sDelete",false);
                }
            }

            if(sheet1.RowCount()+sheet1.HeaderRows() > sheet1.HeaderRows()) {
                sheetToForm(sheet1.GetDataFirstRow());
            } else {
                clearForm();
            }

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
            if( Code > -1 ) doAction1("Search");
        } catch (ex) {
            alert("OnSaveEnd Event Error " + ex);
        }
    }

    // Sheet1 클릭 이벤트
    function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
        try{
            if(editYn) {
                if(!confirm("저장 되지 않은 항목이 있습니다. 정말 이동하시겠습니까?")){
                    sheet1.SetSelectRow(gPRow);
                    return;
                }
            }
            sheetToForm(Row);
            editYn = false;
        } catch(ex){alert("OnClick Event Error : " + ex);}
    }

    function sheet1_OnBeforeCheck(Row, Col) {
        try{
            sheet1.SetAllowCheck(true);
            if(sheet1.ColSaveName(Col) == "sDelete") {
                if(sheet1.GetCellValue(Row, "regYn") == "Y") {
                    alert("이미 " + sheet1.GetCellValue(Row, "workNm") + " 신청된 근태이력이 존재합니다.");
                    sheet1.SetAllowCheck(false);
                    return;
                }
            }
        }catch(ex){
            alert("OnBeforeCheck Event Error : " + ex);
        }
    }

    function selectedRequestUseType (){
        if($("[name=requestUseType]:checked").val() == 'NA'){
            $('#searchDesc').parent().parent().hide();
            $('#searchDesc').parent().parent().prev().hide();
        }else{
            $('#searchDesc').parent().parent().show();
            $('#searchDesc').parent().parent().prev().show();
        }
        clearSearchSeqValue();
    }
</script>
</head>
<body class="iframe_content white attendanceNew">
<form id="workCdMgrForm" name="workCdMgrForm">
    <input id="workCd" name ="workCd" type="hidden" class="text readonly"/>
    <div id="attCode" class="tab-content active">
        <div class="row flex-grow-1">
            <div class="col-4 att-con-wrap wrapper">
                <!-- 검색창 -->
                <div class="search_input outer">
                    <input id="searchWorkNm" name="searchWorkNm" class="form-input" type="text" placeholder="검색" />
                    <a href="javascript:doAction1('Search')" class="btn-search"><i class="mdi-ico">search</i></a>
                </div>
                <div class="inner">
                    <!-- 타이틀 -->
                    <div class="title-wrap sheet_title inner-wrap">
                        <span class="page-title">근무코드목록</span>
                        <div class="btn-wrap">
                            <input type="checkbox" class="form-checkbox type2" id="searchUseYn" name="searchUseYn" value="Y"/>
                            <label for="searchUseYn">사용</label>
                            <button type="button" onclick="doAction1('SaveSeq')" class="btn soft">순서저장</button>
                            <button type="button" onclick="doAction1('Delete')" class="btn filled">삭제</button>
                            <button type="button" onclick="doAction1('Search')" class="btn dark">조회</button>
                        </div>
                    </div>
                </div>
                <script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
            </div>
            <div class="col-8 att-manage-wrap border-left">
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
                            <th><span class="req"></span>근무명칭</th>
                            <td>
                                <div class="input-wrap wid-50">
                                    <input id="workNm" name="workNm" class="form-input" type="text" />
                                </div>
                            </td>
                            <th><span class="req"></span>약어</th>
                            <td>
                                <div class="input-wrap wid-50">
                                    <input id="workSNm" name="workSNm" class="form-input" type="text" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <span class=""></span>근무시간종류
                            </th>
                            <td>
                                <div class="input-wrap wid-50">
                                    <select id="workTimeType" name="workTimeType" class="custom_select"></select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th>간주근로여부</th>
                            <td>
                                <div class="input-wrap">
                                    <div class="radio-wrap">
                                        <input type="radio" name="deemedYn" id="deemedY" value="Y" class="form-radio" />
                                        <label for="deemedY">사용</label>
                                    </div>
                                    <div class="radio-wrap">
                                        <input type="radio" name="deemedYn" id="deemedN" value="N" class="form-radio" />
                                        <label for="deemedN">사용안함</label>
                                    </div>
                                </div>
                            </td>
                            <th>사용여부</th>
                            <td>
                                <div class="input-wrap">
                                    <div class="radio-wrap">
                                        <input type="radio" name="useYn" id="useY" value="Y" class="form-radio" />
                                        <label for="useY">사용</label>
                                    </div>
                                    <div class="raio-wrap">
                                        <input type="radio" name="useYn" id="useN" value="N" class="form-radio" />
                                        <label for="useN">사용안함</label>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th><span class="req"></span>색상</th>
                            <td colspan="3">
                                <div class="input-wrap">
                                    <div class="radio-wrap">
                                        <input type="radio" name="color" id="blue" class="form-radio" value="#9ccbfc"/>
                                        <label for="blue"><span class="att-code blue"></span></label>
                                    </div>
                                    <div class="radio-wrap">
                                        <input type="radio" name="color" id="green" class="form-radio" value="#a6e5ba"/>
                                        <label for="green"><span class="att-code green"></span></label>
                                    </div>
                                    <div class="radio-wrap">
                                        <input type="radio" name="color" id="orange" class="form-radio" value="#ffd49a"/>
                                        <label for="orange"><span class="att-code orange"></span></label>
                                    </div>
                                    <div class="radio-wrap">
                                        <input type="radio" name="color" id="red" class="form-radio" value="#ffbebe"/>
                                        <label for="red"><span class="att-code red"></span></label>
                                    </div>
                                    <div class="radio-wrap">
                                        <input type="radio" name="color" id="yellow" class="form-radio" value="#ffe79a"/>
                                        <label for="yellow"><span class="att-code yellow"></span></label>
                                    </div>
                                    <div class="radio-wrap">
                                        <input type="radio" name="color" id="gray" class="form-radio" value="#d7dadd"/>
                                        <label for="gray"><span class="att-code"></span></label>
                                    </div>
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
                <h2 class="title-wrap mt-12">
                    <div class="inner-wrap">
                        <span class="page-title">근무신청 세부설정</span>
                    </div>
                </h2>
                <div id="reqDetailDiv" class="table-wrap" style="height: calc(100vh - 350px); overflow-y: auto;">
                    <table class="basic type5 bt-line bb-line">
                        <colgroup>
                            <col width="15%" />
                            <col width="35%" />
                            <col width="15%" />
                            <col width="35%" />
                        </colgroup>
                        <tr>
                            <th>신청단위</th>
                            <td colspan="3">
                                <div id="reqUseTypeDiv" class="input-wrap"></div>
                            </td>
                        </tr>
                        <tr>
                            <th>신청단위일수</th>
                            <td>최소 <div class="input-wrap px-2" style="width: 80px;"><input id="baseCnt" name="baseCnt" class="form-input" type="text" /></div>일 - 최대<div class="input-wrap px-2" style="width: 80px;"><input id="maxCnt" name="maxCnt" class="form-input" type="text" /></div>일</td>
                            <th>
                                <span class=""></span>신청요일구분
                            </th>
                            <td>
                                <div class="input-wrap wid-50">
                                    <select id="requestDayType" name="requestDayType" class="custom_select"></select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th>근무적용시간</th>
                            <td colspan="3">
                                <div class="input-wrap px-2" style="width: 80px;"><input id="applyHour" name="applyHour" class="form-input" type="text" /></div>시간
                                <p class="desc mt-2">신청 단위가 '시간'일 경우 근무신청 시 신청한 시간이 적용됩니다.</p>
                            </td>
                        </tr>
                        <tr>
                            <th>결재 예외선</th>
                            <td>
                                <div class="input-wrap wid-50">
                                    <select id="orgLevelCd" name="orgLevelCd" class="custom_select"></select>
                                </div>
                            </td>
                            <th>신청제외대상</th>
                            <td>
                                <div class="input-wrap wid-50"><input id="searchDesc" name ="searchDesc" type="text" class="form-input readonly" readOnly/></div>
                                <input id="excpSearchSeq" name ="excpSearchSeq" type="hidden" class="text readonly" readOnly/>
                                <a onclick="javascript:openSearchSeqLayer();return false;" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
                                <a onclick="javascript:clearSearchSeqValue();return false;" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
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