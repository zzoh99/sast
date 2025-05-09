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
          <span class="sub-title">[운영시간]</span>
          <ul class="dot-list">
            <li>카페 : 평일 AM 08:00~ PM 06:00 (주말 및 공휴일 Closing)</li>
            <li>Lounge & 무인 편의점 : 상시</li>
            <li>1인 휴게실 : 상시</li>
          </ul>
          <span class="sub-title">[운영사항]</span>
          <ul class="dot-list">
            <li>카페 : 키오스크 주문 결제 방식 (대량 주문시 최소 3시간 전 직원에게 요청)</li>
            <li>편의점 : 무인으로 운영되며 Self 결제 방식으로 운영</li>
          </ul>
        </dd>
      </div>
      <div class="list-item">
        <dt class="label-title">특이사항</dt>
        <dd>
          <span class="sub-title">[혜택]</span>
          <span class="desc">무인 편의점 내 구성원 가격 할인 (일반 GS25 편의점보다 20% 할인 가격 제공)</span>
        </dd>
      </div>
      <div class="list-item">
        <dt class="label-title">신청방법</dt>
        <dd class="desc">
          동호회비 지원금 신청 PS.NET 공지(담당자) → 동호회 활동 내역 위톡 채널에 게시(동호회 회장/총무) → 동호회비 지원 요건 충족여부 확인(담당자)  → 동호회비 지급(담당자)
          <div class="mt-12"><a href="#" class="btn-link">위톡채널바로가기</a></div>
        </dd>
      </div>
    </dl>
  </body>
</html>
