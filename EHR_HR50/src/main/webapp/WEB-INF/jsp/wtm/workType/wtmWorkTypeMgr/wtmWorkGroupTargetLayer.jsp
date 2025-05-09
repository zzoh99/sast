<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp" %>
<!DOCTYPE html>
<html class="bodywrap">
<head>
    <link href="/common/plugin/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="/assets/css/common.css" />
    <link rel="stylesheet" type="text/css" href="/assets/css/hrux_fit.css">
    <link rel="stylesheet" type="text/css" href="/assets/css/attendanceNew.css"/>
    <script src="/assets/plugins/moment.js-2.30.1/moment-with-locales.js"></script>
    <!-- 개별 화면 script -->
    <script>
        $(document).ready(async function () {
            const modal = window.top.document.LayerModalUtility.getModal('wtmWorkGroupTargetLayer');
            const workClassCd = modal.parameters.workClassCd || '';
            const workGroupCd = modal.parameters.workGroupCd || '';

            initEvent(workClassCd);

            setEmpData(workClassCd, workGroupCd, "");
        });

        function initEvent(workClassCd) {
            $("#moveBtn").on('click', async function () {
                window.top.goOtherSubPage("", "", "", "", 'WtmPsnlWorkTypeMgr.do?cmd=viewWtmPsnlWorkTypeMgr');
                closeCommonLayer('wtmWorkGroupTargetLayer');
            });

            $('#searchKey').on('keypress', async function (event) {
                if (event.which === 13) {
                    event.preventDefault();
                    await setEmpData(workClassCd, $('#searchKey').val());
                }
            });

            $(document).off('click', '.collpaseButton').on('click', '.collpaseButton', function (e) {
                e.preventDefault();
                $(this).find('.mdi-ico').toggleClass('rotate');
                $(this).closest('.item-header').next('.item-body').toggleClass('open');
            });

            $(".tab_menu").off('click').on('click', function () {
                $(".tab_menu").removeClass("active");
                $(this).addClass("active");
                $(".serarch-result-wrap").hide();
                const tabId = $(this).attr("id");
                $("#tabContent" + tabId.substring(3)).show();
            });

            $("#deleteTargetBtn").on('click', function (){
                let removedCount = 0;
                $('#assignedWrap .card-item').filter(function() {
                    return $(this).find('.form-checkbox').is(':checked');
                }).each(function() {
                    $(this).remove();
                    removedCount++;
                });

                initAddTargetBtn(workClassCd);
                const seq = $("#assignedTargetCnt").text();
                const assignedCnt = parseInt(seq) - removedCount;
                $("#assignedTargetCnt").html(assignedCnt);

                if (assignedCnt === 0) {
                    $("#assignedWrap").hide();
                    $("#assignedListNone").show();
                }
            });

            $("#saveTargetBtn").on('click', function (){
                const param = $("#assignForm").serialize() + "&workClassCd=" + workClassCd;
                const result = ajaxCall("/WtmWorkTypeMgr.do?cmd=savewtmWorkGroupTarget", param, false);

                if (result.Code > 0) {
                    const modal = window.top.document.LayerModalUtility.getModal('wtmWorkGroupTargetLayer');
                    modal.fire('wtmWorkGroupTargetLayerTrigger', '').hide();
                }
            });

            $("#addOrgBtn").on('click', function () {
                const checkedOrgs = orgSheet.FindCheckedRow("checkYn");

                if(checkedOrgs === '' || checkedOrgs == null) {
                    alert('선택한 조직이 없습니다.');
                    return;
                }

                checkedOrgs.split("|").map(function (rowIndex) {
                    const org = orgSheet.GetRowData(rowIndex);

                    if (org.checkedYn !== 'Y' && org.dataId !== '') {
                        const oldClassCd = getOldClassCd('ORG', org.orgCd, workClassCd, '');

                        if (oldClassCd === undefined) {
                            return false;
                        }

                        const seq = $("#assignedTargetCnt").text();
                        const target = {
                            enterCd: org.enterCd,
                            targetNm: org.orgNm,
                            targetCd: org.orgCd,
                            note1: '',
                            note2: org.priorOrgNm,
                            type: 'ORG',
                            oldClassCd: oldClassCd,
                            sdate: getTodayDate().replace(/-/gi, "")
                        }

                        makeAssignedEmpCardItem(target, seq, true);

                        $("#assignedTargetCnt").html(parseInt(seq) + 1);
                        orgSheet.SetCellValue(rowIndex, "checkedYn", "Y");
                        orgSheet.SetCellEditable(rowIndex, "checkYn", 0);

                        $("#assignedWrap").show();
                        $("#assignedListNone").hide();

                        const dataId = 'ORG|' + org.orgCd;
                        const $checkedLiBtn = $("#unassignList li[data-id='" + dataId + "'] .addTargetBtn");
                        $checkedLiBtn.remove();
                    }
                });
            });

            $("#showValidEmp").on("click", async function() {
                const isChecked = $(this).is(":checked");
                const today = moment();

                const assignedTargetList = await setEmpData(workClassCd, "");
                setAssignedEmpData(assignedTargetList);
            })
        }

        function initAddTargetBtn(workClassCd) {
            $(".addTargetBtn").off('click').on('click', function () {
                const $li = $(this).closest('li.card-item');
                const targetCd = $li.find('img').attr('src').split('searchKeyword=')[1];
                const type = $li.data('type');
                const dataId = $li.data('id');
                const oldClassCd = getOldClassCd(type, targetCd, workClassCd, '');

                if (oldClassCd === undefined) {
                    return false;
                }

                $("#assignedWrap").show();
                $("#assignedListNone").hide();

                const seq = $("#assignedTargetCnt").text();
                const target = {
                    enterCd: $li.find('img').attr('src').split('enterCd=')[1],
                    targetNm: $li.find('.name').text(),
                    targetCd: targetCd,
                    note1: $li.find('.position').text(),
                    note2: $li.find('.team').text(),
                    type: type,
                    oldClassCd: oldClassCd,
                    sdate: getTodayDate().replace(/-/gi, "")
                }

                makeAssignedEmpCardItem(target, seq, true);

                $("#assignedTargetCnt").html(parseInt(seq) + 1);

                const orgRow = orgSheet.FindText("dataId", dataId);
                if (orgRow !== -1) {
                    orgSheet.SetCellValue(orgRow, "checkYn", "Y");
                    orgSheet.SetCellValue(orgRow, "checkedYn", "Y");
                    orgSheet.SetCellEditable(orgRow, "checkYn", 0);
                }
            });
        }

        function getOldClassCd(type, targetCd, workClassCd, searchDate) {
            const param = "&targetCd=" + targetCd
                + "&type=" + type
                + "&searchDate=" + searchDate;
            const oldClass = ajaxCall("/WtmWorkTypeMgr.do?cmd=getWorkClassEmpList", param, false).DATA;

            if (oldClass.length < 1) {
                return '';
            }

            if (oldClass[0].workClassCd === workClassCd) {
                return '';
            }

            const confirmAdd =
                confirm(`[${'${oldClass[0].workClassNm}'} (${'${oldClass[0].period}'})] 근무유형의 기간과 중복됩니다.\n` +
                        `근무유형을 변경하시겠습니까?\n` +
                        `근무유형 변경 시 기존 근무유형의 종료일은 새로운 근무유형 시작일 전날로 변경됩니다.`);

            // 변경할 기존 근무 유형의 기간이 유효하지 않은 경우 경우 알림
            const targetSdate = $('li[data-id="'+type+'|'+targetCd+'"] input[id^="sdate-"]').val().replace(/-/g,'');

            const dateObj = new Date(targetSdate.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3'));
            const newEdate = new Date(dateObj.setDate(dateObj.getDate() - 1)).toISOString().slice(0,10).replace(/-/g,'');

            if(!compareDates(oldClass[0].sdate, newEdate)) {
                alert('기존 근무 유형의 기간을 ' + formatDate(oldClass[0].sdate,"-") + ' ~ ' + formatDate(newEdate,"-") + '으로 변경할 수 없습니다.');
                return;
            }

            if (confirmAdd) {
                return oldClass[0].workClassCd;
            }
        }

        // 날짜 비교 (근무유형의 기간 유효성을 체크하기 위함)
        function compareDates(sdate, edate) {
            // 날짜 형식을 YYYYMMDD에서 YYYY-MM-DD로 변환
            const sDateFormatted = sdate.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3');
            const eDateFormatted = edate.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3');

            // Date 객체로 변환
            const sDateObj = new Date(sDateFormatted);
            const eDateObj = new Date(eDateFormatted);

            // 날짜 비교 (edate가 sdate보다 이후인지)
            return eDateObj >= sDateObj;
        }

        async function setEmpData(workClassCd, workGroupCd, searchKey) {
            try {
                progressBar(true);

                const response = await fetch("/WtmWorkTypeMgr.do?cmd=getWtmWorkGroupTargetList", {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'workClassCd=' + workClassCd + '&workGroupCd=' + workGroupCd + '&searchKey=' + searchKey
                });
                const targetList = (await response.json()).DATA

                if (targetList.length < 1) {
                    $("#assignedWrap").hide();
                    $("#assignedListNone").show();
                    return false;
                }
                $("#assignedWrap").show();
                $("#assignedListNone").hide();

                let targetHtml = '';
                const $targetList = $('#assignedList');
                const assignedTarget = [];
                const isCheckedShowValidEmp = $("#showValidEmp").is(":checked");
                const isValidEmp = (_target) => {
                    const sdate = moment(_target.sdate);
                    const edate = moment(_target.edate);
                    return !(moment().isAfter(edate) || moment().isBefore(sdate));
                }
                $targetList.empty();
                targetList.forEach(function(item){
                    targetHtml += '<div class="col-xl-4 col-lg-4 col-md-6 col-sm-12 card-gutter">';
                    targetHtml += '    <div class="workType-card personal">';
                    targetHtml += '        <div class="profile">';
                    targetHtml += '            <div class="img-wrap">';
                    targetHtml += '                <img src="${ctx}/EmpPhotoOut.do?enterCd=' + item.enterCd + '&sabun='+item.sabun+'">';
                    targetHtml += '            </div>';
                    targetHtml += '            <div class="info-wrap">';
                    targetHtml += '                <div class="info">';
                    targetHtml += '                    <span class="name">' + item.name + '</span>';
                    targetHtml += '                    <span class="position">' + item.jikweeNm + '</span>';
                    targetHtml += '                    <span class="divider"></span>';
                    targetHtml += '                    <span class="position co-num">' + item.sabun + '</span>';
                    targetHtml += '                </div>';
                    targetHtml += '                <div class="team">' + item.orgNm + '</div>';
                    targetHtml += '            </div>';
                    targetHtml += '        </div>';
                    targetHtml += '        <div class="row workTime-box">';
                    targetHtml += '            <div class="d-flex align-center">';
                    targetHtml += '                <div class="label">근무유형</div>';
                    targetHtml += '                <div class="desc ml-auto">' + item.workClassNm;
                    if(item.workGroupNm) targetHtml += '('+item.workGroupNm+')';
                    targetHtml += '</div>';
                    targetHtml += '            </div>';
                    targetHtml += '            <div class="d-flex align-center mt-4">';
                    targetHtml += '                <div class="label">기간</div>';
                    targetHtml += '                <div class="desc ml-auto">' + item.sdate + ' - ' + item.edate + '</div>';
                    targetHtml += '            </div>';
                    targetHtml += '        </div>';
                    targetHtml += '    </div>';
                    targetHtml += '</div>';
                })
                // $('#workTypeMgrList').html(html);
                // targetList.forEach(target => {
                //
                //     targetHtml += getUnassignedEmpCardItemHtml(target);
                //
                //     if (target.checkYn === 'Y') {
                //         target.readonly = true; // DB 저장된 대상자의 sdate 변경을 막기 위한 속성
                //         if (!isCheckedShowValidEmp || (isCheckedShowValidEmp && isValidEmp(target)))
                //             assignedTarget.push(target);
                //     }
                // });
                $targetList.append(targetHtml);
            } catch (error) {
                console.error('조회 중 오류 발생:', error);
                alert('조회 중 오류가 발생했습니다.');
            } finally {
                progressBar(false);
            }
        }

        /**
         * 검색결과 임직원 카드 HTML 텍스트 조회
         * @param _target {object} 임직원 정보
         * @returns {string} HTML 텍스트
         */
        function getUnassignedEmpCardItemHtml(_target) {
            const dataId = _target.type + '|' + _target.targetCd;
            return `<li class="card-item" data-type="${'${_target.type}'}" data-id="${'${dataId}'}">
                        <div class="img-wrap">
                            <img src="/EmpPhotoOut.do?enterCd=${'${_target.enterCd}'}&searchKeyword=${'${_target.targetCd}'}">
                        </div>
                        <div class="info-wrap">
                            <div>
                                <span class="name">${'${_target.targetNm}'}</span><span class="position">${'${_target.note1}'}</span>
                            </div>
                            <div class="team">${'${_target.note2}'}</div>
                        </div>
                        <div class="btn-wrap">
                            <button type="button" class="btn filled addTargetBtn">추가</button>
                        </div>
                    </li>`;
        }

        function setAssignedEmpData(assignedTargetList) {
            $("#assignedTargetCnt").html(assignedTargetList.length);
            if (assignedTargetList.length < 1) {
                $getAssignedWrap().hide();
                $("#assignedListNone").show();
                return false;
            }
            $("#assignedWrap").show();
            $("#assignedListNone").hide();

            const $assignWrap = $getAssignedCardList();
            $assignWrap.empty();
            for (let i = 0; i < assignedTargetList.length; i++) {
                let target = assignedTargetList[i];
                makeAssignedEmpCardItem(target, i);
            }

        }

        function generateAssignedHtml(target, seq) {
            const dataId = target.type + '|' + target.targetCd + "|" + target.sdate;
            const sdateClass = target.readonly ? 'readonly' : '';
            return '<li class="card-item" data-id="' + dataId + '">' +
                '    <div class="item-header">' +
                '        <input type="checkbox" class="form-checkbox"/>' +
                '        <div class="img-wrap">' +
                '            <img src="/EmpPhotoOut.do?enterCd=' + target.enterCd + '&searchKeyword=' + target.targetCd + '">' +
                '        </div>' +
                '        <div class="info-wrap">' +
                '            <div>' +
                '                <span class="name">' + target.targetNm + '</span><span class="position">' + target.note1 + '</span>' +
                '            </div>' +
                '            <div class="team">' + target.note2 + '</div>' +
                '        </div>' +
                '        <div class="btn-wrap">' +
                '            <button type="button" class="btn icon collpaseButton" style="cursor: pointer">' +
                '                <i class="mdi-ico">keyboard_arrow_down</i>' +
                '            </button>' +
                '        </div>' +
                '    </div>' +
                '    <div class="item-body">' +
                '        <div class="body-title">기간 상세설정</div>' +
                '        <div class="input-wrap">' +
                '            <div class="date-wrap"><input class="form-input '+ sdateClass +'" name="targetList[' + seq + '].sdate" type="text" id="sdate-' + seq + '" value="' + (target.sdate || getTodayDate()) + '" '+ sdateClass + '></div>' +
                '            <span class="date-divider">-</span>' +
                '            <div class="date-wrap"><input class="form-input" name="targetList[' + seq + '].edate" type="text" id="edate-' + seq + '" value="' + (target.edate) + '"></div>' +
                '        </div>' +
                '    </div>' +
                ' <input type="hidden" name="targetList[' + seq + '].targetCd" value="' + target.targetCd + '">' +
                ' <input type="hidden" name="targetList[' + seq + '].type" value="' + target.type + '">' +
                ' <input type="hidden" id="targetList[' + seq + '].oldClassCd" name="targetList[' + seq + '].oldClassCd" value="' + (target.oldClassCd || '') + '">' +
                '</li>';
        }

        /**
         * 오늘 일자 조회 (YYYY-MM-DD 형태)
         * @returns {string} 오늘일자
         */
        function getTodayDate() {
            const today = new Date();
            const year = today.getFullYear();
            const month = String(today.getMonth() + 1).padStart(2, '0');
            const day = String(today.getDate()).padStart(2, '0');
            return year + '-' + month + '-' + day;
        }

        // 공통 설정 함수
        /**
         * 선택된 대상자의 기간 상세설정 시작/종료일의 datepicker 설정
         * @param dataId {string} 대상자 정보 ID
         */
        function setupDatepicker(dataId) {
            const $sdate = $getAssignedCardItemDate(dataId, "sdate");
            const $edate = $getAssignedCardItemDate(dataId, "edate");

            $sdate.datepicker2({
                disabled: $sdate.prop('readonly'),  // readonly면 disable 처리
                onReturn: function() {
                    $(this).trigger('change');
                }
            });

            $edate.datepicker2({
                enddate: $sdate.attr("id"),
                disabled: $edate.prop('readonly'),  // readonly면 disable 처리
                onReturn: function() {
                    $(this).trigger('change');
                }
            });

            // readonly인 경우 트리거 버튼 스타일 처리
            if ($sdate.prop('readonly')) {
                $sdate.next('.ui-datepicker-trigger')
                    .css('pointer-events', 'none')
                    .css('opacity', '0.5');
            }
            if ($edate.prop('readonly')) {
                $edate.next('.ui-datepicker-trigger')
                    .css('pointer-events', 'none')
                    .css('opacity', '0.5');
            }

            // 기간 값 변경시 중복 체크
            $("#" + $sdate.attr("id") + ", #" + $edate.attr("id")).off('change').on('change', function() {
                const value = $(this).val();
                const numberOnly = value.replace(/[^0-9]/g, '');
                if(numberOnly.length === 8) {
                    chkDupDate(this);
                    if (isDupDate(dataId)) {
                        alert("기간이 중복된 데이터가 존재합니다.");
                        $(this).val("");
                    }
                }
            })
        }

        // 기간 중복체크
        function chkDupDate(obj) {
            const modal = window.top.document.LayerModalUtility.getModal('wtmWorkGroupTargetLayer');
            const workClassCd = modal.parameters.workClassCd || '';

            // 현재 입력 필드의 가장 가까운 li.card-item을 찾아 data-id 값을 가져옴
            const dataId = $(obj).closest('li.card-item').data('id');
            const oldClassCd = getOldClassCd(dataId.split('|')[0], dataId.split('|')[1], workClassCd, $(obj).val())

            if (oldClassCd === undefined) {
                $(obj).val('')
                return;
            }

            // target의 oldClassCd 변경
            const seq = $(obj).attr('id').split('-')[1];
            $('input[name="targetList[' + seq + '].oldClassCd"]').val(oldClassCd);
        }

        function closeCommonLayer( id ) {
            const modal = window.top.document.LayerModalUtility.getModal(id);
            modal.hide();
        }

        /**
         * 선택한 대상자 리스트에서 기간 중복 여부 확인
         * @param _dataId
         * @returns {boolean}
         */
        function isDupDate(_dataId) {

            const type = _dataId.split("|")[0];
            const targetCd = _dataId.split("|")[1];
            const sdate = $getAssignedCardItemDate(_dataId, "sdate").val();
            const edate = $getAssignedCardItemDate(_dataId, "edate").val();

            if (!moment(sdate).isValid() || !moment(edate).isValid()) return false;

            let isDup = false;
            $getAssignedEmpCardItem().each(function() {

                const tmpDataId = $(this).attr("data-id");
                if (tmpDataId === _dataId) return true;
                const isNotSameEmp = (tmpDataId.indexOf(type + "|" + targetCd) < 0);
                if (isNotSameEmp) return true;
                const tmpSdate = $getAssignedCardItemDate(tmpDataId, "sdate").val();
                let tmpEdate = $getAssignedCardItemDate(tmpDataId, "edate").val();

                if (tmpSdate === "") return true;
                if (tmpEdate === "") tmpEdate = "9999-12-31";

                if (!(moment(tmpSdate).isAfter(moment(edate)) || moment(tmpEdate).isBefore(moment(sdate)))) {
                    isDup = true;
                    return false;
                }
            })

            return isDup;
        }

        /**
         * 임직원 카드 ID로 선택되지 않은 대상자 jQuery 셀렉터 조회
         * @param _id 임직원 카드 id
         * @returns {*|jQuery|HTMLElement}
         */
        function $getUnassignedEmpCardItem(_id) {
            return $("ul#unassignList li.card-item[data-id='" + _id + "']");
        }

        /**
         * 선택된 대상자 wrapper 영역 jQuery 셀렉터 조회
         * @returns {*|jQuery|HTMLElement}
         */
        function $getAssignedWrap() {
            return $("#assignedWrap");
        }

        /**
         * 선택된 대상자 card list 영역 jQuery 셀렉터 조회
         * @returns {*|jQuery|HTMLElement}
         */
        function $getAssignedCardList() {
            return $getAssignedWrap().find("ul.card-list");
        }

        /**
         * 임직원 카드 ID로 선택된 대상자 jQuery 셀렉터 조회
         * @param _id {null|string|number} 임직원 카드 id
         * @returns {*|jQuery|HTMLElement}
         */
        function $getAssignedEmpCardItem(_id = "") {
            return $getAssignedCardList().find((_id) ? "li.card-item[data-id='" + _id + "']" : "li.card-item");
        }

        /**
         * 선택된 대상자 임직원 카드 아이템 생성
         * @param _target {object} 임직원 정보
         * @param _idx {string|number} 순번
         * @param isCollapse {boolean} 기간 상세설정 부분 펼칠지 여부
         */
        function makeAssignedEmpCardItem(_target, _idx, isCollapse = false) {
            const assignedHtml = generateAssignedHtml(_target, _idx);
            $getAssignedCardList().append(assignedHtml);
            const id = _target.type + "|" + _target.targetCd + "|" + _target.sdate;
            if (isCollapse)
                $getAssignedEmpCardItem(id).find('.collpaseButton').click();

            setupDatepicker(id);
        }

        /**
         * 카드 아이템의 타겟 ID 로 서로 동일한지 여부 판단
         * @param _id1 {string} 카드 아이템 타겟 ID
         * @param _id2 {string} 카드 아이템 타겟 ID
         * @returns {boolean} 동일한지 여부
         */
        function isSameTarget(_id1, _id2) {
            try {
                const id1Arr = _id1.split("|");
                const id2Arr = _id2.split("|");
                return id1Arr[0] === id2Arr[0] && id1Arr[1] === id2Arr[1];
            } catch(err) {
                console.error(err);
            }
        }

        /**
         * 선택한 대상자 리스트에서 기간의 jQuery Selector 조회
         * @param _dataId {string} 선택한 대상자 카드 아이템의 ID
         * @param type {null|string} 조회하고자 하는 타입 (sdate: 시작일자, edate: 종료일자)
         * @returns {null|jQuery} jQuery Selector 조회
         */
        function $getAssignedCardItemDate(_dataId, type = "sdate") {
            const $input = $getAssignedEmpCardItem(_dataId).find("input");
            return $input.filter(function() {
                return $(this).attr("id") && $(this).attr("id").indexOf(type) >= 0;
            });
        }
    </script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
    <div class="modal_body">
        <h2 class="title-wrap">
<%--            <span class="page-title">기본설정</span>--%>
            <div class="btn-wrap">
                <button type="button" class="btn outline" id="moveBtn">개인별근무유형관리</button>
            </div>
        </h2>
        <div class="memberList-wrap">
            <!-- 리스트가 없을 때 -->
            <div class="list-none" id="assignedListNone" style="display: none;">
                <i class="mdi-ico">groups</i>
                <p class="desc">대상자가 없습니다.</p>
            </div>
            <!-- 리스트가 있을 때 -->
            <form name="assignForm" id="assignForm">
                <div class="workType-body scroll" id="assignedWrap">
                    <div class="row card-wrapper" id="assignedList">
                        <!-- 반복 단위 -->
                    </div>
                </div>
            </form>
        </div>
    </div>
    <div class="modal_footer">
        <a href="javascript:closeCommonLayer('wtmWorkGroupTargetLayer');" class="gray large">닫기</a>
    </div>
</div>
</body>
</html>



