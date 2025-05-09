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
          <ul class="dot-list pa-0">
            <li>사유 : 병가 사유에 포함되지 않는 기타 질병 사유</li>
            <li>연차 先 사용 : 잔여 연차 소진 불필요</li>
          </ul>
        </dd>
      </div>
      <div class="list-item">
        <dt class="label-title">급여</dt>
        <dd class="desc">무급</dd>
      </div>
      <div class="list-item">
        <dt class="label-title">특이사항</dt>
        <dd class="desc">연간 최대 90일</dd>
      </div>
      <div class="list-item">
        <dt class="label-title">필요서류</dt>
        <dd class="desc">
          <ul class="order-list pa-0">
            <li>(1) 진단서 (상병코드/안정가료기간 기재 필수)</li>
            <li>(2) 입퇴원확인서(필요시)</li>
          </ul>
        </dd>
      </div>
      <div class="list-item">
        <dt class="label-title">신청방법</dt>
        <dd class="desc">
          <a href="#" class="btn-link">위톡채널바로가기</a>
        </dd>
      </div>
    </dl>
  </body>
</html>
