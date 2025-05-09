<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp" %>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp" %>
<!DOCTYPE html><html class="bodywrap"><head>
<!-- 근태 css -->
<link rel="stylesheet" type="text/css" href="/assets/css/attendanceNew.css"/>

<!-- 개별 화면 script -->
<script>
    $(document).ready(function () {
        const modal = window.top.document.LayerModalUtility.getModal('wtmWorkClassShiftTargetLayer');
        const workClassCd = modal.parameters.workClassCd || '';
        const workGroupCd = modal.parameters.workGroupCd || '';
        $('#workClassCd').val(workClassCd);
        $('#workGroupCd').val(workGroupCd);

        initEvent(workClassCd, workGroupCd);
        init();
    });

    function init(){
        const assignedTargetList = setEmpData();
        setAssignedEmpData(assignedTargetList);
    }

    function initEvent(workClassCd, workGroupCd) {
        $('#sdate').datepicker2({
            sdate: 'sdate',
            onReturn:function(){
                //리스트 초기화
                $("#assignedWrap ul.card-list").html('');
                init();
            }
        })

        $("#searchBtn").on('click', function () {
            setEmpData();
        });

        $('#searchKey').on('keypress', function (event) {
            if (event.which === 13) {
                event.preventDefault();
                setEmpData();
            }
        });

        $("#deleteTargetBtn").on('click', function (){
            let removedCount = 0;
            $('#assignedWrap .card-item').filter(function() {
                return $(this).find('.form-checkbox').is(':checked');
            }).each(function() {
                const dataId = $(this).data('id');

                $(this).remove();
                removedCount++;

                $('#unassignWrap .card-item').filter(function() {
                    return $(this).data('id') === dataId;
                }).each(function() {
                    $(this).find('.btn-wrap').append('<button class="btn filled addTargetBtn">추가</button>');
                });
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
            const workClassCd = $('#workClassCd').val();
            const workGroupCd = $('#workGroupCd').val();
            const sdate = $('#sdate').val()
            const note = $('#note').val();
            const param = $("#assignForm").serialize() + "&workClassCd=" + workClassCd + "&workGroupCd=" + workGroupCd + "&sdate=" + sdate + "&note=" + note;
            const result = ajaxCall("/WtmWorkTypeMgr.do?cmd=saveWtmWorkClassShiftTarget", param, false);

            if (result.Code > 0) {
                const modal = window.top.document.LayerModalUtility.getModal('wtmWorkClassShiftTargetLayer');
                modal.fire('wtmWorkClassShiftTargetLayerTrigger', '').hide();
            }
        });
    }

    function initAddTargetBtn(workClassCd) {
        $(".addTargetBtn").off('click').on('click', function () {
            const $li = $(this).closest('li.card-item');
            const sabun = $li.find('img').attr('src').split('searchKeyword=')[1];
            const type = $li.data('type');
            const oldGroupCd = getOldGroupCd(type, sabun, workClassCd);

            if (oldGroupCd === undefined) {
                return false;
            }

            $("#assignedWrap").show();
            $("#assignedListNone").hide();

            const seq = $("#assignedTargetCnt").text();
            const $assignWrap = $("#assignedWrap ul.card-list");
            const target = {
                enterCd: $li.find('img').attr('src').split('enterCd=')[1],
                name: $li.find('.name').text(),
                sabun: sabun,
                jikweeNm: $li.find('.position').text(),
                orgNm: $li.find('.team').text(),
                type: type,
                oldGroupCd: oldGroupCd
            }

            const assignedHtml = generateAssignedHtml(target, seq);
            $assignWrap.append(assignedHtml);

            $("#assignedTargetCnt").html(parseInt(seq) + 1);
            $(this).remove();
        });
    }

    function getOldGroupCd(type, sabun, workClassCd, workGroupCd) {
        const param = "&sabun=" + sabun
            + "&workClassCd=" + workClassCd;

        const oldGroup = ajaxCall("/WtmWorkTypeMgr.do?cmd=getWorkGroupEmpList", param, false).DATA;

        if (oldGroup.length < 1) {
            return '';
        }

        if (oldGroup[0].workGroupCd === workGroupCd) {
            return '';
        }

        const confirmAdd = confirm("이미 다른 근무조에 설정되어있습니다. 근무조를 변경하시겠습니까?");
        if (confirmAdd) {
            return oldGroup[0].workGroupCd;
        }
    }

    function setEmpData() {
        const workClassCd = $('#workClassCd').val();
        const workGroupCd = $('#workGroupCd').val();
        const searchKey = $('#searchKey').val();
        const sdate = $('#sdate').val();
        const params = 'workClassCd=' + workClassCd + '&workGroupCd=' + workGroupCd + '&searchKey=' + searchKey + '&sdate=' + sdate;
        const targetList = ajaxCall("/WtmWorkTypeMgr.do?cmd=getWtmWorkShiftTargetList", params, false).DATA;
        if (targetList.length < 1) {
            $("#unassignWrap").hide();
            $("#unassignListNone").show();
            return false;
        }
        $("#unassignWrap").show();
        $("#unassignListNone").hide();

        let targetHtml = '';
        const $targetList = $('#unassignList');
        const assignedTarget = [];
        $targetList.empty();
        targetList.forEach(target => {
            const dataId = target.sabun;
            const foundDataId = $('#assignedWrap .card-item').filter(function() {
                return $(this).data('id') === dataId;
            }).length > 0;

            let addBtn = '';
            if ((target.checkYn === 'N' && !foundDataId)
            || (searchKey !== '' && !foundDataId)) {
                addBtn = '<button class="btn filled addTargetBtn">추가</button>';
            }

            targetHtml += '<li class="card-item data-id="' + dataId + '" data-div="'+target.div+'">' +
                '<div class="img-wrap">' +
                '<img src="/EmpPhotoOut.do?enterCd=' + target.enterCd + '&searchKeyword=' + target.sabun + '">' +
                '</div>' +
                '<div class="info-wrap">' +
                '<div>' +
                '<span class="name">' + target.name + '</span><span class="position">' + target.jikweeNm + '</span>' +
                '</div>' +
                '<div class="team">' + target.orgNm + '</div>' +
                '</div>' +
                '<div class="btn-wrap">' + addBtn + '</div>' +
                '</li>';

            if (target.checkYn === 'Y') {
                assignedTarget.push(target);
            }
        });

        $targetList.append(targetHtml);
        initAddTargetBtn(workClassCd);

        return assignedTarget;
    }

    function setAssignedEmpData(assignedTargetList) {
        $("#assignedTargetCnt").html(assignedTargetList.length);
        if (assignedTargetList.length < 1) {
            $("#assignedWrap").hide();
            $("#assignedListNone").show();
            return false;
        }else{
            $("#assignedWrap").show();
            $("#assignedListNone").hide();
        }

        const $assignWrap = $("#assignedWrap ul.card-list");
        $assignWrap.empty();
        for (let i = 0; i < assignedTargetList.length; i++) {
            let target = assignedTargetList[i];
            let assignedHtml = generateAssignedHtml(target, i);
            $assignWrap.append(assignedHtml);
        }

    }

    function generateAssignedHtml(target, seq) {
        const dataId = target.sabun;
        return '<li class="card-item" data-id="' + dataId + '">' +
            '    <div class="item-header">' +
            '        <input type="checkbox" class="form-checkbox"/>' +
            '        <div class="img-wrap">' +
            '            <img src="/EmpPhotoOut.do?enterCd=' + target.enterCd + '&searchKeyword=' + target.sabun + '">' +
            '        </div>' +
            '        <div class="info-wrap">' +
            '            <div>' +
            '                <span class="name">' + target.name + '</span><span class="position">' + target.jikweeNm + '</span>' +
            '            </div>' +
            '            <div class="team">' + target.orgNm + '</div>' +
            '        </div>' +
            '    </div>' +
            ' <input type="hidden" name="targetList[' + seq + '].targetCd" value="' + target.sabun + '">' +
            ' <input type="hidden" name="targetList[' + seq + '].oldGroupCd" value="' + (target.oldGroupCd || '') + '">' +
            '</li>';
    }
</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
    <div class="modal_body memRegister-wrap pa-0">
        <div class="search-wrap">
            <!-- tab -->
            <ul class="tab_bottom">
                <li class="tab_menu active" id="tab1">대상자 검색</li>
            </ul>
            <div class="serarch-result-wrap active" id="tabContent1">
                <!-- search -->
                <div class="search_input">
                    <input class="form-input" type="text" placeholder="사번/성명을 입력하세요" id="searchKey"/>
                    <i class="mdi-ico" id="searchBtn">search</i>
                </div>

                <h2 class="title-wrap border-bottom">
                    <div class="inner-wrap">
                        <span class="page-title">검색 결과</span>
                    </div>
                </h2>
                <!-- 검색 결과 없을 때 -->
                <div class="list-none" id="unassignListNone" style="display: none;">
                    <i class="mdi-ico">search</i>
                    <p class="desc">선택된 대상자가 없습니다.</p>
                </div>
                <div class="unassign-list-wrap" id="unassignWrap">
                    <ul class="card-list" id="unassignList">
                        <!-- 반복 단위 -->
                    </ul>
                </div>
            </div>
        </div>
        <div class="memberList-wrap border-left">
            <h2 class="title-wrap">
                <div class="inner-wrap">
                    <span class="page-title">근무유형</span>
                </div>
            </h2>
            <div class="table-wrap">
                <table class="basic type5 line-grey">
                    <colgroup>
                        <col width="20%" />
                        <col width="80%" />
                    </colgroup>
                    <tbody>
                    <tr>
                        <th>시작일</th>
                        <td>
                            <div class="input-wrap">
                                <div class="date-wrap">
                                    <input class="form-input" id="sdate" name="sdate" type="text" value="${curSysYyyyMMddHyphen}" readonly/>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th>비고</th>
                        <td>
                            <div class="input-wrap" style="width: 280px;">
                                <input class="form-input" id="note" name="note" type="text" value="" />
                            </div>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <h2 class="title-wrap mt-24">
                <div class="inner-wrap">
                    <span class="page-title">선택한 대상자<strong class="ml-2 cnt"><span id="assignedTargetCnt"></span></strong><strong class="unit">명</strong></span>
                </div>
                <div class="btn-wrap">
                    <button class="btn outline" id="deleteTargetBtn">해제</button>
                </div>
            </h2>
            <!-- 리스트가 없을 때 -->
            <div class="list-none" id="assignedListNone" style="display: none;">
                <i class="mdi-ico">groups</i>
                <p class="desc">선택된 대상자가 없습니다.</p>
            </div>
            <!-- 리스트가 있을 때 -->
            <form name="assignForm" id="assignForm">
                <input type="hidden" id="workClassCd" name="workClassCd" />
                <input type="hidden" id="workGroupCd" name="workGroupCd" />
                <div class="unassign-list-wrap" id="assignedWrap">
                    <ul class="card-list">
                        <!-- 반복 단위 -->
                    </ul>
                </div>
            </form>
        </div>
    </div>
    <div class="modal_footer">
        <a class="btn filled" id="saveTargetBtn">저장</a>
        <a href="javascript:closeCommonLayer('wtmWorkClassShiftTargetLayer')" class="btn outline_gray">닫기</a>
    </div>
</div>
</body>
</html>



