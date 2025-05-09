<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 상단 사진/기본정보 -->
<input type="hidden" id="setEmpLocaleCd" name="setEmpLocaleCd" value="${ssnLocaleCd}" />
<div id="area_employee_header" class="header_table outer">
	<div class="primary_info<c:if test="${ssnGrpCd == '99'}"> common</c:if>"> <%-- 231023 김기용: 임직원공통 일때 common 클래스 추가 --%>
		<!-- <strong id="label_StatusNm" class="cur_status_info AA">재직</strong> --> <!-- 231022 김기용: 주석처리 -->
		<div class="profile_box">
			<div class="profile_frame">
				<img id="userFace" src="" alt="프로필 사진" />
			</div>
			
			<div class="profile_summary"> <!-- 231022 김기용: 마크업 추가 -->
              <p><span class="name" id="profile_summary_name">${ssnName}</span><span class="tag_icon green status">재직</span></p>
              <span class="sabun" id="tdSabun">${ ssnSabun }</span>                 
            </div>
		</div>
		
		<form id="empForm" name="empForm">
			<ul>
				<input type="hidden" id="searchKeyword" name="searchKeyword" />
				<input type="hidden" id="searchEmpType"       name="searchEmpType"       value="I" /> <!-- Include에서  사용 -->
				<input type="hidden" id="searchStatusCd"      name="searchStatusCd"      value="A" /><!-- in ret -->
				<input type="hidden" id="searchUserEnterCd"   name="searchUserEnterCd"   value="${ssnEnterCd}" />
				<input type="hidden" id="searchUserId"        name="searchUserId"        value="${ssnSabun}" />
				<input type="hidden" id="searchEmpPayType"    name="searchEmpPayType"    value="" />
				<input type="hidden" id="searchCurrJikgubYmd" name="searchCurrJikgubYmd" value="" />
				<input type="hidden" id="searchWorkYyCnt"     name="searchWorkYyCnt"     value="" />
				<input type="hidden" id="searchWorkMmCnt"     name="searchWorkMmCnt"     value="" />
				<input type="hidden" id="searchSabunRef"      name="searchSabunRef"      value="" />
				<input type="hidden" id="searchUserStatusCd"  name="searchUserStatusCd"  value="${ssnStatusCd}" />
			</ul>
		</form>
	</div>
	<div class="detail_info">
		<div class="item_list_box">
			<ul class="item_list"></ul>
			<ul class="item_list"></ul>
			<ul class="item_list"></ul>
			<ul class="item_list"></ul>
		</div>
	</div>
</div>