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
          아래와 같은 경우 분할 사용이 가능합니다.
          <ul class="order-list">
            <li>(1) 유산 / 사산의 경험이 있는 경우</li>
            <li>(2) 구성원이 출산전후 휴가 신청시 만 40세 이상인 경우</li>
            <li>(3) 유산 / 사산의 위험이 있다는 의료기관의 진단서가 있는 경우</li> 
          </ul>
          ※ 단, 이 경우에도 출산 후 연속하여 45일(다태아는 60일) 이상이 되어야 함
        </dd>
      </div>
      <div class="list-item">
        <dt class="label-title">급여</dt>
        <dd class="desc">
          <ul class="sub-list">
            <li>
              <span class="sub-title">단태아</span>
              <span class="desc">60일 유급 + 30일 무급</span>
            </li>
            <li>
              <span class="sub-title">다태아</span>
              <span class="desc">75일 유급 + 45일 무급</span>
            </li>
          </ul>
        </dd>
      </div>
      <div class="list-item">
        <dt class="label-title">필요서류</dt>
        <dd class="desc">
          <ul class="order-list pa-0">
            <li>(1) 임신확인서</li>
            <li>(2) 진단서/소견서</li>
            <li>※ 유산경험, 유산 위험 사유 확인</li> 
          </ul>
        </dd>
      </div>
      <div class="list-item">
        <dt class="label-title">기간</dt>
        <dd class="desc">
          <ul class="sub-list">
            <li>
              <span class="sub-title">단태아</span>
              <span class="desc">90일 (출산 후 45일 이상 되도록 사용 필수)</span>
            </li>
            <li>
              <span class="sub-title">다태아</span>
              <span class="desc">120일 (출산 후 60일 이상 되도록 사용 필수)</span>
            </li>
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
