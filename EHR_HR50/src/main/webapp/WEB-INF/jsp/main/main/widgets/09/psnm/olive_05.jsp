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
        <dt class="label-title">제도설명</dt>
        <dd class="desc">
          구성원을 위해 저금리로 생활자금을 최소 100만원에서 최대 3,000만원까지 대여하는 제도입니다.<br>
          <ul class="order-list">
            <li>(이자 연 4.6% = 구성원 2%부담 + 회사 2.6%지원)</li>
          </ul>
        </dd>
      </div>
      <div class="list-item">
        <dt class="label-title">운영기준</dt>
        <dd class="desc">
          1년 이상 재직한 구성원 중 아래 지원기준에 해당되는 대상자<br>
          ※ 숫자는 우선순위를 의미합니다.
          <ul class="order-list">
            <li>① 의료비 : 본인 및 가족의 질병 또는 사고로 인해 장기치료를 요하는 경우</li>
            <li>② 주택 : 주택구입 및 임차비용 (무주택자) 주택수리비용(천재지변 등의 재해로 인한 경우)</li>
            <li>③ 학자금 : 본인 및 본인의 형제/자매의 학자금 지출</li>
            <li>④ 기타 : 위 사유 외 기타 타당한 사유로 단기자금지출 발생시 (대출한도 1천만원으로 제한)
              <ul class="order-list">
                <li>※ 4순위 제출서류 : 신용정보조회서, 사유증명 가능한 서류 제출 必</li>
              </ul>
            </li>
          </ul>
          <div class="sub-title">[상환 및 담보설정]</div>
          <ul class="order-list">
            <li>📌 사내대출 금액 급증으로 '24.3월부터 일시상환은 대출 실행이 되지 않고 있습니다. 분할상환으로 신청 바랍니다.  </li>
            <li>📌 사내대출 실행 시 서명하신 '소액대출 계약서' 제 3조 약정해지, 제 4조 대출금 상환, 제 5조 담보</li>
            <li>조항에 따라 약정된 기간에 채무를 담보하지 못하는 경우 즉시 계약은 해지됩니다. 
              <ul class="order-list">
                <li>- 본인이 신청한 목적으로 사용하지 않을 경우</li>
                <li>- 퇴직 및 휴직의 경우</li>
                <li>- 대출금 상환기간 중 본인의 급여가 제3자의 강제집행 대상이 된 경우</li>
                <li>- 기타채권 보전을 위하여 필요하다고 인정되는 경우</li>
              </ul>
            </li>
          </ul>
          <div>
            <img src="${ctx}/common/images/contents/psnm_loanMore.png" alt="대출상환 방법 및 담보설정">
          </div>
        </dd>
      </div>
      <div class="list-item">
        <dt class="label-title">특이사항</dt>
        <dd class="desc">
          본인 퇴직금의 70%까지 대출가능하며, 최대 3천만원 (1백만원 단위)
        </dd>
      </div>
      <div class="list-item">
        <dt class="label-title">필요서류</dt>
        <dd class="desc">
          ※ 밑줄 표기된 서류는 발급방법별도 안내
          <ul class="order-list">
            <li>① 의료비 : 가족관계증명서, 진단서, 의료비 영수증</li>
            <li>② 주택 : 주택계약서, <span class="under-line">무주택확인서</span>, <span class="under-line">지방세(세목별)과세증명서</span></li>
            <li>③ 학자금 : 가족관계증명서, 교육비고지서</li>
            <li>④ 기타 : <span class="under-line">신용정보조회서</span>, 사유증명 가능한 서류</li>
          </ul>
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
