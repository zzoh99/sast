<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='112100' mdef='개인별 급여 내역'/></title>
<style>
  .salary_paystub_wrap .paystub_list li .line .line_child.line_left {
      width: 30%;
  }
  .salary_paystub_wrap .paystub_list li .line .line_child.line_right {
    width: 70%;
  }
</style>

<script type="text/javascript">
	var payCalcLayer = { id: 'payCalcLayer' };
	$(function() {
		const modal = window.top.document.LayerModalUtility.getModal(payCalcLayer.id);
		var { searchSabun, payActionCd } = modal.parameters;
        const param = {payActionCd, searchSabun};
        settingHeader(param);

		//데이터 조회
		const amount = ajaxCall('${ctx}/PayCalculator.do?cmd=getPayCalcFormila', {...param, elementType:'A'}, false).DATA;
		const deduct = ajaxCall('${ctx}/PayCalculator.do?cmd=getPayCalcFormila', {...param, elementType:'D'}, false).DATA;
		//const time = ajaxCall(ctx + '/PayCalculator.do?cmd=getPayCalcWorkTime', param, false).DATA;

		settingPayment(amount, deduct);
		//settingTime(time);
	});

	function settingHeader(param) {
		var datetime = new Date().getTime();
		var imageUrl = '/EmpPhotoOut.do?enterCd=${ssnEnterCd}&searchKeyword=' + param.searchSabun + '&t=' + datetime;
		$('#payCalcImage').attr('src', imageUrl);
		const personal = ajaxCall('${ctx}/PayCalculator.do?cmd=getPayCalcPersonalInfo', queryStringToJson(param), false).DATA;
		Object.keys(personal).forEach(p => { if ($('#' + p)) $('#' + p).html(personal[p]); });
		$('#amountTitle').html(personal.payActionNm + ' 실수령액');
	}

	//지급, 공제 영역 
	function settingPayment(amount, deduct) {
		//지급합계
		const totalA = amount.reduce((a, c) => a + c.resultMon, 0);
		//공제합계
		const totalD = deduct.reduce((a, c) => a + c.resultMon, 0);
		//실지급액
		const totalAmount = totalA - totalD;
		
		$('#totalA').html(totalA.toLocaleString('ko-KR'));
		$('#totalD').html(totalD.toLocaleString('ko-KR'));
		$('#totalAmount').html(totalAmount.toLocaleString('ko-KR'));

		const amountHtml = amount.reduce((a, c) => {
			a += '<p class="line">\n';
			a += '	<span class="line_child line_left">\n';
			a += '		<span class="name">' + c.reportNm + '</span>\n';
			a += '	</span>\n';
			a += '	<span class="line_child line_right">\n';
			a += '		<span class="name">' + c.formula + '</span>\n';
			a += '		<span ><span class="bold">' + c.resultMon.toLocaleString('ko-KR') + '</span> 원</span>\n';
			a += '	</span>\n';
			a += '</p>\n';
			return a;
		}, '');

		$('#amountArea').append(amountHtml);

		const deductHtml = deduct.reduce((a, c) => {
			a += '<p class="line">\n';
			a += '	<span class="line_child line_left">\n';
			a += '		<span class="name">' + c.reportNm + '</span>\n';
			a += '	</span>\n';
			a += '	<span class="line_child line_right">\n';
			a += '		<span class="name">' + c.formula + '</span>\n';
			a += '		<span ><span class="bold">' + c.resultMon.toLocaleString('ko-KR') + '</span> 원</span>\n';
			a += '	</span>\n';
			a += '</p>\n';
			return a;
		}, '');

		$('#deductArea').append(deductHtml);
	}
	
</script>
</head>
<body>
    <div class="wrapper modal_layer">
        <div class="modal_body">
            <div class="salary_paystub_wrap">
              <div class="popup_body">
                <div class="top">
                  <div class="profile">
                    <img id="payCalcImage" alt="">
                    <p>
                      <span id="name" class="name bold"></span>
                      <br/>
                      <span class="detail">
                        <span id="jikweeNm"></span>
                        <span id="jikchakNm"></span>
                        <span id="sabun"></span>
                      </span>
                    </p>
                  </div>
                  <div class="actual_salary">
                    <span id="amountTitle" class="name"></span>
                    <br/>
                    <span class="bold salary">
                      <p>
                        <span id="totalAmount" class="num"></span> 원
                      </p>
                    </span>
                  </div>
                </div>
                <div class="bot">
                  <div class="content">
                    <div class="paystub">
                      <ul class="paystub_list">
                        <li id="amountArea">
                          <div class="title bold">
                            <span>지급합계</span>
                            <span class="num_box">
                              <span id="totalA" class="num"></span>
                              <span>원</span>
                            </span>
                          </div>
                        </li>
                        <li id="deductArea">
                          <div class="title bold">
                            <span>공제합계</span>
                            <span class="num_box">
                              <span id="totalD" class="num"></span>
                              <span>원</span>
                            </span>
                          </div>
                        </li>
                      </ul>
                    </div>
                  </div>
                </div>
              </div>
            </div>
        </div>
        <div class="modal_footer">
            <btn:a href="javascript:closeCommonLayer('payCalcLayer');" css="gray large" mid='110881' mdef="닫기"/>
        </div>
    </div>
  </body>
</html>



