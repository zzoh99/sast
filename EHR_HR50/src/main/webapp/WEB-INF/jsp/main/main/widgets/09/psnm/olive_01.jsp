<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<link rel="stylesheet" type="text/css" href="/assets/css/welfare_psnm.css"/>
</head>
<body class="dialog-iframe">
    <dl class="list-wrap">
      <div class="list-item">
        <dt class="label-title">운영기준</dt>
        <dd class="desc">
          <div class="sub-title mt-12">[경조금]</div>
          <div class="table-wrap mt-12">
            <table class="default">
              <colgroup>
                <col width="11%">
                <col width="14%">
                <col width="13%">
                <col width="11%">
                <col width="13%">
                <col width="13%">
                <col width="*">
              </colgroup>
              <thead>
                <tr>
                  <th colspan="2">구분</th>
                  <th>경조금</th>
                  <th>휴가</th>
                  <th>화환/조화 지원</th>
                  <th>장례물품 지원</th>
                  <th>증빙서류</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <th rowspan="3">결혼</th>
                  <td>본인</td>
                  <td>50만원</td>
                  <td>5일</td>
                  <td>○</td>
                  <td>-</td>
                  <td>청첩장</td>
                </tr>
                <tr>
                  <td>자녀</td>
                  <td>50만원</td>
                  <td>2일</td>
                  <td>○</td>
                  <td>-</td>
                  <td>청첩장, 가족관계증명서</td>
                </tr>
                <tr>
                  <td>본인 형제/자매</td>
                  <td>20만원</td>
                  <td>1일</td>
                  <td>-</td>
                  <td>-</td>
                  <td>청첩장, 가족관계증명서</td>
                </tr>
                <tr>
                  <th rowspan="2">칠순</th>
                  <td>부모</td>
                  <td>30만원</td>
                  <td>1일</td>
                  <td>-</td>
                  <td>-</td>
                  <td>가족관계증명서</td>
                </tr>
                <tr>
                  <td>배우자 부모</td>
                  <td>30만원</td>
                  <td>1일</td>
                  <td>-</td>
                  <td>-</td>
                  <td>가족관계증명서</td>
                </tr>
                <tr>
                  <th>출생</th>
                  <td>자녀</td>
                  <td>100만원</td>
                  <td>-</td>
                  <td>-</td>
                  <td>-</td>
                  <td>가족관계증명서</td>
                </tr>
                <tr>
                  <th rowspan="8">사망</th>
                  <td>본인</td>
                  <td>1천만원</td>
                  <td>-</td>
                  <td>○</td>
                  <td>○</td>
                  <td>-</td>
                </tr>
                <tr>
                  <td>배우자</td>
                  <td>500만원</td>
                  <td>5일</td>
                  <td>○</td>
                  <td>○</td>
                  <td>사망진단서, 가족관계증명서</td>
                </tr>
                <tr>
                  <td>자녀</td>
                  <td>200만원</td>
                  <td>5일</td>
                  <td>○</td>
                  <td>○</td>
                  <td>사망진단서, 가족관계증명서</td>
                </tr>
                <tr>
                  <td>부모</td>
                  <td>100만원</td>
                  <td>5일</td>
                  <td>○</td>
                  <td>○</td>
                  <td>사망진단서, 가족관계증명서</td>
                </tr>
                <tr>
                  <td>배우자 부모</td>
                  <td>100만원</td>
                  <td>5일</td>
                  <td>○</td>
                  <td>○</td>
                  <td>사망진단서, 가족관계증명서</td>
                </tr>
                <tr>
                  <td>승중상</td>
                  <td>100만원</td>
                  <td>5일</td>
                  <td>○</td>
                  <td>○</td>
                  <td>사망진단서, 가족관계증명서</td>
                </tr>
                <tr>
                  <td>(외)조부모</td>
                  <td>50만원</td>
                  <td>3일</td>
                  <td>○</td>
                  <td>○</td>
                  <td>사망진단서, 가족관계증명서</td>
                </tr>
                <tr>
                  <td>본인 형제/자매</td>
                  <td>30만원</td>
                  <td>3일</td>
                  <td>-</td>
                  <td>-</td>
                  <td>사망진단서, 가족관계증명서</td>
                </tr>
              </tbody>
            </table>
          </div>
          <div class="sub-title mt-12">[경조휴가]</div>
          <ul class="dot-list">
            <li>경조 발생일(주말 제외)부터 사용</li>
            <li>조사의 경우, 사망일자 포함한 일자부터 경조 휴가 일수 카운트</li>
          </ul>
        </dd>
      </div>
      <div class="list-item">
        <dt class="label-title">특이사항</dt>
        <dd class="desc">
          <div class="sub-title">[경조금]</div>
          <ul class="dot-list">
            <li>구성원의 가족인 경우 가족등록 선행이 필요합니다.</li>
            <li>직책자의 결재를 득한 경우에만 지급</li>
            <li>당월 신청한 경조금은 익월 초에 지급됩니다.</li>
            <li>경조금 신청 시 경조사유 발생 1개월 이내(칠순에 한해 3개월 전후 가능) 신청 가능 하며, 신청 후 1개월 전후 경조금이 지급 됩니다.</li>
            <ul class="order-list pa-0 mt-12">
              <li>* 경조금을 기한 내 신청하지 못한 경우 경조신청 지연 품의 작성 必</li>
              <li>* 경조발생일로부터 1년이 넘었을 경우 지원 불가(단, 육아휴직 시 제외/육아휴직 종료 복직 후 1개월 이내 기안 승인)</li>
            </ul>
          </ul>
          <div class="sub-title mt-12">[경조휴가]</div>
          <ul class="order-list mt-12">
            <li>- 칠순 : 3개월 이내 사용 가능</li>
            <li>- 배우자출산휴가 : 출산일로부터 90일 내 사용, 최대 2회 분할 가능</li>
            <li>- 형제자매결혼 : 경조발생일 직전 금요일 또는 직후 월요일에만 사용 가능</li>
          </ul>
        </dd>
      </div>
      <div class="list-item">
        <dt class="label-title">필요서류</dt>
        <dd class="desc">
          구성원의 가족인 경우 가족등록 선행이 필요합니다.
        </dd>
      </div>
      <div class="list-item">
        <dt class="label-title">신청방법</dt>
        <dd class="desc">
          <a href="#" class="btn-link mt-12">위톡채널바로가기</a>
        </dd>
      </div>
    </dl>
  </body>
</html>
