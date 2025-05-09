<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head></head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<script type="text/javascript">
    $(function() {
        const modal = window.top.document.LayerModalUtility.getModal('psnalSalaryMasterUserHistoryLayer');
        const arg = { ...modal.parameters };

        const url = "${ctx}/PsnalSalaryMasterUser.do?cmd=getPsnalSalaryMasterUserHistory";
            fetch(url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: new URLSearchParams(arg)
            })
            .then((response) => response.json())
            .then((resData) => {
                if(resData.Message) alert(resData.Message)

                if(resData.DATA) {
                    $("#dataWrapDiv").empty()
                    if(arg.type === 'tax') {
                        const taxInfoList = resData.DATA
						if(taxInfoList.length > 0) {
							taxInfoList.forEach(taxInfo => {
								const sdate = formatDate(taxInfo.sdate, '-')
								const edate = formatDate(taxInfo.edate, '-')
								const html = `
											 <div class="card rounded-16 pa-24 mb-12 bg-white">
												<p class="txt_body_sm sb mb-8">${'${sdate}'}~${'${edate}'}</p>
												 <div class="label_text_group mb-8">
													<div class="txt_body_sm">
														<span class="txt_secondary">배우자공제</span>
														<span class="sb">${'${taxInfo.spouseYn}'}</span>
													</div>
													<div class="txt_body_sm">
														<span class="txt_secondary">부양자(60세 이상)</span>
														<span class="sb">${'${taxInfo.familyCnt1}'}</span>
													</div>
													<div class="txt_body_sm">
														<span class="txt_secondary">부양자(20세 이하)</span>
														<span class="sb">${'${taxInfo.familyCnt2}'}</span>
													</div>
												</div>
												<div class="label_text_group">
													<div class="txt_body_sm">
														<span class="txt_secondary">외국인 과세구분</span>
														<span class="sb">${'${taxInfo.foreignYn}'}</span>
													</div>
													<div class="txt_body_sm">
														<span class="txt_secondary">외국근로비과세</span>
														<span class="sb">${'${taxInfo.abroadYn}'}</span>
													</div>
													<div class="txt_body_sm">
														<span class="txt_secondary">자녀수</span>
														<span class="sb">${'${taxInfo.addChildCnt}'}</span>
													</div>
												</div>
											</div>
											 `
								$("#dataWrapDiv").append(html)
							})
						} else {
							const html = `
								<div class="h-full d-flex flex-col justify-between align-center my-12">
								   <i class="icon no_list"></i>
								   <p class="txt_body_sm txt_tertiary">조회된 데이터가 없습니다.</p>
								</div>
							`
							$("#dataWrapDiv").append(html)
						}
                    } else if(arg.type === 'account') {
                        const accountInfoList = resData.DATA
						if(accountInfoList.length > 0) {

							accountInfoList.forEach(accInfo => {
								const sdate = formatDate(accInfo.sdate, '-')
								const edate = formatDate(accInfo.edate, '-')
								const html = `
											 <div class="card rounded-12 pa-24 bg-white mb-12">
												<p class="txt_title_xs sb txt_left mb-16">${'${accInfo.accountTypeNm}'}</p>
												<div class="label_text_group mb-8">
													<div class="txt_body_sm">
														<span class="txt_secondary">시작/종료일</span>
														<span class="sb">${'${sdate}'}~${'${edate}'}</span>
													</div>
												</div>
												<div class="label_text_group">
													<div class="txt_body_sm">
														<span class="txt_secondary">은행</span>
														<span class="sb">${'${accInfo.bankNm}'}</span>
													</div>
													<div class="txt_body_sm">
														<span class="txt_secondary">계좌번호</span>
														<span class="sb">${'${accInfo.accountNo}'}</span>
													</div>
													<div class="txt_body_sm">
														<span class="txt_secondary">예금주</span>
														<span class="sb">${'${accInfo.accName}'}</span>
													</div>
												</div>
											</div>
											 `
								$("#dataWrapDiv").append(html)
							})
						} else {
							const html = `
								<div class="h-full d-flex flex-col justify-between align-center my-12">
								   <i class="icon no_list"></i>
								   <p class="txt_body_sm txt_tertiary">조회된 데이터가 없습니다.</p>
							   </div>
							`
							$("#dataWrapDiv").append(html)
						}

                    }

                }
            }).catch((error) => {
                alert("조회에 실패했습니다.")
                console.error("Fetch error:", error);
            });
    });
</script>
</head>
<body class="bodywrap">
    <div class="wrapper modal_layer ux_wrapper bg-gray">
        <div class="modal_body" id="dataWrapDiv"></div>
		<div class="modal_footer">
        	<btn:a href="javascript:closeCommonLayer('psnalSalaryMasterUserHistoryLayer');" css="btn filled" mid='110881' mdef="닫기"/>
        </div>
    </div>
</body>
</html>

