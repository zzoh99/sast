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
          <span class="sub-title">[7일 미만]</span>
          <ul class="dot-list">
            <li>사유 : 질병 사유 제한 없음</li>
            <li>연차 先 사용 : 잔여연차 소진 필수</li>
          </ul>
          <span class="sub-title mt-12">[7일 이상]</span>
          <ul class="dot-list">
            <li>사유 :
              <ul class="order-list">
                <li>(1) 국가 5대암 (위암/대장암/간암/유방암/자궁경부암) + 폐암</li>
                <li>(2) 중증질환 (심장질환 및 뇌혈관질환 등)</li>
                <li>(3) 법정전염병 (1군~4군, 지정감염병)</li>
                <li>(4) 업무 상 관련성이나 사회통념상 합리성이 상당히 인정되는 경우</li>
                <li>(5) 일반 질병으로 7일이상 입원필요</li>
              </ul>
            </li>
            <li>연차 先 사용 : (1) ~ (4)의 경우 잔여연차 소진 불필요
              <ul class="order-list">
                <li>(5)의 경우 잔여연차 소진 필수</li>
              </ul>
            </li>
          </ul>
        </dd>
      </div>
      <div class="list-item">
        <dt class="label-title">급여</dt>
        <dd class="desc">기본급 지급 (포괄수당 미지급)</dd>
      </div>
      <div class="list-item">
        <dt class="label-title">기간</dt>
        <dd class="desc">연간 최대 60일</dd>
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
