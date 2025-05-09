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
          <div class="sub-title">[포인트지급]</div>
          <ul class="dot-list pa-0">
            <li>연초 재직자 기본포인트 지급</li>
            <li>중도 입사자의 경우, 입사 후 4개월차 지급 (연 기본포인트/12 x 잔여개월수)</li>
            <li>복직자는 복직 종료일 기준 월할 계산하여 배정 또는 차감</li>
          </ul>
          <div class="sub-title mt-12">[사용방법]</div>
          포인트 사용기간은 1년 (1/1 ~ 12/31), 이월 불가 및 잔여포인트는 자동소멸
          <ul class="order-list pa-0">
            <li>(1) 베네피아몰 : 포인트/개인카드/현금으로 구매 가능하며 포인트는 바로 차감</li>
            <li>(2) 오프라인 : 구매 후 영수증 승인 신청 가능</li>
            <li>(3) 복지카드 : 결제 후 포인트 차감 가능</li>
          </ul>
        </dd>
      </div>
      <div class="list-item">
        <dt class="label-title">특이사항</dt>
        <dd class="desc">
          휴직자는 사용 불가<br>
          베네피아 최초 로그인 계정 ID : psnm사번, PW : 사번
          <div class="sub-title mt-12">[베네피아 몰 사용방법]</div>
          <a href="#" class="btn-link mt-12">클릭</a>
        </dd>
      </div>
      <div class="list-item">
        <dt class="label-title">필요서류</dt>
        <dd class="desc">
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