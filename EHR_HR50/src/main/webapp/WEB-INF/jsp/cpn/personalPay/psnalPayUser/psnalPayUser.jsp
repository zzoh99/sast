<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="hidden">
<head>
	<title>개인별급여내역</title>
	<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
    <script src="/assets/plugins/moment.js-2.30.1/moment-with-locales.js"></script>
	<script type="text/javascript">
		$(function() {
            init();
		});

        function getIconClass(payNm) {
            const iconClassList = {
                "급여": "bag_won",
                "인센티브": "like",
                "소급": "baloon",
                "퇴직연월차": "gift",
            };

            return iconClassList[payNm];
        }

        function init() {
            initMainEvent();
            initTab1();
            initTab2();
        }

        function initMainEvent() {
            $(".ux_wrapper input[name=radioPeriod]").first().prop("checked", true);

            // 탭 이벤트
            $(".ux_wrapper .tab").click(function () {
                // 모든 탭에서 active 클래스 제거
                $(".ux_wrapper .tab").removeClass("active");

                // 클릭한 탭에 active 클래스 추가
                $(this).addClass("active");

                // 모든 탭 콘텐츠 숨기기
                $(".ux_wrapper .tab_content").removeClass("active");

                // 클릭한 탭에 해당하는 콘텐츠 표시
                var tabId = $(this).data("tab");
                $("#" + tabId).addClass("active");

                if (isTabActive("tab1")) {
                    renderBaseInfo();
                } else if (isTabActive("tab2")) {
                    renderDetailList();
                }
            })

            $(".date_radio #searchSYm").datepicker2({ ymonly: true });
            $(".date_radio #searchEYm").datepicker2({ ymonly: true });

            $('input[name=radioPeriod]').change(function() {
                if ($(this).attr("id") === "radio6" && $(this).is(':checked')) {
                    $('.date_radio .date_picker_wrap').show();
                } else {
                    $('.date_radio .date_picker_wrap').hide();
                }
            });

            $(".ux_wrapper #searchBtn").on("click", function(e) {
                if (isTabActive("tab1")) {
                    renderBaseInfo();
                } else if (isTabActive("tab2")) {
                    renderDetailList();
                }
            });
        }

        async function initTab1() {
            await renderBaseInfo();
            initTab1Event();
        }

        async function renderBaseInfo(isVisible = isVisibleSalaryInfo()) {
            const salaryInfo = await getTab1SalaryInfo(isVisible);
            if (salaryInfo == null) return;

            setBaseMain(salaryInfo.total, isVisible);
            renderBaseCards(salaryInfo.salaries, isVisible);
        }

        /**
         * 기본 탭 데이터 초기화
         */
        function clearSalaryInfo() {
            const $salaryMain = $getTab("tab1").find(".salary_main");
            $salaryMain.find(".txt_body_m").text(getPeriodText() + " 총 지급액");
            $salaryMain.find(".txt_title_sm").empty();

            const $salaryCardWrap = $getTab("tab1").find(".salary_card_wrap");
            $salaryCardWrap.empty();
        }

        /**
         *
         * @param totalInfo
         * @param isVisible
         */
        function setBaseMain(totalInfo, isVisible) {
            const $salaryMain = $getTab("tab1").find(".salary_main");
            $salaryMain.find(".txt_body_m").text(getPeriodText() + " 총 지급액");

            $salaryMain.find(".txt_title_sm").empty();
            if (isVisible) {
                const totalAmount = (totalInfo == null || totalInfo.totPaymentMon == null || totalInfo.totPaymentMon === "") ? 0 : totalInfo.totPaymentMon;
                $salaryMain.find(".txt_title_sm").append(`<span class="sb">${'${totalAmount}'}</span>원`);
            } else {
                $salaryMain.find(".txt_title_sm").append(`<span class="sb">급여 총 금액 비공개</span>`);
            }
        }

        /**
         * 선택한 기간 옵션을 바탕으로 기본 탭 메인에 표시할 텍스트를 조회한다.
         */
        function getPeriodText() {
            const format = "YYYY년 M월";
            const periodValue = $(".ux_wrapper input[name=radioPeriod]:checked").val();
            const today = moment();
            if (periodValue === "oneMonth") {
                return today.format(format);
            } else if (periodValue === "period") {
                if ($("#searchEYm").val() === "") {
                    return moment($("#searchSYm").val().replace(/-/gi, "")).format(format) + "부터";
                } else {
                    return moment($("#searchSYm").val().replace(/-/gi, "")).format(format) + "~" + moment($("#searchEYm").val().replace(/-/gi, "")).format(format);
                }
            } else {
                let fromDate;
                if (periodValue === "threeMonth") {
                    fromDate = moment().subtract(2, "months");
                } else if (periodValue === "sixMonth") {
                    fromDate = moment().subtract(5, "months");
                } else if (periodValue === "nineMonth") {
                    fromDate = moment().subtract(8, "months");
                } else if (periodValue === "oneYear") {
                    fromDate = moment().subtract(11, "months");
                } else {
                    return "-";
                }
                return fromDate.format(format) + "~" + today.format(format);
            }
        }

        /**
         * 기본 탭의 급여 카드를 그려준다.
         * @param salaries 급여리스트 정보
         * @param isVisible 공개여부
         */
        function renderBaseCards(salaries, isVisible) {
            const $salaryCardWrap = $getTab("tab1").find(".salary_card_wrap");
            $salaryCardWrap.empty();

            if (!isVisible) {
                $salaryCardWrap.addClass("dimmed");
            } else {
                $salaryCardWrap.removeClass("dimmed");
            }

            for (let salary of salaries) {
                $salaryCardWrap.append(getSalaryCardHtml());
                const $lastCard = $salaryCardWrap.children().last();
                $lastCard.data("payActionCd", salary.payActionCd);
                $lastCard.find(".icon").addClass(getIconClass(salary.payNm));
                $lastCard.find(".txt_tertiary").text(salary.payActionNm);
                if (isVisible) {
                    $lastCard.find(".sb").text(salary.paymentMon);
                    $lastCard.addClass("pointer");
                    addSalaryCardEvent($lastCard);
                } else {
                    $lastCard.find(".sb").html(`<i class="mdi-ico">lock</i>비공개`);
                    $lastCard.removeClass("pointer");
                }
            }
        }

        /**
         * 기본 탭의 급여카드 HTML 텍스트 조회
         */
        function getSalaryCardHtml() {
            return `<div class="card">
                        <div class="d-flex align-center">
                            <i class="icon size-24"></i>
                        </div>
                        <div class="flex-1">
                            <p class="txt_body_sm txt_tertiary mb-2"></p>
                            <p class="txt_title_sm sb"></p>
                        </div>
                    </div>`;
        }

        /**
         * 기본 탭의 급여카드의 이벤트 설정
         * @param $card
         */
        function addSalaryCardEvent($card) {
            $card.on("click", function() {
                const payActionCd = $(this).data("payActionCd");
                showSalaryDetailLayer(payActionCd);
            })
        }

        function showSalaryDetailLayer(payActionCd) {
            if(!isPopup()) return;

            new window.top.document.LayerModal({
                id: 'psnalPayDetailUserLayer',
                url: '/PsnalPayUser.do?cmd=viewPsnalPayDetailUserLayer',
                parameters: { payActionCd: payActionCd },
                width: 1000,
                height: 900,
                title : "급여상세",
                trigger :[
                    {
                        name : 'psnalPayDetailUserLayerTrigger',
                        callback : function(returnValue){
                        }
                    }
                ]
            }).show();
        }

        function getFromToYmObj() {
            const format = "YYYYMM";
            const searchType = $(".ux_wrapper input[name=radioPeriod]:checked").val();
            const today = moment();
            let fromYm, toYm = moment().format(format);
            if (searchType === "oneMonth") {
                fromYm = today.format(format);
            } else if (searchType === "threeMonth") {
                fromYm = moment().subtract(2, "months").format(format);
            } else if (searchType === "sixMonth") {
                fromYm = moment().subtract(5, "months").format(format);
            } else if (searchType === "nineMonth") {
                fromYm = moment().subtract(8, "months").format(format);
            } else if (searchType === "oneYear") {
                fromYm = moment().subtract(11, "months").format(format);
            } else if (searchType === "period") {
                fromYm = moment($("#searchSYm").val().replace(/-/gi, "")).format(format);
                toYm = moment($("#searchEYm").val().replace(/-/gi, "")).format(format);
            } else {
                return null;
            }

            return { "fromYm": fromYm, "toYm": toYm };
        }

        /**
         * 기본 탭의 이벤트 설정
         */
        function initTab1Event() {
            $getTab("tab1").find(".custom_switch label").on("click", function() {
                // toggle 버튼이 활성화되기까지의 시간이 필요하여 100의 timeout을 부여함.
                setTimeout(renderBaseInfo, 50);
            })
        }

        /**
         * 급여내역 공개여부
         * @returns {boolean} 공개여부
         */
        function isVisibleSalaryInfo() {
            return $getTab("tab1").find("#toggle").is(":checked");
        }


        /**
         * Tab2 initialize
         * @returns {Promise<void>}
         */
        async function initTab2() {
            await renderDetailList();
        }

        /**
         * 상세 탭의 기간별 급여리스트를 그려준다.
         * @returns {Promise<void>}
         */
        async function renderDetailList() {
            const detailList = await getTab2DetailList();
            if (detailList == null) return;

            clearTab2Tbody();

            // 행별 데이터
            renderDetailRow(detailList.list);

            // summary
            renderDetailSummaryRow(detailList.summary);
        }

        /**
         * 상세 탭의 리스트 초기화
         */
        function clearTab2Tbody() {
            $getTab("tab2").find("table tbody").empty();
        }

        /**
         * 상세 탭의 행별 데이터를 그려준다.
         * @param list 행별 리스트
         */
        function renderDetailRow(list) {
            const $detailTbody = $getTab("tab2").find("table tbody");
            for (let salary of list) {
                $detailTbody.append(getDetailRowHtml());
                const $last = $detailTbody.children().last();
                setDetailRowValue($last, salary);
                setDetailRowEvent($last);
            }
        }

        /**
         * 상세 탭의 요약 데이터를 그려준다.
         * @param summary 요약 정보
         */
        function renderDetailSummaryRow(summary) {
            const $detailTbody = $getTab("tab2").find("table tbody");
            $detailTbody.append(getDetailRowHtml(true));
            if (summary == null) return;

            const $total = $detailTbody.find(".total");
            setDetailRowValue($total, summary, true);
        }

        /**
         * 상세 탭의 행별 HTML 값을 조회
         * @param isSummary 요약 행인지 여부
         */
        function getDetailRowHtml(isSummary = false) {
            const trClass = isSummary ? `class="total"` : ``;
            const td1Text = isSummary ? `` : `<button class="btn sm outline gray icon">
                                                <i class="mdi-ico">list_alt</i>
                                            </button>`;
            return `<tr ${'${trClass}'}>
                        <td></td>
                        <td>
                            ${'${td1Text}'}
                        </td>
                        <td></td>
                        <td></td>
                        <td></td>
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

        /**
         * 상세 탭의 행별 값을 세팅
         *
         * @param $el 행 셀렉터
         * @param salary 금액 데이터
         * @param isSummary 요약행인지 여부
         */
        function setDetailRowValue($el, salary, isSummary = false) {
            const getValue = (value) => {
                return (value == null || value === "") ? "-" : value;
            }
            if (!isSummary) {
                $el.data("payActionCd", salary.payActionCd);
                $el.find("td").eq(0).text(salary.seq);
                $el.find("td").eq(2).text(getValue(salary.payActionNm));
            }
            $el.find("td").eq(3).text(getValue(salary.totEarningMon));
            $el.find("td").eq(4).text(getValue(salary.totDedMon));
            $el.find("td").eq(5).text(getValue(salary.paymentMon));
            $el.find("td").eq(6).text(getValue(salary.itaxMon));
            $el.find("td").eq(7).text(getValue(salary.rtaxMon));
            $el.find("td").eq(8).text(getValue(salary.npEeMon));
            $el.find("td").eq(9).text(getValue(salary.hiEeMon));
            $el.find("td").eq(10).text(getValue(salary.eiEeMon));
            $el.find("td").eq(11).text(getValue(salary.taxibleEarnMon));
            $el.find("td").eq(12).text(getValue(salary.notaxTotMon));
        }

        function setDetailRowEvent($el) {
            $el.find("td").eq(1).find("button")
                .on("click", function() {
                    showSalaryDetailLayer($(this).parent().parent().data("payActionCd"));
                })
        }

        /**
         * 탭 ID 로 탭 셀렉터 조회
         */
        function $getTab(tabId) {
            return $(".ux_wrapper .tab_content#" + tabId);
        }

        /**
         * 현재 활성화 탭의 셀렉터 조회
         */
        function $getActiveTab() {
            return $(".ux_wrapper .tab_content.active");
        }

        /**
         * 현재 탭이 활성화되어 있는지 여부 조회
         */
        function isTabActive(tabId) {
            return $(".ux_wrapper .tab_content.active").attr("id") === tabId;
        }

        async function getTab1SalaryInfo(isVisible) {
            const response = await fetch("${ctx}/PsnalPayUser.do?cmd=getPsnalPayUserBaseInfo", {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: $(".ux_wrapper #searchForm").serialize() + "&visibleYn=" + (isVisible ? "Y" : "N")
            });

            const json = await response.json();
            if (json.msg != null && json.msg !== "") {
                alert(json.msg);
                return null;
            }
            return json.map;
        }

        async function getTab2DetailList() {
            const response = await fetch("${ctx}/PsnalPayUser.do?cmd=getPsnalPayUserDetailList", {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: $(".ux_wrapper #searchForm").serialize()
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
<body class="bodywrap">
	<div class="ux_wrapper">
        <div class="page_title mb-12">급여내역</div>
        <div class="contents">
            <div>
                <div class="tab_container w-164 ma-auto mb-8">
                    <ul>
                        <li>
                            <button class="tab active" data-tab="tab1">
                                기본
                            </button>
                        </li>
                        <li>
                            <button class="tab" data-tab="tab2">
                                상세
                            </button>
                        </li>
                    </ul>
                </div>

                <div class="card mb-8 d-flex align-center gap-16">
                    <form id="searchForm">
                        <div class="custom_radio">
                            <input type="radio" name="radioPeriod" id="radio1" class="form-radio" value="oneMonth" />
                            <label for="radio1">최근 한 달</label>
                        </div>
                        <div class="custom_radio">
                            <input type="radio" name="radioPeriod" id="radio2" class="form-radio" value="threeMonth" />
                            <label for="radio2">최근 3개월</label>
                        </div>
                        <div class="custom_radio">
                            <input type="radio" name="radioPeriod" id="radio3" class="form-radio" value="sixMonth" />
                            <label for="radio3">최근 6개월</label>
                        </div>
                        <div class="custom_radio">
                            <input type="radio" name="radioPeriod" id="radio4" class="form-radio" value="nineMonth" />
                            <label for="radio4">최근 9개월</label>
                        </div>
                        <div class="custom_radio">
                            <input type="radio" name="radioPeriod" id="radio5" class="form-radio" value="oneYear" />
                            <label for="radio5">최근 1년</label>
                        </div>
                        <div class="custom_radio date_radio">
                            <input type="radio" name="radioPeriod" id="radio6" class="form-radio" value="period" />
                            <label for="radio6">기간 선택</label>
                            <div class="date_picker_wrap" style="display: none;">
                                <!-- 아래 img 태그는 지우시고 기존 개발에서 사용하시는대로 input.bbit-dp-input 에 .thin 클래스 추가하시면 됩니다. -->
                                <input type="text" id="searchSYm" name="searchSYm" class="date2 bbit-dp-input thin" maxlength="7" autocomplete="off" placeholder="시작일자">
                                <input type="text" id="searchEYm" name="searchEYm" class="date2 bbit-dp-input thin" maxlength="7" autocomplete="off" placeholder="종료일자">
                            </div>
                        </div>
                    </form>
                    <button class="btn sm outline ml-16" id="searchBtn">조회</button>
                </div>

                <div class="tab_content active" id="tab1">

                    <div class="card pa-20 mb-20 rounded-16 salary_main">
                        <p class="txt_body_m txt_secondary mb-4">총 지급액</p>
                        <div class="d-flex align-center gap-16 mb-8">
                            <p class="txt_title_sm">
                                <span class="sb">-</span>원
                                <!-- 토글 off 시 금액 대신 아래 텍스트 -->
                                <!-- <span class="sb">급여 총 금액 비공개</span> -->
                            </p>
                            <div class="custom_switch">
                                <input type="checkbox" id="toggle" hidden />
                                <label for="toggle">
                                  <span></span>
                                </label>
                            </div>
                        </div>
                    </div>

                    <div class="salary_card_wrap">
                    </div>
                </div>

                <div class="tab_content" id="tab2">

                    <div>
                    	<div class="scroll_table_wrap salary_list">
	                        <table class="custom_table">
	                            <thead>
	                              <tr>
	                                <th>No</th>
	                                <th>세부내역</th>
	                                <th>금액일자</th>
	                                <th>금액합계</th>
	                                <th>공제총액</th>
	                                <th>실지급액</th>
	                                <th>소득세</th>
	                                <th>주민세</th>
	                                <th>국민연금</th>
	                                <th>건강보험</th>
	                                <th>고용보험</th>
	                                <th>과세총액</th>
	                                <th>비과세총액</th>
	                              </tr>
	                            </thead>
	                            <tbody>
	                            </tbody>
	                            <!-- <tbody>
                                      <tr>
                                        <td>1</td>
                                        <td>
                                            <button class="btn sm outline gray icon">
                                                <i class="mdi-ico">list_alt</i>
                                            </button>
                                        </td>
                                        <td>2025.01.25</td>
                                        <td>7,456,123</td>
                                        <td>1,434,567</td>
                                        <td>6,045,6789</td>
                                        <td>612,456</td>
                                        <td>56,123</td>
                                        <td>231,654</td>
                                        <td>213,654</td>
                                        <td>52,987</td>
                                        <td>1,321,654</td>
                                        <td>52,478</td>
                                      </tr>
                                      <tr>
                                        <td>1</td>
                                        <td>
                                            <button class="btn sm outline gray icon">
                                                <i class="mdi-ico">list_alt</i>
                                            </button>
                                        </td>
                                        <td>2025.01.25</td>
                                        <td>7,456,123</td>
                                        <td>1,434,567</td>
                                        <td>6,045,6789</td>
                                        <td>612,456</td>
                                        <td>56,123</td>
                                        <td>231,654</td>
                                        <td>213,654</td>
                                        <td>52,987</td>
                                        <td>1,321,654</td>
                                        <td>52,478</td>
                                      </tr>
                                      <tr>
                                        <td>1</td>
                                        <td>
                                            <button class="btn sm outline gray icon">
                                                <i class="mdi-ico">list_alt</i>
                                            </button>
                                        </td>
                                        <td>2025.01.25</td>
                                        <td>7,456,123</td>
                                        <td>1,434,567</td>
                                        <td>6,045,6789</td>
                                        <td>612,456</td>
                                        <td>56,123</td>
                                        <td>231,654</td>
                                        <td>213,654</td>
                                        <td>52,987</td>
                                        <td>1,321,654</td>
                                        <td>52,478</td>
                                      </tr>
                                    </tbody>
                                    <tfoot>
                                        <tr class="total">
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td>77,456,123</td>
                                            <td>7,434,567</td>
                                            <td>66,045,6789</td>
                                            <td>6,612,456</td>
                                            <td>5,56,123</td>
                                            <td>4,231,654</td>
                                            <td>2,213,654</td>
                                            <td>552,987</td>
                                            <td>11,321,654</td>
                                            <td>532,478</td>
                                          </tr>
                                    </tfoot>   -->
                                    <!-- <tbody>
                                        <tr>
                                            <td colspan="100%">
                                                <div class="h-84 d-flex flex-col justify-between align-center my-12">
                                                    <i class="icon no_list"></i>
                                                     <p class="txt_body_sm txt_tertiary">조회된 데이터가 없습니다.</p>
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody> -->
	                          </table>
                          </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</body>
</html>
