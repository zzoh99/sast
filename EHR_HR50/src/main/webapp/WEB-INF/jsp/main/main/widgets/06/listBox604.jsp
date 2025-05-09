<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp" %>

<script type="text/javascript">

    var widget604 = {
        size: null
    };

    let rankType = 'top';

    function init_listBox604(size) {
        widget604.size = size;
        initCombo();

        if (size == "normal") {
            initMiniWidget604();
            setEvalRankingList();
        } else if (size == "wide") {
            initWideWidget604();
            setEvalRankingList();
        }
        initEvent();
    }

    function initCombo() {
        let currentDate = new Date();
        let currentYear = currentDate.getFullYear();
        let lastYear = currentYear - 1;

        $(".select_toggle604 span").text(lastYear);

        let options = '';
        for (let i = 0; i < 5; i++) {
            let year = currentYear - i;
            options += '<div class="option widget604Option">' + year + '</div>';
        }

        $(".select_options604").html(options);
        $('#searchYear').val(lastYear);
    }

    function initMiniWidget604() {
        let html = '  <div class="bookmarks_title">'
                    + '    <a href="#" id="widget604ArrowLeft" class="arrowLeft"><i class="mdi-ico">keyboard_arrow_left</i></a>'
                    + '    <span id="widget604ArrowTitle">상위 Top 3</span>'
                    + '    <a href="#" id="widget604ArrowRight" class="arrowRight"><i class="mdi-ico">keyboard_arrow_right</i></a>'
                    + '  </div>'
                    + '  <div class="avatar-list" id="top3List"></div>'
                    + '  <!-- hover 시 말풍선 -->'
                    + '  <div class="speech-bubble">'
                    + '  <span class="name">박주호<span class="team divider">본부장</span><span'
                    + '      class="time divider">124시간 25분</span></span>'
                    + '  </div>'
                    + '  <div class="avatar-list" id="bottom3List"></div>'
                    + '  <!-- hover 시 말풍선 -->'
                    + '  <div class="speech-bubble">'
                    + '  <span class="name">박주호<span class="team divider">본부장</span><span'
                    + '      class="time divider">124시간 25분</span></span>'
                    + '  </div>'
                    + '</div>';

        $('#widget604Body').append(html);
        $('#bottom3List').hide();
    }

    function initWideWidget604() {
        let $widget604Body = $('#widget604Body');

        let html = '<div class="container_box">'
                + '    <div class="container_info avatar-type">'
                + '        <div class="list-title" id="widget604ArrowTitle">상위 Top 3<span class="tag_icon green round"><i class="mdi-ico">trending_up</i></span>'
                + '        </div>'
                + '        <div class="avatar-list" id="top3List"></div>'
                + '        <!-- hover 시 말풍선 -->'
                + '        <div class="speech-bubble">'
                + '        <span class="name">박주호<span class="team divider">본부장</span><span'
                + '            class="time divider">124시간 25분</span></span>'
                + '        </div>'
                + '    </div>'
                + '    <div class="container_info avatar-type">'
                + '        <div class="list-title">하위 Top 3<span class="tag_icon red round"><i class="mdi-ico">trending_down</i></span>'
                + '        </div>'
                + '        <div class="avatar-list" id="bottom3List"></div>'
                + '        <!-- hover 시 말풍선 -->'
                + '        <div class="speech-bubble">'
                + '        <span class="name">박주호<span class="team divider">본부장</span><span'
                + '            class="time divider">124시간 25분</span></span>'
                + '        </div>'
                + '    </div>'
                + '</div>';

        $widget604Body.append(html);
        $widget604Body.addClass('best-top');
    }

    function initEvent() {
        $(".select_toggle604").click(function () {
            let $selectOptions = $(".select_options604");
            if ($selectOptions.css("visibility") === "visible") {
                $selectOptions.css("visibility", "hidden");
            } else {
                $selectOptions.css("visibility", "visible");
            }
        });

        $(".widget604Option").click(function () {
            let selectedOption = $(this).text();
            $(".select_toggle604 span").text(selectedOption);
            $(".select_options").css("visibility", "hidden");

            $("#top3List").empty();
            $("#bottom3List").empty();

            $('#searchYear').val(selectedOption);

            setEvalRankingList();
        });

        $('#widget604ArrowRight, #widget604ArrowLeft').click(function () {
            if (rankType === 'top') {
                rankType = 'bottom';
                $('#widget604ArrowTitle').text('하위 Top 3');
                $('#bottom3List').show();
                $('#top3List').hide();
            } else {
                rankType = 'top';
                $('#widget604ArrowTitle').text('상위 top 3');
                $('#bottom3List').hide();
                $('#top3List').show();
            }
        });
    }

    function setEvalRankingList() {
        const empLankList = ajaxCall('/AppResultMgr.do?cmd=getEvalRankingList', $('#targetForm').serialize(), false).DATA;

        let top3ListHtml = makeHtmlForRankList(empLankList, 'A');
        $('#top3List').append(top3ListHtml);

        let bottom3ListHtml = makeHtmlForRankList(empLankList, 'B');
        $('#bottom3List').append(bottom3ListHtml);

    }

    function makeHtmlForRankList(empLankList, gubun) {
        const rankList = empLankList.filter(function (emp) {
            return emp.gubun === gubun;
        });

        if (rankList.length < 1) {
            return '<span>조회 결과가 없습니다.</span>';
        }

        let rankHtml = '';
        rankList.forEach(function (emp) {
            rankHtml += '<div>'
                + '    <span class="avatar-wrap">'
                + '        <span id="empIcon" class="tag_icon ' + getIconColor(gubun) + ' round">' + emp.rn + '</span>'
                + '        <span class="avatar">'
                + '            <img src="/EmpPhotoOut.do?enterCd=' + emp.enterCd + '&searchKeyword=' + emp.sabun +'">'
                + '        </span>'
                + '    </span>'
                + '    <span class="name">' + emp.name + '</span>'
                + '    <span class="team ellipsis">' + emp.appOrgNm + '</span>'
                + '</div>';
        });

        return rankHtml;
    }

    function getIconColor(gubun) {
        if (gubun === 'A') {
            return 'green';
        }
        return 'red';
    }
</script>

<div class="widget_header">
    <div class="widget_title">평가 상위자 및 저조자</div>
</div>
<div class="widget_body attendance_contents annual-status overtime-work widget-common" id="widget604Body">
    <form id="targetForm" name="targetForm">
        <input type="hidden" name="searchAppTypeCd" id="searchAppTypeCd" value="C">
        <input type="hidden" name="searchYear" id="searchYear">
    </form>
    <div class="custom_select no_style">
        <button class="select_toggle select_toggle604">
            <span>전체</span><i class="mdi-ico">arrow_drop_down</i>
        </button>
        <div class="select_options numbers select_options604" style="visibility: hidden"></div>
    </div>
</div>