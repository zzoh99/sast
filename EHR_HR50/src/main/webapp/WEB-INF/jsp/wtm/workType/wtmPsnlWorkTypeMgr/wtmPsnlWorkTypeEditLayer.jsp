<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp" %>
<!DOCTYPE html><html class="bodywrap"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp" %>
<script>
    $(document).ready(async function() {
        const modal = window.top.document.LayerModalUtility.getModal('wtmPsnlWorkTypeEditLayer');
        const params = modal.parameters;
        $('#searchDate').val(params.searchDate);
        $('#searchSabun').val(params.searchSabun);
        $('#oldClassCd').val(params.searchWorkClassCd);
        $('#oldGroupCd').val(params.searchWorkGroupCd);
        const editData = await getWtmPsnlWorkTypeMgrDet(params);
        $('#oldSdate').val(editData.sdate.replace(/\./g, "-"));
        initDetail(editData);
        addLayerEvents();
    });

    function initDetail(data) {
        $('.profile .name').text(data.name);
        $('.profile .team').text(data.orgNm);
        $('.profile .position.jikwee').text(data.jikweeNm);
        $('.profile .position.co-num').text(data.sabun);
        $('.profile img').attr('src', '${ctx}/EmpPhotoOut.do?enterCd=' + data.enterCd + '&sabun='+data.sabun);

        $('.det-work').text(data.workClassNm);
        console.log(data)
        if(data.workGroupCd && data.workGroupNm){
            $('.det-group').text(data.workGroupNm);
            $('.detGroup').show();
            $(".workGroupCd").show();
        }
        // detGroup
        $('.det-type').text(data.workTypeNm);
        $('.det-day').text(data.sdate + ' - ' + data.edate);
        $('.det-note').text(data.note);

        $('#searchSabun').val(data.sabun);
        const workClassCdList = ajaxCall("/WtmPsnlWorkTypeMgr.do?cmd=getWtmPsnlWorkClassCdList", "", false).DATA;
        workClassCdList.forEach(function(item){
            let comboHtml = '<option value="' + item.workClassCd + '" ';
            if(data.workClassCd == item.workClassCd){
                comboHtml += 'selected' ;
                setWorkGroup(item.workClassCd);
            }
            comboHtml += '>' ;
            comboHtml += item.workClassNm ;
            comboHtml += '</option>';
            $('#workClassCd').append(comboHtml);
        })

        $('#sdate').datepicker2({});
        $('#sdate').val(data.sdate.replace(/\./g, "-"));

        $('#edate').datepicker2({
            enddate: 'sdate'
        });
        $('#edate').val(data.edate.replace(/\./g, "-"));

        $("#untilNextWorkYn").on("change", function() {
            if ($(this).is(":checked")) {
                $("#edate").val("").parent().hide();
            } else {
                $("#edate").val($("#sdate").val()).parent().show();
            }
        })
        $('#note').val(data.note);

        $('#workClassCd').change(function(){
            const workClassCd = $(this).val();
            const workTypeCd = workClassCd.substring(0, 1);
            setWorkGroup(workClassCd);
            if(workTypeCd == 'D') {
                $('.workGroupCd').show();
            }else{
                $('.workGroupCd').hide();
            }
        })

        function setWorkGroup(workClassCd){
            $('#workGroupCd').html('<option value="">선택</option>');
            const workGroupCdList = ajaxCall("/WtmPsnlWorkTypeMgr.do?cmd=getWtmPsnlWorkGroupCdList", "workClassCd=" + workClassCd, false).DATA;
            workGroupCdList.forEach(function(item){
                let comboHtml = '<option value="' + item.workGroupCd + '" ';
                if(data.workGroupCd == item.workGroupCd){
                    comboHtml += 'selected' ;
                }
                comboHtml += '>' ;
                comboHtml += item.workGroupNm ;
                comboHtml += '</option>';
                $('#workGroupCd').append(comboHtml);
            })
        }

    }

    async function getWtmPsnlWorkTypeMgrDet(params) {
        const data = await callFetch("${ctx}/WtmPsnlWorkTypeMgr.do?cmd=getWtmPsnlWorkTypeMgrDet", new URLSearchParams(params).toString());
        if (data.isError) {
            alert(data.errMsg);
            return null;
        }

        return data.DATA;
    }

    async function saveEdit(){
        try {
            progressBar(true, '저장중입니다.');
            // 저장 처리
            const result = await callFetch("/WtmPsnlWorkTypeMgr.do?cmd=saveWtmPsnlWorkTypeMgr", $("#saveForm").serialize());
            if (result.isError) {
                alert(result.errMsg);
                return;
            }

            if (result.DATA.Code > 0) {
                if (result.Message) {
                    alert(result.Message);
                    const modal = window.top.document.LayerModalUtility.getModal('wtmPsnlWorkTypeEditLayer');
                    modal.fire('wtmPsnlWorkTypeEditLayerTrigger', '').hide();
                }
            }
        } catch (error) {
            console.error('저장 중 오류 발생:', error);
            alert('저장 중 오류가 발생했습니다.');
        } finally {
            progressBar(false);
        }
    }

    function addLayerEvents() {

        $('#modBtn').click(function(){
            $(this).parent().hide();
            $('#editDet').hide();
            $("#noEditBtn").hide();
            $('#editMod').show();
            $("#onEditBtn").show();
        })

        $("#btnClose").click(function(){
            closeModal();
        })

        $("#btnSave").on("click", function() {
            saveEdit();
        })

        $("#btnCancel").on("click", function() {
            cancelEdit();
        })
    }

    function cancelEdit() {
        $("#modBtn").parent().show();
        $('#editMod').hide();
        $("#onEditBtn").hide();
        $('#editDet').show();
        $("#noEditBtn").show();
    }

    function closeModal() {
        const modal = window.top.document.LayerModalUtility.getModal('wtmPsnlWorkTypeEditLayer');
        modal.hide();
    }
</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
    <div class="modal_body">
        <h2 class="title-wrap">
            <div class="inner-wrap">
                <span class="page-title">기존설정내용</span>
            </div>
            <div class="btn-wrap">
                <button type="button" id="modBtn" class="btn outline icon_text"><i class="mdi-ico filled">settings</i>근무유형 변경</button>
            </div>
        </h2>
        <div class="table-wrap" id="editDet">
            <table class="basic type5 line-grey">
                <colgroup>
                    <col width="20%" />
                    <col width="80%" />
                </colgroup>
                <tbody>
                <tr>
                    <th colspan="2">
                        <div class="profile">
                            <div class="img-wrap">
                                <img src="">
                            </div>
                            <div class="info-wrap">
                                <div class="info">
                                    <span class="name"></span>
                                    <span class="position jikwee"></span>
                                    <span class="divider"></span>
                                    <span class="position co-num"></span>
                                </div>
                                <div class="team"></div>
                            </div>
                        </div>
                    </th>
                </tr>
                <tr>
                    <th>근무유형</th>
                    <td class="det-work"></td>
                </tr>
                <tr class="detGroup" style="display: none">
                    <th>근무조</th>
                    <td class="det-group"></td>
                </tr>
                <tr>
                    <th>기간</th>
                    <td class="det-day"></td>
                </tr>
                <tr>
                    <th>비고</th>
                    <td class="det-note"></td>
                </tr>
                </tbody>
            </table>
        </div>
        <div class="table-wrap" id="editMod" style="display: none">
            <form id="saveForm" name="saveForm" >
                <input type="hidden" id="oldClassCd" name="oldClassCd" />
                <input type="hidden" id="oldGroupCd" name="oldGroupCd" />
                <input type="hidden" id="oldSdate" name="oldSdate" />
                <input type="hidden" id="searchSabun" name="searchSabun" />
                <input type="hidden" id="searchDate" name="searchDate" />
                <table class="basic type5 line-grey">
                    <colgroup>
                        <col width="20%" />
                        <col width="80%" />
                    </colgroup>
                    <tbody>
                    <tr>
                        <th colspan="2">
                            <div class="profile">
                                <div class="img-wrap">
                                    <img src="">
                                </div>
                                <div class="info-wrap">
                                    <div class="info">
                                        <span class="name"></span>
                                        <span class="position jikwee"></span>
                                        <span class="divider"></span>
                                        <span class="position co-num"></span>
                                    </div>
                                    <div class="team"></div>
                                </div>
                            </div>
                        </th>
                    </tr>
                    <tr>
                        <th>근무유형</th>
                        <td>
                            <div class="input-wrap" style="width: 280px;">
                                <select class="custom_select" id="workClassCd" name="workClassCd">
                                    <option value="">선택</option>
                                </select>
                            </div>
                        </td>
                    </tr>
                    <tr class="workGroupCd" style="display: none">
                        <th>근무조</th>
                        <td>
                            <div class="input-wrap" style="width: 280px;">
                                <select class="custom_select" id="workGroupCd" name="workGroupCd">
                                    <option value="">선택</option>
                                </select>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th>시작일</th>
                        <td>
                            <div class="input-wrap">
                                <div class="date-wrap">
                                    <input class="form-input" id="sdate" name="sdate" type="text">
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th>종료일</th>
                        <td>
                            <div class="input-wrap">
                                <div class="date-wrap">
                                    <input class="form-input" id="edate" name="edate" type="text">
                                </div>
                                <input type="checkbox" class="form-checkbox" id="untilNextWorkYn" name="untilNextWorkYn" value="Y" />
                                <label for="untilNextWorkYn">직후 근무유형 전까지</label>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th>비고</th>
                        <td>
                            <div class="input-wrap" style="width: 280px;">
                                <input class="form-input" id="note" name="note" type="text" value="">
                            </div>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </form>
        </div>
    </div>
    <div class="modal_footer">
        <div id="onEditBtn" style="display: none">
            <a id="btnCancel" class="btn outline_gray">변경취소</a>
            <a id="btnSave" class="btn filled">저장</a>
        </div>
        <div id="noEditBtn">
            <a id="btnClose" class="btn outline_gray">확인</a>
        </div>
    </div>
</div>
</body>
</html>