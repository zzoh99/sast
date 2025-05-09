<%@ page import="com.hr.common.util.DateUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp" %>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp"%>
<script type="text/javascript">
    /*
     * 급여확인
     */

    //위젯 사이즈별 로드
    function init_listBox713(size) {
        widget713.size = size;
        if (size == "normal") {
            widget713.makeMini();
            widget713.setData();
        } else if (size == "wide") {
            widget713.makeWide();
            widget713.setData();
        }
    }

    let widget713 = {
        size: null,
        elemId: "widget713", // 위젯 엘리면트 id
        $widget: null,
        w713Data: null, // 예상퇴직금 데이터

        // 작은 위젯 마크업 생성
        makeMini: function () {
            let html =
                '<div class="widget_header">' +
                '	<div class="widget_title">급여확인</div>' +
                '</div>' +
                '<div class="widget_body widget_h">' +
                '	<div class="widget_cnt">' +
                '		<div class="flex-col-between">' +
                '			<div class="icon_box sm self-center"><img src="/common/images/widget/eis_icon_salary_s_2x.png" alt="급여 지급완료"></div>' +
                '			<p><span id="payMonth"></span>월 급여 <br />지급완료</p>' +
                '			<button type="button" id="713Btn" class="btn outline_gray m-auto">급여 지급내역 확인</button>' +
                '		</div>' +
                '	</div>' +
                '</div>';

            document.getElementById(this.elemId).innerHTML = html;
            this.initEvent();
        },
        setData: function () {
            ajaxCall2("${ctx}/PayCalculator.do?cmd=getPayDayMgrList"
                , $("#srchForm").serialize()
                , true
                , null
                , function(data) {
                    if (data && data.DATA) {
                        const payList = data.DATA;

                        const today = new Date();
                        const todayString = today.toISOString().slice(0, 10).replace(/-/g, '');
                        const firstBeforeToday = payList.find(item => item.paymentYmd < todayString);
                        const payMonth = firstBeforeToday.payYm.substring(4,6);

                        $("#payMonth").text(payMonth);
                    }
                })
        },

        // 와이드 위젯 마크업 생성
        makeWide: function () {
            let html =
                '<div class="widget_header">' +
                '	<div class="widget_title">급여확인</div>' +
                '</div>' +
                '<div class="widget_body widget_h">' +
                '	<div class="widget_cnt">' +
                '		<div class="icon_box"><img src="/common/images/widget/eis_icon_salary_2x.png" alt="급여 지급완료"></div>' +
                '		<div class="flex-col-between">' +
                '			<p><span id="payMonth"></span>월 급여 <br />지급완료</p>' +
                '			<button type="button" id="713Btn" class="btn ml-0 outline_gray">급여 지급내역 확인</button>' +
                '		</div>' +
                '	</div>' +
                '</div>';

            document.getElementById(this.elemId).innerHTML = html;
            this.initEvent();
        },
        initEvent: function () {
            $('#713Btn').off().on("click", function () {
                gotoSubPage('PerPayPartiUserSta.do?cmd=viewPerPayPartiUserSta')
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
<form id="srchForm" name="srchForm" >
    <input id="searchMonthFrom" name="searchMonthFrom"  type="hidden" value="<%= DateUtil.addMonths(DateUtil.getCurrentTime("yyyy-MM-dd"),-5)%>"/>
    <input id="searchMonthTo" 	name="searchMonthTo" 	type="hidden" value="<%=DateUtil.addMonths(DateUtil.getCurrentTime("yyyy-MM-dd"),0)%>"/>
    <input id="searchPayCd" 	name="searchPayCd" 	type="hidden" value="A1"/>
</form>
<div class="widget" id="widget713"></div>