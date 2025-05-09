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
        <dd class="desc">휴직시작 30일전까지 신청서 제출 시 허용</dd>
      </div>
      <div class="list-item">
        <dt class="label-title">필요서류</dt>
        <dd>
          신청자가 돌볼 수 밖에 없는 사유에 대한 증빙 필요 (예: 독자, 홀어머니 등)
          <ul class="order-list">
            <li>(1) 가족관계 증명서</li>
            <li>(2) 진단서</li> 
            <li>(3) 기타 증빙 서류 (휴교/방학 통지문 등)</li>
          </ul>
        </dd>
      </div>
      <div class="list-item">
        <dt class="label-title">기간</dt>
        <dd class="desc">
          연간 최장 90일 한도 (분할 사용 가능, 가족돌봄휴가 사용 시 일수 차감)<br>
          <span class="desc grey">* 단, 분할사용시 1회 기간은 30일 이상 되어야 함</span>
        </dd>
      </div>
      <div class="list-item">
        <dt class="label-title">특이사항</dt>
        <dd class="desc">* 연간 최장 90일 한도 (분할사용시 1회 기간은 30일 이상 되어야 함)</dd>
      </div>
      <div class="list-item">
        <dt class="label-title">신청방법</dt>
        <dd class="desc">아직 메뉴명을 모름</dd>
      </div>
      <div class="list-item">
        <dt class="label-title">추가문의</dt>
        <dd><a href="#" class="btn-link">위톡채널바로가기</a></dd>
      </div>
    </dl>
  </body>
</html>
