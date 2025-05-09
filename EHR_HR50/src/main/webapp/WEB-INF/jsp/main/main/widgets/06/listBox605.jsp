<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<script type="text/javascript">
/* 
 * 평가하기
 */
 
//위젯 사이즈별 로드
 function init_listBox605(size) {
   widget605.size = size;
   if (size == "normal") {
     widget605.makeMini();
     //widget605.setDataMini();
   } else if (size == "wide") {
     widget605.makeWide();
     //widget605.setDataWide();
   }
 }

 let widget605 = {
   size: null,
   elemId: "widget605", // 위젯 엘리면트 id
   $widget: null,
   w605Data: null, // 예상퇴직금 데이터

   // 작은 위젯 마크업 생성
   makeMini: function () {
     let html =
		'<div class="widget_header">' +
		'	<div class="widget_title">평가하기</div>' +
		'</div>' +
		'<div class="widget_body widget_h">' +
		'	<div class="widget_cnt">' +
		'		<div class="flex-col-between">' +
		'			<div class="icon_box sm self-center"><img src="/common/images/widget/eis_icon_evaluation_s_2x.png" alt="중간평가진행"></div>' +
		'			<p>중간평가진행</p>' +
		'			<p>23.7.11~7.15</p>' +
		'			<button type="button" class="btn outline_gray m-auto">평가하기</button>' +
		'		</div>' +
		'	</div>' +
		'</div>';

     document.getElementById(this.elemId).innerHTML = html;
   },

   // 와이드 위젯 마크업 생성
   makeWide: function () {
     let html =
		'<div class="widget_header">' +
		'	<div class="widget_title">평가하기</div>' +
		'</div>' +
		'<div class="widget_body widget_h">' +
		'	<div class="widget_cnt">' +
		'		<div class="icon_box"><img src="/common/images/widget/eis_icon_evaluation_2x.png" alt="중간평가진행"></div>' +
		'		<div class="flex-col-between">' +
		'			<p>중간평가진행</p>' +
		'			<p>23.7.11~7.15</p>' +
		'			<button type="button" class="btn outline_gray ml-0">평가하기</button>' +
		'		</div>' +
		'	</div>' +
		'</div>';

     document.getElementById(this.elemId).innerHTML = html;
   },
 };
 </script>
<div class="widget" id="widget605"></div>