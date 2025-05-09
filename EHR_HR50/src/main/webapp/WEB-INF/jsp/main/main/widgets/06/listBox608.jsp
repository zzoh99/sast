<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
/* 
 * 최종평가
 */
 
//위젯 사이즈별 로드
 function init_listBox608(size) {
   widget608.size = size;
   if (size == "normal") {
     widget608.makeMini();
     //widget608.setDataMini();
   } else if (size == "wide") {
     widget608.makeWide();
     //widget608.setDataWide();
   }
 }

 let widget608 = {
   size: null,
   elemId: "widget608", // 위젯 엘리면트 id
   $widget: null,
   w608Data: null, // 예상퇴직금 데이터

   // 작은 위젯 마크업 생성
   makeMini: function () {
     let html =
		'<div class="widget_header">' +
		'	<div class="widget_title">최종평가</div>' +
		'</div>' +
		'<div class="widget_body widget_h">' +
		'	<div class="widget_cnt">' +
		'		<div class="flex-col-between">' +
		'			<div class="icon_box sm self-center"><img src="/common/images/widget/eis_icon_final_evaluation_s_2x.png" alt="최종평가진행"></div>' +
		'			<p>최종평가진행</p>' +
		'			<p>23.12.11~12.15</p>' +
		'			<button type="button" class="btn outline_gray m-auto">최종평가하기</button>' +
		'		</div>' +
		'	</div>' +
		'</div>';

     document.getElementById(this.elemId).innerHTML = html;
   },

   // 와이드 위젯 마크업 생성
   makeWide: function () {
     let html =
		'<div class="widget_header">' +
		'	<div class="widget_title">최종평가</div>' +
		'</div>' +
		'<div class="widget_body widget_h">' +
		'	<div class="widget_cnt">' +
		'		<div class="icon_box"><img src="/common/images/widget/eis_icon_final_evaluation_2x.png" alt="최종평가진행"></div>' +
		'		<div class="flex-col-between">' +
		'			<p>최종평가진행</p>' +
		'			<p>23.12.11~12.15</p>' +
		'			<button type="button" class="btn outline_gray ml-0">최종평가하기</button>' +
		'		</div>' +
		'	</div>' +
		'</div>';

     document.getElementById(this.elemId).innerHTML = html;
   },
 };
 </script>

<div class="widget" id="widget608"></div>