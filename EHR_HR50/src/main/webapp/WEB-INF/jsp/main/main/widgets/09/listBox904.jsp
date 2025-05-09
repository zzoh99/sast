<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
    /*
     * 근태 > 시간외 근무 사용현황
     */

    var widget904 = {
        size: null
    };

    var wokrTypeStand = '';

    /**
     * 파라미터에 따른 메서드 선택
     * size : 사이즈 (값 "wide" -> wide위젯 메서드 호출, "normal" -> 한칸 위젯 메서드 호출)
     */
    function init_listBox904(size) {
        widget904.size = size;

        // if (size == "normal"){
        // 	createWidgetMini904();
        // 	setDataWidgetMini904();
        // } else if (size == ("wide")){
        // 	createWidgetWide904();
        // 	setDataWidgetWide904();
        // }
    }

    // 위젯 html 코드 생성
    function createWidgetMini904(){
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

        document.querySelector('#widget904Element').innerHTML = code;
    }


    // Function to open the modal
    function open904Modal() {
        var menuListLayer = new window.top.document.LayerModal({
            id: 'list904Layer',
            url: "${ctx}/list09.do?cmd=viewList904Layer",
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
        단체상해보험
    </div>
</div>
<div class="widget_body widget_approval widget-benefit">
    <div class="inner-wrap">
        <div class="widget-desc">임직원 여러분의 상해, 질병과 관련한 복지 증진을 위하여 단체상해보험을 가입하여 운용하고 있습니다.<br>보험청구 필요한 사항이 발생하였을 경우 가이드를 참고하여 접수 및 청구하여 활용해 주시기 바랍니다.</div>
        <div class="btn-wrap">
            <button class="btn-common" onclick="open904Modal()">가이드</button>
        </div>
        <div class="img-wrap">
            <img src="/common/images/widget/widget_insurance_2x.png" alt="">
        </div>
    </div>
</div>
