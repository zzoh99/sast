<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div id="content_01" class="typSetting-content active">
    <h2 class="title-wrap">
        <span class="page-title">기본설정</span>
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
                <th id="workDayTh">근무일</th>
                <td id="workDayTd" colspan="3">
                    <div class="input-wrap">
                        <div class="checkbox-wrap">
                            <input type="checkbox" class="form-checkbox workDay" id="workDay01" value="MON">
                            <label for="workDay01">월</label>
                        </div>
                        <div class="checkbox-wrap">
                            <input type="checkbox" class="form-checkbox workDay" id="workDay02" value="TUE">
                            <label for="workDay02">화</label>
                        </div>
                        <div class="checkbox-wrap">
                            <input type="checkbox" class="form-checkbox workDay" id="workDay03" value="WED">
                            <label for="workDay03">수</label>
                        </div>
                        <div class="checkbox-wrap">
                            <input type="checkbox" class="form-checkbox workDay" id="workDay04" value="THU">
                            <label for="workDay04">목</label>
                        </div>
                        <div class="checkbox-wrap">
                            <input type="checkbox" class="form-checkbox workDay" id="workDay05" value="FRI">
                            <label for="workDay05">금</label>
                        </div>
                        <div class="checkbox-wrap">
                            <input type="checkbox" class="form-checkbox workDay" id="workDay06" value="SAT">
                            <label for="workDay06">토</label>
                        </div>
                        <div class="checkbox-wrap">
                            <input type="checkbox" class="form-checkbox workDay" id="workDay07" value="SUN">
                            <label for="workDay07">일</label>
                        </div>
                    </div>
                    <input type="hidden" name="workDay" id="workDays">
                </td>
            </tr>
            <tr>
                <th id="weekRestDayTh">주휴일</th>
                <td id="weekRestDayTd">
                    <div class="input-wrap">
                        <input type="checkbox" class="form-checkbox weekRestDay" id="weekRestDay01" value="MON">
                        <label for="weekRestDay01">월</label>
                        <input type="checkbox" class="form-checkbox weekRestDay" id="weekRestDay02" value="TUE">
                        <label for="weekRestDay02">화</label>
                        <input type="checkbox" class="form-checkbox weekRestDay" id="weekRestDay03" value="WED">
                        <label for="weekRestDay03">수</label>
                        <input type="checkbox" class="form-checkbox weekRestDay" id="weekRestDay04" value="THU">
                        <label for="weekRestDay04">목</label>
                        <input type="checkbox" class="form-checkbox weekRestDay" id="weekRestDay05" value="FRI">
                        <label for="weekRestDay05">금</label>
                        <input type="checkbox" class="form-checkbox weekRestDay" id="weekRestDay06" value="SAT">
                        <label for="weekRestDay06">토</label>
                        <input type="checkbox" class="form-checkbox weekRestDay" id="weekRestDay07" value="SUN">
                        <label for="weekRestDay07">일</label>
                    </div>
                    <input type="hidden" name="weekRestDay" id="weekRestDays">
                </td>
                <th id="weekBeginDayTh">시작 요일</th>
                <td id="weekBeginDayTd">
                    <div class="input-wrap wid-33">
                        <select class="custom_select" id="weekBeginDay" name="weekBeginDay">
                            <!-- 옵션 반복 -->
                            <option value="">선택</option>
                            <option value="MON">월</option>
                            <option value="TUE">화</option>
                            <option value="WED">수</option>
                            <option value="THU">목</option>
                            <option value="FRI">금</option>
                            <option value="SAT">토</option>
                            <option value="SUN">일</option>
                        </select>
                    </div>
                </td>
            </tr>
            <tr>
                <th id="workHoursTh">표준 근무시간</th>
                <td id="workHoursTd">
                    <div class="input-wrap pr-2" style="width: 70px;"><input class="form-input" id="workHours" name="workHours" type="text"></div>시간
                </td>
                <th id="workTimeTh">출퇴근시간</th>
                <td id="workTimeTd">
                    <div class="input-wrap pr-2" style="width: 70px;"><input class="form-input" id="workTimeF" name="workTimeF" type="text"></div>&nbsp;-&nbsp;
                    <div class="input-wrap pr-2" style="width: 70px;"><input class="form-input" id="workTimeT" name="workTimeT" type="text"></div>
                </td>
                <th id="coreTimeTh">코어타임</th>
                <td id="coreTimeTd">
                    <div class="input-wrap pr-2" style="width: 70px;"><input class="form-input" id="coreTimeF" name="coreTimeF" type="text"></div>&nbsp;-&nbsp;
                    <div class="input-wrap pr-2" style="width: 70px;"><input class="form-input" id="coreTimeT" name="coreTimeT" type="text"></div>
                </td>
            </tr>
            <tr>
                <th id="sameDayChgYnTh">당일근무변경</th>
                <td id="sameDayChgYnTd">
                    <div class="input-wrap">
                        <input type="checkbox" class="form-checkbox" name="sameDayChgYn" id="sameDayChgYn">
                        <label for="sameDayChgYn">변경</label>
                    </div>
                </td>
                <th id="startWorkTimeTh">출근 가능 시간</th>
                <td id="startWorkTimeTd">
                    <div class="input-wrap pr-2" style="width: 70px;"><input class="form-input" id="startWorkTimeF" name="startWorkTimeF" type="text"></div>&nbsp;-&nbsp;
                    <div class="input-wrap pr-2" style="width: 70px;"><input class="form-input" id="startWorkTimeT" name="startWorkTimeT" type="text"></div>
                </td>
            </tr>
            <tr>
                <th id="applSetTh">근무스케줄 설정</th>
                <td id="applSetTd" colspan="3">
                    <button type="button" class="btn outline" id="approvalBtn">신청 설정</button>
                    <input id="applCd" name="applCd" type="hidden">
                    <input id="applUnit" name="applUnit" type="hidden">
                    <input id="applMinUnit" name="applMinUnit" type="hidden">
                    <input id="applMaxUnit" name="applMaxUnit" type="hidden">
                </td>
            </tr>
            <tr>
                <th id="breakTimeTh">기본 휴게시간</th>
                <td id="breakTimeTd" colspan="3">
                    <div class="btn-group-toggle" data-toggle="buttons" id="breakTypeBtn">
                        <label class="btn">
                            <input type="radio" name="breakTimeType" value="A" autocomplete="off">지정 휴게
                        </label>
                        <label class="btn">
                            <input type="radio" name="breakTimeType" value="B" autocomplete="off">근무시간기준
                        </label>
                        <label class="btn">
                            <input type="radio" name="breakTimeType" value="C" autocomplete="off">임직원자율
                        </label>
                    </div>
                    <div class="mt-2" id="breakTimeDetDiv">
                        <div class="breakTimeDet">
                            <div class="input-wrap pr-2" style="width: 70px;"><input class="form-input breakTime" type="text"></div> -
                            <div class="input-wrap px-2" style="width: 70px;"><input class="form-input breakTime" type="text"></div>
                            <button type="button" class="btn outline_gray ml-5 deleteBreakTimeDetBtn" style="display: none;">삭제</button>
                        </div>
                        <button type="button" class="btn outline btn-add ml-2" id="addBreakTimeDetBtn" style="display: none;">추가</button>
                        <input type="hidden" name="breakTimeDet" id="breakTimeDet">
                    </div>
                    <div class="mt-2" id="breakTimeTRDiv" style="display: none;">
                        <div class="input-wrap pr-2" style="width: 70px;"><input class="form-input" name="breakTimeT" id="breakTimeT" type="text"></div>시간 근무 시
                        <div class="input-wrap px-2" style="width: 70px;"><input class="form-input" name="breakTimeR" id="breakTimeR" type="text"></div>분 휴게입니다.
                    </div>
                </td>
            </tr>
            <tr>
                <th id="otBreakTimeTh">연장근무<br>휴게시간</th>
                <td id="otBreakTimeTd" colspan="3">
                    <div class="input-wrap pr-2" style="width: 70px;"><input class="form-input" name="otBreakTimeT" id="otBreakTimeT" type="text"></div>시간 근무 시
                    <div class="input-wrap px-2" style="width: 70px;"><input class="form-input" name="otBreakTimeR" id="otBreakTimeR" type="text"></div>분 휴게입니다.
                </td>
            </tr>
            </tbody>
        </table>
    </div>
</div>
