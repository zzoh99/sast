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
        <dd>
          <ul class="sub-list">
            <li>
              <span class="sub-title">10년</span><span class="desc">: 휴가 10일 (200만원 및 상패수여)</span>
            </li>
            <li>
              <span class="sub-title">15년</span><span class="desc">: 휴가 15일 (상패수여)</span>
            </li>
            <li>
              <span class="sub-title">20년</span><span class="desc">: 휴가 20일 (200만원 및 상패수여)</span>
            </li>
          </ul>
        </dd>
      </div>
      <div class="list-item">
        <dt class="label-title">기간</dt>
        <dd class="desc">5년 / 10년 / 15년 / 20년 단위</dd>
      </div>
      <div class="list-item">
        <dt class="label-title">신청방법</dt>
        <dd><a href="#" class="btn-link">위톡채널바로가기</a></dd>
      </div>
    </dl>
  </body>
</html>
