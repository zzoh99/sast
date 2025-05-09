<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp" %>
<script type="text/javascript">
    /*
     * 급여 알림
     */


    //위젯 사이즈별 로드
    function init_listBox710(size) {
        widget710.size = size;
        if (size == "normal") {
            widget710.makeMini();
            //widget710.setDataMini();
            widget710.initMiniEvent();
            widget710.initEvent();
            widget713.setData();
        } else if (size == ("wide")) {
            widget710.makeWide();
            //widget710.setDataWide();
            widget710.initEvent();
            widget713.setData();
        }
    }

    let widget710 = {
        size: null,
        elemId: 'widget710',  // 위젯 엘리면트 id
        $widget: null,
        w710Data: null,  // 예상퇴직금 데이터

        // 작은 위젯 마크업 생성
        makeMini: function () {
            let html =
                '<div class="widget_header">' +
                '	<div class="widget_title">알림</div>' +
                '</div>' +
                '<div class="widget_body">' +
                '	<div class="widget_cnt">' +
                '		<div class="swiper widget_swiper">' +
                '			<div class="swiper-wrapper">' +
                '				<div class="swiper-slide">' +
                '					<div class="swiper-title"><h2>연봉계약서</h2></div>' +
                '					<div class="flex-row-between">' +
                '						<div class="icon_box sm"><img src="/common/images/widget/eis_icon_salary_contract_s_2x.png" alt="연봉계약서에 서명해주세요"></div>' +
                '						<p>연봉계약서에 <br />서명해주세요</p>' +
                '					</div>' +
                '					<button type="button" id="salaryContractBtn" class="btn outline_gray m-auto">연봉 계약서 바로가기</button>' +
                '				</div>' +
                '				<div class="swiper-slide">' +
                '					<div class="swiper-title"><h2>급여확인</h2></div>' +
                '					<div class="flex-row-between">' +
                '						<div class="icon_box sm"><img src="/common/images/widget/eis_icon_salary_s_2x.png" alt="급여 지급완료"></div>' +
                '						<p><span id="payMonth"></span>월 급여 <br />지급완료</p>' +
                '					</div>' +
                '					<button type="button" id="salaryBtn" class="btn outline_gray m-auto">급여 지급내역 확인</button>' +
                '				</div>' +
                '				<div class="swiper-slide">' +
                '					<div class="swiper-title"><h2>연말정산</h2></div>' +
                '					<div class="flex-row-between">' +
                '						<div class="icon_box sm"><img src="/common/images/widget/eis_icon_year_end_settlement_s_2x.png" alt="연말정산 일정 확인하기"></div>' +
                '						<p>연말정산 일정 <br />확인하기!</p>' +
                '					</div>' +
                '					<button type="button" id="yearEndBtn" class="btn outline_gray m-auto">연말정산 바로가기</button>' +
                '				</div>' +
                '			</div>' +
                '			<div class="swiper-button-next"><i class="mdi-ico">keyboard_arrow_right</i></div>' +
                '			<div class="swiper-button-prev"><i class="mdi-ico">keyboard_arrow_left</i></div>' +
                '		</div>' +
                '	</div>' +
                '</div>';

            document.getElementById(this.elemId).innerHTML = html;
        },

        initMiniEvent: function () {
            const swiper = new Swiper('.widget_swiper', {
                slidesPerView: 1,
                spaceBetween: 30,
                navigation: {
                    nextEl: '.swiper-button-next',
                    prevEl: '.swiper-button-prev',
                },
            });
        },

        // 와이드 위젯 마크업 생성
        makeWide: function () {
            let html =
                '<div class="widget_header">' +
                '	<div class="widget_title">알림</div>' +
                '</div>' +
                '<div class="widget_body">' +
                '	<div class="widget_cnt">' +
                '		<div class="widget_tab">' +
                '			<ul class="tab_wrap">' +
                '				<li class="tab_menu active"><a href="#;">연봉계약서</a></li>' +
                '				<li class="tab_menu"><a href="#;">급여확인</a></li>' +
                '				<li class="tab_menu"><a href="#;">연말정산</a></li>' +
                '			</ul>' +
                '			<div class="tab_contents">' +
                '				<div class="tab_item on">' +
                '					<div class="icon_box"><img src="/common/images/widget/eis_icon_salary_contract_2x.png" alt="연봉계약서에 서명해주세요"></div>' +
                '					<div class="flex-col-between">' +
                '						<p>연봉계약서에 <br />서명해주세요</p>' +
                '						<button type="button" id="salaryContractBtn" class="btn outline_gray">연봉 계약서 바로가기</button>' +
                '					</div>' +
                '				</div>' +
                '				<div class="tab_item">' +
                '					<div class="icon_box"><img src="/common/images/widget/eis_icon_salary_2x.png" alt="급여 지급완료"></div>' +
                '					<div class="flex-col-between">' +
                '						<p><span id="payMonth"></span>월 급여 <br />지급완료</p>' +
                '						<button type="button" id="salaryBtn"  class="btn outline_gray">급여 지급내역 확인</button>' +
                '					</div>' +
                '				</div>' +
                '				<div class="tab_item">' +
                '					<div class="icon_box"><img src="/common/images/widget/eis_icon_year_end_settlement_2x.png" alt="연말정산 일정 확인하기"></div>' +
                '					<div class="flex-col-between">' +
                '						<p>연말정산 일정 <br />확인하기!</p>' +
                '						<button type="button" id="yearEndBtn" class="btn outline_gray">연말정산 바로가기</button>' +
                '					</div>' +
                '				</div>' +
                '			</div>' +
                '		</div>' +
                '	</div>' +
                '</div>';

            document.getElementById(this.elemId).innerHTML = html;
        },

        initEvent: function () {
            $('#salaryContractBtn').off().click(function () {
                gotoSubPage('PerContractSrch.do?cmd=viewPerContractSrch')
            });
            $('#salaryBtn').off().click(function () {
                gotoSubPage('PerPayPartiUserSta.do?cmd=viewPerPayPartiUserSta')
            });
            $('#yearEndBtn').off().click(function () {
                gotoSubPage('yjungsan/y_2024/jsp_jungsan/yeaCalcCre/yeaCalcCre.jsp')
            });

        },

    };

    function gotoSubPage(subPagePath) {
        if (typeof goSubPage == 'undefined') {
            // 서브페이지에서 서브페이지 호출
            if (typeof window.top.goOtherSubPage == 'function') {
                window.top.goOtherSubPage("", "", "", "", subPagePath);
            }
        } else {
            goSubPage("", "", "", "", subPagePath);
        }
    }
</script>
<div class="widget" id="widget710"></div>

<script>
    $(function () {
        //탭메뉴
        $(".tab_wrap .tab_menu").on('click', function () {
            var tabMenuidx = $(".tab_wrap .tab_menu").index(this);

            $(this).addClass('active');
            $('.tab_wrap .tab_menu').not(this).removeClass('active');

            $('.tab_contents .tab_item').removeClass('on');
            $('.tab_contents .tab_item:eq(' + tabMenuidx + ')').addClass('on');
        });
    });
</script>