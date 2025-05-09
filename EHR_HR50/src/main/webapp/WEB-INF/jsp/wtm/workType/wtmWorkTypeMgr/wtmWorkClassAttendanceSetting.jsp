<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div id="content_03" class="typSetting-content">
    <h2 class="title-wrap">
        <span class="page-title">출퇴근 설정</span>
        <%--                    <div class="btn-wrap">--%>
        <%--                        <button class="btn dark">저장</button>--%>
        <%--                    </div>--%>
    </h2>
    <div class="table-wrap mt-2 table-responsive">
        <table class="basic type5 line-grey">
            <colgroup>
                <col width="15%">
                <col width="35%">
                <col width="15%">
                <col width="35%">
            </colgroup>
            <tbody>
            <tr>
                <th id="autoWorkYnTh">출퇴근 자동처리</th>
                <td id="autoWorkYnTd">
                    <div class="input-wrap">
                        <div class="checkbox-wrap">
                            <input type="checkbox" class="form-checkbox" id="autoWorkStartYn" name="autoWorkStartYn">
                             <label for="autoWorkStartYn">출근</label>
                        </div>
                        <div class="checkbox-wrap">
                            <input type="checkbox" class="form-checkbox" id="autoWorkEndYn" name="autoWorkEndYn">
                            <label for="autoWorkEndYn">퇴근</label>
                        </div>
                    </div>
                </td>
                <th id="checkUseTh">체크여부</th>
                <td id="checkUseTd">
                    <div class="input-wrap">
                        <div class="checkbox-wrap">
                            <input type="checkbox" class="form-checkbox" id="lateUseYn" name="lateUseYn">
                            <label for="lateUseYn">지각</label>
                        </div>
                        <div class="checkbox-wrap">
                            <input type="checkbox" class="form-checkbox" id="earlyLeaveUseYn" name="earlyLeaveUseYn">
                            <label for="earlyLeaveUseYn">조퇴</label>
                        </div>
                        <div class="checkbox-wrap">
                            <input type="checkbox" class="form-checkbox" id="absenceUseYn" name="absenceUseYn">
                            <label for="absenceUseYn">결근</label>
                        </div>
                    </div>
                </td>
            </tr>
            <tr>
                <th id="deemedTimeTh">간주시간</th>
                <td id="deemedTimeTd">
                    근무 계획을 세우지 않으면
                    <div class="input-wrap px-2" style="width: 70px;">
                        <input class="form-input" id="deemedTimeF" name="deemedTimeF" type="text">
                    </div>
                    -
                    <div class="input-wrap px-2" style="width: 70px;">
                        <input class="form-input" id="deemedTimeT" name="deemedTimeT" type="text">
                    </div>간주합니다.
                </td>
                <th id="baseWorkPreUseYnTh">기본근무 선소진여부</th>
                <td id="baseWorkPreUseYnTd" colspan="3">
                    <div class="input-wrap">
                        <div class="checkbox-wrap">
                            <input type="checkbox" class="form-checkbox" id="baseWorkPreUseYn" name="baseWorkPreUseYn">
                            <label for="baseWorkPreUseYn">연장근무 신청 시 단위 기간 내 기본 근무 소진 여부를 체크합니다.</label>
                        </div>
                    </div>
                </td>
            </tr>
            <tr>
                <th id="noWorkPlanYnTh">근무계획 미등록여부</th>
                <td id="noWorkPlanYnTd" colspan="3">
                    <div class="input-wrap">
                        <div class="checkbox-wrap">
                            <input type="checkbox" class="form-checkbox" id="noWorkPlanYn" name="noWorkPlanYn">
                            <label for="noWorkPlanYn">근무 계획을 등록하지 않아도 출/퇴근 타각 정보로 근무를 인정합니다.</label>
                        </div>
                    </div>
                </td>
            </tr>
            <tr>
                <th id="workBeginPreYnTh">사전 출근 여부</th>
                <td id="workBeginPreYnTd" colspan="3">
                    <div class="input-wrap">
                        <div class="checkbox-wrap">
                            <input type="checkbox" class="form-checkbox" id="workBeginPreYn" name="workBeginPreYn">
                            <label for="workBeginPreYn">근무 계획 시간 이전에 출근이 가능하고 근무로 인정합니다.</label>
                        </div>
                    </div>
                </td>
            </tr>
            <tr>
                <th id="workEnableRangeTh">출퇴근 가능 시간 범위</th>
                <td colspan="3" id="workEnableRangeTd">
                    <div class="input-wrap wid-15">
                        <select class="custom_select" id="workEnableRange" name="workEnableRange">
                            <!-- 옵션 반복 -->
                            <option value="">선택</option>
                        </select>
                    </div>
                    <p class="desc mt-2">출퇴근 범위를 설정할 경우 근무 계획의 출퇴근 범위보다 이후에 출근 또는 이전에 퇴근이 가능합니다.</p>
                </td>
            </tr>
            <tr>
                <th id="autoOtTimeYnTh">계획시간 외 연장생성</th>
                <td id="autoOtTimeYnTd" colspan="3">
                    <div class="input-wrap">
                        <input type="checkbox" class="form-checkbox" id="autoOtTimeYn" name="autoOtTimeYn">
                        <label for="autoOtTimeYn">체크 시 연장근무신청을 하지 않아도 타각시간에 따라 연장근무를 인정합니다.</label>
                    </div>
                </td>
                <th class="hide" id="fixOtUseYnTh">고정OT소진 사용여부</th>
                <td class="hide" id="fixOtUseYnTd">
                    <div class="input-wrap">
                        <input type="checkbox" class="form-checkbox" id="fixOtUseYn" name="fixOtUseYn">
                        <label for="fixOtUseYn">사용</label>
                    </div>
                </td>
            </tr>
            </tbody>
        </table>
    </div>
</div>
