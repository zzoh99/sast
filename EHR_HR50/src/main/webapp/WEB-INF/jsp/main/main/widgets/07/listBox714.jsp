<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp" %>
<script type="text/javascript">
    /*
     * 연말정산
     */

    //위젯 사이즈별 로드
    function init_listBox714(size) {
        widget714.size = size;
        if (size == "normal") {
            widget714.makeMini();
            //widget714.setDataMini();
            widget714.initEvent();
        } else if (size == "wide") {
            widget714.makeWide();
            //widget714.setDataWide();
            widget714.initEvent();
        }
    }

    let widget714 = {
        size: null,
        elemId: "widget714", // 위젯 엘리면트 id
        $widget: null,
        w714Data: null, // 예상퇴직금 데이터

        // 작은 위젯 마크업 생성
        makeMini: function () {
            let html =
                '<div class="widget_header">' +
                '	<div class="widget_title">연말정산</div>' +
                '</div>' +
                '<div class="widget_body widget_h">' +
                '	<div class="widget_cnt">' +
                '		<div class="flex-col-between">' +
                '			<div class="icon_box sm self-center"><img src="/common/images/widget/eis_icon_year_end_settlement_s_2x.png" alt="연말정산 일정 확인하기"></div>' +
                '			<p>연말정산 일정 <br />확인하기!</p>' +
                '			<button type="button" id="714Btn" class="btn outline_gray m-auto">연말정산 바로가기</button>' +
                '		</div>' +
                '	</div>' +
                '</div>';

            document.getElementById(this.elemId).innerHTML = html;
        },

        // 와이드 위젯 마크업 생성
        makeWide: function () {
            let html =
                '<div class="widget_header">' +
                '	<div class="widget_title">연말정산</div>' +
                '</div>' +
                '<div class="widget_body widget_h">' +
                '	<div class="widget_cnt">' +
                '		<div class="icon_box"><img src="/common/images/widget/eis_icon_year_end_settlement_2x.png" alt="연말정산 일정 확인하기"></div>' +
                '		<div class="flex-col-between">' +
                '			<p>연말정산 일정 <br />확인하기!</p>' +
                '			<button type="button" id="714Btn" class="btn ml-0 outline_gray">연말정산 바로가기</button>' +
                '		</div>' +
                '	</div>' +
                '</div>';

            document.getElementById(this.elemId).innerHTML = html;
        },
        initEvent: function () {
            $('#714Btn').off().click(function () {
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
<div class="widget" id="widget714"></div>