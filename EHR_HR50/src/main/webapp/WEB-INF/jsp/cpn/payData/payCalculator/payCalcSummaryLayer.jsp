<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<!-- ajax error -->
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp" %>

<style>
    .calculation_complete_modal .summary_list li:last-child {
        padding-bottom: 58px;
    }

    .calculation_complete_modal .summary_list li .line#modalCompareArea {
        float: right;
        width: auto;
        transform: none;
    }

    .calculation_complete_modal .summary_list li .line#modalCompareArea .number {
        font-size: 18px;
        padding-top: 2px;
        padding-bottom: 2px;
        height: auto;
    }
</style>
<script>
var payCalcSummaryLayer = { id: 'payCalcSummaryLayer', 
							payActionCd: '', 
							payActionNm: '',
							paymentYmd: '' };
$(function() {
	const modal = window.top.document.LayerModalUtility.getModal(payCalcSummaryLayer.id);
	payCalcSummaryLayer = { ...payCalcSummaryLayer, ...modal.parameters };
	const p = { payActionCd: payCalcSummaryLayer.payActionCd };
	const d = ajaxCall("${ctx}/PayCalculator.do?cmd=getPaymentSummary", queryStringToJson(p), false).DATA;
	const totalAmount = d.compare.curMoney.toLocaleString('ko-KR');
	const [yyyy, mm, dd] = payCalcSummaryLayer.paymentYmd.split('-');
	
	//HEADER SETTING
	$('#modalPayActionNm').html(payCalcSummaryLayer.payActionNm + ' 계산을 완료했습니다!');
	$("#modalTotalMoney").html(totalAmount + '원')
	$('#modalPaymentYmd').html(yyyy + '년 ' + mm + '월 ' + dd + '일');
	//PEOPLES COUNT SETTING
	$('#modalTotals').html(d.peoples.totalCnt.toLocaleString('ko-KR'));
	$('#modalTargets').html(d.peoples.targetCnt.toLocaleString('ko-KR'));
	$('#modalNoTargets').html((d.peoples.totalCnt - d.peoples.totalCnt).toLocaleString('ko-KR'));

	//PAYMENT SETTING
	const payments = d.amount.filter(v => v.resultMon != '' && v.reportNm != '')
							 .reduce((a, c) => {
								 a += '<p class="line">\n';
								 a += '	<span class="name">총 ' + c.reportNm + '</span>\n';
								 a += '	<span ><span class="bold">' + c.resultMon + '</span> 원</span>\n';
								 a += '</p>\n';
								 return a;
							 }, '<div class="title bold">급여항목</div>\n');
	$('#modalPaymentsList').html(payments);

	//COMPARE SETTING
	const updown = d.compare.diffPer > 0 ? 'up':'down';
	const indecrease = d.compare.diffPer > 0 ? 'increase':'decrease';
	const compare = '<span class="name">금액</span>\n'
				  + '<span class="number ' + indecrease + '">\n'
				  + '	<i class="mdi-ico">arrow_drop_' + updown + '</i>\n'
				  + '	<span class="percent">\n'
				  + Math.abs(d.compare.diffPer) + '%\n'
				  + '	</span>\n'
				  + '	<span class="bold">' + d.compare.diffMoney.toLocaleString('ko-KR') + '</span> 원\n'
				  + '</span>\n';
	$('#modalCompareArea').html(compare);
	//FOOTER SETTING
	$('#modalPaymentTotalAmount').html(totalAmount);
});

function closeCalCompleteModal() {
	const modal = window.top.document.LayerModalUtility.getModal(payCalcSummaryLayer.id);
	modal.hide();
}
</script>
<div class="calculation_complete_modal modal_layer">
  <div class="modal_body">
    <div class="modal_body_content">
      <div class="complete_message">
        <div class="first_line">
          <i class="mdi-ico outlined">savings</i>
          <span id="modalPayActionNm" class="message_top bold"></span>
        </div>
        <div class="second_line">
          계산된 급여는 총 지급액 <span id="modalTotalMoney" class="bold"></span>이며, 지급일자는 <span id="modalPaymentYmd" class="bold"></span> 입니다.
        </div>
      </div>
      <div class="content summary">
        <ul class="summary_list">
          <li>
            <div class="title bold">급여대상자</div>
            <p class="line">
              <span class="name">총인원</span>
              <span ><span id="modalTotals" class="bold"></span> 명</span>
            </p>
            <p class="line">
              <span class="name">지급대상</span>
              <span ><span id="modalTargets" class="bold"></span> 명</span>
            </p>
            <p class="line">
              <span class="name">예외인원</span>
              <span ><span id="modalNoTargets" class="bold"></span> 명</span>
            </p>
          </li>
          <li id="modalPaymentsList">
          </li>
          <li>
            <div class="title bold">전월대비 증/감 금액</div>
            <p class="line" id="modalCompareArea">
            </p>
          </li>
        </ul>
        <div class="total_amount_spent">
          <span class="name bold">총 지출액</span>
          <span ><span id="modalPaymentTotalAmount" class="bold amount"></span> 원</span>
        </div>
      </div>
    </div>
  </div>
  <div class="modal_footer">
    <button id="modal_submit_btn" class="btn outline_gray" onclick="closeCalCompleteModal()">확인</button>
  </div>
</div>