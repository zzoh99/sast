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
          <span class="sub-title">[검진구분]</span>
          <ul class="dot-list">
            <li>공단검진</li>
            <li><span class="point-red">회사(준종합/종합)검진</span> : 복리후생 차원에서 회사가 전문업체와 연계하여 지원/제공해주는 서비스</li>
          </ul>
          <span class="sub-title">[진행구분]</span>
          <span class="point-red">신규 입사 구성원은 입사일 기준 2개월 내 공단검진 수검 필수<br>
            ※단, 전직장에서 당해년도 검진 수검완료 시 제외 가능</span>
          공단검진 / 준종합(회사)검진은 격년단위로 진행<br>
          (예) 24년 <span class="point-red">준종합검진</span> > 25년 공단검진
          <ul class="dot-list">
            <li>남성 만 40세, 여성 35세 미만은 준/종합검진(검사항목 약 70가지)</li>
            <li>남성 만 40세 이상, 여성 35세 이상은 매년 종합검진 지원(검사항목 약 90~120가지)</li>
            <li>종합검진(가족)은 배우자 연령이 종합검진 기준에 부합되는 경우, 배우자 또는 *부모(*구성원 또는 배우자의 부모) 중 1명 선택하여 매년 지원 가능</li>
          </ul>
          ( 단, 인사정보 가족등록자에 한하며 <span class="point-red">가족검진 변경/신청 절차에 따라 신청/변경한 경우에만 지원. 임의로 베네피아에 가족 검진대상 등록 시 본인부담 비용 발생하며, 해당 비용은 회사지원 불가</span> ) <br>
          * 참고사항: 공단검진(국가건강검진) / 회사검진(준종합검진 or 종합검진)
        </dd>
      </div>
      <div class="list-item">
        <dt class="label-title">신청방법</dt>
        <dd class="desc">
          베네피아를 통해 <span class="point-red">희망 검진 기관 및 일정 예약</span>
        </dd>
      </div>
    </dl>
  </body>
</html>
