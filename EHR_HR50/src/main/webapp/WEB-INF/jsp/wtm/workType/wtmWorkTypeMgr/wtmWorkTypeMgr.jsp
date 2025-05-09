<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<!-- bootstrap -->
<link rel="stylesheet" type="text/css" href="/common/plugin/bootstrap/css/bootstrap.min.css" />
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<title>근무유형관리</title>
<!-- 근태 css -->
<link rel="stylesheet" type="text/css" href="/assets/css/attendanceNew.css"/>
<script type="text/javascript">
    $(document).ready(function() {
        drawWorkClassCard();

        $(document).on('click', function(event) {
            if (!$(event.target).closest('.custom_select').length) {
                $('.custom_select .select_options').removeClass('visible');
            }
        });

        $(document).on('click', '.select_toggle', function(event) {
            event.stopPropagation();
            var options = $(this).next('.select_options');
            $('.custom_select .select_options').not(options).removeClass('visible');
            options.toggleClass('visible');
        });

        $(".btn-add").click(function () {
            const workClassCd = $(this).closest('.workType-card').data('id');
            openWorkClassMgr(workClassCd);
        });

        $("#unassignedEmpBtn").on('click', function () {
            let layerModal = new window.top.document.LayerModal({
                id : 'wtmWorkUnassignedEmpLayer' //식별자ID
                , url : '/WtmWorkTypeMgr.do?cmd=viewWtmWorkUnassignedEmpLayer' //팝업에 띄울 화면 jsp
                , parameters : ''
                , width : 1000
                , height : 720
                , title : '미배정 확인'
                , trigger :[ //콜백
                    {
                        name : 'wtmWorkUnassignedEmpLayerTrigger'
                        , callback : function(result){
                        }
                    }
                ]
            });
            layerModal.show();
        });
    });

    /**
     * 근무유형 카드 그리기
     */
    async function drawWorkClassCard() {

        progressBar(true, "조회중입니다.");
        try {
            const json = await fetchWorkClassList();
            const workClassList = json.DATA;
            renderMonthCards(workClassList)
                .then(() => {
                    progressBar(false);
                })
                .catch(() => {
                    progressBar(false);
                });
        } catch(error) {
            console.error(error);
            progressBar(false);
        }
    }

    /**
     * 근무유형 리스트 조회
     * @returns {Promise<any>}
     */
    function fetchWorkClassList() {
        const url = "${ctx}/WtmWorkTypeMgr.do?cmd=getWtmWorkClassMgrList";
        return fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            }
        }).then((response) => {
            return response.json();
        });
    }

    /**
     * 근무유형 카드 그리기
     * @param _workClassList {object} 근무유형 리스트
     * @returns {Promise<any>}
     */
    function renderMonthCards(_workClassList) {
        return new Promise((resolve, reject) => {

            try {
                // 화면 전체 비우기
                const $container = $('.row.card-wrapper');
                $container.empty();

                // 근무유형 코드별 작업
                // 순서에 따라 카드를 먼저 그려준 후, 비동기식으로 대상자 인원 리스트를 조회하여 뿌려줌.
                for (let idx = 0; idx < _workClassList.length; idx++) {
                    const _workClass = _workClassList[idx];
                    const monthCardHtml = makeMonthCardHtml(idx, _workClass);
                    $container.append(monthCardHtml);
                    addEventMonthCard(_workClass);

                    fetchWorkClassEmpList(_workClass)
                        .then((json) => {
                            try {
                                const empList = json.DATA;

                                const avatarHtml = getAvatarHtml(empList);
                                const workClassCd = _workClass.workClassCd;
                                $("div.workType-card[data-id=" + workClassCd + "]").append(avatarHtml);

                                // 마지막 행에서 progressbar 비활성화를 위해 resolve 해준다.
                                const isLastIndex = (idx === _workClassList.length - 1);
                                if (isLastIndex)
                                    resolve();
                            } catch(error) {
                                console.error(error);
                                reject();
                            }
                        })
                }
            } catch(error) {
                console.error(error);
                alert("오류가 발생하였습니다. 관리자에게 문의바랍니다.");
                reject();
            }
        })
    }

    /**
     * 근무유형 별 카드 의 HTML 텍스트 조회
     * @param idx {string|number} 순번
     * @param _workClass {object} 근무유형 정보
     * @returns {string} HTML 텍스트
     */
    function makeMonthCardHtml(idx, _workClass) {

        const checkedClass = (_workClass.useYn === "Y") ? " checked" : "";
        const workDayHtml = getWorkDayHtml(_workClass);
        const workTimeBoxHtml = getWorkTimeBoxHtml(_workClass);
        return `<div class="col-xl-3 col-lg-4 col-md-6 col-sm-12 card-gutter">
                    <div class="workType-card" data-id="${'${_workClass.workClassCd}'}" data-name="${'${_workClass.workClassNm}'}" data-def="${'${_workClass.workClassDefYn}'}">
                        <div class="card-header">
                            <input type="checkbox" id="toggle${'${idx}'}" name="toggle" hidden${'${checkedClass}'}/>
                            <label for="toggle${'${idx}'}" class="toggleSwitch"><span class="toggleButton"></span></label>
                            <div class="custom_select no_style icon btn-more">
                                <button class="select_toggle">
                                    <i class="mdi-ico">more_vert</i>
                                </button>
                                <div class="select_options fix_width align_center">
                                    <div class="option setting-btn">설정</div>
                                    <div class="option delete-btn">유형삭제</div>
                                </div>
                            </div>
                        </div>
                        <div class="card-title icon-more">${'${_workClass.workClassNm}'}${'${workDayHtml}'}</div>
                        <div class="period-wrap">
                            <span class="label">기간</span>
                            <span class="divider"></span>
                            <span class="date">${'${_workClass.sdate.replaceAll("-", ".")}'} - ${'${_workClass.edate.replaceAll("-", ".")}'}</span>
                        </div>
                        ${'${workTimeBoxHtml}'}
                    </div>
                </div>`;
    }

    /**
     * 근무유형 하단에 표시할 대상자 리스트의 HTML 텍스트 조회
     * @param _empList {object} 임직원 리스트
     * @returns {string} HTML 텍스트
     */
    function getAvatarHtml(_empList) {

        const avatarList = getAvatarList(_empList);
        const maxAvatars = 7;
        const displayedAvatarsHtml = avatarList.slice(0, maxAvatars).join('');
        const remainingAvatars = avatarList.length - maxAvatars;
        const remainingAvatarsHtml = remainingAvatars > 0 ? `<span class="re-cnt">+${'${remainingAvatars}'}</span>` : '';
        return `<div class="shift-wrap">
                    <span class="label">인원</span>
                    <span class="cnt">${'${_empList.length}'}명</span>
                    <div class="avatar-wrap">
                        <ul class="avatar-list">
                            ${'${displayedAvatarsHtml}'}
                        </ul>
                        ${'${remainingAvatarsHtml}'}
                    </div>
                </div>`;
    }

    /**
     * 해당 근무유형에 속한 임직원 리스트를 조회
     * @param _workClass {object} 근무유형 정보
     * @returns {Promise<Response>}
     */
    function fetchWorkClassEmpList(_workClass) {
        const url = "${ctx}/WtmWorkTypeMgr.do?cmd=getWorkClassEmpList";
        return fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: "workClassCd=" + _workClass.workClassCd
        }).then((response) => {
            return response.json();
        });
    }

    /**
     * 근무일 정보 HTML 텍스트 조회
     * @param _workClass {object} 근무유형 정보
     * @returns {string} 근무일 HTML 텍스트
     */
    function getWorkDayHtml(_workClass) {

        const dayMap = {
            MON: '월',
            TUE: '화',
            WED: '수',
            THU: '목',
            FRI: '금',
            SAT: '토',
            SUN: '일'
        };

        let workDayHtml = '';
        const workDays = _workClass.workDay;
        if (_workClass.workTypeCd !== 'D' && workDays && workDays.indexOf(",") >= 0) {
            workDayHtml = '<span class="day-wrap">';
            const workDaysArr = _workClass.workDay.split(',');
            workDaysArr.forEach(day => {
                workDayHtml += `<span class="day">${'${dayMap[day.trim()]}'}</span>`;
            })
            workDayHtml += '</span>';
        }

        return workDayHtml;
    }

    /**
     * 근무유형 박스 HTML 텍스트 조회
     * @param _workClass {object} 근무유형 정보
     * @returns {string} HTML 텍스트 조회
     */
    function getWorkTimeBoxHtml(_workClass) {

        if (_workClass.workTypeCd === 'A') {
            const coreTime = (_workClass.coreTimeF) ? formatTime(_workClass.coreTimeF) + " ~ " + formatTime(_workClass.coreTimeT) : "-";
            const avgWeekWkLmt = (_workClass.avgWeekWkLmt) ? _workClass.avgWeekWkLmt + "시간" : "-";
            return `<div class="row workTime-box">
                       <div class="col-6">
                           <span class="label">코어타임</span>
                           <div class="desc">${'${coreTime}'}</div>
                       </div>
                       <div class="col-6 divider">
                           <span class="label">주평균</span>
                           <div class="desc">${'${avgWeekWkLmt}'}</div>
                       </div>
                   </div>`;
        } else if (_workClass.workTypeCd === 'B') {
            const startWorkTime = (_workClass.startWorkTimeF) ? formatTime(_workClass.startWorkTimeF) + " ~ " + formatTime(_workClass.startWorkTimeT) : "-";
            const workHours = (_workClass.workHours) ? _workClass.workHours + "시간" : "-";
            const weekWkLmt = (_workClass.weekWkLmt) ? _workClass.weekWkLmt + "시간" : "-";
            return `<div class="row workTime-box">
                       <div class="col-4">
                           <span class="label">출근가능시간</span>
                           <div class="desc">${'${startWorkTime}'}</div>
                       </div>
                       <div class="col-4 divider">
                           <span class="label">일근무</span>
                           <div class="desc">${'${workHours}'}</div>
                       </div>
                       <div class="col-4 divider">
                           <span class="label">주근무</span>
                           <div class="desc">${'${weekWkLmt}'}</div>
                       </div>
                   </div>`;
        } else if (_workClass.workTypeCd === 'C') {
            const workHours = (_workClass.workHours) ? _workClass.workHours + "시간" : "-";
            const weekWkLmt = (_workClass.weekWkLmt) ? _workClass.weekWkLmt + "시간" : "-";
            return `<div class="row workTime-box">
                       <div class="col-6">
                           <span class="label">근무</span>
                           <div class="desc">${'${workHours}'}</div>
                       </div>
                       <div class="col-6 divider">
                           <span class="label">주근무</span>
                           <div class="desc">${'${weekWkLmt}'}</div>
                       </div>
                   </div>`;
        } else if (_workClass.workTypeCd === 'D') {
            return `<div class="row workTime-box">
                       <div class="col-12">
                           <div class="desc text-center">${'${_workClass.workGroupCnt}'}조 ${'${_workClass.workSchCnt}'}교대</div>
                       </div>
                    </div>`;
        } else {
            const workTimeF = (_workClass.workTimeF) ? formatTime(_workClass.workTimeF) + " 출근" : "-";
            const workHours = (_workClass.workHours) ? _workClass.workHours + "시간" : "-";
            const weekWkLmt = (_workClass.weekWkLmt) ? _workClass.weekWkLmt + "시간" : "-";
            return `<div class="row workTime-box">
                       <div class="col-4">
                           <span class="label">출근</span>
                           <div class="desc">${'${workTimeF}'}</div>
                       </div>
                       <div class="col-4 divider">
                           <span class="label">근무</span>
                           <div class="desc">${'${workHours}'}</div>
                       </div>
                       <div class="col-4 divider">
                           <span class="label">주근무</span>
                           <div class="desc">${'${weekWkLmt}'}</div>
                       </div>
                   </div>`;
        }
    }

    /**
     * 근무유형 카드섹션에 필요한 아바타 리스트 조회
     * @param _empList {object} 근무유형에 속한 임직원 리스트
     * @returns {*[]} 아바타 리스트 조회
     */
    function getAvatarList(_empList) {
        let avatarList = [];
        _empList.forEach(function(emp) {
            avatarList.push(`<li><img src="/EmpPhotoOut.do?enterCd=${'${emp.enterCd}'}&searchKeyword=${'${emp.targetCd}'}"></li>`);
        });
        return avatarList;
    }

    /**
     * 근무유형 이벤트 추가
     * @param _workClass {object} 근무유형 정보
     */
    function addEventMonthCard(_workClass) {
        const $workTypeCard = $("div.workType-card[data-id=" + _workClass.workClassCd + "]");

        $workTypeCard.find("input[name=toggle]").on('click', function() {
            const userYn = $(this).is(':checked') ? 'Y' : 'N';
            const workClassCd = $(this).closest('.workType-card').data('id');
            const params = "useYn=" + userYn
                + "&workClassCd=" + workClassCd;
            const result = ajaxCall("${ctx}/WtmWorkTypeMgr.do?cmd=saveWtmWorkClassUseYn", params, false);
            if (result.Result.Code < 1) {
                alert("저장 중 오류가 발생하였습니다.");
            }
        });

        $workTypeCard.find("div.setting-btn, div.card-title").on("click", function () {
            const workClassCd = $(this).closest('.workType-card').data('id');
            openWorkClassMgr(workClassCd);
        });

        $workTypeCard.find("div.delete-btn").on("click", function() {
            // WORK_CLASS_DEF_YN
            // data-def
            console.log($(this).closest('.workType-card').data('def'))
            if($(this).closest('.workType-card').data('def') == 'Y'){
                alert('기본 근무제는 삭제할 수 없습니다.\n기본 근무제를 변경해주세요.');
            }else{
                const workClassNm = $(this).closest('.workType-card').data('name');
                const confirmDelete = confirm("'" + workClassNm +"'을(를) 삭제 하시겠습니까?");
                if (confirmDelete) {
                    const workClassCd = $(this).closest('.workType-card').data('id');
                    const result = ajaxCall("${ctx}/WtmWorkTypeMgr.do?cmd=deleteWtmWorkClassMgr", "workClassCd=" + workClassCd, false);
                    if (result.Result.Code > 0) {
                        drawWorkClassCard();
                        alert('삭제가 완료되었습니다.');
                    }
                }
            }
        });
    }

    function openWorkClassMgr(workClassCd) {
        const param = "&workClassCd=" + workClassCd;
        window.location.href = '/WtmWorkTypeMgr.do?cmd=viewWtmWorkClassMgr' + param;
    }



</script>
</head>

<body class="iframe_content white attendanceNew">
<h2 class="title-wrap">
    <div class="inner-wrap">
        <span class="icon-wrap"><i class="mdi-ico">checklist</i></span>
        <span class="page-title">근무유형관리</span>
    </div>
    <div class="btn-wrap">
        <button class="btn outline" id="unassignedEmpBtn">미배정 확인</button>
        <button class="btn filled icon_text btn-add"><i class="mdi-ico">add</i>생성하기</button>
    </div>
</h2>
<!-- 달력 body -->
<div class="workType-body">
    <div class="row card-wrapper"></div>
</div>
<script>

</script>
</body>
</html>