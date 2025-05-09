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
            <li>지원대상: 체육, 문화, 레저, 봉사활동 등의 동호회</li>
            <li>구성인원: 회원 7명 이상(단, 분기별 평균 참석율 60%이상 충족 必)</li>
            <li>활동 횟수: 분기 2회이상</li>
            <li>지원금: 월 1만원/ 인(월 2회이상 활동 시, 1회분만 지원)</li>
          </ul>
        </dd>
      </div>
      <div class="list-item">
        <dt class="label-title">필요서류</dt>
        <dd>
          <span class="sub-title">[동호회비 지원요청시]</span>
          <ul class="dot-list">
            <li>동호회 회원 리스트: 회장, 총무 기재 必(지원금은 총무의 월급 계좌로 입금)</li>
            <li>분기별 활동내역서: 날짜, 장소, 활동내용 등을 기재</li>
            <li>단체사진: 최소 인원 이상이 참석했음을 증빙</li>
            <li>참여 회원명: 동호회 활동에 참여한 회원을 기재</li>
            <li>증빙자료: 영수증, 카드 매출내역서, 출금내역서(사용용도, 업체명, 사용일자)</li>
          </ul>
        </dd>
      </div>
      <div class="list-item">
        <dt class="label-title">기간</dt>
        <dd class="desc">분기별</dd>
      </div>
      <div class="list-item">
        <dt class="label-title">특이사항</dt>
        <dd class="desc"><span class="sub-title">[동호회 개설 희망시]</span>
        동호회 신규 개설을 위한 추가 절차는 없으므로, 동호회비 지원 요건을 충족한 뒤 정산공지가 올라올 경우 활동내역을 보내주세요.
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
