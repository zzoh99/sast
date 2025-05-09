<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<script type="text/javascript">
/* 
 * 근태신청
 */
 
//위젯 사이즈별 로드
 function init_listBox815(size) {
   widget815.size = size;
   if (size == "normal") {
     widget815.makeMini();
     // widget815.setDataMini();
     widget815.initMiniEvent();
     widget815.initEvent();
   } else if (size == "wide") {
     widget815.makeWide();
     // widget815.setDataWide();
     widget815.initEvent();
   }
 }

 let widget815 = {
   size: null,
   elemId: "widget815", // 위젯 엘리면트 id
   $widget: null,
   w815Data: null, // 예상퇴직금 데이터

   // 작은 위젯 마크업 생성
   makeMini: function () {
	let html =
		'<div class="widget_header">' +
    	'	<div class="widget_title">근태신청</div>' +
    	'</div>' +
		'<div class="widget_body">'+
		'	<div class="widget_cnt">' +
		'		<div class="swiper widget_swiper">'+
		'			<div class="swiper-wrapper">'+
		'				<div class="swiper-slide">'+
		'					<div class="swiper-title"><h2>휴가신청</h2></div>'+
		'					<div class="flex-col-between">'+
		'						<div class="icon_box sm self-center">'+
		'							<img src="/common/images/widget/eis_icon_work_2x.png" alt="acc">'+
		'						</div>'+
		'						<button type="button" id="vacationBtn" class="btn filled m-auto">휴가신청</button>' +
		'					</div>'+
		'				</div>'+
		'				<div class="swiper-slide">'+
		'					<div class="swiper-title"><h2>연장근로신청</h2></div>'+
		'					<div class="flex-col-between">'+
		'						<div class="icon_box sm self-center">'+
		'							<img src="/common/images/widget/eis_icon_workovertime_2x.png" alt="acc">'+
		'						</div>'+
		'						<button type="button" class="btn filled m-auto" id="overtimeBtn">연장근로신청</button>'+
		'					</div>'+
		'				</div>'+
		'			</div>'+
		'			<div class="swiper-button-next"><i class="mdi-ico">keyboard_arrow_right</i></div>'+
		'			<div class="swiper-button-prev"><i class="mdi-ico">keyboard_arrow_left</i></div>'+
		'		</div>'+
		'	</div>' +
		'</div>';

     document.getElementById(this.elemId).innerHTML = html;
   },

  setDataMini: function () {

  },

  initMiniEvent: function () {
   const swiper = new Swiper('.widget_swiper', {
    slidesPerView: 1,
    spaceBetween: 30,
    navigation: {
     nextEl: '.swiper-button-next',
     prevEl: '.swiper-button-prev',
    },
   });
  },

   // 와이드 위젯 마크업 생성
   makeWide: function () {
     let html =
		'<div class="widget_header">' +
		'	<div class="widget_title">근태신청</div>' +
		'</div>' +
		'<div class="widget_body">' +
		'	<div class="widget_cnt">' +
		'		<div class="box">' +
		'			<img src="/common/images/widget/eis_icon_work_2x.png" alt="">' +
		'			<button class="btn filled" id="vacationBtn">휴가신청</button>' +
		'		</div>' +
		'		<div class="box">' +
		'			<img src="/common/images/widget/eis_icon_workovertime_2x.png" alt="">' +
		'			<button class="btn filled" id="overtimeBtn">연장근로신청</button>' +
		'		</div>' +
		'	</div>' +
		'</div>';

     document.getElementById(this.elemId).innerHTML = html;
   },

  initEvent: function () {
   $('#vacationBtn').on('click', function () {
    gotoSubPage("VacationApp.do?cmd=viewVacationApp");
   });
   $('#overtimeBtn').on('click', function () {
    gotoSubPage("OtWorkOrgApp.do?cmd=viewOtWorkOrgApp");
   });
  },
 };

 function gotoSubPage(subPagePath) {
  if(typeof goSubPage == 'undefined') {
   // 서브페이지에서 서브페이지 호출
   if(typeof window.top.goOtherSubPage == 'function') {
    window.top.goOtherSubPage("", "", "", "", subPagePath);
   }
  } else {
   goSubPage("", "", "", "", subPagePath);
  }
 }
 </script>
<div class="widget" id="widget815"></div>

