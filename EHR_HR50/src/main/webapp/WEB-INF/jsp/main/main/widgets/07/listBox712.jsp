<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp" %>
<script type="text/javascript">
    /*
     * 연봉계약서
     */

    //위젯 사이즈별 로드
    function init_listBox712(size) {
        widget712.size = size;
        if (size == "normal") {
            widget712.makeMini();
            //widget712.setDataMini();
            widget712.initEvent();
        } else if (size == "wide") {
            widget712.makeWide();
            //widget712.setDataWide();
            widget712.initEvent();
        }
    }

    let widget712 = {
        size: null,
        elemId: "widget712", // 위젯 엘리면트 id
        $widget: null,
        w712Data: null, // 예상퇴직금 데이터

        // 작은 위젯 마크업 생성
        makeMini: function () {
            let html =
                '<div class="widget_header">' +
                '	<div class="widget_title">연봉계약서</div>' +
                '</div>' +
                '<div class="widget_body widget_h">' +
                '	<div class="widget_cnt">' +
                '		<div class="flex-col-between">' +
                '			<div class="icon_box sm self-center"><img src="/common/images/widget/eis_icon_salary_contract_s_2x.png" alt="연봉계약서에 서명해주세요"></div>' +
                '			<p>연봉계약서에 <br />서명해주세요</p>' +
                '			<button type="button" id="712Btn" class="btn outline_gray m-auto">연봉 계약서 바로가기</button>' +
                '		</div>' +
                '	</div>' +
                '</div>';

            document.getElementById(this.elemId).innerHTML = html;
        },

        // 와이드 위젯 마크업 생성
        makeWide: function () {
            let html =
                '<div class="widget_header">' +
                '	<div class="widget_title">연봉계약서</div>' +
                '</div>' +
                '<div class="widget_body widget_h">' +
                '	<div class="widget_cnt">' +
                '		<div class="icon_box"><img src="/common/images/widget/eis_icon_salary_contract_2x.png" alt="연봉계약서에 서명해주세요"></div>' +
                '		<div class="flex-col-between">' +
                '			<p>연봉계약서에 <br />서명해주세요</p>' +
                '			<button type="button" id="712Btn" class="btn ml-0 outline_gray">연봉 계약서 바로가기</button>' +
                '		</div>' +
                '	</div>' +
                '</div>';

            document.getElementById(this.elemId).innerHTML = html;
        },
        initEvent: function () {
            $('#712Btn').off().click(function () {
                gotoSubPage('PerContractSrch.do?cmd=viewPerContractSrch')
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

<div class="widget" id="widget712"></div>