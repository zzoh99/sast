$(document).ready(function() {
    initTypeList(selectedWorkClassCd);
    initCommonCodeLists();
    initEvent();

    if (selectedWorkClassCd !== 'undefined') {
        setData(selectedWorkClassCd);
    } else {
        initNewWorkClass();
    }

});

function initEvent() {
    $('#deleteBtn').off().on('click', function (e) {
        e.preventDefault();
        const $activeLi = $('.type-list li.active');
        const workClassNm = $activeLi.text().replace('work', '').trim();
        const deletedId = $activeLi.data('id');

        const confirmDelete = confirm("'" + workClassNm +"'을(를) 삭제 하시겠습니까?");
        if (confirmDelete) {
            if (deletedId !== undefined || deletedId !== '') {
                ajaxCall("/WtmWorkTypeMgr.do?cmd=deleteWtmWorkClassMgr", "workClassCd=" + deletedId, false);
            }

            let newActiveClassCd = "";
            const $nextLi = $activeLi.next('li');
            if ($nextLi.length > 0) {
                newActiveClassCd = $nextLi.data('id');
            } else {
                const $prevLi = $activeLi.prev('li');
                if ($prevLi.length > 0) {
                    newActiveClassCd = $prevLi.data('id');
                }
            }

            initTypeList(newActiveClassCd);
            setData(newActiveClassCd);
            clickTab("01");
        }
    });

    $('#breakTypeBtn').on('change', 'input[type=radio]', function() {
        const breakType = $(this).val();
        changeBreakTypeSheet(breakType);
    });

    $('.deleteBreakTimeDetBtn').click(function(e) {
        $(this).closest('.breakTimeDet').remove();
    });

    $('#addBreakTimeDetBtn').off('click').on('click', function(e) {
        e.preventDefault();
        drawBreakTimeDetDiv();
    });

    $("#addBtn").on('click', function (e) {
        if ($("#saveBtn").css("display") !== "none") {
            if (!confirm("저장되지 않은 데이터가 있습니다. 계속 하시겠습니까?")) {
                return;
            }
        }
        clickTab("01");
        $("#workTypeForm1")[0].reset();
        $("#workTypeForm2")[0].reset();
        $("#workScheduleForm")[0].reset();
        $("#workGroupForm")[0].reset();
        setWorkClassDefYnBtn("N");

        // 기본휴게시간 초기화
        $('.breakTimeDet').remove();
        $('#breakTypeBtn .btn').removeClass('active');
        $('#breakTypeBtn .btn input[value="A"]').closest('.btn').addClass('active');
        $('#breakTypeBtn .btn input[value="A"]').prop('checked', true);
        $('#breakTypeBtn').val('A');
        changeBreakTypeSheet('A');

        // 단위기간 시작기준 초기화
        $("#intervalBeginType").empty()

        initNewWorkClass();
    });

    $('.tab_menu').click(function() {
        const tabId = this.id.split('_')[1]
        clickTab(tabId);
    });

    $("#workClassNm").on('input', function() {
        $(".type-list li.active").html('<i class="mdi-ico">work</i>' +  $(this).val());
        $("#workClassNmTitle").html($(this).val());
    });

    $("#approvalBtn").on('click', async function () {

        if ($("#saveBtn").css("display") !== "none") {
            const confirmSave = confirm("대상자 설정 전에 근무제 저장이 필요합니다. 저장 후 작성하시겠습니까?");
            if (!confirmSave) {
                return;
            }
            await saveWtmWorkClassMgr();
        }

        const p = {
            workClassCd: getWorkClassCd(),
            applCd: $("#applCd").val()
        };

        let layerModal = new window.top.document.LayerModal({
            id : 'wtmWorkClassApprLayer' //식별자ID
            , url : '/WtmWorkTypeMgr.do?cmd=viewWtmWorkClassApprLayer' //팝업에 띄울 화면 jsp
            , parameters : p
            , width : 500
            , height : 620
            , title : '근무스케줄 신청 설정'
            , trigger :[ //콜백
                {
                    name : 'wtmWorkClassApprLayerTrigger'
                    , callback : function(result){
                        $("#applCd").val(result.applCd);
                    }
                }
            ]
        });
        layerModal.show();
    });

    $("#toList").on('click', function (){
        if ($("#saveBtn").css("display") !== "none") {
            if (!confirm("저장되지 않은 데이터가 있습니다. 계속 하시겠습니까?")) {
                return;
            }
        }
        window.location.href = '/WtmWorkTypeMgr.do?cmd=viewWtmWorkTypeMgr';
    });

    $("#setEmpBtn").on('click', async function () {
        try {
            if ($("#saveBtn").css("display") !== "none") {
                const confirmSave = confirm("대상자 설정 전에 근무제 저장이 필요합니다. 저장 후 작성하시겠습니까?");
                if (!confirmSave) {
                    return;
                }
                await saveWtmWorkClassMgr();
            }

            const p = {
                workClassCd : getWorkClassCd()
            }
            let layerModal = new window.top.document.LayerModal({
                id : 'wtmWorkClassTargetLayer' //식별자ID
                , url : '/WtmWorkTypeMgr.do?cmd=viewWtmWorkClassTargetLayer' //팝업에 띄울 화면 jsp
                , parameters : p
                , width : 1000
                , height : 720
                , title : '대상자 설정'
                , trigger :[ //콜백
                    {
                        name : 'wtmWorkClassTargetLayerTrigger'
                        , callback : function(result){
                        }
                    }
                ]
            });
            layerModal.show();
        } catch (error) {
        } finally {
        }
    });

    // 기본설정 탭 - 시간 기간 입력 항목 HH:MM 형식으로 입력 가능하도록
    $("#workTimeF, #workTimeT, #coreTimeF, #coreTimeT, #startWorkTimeF, #startWorkTimeT").mask('11:11');
    $(".breakTime").mask('11:11');

    // 기본설정 탭 - 시간 입력 항목 숫자만 입력 가능하도록
    $("#workHours, #otBreakTimeT, #otBreakTimeR")
        .on("keyup", function(event) {
        makeNumber(this,'A'); // 숫자만 허용
    });

    // 근무시간기준 탭 - 시간 입력 항목 숫자만 입력 가능하도록
    $("#dayWkLmt, #dayOtLmt, #weekWkLmt, #weekOtLmt, #avgWeekWkLmt, #avgWeekOtLmt").on("keyup", function(event) {
        makeNumber(this,'A'); // 숫자만 허용
    });

    // 출퇴근 설정 탭 - 시간 기간 입력 항목 HH:MM 형식으로 입력 가능하도록
    $("#deemedTimeF, #deemedTimeT").mask('11:11');

    // 근무시간기준 탭 - 단위기간 변경 이벤트
    $('#intervalCd').on("change", function () {
        const intervalType = $("#intervalCd option:selected").attr("note2");
        const intervalBeginTypes = convCode( codeList("/CommonCode.do?cmd=getCommonCodeList&note1="+intervalType,"T90210"), "");
        if (intervalType !== '' && intervalBeginTypes !== undefined) {
            $("#intervalBeginType").empty().append(intervalBeginTypes[2]);
        }
    })
}

function getWorkClassCd() {
    const $activeLi = $('.type-list li.active');
    return $activeLi.data('id');
}

function clickTab(tabId) {
    // 모든 탭과 콘텐츠에서 active 클래스 제거
    $('.tab_menu').removeClass('active');
    $('.typSetting-content').removeClass('active');

    // 클릭된 탭과 해당하는 콘텐츠에 active 클래스 추가
    $('#tab_' + tabId).addClass('active');
    const contentId = '#content_' + tabId;
    $(contentId).addClass('active');
}

function drawBreakTimeDetDiv() {
    const newBreakTimeDet = '<div class="breakTimeDet">' +
        '<div class="input-wrap pr-2" style="width: 70px;"><input class="form-input breakTime" type="text"></div> - ' +
        '<div class="input-wrap pr-2" style="width: 70px;"><input class="form-input breakTime" type="text"></div>' +
        '<button type="button" class="btn outline_gray ml-5 deleteBreakTimeDetBtn">삭제</button>' +
        '</div>';

    $('#breakTimeDetDiv').append(newBreakTimeDet);
    if ($('#addBreakTimeDetBtn').length === 0) {
        const addButton = '<button type="button" class="btn outline btn-add ml-2" id="addBreakTimeDetBtn">추가</button>';
        $('#breakTimeDetDiv:last').append(addButton);
    } else {
        $('#addBreakTimeDetBtn').detach().appendTo('#breakTimeDetDiv:last');
        $('#addBreakTimeDetBtn').off('click').on('click', function(e) {
            e.preventDefault();
            drawBreakTimeDetDiv();
        });
    }

    $('#breakTimeDetDiv').on('click', '.deleteBreakTimeDetBtn', function() {
        $(this).closest('.breakTimeDet').remove();
    });

    $(".breakTime").mask('11:11');
}

function changeBreakTypeSheet(breakType) {
    switch(breakType) {
        case 'A':
            $("#breakTimeTRDiv").hide();
            $("#breakTimeDetDiv").show();
            break;
        case 'B':
            $("#breakTimeTRDiv").show();
            $("#breakTimeDetDiv").hide();
            break;
        case 'C':
            $("#breakTimeTRDiv").hide();
            $("#breakTimeDetDiv").hide();
            break;
        default:
            console.log('Unknown work type selected');
    }
}

function initTypeList(selectedWorkClassCd) {
    const workClassCdList = ajaxCall("/WtmWorkTypeMgr.do?cmd=getWtmWorkClassCdList", "", false).DATA;
    let workClassHtmlItem = "";
    workClassCdList.forEach(function (workClass) {
        let activeClass = "";
        if (workClass.workClassCd === selectedWorkClassCd) {
            activeClass = "active";
        }
        workClassHtmlItem += '<li class="' + activeClass + '" data-id="' + workClass.workClassCd +'"><i class="mdi-ico">work</i>' + workClass.workClassNm + '</li>';
    });
    $(".type-list").empty().append(workClassHtmlItem);

    const $typeListLi = $(".type-list li");
    $("#workClassCnt").html($typeListLi.length + "개");

    //근무유형 tab
    $('.type-list li').off().click(function(){
        if (!$(this).hasClass('active')) {
            if ($("#saveBtn").css("display") !== "none") {
                const noDataIdTypeCnt = $(".type-list li:not([data-id])").length; // 신규 입력 후 저장되지 않은 근무유형 갯수
                if (noDataIdTypeCnt > 0) {
                    if (!confirm("저장하지 않은 근무유형의 경우 삭제될 수 있습니다. 계속 하시겠습니까?")) {
                        return;
                    }

                    $(".type-list li:not([data-id])").remove();
                } else {
                    if (!confirm("저장되지 않은 데이터가 있습니다. 계속 하시겠습니까?")) {
                        return;
                    }
                }
            }
            const dataId = $(this).data('id');
            if (dataId !== undefined) {
                setData(dataId);
            }
            clickTab("01");
        }
        $('.type-list li').removeClass('active');
        $(this).addClass('active');
    });
}

function initCommonCodeLists() {
    const workTypeList = codeList("/CommonCode.do?cmd=getCommonCodeList", "T10002");
    let workTypeHtml = "";
    workTypeList.forEach(function (workType) {
        workTypeHtml += '<div class="radio-wrap"><input type="radio" name="workTypeCd" id="workTypeCd-' + workType.code + '" value="' + workType.code + '" class="form-radio">' +
                        '<label for="workTypeCd-' + workType.code + '">' + workType.codeNm + '</label></div>'
    });
    $("#workTypeRadio").append(workTypeHtml);


    const intervalCds = convCodeCols(ajaxCall("/CommonCode.do?cmd=getCommonCodeLists","grpCd=T90200",false).codeList, "note1,note2", "");
    if (intervalCds !== undefined) {
        $("#intervalCd").append(intervalCds[2]);
    }

    const workEnableRanges = convCode( codeList("/CommonCode.do?cmd=getCommonCodeList","WT0211"), "");
    if (workEnableRanges !== undefined) {
        $("#workEnableRange").append(workEnableRanges[2]);
    }

    $('#workTypeRadio').on('change', 'input[type=radio]', function() {
        const selectedValue = $(this).val();
        changeWorkTypeSheet(selectedValue);
    });
}

function changeWorkTypeSheet(workTypeCd) {
    switch(workTypeCd) {
        case 'R':
            initRegularWorkingSheet();
            break;
        case 'B':
            initFlexibleWorkingHoursSheet();
            break;
        case 'C':
            initFlexibleWorkScheduleSheet();
            break;
        case 'A':
            initAlternativeWorkScheduleSheet();
            break;
        case 'D':
            initShiftWorkScheduleSheet();
            break;
        default:
            console.log('Unknown work type selected');
    }
}

function initNewWorkClass() {
    toggleDatePicker("class", true);
    $("#classSdate").val("1900-01-01");
    $("#classEdate").val("2999-12-31");

    $('#updateBtn').hide();
    $('#saveBtn').show();
    $('#addBreakTimeDetBtn').show();
    $('.deleteBreakTimeDetBtn').show();
    $('.shift-btns').show();
    $('#workClassCd').val(null);

    $('#breakTimeTd input[type="text"]').prop('disabled', false);
    $('#breakTypeBtn input[type="radio"]').prop('disabled', false);
    $('#breakTypeBtn label').css({
        'pointer-events': 'auto',
        'opacity': '1'
    });

    $('#breakTypeBtn .btn input[value="A"]').closest('.btn').addClass('active');
    $('#breakTypeBtn .btn input[value="A"]').prop('checked', true);

    $(':disabled').prop('disabled', false);

    const initTitle = "새로운 근무유형";
    $(".type-list li").removeClass("active");
    const workClassHtmlItem = '<li class="active"><i class="mdi-ico">work</i>' + initTitle + '</li>';
    $(".type-list").append(workClassHtmlItem);
    $("#workClassNm").val(initTitle);
    $("#workClassNmTitle").html(initTitle);

    const $typeListLi = $(".type-list li");
    $("#workClassCnt").html($typeListLi.length + "개");

    $('#workTypeRadio input[value="R"]').prop('checked', true);
    $('#workTypeRadio input[type="radio"]').off('click');

    initRegularWorkingSheet();
    initSaveBtnEvent();
}

function initSaveBtnEvent() {
    $('#saveBtn').off('click').on('click', async function(e) {
        e.preventDefault();
        await saveWtmWorkClassMgr();
    });
}

async function saveWtmWorkClassMgr() {
    try {
        progressBar(true, '저장중입니다.');
        let selectedDays = [];

        // 기본휴게시간 선택한 타입의 값만 남기고 초기화
        const breakType = $("input[name='breakTimeType']:checked").val();
        if (breakType === 'A') { // 지정휴게
            $("#breakTimeT").val('');
            $("#breakTimeR").val('');
        } else if (breakType === 'B') { // 근무시간 기준
            $('.breakTimeDet').remove();
        } else if (breakType === 'C') {
            $('.breakTimeDet').remove();
            $("#breakTimeT").val('');
            $("#breakTimeR").val('');
        }

        let breakTimes = [];
        $('.breakTimeDet').each(function() {
            const inputs = $(this).find('input[type="text"]');
            if (inputs.length == 2) {
                const start = inputs.eq(0).val();
                const end = inputs.eq(1).val();
                breakTimes.push(start + '-' + end);
            }
        });
        $('#breakTimeDet').val(breakTimes.join(','));

        //근무일
        $('.workDay').each(function() {
            if ($(this).is(":checked")) {
                selectedDays.push($(this).val());
            }
        });
        $('#workDays').val(selectedDays.join(','));

        //주휴일
        let selectedRestDays = [];
        $('.weekRestDay').each(function() {
            if ($(this).is(":checked")) {
                selectedRestDays.push($(this).val());
            }
        });
        $('#weekRestDays').val(selectedRestDays.join(','));

        // 각 체크박스에 대해 반복
        $('#workTypeForm2').find('input[type="checkbox"]').not('.weekRestDay, .workDay').each(function() {
            if ($(this).is(':checked')) {
                $(this).val('Y');
            } else {
                if($(this).attr('id') != 'holInclYn' && $(this).attr('id') != 'realBreakTimeYn'){
                    $(this).prop('checked', true).val('N').attr('name', $(this).attr('name'));
                }
            }
        });

        // form 안의 display: none 스타일이 적용된 input 요소들을 찾습니다.
        $(this).find('input, select, textarea').each(function() {
            if ($(this).css('display') === 'none') {
                $(this).val(null);
            }
        });

        const formData1 = $("#workTypeForm1").serialize();
        const formData2 = $("#workTypeForm2").serialize();

        // 저장 처리
        const response = await fetch("/WtmWorkTypeMgr.do?cmd=saveWtmWorkClassMgr", {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: formData1 + '&' + formData2
        });

        const result = await response.json();
        if (result.DATA.Code > 0) {
            initTypeList(result.DATA.workClassCd);
            setData(result.DATA.workClassCd);
            if (result.Message) {
                alert(result.Message);
            }
        }
    } catch (error) {
        console.error('저장 중 오류 발생:', error);
        alert('저장 중 오류가 발생했습니다.');
    } finally {
        progressBar(false);
    }
}

//기본근무
function initRegularWorkingSheet() {
    const hideElements = [
        "#tab_04", "#coreTimeTh", "#coreTimeTd",
        "#startWorkTimeTh","#startWorkTimeTd",
        "#applSetTh", "#applSetTd",
        "#intervalCdTh", "#intervalCdTd",
        "#intervalBeginTypeTh", "#intervalBeginTypeTd",
        "#avgWeekWkLmtTh", "#avgWeekWkLmtTd",
        "#avgWeekOtLmtTh", "#avgWeekOtLmtTd",
        "#deemedTimeTh", "#deemedTimeTd"
    ];
    hideElements.forEach(selector => $(selector).hide());

    const showElements = [
        "#tab_03", "#workDayTh", "#workDayTd",
        "#workHoursTh", "#workHoursTd",
        "#breakTimeTh", "#breakTimeTd",
        "#workTimeTh", "#workTimeTd",
        "#dayWkLmtTh", "#dayWkLmtTd",
        "#dayOtLmtTh", "#dayOtLmtTd",
        "#weekWkLmtTh", "#weekWkLmtTd",
        "#weekOtLmtTh", "#weekOtLmtTd",
    ];
    showElements.forEach(selector => $(selector).show());
}

//탄력근무제
function initFlexibleWorkScheduleSheet() {
    const hideElements = [
        "#tab_04",
        "#workTimeTh", "#workTimeTd", "#coreTimeTh",
        "#coreTimeTd", "#startWorkTimeTh", "#startWorkTimeTd",
        "#deemedTimeTh", "#deemedTimeTd",
    ];
    hideElements.forEach(selector => $(selector).hide());

    const showElements = [
        "#tab_03", "#workDayTh", "#workDayTd",
        "#workHoursTh", "#workHoursTd",
        "#applSetTh", "#applSetTd",
        "#breakTimeTh", "#breakTimeTd",
        "#intervalCdTh", "#intervalCdTd",
        "#intervalBeginTypeTh", "#intervalBeginTypeTd",
        "#dayWkLmtTh", "#dayWkLmtTd",
        "#dayOtLmtTh", "#dayOtLmtTd",
        "#weekWkLmtTh", "#weekWkLmtTd",
        "#weekOtLmtTh", "#weekOtLmtTd",
        "#avgWeekWkLmtTh", "#avgWeekWkLmtTd",
        "#avgWeekOtLmtTh", "#avgWeekOtLmtTd",
    ];
    showElements.forEach(selector => $(selector).show());
}

//시차출퇴근
function initFlexibleWorkingHoursSheet() {
    const hideElements = [
        "#tab_04", "#workTimeTh", "#workTimeTd",
        "#coreTimeTh","#coreTimeTd",
        "#intervalCdTh", "#intervalCdTd",
        "#intervalBeginTypeTh", "#intervalBeginTypeTd",
        "#avgWeekWkLmtTh", "#avgWeekWkLmtTd",
        "#avgWeekOtLmtTh", "#avgWeekOtLmtTd",
    ];
    hideElements.forEach(selector => $(selector).hide());

    const showElements = [
        "#tab_03", "#workDayTh", "#workDayTd",
        "#workHoursTh", "#workHoursTd",
        "#startWorkTimeTh", "#startWorkTimeTd",
        "#applSetTh", "#applSetTd",
        "#breakTimeTh", "#breakTimeTd",
        "#dayWkLmtTh", "#dayWkLmtTd",
        "#dayOtLmtTh", "#dayOtLmtTd",
        "#weekWkLmtTh", "#weekWkLmtTd",
        "#weekOtLmtTh", "#weekOtLmtTd",
        "#deemedTimeTh", "#deemedTimeTd",
    ];
    showElements.forEach(selector => $(selector).show());
}

//선택근무제
function initAlternativeWorkScheduleSheet() {
    const hideElements = [
        "#tab_04", "#tab_03",
        "#workTimeTh", "#workTimeTd",
        "#startWorkTimeTh", "#startWorkTimeTd",
        "#deemedTimeTh", "#deemedTimeTd",
    ];
    hideElements.forEach(selector => $(selector).hide());

    const showElements = [
        "#workDayTh", "#workDayTd",
        "#workHoursTh", "#workHoursTd",
        "#coreTimeTh", "#coreTimeTd",
        "#applSetTh", "#applSetTd",
        "#breakTimeTh", "#breakTimeTd",
        "#intervalCdTh", "#intervalCdTd",
        "#intervalBeginTypeTh", "#intervalBeginTypeTd",
        "#dayWkLmtTh", "#dayWkLmtTd",
        "#dayOtLmtTh", "#dayOtLmtTd",
        "#weekWkLmtTh", "#weekWkLmtTd",
        "#weekOtLmtTh", "#weekOtLmtTd",
        "#avgWeekWkLmtTh", "#avgWeekWkLmtTd",
        "#avgWeekOtLmtTh", "#avgWeekOtLmtTd",
    ];
    showElements.forEach(selector => $(selector).show());
}

//교대조
function initShiftWorkScheduleSheet() {
    const hideElements = [
        "#weekRestDayTh","#weekRestDayTd",
        "#workDayTh", "#workDayTd", "#workHoursTh", "#workHoursTd",
        "#workTimeTh", "#workTimeTd", "#coreTimeTh", "#coreTimeTd",
        "#startWorkTimeTh", "#startWorkTimeTd",
        "#applSetTh", "#applSetTd",
        "#breakTimeTh", "#breakTimeTd",
        "#intervalCdTh", "#intervalCdTd", "#intervalBeginTypeTh", "#intervalBeginTypeTd",
        "#avgWeekWkLmtTh", "#avgWeekWkLmtTd",
        "#avgWeekOtLmtTh", "#avgWeekOtLmtTd",
        "#deemedTimeTh", "#deemedTimeTd",
    ];
    hideElements.forEach(selector => $(selector).hide());

    const showElements = [
        "#tab_03", "#tab_04",
        "#dayWkLmtTh", "#dayWkLmtTd",
        "#dayOtLmtTh", "#dayOtLmtTd",
        "#weekWkLmtTh", "#weekWkLmtTd",
        "#weekOtLmtTh", "#weekOtLmtTd",
    ];
    showElements.forEach(selector => $(selector).show());
}

function setData(selectedWorkClassCd) {
    $("#workClassCd").val(selectedWorkClassCd);
    $('#saveBtn').hide();
    // 교대근무관리 탭 버튼 숨김
    $('.shift-btns').hide();
    $('#updateBtn').show().off('click')
        .on('click', function(e) {
            e.preventDefault();
            $('#updateBtn').hide();
            $('#saveBtn').show();
            $('#addBreakTimeDetBtn').show();
            $('.deleteBreakTimeDetBtn').show();
            $('.shift-btns').show();
            $('#workTypeForm1 :disabled').prop('disabled', false);
            $('#workTypeForm2 :disabled').prop('disabled', false);
            $('#breakTimeTd input[type="text"]').prop('disabled', false);
            $('#breakTypeBtn input[type="radio"]').prop('disabled', false);
            $('#breakTypeBtn label').css({
                'pointer-events': 'auto',
                'opacity': '1'
            });

            $('#workTypeRadio input[type="radio"]').off('click').on('click', function(event) {
                // event.preventDefault();
                alert("설정된 값이 초기화 됩니다.");
                clickTab("01");
                $("#workTypeForm1")[0].reset();
                $("#workTypeForm2")[0].reset();
                $("#workScheduleForm")[0].reset();
                $("#workGroupForm")[0].reset();
                setWorkClassDefYnBtn("N");

                // 기본휴게시간 초기화
                $('.breakTimeDet').remove();
                $('#breakTypeBtn .btn').removeClass('active');
                $('#breakTypeBtn .btn input[value="A"]').closest('.btn').addClass('active');
                $('#breakTypeBtn .btn input[value="A"]').prop('checked', true);
                $('#breakTypeBtn').val('A');
                changeBreakTypeSheet('A');

                // 단위기간 시작기준 초기화
                $("#intervalBeginType").empty()

                initNewWorkClass();
            });

            const sdate = $("#classSdate").val();
            const edate = $("#classEdate").val();
            toggleDatePicker("class", true);
            $("#classSdate").val(sdate);
            $("#classEdate").val(edate);
            initSaveBtnEvent();
        });

    const workClass = ajaxCall("/WtmWorkTypeMgr.do?cmd=getWtmWorkClassMgrList", "workClassCd=" + selectedWorkClassCd, false).DATA[0];
    changeWorkTypeSheet(workClass.workTypeCd);

    //기본근무유형설정
    setWorkClassDefYnBtn(workClass.workClassDefYn);
/*
    const $workClassDefYn = $("#workClassDefYn");
    const checkIcon = '<i class="mdi-ico filled">check</i>기본 근무제';
    if (workClass.workClassDefYn === 'Y') {
        $workClassDefYn.removeClass('outline_blue')
            .addClass('filled')
            .css('pointer-events', 'none')
            .html(checkIcon);
    } else {
        $("#workClassDefYn").removeClass('filled').addClass('outline_blue')
            .css('pointer-events', 'auto').html("기본 근무제 설정");
    }

    $workClassDefYn.off('click').on('click', async function (e) {
        e.preventDefault();
        try {
            progressBar(true, '저장중입니다.');

            // 저장 처리
            const response = await fetch("/WtmWorkTypeMgr.do?cmd=saveWorkClassDefYn", {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: "workClassCd=" + selectedWorkClassCd
            });

            const result = await response.json();
            if (result.Code > 0) {
                $workClassDefYn.removeClass('outline_blue')
                    .addClass('filled')
                    .css('pointer-events', 'none')
                    .html(checkIcon);
            }
        } catch (error) {
            console.error('저장 중 오류 발생:', error);
            alert('저장 중 오류가 발생했습니다.');
        } finally {
            progressBar(false);
        }
    });
 */

    //근무유형명
    $("#workClassNm").val(workClass.workClassNm).prop('disabled', true);
    $("#workClassNmTitle").html(workClass.workClassNm);
    $('#workTypeRadio input[type="radio"][value="' + workClass.workTypeCd + '"]')
        .prop('checked', true);
    toggleDatePicker("class", false);
    $('#classSdate').val(workClass.sdate).prop('disabled', true);
    $('#classEdate').val(workClass.edate).prop('disabled', true);
    $('#workTypeRadio input[type="radio"]').prop('disabled', true);

    //근무일
    const workDays = workClass.workDay.split(",");
    $('.workDay').each(function() {
        $(this).prop('checked', workDays.includes($(this).val())).prop('disabled', true);
    });

    //주휴일
    const weekRestDays = workClass.weekRestDay.split(",");
    $('.weekRestDay').each(function() {
        $(this).prop('checked', weekRestDays.includes($(this).val())).prop('disabled', true);
    });

    //시작요일
    $("#weekBeginDay").val(workClass.weekBeginDay).prop('disabled', true);

    //근무시간
    $("#workHours").val(workClass.workHours).prop('disabled', true);

    //출퇴근시간
    $("#workTimeF").val(workClass.workTimeF).prop('disabled', true);
    $("#workTimeT").val(workClass.workTimeT).prop('disabled', true);

    //코어타임시간
    $("#coreTimeF").val(workClass.coreTimeF).prop('disabled', true);
    $("#coreTimeT").val(workClass.coreTimeT).prop('disabled', true);

    //당일근무변경
    $('#sameDayChgYn').prop('checked', workClass.sameDayChgYn === "Y").prop('disabled', true);

    //출근가능시간
    $("#startWorkTimeF").val(workClass.startWorkTimeF).prop('disabled', true);
    $("#startWorkTimeT").val(workClass.startWorkTimeT).prop('disabled', true);

    //기본휴게시간
    changeBreakTypeSheet(workClass.breakTimeType);
    $('#breakTypeBtn .btn').removeClass('active');
    $('#breakTypeBtn .btn input[value="' + workClass.breakTimeType + '"]').closest('.btn').addClass('active');
    $('#breakTypeBtn .btn input[value="' + workClass.breakTimeType + '"]').prop('checked', true);
    $('#breakTimeTd input[type="text"]').prop('disabled', true);
    $('#breakTypeBtn input[type="radio"]').prop('disabled', true);
    $('#breakTypeBtn label').css({
        'pointer-events': 'none',
        'opacity': '0.6'  // 시각적으로 비활성화된 것처럼 보이게 함
    });
    $('#addBreakTimeDetBtn').hide();

    $('.breakTimeDet').remove();
    const timeRanges = workClass.breakTimeDet.split(',');
    timeRanges.forEach(range => {
        if(range !== '' && range != null) {
            const [startTime, endTime] = range.split('-');
            const newBreakTimeDet = $(
                '<div class="breakTimeDet">' +
                '<div class="input-wrap pr-2" style="width: 70px;">' +
                '<input class="form-input breakTime" type="text" value="' + startTime + '">' +
                '</div> - ' +
                '<div class="input-wrap px-2" style="width: 70px;">' +
                '<input class="form-input breakTime" type="text" value="' + endTime + '">' +
                '</div>' +
                '<button type="button" class="btn outline_gray ml-5 deleteBreakTimeDetBtn" style="display: none;">삭제</button>' +
                '</div>'
            );
            $(newBreakTimeDet).insertBefore('#addBreakTimeDetBtn');
        }
    });
    $("#breakTimeT").val(workClass.breakTimeT);
    $("#breakTimeR").val(workClass.breakTimeR);
    $(".breakTime").prop('disabled', true);

    //연장근무 휴게시간
    $("#otBreakTimeT").val(workClass.otBreakTimeT).prop('disabled', true);
    $("#otBreakTimeR").val(workClass.otBreakTimeR).prop('disabled', true);

    //단위기간
    $("#intervalCd").val(workClass.intervalCd).prop('disabled', true);
    $('#intervalCd').change();

    //단위기간 시작기준
    $("#intervalBeginType").val(workClass.intervalBeginType).prop('disabled', true);
    //일기본근로시간한도
    $("#dayWkLmt").val(workClass.dayWkLmt).prop('disabled', true);
    //일연장근로시간한도
    $("#dayOtLmt").val(workClass.dayOtLmt).prop('disabled', true);
    //주기본근로시간한도
    $("#weekWkLmt").val(workClass.weekWkLmt).prop('disabled', true);
    //주연장근로시간한도
    $("#weekOtLmt").val(workClass.weekOtLmt).prop('disabled', true);
    //주평균기본근로시간한도
    $("#avgWeekWkLmt").val(workClass.avgWeekWkLmt).prop('disabled', true);
    //주평균연장근무시간한도
    $("#avgWeekOtLmt").val(workClass.avgWeekOtLmt).prop('disabled', true);
    //휴일포함여부
    $('#holInclYn').prop('checked', workClass.holInclYn === "Y").prop('disabled', true);
    //실시간휴게관리사용여부
    $('#realBreakTimeYn').prop('checked', workClass.realBreakTimeYn === "Y").prop('disabled', true);
    //출근자동처리여부
    $('#autoWorkStartYn').prop('checked', workClass.autoWorkStartYn === "Y").prop('disabled', true);
    //퇴근자동처리여부
    $('#autoWorkEndYn').prop('checked', workClass.autoWorkEndYn === "Y").prop('disabled', true);
    //지각체크여부
    $('#lateUseYn').prop('checked', workClass.lateUseYn === "Y").prop('disabled', true);
    //조퇴체크여부
    $('#earlyLeaveUseYn').prop('checked', workClass.earlyLeaveUseYn === "Y").prop('disabled', true);
    //결근체크여부
    $('#absenceUseYn').prop('checked', workClass.absenceUseYn === "Y").prop('disabled', true);
    //간주근무시간 시작
    $("#deemedTimeF").val(workClass.deemedTimeF).prop('disabled', true);
    //간주근무시간 종료
    $("#deemedTimeT").val(workClass.deemedTimeT).prop('disabled', true);
    //기본근무선소진여부
    $('#baseWorkPreUseYn').prop('checked', workClass.baseWorkPreUseYn === "Y").prop('disabled', true);
    //근무계획미등록여부
    $('#noWorkPlanYn').prop('checked', workClass.noWorkPlanYn === "Y").prop('disabled', true);
    //사전출근여부
    $('#workBeginPreYn').prop('checked', workClass.workBeginPreYn === "Y").prop('disabled', true);
    //출퇴근가능시간범위
    $("#workEnableRange").val(workClass.workEnableRange).prop('disabled', true);
    //계획시간외연장생성
    $('#autoOtTimeYn').prop('checked', workClass.autoOtTimeYn === "Y").prop('disabled', true);
    //고정OT사용여부
    $('#fixOtUseYn').prop('checked', workClass.fixOtUseYn === "Y").prop('disabled', true);
    $('#applCd').val(workClass.applCd);
    $('#applUnit').val(workClass.applUnit);
    $('#applMinUnit').val(workClass.applMinUnit);
    $('#applMaxUnit').val(workClass.applMaxUnit);

    // 기본설정 탭 - 시간 기간 입력 항목 HH:MM 형식으로 입력 가능하도록
    $("#workTimeF, #workTimeT, #coreTimeF, #coreTimeT, #startWorkTimeF, #startWorkTimeT").mask('11:11');
    $(".breakTime").mask('11:11');

    // 출퇴근 설정 탭 - 시간 기간 입력 항목 HH:MM 형식으로 입력 가능하도록
    $("#deemedTimeF, #deemedTimeT").mask('11:11');
}

function toggleDatePicker(key, enableDatePicker) {
    if (enableDatePicker) {
        inputClassDates(key);
        const sdate = key + "Sdate";
        const edate = key + "Edate";
        setupDatepicker(sdate, edate, "startdate");
        setupDatepicker(edate, sdate, "enddate");
    } else {
        inputClassDates(key);
    }
}

// 공통 설정 함수
function setupDatepicker(selector, relatedSelector, optionKey) {
    $("#" + selector).datepicker2({
        [optionKey]: relatedSelector
    });
}

function inputClassDates(key) {
    const $dates = $("#" + key + "Dates");
    $dates.empty();
    const datesHtml = '<div class="input-wrap w-108"><input class="form-input" id="' + key + 'Sdate" name="sdate" type="text"></div><span class="text-center px-1">-</span>' +
        '<div class="input-wrap w-108"><input class="form-input" id="' + key + 'Edate" name="edate" type="text"></div>';

    $dates.append(datesHtml);
    $("#" + key + "Sdate").mask("1111.11.11") ;
    $("#" + key + "Edate").mask("1111.11.11") ;
}

function setWorkClassDefYnBtn(_workClassDefYn) {
    const $workClassDefYn = $("#workClassDefYn");
    if (_workClassDefYn === 'Y') {
        const checkIcon = '<i class="mdi-ico filled">check</i>기본 근무제';
        $workClassDefYn.removeClass('outline_blue')
            .addClass('filled')
            .css('pointer-events', 'none')
            .html(checkIcon);
    } else {
        $workClassDefYn.removeClass('filled').addClass('outline_blue')
            .css('pointer-events', 'auto').html("기본 근무제 설정");
    }

    $workClassDefYn.off('click').on('click', async function (e) {
        e.preventDefault();
        try {
            progressBar(true, '저장중입니다.');

            // 저장 처리
            const response = await fetch("/WtmWorkTypeMgr.do?cmd=saveWorkClassDefYn", {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: "workClassCd=" + selectedWorkClassCd
            });

            const result = await response.json();
            if (result.Code > 0) {
                const checkIcon = '<i class="mdi-ico filled">check</i>기본 근무제';
                $workClassDefYn.removeClass('outline_blue')
                    .addClass('filled')
                    .css('pointer-events', 'none')
                    .html(checkIcon);
            }
        } catch (error) {
            console.error('저장 중 오류 발생:', error);
            alert('저장 중 오류가 발생했습니다.');
        } finally {
            progressBar(false);
        }
    });
}