<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<script src="/assets/js/wtm/workType/wtmWorkClassDragDrop.js"></script>
<script type="text/javascript">
    $(document).ready(function () {
        $("#tab_04").on('click', function () {

            $('#workScheduleForm')[0].reset();
            $('#workGroupForm')[0].reset();

            const scheduleList = ajaxCall("/WtmWorkTypeMgr.do?cmd=getWorkScheduleList", "workClassCd=" + getWorkClassCd(), false).DATA;

            if (scheduleList.length > 0) {
                $('.setting-page').addClass('d-none');
                $('.setting-mng').removeClass('d-none');
                setScheduleList(scheduleList);
            } else {
                $('.setting-page').removeClass('d-none');
                $('.setting-mng').addClass('d-none');
                initNewSchedule();
            }

            $("#detailBtn").on('click', function () {
                const param = "&workClassCd=" + getWorkClassCd() + '&workGroupCd=' + getWorkGroupCd();
                window.location.href = '/WtmWorkTypeMgr.do?cmd=viewWtmWorkClassSchDetail' + param;
            });

            $("#schWorkTimeF, #schWorkTimeT, #schBreakTimeF, #schBreakTimeT").mask('11:11')

            $("#schSdate, #schEdate, #grpSdate").on('blur', checkDateRange)

            initSchEvent();
            initGroupEvent();
            initSchCardListEvent();

            //교대근무 관리 초기화
            $('#roundTab_01').trigger('click')

            setGroupCnt();
        });
    });

    function getWorkClassCd() {
        const $activeLi = $('.type-list li.active');
        return $activeLi.data('id');
    }

    function getWorkGroupCd() {
        const $activeLi = $('#groupCardList li.active');
        return $activeLi.data('id');
    }

    function setScheduleList(scheduleList) {
        console.log(scheduleList)
        const $schCardList = $('#schCardList');
        let schCardHtml = '';
        let workClassCd = scheduleList[0].workClassCd;
        let firstYn = true;
        for (let i = 0; i < scheduleList.length; i++) {
            const schedule = scheduleList[i];
            // 시스템 코드는 제외하고 출력
            if(schedule.systemCdYn !== 'Y') {
                schCardHtml += '<li class="work-card pointer ' + (firstYn ? 'active' : '') + '" data-id="' + schedule.workSchCd + '">' +
                    '<p class="card-name"><span class="att-code ' + schedule.color + '"></span>' + schedule.workSchNm + '</p>' +
                    '<p class="desc">' + formatTime(schedule.workTimeF) + ' - ' + formatTime(schedule.workTimeT) + '</p>' +
                    '</li>';

                if (firstYn) {
                    firstYn = false;
                    setSchData(schedule);
                }
            }
        }
        $schCardList.empty().append(schCardHtml);

        setGroupList(workClassCd);

        //event
        $('#schColorRadio input[type="radio"]').first()
            .prop('checked', true);

    }

    function setGroupList(workClassCd) {
        const groupList = ajaxCall("/WtmWorkTypeMgr.do?cmd=getWorkGroupList", "workClassCd=" + workClassCd, false).DATA;

        const $groupCardList = $('#groupCardList');
        $groupCardList.empty();
        if (!(groupList.length > 0)) {
            // $("#saveGroup").show();
        }

        let groupCardHtml = '';
        for (let i = 0; i < groupList.length; i++) {
            const group = groupList[i];
            const desc = (group.cnt > 0) ? group.cnt + "명" : "조원을 설정해주세요";
            groupCardHtml += '<li class="work-card pointer ' + (i === 0 ? 'active' : '') + '" data-id="' + group.workGroupCd + '">' +
                '<p class="card-name"><span class="att-code"></span>' + group.workGroupNm + '</p>' +
                '<p class="desc">' + desc + '</p>' +
                '</li>';

            if (i === 0) {
                setGroupData(group);
            }
        }
        $groupCardList.append(groupCardHtml);

        //event
        initGroupListEvent();

        $("#addGroup").off('click').on('click', function (e) {
            e.preventDefault();
            if ($("#saveGroup").css("display") !== "none") {
                alert("저장 또는 삭제 후 이동해주세요.");
                return;
            }
            initNewGroup();
        });
    }

    function initGroupListEvent() {
        $(document).off('click').on('click', '#groupCardList li', function() {
            if (!$(this).hasClass('active')) {
                if ($("#saveGroup").css("display") !== "none") {
                    alert("저장 또는 삭제 후 이동해주세요.");
                    return;
                }
                $('#groupCardList li').removeClass('active');
                $(this).addClass('active');

                const dataId = $(this).data('id');
                if (dataId !== undefined) {
                    $("#groupNmTitle").text($(this).find('.card-name').text());
                    const param = "workClassCd=" + getWorkClassCd() +
                        "&workGroupCd=" + dataId;
                    const group = ajaxCall("/WtmWorkTypeMgr.do?cmd=getWorkGroupList", param, false).DATA[0];
                    setGroupData(group);
                }
            }
        });
    }

    function initNewSchedule() {
        $("#workScheduleForm")[0].reset();
        $('.workSchedule-wrap :disabled').prop('disabled', false);
        $('#schColorRadio input[type="radio"]').first()
            .prop('checked', true);
        $("#updateSchedule").hide();
        $("#saveSchedule").show();

        const newTitle = "새로운 스케줄"
        $("#schNmTitle").html(newTitle);
        $("#workSchNm").val(newTitle);

        $('#schCardList li').removeClass('active');
        const schCardHtml = '<li class="work-card pointer active">' +
            '<p class="card-name"><span class="att-code blue"></span>' + newTitle + '</p>' +
            '<p class="desc">근무시간을 설정해주세요</p>' +
            '</li>';
        $('#schCardList').append(schCardHtml);

        $("#workSchCd").val(null);

        initSchCardListEvent();
        $("#schSdate").val($("#classSdate").val());
        $("#schEdate").val($("#classEdate").val());

        $("#grpSdate").datepicker2({
            startdate: "schEdate",
            enddate: "schSdate",
        });
        $("#schSdate").datepicker2();
        $("#schEdate").datepicker2();
    }

    function checkDateRange() {
        if($("#schSdate").val() !== '' && $("#classSdate").val().replace(/-/gi, "") > $("#schSdate").val().replace(/-/gi, "")) {
            alert('근무유형 적용기간을 벗어났습니다.');
            $("#schSdate").val('')
            return;
        }

        if($("#schSdate").val() !== '' && $("#classEdate").val().replace(/-/gi, "") < $("#schEdate").val().replace(/-/gi, "")) {
            alert('근무유형 적용기간을 벗어났습니다.');
            $("#schEdate").val('')
            return;
        }

        if($("#grpSdate").val() !== '' &&
            !($("#classSdate").val().replace(/-/gi, "") <= $("#grpSdate").val().replace(/-/gi, "") && $("#classEdate").val().replace(/-/gi, "") >= $("#grpSdate").val().replace(/-/gi, "")) ) {
            alert('근무유형 적용기간을 벗어났습니다.');
            $("#grpSdate").val('')
            return;
        }

    }

    function initNewGroup() {
        $("#workGroupForm")[0].reset();
        $('#workGroupForm :disabled').prop('disabled', false);
        $("#updateGroup").hide();
        $("#saveGroup").show();

        const newTitle = "새로운 근무조"
        $("#groupNmTitle").html(newTitle);
        $("#workGroupNm").val(newTitle);

        $('#grpSdate').siblings().remove();
        $('.grpDates').find('img').remove();
        $('#grpSdate').removeClass('bbit-dp-input');
        $('#grpSdate').datepicker2();

        //그룹카드 추가하기
        $('#groupCardList li').removeClass('active');
        const groupCardHtml = '<li class="work-card pointer active">' +
            '<p class="card-name"><span class="att-code"></span>' + newTitle + '</p>' +
            '<p class="desc">조원을 설정해주세요</p>' +
            '</li>';
        $('#groupCardList').append(groupCardHtml);
        $("#workGroupCd").val(null);

        //pattern div 다시 그리기
        $("#divDrag").show();
        const $divDropContainer = $('#divDrop');

        let newGroupPatternHtml = '';
        for (let i = 1; i <= 4; i++) {
            newGroupPatternHtml += '<div class="inner-wrap">' +
                            '<div class="day-unit">' + i + '일</div>' +
                            '<div id="divDrop' + i + '" class="drop-area" ondrop="drop(event)" ondragover="allowDrop(event)"></div>' +
                        '</div>';
        }
        $divDropContainer.html(newGroupPatternHtml);
        $('.attend-chip').each(function() {
            if ($(this).find('i.mdi-ico').length === 0) {
                const $span = $(this).find('span.text');
                $span.after('<i class="mdi-ico">delete</i>');
            }
        });

        initializeDragAndDrop();
        initGroupListEvent();
    }

    function setSchData(schedule) {
        if(schedule === null || schedule === undefined) {
            $('#workScheduleForm')[0].reset();
            $("#schSdate").val($("#classSdate").val());
            $("#schEdate").val($("#classEdate").val());
            const dataId = $('#schCardList li.work-card.active').data('id');
            const colors = ['blue', 'green', 'orange', 'red', 'yellow', ''];
            const color = colors[(dataId - 1) % colors.length];
            $('#schColorRadio input[type="radio"][value="' + color + '"]').prop('checked', true);
            $("#workSchCd").val('');
        } else {
            $("#updateSchedule").show();
            $("#saveSchedule").hide();

            $("#workSchCd").val(schedule.workSchCd);
            $("#schNmTitle").html(schedule.workSchNm);
            $("#workSchNm").val(schedule.workSchNm).prop('disabled', true);
            $("#workSchSrtNm").val(schedule.workSchSrtNm).prop('disabled', true);
            $('#schColorRadio input[type="radio"][value="' + schedule.color + '"]')
                .prop('checked', true);
            $('#schColorRadio input[type="radio"]').prop('disabled', true);

            $("#schSdate, #schEdate").prop('disabled', true);
            $("#schSdate, #schEdate").removeClass('bbit-dp-input');
            $("#schDates").find('.ui-datepicker-trigger').remove();
            $("#schSdate").val(schedule.sdate);
            $("#schEdate").val(schedule.edate);

            $("#schWorkTimeF").val(schedule.workTimeF).prop('disabled', true);
            $("#schWorkTimeT").val(schedule.workTimeT).prop('disabled', true);

            const breakTimes = schedule.breakTimes.split('-');
            $("#schBreakTimeF").val(breakTimes[0]).prop('disabled', true);
            $("#schBreakTimeT").val(breakTimes[1]).prop('disabled', true);
            $("#shortcut").val(schedule.shortcut).prop('disabled', true);
            $("#schNote").val(schedule.note).prop('disabled', true);

            $('#schCardList li.work-card.active').find('p.desc').text(formatTime(schedule.workTimeF.replace(/:/gi, "")) + ' - ' + formatTime(schedule.workTimeT.replace(/:/gi, "")));

            $("#schWorkTimeF, #schWorkTimeT, #schBreakTimeF, #schBreakTimeT").mask('11:11')
        }
    }

    function setGroupData(group) {
        if(group === null || group === undefined) {
            $('#workGroupForm')[0].reset();
            const dataId = $('#groupCardList li.work-card.active').data('id');
            const groupName = String.fromCharCode(64 + dataId) + ' 조';
            $("#workGroupNm").val(groupName);
            $("#workGroupCd").val('');
        } else {
            $("#updateGroup").show();
            $("#saveGroup").hide();

            $("#workGroupCd").val(group.workGroupCd);
            $("#workGroupNm").val(group.workGroupNm).prop('disabled', true);
            $("#groupNote").val(group.note).prop('disabled', true);

            $('#grpSdate').siblings().remove();
            $('#grpSdate').removeClass('bbit-dp-input');
            $("#grpSdate").prop('disabled', true);
            $("#grpSdate").val(formatDate(group.sdate, '-'));

            const patterns = group.patterns;
            $("#divDrag").hide();
            const $divDrop = $("#divDrop");

            $("#groupCardList li.active").attr('data-id', group.workGroupCd);

            if (patterns !== undefined) {
                let patternHtml = '';
                for (let i = 1; i <= patterns.length; i++) {
                    const pattern = patterns[i - 1];
                    const patternNm = pattern.workSchCd == '0' ? '휴' : pattern.workSchSrtNm;
                    patternHtml += '<div class="inner-wrap">' +
                        '<div class="day-unit">' + i + '일</div>' +
                        '<div class="drop-area" ondrop="drop(event)" ondragover="allowDrop(event)">' +
                        '<div class="attend-chip day ' + pattern.color + '" id="chip' + new Date().getTime() + '" data-id="' + pattern.workSchCd + '">' +
                        '<span class="text">' + patternNm + '</span>' +
                        '</div>' +
                        '</div>' +
                        '</div>';
                }
                $divDrop.empty().append(patternHtml).show();
            }


            $divDrop.addClass("viewer");
            $('.attend-chip').each(function() {
                $(this).find('i.mdi-ico').remove();
                $(this).attr('draggable', 'false');
            });
        }
    }

    function initSchEvent() {
        $("#addSchedule").off().on('click', function (e) {
            e.preventDefault();
            const isExistsActivedCard = ($("#schCardList li.active").length !== 0);
            if (isExistsActivedCard && $("#saveSchedule").css("display") !== "none") {
                alert("저장 또는 삭제 후 이동해주세요.");
                return;
            }
            initNewSchedule();
        });

        //근무생성
        $('.btn-crate').off().click(async function () {
            if ($("#saveBtn").css("display") !== "none") {
                const confirmSave = confirm("교대근무관리 작성 전에 근무제 저장이 필요합니다. 저장 후 작성하시겠습니까?");
                if (!confirmSave) {
                    return;
                }
                await saveWtmWorkClassMgr();
            }

            $('#updateBtn').trigger('click');
            drawCreateShiftInitPage();
            $('.setting-page').addClass('d-none');
            $('.setting-mng').removeClass('d-none');
        });

        // 근무 스케줄, 근무조 tab
        $('.round-tab').off("click").on("click", function () {

            if (this.id === 'roundTab_02') {
                const scheduleList = ajaxCall("/WtmWorkTypeMgr.do?cmd=getWorkScheduleList", "workClassCd=" + getWorkClassCd(), false).DATA;

                if (scheduleList.length < 1) {
                    alert("근무스케줄 생성 후 이동가능합니다.");
                    return false;
                }

                $("#preViewBtn, #detailBtn, #setBtn").show();

                const $chipWrap = $(".chip-wrap");
                let chipHtml = '';

                for (let i = 0; i < scheduleList.length; i++) {
                    const schedule = scheduleList[i];
                    chipHtml += '<div class="attend-chip day ' + schedule.color + '" draggable="true" ondragstart="drag(event)" id="dragChip' + i + '" data-id="' + schedule.workSchCd + '">' +
                        '<span class="text">' + schedule.workSchSrtNm + '</span>' +
                        ' <i class="mdi-ico">delete</i>' +
                        '</div>';
                }

                $chipWrap.empty();
                $chipWrap.append(chipHtml);

                initGroupListEvent();
            } else {
                $("#preViewBtn, #detailBtn, #setBtn").hide();
                initSchCardListEvent();
            }

            // 모든 탭과 콘텐츠에서 active 클래스 제거
            $('.round-tab').removeClass('active');
            $('.round-cont').removeClass('active');

            // 클릭된 탭과 해당하는 콘텐츠에 active 클래스 추가
            $(this).addClass('active');
            const roundConId = '#roundCon_' + this.id.split('_')[1];
            $(roundConId).addClass('active');
        });

        $('#workSchNm').off('input').on('input', function () {
            const newName = $(this).val(); // 입력 필드의 새로운 값 가져오기
            $("#schNmTitle").text(newName);
            const activeCard = $("#schCardList li.active");
            activeCard.find("p.card-name").contents().filter(function () {
                return this.nodeType === 3;
            }).each(function () {
                // 기존 텍스트 노드가 있으면 제거
                $(this).replaceWith(newName ? newName : '\u00A0'); // 새로운 값으로 대체, 값이 비어 있으면 공백 추가
            });

            // 텍스트 노드가 없는 경우 추가
            if (activeCard.find("p.card-name").contents().length === 0) {
                activeCard.find("p.card-name").text(newName ? newName : '\u00A0'); // 값이 비어 있으면 공백 추가
            }
        });

        $('#schWorkTimeF, #schWorkTimeT').off('input').on('input', function () {
            const schWorkTimeF = $("#schWorkTimeF").val();
            const schWorkTimeT = $("#schWorkTimeT").val();
            const activeCard = $("#schCardList li.active");
            activeCard.find("p.desc").text((schWorkTimeF || schWorkTimeT) ? schWorkTimeF + ' - ' + schWorkTimeT : '\u00A0');
        });

        $("#saveSchedule").off('click').on('click', async function (e) {
            e.preventDefault();
            if($("#workSchNm").val() == null || $("#workSchNm").val() == '') {
                alert('근무명을 입력해주세요.');
                return;
            }
            if($("#workSchSrtNm").val() == null || $("#workSchSrtNm").val() == '') {
                alert('약어를 입력해주세요.');
                return;
            }
            if($("#schSdate").val() == null || $("#schSdate").val() == ''
                && $("#schEdate").val() == null || $("#schEdate").val() == '') {
                alert('적용기간을 입력해주세요.');
                return;
            }
            if($("#schWorkTimeF").val() == null || $("#schWorkTimeF").val() == ''
                && $("#schWorkTimeT").val() == null || $("#schWorkTimeT").val() == '') {
                alert('근무시간을 입력해주세요.');
                return;
            }
            await saveWtmWorkSchedule();

            setGroupCnt();
        });

        $("#saveGroup").off('click').on('click', function (e) {
            e.preventDefault();
            if($("#workGroupNm").val() == null || $("#workGroupNm").val() == '') {
                alert('근무조명을 입력해주세요.');
                return;
            }
            if($("#grpSdate").val() == null || $("#grpSdate").val() == '') {
                alert('시작일자를 입력해주세요.');
                return;
            }

            const patterns = [];
            $("#divDrop .drop-area").each(function() {
                const chip = $(this).find(".attend-chip");
                if (chip.length) {
                    patterns.push(chip.data("id"));
                }
            });

            const formData = $("#workGroupForm").serialize()
                + "&workClassCd=" + getWorkClassCd()
                + "&patterns=" + patterns;

            const result = ajaxCall("/WtmWorkTypeMgr.do?cmd=saveWtmWorkGroup", formData, false);

            if (result.Code > 0) {
                setGroupData(result.DATA);
            }
            alert(result.Message);

            setGroupCnt();
        });

        $("#updateSchedule").off('click').on('click', function (e) {
            e.preventDefault();
            $('.workSchedule-wrap :disabled').prop('disabled', false);
            $("#updateSchedule").hide();
            $("#saveSchedule").show();

            $("#schSdate, #schEdate").removeClass('bbit-dp-input');
            $("#schDates").find('.ui-datepicker-trigger').remove();
            $("#schSdate").datepicker2({
                startdate: "schEdate",
                onReturn: checkDateRange
            });
            $("#schEdate").datepicker2({
                enddate: "schSdate",
                onReturn: checkDateRange
            });

            const sdate = $("#schSdate").val();
            const edate = $("#schEdate").val();
            $("#schSdate").val(sdate);
            $("#schEdate").val(edate);

            setGroupCnt();
        });

        $('#schColorRadio input[type="radio"]').off('change').on('change', function () {
            const selectedColor = $(this).val(); // 선택된 색상 값 가져오기
            const activeCard = $("#schCardList li.active");
            const nameText = activeCard.find("p.card-name").contents().filter(function () {
                return this.nodeType === 3;
            }).text();

            activeCard.find("p.card-name").html('<span class="att-code ' + selectedColor + '"></span>' + nameText);
        });

        $("#deleteSchedule").off('click').on('click', function (e) {
            e.preventDefault();
            const $activeCard = $('#schCardList li.active');
            const deleteId = $activeCard.data('id');

            if (deleteId !== undefined) {
                const param = "workSchCd=" + deleteId + "&workClassCd=" + getWorkClassCd();
                const scheduleList = ajaxCall("/WtmWorkTypeMgr.do?cmd=deleteWtmWorkSchedule", param, false).Result;
                if (scheduleList.Code < 0) {
                    return;
                }
                alert(scheduleList.Message);
                $('#workScheduleForm')[0].reset();
            }

            $("#saveSchedule").hide();
            if ($activeCard.length) {
                const $prevCard = $activeCard.prev('.work-card');
                $activeCard.remove();

                if ($prevCard.length) {
                    $prevCard.trigger('click');
                } else {
                    const $nextCard = $('#schCardList li').first();
                    if ($nextCard.length) {
                        $nextCard.trigger('click');
                    }
                }
            }

            setGroupCnt();
        });

        initSchCardListEvent();
    }

    function setGroupCnt(){
        const schCardList = $('#schCardList li');
        $('#schCardCnt').html(schCardList.length);
        const groupCardList = $('#groupCardList li');
        $('#groupCardCnt').html(groupCardList.length);
    }

    async function saveWtmWorkSchedule() {
        try {
            progressBar(true, '저장중입니다.');

            let breakTimes = $("#schBreakTimeF").val() + "-" + $("#schBreakTimeT").val();
            $("#breakTimes").val(breakTimes);

            const param = $("#workScheduleForm").serialize()
                + "&workClassCd=" + getWorkClassCd();

            // 저장 처리
            const response = await fetch("/WtmWorkTypeMgr.do?cmd=saveWtmWorkSchedule", {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: param
            });

            const result = await response.json();
            if (result.Code > 0) {
                setSchData(result.DATA);
                $('#schCardList li.work-card.active').attr('data-id', result.DATA.workSchCd);
            }
            alert(result.Message);
        } catch (error) {
            console.error('저장 중 오류 발생:', error);
            alert('저장 중 오류가 발생했습니다.');
        } finally {
            progressBar(false);
        }
    }

    function initSchCardListEvent() {
        $(document).off('click').on('click', '#schCardList li', function() {
            console.log($(this))
            if (!$(this).hasClass('active')) {
                if ($("#saveSchedule").css("display") !== "none") {
                    alert("저장 또는 삭제 후 이동해주세요.");
                    return;
                }
                $('#schCardList li').removeClass('active');
                $(this).addClass('active');

                const dataId = $(this).data('id');
                if (dataId !== undefined) {
                    const param = "workClassCd=" + getWorkClassCd()
                        + "&workSchCd=" + dataId;
                    const scheduleList = ajaxCall("/WtmWorkTypeMgr.do?cmd=getWorkScheduleList", param, false).DATA;
                    setSchData(scheduleList[0]);
                }
            }
        });
    }

    function initGroupEvent() {
        $('#workGroupNm').off('input').on('input', function () {
            const newName = $(this).val(); // 입력 필드의 새로운 값 가져오기
            $("#groupNmTitle").text(newName);
            const activeCard = $("#groupCardList li.active");
            activeCard.find("p.card-name").contents().filter(function () {
                return this.nodeType === 3;
            }).each(function () {
                $(this).replaceWith(newName ? newName : '\u00A0');
            });

            if (activeCard.find("p.card-name").contents().length === 0) {
                activeCard.find("p.card-name").text(newName ? newName : '\u00A0');
            }
        });

        $("#updateGroup").off('click').on('click', function (e) {
            e.preventDefault();
            $('#workGroupForm :disabled').prop('disabled', false);
            $("#updateGroup").hide();
            $("#saveGroup").show();

            const sdate = $("#grpSdate").val();
            $("#grpSdate").datepicker2({
                startdate: "schEdate",
                enddate: "schSdate",
            });
            $("#grpSdate").val(sdate);

            $("#divDrag").show();
            const $divDrop = $("#divDrop");
            $divDrop.removeClass("viewer");
            $('.attend-chip').each(function() {
                $(this).find('i.mdi-ico').remove();
                $(this).attr('draggable', 'true');
                $(this).append('<i class="mdi-ico">delete</i>');
            });
            checkAndAddNewDropZone();
            initializeDragAndDrop();
        });

        $("#deleteGroup").off('click').on('click', function (e) {
            e.preventDefault();
            const $activeCard = $('#groupCardList li.active');
            const deleteId = $activeCard.data('id');

            if (deleteId !== undefined) {
                const param = "workGroupCd=" + deleteId + "&workClassCd=" + getWorkClassCd();
                const result = ajaxCall("/WtmWorkTypeMgr.do?cmd=deleteWtmWorkGroup", param, false).Result;
                if (result.Code < 0) {
                    return;
                }
                alert(result.Message);
                $('#workGroupForm')[0].reset();
            }

            $("#saveGroup").hide();
            if ($activeCard.length) {
                const prevCard = $activeCard.prev('.work-card');
                $activeCard.remove();

                if (prevCard.length) {
                    prevCard.trigger('click');
                } else {
                    const nextCard = $('#groupCardList li').first();
                    if (nextCard.length) {
                        nextCard.trigger('click');
                    }
                }
            }

            setGroupCnt();
        });

        $("#preViewBtn").off('click').on('click', function (e) {
            if ($("#saveGroup").css("display") !== "none") {
                alert("저장 후 미리보기 가능합니다.");
                return false;
            }

            openPreViewLayer();
        });

        $("#shiftTargetBtn").off('click').on('click', function (e) {
            e.preventDefault();
            if ($("#saveGroup").css("display") !== "none") {
                alert("근무조 저장 후 조원 설정 가능합니다.");
                return false;
            }

            const p = {
                workClassCd: getWorkClassCd(),
                workGroupCd: getWorkGroupCd()
            };

            let layerModal = new window.top.document.LayerModal({
                id : 'wtmWorkGroupTargetLayer' //식별자ID
                , url : '/WtmWorkTypeMgr.do?cmd=viewWtmWorkGroupTargetLayer' //팝업에 띄울 화면 jsp
                , parameters : p
                , width : 1000
                , height : 720
                , title : '대상자 설정'
                , trigger :[ //콜백
                    {
                        name : 'wtmWorkGroupTargetLayerTrigger'
                        , callback : function(result){
                        }
                    }
                ]
            });
            layerModal.show();
        });
    }

    function openPreViewLayer() {
        const p = {
            workClassCd : getWorkClassCd()
        };

        let layerModal = new window.top.document.LayerModal({
            id : 'wtmWorkPreViewLayer' //식별자ID
            , url : '/WtmWorkTypeMgr.do?cmd=viewWtmWorkPreViewLayer' //팝업에 띄울 화면 jsp
            , parameters : p
            , width : 740
            , height : 520
            , title : '미리보기'
            , trigger :[ //콜백
                {
                    name : 'wtmWorkPreViewLayerTrigger'
                    , callback : function(result){
                    }
                }
            ]
        });
        layerModal.show();
    }
    function drawCreateShiftInitPage() {
        $("#saveSchedule").show();
        $("#updateSchedule").hide();
        //근무스케줄
        const colors = ['blue', 'green', 'orange', 'red', 'yellow', ''];

        const schCnt = $("#schCnt").val();
        const $schCardList = $('#schCardList');
        let schCardHtml = '';
        for (let i = 1; i <= schCnt; i++) {
            const color = colors[(i - 1) % colors.length];
            schCardHtml += '<li class="work-card pointer ' + (i === 1 ? 'active' : '') + '" data-id = "'+i+'">' +
                '<p class="card-name"><span class="att-code ' + color + '"></span>스케줄 ' + i + '</p>' +
                '<p class="desc">근무시간을 설정해주세요</p>' +
                '</li>';
        }
        $schCardList.empty().append(schCardHtml);
        $("#schCardCnt").html(schCnt);
        const initSchNm = "스케줄 1";
        $("#workSchNm").val(initSchNm);
        $("#schNmTitle").html(initSchNm)
        $('#attColor1').prop('checked', true);

        //근무조
        $("#saveGroup").show();
        $("#updateGroup").hide();
        const groupCnt = $("#groupCnt").val();
        const $groupCardList = $('#groupCardList');
        $groupCardList.empty();
        let groupCardHtml = '';
        for (let i = 1; i <= groupCnt; i++) {
            const groupName = String.fromCharCode(64 + i) + ' 조';
            groupCardHtml += '<li class="work-card pointer ' + (i === 1 ? 'active' : '') + '" data-id = "'+i+'">' +
                '<p class="card-name"><span class="att-code"></span>' + groupName + '</p>' +
                '<p class="desc">조원을 설정해주세요</p>' +
                '</li>';

        }
        $groupCardList.append(groupCardHtml);
        $("#groupCardCnt").html(groupCnt);
        const initGroupNm = "A 조";
        $("#workGroupNm").val(initGroupNm);
        $("#groupNmTitle").html(initGroupNm);
    }

</script>
<div id="content_04" class="typSetting-content no-padding">
    <div class="setting-page">
        <p class="title">교대 근무를 설정을 해주세요.</p>
        <p class="desc">근무조와 스케줄을 설정해두면 쉽게 근무 스케줄을 만들 수 있습니다.</p>
        <div class="input-wrap">
            <select class="custom_select" id="groupCnt">
                <!-- 옵션 반복 -->
                <option value="1">1조</option>
                <option value="2">2조</option>
                <option value="3">3조</option>
                <option value="4">4조</option>
                <option value="5">5조</option>
                <option value="6">6조</option>
                <option value="7">7조</option>
                <option value="8">8조</option>
                <option value="9">9조</option>
                <option value="10">10조</option>
            </select>
            <select class="custom_select" id="schCnt">
                <!-- 옵션 반복 -->
                <option value="1">1교대</option>
                <option value="2">2교대</option>
                <option value="3">3교대</option>
                <option value="4">4교대</option>
                <option value="5">5교대</option>
                <option value="6">6교대</option>
                <option value="7">7교대</option>
                <option value="8">8교대</option>
                <option value="9">9교대</option>
                <option value="10">10교대</option>
            </select>
            <div class="btn-wrap">
                <button type="button" class="btn filled btn-block btn-crate">근무생성</button>
            </div>
        </div>
    </div>
    <div class="setting-mng d-none">
        <h2 class="title-wrap">
            <div class="inner-wrap">
                <span class="page-title">교대근무 관리</span>
                <div class="round-tab-wrap">
                    <button type="button" id="roundTab_01" class="btn round-tab active">근무스케줄</button>
                    <button type="button" id="roundTab_02" class="btn round-tab">근무조</button>
                </div>
            </div>
            <!-- 버튼 리스트 -->
            <div class="btn-wrap">
                <button type="button" class="btn outline_gray" id="preViewBtn" style="display: none;">미리보기</button>
<%--                <button type="button" class="btn btn outline" id="detailBtn" style="display: none;">상세설정</button>--%>
            </div>
        </h2>
        <div id="roundCon_01" class="round-cont active">
            <div class="row workSchedule-wrap border-top">
                <div class="col-3 card-content">
                    <h3 class="title-wrap">
                        <div class="inner-wrap">
                                <span class="page-title">등록 된 스케줄<strong class="ml-2 cnt" id="schCardCnt"></strong></span>
                        </div>
                        <!-- 버튼 리스트 -->
                        <div class="btn-wrap shift-btns" style="display: none">
                            <button type="button" class="btn outline_gray" id="addSchedule">추가</button>
                        </div>
                    </h3>
                    <!-- 스케줄 리스트 -->
                    <div class="card-list-wrap">
                        <ul class="card-list" id="schCardList">
                        </ul>
                    </div>
                </div>
                <div class="col-9 schedule-detail border-left">
                    <!-- 테이블 제목 -->
                    <h3 class="title-wrap">
                        <div class="inner-wrap">
                            <span class="page-title" id="schNmTitle"></span>
                        </div>
                        <div class="btn-wrap shift-btns" style="display: none">
                            <button type="button" class="btn outline_gray" id="deleteSchedule">삭제</button>
                            <button type="button" class="btn soft" id="saveSchedule" style="display: none;">저장</button>
                            <button type="button" class="btn outline" id="updateSchedule" style="display: none;">수정</button>
                        </div>
                    </h3>
                    <!-- 테이블 -->
                    <form name="workScheduleForm" id="workScheduleForm">
                        <input type="hidden" name="workSchCd" id="workSchCd">
                        <div class="table-wrap mt-2 table-responsive">
                            <table class="basic type5 line-grey">
                                <colgroup>
                                    <col width="15%">
                                    <col width="85%">
                                </colgroup>
                                <tr>
                                    <th><span class="req">근무명</span></th>
                                    <td>
                                        <div class="input-wrap w-100">
                                            <input class="form-input" type="text" id="workSchNm" name="workSchNm">
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th><span class="req">약어</span></th>
                                    <td>
                                        <div class="input-wrap wid-33">
                                            <input class="form-input" type="text" id="workSchSrtNm" name="workSchSrtNm">
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th>색상</th>
                                    <td>
                                        <div class="input-wrap" id="schColorRadio">
                                            <input type="radio" name="schColor" id="attColor1" class="form-radio"
                                                   value="blue">
                                            <label for="attColor1"><span class="att-code blue"></span></label>
                                            <input type="radio" name="schColor" id="attColor2" class="form-radio"
                                                   value="green">
                                            <label for="attColor2"><span class="att-code green"></span></label>
                                            <input type="radio" name="schColor" id="attColor3" class="form-radio"
                                                   value="orange">
                                            <label for="attColor3"><span class="att-code orange"></span></label>
                                            <input type="radio" name="schColor" id="attColor4" class="form-radio"
                                                   value="red">
                                            <label for="attColor4"><span class="att-code red"></span></label>
                                            <input type="radio" name="schColor" id="attColor5" class="form-radio"
                                                   value="yellow">
                                            <label for="attColor5"><span class="att-code yellow"></span></label>
                                            <input type="radio" name="schColor" id="attColor6" class="form-radio"
                                                   value="gray">
                                            <label for="attColor6"><span class="att-code"></span></label>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th><span class="req">적용기간</span></th>
                                    <td id="schDates">
                                        <div class="input-wrap pr-2"><input class="form-input" id="schSdate" name="sdate" type="text"></div> -
                                        <div class="input-wrap pr-2"><input class="form-input" id="schEdate" name="edate" type="text"></div>
                                    </td>
                                </tr>
                                <tr>
                                    <th><span class="req">근무시간</span></th>
                                    <td>
                                        <div class="input-wrap pr-2" style="width: 70px;">
                                            <input class="form-input" type="text" id="schWorkTimeF" name="workTimeF">
                                        </div>
                                         -
                                        <div class="input-wrap px-2" style="width: 70px;">
                                            <input class="form-input" type="text" id="schWorkTimeT" name="workTimeT">
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th>휴게시간</th>
                                    <td>
                                        <div class="input-wrap pr-2" style="width: 70px;">
                                            <input class="form-input" type="text" id="schBreakTimeF"></div>
                                         -
                                        <div class="input-wrap px-2" style="width: 70px;">
                                            <input class="form-input" type="text" id="schBreakTimeT"></div>
                                    </td>
                                    <input type="hidden" name="breakTimes" id="breakTimes">
                                </tr>
                                <tr class="hide">
                                    <th>단축키</th>
                                    <td>
                                        <div class="input-wrap wid-15">
                                            <select class="custom_select" name="shortcut" id="shortcut">
                                                <!-- 옵션 반복 -->
                                                <option value="1">1</option>
                                                <option value="2">2</option>
                                                <option value="3">3</option>
                                                <option value="4">4</option>
                                                <option value="5">5</option>
                                                <option value="6">6</option>
                                                <option value="7">7</option>
                                                <option value="8">8</option>
                                                <option value="9">9</option>
                                                <option value="0">0</option>
                                            </select>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th>설명</th>
                                    <td>
                                        <div class="input-wrap w-100">
                                            <input class="form-input" type="text" id="schNote" name="note">
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <div id="roundCon_02" class="round-cont">
            <div class="row workTeam-wrap border-top">
                <div class="col-3 card-content">
                    <h3 class="title-wrap">
                        <div class="inner-wrap">
                                <span class="page-title">등록 된 근무조<strong class="ml-2 cnt" id="groupCardCnt"></strong></span>
                        </div>
                        <!-- 버튼 리스트 -->
                        <div class="btn-wrap shift-btns" style="display: none">
                            <button type="button" class="btn outline_gray" id="addGroup">추가</button>
                        </div>
                    </h3>
                    <!-- 스케줄 리스트 -->
                    <div class="card-list-wrap">
                        <ul class="card-list" id="groupCardList">
                            <li class="work-card active">
                                <p class="card-name"><span class="att-code blue"></span>A조</p>
                                <p class="desc">조원을 설정해주세요</p>
                            </li>
                        </ul>
                    </div>
                </div>
                <div class="col-9 schedule-detail border-left">
                    <!-- 테이블 제목 -->
                    <h3 class="title-wrap">
                        <div class="inner-wrap">
                            <span class="page-title" id="groupNmTitle"></span>
                        </div>
                        <div class="btn-wrap shift-btns" style="display: none">
                            <button type="button" class="btn outline_gray" id="deleteGroup">삭제</button>
                            <button type="button" class="btn outline" id="updateGroup" style="display: none;">수정</button>
                            <button type="button" class="btn dark" id="saveGroup" style="display: none;">저장</button>
                        </div>
                    </h3>
                    <!-- 테이블 -->
                    <form name="workGroupForm" id="workGroupForm">
                        <input type="hidden" name="workGroupCd" id="workGroupCd">
                        <div class="table-wrap mt-2 table-responsive">
                            <table class="basic type5 line-grey">
                                <colgroup>
                                    <col width="20%">
                                    <col width="80%">
                                </colgroup>
                                <tr>
                                    <th><span class="req">근무조명</span></th>
                                    <td>
                                        <div class="input-wrap w-100">
                                            <input class="form-input" type="text" id="workGroupNm" name="workGroupNm"
                                                   value="">
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th><span class="req">시작일자</span></th>
                                    <td id="grpDates">
                                        <div class="input-wrap pr-2"><input class="form-input" id="grpSdate" name="grpSdate" type="text"></div>
                                    </td>
                                </tr>
                                <tr>
                                    <th>설명</th>
                                    <td>
                                        <div class="input-wrap w-100">
                                            <input class="form-input" type="text" id="groupNote" name="note">
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th>근무조원</th>
                                    <td>
                                        <button type="button" class="btn outline" id="shiftTargetBtn">조원 확인</button>
                                    </td>
                                <tr>
                                    <th>패턴설정</th>
                                    <td class="drag-wrapper">
                                        <div id="divDrag" class="drag-item-wrap">
                                            <p class="desc"><span class="req"></span>항목을 드래그 하여 근무패턴을 설정해주세요.</p>
                                            <div class="chip-wrap"></div>
                                        </div>
                                        <div id="divDrop" class="drop-area-wrap">
                                            <div class="inner-wrap">
                                                <div class="day-unit">1일</div>
                                                <div id="divDrop1" class="drop-area" ondrop="drop(event)"
                                                     ondragover="allowDrop(event)"></div>
                                            </div>
                                            <div class="inner-wrap">
                                                <div class="day-unit">2일</div>
                                                <div id="divDrop2" class="drop-area" ondrop="drop(event)"
                                                     ondragover="allowDrop(event)"></div>
                                            </div>
                                            <div class="inner-wrap">
                                                <div class="day-unit">3일</div>
                                                <div id="divDrop3" class="drop-area" ondrop="drop(event)"
                                                     ondragover="allowDrop(event)"></div>
                                            </div>
                                            <div class="inner-wrap">
                                                <div class="day-unit">4일</div>
                                                <div id="divDrop4" class="drop-area" ondrop="drop(event)"
                                                     ondragover="allowDrop(event)"></div>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
