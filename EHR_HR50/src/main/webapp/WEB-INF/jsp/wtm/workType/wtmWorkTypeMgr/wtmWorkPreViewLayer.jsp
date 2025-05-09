<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp" %>
<!DOCTYPE html><html class="bodywrap"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp" %>
<!-- 근태 css -->
<link rel="stylesheet" type="text/css" href="/assets/css/attendanceNew.css"/>

<!-- 개별 화면 script -->
<script>
    $(document).ready(function() {
        const modal = window.top.document.LayerModalUtility.getModal('wtmWorkPreViewLayer');
        const workClassCd = modal.parameters.workClassCd || '';
        const daysOfWeek = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"];

        const today = new Date();
        const month = today.getMonth() + 1;
        const year = today.getFullYear();

        // Get the number of days in the month
        const daysInMonth = new Date(year, month + 1, 0).getDate();

        const groupList = ajaxCall("/WtmWorkTypeMgr.do?cmd=getWorkGroupList", "workClassCd=" + workClassCd, false).DATA;
        let teamWrapHtml = '';
        for (let i = 0 ; i < groupList.length; i++) {
            const group = groupList[i];
            teamWrapHtml += '<div class="team-common team' + i + '">' + group.workGroupNm + '</div>';
            const patterns = group.patterns;
            group.patternArray = createPatternArray(patterns, daysInMonth);
        }

        for (let day = 1; day <= daysInMonth; day += 7) {
            let headerRow = '<tr><th class="text-center">순번</th>';
            let contentRow = '<tr><td class="no-padding text-center"><div class="team-wrap">' + teamWrapHtml + '</div></td>';

            for (var i = 0; i < 7; i++) {
                if (day + i > daysInMonth) break;

                var date = new Date(year, month, day + i);
                var dayOfWeek = daysOfWeek[date.getDay()];

                headerRow += '<th><div class="d-flex"><div class="date">' + (day + i) + '</div><div class="day ml-auto">' + dayOfWeek + '</div></div></th>';
                contentRow += '<td><div class="team-wrap">';

                groupList.forEach(group => {
                    const index = day + i -1;
                    const workSchNm = group.patternArray[index].workSchNm == '' ? "휴일" : group.patternArray[index].workSchSrtNm;
                    contentRow += '<div class="team-common"><span class="attend-chip day ' + group.patternArray[index].color + '">' + workSchNm + '</span></div>';
                });
                contentRow +=  '</div></td>';

            }

            headerRow += '</tr>';
            contentRow += '</tr>';

            $('#dynamic-rows').append(headerRow);
            $('#dynamic-rows').append(contentRow);
        }
    });

    function createPatternArray(patterns, days) {
        const result = [];
        const patternLength = patterns.length;

        for (let i = 0; i < days; i++) {
            result.push(patterns[i % patternLength]);
        }

        return result;
    }

</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
    <div class="modal_body">
        <h2 class="title-wrap">
            <div class="inner-wrap">
                <span class="page-title">근무패턴</span>
            </div>
        </h2>
        <div class="table-wrap">
            <table class="attend">
                <colgroup>
                    <col width="12.5%">
                    <col width="12.5%">
                    <col width="12.5%">
                    <col width="12.5%">
                    <col width="12.5%">
                    <col width="12.5%">
                    <col width="12.5%">
                    <col width="12.5%">
                </colgroup>
                <tbody id="dynamic-rows">
                <!-- Rows will be added dynamically here -->
                </tbody>
            </table>
        </div>
    </div>
    <div class="modal_footer">
        <a href="javascript:closeCommonLayer('wtmWorkPreViewLayer');" class="btn outline_gray">닫기</a>
    </div>
</div>
</body>
</html>



