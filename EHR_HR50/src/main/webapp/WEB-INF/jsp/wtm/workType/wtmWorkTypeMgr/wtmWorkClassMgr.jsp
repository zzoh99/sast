<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<!-- bootstrap -->
<link rel="stylesheet" type="text/css" href="/common/plugin/bootstrap/css/bootstrap.min.css" />
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%><!--common-->
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!-- 근태 css -->
<link rel="stylesheet" type="text/css" href="/assets/css/attendanceNew.css"/>
<script src="/common/plugin/bootstrap/js/bootstrap.min.js"></script>

<script type="text/javascript">
    var selectedWorkClassCd = "${selectedWorkClassCd}";
    var ctx = "${ctx}";
</script>
<script src="/assets/js/wtm/workType/wtmWorkClassMgr.js?ver=<%= System.currentTimeMillis() %>"></script> <!-- 스크립트 파일의 경로를 지정 -->

<style>
    .disabled {
        pointer-events: none;
        opacity: 0.5;
        cursor: default;
    }
</style>
</head>

<body class="iframe_content white attendanceNew">
<div class="row flex-grow-1 m-0">
    <div class="col-3 workType-content bg-grey">
        <h2 class="title-wrap">
            <div class="inner-wrap">
                <span class="page-title">근무유형<span class="cnt" id="workClassCnt">0개</span></span>
            </div>
            <div class="btn-wrap">
                <button type="button" class="btn outline_gray" id="addBtn">추가</button>
            </div>
        </h2>
        <div class="workType-list-wrap">
            <ul class="type-list">
            </ul>
        </div>
    </div>
        <div class="col-9 border-left typeDetail-content">
        <h2 class="title-wrap type-header">
            <div class="inner-wrap">
                <span class="page-title" id="workClassNmTitle"></span>
                <button type="button" class="btn outline_gray" id="toList" style="margin-left: 12px;">목록으로</button>
            </div>
            <!-- 버튼 리스트 -->
            <div class="btn-wrap">
            	<button type="button" class="btn outline_gray" id="deleteBtn">삭제</button>
                <button type="button" class="btn dark" id="saveBtn" style="display: none;">저장</button>
                <button type="button" class="btn outline" id="updateBtn" style="display: none;">수정</button>
                <button type="button" class="btn outline_blue icon_text" style="pointer-events: none;" id="workClassDefYn">기본 근무제 설정</button>
            </div>
        </h2>
        <div class="setting-wrap">
          <h2 class="title-wrap">
            <span class="page-title">기본설정</span>
            <div class="btn-wrap">
              <button type="button" class="btn outline" id="setEmpBtn">대상자 확인</button>
            </div>
          </h2>
        <form name="workTypeForm1" id="workTypeForm1">
            <div class="table-wrap mt-2 table-responsive">
                <table class="basic type5 line-grey">
                    <colgroup>
                        <col width="10%">
                        <col width="40%">
                        <col width="10%">
                        <col width="40%">
                    </colgroup>
                    <tbody>
                    <tr>
                        <th><span class="req"></span>근무명</th>
                        <td>
                            <div class="input-wrap wid-100">
                                <input class="form-input" type="text" id="workClassNm" name="workClassNm">
                                <input type="hidden" id="workClassCd" name="workClassCd"/>
                            </div>
                        </td>
                        <th><span class="req"></span>적용기간</th>
                        <td id="classDates">
                            <div class="input-wrap w-108"><input class="form-input" id="classSdate" name="sdate" type="text"></div>
                            <span class="text-center px-1">-</span>
                            <div class="input-wrap w-108"><input class="form-input" id="classEdate" name="edate" type="text"></div>
                        </td>
                    </tr>
                    <tr>
                        <th><span class="req"></span>근무제</th>
                        <td colspan="3">
                            <div class="input-wrap" id="workTypeRadio"></div>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </form>
        </div>
        <div class="workType-wrap">
            <!-- 근무제 별 설정 탭 -->
            <div class="main_tab_wrap">
                <div class="main_tab_menu">
                    <a class="tab_menu active" id="tab_01">
                        <span>기본설정</span>
                    </a>
                    <a class="tab_menu" id="tab_02">
                        <span>근무시간기준</span>
                    </a>
                    <a class="tab_menu" id="tab_03">
                        <span>출퇴근 설정</span>
                    </a>
                    <a class="tab_menu" id="tab_04">
                        <span>교대근무관리</span>
                    </a>
                    <!-- .tab_menu 반복 -->
                </div>
            </div>
            <form class="workTypeForm2" id="workTypeForm2">
                <%@ include file="wtmWorkClassBasicSetting.jsp" %>
                <%@ include file="wtmWorkClassTimeSetting.jsp" %>
                <%@ include file="wtmWorkClassAttendanceSetting.jsp" %>
            </form>
            <%@ include file="wtmWorkClassShiftSetting.jsp" %>
        </div>
    </div>
</div>
</body>
</html>