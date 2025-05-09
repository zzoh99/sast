<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp" %>
<!DOCTYPE html>
<html class="bodywrap"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="/assets/css/attendanceNew.css"/>

<!-- 개별 화면 script -->
<script type="text/javascript">
    $(function() {
        const modal = window.top.document.LayerModalUtility.getModal('wtmLeaveCreMgrLayer');
        initGntCd(modal.parameters.searchGntCd);

        if (modal.parameters.searchYear)
            $("#searchYear").val(modal.parameters.searchYear);

        $("#btnCreate").off().on("click", function() {
            create();
        })
    });

    function initGntCd(initValue) {
        const gntCdList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getWtmLeaveCdList&searchBasicCdYn=Y&isExistsCreStdYn=Y", false).codeList, "");
        $("#searchGntCd").html(gntCdList[2]);
        $("#searchGntCd").off().on("change", function() {
            initSearchSeq();
        });

        if (initValue) {
            const modal = window.top.document.LayerModalUtility.getModal('wtmLeaveCreMgrLayer');
            $("#searchGntCd").val(modal.parameters.searchGntCd);
        }

        if ($("#searchGntCd").val())
            $("#searchGntCd").change();
    }

    function initSearchSeq() {
        const seqCdList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getWtmLeaveCreMgrSearchSeqList&searchGntCd=" + $("#searchGntCd").val(), false).codeList, "");
        $("#searchSeq").html(seqCdList[2]);
        $("#searchSeq").off().on("change", function() {
            setLeaveCreStdInfo();
        })
        if ($("#searchSeq").val())
            $("#searchSeq").change();
    }

    function setLeaveCreStdInfo() {
        const info = ajaxCall("${ctx}/WtmLeaveCreMgr.do?cmd=getWtmLeaveCreMgrLayerStdInfo", "gntCd=" + $("#searchGntCd").val() + "&searchSeq=" + $("#searchSeq").val(), false);
        if (info && info.DATA) {
            const data = info.DATA;
            const html = `<p>연차는 \${data.annualCreTypeNm} 기준으로 생성되며, 회계일은 \${data.finDateMonth}월 \${data.finDateDay}일 입니다.</p>`;
            $("#pStdText").html(html);
        }
    }

    function create() {

        if (!$("#searchGntCd").val()) {
            alert("근태명을 입력해주세요.");
            return;
        }

        if (!$("#searchYear").val()) {
            alert("생성년도를 입력해주세요.");
            return;
        }

        if (!$("#searchSeq").val()) {
            alert("대상자를 선택해주세요.");
            return;
        }

        const param = "searchYear=" + $("#searchYear").val()
            + "&gntCd=" + $("#searchGntCd").val()
            + "&searchSeq=" + $("#searchSeq").val();

        ajaxCall2("${ctx}/WtmLeaveCreMgr.do?cmd=excCreateWtmLeaves", param, true
            , function() {
                progressBar(true, "연차 생성중입니다. 잠시만 기다려주시기 바랍니다.");
            }, function(data) {
                progressBar(false);
                alert(data.Result.Message);
                if (data.Result.Code > 0) {
                    // 성공
                    const modal = window.top.document.LayerModalUtility.getModal('wtmLeaveCreMgrLayer');
                    modal.fire('wtmLeaveCreMgrLayerTrigger', {
                        resultCode : data.Result.Code
                    }).hide();
                }
            });
    }
</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
    <div class="modal_body">
        <h2 class="title-wrap">
            <div class="inner-wrap">
                <span class="page-title">휴가생성</span>
            </div>
        </h2>
        <div class="table-wrap">
            <form id="holidayForm">
                <table class="sheet_search default type5 bt-line bb-line">
                    <colgroup>
                        <col width="30%" />
                        <col width="70%" />
                    </colgroup>
                    <tbody>
                    <tr>
                        <th><label for="searchGntCd">근태명</label></th>
                        <td>
                            <div class="input-wrap mt-4">
                                <select id="searchGntCd" name="searchGntCd">
                                </select>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th><label for="searchYear">생성년도</label></th>
                        <td>
                            <div class="input-wrap mt-4">
                                <input type="text" name="searchYear" id="searchYear" class="text"/>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th><label for="searchSeq">대상자</label></th>
                        <td>
                            <div class="input-wrap mt-4">
                                <select id="searchSeq" name="searchSeq">
                                </select>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th>생성기준</th>
                        <td>
                            <div class="input-wrap mt-4">
                                <p id="pStdText"></p>
                            </div>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </form>
        </div>
    </div>
    <div class="modal_footer">
        <a href="javascript:closeCommonLayer('wtmLeaveCreMgrLayer')" class="btn outline_gray">취소</a>
        <a class="btn filled" id="btnCreate">생성</a>
    </div>
</div>
</body>
</html>



