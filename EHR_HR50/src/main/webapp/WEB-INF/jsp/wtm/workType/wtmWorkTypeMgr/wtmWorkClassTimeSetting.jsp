<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div id="content_02" class="typSetting-content">
    <h2 class="title-wrap">
        <span class="page-title">근무시간기준</span>
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
                <th id="intervalCdTh">단위기간</th>
                <td id="intervalCdTd">
                    <div class="input-wrap wid-33">
                        <select class="custom_select" id="intervalCd" name="intervalCd">
                            <!-- 옵션 반복 -->
                            <option value="">선택</option>
                        </select>
                    </div>
                </td>
                <th id="intervalBeginTypeTh">단위기간 시작기준</th>
                <td id="intervalBeginTypeTd">
                    <select class="custom_select" id="intervalBeginType" name="intervalBeginType">
                        <!-- 옵션 반복 -->
                        <option value="">선택</option>
                    </select>
                </td>
            </tr>
            <tr>
                <th id="dayWkLmtTh">일 기본근무시간 한도</th>
                <td id="dayWkLmtTd">
                    특정일 기본근무시간은
                    <div class="input-wrap px-2" style="width: 70px;">
                        <input class="form-input" id="dayWkLmt" name="dayWkLmt" type="text">
                    </div>시간을 초과 할 수 없습니다.
                    <p class="text-danger">* 일 기본근무시간 한도를 초과하는 근무시간은 연장근무시간으로 간주합니다.</p>
                </td>
                <th id="dayOtLmtTh">일 연장근무시간 한도</th>
                <td id="dayOtLmtTd">
                    특정일 연장근무는
                    <div class="input-wrap px-2" style="width: 70px;">
                        <input class="form-input" id="dayOtLmt" name="dayOtLmt" type="text">
                    </div>시간을 초과 할 수 없습니다.
                </td>
            </tr>
            <tr>
                <th id="weekWkLmtTh">주 기본근무시간 한도</th>
                <td id="weekWkLmtTd">
                    특정주 기본근무시간은
                    <div class="input-wrap px-2" style="width: 70px;">
                        <input class="form-input" id="weekWkLmt" name="weekWkLmt" type="text">
                    </div>시간을 초과 할 수 없습니다.
                    <p class="text-danger">* 주 기본근무시간 한도를 초과하는 근무시간은 연장근무시간으로 간주합니다.</p>
                </td>
                <th id="weekOtLmtTh">주 연장근무시간 한도</th>
                <td id="weekOtLmtTd">
                    특정주 연장근무는
                    <div class="input-wrap px-2" style="width: 70px;">
                        <input class="form-input" id="weekOtLmt" name="weekOtLmt" type="text">
                    </div>시간을 초과 할 수 없습니다.
                </td>
            </tr>
            <tr>
                <th id="avgWeekWkLmtTh">주 평균 기본근무시간 한도</th>
                <td id="avgWeekWkLmtTd">
                    1주 평균 기본근무시간은
                    <div class="input-wrap px-2" style="width: 70px;">
                        <input class="form-input" id="avgWeekWkLmt" name="avgWeekWkLmt" type="text">
                    </div>시간을 초과 할 수 없습니다.
                    <p class="text-danger">* 주 평균 기본근무시간 한도를 초과하는 근무시간은 연장근무시간으로 간주합니다.</p>
                </td>
                <th id="avgWeekOtLmtTh">주 평균 연장근무시간 한도</th>
                <td id="avgWeekOtLmtTd">
                    1주 평균 연장근무시간은
                    <div class="input-wrap px-2" style="width: 70px;">
                        <input class="form-input" id="avgWeekOtLmt" name="avgWeekOtLmt" type="text">
                    </div>시간을 초과 할 수 없습니다.
                </td>
            </tr>
            <tr>
                <th id="holInclYnTh">휴일 포함</th>
                <td id="holInclYnTd">
                    <div class="input-wrap">
                        <input type="checkbox" class="form-checkbox" id="holInclYn" name="holInclYn">
                        <label for="holInclYn">포함</label>
                    </div>
                </td>
                <th id="realBreakTimeYnTh">실시간 휴게(이석)관리</th>
                <td id="realBreakTimeYnTd">
                    <div class="input-wrap">
                        <input type="checkbox" class="form-checkbox" id="realBreakTimeYn" name="realBreakTimeYn">
                        <label for="realBreakTimeYn">포함</label>
                    </div>
                </td>
            </tr>
            </tbody>
        </table>
    </div>
</div>
