<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<input type="hidden" id="setEmpLocaleCd" name="setEmpLocaleCd" value="${ssnLocaleCd}" />
<div class="ux_wrapper header_wrap outer">
    <div class="header card">
        <form id="empForm" name="empForm">
            <div class="top">
                <div class="d-flex gap-32">
                    <div class="d-flex align-center gap-12">
                        <div class="avatar">
                            <img id="userFace" src="">
                        </div>
                        <div class="name">
                            <span class="txt_title_xs_sb emp_name">${ssnName}</span>
                            <span class="txt_body_sm txt_primary">
                                <span class="emp_position">-</span>
                                <span class="emp_org">-</span>
                                <span class="emp_status chip sm">-</span>
                            </span>
                        </div>
                        <c:if test='${searchOnlyMyself != "Y"}'>
                        <!-- input_search_wrap은 임직원, 관리자일 경우 노출 -->
                        <div class="input_search_wrap">
                            <input id="searchKeyword" name="searchKeyword" type="text" class="input_text sm" placeholder="사원검색"/>
                            <span class="material-icons-outlined cancel_btn">cancel</span>
                            <span class="material-icons-outlined txt_tertiary">search</span>
                        </div>
                        </c:if>
                    </div>
                    <div class="label_text_group">
                        <div class="txt_body_sm">
                            <span class="txt_secondary">직무</span>
                            <span class="sb emp_job">-</span>
                        </div>
                        <div class="txt_body_sm">
                            <span class="txt_secondary">근무지</span>
                            <span class="sb emp_location">-</span>
                        </div>
                        <div class="txt_body_sm">
                            <span class="txt_secondary">입사일</span>
                            <span class="sb emp_join_date">-</span>
                        </div>
                        <div class="txt_body_sm">
                            <span class="txt_secondary">근속기간</span>
                            <span class="sb emp_work_period">-</span>
                        </div>
                    </div>
                </div>
                <div class="d-flex align-center">
                    <span class="material-icons-outlined cursor-pointer expand_btn">
                        expand_more
                    </span>
                </div>
            </div>
            <div class="expand_wrap">
                <div class="label_text_group col">
                </div>
            </div>
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
            <input type="hidden" id="viewSearchDate"      name="viewSearchDate"      value="" />
        </form>
    </div>
</div>