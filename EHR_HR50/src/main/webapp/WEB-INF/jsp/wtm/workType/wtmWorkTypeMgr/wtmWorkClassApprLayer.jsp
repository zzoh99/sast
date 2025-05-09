<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp" %>
<!DOCTYPE html>
<html class="bodywrap"><head>
<link rel="stylesheet" type="text/css" href="/assets/css/attendanceNew.css"/>

<!-- 개별 화면 script -->
<script>
    $(document).ready(function () {
        const modal = window.top.document.LayerModalUtility.getModal('wtmWorkClassApprLayer');
        const workClassCd = modal.parameters.workClassCd || '';
        const applCd = modal.parameters.applCd || '';
        $("#workClassCd").val(workClassCd);

        initData(applCd);
        initEvent();
    });

    function initData(applCd) {
        const orgLevelCdList = convCodeIdx(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "W82020"), "", -1);
        $("#orgLevelCd").append(orgLevelCdList);

        const appCodeList = ajaxCall("/WtmWorkTypeMgr.do?cmd=getWtmWorkClassApplCdList", '', false).DATA;
        let appCodeHtml = '';
        appCodeList.forEach(code => {
            const isSelected = code.applCd === applCd ? 'selected' : '';
            appCodeHtml += '<option value="' + code.applCd + '" ' + isSelected + '>' + code.applNm + '</option>'

            if (code.applCd === applCd) {
                setApplData(code);
                $(".desc").hide();
                $("#appCodeMgrBtn").prop('disabled', false);
            }
        });

        $("#applCdForm #applCd").append(appCodeHtml);
    }

    function setApplData(code) {
        $("#applNm").val(code.applNm);
        $("#applTitle").val(code.applTitle);
        $('#fileYn').prop('checked', code.fileYn === "Y");
        $("#orgLevelCd").val(code.orgLevelCd);
        $("#etcNote").val(code.etcNote);
        $("#fileSeq").val(code.fileSeq);
    }

    function initEvent() {
        $("#detailBtn").on('click', function () {
            const selectedValue = $("#applCdForm #applCd option:selected").val();
            if (selectedValue === '') {
                alert("신청서 상세 설정은 신청서코드 생성 후 이동 가능합니다.");
                return false;
            }

            const modal = window.top.document.LayerModalUtility.getModal('wtmWorkClassApprLayer');
            modal.hide();

            goOtherSubPage("", "", "", "", "AppCodeMgr.do?cmd=viewAppCodeMgr");
        });

        $("input:checkbox").change(function(){
            if(this.checked){
                $(this).attr('value', 'Y');
            }else{
                $(this).attr('value', 'N');
            }
        });

        $("#saveApplCdBtn").on('click', function () {
            const result = ajaxCall("/WtmWorkTypeMgr.do?cmd=saveWtmWorkClassApplCd", $("#applCdForm").serialize(), false);
            if(result.Code > 0) {
                alert(result.Message);

                const applCd = result.ApplCd;
                const modal = window.top.document.LayerModalUtility.getModal('wtmWorkClassApprLayer');
                modal.fire('wtmWorkClassApprLayerTrigger', {applCd : applCd}).hide();
            }
        });

        $("#applCdForm #applCd").on('change', function () {
            const selectedApplCd = $(this).val();
            let code = {};
            if (applCd === '') {
                code = {
                    applNm: '',
                    applTitle: '',
                    fileYn: 'N',
                    orgLevelCd: '0'
                };
                $('.desc').show();
            } else {
                const param = "srchUseYn=Y&appCd=" + selectedApplCd;
                const appCodeList = ajaxCall("/AppCodeMgr.do?cmd=getAppCodeMgrList", param, false).DATA;
                code = appCodeList[0];
                $('.desc').hide();
                $("#appCodeMgrBtn").prop('disabled', false);
            }

            setApplData(code);
        });

        $("#appCodeMgrBtn").on('click', function (e){
            e.preventDefault();
            const url 	= "/AppCodeMgr.do?cmd=viewAppCodeMgrLayer";

            const p = {
                applCd: $("#applCdForm #applCd").val()
            }

            let layerModal = new window.top.document.LayerModal({
                id : 'appCodeMgrLayer'
                , url : url
                , parameters : p
                , width : 900
                , height :520
                , title : '수신결재자등록'
                , trigger :[
                    {
                        name : 'appCodeMgrTrigger'
                        , callback : function(result){
                        }
                    }
                ]
            });
            layerModal.show();
        });
    }

    function filePopup() {
        if(!isPopup()) {return;}

        var param = [];
        param["fileSeq"] = $("#fileSeq").val();

        var url =  '/fileuploadJFileUpload.do?cmd=viewFileMgrLayer&authPg=A';
        var param = { fileSeq: $("#fileSeq").val() };
        let layerModal = new window.top.document.LayerModal({
            id : 'fileMgrLayer'
            , url : url
            , parameters : param
            , width : 740
            , height : 420
            , title : '파일 업로드'
            , trigger :[
                {
                    name : 'fileMgrTrigger'
                    , callback : function(result){
                        $("#fileSeq").val(result.fileSeq);
                    }
                }
            ]
        });
        layerModal.show();
    }
</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
    <div class="modal_body">
        <form id="applCdForm" name="applCdForm">
        <input type="hidden" name="workClassCd" id="workClassCd">
        <h2 class="title-wrap">
            <div class="inner-wrap">
                <span class="page-title">신청서</span>
                <div class="input-wrap wid-200px">
                    <select class="custom_select" id="applCd" name="applCd">
                        <!-- 옵션 반복 -->
                        <option value="">직접 입력</option>
                    </select>
                </div>
            </div>
            <div class="btn-wrap">
                <button class="btn outline icon_text" id="detailBtn"><i class="mdi-ico filled">settings</i>신청서 상세 설정</button>
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
                    <th>신청서명</th>
                    <td>
                        <div class="input-wrap wid-100">
                            <input class="form-input" type="text" id="applNm" name="applNm">
                        </div>
                    </td>
                </tr>
                <tr>
                    <th>신청서 팝업명</th>
                    <td>
                        <div class="input-wrap wid-100">
                            <input class="form-input" type="text" id="applTitle" name="applTitle">
                        </div>
                    </td>
                </tr>
                <tr>
                    <th>수신결재자 등록</th>
                    <td>
                        <button class="btn outline_gray" id="appCodeMgrBtn" disabled>등록</button>
                        <p class="desc">신청서 설정 저장 후 등록 가능합니다.</p>
                    </td>
                </tr>
                <tr>
                    <th>유의사항</th>
                    <td>
                        <textarea id="etcNote" name="etcNote" class="text w100p" rows="30"></textarea>
                        <btn:a href="javascript:filePopup();" css="basic" mid='btnFileV1' mdef="파일첨부"/>
                        <input type="hidden" name="fileSeq" id="fileSeq">
                    </td>
                </tr>
                <tr>
                    <th>첨부파일 여부</th>
                    <td>
                        <div class="input-wrap">
                            <input type="checkbox" class="form-checkbox" id="fileYn" name="fileYn">
                            <label for="fileYn">첨부파일</label>
                        </div>
                    </td>
                </tr>
                <tr>
                    <th>기본 결재선</th>
                    <td>
                        <div class="input-wrap wid-33">
                            <select class="custom_select" name="orgLevelCd" id="orgLevelCd">
                                <!-- 옵션 반복 -->
                            </select>
                        </div>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
        </form>
    </div>
    <div class="modal_footer">
        <a href="#" class="btn filled" id="saveApplCdBtn">저장</a>
    </div>
</div>
</body>
</html>



