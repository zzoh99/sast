<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp" %>
<!DOCTYPE html><html class="bodywrap"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp" %>
<script>
    $(document).ready(function() {
        const unassignedEmpList = ajaxCall("/WtmWorkTypeMgr.do?cmd=getWtmWorkClassUnassignedEmpList", '', false).DATA;
        if (unassignedEmpList) {
            let empCardHtml = '';
            if (unassignedEmpList.length === 0) {
                empCardHtml += `<li class="card-item">
                                    <div class="info-wrap">미배정된 대상자가 없습니다.</div>
                                </li>`;
            } else {
                unassignedEmpList.forEach(emp => {
                    empCardHtml += `<li class="card-item">
                                        <div class="img-wrap">
                                            <img src="/EmpPhotoOut.do?enterCd=${'${emp.enterCd}'}&searchKeyword=${'${emp.sabun}'}">
                                        </div>
                                        <div class="info-wrap">
                                            <div>
                                                <span class="name">${'${emp.name}'}</span>
                                                <span class="position">${'${emp.jikweeNm}'}</span>
                                            </div>
                                            <div class="team">${'${emp.orgNm}'}</div>
                                        </div>
                                    </li>`;
                });
            }

            $('.card-list').append(empCardHtml);
            $('#totalCnt').text(unassignedEmpList[0].total);
            $('#unassignedCnt').text(unassignedEmpList.length);
        } else {
            alert("조회에 실패하였습니다. 관리자에게 문의바랍니다.");
        }
    });
</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
    <div class="modal_body">
        <div class="list-status">
            <p class="status-title">미배정자</p>
            <p class="status-desc">총 <span id="totalCnt"></span>명 중, 미배정자는 <strong><span id="unassignedCnt"></span>명</strong> 입니다.</p>
        </div>
        <div class="unassign-list-wrap">
            <ul class="card-list"></ul>
        </div>
    </div>
    <div class="modal_footer">
        <a href="javascript:closeCommonLayer('wtmWorkUnassignedEmpLayer')" class="btn outline_gray">확인</a>
    </div>
</div>
</body>
</html>



