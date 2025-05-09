<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="hidden">
<head>
	<title><tit:txt mid='104379' mdef='급여내역'/></title>
	<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>

    <script src="${ctx}/common/plugin/EIS/js/chart.js?ver=<%= System.currentTimeMillis()%>" type="text/javascript"></script>

	<script type="text/javascript">
		$(function() {
			const modal = window.top.document.LayerModalUtility.getModal('psnalPayDetailUserLayer');
			const arg = modal.parameters;
            const payActionCd = arg.payActionCd;

			init(payActionCd);
		});

		async function init(payActionCd = "") {
            await renderPayActionList(payActionCd);
			await renderPayDetail();
            initBtnEvent();
		}

        async function renderPayActionList(payActionCd) {

            const payActionList = await getPayActionList();
            if (payActionList == null) return;

            renderPayActionCds(payActionList);
            if (payActionCd != null && payActionCd !== "")
                $("#searchPayActionCd").val(payActionCd);
        }

        function renderPayActionCds(list) {
            const $selectBox = $("#searchPayActionCd");
            for(const obj of list) {
                $selectBox.append(`<option></option>`);
                const $last = $selectBox.children().last();
                $last.prop("value", obj.code);
                $last.text(obj.codeNm);
            }
        }

		async function renderPayDetail() {

			const payDetail = await getPayDetail();
            if (payDetail == null) return;

            if (payDetail.isOpenYn === "N") {
                alert("아직 임직원에게 오픈되지 않은 급여입니다. 담당자에게 문의 바랍니다.");

                closeDetailLayer();
                return;
            }

            setSummary(payDetail.summary);
            renderPay(payDetail.pay);
            renderDeduct(payDetail.deduct);
            renderBasic(payDetail.basic);
            renderEtcList(payDetail.etcList);
		}

        function setSummary(summary) {
			const $summaryArea = $("#summaryArea");

            drawSummaryChart(summary);
            $summaryArea.find(".txt_title_sm").text(summary.payActionNm);
            $summaryArea.find("#paymentMonArea .txt_title_sm").text(summary.paymentMon);
            $summaryArea.find("#totEarningMonArea .txt_title_sm").text(summary.totEarningMon);
            $summaryArea.find("#notaxTotMonArea .sb").text(summary.notaxTotMon);
            $summaryArea.find("#taxibleEarnMonArea .sb").text(summary.taxibleEarnMon);
            $summaryArea.find("#familyCntArea .sb").text(summary.familyCnt);
            $summaryArea.find("#addChildCntArea .sb").text(summary.addChildCnt);

            $summaryArea.find("#totDedMonArea .sb").text(summary.totDedMon);
            $summaryArea.find("#itaxMonArea .sb").text(summary.itaxMon);
            $summaryArea.find("#rtaxMonArea .sb").text(summary.rtaxMon);
            $summaryArea.find("#etcDedMonArea .sb").text(summary.etcDedMon);
        }

        function drawSummaryChart(summary) {
            if (summary == null) return;
            HR_CHART["APEX_PIE_BASIC"].render("#chartArea", getCharOption(), getChartData(summary));
        }

        function getCharOption() {
            return {
                chart: {
                    type: "donut",
                    toolbar: {
                        show: true,
                        tools: {
                            download: true
                        }
                    },
                },
                colors: ["#1D56E7", "#59C9D9"],
                dataLabels: {
                    enabled: true,
                    formatter: function(val, opts) {
                        let calcedValue;
                        if (opts.seriesIndex === 0) {
                            calcedValue = Math.ceil(val);
                        } else {
                            calcedValue = Math.floor(val);
                        }
                        return calcedValue + "%"
                    }
                },
                plotOptions: {
                    pie: {
                        donut: {
                            size: '45%'
                        }
                    }
                },
                legend: {
                    show: false
                },
                responsive: [{
                    breakpoint: 500,
                    options: {
                        chart: {
                            width: 250
                        },
                        legend: {
                            position: 'bottom'
                        }
                    }
                }]
            };
        }

        function getChartData(summary) {
            const totPayMon = Number(summary.totEarningMon.replace(/,/gi, ""));
            const totDedMon = Number(summary.totDedMon.replace(/,/gi, ""));
            const totMon = totPayMon + totDedMon;

            const payMonRate = Math.round((totPayMon / totMon) * 100);
            const dedMonRate = 100 - payMonRate;

            return [
                {
                    "seriesIdx": 0,
                    "seriesCode": "TOT_PAY_MON",
                    "categoryLabel": "지급총액",
                    "seriesData": totPayMon
                },
                {
                    "seriesIdx": 0,
                    "seriesCode": "TOT_DED_MON",
                    "categoryLabel": "공제총액",
                    "seriesData": totDedMon
                },
            ];
        }

        function getValue(value) {
            return (value == null || value === "") ? "-" : value;
        }

        function renderPay(pay) {

            const $payArea = $("#payArea");
            const $payItemWrap = $payArea.find("#payItemWrap");
            $payItemWrap.empty();

            if (pay.length === 1) {
                // 지급총액 행만 존재한다면
                $payArea.find(".card").eq(0).find(".txt_title_sm").text("-");
                const html = getNoDataHtml();
                $payItemWrap.append(html);
                return;
            }

            const payTot = Array.from(pay).filter(map => map.type === "PAY_TOT")[0];
            $payArea.find(".card").eq(0).find(".txt_title_sm").text(payTot.resultMon);

            const list = Array.from(pay).filter(map => map.type !== "PAY_TOT");
            for (const map of list) {
                const html = getPayItemHtml();
                $payItemWrap.append(html);
                const $last = $payItemWrap.children().last();
                $last.find(".txt_secondary").text(getValue(map.reportNm));
                $last.find(".sb").text(getValue(map.resultMon));
            }
        }

        function getNoDataHtml() {
            return `<div class="h-84 d-flex flex-col justify-between align-center my-12">
						<i class="icon no_list"></i>
						<p class="txt_body_sm txt_tertiary">조회된 데이터가 없습니다.</p>
					</div>`;
        }

        function getPayItemHtml() {
            return `<div class="d-flex w-full justify-between">
					    <span class="txt_body_sm txt_secondary"></span>
					    <span class="txt_body_sm sb"></span>
					</div>`;
        }

        function renderDeduct(deduct) {

            const $deductArea = $("#deductArea");
            const $deductItemWrap = $deductArea.find("#deductItemWrap");
            $deductItemWrap.empty();

            if (deduct.length === 1) {
                // 공제총액 행만 존재한다면
                $deductArea.find(".card").eq(0).find(".txt_title_sm").text("-");
                const html = getNoDataHtml();
                $deductItemWrap.append(html);
                return;
            }

            const deductTot = Array.from(deduct).filter(map => map.type === "DEDUCT_TOT")[0];
            $deductArea.find(".card").eq(0).find(".txt_title_sm").text(deductTot.resultMon);

            const list = Array.from(deduct).filter(map => map.type !== "DEDUCT_TOT");
            for (const map of list) {
                const html = getDeductItemHtml();
                $deductItemWrap.append(html);
                const $last = $deductItemWrap.children().last();
                $last.find(".txt_secondary").text(getValue(map.reportNm));
                $last.find(".sb").text(getValue(map.resultMon));
            }
        }

        function getDeductItemHtml() {
            return `<div class="d-flex w-full justify-between">
					    <span class="txt_body_sm txt_secondary"></span>
					    <span class="txt_body_sm sb"></span>
					</div>`;
        }

        function renderBasic(basic) {

            const $basicArea = $("#basicArea");
            const $basicItemWrap = $basicArea.find("#basicItemWrap");
            $basicItemWrap.empty();

            if (basic.length === 1) {
                // 급여기초총액 행만 존재한다면
                $basicArea.find(".card").eq(0).find(".txt_title_sm").text("-");
                const html = getNoDataHtml();
                $basicItemWrap.append(html);
                return;
            }

            const basicTot = Array.from(basic).filter(map => map.type === "BASIC_TOT")[0];
            $basicArea.find(".card").eq(0).find(".txt_title_sm").text(basicTot.resultMon);

            const list = Array.from(basic).filter(map => map.type !== "BASIC_TOT");
            for (const map of list) {
                const html = getBasicItemHtml();
                $basicItemWrap.append(html);
                const $last = $basicItemWrap.children().last();
                $last.find(".txt_secondary").text(getValue(map.reportNm));
                $last.find(".sb").text(getValue(map.resultMon));
            }
        }

        function getBasicItemHtml() {
            return `<div class="d-flex w-full justify-between">
					    <span class="txt_body_sm txt_secondary"></span>
					    <span class="txt_body_sm sb"></span>
					</div>`;
        }

        function renderEtcList(etcList) {

            const $etcListTbody = $("#etcListArea tbody");
            $etcListTbody.empty();

            if (etcList.length === 0) {
                const noDataHtml = getNoDataHtml();
                $etcListTbody.append(`<tr><td colspan="8">${'${noDataHtml}'}</td></tr>`);
                return;
            }

            for (const map of etcList) {
                const html = getEtcListItemHtml();
                $etcListTbody.append(html);
                const $last = $etcListTbody.children().last();
                $last.find("td").eq(0).text(getValue(map.bizNm));
                $last.find("td").eq(1).text(getValue(map.elementNm));
                $last.find("td").eq(2).text(getValue(map.eleValue));
                $last.find("td").eq(3).text(getValue(map.unit));
                $last.find("td").eq(4).text(getValue(map.bizNm2));
                $last.find("td").eq(5).text(getValue(map.elementNm2));
                $last.find("td").eq(6).text(getValue(map.eleValue2));
                $last.find("td").eq(7).text(getValue(map.unit2));
            }
        }

        function getEtcListItemHtml() {
            return `<tr>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>`;
        }

        function initBtnEvent() {
            $("#btnSearch").on("click", function(e) {
                renderPayDetail();
            })

            $("#btnReport").on("click", function(e) {
                showPayReport();
            })

            $("#btnItemDetail").on("click", function(e) {
                if(!isPopup()) return;

                new window.top.document.LayerModal({
                    id: 'psnalPayItemDetailUserLayer',
                    url: '/PsnalPayUser.do?cmd=viewPsnalPayItemDetailUserLayer',
                    parameters: { payActionCd: $("#searchPayActionCd").val() },
                    width: 1000,
                    height: 650,
                    title : "항목세부내역",
                    trigger :[
                        {
                            name : 'psnalPayItemDetailUserLayerTrigger',
                            callback : function(returnValue){
                            }
                        }
                    ]
                }).show();
            })

            $("#btnFormula").on("click", function(e) {
                if(!isPopup()) return;

                new window.top.document.LayerModal({
                    id: 'psnalPayFormulaUserLayer',
                    url: '/PsnalPayUser.do?cmd=viewPsnalPayFormulaUserLayer',
                    parameters: { payActionCd: $("#searchPayActionCd").val() },
                    width: 1000,
                    height: 650,
                    title : "항목세부내역",
                    trigger :[
                        {
                            name : 'psnalPayFormulaUserLayerTrigger',
                            callback : function(returnValue){
                            }
                        }
                    ]
                }).show();
            })
        }

        /**
         * 급여명세서 팝업
         */
        function showPayReport() {
            if (!isValidPayAction()) return;

            new window.top.document.LayerModal({
                id : 'payPartiLayer'
                , url : '/PerPayPartiUserSta.do?cmd=viewPerPayPartiLayer&authPg=R'
                , parameters : {
                    payActionCd : $("#searchPayActionCd").val()
                }
                , width : 680
                , height : 700
                , title : '<tit:txt mid='perPayPartiPopSta' mdef='급여명세서'/>'
            }).show();
        }

        function isValidPayAction() {
            if ($("#searchPayActionCd").val() != null && $("#searchPayActionCd").val() !== "")
                return true;
            else {
                alert("급여일자를 선택해주세요.");
                $("#searchPayActionCd").focus();
                return false;
            }
        }

        function closeDetailLayer() {
            const modal = window.top.document.LayerModalUtility.getModal('psnalPayDetailUserLayer');
            modal.fire('psnalPayDetailUserLayerTrigger', {}).hide();
        }

		async function getPayActionList() {
			const response = await fetch("${ctx}/PsnalPayUser.do?cmd=getPsnalPayDetailUserPayActionList", {
				method: "POST",
				headers: {
					'Content-Type': 'application/x-www-form-urlencoded',
				},
				body: ""
			});

			const json = await response.json();
			if (json.msg != null && json.msg !== "") {
				alert(json.msg);
				return null;
			}
			return json.list;
		}

		async function getPayDetail() {
			const response = await fetch("${ctx}/PsnalPayUser.do?cmd=getPsnalPayDetailUser", {
				method: "POST",
				headers: {
					'Content-Type': 'application/x-www-form-urlencoded',
				},
				body: "searchPayActionCd=" + $("#searchPayActionCd").val()
			});

			const json = await response.json();
			if (json.msg != null && json.msg !== "") {
				alert(json.msg);
				return null;
			}
			return json.map;
		}
	</script>
</head>
<body class="hidden">
	<div class="wrapper modal_layer ux_wrapper">
        <div class="modal_body">
            
            <div class="card mb-12 d-flex align-center justify-between">
                <div class="d-flex">
					<div class="select_wrap icon date">
                        <select class="custom_select thin w-187" name="searchPayActionCd" id="searchPayActionCd">
                        </select>
                    </div>
                    <button class="btn sm outline ml-20" id="btnSearch">조회</button>
                </div>
                <button class="btn ml-16" id="btnReport">명세서출력</button>
            </div>

            <div class="card rounded-12 pa-24 mb-16" id="summaryArea">
                <div class="d-flex justify-between mb-16">
                    <p class="txt_title_sm sb"></p>
                    <div class="d-flex gap-8">
                        <button class="btn" id="btnItemDetail">항목세부내역</button>
                        <button class="btn" id="btnFormula">급여계산방법</button>
                    </div>
                </div>
            
                <div class="d-grid grid-cols-3 gap-40">
                    <div class="d-grid grid-cols-2 align-center">
                        <div>
                            <!-- 차트 -->
                             <div id="chartArea"></div>
                        </div>
                        <div id="paymentMonArea">
                            <p class="txt_body_sm txt_secondary">실수령액</p>
                            <p class="txt_title_sm sb">-</p>
                        </div>
                    </div>

                    <div>
                        <div class="card bg-gray pa-12 d-flex align-center justify-between mb-12" id="totEarningMonArea">
                            <div class="txt_body_m txt_secondary">지급총액</div>
                            <div class="txt_title_sm sb">-</div>
                        </div>
                        <div class="px-12 d-flex flex-col gap-16">
                            <div class="d-flex w-full justify-between" id="notaxTotMonArea">
                                <span class="txt_body_sm txt_secondary">비과세총액</span>
                                <span class="txt_body_sm sb">-</span>
                            </div>
                            <div class="d-flex w-full justify-between" id="taxibleEarnMonArea">
                                <span class="txt_body_sm txt_secondary">과세대상금액</span>
                                <span class="txt_body_sm sb">-</span>
                            </div>
                            <div class='line'></div>
                            <div class="d-flex w-full justify-between" id="familyCntArea">
                                <span class="txt_body_sm txt_secondary">부양가족수</span>
                                <span class="txt_body_sm sb">-</span>
                            </div>
                            <div class="d-flex w-full justify-between" id="addChildCntArea">
                                <span class="txt_body_sm txt_secondary">다자녀수</span>
                                <span class="txt_body_sm sb">-</span>
                            </div>
                        </div>
                    </div>

                    <div>
                        <div class="card bg-gray pa-12 d-flex align-center justify-between mb-12" id="totDedMonArea">
                            <div class="txt_body_m txt_secondary">공체총액</div>
                            <div class="txt_title_sm sb">-</div>
                        </div>
                        <div class="px-12 d-flex flex-col gap-16">
                            <div class="d-flex w-full justify-between" id="itaxMonArea">
                                <span class="txt_body_sm txt_secondary">소득세</span>
                                <span class="txt_body_sm sb">-</span>
                            </div>
                            <div class="d-flex w-full justify-between" id="rtaxMonArea">
                                <span class="txt_body_sm txt_secondary">주민세</span>
                                <span class="txt_body_sm sb">-</span>
                            </div>
                            <div class="d-flex w-full justify-between" id="etcDedMonArea">
                                <span class="txt_body_sm txt_secondary">기타공제</span>
                                <span class="txt_body_sm sb">-</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="mb-40">
                <p class="txt_title_xs sb txt_left mb-12">상세내역</p>
                <div class='d-grid grid-cols-3 gap-12'>
                    <div id="payArea">
                        <div class="card bg-gray pa-12 d-flex align-center justify-between mb-12">
                            <div class="txt_body_m txt_secondary sb d-flex gap-8">
                                <i class="mdi-ico filled color_primary txt_18">savings</i>
                                지급총액
                            </div>
                            <div class="txt_title_sm sb">1,000,000</div>
                        </div>
                        <div class="px-12 d-flex flex-col gap-12" id="payItemWrap">
                        </div>
                    </div>

                    <div id="deductArea">
                        <div class="card bg-gray pa-12 d-flex align-center justify-between mb-12">
                            <div class="txt_body_m txt_secondary sb d-flex gap-8">
                                <i class="mdi-ico filled color_primary txt_18">sell</i>
                                공제총액
                            </div>
                            <div class="txt_title_sm sb">1,000,000</div>
                        </div>
                        <div class="px-12 d-flex flex-col gap-12" id="deductItemWrap">
                        </div>
                    </div>

                    <div id="basicArea">
                        <div class="card bg-gray pa-12 d-flex align-center justify-between mb-12">
                            <div class="txt_body_m txt_secondary sb d-flex gap-8">
                                <i class="mdi-ico filled color_primary txt_18">list_alt</i>
                                급여기초
                            </div>
                            <div class="txt_title_sm sb">-</div>
                        </div>
                        <div class="px-12 d-flex flex-col gap-12" id="basicItemWrap">
                            <!-- 조회 데이터 없을 때 -->
                            <div class="h-84 d-flex flex-col justify-between align-center my-12">
                                <i class="icon no_list"></i>
                                 <p class="txt_body_sm txt_tertiary">조회된 데이터가 없습니다.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div>
                <p class="txt_title_xs sb txt_left mb-12">근태/기타 내역</p>
                <table class="custom_table" id="etcListArea">
                    <thead>
                      <tr>
                        <th>업무구분</th>
                        <th>항목명</th>
                        <th>항목값</th>
                        <th>단위</th>
                        <th>업무구분</th>
                        <th>항목명</th>
                        <th>항목값</th>
                        <th>단위</th>
                      </tr>
                    </thead>
                    <tbody>
                    </tbody>
                  </table>
            </div>
        </div>
		<div class="modal_footer ">
			<btn:a href="javascript:closeCommonLayer('psnalPayDetailUserLayer');" css="btn outline_gray" mid='110881' mdef="닫기"/>
		</div>
    </div>
</body>
</html>
