<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.hr.common.util.DateUtil" %>
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
    let reqUseTypeList;
    let editYn = false;
    var gPRow = "";
    $(function() {
        init();
        initEvent();
        doAction1("Search");
    });

    function init() {
        // 근태종류 콤보박스
        const gntGubunCdList = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","T10003"), "");
        $('#gntGubunCd').html(gntGubunCdList[2]);

        // 근태신청 세부설정 - 신청단위 라디오버튼 생성
        reqUseTypeList = codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","T10006")
        let html = '';
        reqUseTypeList.forEach((reqUseType, idx) => {
            html += `<div class="radio-wrap"><input type="radio" name="requestUseType" id="reqUseTypeCd_${'${idx}'}" value="${'${reqUseType.code}'}" class="form-radio">
                     <label for="reqUseTypeCd_${'${idx}'}">${'${reqUseType.codeNm}'}</label></div>`
        })

        html += `<div class="radio-wrap"><input type="radio" name="requestUseType" id="reqUseTypeCd_none" value="NA" class="form-radio">
                 <label for="reqUseTypeCd_none">신청안함</label></div>`

        $("#reqUseTypeDiv").html(html);

        // 근태신청 세부설정 - 결재 예외선
        const orgLevelCdList = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W82020"), "");
        $('#orgLevelCd').html(("<option value='N'>결재선 유지</option>"+orgLevelCdList[2]));

        // Sheet 초기화
        var initdata1 = {};
        initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly,Page:22};
        initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
        initdata1.Cols = [
            {Header:"<sht:txt mid='sDeleteV1' 		mdef='삭제'/>",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
            {Header:"<sht:txt mid='sStatusV1' 		mdef='상태'/>",				Type:"${sSttTy}",	Hidden:1,   Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
            {Header:"<sht:txt mid='gntCdV6' 		mdef='근태종류'/>",			Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"gntGubunCd",	KeyField:1,	Format:"",		    PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
            {Header:"<sht:txt mid='gntNm' 			mdef='근태명'/>",			Type:"Html",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"gntShortNmHtml",	KeyField:1,	Format:"",		    PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
            {Header:"<sht:txt mid='gntNm' 			mdef='근태명'/>",			Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"gntNm",		KeyField:1,	Format:"",		    PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
            {Header:"<sht:txt mid='agreeSeq'        mdef='순서'/>",			    Type:"Int",			Hidden:0,	Width:50,	Align:"Right",	ColMerge:0,	SaveName:"seq",	        KeyField:1,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },

            /* Hidden */
            {Header:"근태코드",          Type:"Text",      Hidden:1,  SaveName:"gntCd"},
            {Header:"약어",             Type:"Text",      Hidden:1,  SaveName:"gntShortNm"},
            {Header:"사용여부",          Type:"Text",      Hidden:1,  SaveName:"useYn"},
            {Header:"대표코드여부",       Type:"Text",      Hidden:1,  SaveName:"basicGntCdYn"},
            {Header:"색상",	            Type:"Text",      Hidden:1,  SaveName:"color"},
            {Header:"메모",	            Type:"Text",      Hidden:1,  SaveName:"memo"},
            {Header:"신청단위",          Type:"Text",      Hidden:1,  SaveName:"requestUseType"},
            {Header:"신청최소일수",       Type:"Text",      Hidden:1,  SaveName:"baseCnt"},
            {Header:"신청최대일수",       Type:"Text",      Hidden:1,  SaveName:"maxCnt"},
            {Header:"휴일포함여부",       Type:"Text",      Hidden:1,  SaveName:"holInclYn"},
            {Header:"휴가적용시간",       Type:"Text",      Hidden:1,  SaveName:"stdApplyHour"},
            {Header:"발생근태사용여부",    Type:"Text",      Hidden:1,  SaveName:"vacationYn"},
            {Header:"마이너스허용여부",    Type:"Text",      Hidden:1,  SaveName:"minusAllowYn"},
            {Header:"결재예외선",         Type:"Text",      Hidden:1,  SaveName:"orgLevelCd"},
            {Header:"신청제외대상",       Type:"Text",      Hidden:1,  SaveName:"excpSearchSeq"},
            {Header:"신청제외대상명",      Type:"Text",      Hidden:1,  SaveName:"searchDesc"},
            {Header:"분할신청",          Type:"Text",      Hidden:1,  SaveName:"divCnt"},
            {Header:"무급여부",          Type:"Text",      Hidden:1,  SaveName:"noPayYn"},
        ]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

        sheet1.SetColProperty("gntGubunCd", 		{ComboText:"|"+gntGubunCdList[0], ComboCode:"|"+gntGubunCdList[1]} );
        $(window).smartresize(sheetResize); sheetInit();
        //sheet1.SetSheetHeight(sheet1.GetSheetHeight()-115);
    }

    function initEvent() {

        // 조회조건 입력 이벤트
        $('#searchUseYn').change(function() {
            doAction1("Search");
        });

        $("#searchGntNm").keyup(function(event) {
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
            $('#gntCd').val('');
            await saveGntCdMgr();
        });

        // 저장 버튼 클릭 이벤트
        $('#btnSave').on('click', saveGntCdMgr);

        // 근태신청-신청단위 라디오버튼 변경 이벤트
        $('input[type=radio][name=requestUseType]').change(function() {
            if(this.id === 'reqUseTypeCd_none') {
                // 근태신청 사용하지 않는 경우, 근태신청 세부 설정 값 초기화 및 비활성화 처리
                $('#reqDetailDiv input[type="text"]').val('');
                $('#reqDetailDiv input[type="radio"]').not('[name="requestUseType"]').prop('checked', false);
                $('#reqDetailDiv input[type="checkbox"]').prop('checked', false);
                $('#reqDetailDiv select').prop('selectedIndex', 0);
            } else {
                // 공통코드(T10006)의 비고 값으로 신청가능일수, 휴가적용시간 default 값 세팅
                const idx = replaceAll(this.id, 'reqUseTypeCd_', '');
                $('#baseCnt').val(reqUseTypeList[idx].note1);
                $('#maxCnt').val(reqUseTypeList[idx].note2);
                $('#stdApplyHour').val(reqUseTypeList[idx].note3);
            }
            setEditable('requestUseType');
        });

        $('#baseCnt').keyup(function(){
            if($(this).val() != '' && $('#maxCnt').val() != ''){
                if($(this).val()*1 > $('#maxCnt').val()*1){
                    alert('최소값이 최대값 보다 클 수 없습니다.');
                }
            }
        });
        $('#maxCnt').keyup(function(){
            if($('#baseCnt').val() != '' && $(this).val() != ''){
                if($('#baseCnt').val()*1 > $(this).val()*1){
                    alert('최소값이 최대값 보다 클 수 없습니다.');
                }
            }
        });

        // 근태신청 세부설정 - 발생근태사용 체크박스 변경 이벤트
        $('#vacationYn').change(function() {
            setEditable('vacationYn');
        });

        // 근태신청 세부설정 - 일수 및 시간 입력 항목 숫자만 입력 가능하도록
        $("#baseCnt, #maxCnt").on("keyup", function(event) {
            makeNumber(this,'C'); // 소수점 허용
        });
        $("#stdApplyHour, #divCnt").on("keyup", function(event) {
            makeNumber(this,'A'); // 숫자만 허용
        });

        // form 의 모든 입력 요소의 값이 변경된 경우
        $('form :input').on('change keyup paste', function() {
            editYn = true;
        });
    }

    function isValidSaveGntCd() {
        let isValid = true;

        $("#gntCdForm span.req").each((idx, el) => {
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
     * 근태 코드 정보 저장
     */
    async function saveGntCdMgr() {
        try {
            progressBar(true);

            // 대표코드설정 중복 체크
            const gntGubunCd = $('#gntGubunCd').val();
            const gntCd = $('#gntCd').val();
            if (!gntGubunCd) {
                alert("대표코드를 선택해주세요.");
                return;
            }

            if (!isValidSaveGntCd()) {
                return;
            }

            if($('#basicGntCdYn').prop('checked')) {
                const dupChk = await fetch("/WtmGntCdMgr.do?cmd=getWtmGntCdMgrDupCnt", {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: new URLSearchParams({ gntGubunCd, gntCd }).toString()
                });

                const dupData = await dupChk.json();
                if (dupData.DATA.cnt > 0) {
                    alert("이미 대표코드로 설정된 근태코드가 있습니다.");
                    return;
                }
            }

            // 저장 처리
            const response = await fetch("/WtmGntCdMgr.do?cmd=saveWtmGntCdMgr", {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: $("#gntCdForm").serialize()
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
     * gntCdForm 의 모든 입력 요소 clear
     */
    function clearForm() {
        $('#gntCdForm input').not('[type=radio]').not("[type=checkbox]").val('');

        // text input 초기화
        $('#gntCdForm input[type="text"]').val('');

        // radio 버튼 초기화
        $('#gntCdForm input[type="radio"]').prop('checked', false);

        // checkbox 초기화
        $('#gntCdForm input[type="checkbox"]').prop('checked', false);

        // select 초기화
        $('#gntCdForm select').prop('selectedIndex', 0);

        // 마이너스 허용 체크박스 초기화
        $('#minusAllowYn').prop('checked', false)  // 체크 해제
            .prop('readonly', true); // 비활성화
    }

    /**
     * Sheet 내용을 Form에 입력
     */
    function sheetToForm(Row) {
        gPRow = Row;

        $('#gntCd').val(sheet1.GetCellValue(Row, 'gntCd'));
        $('#seq').val(sheet1.GetCellValue(Row, 'seq'));
        $('#gntGubunCd').val(sheet1.GetCellValue(Row, 'gntGubunCd'));
        $('#gntShortNm').val(sheet1.GetCellValue(Row, 'gntShortNm'));
        $('#gntNm').val(sheet1.GetCellValue(Row, 'gntNm'));
        $('#memo').val(sheet1.GetCellValue(Row, 'memo'));
        $('#baseCnt').val(sheet1.GetCellValue(Row, 'baseCnt'));
        $('#maxCnt').val(sheet1.GetCellValue(Row, 'maxCnt'));
        $('#stdApplyHour').val(sheet1.GetCellValue(Row, 'stdApplyHour'));
        $('#orgLevelCd').val(sheet1.GetCellValue(Row, 'orgLevelCd'));
        $('#excpSearchSeq').val(sheet1.GetCellValue(Row, 'excpSearchSeq'));
        $('#searchDesc').val(sheet1.GetCellValue(Row, 'searchDesc'));
        $('#divCnt').val(sheet1.GetCellValue(Row, 'divCnt'));


        const useYn = sheet1.GetCellValue(Row, 'useYn');
        $('input[type="radio"][name="useYn"][value="'+useYn+'"]').prop('checked', true);

        const basicGntCdYn = sheet1.GetCellValue(Row, 'basicGntCdYn');
        $('#basicGntCdYn').prop('checked', basicGntCdYn === 'Y');

        const color = sheet1.GetCellValue(Row, 'color');
        $('input[type="radio"][name="color"][value="'+color+'"]').prop('checked', true);

        const noPayYn = sheet1.GetCellValue(Row, 'noPayYn');
        $('#noPayYn').prop('checked', noPayYn === 'Y');

        const requestUseType = sheet1.GetCellValue(Row, 'requestUseType');
        $('input[type="radio"][name="requestUseType"][value="'+requestUseType+'"]').prop('checked', true);

        const holInclYn = sheet1.GetCellValue(Row, 'holInclYn');
        $('input[type="radio"][name="holInclYn"][value="'+holInclYn+'"]').prop('checked', true);

        const vacationYn = sheet1.GetCellValue(Row, 'vacationYn');
        $('#vacationYn').prop('checked', vacationYn === 'Y');

        const minusAllowYn = sheet1.GetCellValue(Row, 'minusAllowYn');
        $('#minusAllowYn').prop('checked', minusAllowYn === 'Y');

        setEditable('requestUseType');
        setEditable('vacationYn');
    }

    /**
     * Form 근태신청 세부설정 입력 항목 readOnly 처리
     */
    function setEditable(type) {

        if(type === 'requestUseType') {
            const id = $(`input[type="radio"][name="requestUseType"]:checked`).attr('id');
            if(id === undefined) return;

            if(id === 'reqUseTypeCd_none') {
                $('#reqDetailDiv :input, #reqDetailDiv select').prop('disabled', true)
                $('input[type=radio][name="requestUseType"]').prop('disabled', false);
            } else {
                // 근태신청 세부설정 모든 항목 활성화
                $('#reqDetailDiv :input, #reqDetailDiv select').prop('disabled', false)

                // 신청단위에 따른 입력 항목 비활성화 처리
                const idx = replaceAll(id, 'reqUseTypeCd_', '');
                const fixYn = reqUseTypeList[idx].note4.split('');
                const [baseCntFixYn, maxCntFixYn, stdApplyHourFixYn] = fixYn;
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

                if(stdApplyHourFixYn === 'Y') {
                    $('#stdApplyHour').addClass('readonly')
                    $('#stdApplyHour').attr('readonly', true)
                } else {
                    $('#stdApplyHour').removeClass('readonly')
                    $('#stdApplyHour').attr('readonly', false)
                }
            }
        } else if (type === 'vacationYn') {
            const isChecked = $('#vacationYn').prop('checked');

            if (!isChecked) {
                // vacationYn이 체크 해제되면
                $('#minusAllowYn').prop('checked', false)  // 체크 해제
                    .prop('readonly', true); // 비활성화
            } else {
                // vacationYn이 체크되면
                $('#minusAllowYn').prop('readonly', false); // 활성화
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
                sheet1.DoSearch( "${ctx}/WtmGntCdMgr.do?cmd=getWtmGntCdMgrList",$("#gntCdForm").serialize() );
                break;
            case "SaveSeq":
                IBS_SaveName(document.gntCdForm,sheet1);
                sheet1.DoSave( "${ctx}/WtmGntCdMgr.do?cmd=saveWtmGntCdSeq", $("#gntCdForm").serialize());
                break;
            case "Delete":
                IBS_SaveName(document.gntCdForm,sheet1);
                sheet1.DoSave( "${ctx}/WtmGntCdMgr.do?cmd=deleteWtmGntCdMgr", $("#gntCdForm").serialize());
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
<form id="gntCdForm" name="gntCdForm">
    <input id="gntCd" name ="gntCd" type="hidden" class="text readonly"/>
    <input id="seq" name="seq" type="hidden" class="text readonly"/>
    <div id="attCode" class="tab-content active">
        <div class="row flex-grow-1">
            <div class="col-4 att-con-wrap wrapper">
                <!-- 검색창 -->
                <div class="search_input outer">
                    <input id="searchGntNm" name="searchGntNm" class="form-input" type="text" placeholder="검색" />
                    <a href="javascript:doAction1('Search')" class="btn-search"><i class="mdi-ico">search</i></a>
                </div>
                <div class="inner">
                    <!-- 타이틀 -->
                    <div class="title-wrap sheet_title inner-wrap">
                        <span class="page-title">근태목록</span>
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
                            <th>
                                <span class="req"></span>근태종류
                            </th>
                            <td>
                                <div class="input-wrap wid-50">
                                    <select id="gntGubunCd" name="gntGubunCd" class="custom_select"></select>
                                </div>
                                <div class="input-wrap">
                                    <div>
                                        <input type="checkbox" class="form-checkbox" id="basicGntCdYn" name="basicGntCdYn" value="Y"/>
                                         <label for="basicGntCdYn">대표코드 설정</label>
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
                                    <div class="radio-wrap">
                                        <input type="radio" name="useYn" id="useN" value="N" class="form-radio" />
                                        <label for="useN">사용안함</label>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th><span class="req"></span>근태명칭</th>
                            <td>
                                <div class="input-wrap wid-50">
                                    <input id="gntNm" name="gntNm" class="form-input" type="text" />
                                </div>
                            </td>
                            <th><span class="req"></span>약어</th>
                            <td>
                                <div class="input-wrap wid-50">
                                    <input id="gntShortNm" name="gntShortNm" class="form-input" type="text" maxlength="4" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th>색상</th>
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
                            <th>무급여부</th>
                            <td colspan="3">
                                <div class="input-wrap">
                                    <input type="checkbox" class="form-checkbox" id="noPayYn" name="noPayYn" value="Y"/>
                                    <label for="noPayYn">무급여부</label>
                                </div>
                                <p class="desc mt-1">근태집계 시 무급휴가에 포함되어 집계됩니다.</p>
                            </td>
                        </tr>
                        <tr>
                            <th>메모</th>
                            <td colspan="3">
                                <div class="input-wrap wid-50">
                                    <input id="memo" name="memo" class="form-input" type="text" />
                                </div>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
    
                <!--  -->
                <h2 class="title-wrap mt-12">
                    <div class="inner-wrap">
                        <span class="page-title">근태신청 세부설정</span>
                    </div>
                </h2>
                <div id="reqDetailDiv" class="table-wrap" style="height: calc(100vh - 360px); overflow-y: auto;">
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
                            <th>휴일포함여부</th>
                            <td>
                                <div class="input-wrap">
                                    <div class="radio-wrap">
                                        <input type="radio" name="holInclYn" id="holInclY" class="form-radio" value="Y">
                                        <label for="holInclY">휴일포함</label>
                                    </div>
                                    <div class="radio-wrap">
                                        <input type="radio" name="holInclYn" id="holInclN" class="form-radio" value="N">
                                        <label for="holInclN">안함</label>
                                    </div>
                                </div>
                                <p class="desc mt-2">휴일포함에 체크할 경우 근태신청 시 적용일수에 휴일을 포함하여 계산합니다.</p>
                            </td>
                        </tr>
                        <tr>
                            <th>휴가적용시간</th>
                            <td colspan="3">
                                <div class="input-wrap px-2" style="width: 80px;"><input id="stdApplyHour" name="stdApplyHour" class="form-input" type="text" /></div>시간
                                <p class="desc mt-2">신청 단위가 '시간'일 경우 근태신청 시 신청한 시간이 적용됩니다.</p>
                            </td>
                        </tr>

                        <tr>
                            <th>발생 근태사용</th>
                            <td>
                                <div class="input-wrap">
                                    <input type="checkbox" class="form-checkbox" id="vacationYn" name="vacationYn" value="Y"/>
                                    <label for="vacationYn">적용</label>
                                </div>
                                <p class="desc mt-1">담당자가 생성한 근태에 대해서만 신청 가능합니다.</p>
                            </td>
                            <th>마이너스 허용</th>
                            <td>
                                <div class="input-wrap">
                                    <input type="checkbox" class="form-checkbox" id="minusAllowYn" name="minusAllowYn" value="Y"/>
                                    <label for="minusAllowYn">적용</label>
                                </div>
                                <p class="desc mt-1">사용가능일수가 0이어도 근태신청 가능합니다.</p>
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
                        <tr>
                            <th>분할신청</th>
                            <td><div class="input-wrap px-2" style="width: 80px;"><input id="divCnt" name="divCnt" class="form-input" type="text" /></div>회</td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </div>
</form>
</body>
</html>