<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="hidden">
<head>
	<title>개인임금마스터</title>
	<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
	<script type="text/javascript">
		$(function() {
            init();
            searchBasic()
		});

        function init() {
            /* 버튼 이벤트 */
            // 과세이력
            $("#btnTaxHistory").on('click', function () {
                callHistoryLayer('tax')
            })

            // 과세이력
            $("#btnAccountHistory").on('click', function () {
                callHistoryLayer('account')
            })
        }

        // 기본사항 검색
        function searchBasic() {
            const url = "${ctx}/PsnalSalaryMasterUser.do?cmd=getPsnalSalaryMasterUserBasic";
            fetch(url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: new URLSearchParams({ isCurrent: 'Y' })
            })
            .then((response) => response.json())
            .then((resData) => {
                if(resData.Message) alert(resData.Message)


                if(resData.DATA.taxInfoList && resData.DATA.taxInfoList.length > 0) {
                    const taxInfo = resData.DATA.taxInfoList[0] // 현재 유효한 과세 정보중 가장 최근의 정보만 가져온다
                    $("#taxDates").text(formatDate(taxInfo.sdate, '-') + "~" + formatDate(taxInfo.edate, '-'))
                    $("#taxSpouseYn").text(taxInfo.spouseYn)
                    $("#taxFamilyCnt1").text(taxInfo.familyCnt1)
                    $("#taxFamilyCnt2").text(taxInfo.familyCnt2)
                    $("#taxForeignYn").text(taxInfo.foreignYn)
                    $("#taxAbroadYn").text(taxInfo.abroadYn)
                    $("#taxAddChildCnt").text(taxInfo.addChildCnt)
                }

                if(resData.DATA.accountInfoList) {
                    const accountInfoList = resData.DATA.accountInfoList

                    $("#accountWrapDiv").empty()
                    accountInfoList.forEach(accInfo => {
                        const sdate = formatDate(accInfo.sdate, '-')
                        const edate = formatDate(accInfo.edate, '-')
                        const html = `
                             <div class="card rounded-12 pa-24 bg-white">
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
                        $("#accountWrapDiv").append(html)
                    })
                }
            }).catch((error) => {
                alert("조회에 실패했습니다.")
                console.error("Fetch error:", error);
            });
        }

        // 지급/공제내역 검색
        function searchPay() {
            const url = "${ctx}/PsnalSalaryMasterUser.do?cmd=getPsnalSalaryMasterUserPay";
            fetch(url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                }
            })
            .then((response) => response.json())
            .then((resData) => {
                if(resData.Message) alert(resData.Message)

                if(resData.DATA.payList) {
                    const payList = resData.DATA.payList

                    $("#payWrapDiv").empty()
                    payList.forEach(payInfo => {
                        const sdate = formatDate(payInfo.sdate, '-')
                        const edate = payInfo.edate ? formatDate(payInfo.edate, '-') : '-'
                        const html = `
                             <div class="card rounded-12 pa-24 bg-white">
                                <p class="txt_title_xs sb txt_left mb-16">${'${payInfo.elementNm}'}</p>
                                <div class="label_text_group mb-8">
                                    <div class="txt_body_sm">
                                        <span class="txt_secondary">통화단위</span>
                                        <span class="sb">${'${payInfo.currencyNm}'}</span>
                                    </div>
                                    <div class="txt_body_sm">
                                        <span class="txt_secondary">반영금액</span>
                                        <span class="sb">${'${payInfo.monthMon.toLocaleString()}'}</span>
                                    </div>
                                    <div class="txt_body_sm">
                                        <span class="txt_secondary">시작일</span>
                                        <span class="sb">${'${sdate}'}</span>
                                    </div>
                                    <div class="txt_body_sm">
                                        <span class="txt_secondary">종료일</span>
                                        <span class="sb">${'${edate}'}</span>
                                    </div>
                                </div>
                                <div class="label_text_group">
                                    <div class="txt_body_sm">
                                        <span class="txt_secondary">비고</span>
                                        <span class="sb">${'${payInfo.note}'}</span>
                                    </div>
                                </div>
                            </div>
                        `
                        $("#payWrapDiv").append(html)
                    })
                }

                if(resData.DATA.dedList) {
                    const dedList = resData.DATA.dedList

                    $("#dedWrapDiv").empty()
                    dedList.forEach(dedInfo => {
                        const sdate = formatDate(dedInfo.sdate, '-')
                        const edate = dedInfo.edate ? formatDate(dedInfo.edate, '-') : '-'
                        const html = `
                             <div class="card rounded-12 pa-24 bg-white">
                                <p class="txt_title_xs sb txt_left mb-16">${'${dedInfo.elementNm}'}</p>
                                <div class="label_text_group mb-8">
                                    <div class="txt_body_sm">
                                        <span class="txt_secondary">통화단위</span>
                                        <span class="sb">${'${dedInfo.currencyNm}'}</span>
                                    </div>
                                    <div class="txt_body_sm">
                                        <span class="txt_secondary">반영금액</span>
                                        <span class="sb">${'${dedInfo.monthMon.toLocaleString()}'}</span>
                                    </div>
                                    <div class="txt_body_sm">
                                        <span class="txt_secondary">시작일</span>
                                        <span class="sb">${'${sdate}'}</span>
                                    </div>
                                    <div class="txt_body_sm">
                                        <span class="txt_secondary">종료일</span>
                                        <span class="sb">${'${edate}'}</span>
                                    </div>
                                </div>
                                <div class="label_text_group">
                                    <div class="txt_body_sm">
                                        <span class="txt_secondary">비고</span>
                                        <span class="sb">${'${dedInfo.note}'}</span>
                                    </div>
                                </div>
                            </div>
                        `
                        $("#dedWrapDiv").append(html)
                    })
                }

            }).catch((error) => {
                alert("조회에 실패했습니다.")
                console.error("Fetch error:", error);
            });
        }

        // 연봉이력 검색
        function searchSalary() {
            const url = "${ctx}/PsnalSalaryMasterUser.do?cmd=getPsnalSalaryMasterUserSalary";
            fetch(url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                }
            })
            .then((response) => response.json())
            .then((resData) => {
                if(resData.Message) alert(resData.Message)

                const salaryTitleList = resData.DATA.salaryTitleList || [];
                const salaryList = resData.DATA.salaryList || [];

                // 연봉 이력 항목 타이틀 추가
                $("#salaryTitleTr th").not("[data-type='defaultTitle'], [data-type='defaultTitleLast']").remove();
                const lastTitleTh = $("#salaryTitleTr th[data-type='defaultTitleLast']");

                salaryTitleList.forEach(title =>{
                    $(`<th>${'${title.elementNm}'}</th>`).insertBefore(lastTitleTh)
                })

                // 연봉 이력 항목 데이터 입력
                const total = {};
                $("#salaryTableBody").empty()
                salaryList.forEach((salary, idx) =>{
                    const sdate = formatDate(salary.sdate, '-')
                    const edate = salary.edate ? formatDate(salary.edate, '-') : '-'

                    let html = `
                        <tr>
                            <td>${'${idx+1}'}</td>
                            <td>${'${sdate}'}</td>
                            <td>${'${edate}'}</td>
                   `
                    salaryTitleList.forEach(title =>{
                        const key = `s${'${salary.sdate}'}e${'${title.elementCd}'}Mon`
                        html += `<td>${'${salary[key].toLocaleString()}'}</td>`

                        // 합계 계산용
                        total[title.elementCd] = total[title.elementCd] ? total[title.elementCd] + salary[key] : salary[key];
                    })

                    html += `<td>${'${salary.bigo}'}</td> </tr>`

                    $("#salaryTableBody").append(html)
                })

                // 합계 행 생성
                $("#salaryTotalTr td").not("[data-type='noData'], [data-type='noDataLast']").remove();
                const lastTotalTd = $("#salaryTotalTr td[data-type='noDataLast']");
                salaryTitleList.forEach(title =>{
                    $(`<td>${'${total[title.elementCd].toLocaleString()}'}</td>`).insertBefore(lastTotalTd)
                })
            }).catch((error) => {
                alert("조회에 실패했습니다.")
                console.error("Fetch error:", error);
            })
        }

        // 급여압류 검색
        function searchPayGrns() {

            const url = "${ctx}/PsnalSalaryMasterUser.do?cmd=getPsnalSalaryMasterUserPayGrns";
            fetch(url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                }
            })
            .then((response) => response.json())
            .then((resData) => {
                if(resData.Message) alert(resData.Message)

                const bondList = resData.DATA.bondList || [];
                const dedList = resData.DATA.dedList || [];

                // 채권현황
                $("#grnsBondWrapDiv").empty()
                bondList.forEach(bond => {
                    let statusClass = ''
                    switch (bond.attatchStatus) {
                        case '1':
                            statusClass = 'peach'
                            break;
                        case '2':
                            statusClass = 'lilac'
                            break;
                        case '3':
                            statusClass = 'blue'
                            break;
                        case '4':
                            statusClass = 'river'
                            break;
                    }

                    const html = `
                        <div class="card rounded-12 pa-16-24 bg-white d-flex justify-between">
                            <div>
                                <div class="label_text_group line mb-8">
                                    <div class="txt_body_sm">
                                        <span class="txt_secondary">접수번호</span>
                                        <span class="sb">${'${bond.attatchNo}'}</span>
                                    </div>
                                    <div class="txt_body_sm">
                                        <span class="txt_secondary">접수일자</span>
                                        <span class="sb">${'${formatDate(bond.attatchSymd, "-")}'}</span>
                                    </div>
                                </div>
                                <div class="label_text_group">
                                    <div class="txt_body_sm">
                                        <span class="txt_secondary">적요</span>
                                        <span class="sb">${'${bond.debtContent}'}</span>
                                    </div>
                                    <div class="txt_body_sm">
                                        <span class="txt_secondary">채권자</span>
                                        <span class="sb">${'${bond.bonder}'}</span>
                                    </div>
                                    <div class="txt_body_sm">
                                        <span class="txt_secondary">채권금액</span>
                                        <span class="sb">${'${bond.attachMon.toLocaleString()}'}</span>
                                    </div>
                                </div>
                            </div>
                            <div>
                                <span class="chip sm ${'${statusClass}'}">${'${bond.attatchStatusNm}'}</span>
                            </div>
                        </div>
                    `
                    $("#grnsBondWrapDiv").append(html)
                })

                // 공제현황
                $("#grnsDedTableBody").empty()
                $("#grnsDedTotalTr td").not("[data-type='noData']").remove();
                if(dedList.length > 0) {
                    let paymentMonSum = 0, itaxMonSum = 0, rtaxMonSum = 0, npEeMonSum = 0, hiEeMonSum = 0, hiEeMon2Sum = 0, eiEeMonSum = 0, monSum = 0;
                    dedList.forEach((ded, idx) => {
                        const html = `
                            <tr>
                                <td>${'${idx}'}</td>
                                <td>${'${formatDate(ded.paymentYmd, "-")}'}</td>
                                <td>${'${ded.payNm}'}</td>
                                <td>${'${ded.paymentMon.toLocaleString()}'}</td>
                                <td>${'${ded.itaxMon.toLocaleString()}'}</td>
                                <td>${'${ded.rtaxMon.toLocaleString()}'}</td>
                                <td>${'${ded.npEeMon.toLocaleString()}'}</td>
                                <td>${'${ded.hiEeMon.toLocaleString()}'}</td>
                                <td>${'${ded.hiEeMon2.toLocaleString()}'}</td>
                                <td>${'${ded.eiEeMon.toLocaleString()}'}</td>
                                <td>${'${ded.mon.toLocaleString()}'}</td>
                            </tr>
                        `
                        $("#grnsDedTableBody").append(html)

                        // 항목별 합계 처리
                        paymentMonSum += ded.paymentMon;
                        itaxMonSum += ded.itaxMon;
                        rtaxMonSum += ded.rtaxMon;
                        npEeMonSum += ded.npEeMon;
                        hiEeMonSum += ded.hiEeMon;
                        hiEeMon2Sum += ded.hiEeMon2;
                        eiEeMonSum += ded.eiEeMon;
                        monSum += ded.mon;

                    })

                    // 합계 행 생성
                    $("#grnsDedTotalTr").append(`<td>${'${paymentMonSum.toLocaleString()}'}</td>`)
                    $("#grnsDedTotalTr").append(`<td>${'${itaxMonSum.toLocaleString()}'}</td>`)
                    $("#grnsDedTotalTr").append(`<td>${'${rtaxMonSum.toLocaleString()}'}</td>`)
                    $("#grnsDedTotalTr").append(`<td>${'${npEeMonSum.toLocaleString()}'}</td>`)
                    $("#grnsDedTotalTr").append(`<td>${'${hiEeMonSum.toLocaleString()}'}</td>`)
                    $("#grnsDedTotalTr").append(`<td>${'${hiEeMon2Sum.toLocaleString()}'}</td>`)
                    $("#grnsDedTotalTr").append(`<td>${'${eiEeMonSum.toLocaleString()}'}</td>`)
                    $("#grnsDedTotalTr").append(`<td>${'${monSum.toLocaleString()}'}</td>`)

                } else {
                    const html = `
                        <tr>
                            <td colspan="100%">
                                <div class="h-84 d-flex flex-col justify-between align-center my-12">
                                    <i class="icon no_list"></i>
                                     <p class="txt_body_sm txt_tertiary">조회된 데이터가 없습니다.</p>
                                </div>
                            </td>
                        </tr>
                    `
                    $("#grnsDedTableBody").append(html)
                }
                
                // 급여압류 데이터 호출 후 테이블 높이 계산
                var bondHeight = $(".bond_div").outerHeight(true)
                $(".deduction_div").css("height", "calc(100% - " + bondHeight + "px)");
                
            }).catch((error) => {
                alert("조회에 실패했습니다.")
                console.error("Fetch error:", error);
            })
        }

        // 사회보험 검색
        function searchInsr() {
            const url = "${ctx}/PsnalSalaryMasterUser.do?cmd=getPsnalSalaryMasterUserInsr";
            fetch(url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                }
            })
            .then((response) => response.json())
            .then((resData) => {
                if(resData.Message) alert(resData.Message)

                const insrStatus = resData.DATA.insrStatus || [];
                const insrCalcList = resData.DATA.insrCalcList || [];

                // 현재불입상태
                if(insrStatus) {
                    insrStatus.forEach(status => {
                        switch (status.gubun) {
                            case '국민연금':
                                $("#natSocStateNm").text(status.socStateNm)
                                $("#natRewardTotMon").text(status.rewardTotMon.toLocaleString())
                                $("#natRate").text(status.rate.toLocaleString())
                                $("#natSelfMon").text(status.selfMon.toLocaleString())
                                break
                            case '건강보험':
                                $("#hltSocStateNm").text(status.socStateNm)
                                $("#hltRewardTotMon").text(status.rewardTotMon.toLocaleString())
                                $("#hltRate").text(status.rate.toLocaleString())
                                $("#hltSelfMon").text(status.selfMon.toLocaleString())
                                break
                            case '요양보험료':
                                $("#careSocStateNm").text(status.socStateNm)
                                $("#careRewardTotMon").text(status.rewardTotMon.toLocaleString())
                                $("#careRate").text(status.rate.toLocaleString())
                                $("#caretSelfMon").text(status.selfMon.toLocaleString())
                                break
                            case '고용보험료':
                                $("#empSocStateNm").text(status.socStateNm.toLocaleString())
                                $("#empRewardTotMon").text(status.rewardTotMon.toLocaleString())
                                $("#empRate").text(status.rate.toLocaleString())
                                $("#empSelfMon").text(status.selfMon.toLocaleString())
                                break

                        }
                    })
                }

                // 년도별 건강/요양 보험료 정산
                $("#insrCalcTableBody").empty()
                if(insrCalcList.length > 0) {
                    insrCalcList.forEach((calc, idx) => {
                        const html = `
                            <tr>
                                <td>${'${idx + 1}'}</td>
                                <td>${'${calc.payYear}'}</td>
                                <td>${'${formatDate(calc.paymentYmd, "-")}'}</td>
                                <td>${'${calc.totEarningMon.toLocaleString()}'}</td>
                                <td>${'${calc.mon.toLocaleString()}'}</td>
                                <td>${'${calc.hiMon.toLocaleString()}'}</td>
                                <td>${'${calc.workCnt.toLocaleString()}'}</td>
                                <td>${'${calc.mon1.toLocaleString()}'}</td>
                                <td>${'${calc.mon2.toLocaleString()}'}</td>
                                <td>${'${calc.monTot.toLocaleString()}'}</td>
                                <td>${'${calc.mon3.toLocaleString()}'}</td>
                                <td>${'${calc.mon4.toLocaleString()}'}</td>
                                <td>${'${calc.realTot.toLocaleString()}'}</td>
                                <td>${'${calc.mon5.toLocaleString()}'}</td>
                                <td>${'${calc.mon6.toLocaleString()}'}</td>
                                <td>${'${calc.mon7.toLocaleString()}'}</td>
                            </tr>
                        `
                        $("#insrCalcTableBody").append(html)
                    })

                } else {
                    const html = `
                        <tr>
                            <td colspan="100%">
                                <div class="h-84 d-flex flex-col justify-between align-center my-12">
                                    <i class="icon no_list"></i>
                                     <p class="txt_body_sm txt_tertiary">조회된 데이터가 없습니다.</p>
                                </div>
                            </td>
                        </tr>
                    `
                    $("#insrCalcTableBody").append(html)
                }

            }).catch((error) => {
                alert("조회에 실패했습니다.")
                console.error("Fetch error:", error);
            })
        }

        // 임금피크 검색
        function searchPeak() {
            const url = "${ctx}/PsnalSalaryMasterUser.do?cmd=getPsnalSalaryMasterUserPeak";
            fetch(url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                }
            })
            .then((response) => response.json())
            .then((resData) => {
                if(resData.Message) alert(resData.Message)

                const peakList = resData.DATA || [];

                $("#peakWrapDiv").empty()
                if(peakList.length > 0) {
                    peakList.forEach((peak, idx) => {
                        const html = `
                            <div class="card rounded-12 pa-16-24 bg-white">
                                <div class="d-grid grid-cols-4 gap-16 align-center">
                                    <span class="txt_body_sm sb">${'${peak.year}'}년 차</span>
                                    <div class="d-flex flex-col gap-4">
                                        <span class="txt_body_sm txt_secondary">지급율(%)</span>
                                        <span class="txt_body_sm sb">${'${peak.rate}'}</span>
                                    </div>
                                    <div class="d-flex flex-col gap-4">
                                        <span class="txt_body_sm txt_secondary">시작/종료 월</span>
                                        <span class="txt_body_sm sb">${'${formatDate(peak.sYm, "-")}'} ~ ${'${formatDate(peak.eYm, "-")}'}</span>
                                    </div>
                                    <div class="d-flex flex-col gap-4">
                                        <span class="txt_body_sm txt_secondary">비고</span>
                                        <span class="txt_body_sm sb">${'${peak.bigo}'}</span>
                                    </div>
                                </div>
                            </div>
                        `
                        $("#peakWrapDiv").append(html)
                    })
                } else {
                    const html = `
                        <div class="h-full d-flex flex-col justify-between align-center my-12">
                            <i class="icon no_list"></i>
                            <p class="txt_body_sm txt_tertiary">조회된 데이터가 없습니다.</p>
                        </div>
                    `
                    $("#peakWrapDiv").append(html)
                }
            }).catch((error) => {
                alert("조회에 실패했습니다.")
                console.error("Fetch error:", error);
            })
        }

        // 이력 조회 레이어 호출
        function callHistoryLayer(type){
            const w 		= 960;
            const h 		= 720;
            const url = "/PsnalSalaryMasterUser.do?cmd=viewPsnalSalaryMasterUserHistoryLayer&authPg=R";
            const p = {
                type : type
            };

            const layer = new window.top.document.LayerModal({
                id: 'psnalSalaryMasterUserHistoryLayer',
                url: url,
                parameters: p,
                width: w,
                height: h,
                title: type === 'tax' ? '과세 이력' : '계좌 이력',
                trigger: [
                    {
                        name: 'psnalSalaryMasterUserHistoryLayerTrigger',
                        callback: function(rv) {
                        }
                    }
                ]
            });

            layer.show();
        }
	</script>
</head>
<body class="bodywrap">
	 <div class="wrapper">
            <div class="ux_wrapper">
                <div class="page_title mb-12">개인 임금 마스터</div>
                <div class="contents pa-0">
                    <div>
                        <div class="tab_container ma-auto mb-12 w-520">
                            <ul>
                                <li>
                                    <button onclick="searchBasic()" class="tab active" data-tab="tab1">기본사항</button>
                                </li>
                                <li>
                                    <button onclick="searchPay()" class="tab" data-tab="tab2">지급/공제 내역</button>
                                </li>
                                <li>
                                    <button onclick="searchSalary()" class="tab" data-tab="tab3">연봉이력</button>
                                </li>
                                <li>
                                    <button onclick="searchPayGrns()" class="tab" data-tab="tab4">급여압류</button>
                                </li>
                                <li>
                                    <button onclick="searchInsr()" class="tab" data-tab="tab5">사회보험</button>
                                </li>
                                <li>
                                    <button onclick="searchPeak()" class="tab" data-tab="tab6">임금피크</button>
                                </li>
                            </ul>
                        </div>
                        <div class="tab_content active" id="tab1">
                            <div class="salary_master_tab scroll-y">
                                <div class="card rounded-16 pa-24 mb-24">
                                    <div class="title_label_list">
                                        <div class="title d-flex gap-8">
                                            <i class="icon bag_won size-18"></i>
                                            <p class="txt_title_sm sb txt_left">연봉정보</p>
                                        </div>
                                        <div class="label_text_group mb-20 card bg-white rounded-12 pa-16-8 ">
                                            <div class="txt_title_xs">
                                                <span class="txt_secondary">연봉</span>
                                                <span class="sb">10,000,000</span>
                                            </div>
                                            <div class="txt_title_xs">
                                                <span class="txt_secondary">급여구분</span>
                                                <span class="sb">사무직 연봉제</span>
                                            </div>
                                            <div class="txt_title_xs">
                                                <span class="txt_secondary">직급</span>
                                                <span class="sb">수석연구원</span>
                                            </div>
                                            <div class="txt_title_xs">
                                                <span class="txt_secondary">연봉 적용 시작일</span>
                                                <span class="sb">2025-01-01</span>
                                            </div>
                                            <div class="txt_title_xs">
                                                <span class="txt_secondary">연봉 적용 종료일</span>
                                                <span class="sb">-</span>
                                            </div>
                                        </div>
                                        <!-- 보여줘야 하는 라벨이 9개 이상일 경우 아래 label_list에 .annual_label_list 클래스 추가 -->
                                        <div class="label_list gap-16 flex-row all-flex-1">
                                            <div class="d-flex flex-col align-center gap-4">
                                                <span class="txt_body_sm txt_secondary">연봉</span>
                                                <span class="txt_body_sm sb">10,000,000</span>
                                            </div>
                                            <div class="d-flex flex-col align-center gap-4">
                                                <span class="txt_body_sm txt_secondary">급여구분</span>
                                                <span class="txt_body_sm sb">사무직 연봉제</span>
                                            </div>
                                            <div class="d-flex flex-col align-center gap-4">
                                                <span class="txt_body_sm txt_secondary">직급</span>
                                                <span class="txt_body_sm sb">수석연구원</span>
                                            </div>
                                            <div class="d-flex flex-col align-center gap-4">
                                                <span class="txt_body_sm txt_secondary">연봉 적용 시작일</span>
                                                <span class="txt_body_sm sb">2025-01-01</span>
                                            </div>
                                            <div class="d-flex flex-col align-center gap-4">
                                                <span class="txt_body_sm txt_secondary">연봉 적용 종료일</span>
                                                <span class="txt_body_sm sb">-</span>
                                            </div>
                                            <div class="d-flex flex-col align-center gap-4">
                                                <span class="txt_body_sm txt_secondary">기본급</span>
                                                <span class="txt_body_sm sb">10,000,000</span>
                                            </div>
                                            <div class="d-flex flex-col align-center gap-4">
                                                <span class="txt_body_sm txt_secondary">고정 OT 수당</span>
                                                <span class="txt_body_sm sb">1,000,000</span>
                                            </div>
                                            <div class="d-flex flex-col align-center gap-4">
                                                <span class="txt_body_sm txt_secondary">식대(비과세)</span>
                                                <span class="txt_body_sm sb">100,000</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="card rounded-16 pa-24 mb-24">
                                    <div class="title_label_list">
                                        <div class="title d-flex gap-8 justify-between align-center">
                                            <div class="d-flex gap-8">
                                                <i class="icon graph size-18"></i>
                                                <p class="txt_title_sm sb txt_left txt-leading-100">과세정보</p>
                                            </div>
                                            <div class="mb-10">
                                                <button class="btn outline dark_gray" id="btnTaxHistory">과세 이력</button>
                                            </div>
                                        </div>
                                        <div>
                                            <p class="txt_body_sm sb mb-8" id="taxDates"></p>
                                            <div class="label_text_group mb-8">
                                                <div class="txt_body_sm">
                                                    <span class="txt_secondary">배우자공제</span>
                                                    <span class="sb" id="taxSpouseYn"></span>
                                                </div>
                                                <div class="txt_body_sm">
                                                    <span class="txt_secondary">부양자(60세 이상)</span>
                                                    <span class="sb" id="taxFamilyCnt1"></span>
                                                </div>
                                                <div class="txt_body_sm">
                                                    <span class="txt_secondary">부양자(20세 이하)</span>
                                                    <span class="sb" id="taxFamilyCnt2"></span>
                                                </div>
                                                <div class="txt_body_sm">
                                                    <span class="txt_secondary">외국인 과세구분</span>
                                                    <span class="sb" id="taxForeignYn"></span>
                                                </div>
                                                <div class="txt_body_sm">
                                                    <span class="txt_secondary">외국근로비과세</span>
                                                    <span class="sb" id="taxAbroadYn"></span>
                                                </div>
                                                <div class="txt_body_sm">
                                                    <span class="txt_secondary">자녀수</span>
                                                    <span class="sb" id="taxAddChildCnt"></span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="card rounded-16 pa-24 mb-12">
                                    <div class="title_label_list">
                                        <div class="title d-flex gap-8 justify-between align-center">
                                            <div class="d-flex gap-8">
                                                <i class="icon bank size-18"></i>
                                                <p class="txt_title_sm sb txt_left txt-leading-100">계좌정보</p>
                                            </div>
                                            <div class="mb-10 d-flex gap-8">
                                                <button class="btn outline dark_gray" id="btnAccountHistory">계좌 이력</button>
                                                <button class="btn outline dark_gray" id="btnAccount">계좌수정신청</button>
                                            </div>
                                        </div>
                                        <div class="d-flex flex-col gap-16" id="accountWrapDiv"></div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="tab_content" id="tab2">
                            <div class="d-grid grid-cols-2 gap-16 salary_master_tab">
                                <div class="card rounded-16 pa-24">
                                    <div class="title_label_list">
                                        <div class="title d-flex gap-8">
                                            <i class="icon money size-18"></i>
                                            <p class="txt_title_sm sb txt_left txt-leading-100">지급</p>
                                        </div>
                                        <div class="d-flex flex-col gap-16" id="payWrapDiv"></div>
                                    </div>
                                </div>

                                <div class="card rounded-16 pa-24">
                                    <div class="title_label_list">
                                        <div class="title d-flex gap-8">
                                            <i class="icon calculator_c size-18"></i>
                                            <p class="txt_title_sm sb txt_left txt-leading-100">공제</p>
                                        </div>
                                        <div class="d-flex flex-col gap-16" id="dedWrapDiv"></div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="tab_content" id="tab3">
                            <div>
                                <div class="title_label_list">
                                    <div class="title d-flex gap-8">
                                        <i class="icon bag_won size-18"></i>
                                        <p class="txt_title_sm sb txt_left txt-leading-100">연봉이력</p>
                                    </div>
                                    <div>
                                        <div class="scroll_table_wrap annual_table_wrap fixed_h">
                                            <table class="custom_table">
                                                <thead>
                                                    <tr id="salaryTitleTr">
                                                        <th data-type="defaultTitle">No</th>
                                                        <th data-type="defaultTitle">시작일</th>
                                                        <th data-type="defaultTitle">종료일</th>
                                                        <th data-type="defaultTitleLast">비고</th>
                                                    </tr>
                                                </thead>
                                                <tbody id="salaryTableBody"></tbody>
                                                <tfoot>
                                                    <tr class="total" id="salaryTotalTr">
                                                        <td data-type="noData"></td>
                                                        <td data-type="noData"></td>
                                                        <td data-type="noData"></td>
                                                        <td data-type="noDataLast"></td>
                                                    </tr>
                                                </tfoot>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="tab_content" id="tab4">
                            <div class="salary_master_tab">
                                <div class="card rounded-16 pa-24 mb-32 bond_div">
                                    <div class="title_label_list">
                                        <div class="title d-flex gap-8 justify-between align-center h-42">
                                            <div class="d-flex gap-8">
                                                <i class="icon bank size-18"></i>
                                                <p class="txt_title_sm sb txt_left txt-leading-100">채권현황</p>
                                            </div>
                                            <!-- <div class="mb-10">
                                                <button class="btn outline dark_gray" id="open_modal12">채권 더보기</button>
                                            </div> -->
                                        </div>
                                        <div class="d-flex flex-wrap gap-16 bond_card_wrap" id="grnsBondWrapDiv">
                                            <div class="card rounded-12 pa-16-24 bg-white d-flex justify-between"></div>
                                        </div>
                                    </div>
                                </div>
                                <div class="deduction_div">
                                    <div class="title_label_list">
                                        <div class="title d-flex gap-8">
                                            <i class="icon money size-18"></i>
                                            <p class="txt_title_sm sb txt_left txt-leading-100">공제현황</p>
                                        </div>
                                        <div>
                                            <div class="scroll_table_wrap deduction_wrap fixed_h">
                                                <table class="custom_table">
                                                    <thead>
                                                        <tr>
                                                            <th>No</th>
                                                            <th>공제일</th>
                                                            <th>급상구분</th>
                                                            <th>지급총액</th>
                                                            <th>소득세</th>
                                                            <th>주민세</th>
                                                            <th>국민연금</th>
                                                            <th>건강보험료</th>
                                                            <th>요양보험료</th>
                                                            <th>고용보험료</th>
                                                            <th>압류금액</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody id="grnsDedTableBody"></tbody>
                                                    <tfoot>
                                                        <tr class="total" id="grnsDedTotalTr">
                                                            <td data-type="noData"></td>
                                                            <td data-type="noData"></td>
                                                            <td data-type="noData"></td>
                                                        </tr>
                                                    </tfoot>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="tab_content" id="tab5">
                            <div class="salary_master_tab scroll-y">
                                <div class="card rounded-16 pa-24 mb-32">
                                    <div class="title_label_list">
                                        <div class="title d-flex gap-8">
                                            <i class="icon script size-18"></i>
                                            <p class="txt_title_sm sb txt_left txt-leading-100">현재불입상태</p>
                                        </div>
                                        <div class="d-grid grid-cols-4 gap-16">
                                            <div class="card rounded-12 pa-24 bg-white">
                                                <div class="d-flex gap-8 align-center justify-between mb-16">
                                                    <div class="d-flex gap-8 align-center">
                                                        <span class="icon_bg">
                                                            <i class="icon script size-16 bg-icon"></i>
                                                        </span>
                                                        <span class="txt_title_xs sb">국민연금</span>
                                                    </div>
                                                    <div>
                                                        <span class="chip sm" id="natSocStateNm"></span>
                                                    </div>
                                                </div>
                                                <div class="d-grid grid-cols-3 gap-16 align-center">
                                                    <div class="d-flex flex-col gap-4 align-center">
                                                        <span class="txt_body_sm txt_secondary">보수월액</span>
                                                        <span class="txt_body_sm sb" id="natRewardTotMon"></span>
                                                    </div>
                                                    <div class="d-flex flex-col gap-4 align-center">
                                                        <span class="txt_body_sm txt_secondary">보험료율</span>
                                                        <span class="txt_body_sm sb" id="natRate"></span>
                                                    </div>
                                                    <div class="d-flex flex-col gap-4 align-center">
                                                        <span class="txt_body_sm txt_secondary">보험료</span>
                                                        <span class="txt_body_sm sb" id="natSelfMon">3,600</span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="card rounded-12 pa-24 bg-white">
                                                <div class="d-flex gap-8 align-center justify-between mb-16">
                                                    <div class="d-flex gap-8 align-center">
                                                        <span class="icon_bg">
                                                            <i class="icon script size-16 bg-icon"></i>
                                                        </span>
                                                        <span class="txt_title_xs sb">건강보험</span>
                                                    </div>
                                                    <div>
                                                        <span class="chip sm" id="hltSocStateNm"></span>
                                                    </div>
                                                </div>
                                                <div class="d-grid grid-cols-3 gap-16 align-center">
                                                    <div class="d-flex flex-col gap-4 align-center">
                                                        <span class="txt_body_sm txt_secondary">보수월액</span>
                                                        <span class="txt_body_sm sb" id="hltRewardTotMon"></span>
                                                    </div>
                                                    <div class="d-flex flex-col gap-4 align-center">
                                                        <span class="txt_body_sm txt_secondary">보험료율</span>
                                                        <span class="txt_body_sm sb" id="hltRate"></span>
                                                    </div>
                                                    <div class="d-flex flex-col gap-4 align-center">
                                                        <span class="txt_body_sm txt_secondary">보험료</span>
                                                        <span class="txt_body_sm sb" id="hltSelfMon"></span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="card rounded-12 pa-24 bg-white">
                                                <div class="d-flex gap-8 align-center justify-between mb-16">
                                                    <div class="d-flex gap-8 align-center">
                                                        <span class="icon_bg">
                                                            <i class="icon script size-16 bg-icon"></i>
                                                        </span>
                                                        <span class="txt_title_xs sb">요양보험료</span>
                                                    </div>
                                                    <div>
                                                        <span class="chip sm" id="careSocStateNm"></span>
                                                    </div>
                                                </div>
                                                <div class="d-grid grid-cols-3 gap-16 align-center">
                                                    <div class="d-flex flex-col gap-4 align-center">
                                                        <span class="txt_body_sm txt_secondary">보수월액</span>
                                                        <span class="txt_body_sm sb" id="careRewardTotMon"></span>
                                                    </div>
                                                    <div class="d-flex flex-col gap-4 align-center">
                                                        <span class="txt_body_sm txt_secondary">보험료율</span>
                                                        <span class="txt_body_sm sb" id="careRate"></span>
                                                    </div>
                                                    <div class="d-flex flex-col gap-4 align-center">
                                                        <span class="txt_body_sm txt_secondary">보험료</span>
                                                        <span class="txt_body_sm sb" id="caretSelfMon"></span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="card rounded-12 pa-24 bg-white">
                                                <div class="d-flex gap-8 align-center justify-between mb-16">
                                                    <div class="d-flex gap-8 align-center">
                                                        <span class="icon_bg">
                                                            <i class="icon script size-16 bg-icon"></i>
                                                        </span>
                                                        <span class="txt_title_xs sb">고용보험</span>
                                                    </div>
                                                    <div>
                                                        <span class="chip sm" id="empSocStateNm">정상공제</span>
                                                    </div>
                                                </div>
                                                <div class="d-grid grid-cols-3 gap-16 align-center">
                                                    <div class="d-flex flex-col gap-4 align-center">
                                                        <span class="txt_body_sm txt_secondary">보수월액</span>
                                                        <span class="txt_body_sm sb" id="empRewardTotMon"></span>
                                                    </div>
                                                    <div class="d-flex flex-col gap-4 align-center">
                                                        <span class="txt_body_sm txt_secondary">보험료율</span>
                                                        <span class="txt_body_sm sb" id="empRate"></span>
                                                    </div>
                                                    <div class="d-flex flex-col gap-4 align-center">
                                                        <span class="txt_body_sm txt_secondary">보험료</span>
                                                        <span class="txt_body_sm sb" id="empSelfMon"></span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div>
                                    <div class="title_label_list">
                                        <div class="title d-flex gap-8">
                                            <i class="icon money size-18"></i>
                                            <p class="txt_title_sm sb txt_left txt-leading-100">년도별 건강/요양 보험료 정산</p>
                                        </div>
                                        <div>
                                            <table class="custom_table insurance">
                                                <thead>
                                                    <tr>
                                                        <th rowspan="2">No</th>
                                                        <th rowspan="2">귀속년도</th>
                                                        <th rowspan="2">급여반영일</th>
                                                        <th rowspan="2">소득총액</th>
                                                        <th rowspan="2">보수월액</th>
                                                        <th rowspan="2">보험료</th>
                                                        <th rowspan="2">근무월수</th>
                                                        <th colspan="3">확정보험료</th>
                                                        <th colspan="3">납부한보험료</th>
                                                        <th colspan="3">추가납부/환급보험료</th>
                                                    </tr>
                                                    <tr>
                                                        <th>건강보험료</th>
                                                        <th>요양보험료</th>
                                                        <th>합계</th>
                                                        <th>건강보험료</th>
                                                        <th>요양보험료</th>
                                                        <th>합계</th>
                                                        <th>건강보험료</th>
                                                        <th>요양보험료</th>
                                                        <th>합계</th>
                                                    </tr>
                                                </thead>
                                                <tbody id="insrCalcTableBody"></tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="tab_content" id="tab6">
                            <div class="salary_master_tab d-flex all-flex-1">
                                <div class="card rounded-16 pa-24">
                                    <div class="title_label_list">
                                        <div class="title d-flex gap-8">
                                            <i class="icon office size-18"></i>
                                            <p class="txt_title_sm sb txt_left txt-leading-100">임금피크정보</p>
                                        </div>
                                        <div class="d-flex flex-col gap-16" id="peakWrapDiv"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

	<script>
		/**
		 * 패키지 개선 탭
		 */
		$(document).ready(function () {
		    $(".ux_wrapper > .contents > div > .tab_container .tab").click(function () {
		        var $mainContainer = $(this).closest(".tab_container")
	
		        $mainContainer.find(".tab").removeClass("active")
		        $(this).addClass("active")
	
		        var tabId = $(this).data("tab")
		        $mainContainer.siblings(".tab_content").removeClass("active")
		        $mainContainer.siblings("#" + tabId).addClass("active")
		    })

		    function setDeductionHeight() {
                var bondHeight = $(".bond_div").outerHeight(true) // margin 포함한 전체 높이
                $(".deduction_div").css("height", "calc(100% - " + bondHeight + "px)");
            }

            // 초기 실행
            setDeductionHeight()

            // 창 크기 변경시 다시 계산
            $(window).on("resize", function () {
                setDeductionHeight()
            })

            $(".tab").on("click", function () {
                setDeductionHeight() // 탭 전환 애니메이션 후 실행
            })

            $(document).on("DOMNodeInserted", "#grnsBondWrapDiv, #grnsDedTableBody", function() {
                if($("#tab4").hasClass("active")) {
                    setDeductionHeight();
                }
            });

            
                
		})
		
		</script>
</body>
</html>
