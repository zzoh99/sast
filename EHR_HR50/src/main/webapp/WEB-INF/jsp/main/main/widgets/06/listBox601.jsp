<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
var widget601 = {
	size: null
};
var now = new Date();
var currentYear = now.getFullYear();

function init_listBox601(size) {
	widget601.size = size;
    $('#searchSabun').val("${sessionScope.ssnSabun}");
    $('#searchAppOrgCd').val("${sessionScope.ssnOrgCd}");

    if (size == "normal") {
      initMiniWidget601();
      setEvalSchedules();

    } else if (size == "wide") {
      initWideWidget601();
      setEvalSchedules();
      setGoals();
    }
}

function initMiniWidget601() {
  let html =
          '<div class="bookmarks_wrap ">'
          + '  <div class="bookmark_list">'
          + '    <div class="timeline">'
          + '       <span class="bar"></span>'
          + '    </div>'
          + '  </div>'
          + '</div>';

  $('#widget601Element').html(html);
}

function initWideWidget601() {
  let html =
          '<div class="bookmarks_wrap ">'
          + '  <div class="bookmark_list" id="goal-container">'
          + '  </div>'
          + '  <div class="bookmark_list">'
          + '    <div class="timeline">'
          + '       <span class="bar"></span>'
          + '    </div>'
          + '  </div>'
          + '</div>';

  $('#widget601Element').html(html);
}

function setEvalSchedules() {
  currentYear = now.getFullYear();
  const timelines = ajaxCall('AppraisalIdMgr.do?cmd=getAppraisalIdMgrList', "appraisalYy=" + currentYear, false).DATA;
  $('#searchAppraisalCd').val(timelines[0].appraisalCd);

  setBarHeight(timelines.length);

  let timelineHtml = '';
  timelines.forEach(function(timeline) {
    let step = timeline.appraisalNm;
    let duration = timeline.duration;
    timelineHtml += '<span>'
          + '  <span class="timelineDot"></span>'
          + '  <span class="inner-wrap">'
          + '    <span class="timelineStep">' + step + '</span>'
          + '    <span class="timelineDate">' + duration + '</span>'
          + '  </span>'
          + '</span>';
  });

  $('.timeline').append(timelineHtml);
}

function setBarHeight(length) {
  let barHeight = 46 * (length - 1);
  $('.bar').css('height', 'calc(' + barHeight + 'px)');
}

function setGoals() {
  const codes = ajaxCall('/CommonCode.do?cmd=getCommonCodeList', "grpCd=P10009", false).codeList;

  let goalBoxHtml = '';

  codes.forEach(function(code) {
    $('#mboType').val(code.code);
    const goals = ajaxCall('/EvaMain.do?cmd=getMboTargetRegList1', $("#goalForm").serialize(), false).DATA;

    let goalLiItems = '';
    goals.forEach(function(goal) {
      goalLiItems += '<li>' + goal.mboTarget + '</li>';
    });

    goalBoxHtml += '<div class="goal-box">'
                + '  <p class="goal-title">' + code.codeNm + '</p>'
                + '  <ul class="goal-list">'
                + goalLiItems
                + ' </ul>'
                + '</div>';
  });

  $('#goal-container').html(goalBoxHtml);
}

</script>
<div class="widget_header">
  <div class="widget_title">전사 평가 일정</div>
</div>
<div class="widget_body widget-common schedule-list">
  <form id="goalForm" name="empForm">
    <input type="hidden" name="searchAppStepCd" id="searchAppStepCd" value="1">
    <input type="hidden" name="searchAppraisalCd" id="searchAppraisalCd">
    <input type="hidden" name="searchSabun" id="searchSabun">
    <input type="hidden" name="searchAppOrgCd" id="searchAppOrgCd">
    <input type="hidden" name="mboType" id="mboType">
  </form>
  <div id="widget601Element"></div>
</div>
