<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<script type="text/javascript">
/* 
 * 목표등록
 */
 
//위젯 사이즈별 로드
 function init_listBox607(size) {
   widget607.size = size;
   if (size == "normal") {
     widget607.makeMini();
     //widget607.setDataMini();
   } else if (size == "wide") {
     widget607.makeWide();
     //widget607.setDataWide();
   }
 }

 let widget607 = {
   size: null,
   elemId: "widget607", // 위젯 엘리면트 id
   $widget: null,
   w607Data: null, // 예상퇴직금 데이터

   // 작은 위젯 마크업 생성
   makeMini: function () {
     let html =
		'<div class="widget_header">' +
		'	<div class="widget_title">중간평가</div>' +
		'</div>' +
		'<div class="widget_body widget_h">' +
		'	<div class="widget_cnt">' +
		'		<div class="flex-col-between">' +
		'			<div class="icon_box sm self-center"><img src="/common/images/widget/eis_icon_midt_evaluation_s_2x.png" alt="중간평가하기"></div>' +
		'			<p>중간평가진행</p>' +
		'			<p>23.7.11~7.15</p>' +
		'			<button type="button" class="btn outline_gray m-auto">중간평가하기</button>' +
		'		</div>' +
		'	</div>' +
		'</div>';

     document.getElementById(this.elemId).innerHTML = html;
   },

   // 와이드 위젯 마크업 생성
   makeWide: function () {
     let html =
		'<div class="widget_header">' +
		'	<div class="widget_title">중간평가</div>' +
		'</div>' +
		'<div class="widget_body widget_h">' +
		'	<div class="widget_cnt">' +
		'		<div class="icon_box"><img src="/common/images/widget/eis_icon_midt_evaluation_2x.png" alt="중간평가진행"></div>' +
		'		<div class="flex-col-between">' +
		'			<p>중간평가진행</p>' +
		'			<p>23.7.11~7.15</p>' +
		'			<button type="button" class="btn outline_gray ml-0">중간평가하기</button>' +
		'		</div>' +
		'	</div>' +
		'</div>';

     document.getElementById(this.elemId).innerHTML = html;
   },
 };
 </script>
<div class="widget" id="widget607"></div>