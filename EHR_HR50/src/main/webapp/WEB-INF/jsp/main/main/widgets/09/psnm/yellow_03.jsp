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
          출산일로부터 90일 이내 2회까지 분할 사용 가능합니다.<br>
          (예) 3일/4일/3일, 2일/5일/3일 등
        </dd>
      </div>
      <div class="list-item">
        <dt class="label-title">필요서류</dt>
        <dd class="desc">
          <ul class="order-list pa-0">
            <li>(1) HR시스템 내 가족사항 등록 필요</li>
            <li>(2) 가족 등록 후 배우자 출산 휴가 쿼터 생성 필요</li>
          </ul>
        </dd>
      </div>
      <div class="list-item">
        <dt class="label-title">급여</dt>
        <dd class="desc">10일 유급</dd>
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
