<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp" %>
<!DOCTYPE html>
<html class="bodywrap">
<head>
    <!-- 개별 화면 script -->
    <script>
        $(document).ready(async function () {
            const modal = window.top.document.LayerModalUtility.getModal('wtmPsnlWorkTypeTargetLayer');
            createIBSheet3(document.getElementById('orgSheet-wrap'), "orgSheet", "100%", "100%", "${ssnLocaleCd}");
            const workClassCd = modal.parameters.workClassCd || '';
            initEvent(workClassCd);
            await init(workClassCd);
            if(workClassCd){
               $('.workType').hide();
            }
        });
        $(document).ready( function () {
            //스크롤시 이미지 lazy 적용
            $('#unassignWrap').on('scroll', function() {
                cardLazy();
            });
        });

        async function init(workClassCd, workGroupCd){
            initOrgSheet();
            initType(workClassCd, workGroupCd);

            const assignedTargetList = await setEmpData(workClassCd, workGroupCd, "");
            setAssignedEmpData(assignedTargetList);
            cardLazy();
            doAction2('Search', workClassCd, workGroupCd)
        }

        function initType(workClassCd, workGroupCd){
            $('.workGroupCd').hide();
            $('#workGroupCd').html('');
            const workClassCdList = ajaxCall("/WtmPsnlWorkTypeMgr.do?cmd=getWtmPsnlWorkClassCdList", "", false).DATA;
            let comboHtml = '<option value="">선택</option>';
            workClassCdList.forEach(function(item){
                comboHtml += '<option value="' + item.workClassCd + '" ';
                if(workClassCd == item.workClassCd){
                    comboHtml += 'selected' ;
                    if(item.workTypeCd == 'D'){
                        const workGroupCdList = ajaxCall("/WtmPsnlWorkTypeMgr.do?cmd=getWtmPsnlWorkGroupCdList", "workClassCd=" + workClassCd, false).DATA;
                        let groupHtml = '<option value="">선택</option>';
                        workGroupCdList.forEach(function(group){
                            groupHtml += '<option value="' + group.workGroupCd + '" ';
                            if(workGroupCd == group.workGroupCd){
                                groupHtml += 'selected' ;
                            }
                            groupHtml += '>' + group.workGroupNm + '</option>';
                        });
                        $('#workGroupCd').html(groupHtml);
                        $('.workGroupCd').show();
                    }
                }
                comboHtml += '>' ;
                comboHtml += item.workClassNm;
                comboHtml += '</option>';
            })
            $('#workClassCd').html(comboHtml);
        }

        function initOrgSheet() {
            let initdata = {};
            initdata.Cfg = {
                SearchMode: smLazyLoad,
                ChildPage: 22,
                AutoFitColWidth: 'init|search|resize|rowtransaction'
            };
            initdata.HeaderMode = {Sort: 1, ColMove: 1, ColResize: 1, HeaderCheck: 0};
            initdata.Cols = [
                {Header: "상위부서코드", Type: "Text", Hidden: 1, Width: 100, Align: "Center", SaveName: "priorOrgCd", Edit: 0},
                {Header: "조직트리", Type: "Text", Hidden: 0, Width: 100, Align: "Left", SaveName: "orgNm", Edit: 0, TreeCol: 1},
                {Header: "enterCd", Type: "Text", Hidden: 1, Width: 100, Align: "Center", SaveName: "enterCd", Edit: 0},
                {Header: "상위부서명", Type: "Text", Hidden: 1, Width: 100, Align: "Center", SaveName: "priorOrgNm", Edit: 0},
                {Header: "부서코드", Type: "Text", Hidden: 1, Width: 100, Align: "Center", SaveName: "orgCd", Edit: 0},
                {Header: "ID", Type: "Text", Hidden: 1, Width: 100, Align: "Center", SaveName: "dataId", Edit: 0},
                {Header: "추가", Type: "CheckBox", Hidden: 0, Width: 70, Align: "Center", ColMerge: 1, SaveName: "checkYn", KeyField: 0, CalcLogic: "", Format: "", PointCount: 0, UpdateEdit: 1, InsertEdit: 1, EditLen: 1, TrueValue: "Y", FalseValue: "N"},
                {Header: "추가", Type: "CheckBox", Hidden: 1, Width: 70, Align: "Center", ColMerge: 1, SaveName: "checkedYn", KeyField: 0, CalcLogic: "", Format: "", PointCount: 0, UpdateEdit: 1, InsertEdit: 1, EditLen: 1, TrueValue: "Y", FalseValue: "N"}
            ];
            IBS_InitSheet(orgSheet, initdata);
            // sheet 높이 계산
            let orgSheetHeight = $(".modal_body").height() - $(".tab_bottom").height() - $(".sheet_title").height() - 2;
            orgSheet.SetSheetHeight(orgSheetHeight);

            orgSheet.SetVisible(true);
            orgSheet.SetEditableColorDiff(0); //편집불가 상관없이 기본색상 출력
            orgSheet.SetSelectionMode(1);
            orgSheet.SetWaitImageVisible(0);
            orgSheet.SetFocusAfterProcess(0);
            //orgSheet.FitColWidth();

            $(window).smartresize(sheetResize);
            sheetInit();
        }

        function doAction2(sAction, workClassCd, workGroupCd) {
            switch (sAction) {
                case "Search":
                    let params = '';
                    params += 'workClassCd=' + workClassCd;
                    params += '&searchDate=' + $('#searchDate').val();
                    if(workGroupCd){
                        params += '&workGroupCd=' + workGroupCd;
                    }

                    orgSheet.DoSearch("${ctx}/WtmPsnlWorkTypeMgr.do?cmd=getWtmPsnlWorkTargetOrgList", params);
                    break;
            }
        }

        function orgSheet_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
            try {
                selectSheet = orgSheet;

                if (OldRow != NewRow) {
                    $("#orgCd").val(orgSheet.GetCellValue(NewRow, "orgCd"));
                    $("#name").val("");
                    $("#orgNm").val("");
                }
            } catch (ex) {
                alert("OnSelectCell Event Error " + ex);
            }
        }

        function orgSheet_OnChange(Row, Col, Value) {
            try {
                if (orgSheet.ColSaveName(Col) == "checkYn") {
                    var children = orgSheet.GetChildRows(Row).split("|");

                    for (var i = 0; i < children.length; i++) {
                        orgSheet.SetCellValue(children[i], "checkYn", orgSheet.GetCellValue(Row, "checkYn"));
                    }
                }
            } catch (ex) {
                alert("OnSelectCell Event Error " + ex);
            }
        }

        // 조회 후 에러 메시지
        function orgSheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
            try {
                if (Msg != "") {
                    alert(Msg);
                }
                // for(var i = orgSheet.HeaderRows(); i < orgSheet.RowCount()+orgSheet.HeaderRows() ; i++) {
                //     if( orgSheet.GetCellValue(i, "checkedYn") === "Y" ){
                //         orgSheet.SetCellEditable(i, "checkYn", 0);
                //     }
                // }
                //
                // orgSheet.SetFocusAfterProcess(0);
                // sheetResize();
                // $("#name").focus();
            } catch (ex) {
                alert("OnSearchEnd Event Error : " + ex);
            }
        }

        function initEvent(workClassCd) {
            $('#searchDate').datepicker2({
                searchDate: 'searchDate',
                onReturn:function(){
                    //리스트 초기화
                    $("#assignedWrap ul.card-list").html('');
                    init($('#workClassCd').val(), $("#workGroupCd").val());
                }
            });

            $("#workGroupCd").on('change', async function () {
                await init($("#workClassCd").val(), $(this).val());

                await setEmpData($("#workClassCd").val(), $("#workGroupCd").val(), $("#searchKey").val());
                cardLazy();

                // const workClassCd = $("#workClassCd").val();
                // const workGroupCd = $(this).val();
                //
                // initOrgSheet();
                // initType(workClassCd, workGroupCd);
                // const assignedTargetList = await setEmpData($("#workClassCd").val(), $("#workGroupCd").val(), $('#searchKey').val());
                // setAssignedEmpData(assignedTargetList);
                // cardLazy();
                // doAction2('Search', workClassCd, workGroupCd)
            });

            $("#workClassCd").on('change', async function () {
                $('#searchKey').val('');
                await init($(this).val(), $("#workGroupCd").val());
            });

            $("#searchBtn").on('click', async function () {
                await setEmpData($("#workClassCd").val(), $("#workGroupCd").val(), $("#searchKey").val());

                cardLazy();
            });

            $('#searchKey').on('keypress', async function (event) {
                if (event.which === 13) {
                    event.preventDefault();
                    await setEmpData($("#workClassCd").val(), $("#workGroupCd").val(), $('#searchKey').val());

                    cardLazy();
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
                let searchSabun = [];
                $('#assignedWrap .card-item').filter(function() {
                    return $(this).find('.form-checkbox').is(':checked');
                }).each(function() {
                    const dataId = $(this).data('id');
                    const targetCd = $(this).find('input[type=hidden]:eq(0)').val()
                    searchSabun.push(targetCd)
                    $(this).remove();
                    removedCount++;

                    $('#unassignWrap .card-item').filter(function() {
                        return $(this).data('id') === dataId;
                    }).each(function() {
                        $(this).find('.btn-wrap').append('<button type="button" class="btn filled addTargetBtn" onClick="javascript:addTargetBtn(\'' + workClassCd + '\', \'' + $('#workGroupCd').val() + '\', \'' + targetCd + '\');">추가</button>');
                    });
                });
                const params = {
                    searchSabun: JSON.stringify(searchSabun),
                    workClassCd: $("#workClassCd").val(),
                    workGroupCd: $("#workGroupCd").val(),
                    sdate: $("#searchDate").val(),
                }
                const result = ajaxCall("/WtmPsnlWorkTypeMgr.do?cmd=deleteWtmPsnlWorkClassTarget", params, false);

                const seq = $("#assignedTargetCnt").text();
                const assignedCnt = parseInt(seq) - removedCount;
                $("#assignedTargetCnt").html(assignedCnt);

                if (assignedCnt === 0) {
                    $("#assignedWrap").hide();
                    $("#assignedListNone").show();
                }
            });

            $("#saveTargetBtn").on('click', function (){
                let param = $("#assignForm").serialize();
                param += "&workClassCd=" + $('#workClassCd').val();
                param += "&searchDate=" + $('#searchDate').val();
                param += "&note=" + $('#note').val();
                if($('#workGroupCd').val()){
                    param += "&workGroupCd=" + $('#workGroupCd').val();
                }

                const result = ajaxCall("/WtmPsnlWorkTypeMgr.do?cmd=saveWtmPsnlWorkTarget", param, false);

                if (result.Code > 0) {
                    const modal = window.top.document.LayerModalUtility.getModal('wtmPsnlWorkTypeTargetLayer');
                    modal.fire('wtmPsnlWorkTypeTargetLayerTrigger', '').hide();
                }
            });
            $("#closeTargetBtn").on('click', function (){
                const modal = window.top.document.LayerModalUtility.getModal('wtmPsnlWorkTypeTargetLayer');
                modal.fire('wtmPsnlWorkTypeTargetLayerTrigger', '').hide();
            });

            $("#addOrgBtn").on('click', function () {
                const checkedOrgs = orgSheet.FindCheckedRow("checkYn");
                const searchDate = $('#searchDate').val();
                const workGroupCd = $('#workGroupCd').val();
                const workClassCd = $('#workClassCd').val();

                if(workClassCd === '' || workClassCd == null) {
                    alert('선택한 조직이 없습니다.');
                    return;
                }

                if(workGroupCd != null && workGroupCd =='') {
                    alert('선택한 근무조가 없습니다.');
                    return;
                }

                if(searchDate === '' || searchDate == null) {
                    alert('시작일을 입력해주세요.');
                    return;
                }

                let sabunList = [];
                checkedOrgs.split("|").map(function (rowIndex) {
                    const org = orgSheet.GetRowData(rowIndex);
                    if (org.checkedYn !== 'Y' && org.dataId !== '') {
                        sabunList.push(org.orgCd)
                    }
                });
                //openlayer
                //레이어 생성
                const params = {
                    workClassCd: workClassCd,
                    workGroupCd: workGroupCd,
                    sabun: sabunList
                }
                let layerModal = new window.top.document.LayerModal({
                    id : 'wtmPsnlWorkTypeAddTargetLayer' //식별자ID
                    , url : '/WtmPsnlWorkTypeMgr.do?cmd=viewWtmPsnlWorkTypeAddTargetLayer' //팝업에 띄울 화면 jsp
                    , parameters: params
                    , width : 400
                    , height : 400
                    , title : '대상자 추가'
                    , trigger :[ //콜백
                        {
                            name : 'wtmPsnlWorkTypeAddTargetLayerTrigger'
                            , callback : function(result){
                                init(workClassCd, workGroupCd);
                            }
                        }
                    ]
                });
                layerModal.show();
            });

        }

        function addTargetBtn(workClassCd, workGroupCd, sabun) {
            if(workClassCd == null || workClassCd == ''){
                alert('근무유형을 선택해주세요.')
                return;
            }
            if(workClassCd.substring(0,1) == 'D' && (workGroupCd == null || $('#workGroupCd').val() == '')){
                alert('근무조를 선택해주세요.')
                return;
            }
            //레이어 생성
            const params = {
                workClassCd: workClassCd,
                workGroupCd: workGroupCd,
                sabun: [sabun]
            }
            let layerModal = new window.top.document.LayerModal({
                id : 'wtmPsnlWorkTypeAddTargetLayer' //식별자ID
                , url : '/WtmPsnlWorkTypeMgr.do?cmd=viewWtmPsnlWorkTypeAddTargetLayer' //팝업에 띄울 화면 jsp
                , parameters: params
                , width : 400
                , height : 400
                , title : '대상자 추가'
                , trigger :[ //콜백
                    {
                        name : 'wtmPsnlWorkTypeAddTargetLayerTrigger'
                        , callback : function(result){
                            init(workClassCd, workGroupCd);
                        }
                    }
                ]
            });
            layerModal.show();

            //저장 후 추가
            //drawAddTarget(workClassCd);
        }

        function getOldClassCd(type, targetCd, workClassCd, searchDate) {
            const param = "&targetCd=" + targetCd
                + "&type=" + type
                + "&searchDate=" + searchDate;
            const oldClass = ajaxCall("/WtmPsnlWorkTypeMgr.do?cmd=getWorkClassEmpList", param, false).DATA;

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
            const targetSdate = $('#searchDate').val().replace(/-/g,'');

            const dateObj = new Date(targetSdate.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3'));
            const newEdate = new Date(dateObj.setDate(dateObj.getDate() - 1)).toISOString().slice(0,10).replace(/-/g,'');

            if(!compareDates(oldClass[0].searchDate, newEdate)) {
                alert('기존 근무 유형의 기간을 ' + formatDate(oldClass[0].searchDate,"-") + ' ~ ' + formatDate(newEdate,"-") + '으로 변경할 수 없습니다.');
                return;
            }

            if (confirmAdd) {
                return oldClass[0].workClassCd;
            }
        }

        // 날짜 비교 (근무유형의 기간 유효성을 체크하기 위함)
        function compareDates(searchDate, edate) {
            // 날짜 형식을 YYYYMMDD에서 YYYY-MM-DD로 변환
            const sDateFormatted = searchDate.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3');
            const eDateFormatted = edate.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3');

            // Date 객체로 변환
            const sDateObj = new Date(sDateFormatted);
            const eDateObj = new Date(eDateFormatted);

            // 날짜 비교 (edate가 sdate보다 이후인지)
            return eDateObj >= sDateObj;
        }

        async function setEmpData(pWorkClassCd, pWorkGroupCd, pSearchKey) {
            const workClassCd = pWorkClassCd?pWorkClassCd:''
            const workGroupCd = pWorkGroupCd?pWorkGroupCd:''
            const searchKey = pSearchKey?pSearchKey:''
            try {
                progressBar(true);

                let params = '';
                params += 'workClassCd=' + workClassCd;
                params += '&searchDate=' + $('#searchDate').val();
                params += '&searchKey=' + searchKey;
                params += '&workGroupCd=' + workGroupCd;

                const response = await fetch("/WtmPsnlWorkTypeMgr.do?cmd=getWtmPsnlWorkTargetList", {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: params
                });
                const targetList = (await response.json()).DATA

                const $targetList = $('#unassignList');
                $targetList.empty();

                if (targetList.length < 1) {
                    $("#unassignWrap").hide();
                    $("#unassignListNone").show();
                    return false;
                }
                $("#unassignWrap").show();
                $("#unassignListNone").hide();

                let targetHtml = '';
                const assignedTarget = [];
                targetList.forEach(target => {
                    const dataId = target.type + '|' + target.targetCd;
                    const foundDataId = $('#assignedWrap .card-item').filter(function() {
                        return $(this).data('id') === dataId;
                    }).length > 0;


                    let addBtn = '';
                    if ((target.checkYn === 'N')) {
                        addBtn = '<button type="button" class="btn filled addTargetBtn" onClick="javascript:addTargetBtn(\'' + workClassCd + '\', \'' + workGroupCd + '\', \'' + target.targetCd + '\');">추가</button>';
                    }

                    targetHtml += '<li class="card-item" data-type="' + target.type + '" data-id="' + dataId + '">' ;
                    targetHtml += '<div class="img-wrap">' ;
                    targetHtml += '<img class="lazy" data-src="/EmpPhotoOut.do?enterCd=' + target.enterCd + '&searchKeyword=' + target.targetCd + '" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///ywAAAAAAQABAAACAUwAOw==">';
                    targetHtml += '</div>' ;
                    targetHtml += '<div class="info-wrap">' ;
                    targetHtml += '<div>' ;
                    targetHtml += '<span class="name">' + target.targetNm + '</span><span class="position">' + target.note1 + '</span>' ;
                    targetHtml += '</div>' ;
                    targetHtml += '<div class="team">' + target.note2 + '</div>' ;
                    targetHtml += '</div>' ;
                    targetHtml += '<div class="btn-wrap">' + addBtn + '</div>' ;
                    targetHtml += '</li>';

                    if (target.checkYn === 'Y') {
                        target.readonly = true; // DB 저장된 대상자의 searchDate 변경을 막기 위한 속성
                        assignedTarget.push(target);
                    }
                });
                $targetList.html(targetHtml);
                return assignedTarget;
            } catch (error) {
                console.error('조회 중 오류 발생:', error);
                alert('조회 중 오류가 발생했습니다.');
            } finally {
                progressBar(false);
            }
        }

        function setAssignedEmpData(assignedTargetList) {
            $("#assignedTargetCnt").html(assignedTargetList.length);
            const $assignWrap = $("#assignedWrap ul.card-list");
            $assignWrap.empty();
            if (assignedTargetList.length < 1) {
                $("#assignedWrap").hide();
                $("#assignedListNone").show();
                return false;
            }else{
                $("#assignedWrap").show();
                $("#assignedListNone").hide();
            }

            for (let i = 0; i < assignedTargetList.length; i++) {
                let target = assignedTargetList[i];
                let assignedHtml = generateAssignedHtml(target, i);
                $assignWrap.append(assignedHtml);
            }
        }

        function generateAssignedHtml(target, seq) {
            const dataId = target.type + '|' + target.targetCd;
            let result = '';
            result += '<li class="card-item" data-id="' + dataId + '">' ;
            result += '    <div class="item-header">' ;
            result += '        <input type="checkbox" class="form-checkbox"/>' ;
            result += '        <div class="img-wrap">' ;
            result += '            <img class="lazy" data-src="/EmpPhotoOut.do?enterCd=' + target.enterCd + '&searchKeyword=' + target.targetCd + '" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///ywAAAAAAQABAAACAUwAOw==">' ;
            result += '        </div>' ;
            result += '        <div class="info-wrap">' ;
            result += '            <div>' ;
            result += '                <span class="name">' + target.targetNm + '</span><span class="position">' + target.note1 + '</span>' ;
            result += '            </div>' ;
            result += '            <div class="team">' + target.note2 + '</div>' ;
            result += '        </div>' ;
            result += '    </div>' ;
            result += ' <input type="hidden" name="targetList[' + seq + '].targetCd" value="' + target.targetCd + '">' ;
            result += ' <input type="hidden" name="targetList[' + seq + '].type" value="' + target.type + '">' ;
            result += ' <input type="hidden" id="targetList[' + seq + '].oldClassCd" name="targetList[' + seq + '].oldClassCd" value="' + (target.oldClassCd || '') + '">' ;
            result += '</li>';
            return result;
        }

        function getTodayDate() {
            const today = new Date();
            const year = today.getFullYear();
            const month = String(today.getMonth() + 1).padStart(2, '0');
            const day = String(today.getDate()).padStart(2, '0');
            return year + '-' + month + '-' + day;
        }

        function drawAddTarget(workClassCd) {
            const $li = $(this).closest('li.card-item');
            const targetCd = $li.find('img').attr('src').split('searchKeyword=')[1];
            const type = $li.data('type');
            const dataId = $li.data('id');
            const searchDate = $('#searchDate').val();

            if(workClassCd === '' || workClassCd == null) {
                alert('근무유형을 선택해주세요.');
                return;
            }

            if(searchDate === '' || searchDate == null) {
                alert('시작일을 입력해주세요.');
                return;
            }

            $("#assignedWrap").show();
            $("#assignedListNone").hide();

            const seq = $("#assignedTargetCnt").text();
            const $assignWrap = $("#assignedWrap ul.card-list");
            const target = {
                enterCd: $li.find('img').attr('data-src').split('enterCd=')[1],
                targetNm: $li.find('.name').text(),
                targetCd: targetCd,
                note1: $li.find('.position').text(),
                note2: $li.find('.team').text(),
                type: type,
                // oldClassCd: oldClassCd
            }

            const assignedHtml = generateAssignedHtml(target, seq);
            $assignWrap.append(assignedHtml);
            $('li[data-id="'+target.type + '|' + target.targetCd+'"] .collpaseButton').click();

            $("#assignedTargetCnt").html(parseInt(seq) + 1);
            $(this).remove();

            const orgRow = orgSheet.FindText("dataId", dataId);
            // if (orgRow !== -1) {
            //     orgSheet.SetCellValue(orgRow, "checkYn", "Y");
            //     orgSheet.SetCellValue(orgRow, "checkedYn", "Y");
            //     orgSheet.SetCellEditable(orgRow, "checkYn", 0);
            // }
        }

        function cardLazy(){
            $('#unassignWrap .lazy:not(.lazy-loaded)').each(function () {
                const $img = $(this);
                const rect = this.getBoundingClientRect();
                if (rect.top < window.innerHeight + 200) {
                    $img.attr('src', $img.data('src')).addClass('lazy-loaded');
                }
            });
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
                <li class="tab_menu" id="tab2">조직도</li>
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
            <!-- 조직도 -->
            <div class="serarch-result-wrap" id="tabContent2" style="display: none;">
                <table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
                    <tr>
                        <td id="orgMain" class="sheet_left w25p">
                            <div class="inner">
                                <div class="sheet_title">
                                    <ul>
                                        <li class="txt">조직도</li>
                                        <li class="btn">
                                            <btn:a css="btn filled" mid="110708" id="addOrgBtn" mdef="추가"/>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                            <div id="orgSheet-wrap"></div>
                        </td>
                    </tr>
                </table>
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
                    <tr class="workType">
                        <th>근무유형</th>
                        <td>
                            <div class="input-wrap" style="width: 280px;">
                                <select class="custom_select" id="workClassCd" name="workClassCd">
                                </select>
                            </div>
                        </td>
                    </tr>
                    <tr class="workGroupCd">
                        <th>근무조</th>
                        <td>
                            <div class="input-wrap" style="width: 80px;">
                                <select class="custom_select" id="workGroupCd" name="workGroupCd">
                                </select>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th>시작일</th>
                        <td>
                            <div class="input-wrap">
                                <div class="date-wrap">
                                    <input class="form-input" id="searchDate" name="searchDate" type="text" value="${curSysYyyyMMddHyphen}" readonly/>
                                </div>
                            </div>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <h2 class="title-wrap mt-24">
                <div class="inner-wrap">
                    <span class="page-title">선택한 대상자<strong class="ml-2 cnt"><span
                            id="assignedTargetCnt"></span></strong><strong class="unit">명</strong></span>
                </div>
                <div class="btn-wrap">
                    <button type="button" class="btn outline" id="deleteTargetBtn">해제</button>
                </div>
            </h2>
            <!-- 리스트가 없을 때 -->
            <div class="list-none" id="assignedListNone" style="display: none;">
                <i class="mdi-ico">groups</i>
                <p class="desc">선택된 대상자가 없습니다.</p>
            </div>
            <!-- 리스트가 있을 때 -->
            <form name="assignForm" id="assignForm">
                <div class="unassign-list-wrap" id="assignedWrap">
                    <ul class="card-list">
                        <!-- 반복 단위 -->
                    </ul>
                </div>
            </form>
        </div>
    </div>
    <div class="modal_footer">
<%--        <a href="#" class="btn filled" id="saveTargetBtn">저장</a>--%>
        <a href="#" class="btn filled" id="closeTargetBtn">닫기</a>
    </div>
</div>
</body>
</html>



