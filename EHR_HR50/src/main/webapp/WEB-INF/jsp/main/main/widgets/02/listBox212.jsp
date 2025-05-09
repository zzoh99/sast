<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<script type="text/javascript">
/* 
 * 인사발령
 */



//위젯 사이즈별 로드
function init_listBox212(size) {
  widget212.size = size;
  if (size == "normal") {
    widget212.makeMini();
    widget212.setDataMini();
  } else if (size == "wide") {
    widget212.makeWide();
    widget212.setDataWide();
  }
}

let widget212 = {
  size: null,
  elemId: "widget212", // 위젯 엘리면트 id
  $widget: null,
  w212Data: null, // 예상퇴직금 데이터

  // 작은 위젯 마크업 생성
  makeMini: function () {
    let html =
	'<div class="widget_header">' +
	'	<div class="widget_title">인사발령</div>' +
	'</div>' +
	'<div class="widget_body widget_h">' +
	'	<div class="widget_cnt">' +
	'		<div class="flex-col-between">' +
	'			<div class="icon_box sm self-center"><img src="/common/images/widget/eis_icon_hrm_s_2x.png" alt="2024년 인사발령 조직개편"></div>' +
	'			<p><span id="thisYear"></span>년 인사발령 <br />조직개편</p>' +
	'			<button type="button" id="confirmBtn" class="btn outline_gray m-auto">인사발령 확인</button>' +
	'		</div>' +
	'	</div>' +
	'</div>';

    document.getElementById(this.elemId).innerHTML = html;
  },

    setDataMini: function () {
      const today = new Date();
      const year = today.getFullYear();
      $('#thisYear').text(year);
      clickConfirmBtn();
    },

  // 와이드 위젯 마크업 생성
  makeWide: function () {
    let html =
		'<div class="widget_header">' +
		'	<div class="widget_title">인사발령</div>' +
		'</div>' +
		'<div class="widget_body widget_h">' +
		'	<div class="widget_cnt">' +
		'		<div class="icon_box"><img src="/common/images/widget/eis_icon_hrm_2x.png" alt="2024년 인사발령 조직개편"></div>' +
		'		<div class="flex-col-between">' +
		'			<p><span id="thisYear"></span>년 인사발령 <br />조직개편</p>' +
		'			<button type="button" id="confirmBtn" class="btn ml-0 outline_gray">인사발령 확인</button>' +
		'		</div>' +
		'	</div>' +
		'</div>';

    document.getElementById(this.elemId).innerHTML = html;
  },

    setDataWide: function () {
        const today = new Date();
        const year = today.getFullYear();
        $('#thisYear').text(year);
        clickConfirmBtn();
    },
};

function clickConfirmBtn() {
    $('#confirmBtn').off().click(function() {
        if(typeof goSubPage == 'undefined') {
            // 서브페이지에서 서브페이지 호출
            if(typeof window.top.goOtherSubPage == 'function') {
                window.top.goOtherSubPage("", "", "", "", "ExecAppmtLst.do?cmd=viewExecAppmtLst");
            }
        } else {
            goSubPage("", "", "", "", "ExecAppmtLst.do?cmd=viewExecAppmtLst");
        }
    });
}
</script>
<div class="widget" id="widget212"></div>