<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
    /*
     * 근태 > 시간외 근무 사용현황
     */

    var widget906 = {
        size: null
    };

    var wokrTypeStand = '';

    /**
     * 파라미터에 따른 메서드 선택
     * size : 사이즈 (값 "wide" -> wide위젯 메서드 호출, "normal" -> 한칸 위젯 메서드 호출)
     */
    function init_listBox906(size) {
        widget906.size = size;

        // if (size == "normal"){
        // 	createWidgetMini906();
        // 	setDataWidgetMini906();
        // } else if (size == ("wide")){
        // 	createWidgetWide906();
        // 	setDataWidgetWide906();
        // }
    }

    // 위젯 html 코드 생성
    function createWidgetMini906(){
        var code =
            '<div class="widget_header">' +
            '  <div class="widget_title">시간외 근무 사용현황</div>' +
            '</div>' +
            '<div class="widget_body widget-common overtime-work">' +
            '  <div class="bookmarks_title">' +
            '    <a href="#" class="arrowLeft"><i class="mdi-ico">keyboard_arrow_left</i></a>' +
            '    <span id="workTypeName"></span>' +
            '    <a href="#" class="arrowRight"><i class="mdi-ico">keyboard_arrow_right</i></a>' +
            '  </div>' +
            '  <div class="container_info">' +
            '    <span class="info_title_num" id="overCntMini"><span class="info_title unit">건</span></span>' +
            '    <span class="info_title desc" id="overTimeTrendMini"></span>' +
            '    <div class="info_box">' +
            '      <span class="title_kor">평균</span><span class="box_bnum" id="avgHourMini"></span><span class="title_kor">시간</span>' +
            '    </div>' +
            '  </div>' +
            '</div>';

        document.querySelector('#widget906Element').innerHTML = code;
    }


    // Function to open the modal
    function open906Modal() {
        var menuListLayer = new window.top.document.LayerModal({
            id: 'list906Layer',
            url: "${ctx}/list09.do?cmd=viewList906Layer",
            parameters: {},
            width: 800,
            height: 635,
            title: '규정'
        });
        menuListLayer.show();
    }

</script>

<div class="widget_header">
    <div class="widget_title">
        장기근속포상경조금
    </div>
</div>
<div class="widget_body widget_approval widget-benefit">
    <div class="inner-wrap">
        <div class="widget-desc">임직원의 노고에 감사드리며 근속연수에 따라 포상금 및 기념패를 지급합니다. <br>근속연수는 매년 12월 말의 기준이며 상세 내용은 규정을 확인합니다.</div>
        <div class="btn-wrap">
            <button class="btn-common" onclick="open906Modal()">규정</button>
        </div>
        <div class="img-wrap">
            <img src="/common/images/widget/widget_reward_2x.png" alt="">
        </div>
    </div>
</div>
