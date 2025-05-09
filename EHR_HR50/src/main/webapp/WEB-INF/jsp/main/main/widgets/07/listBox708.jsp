<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<script type="text/javascript">
    /*
     * 예상퇴직금 조회
     */

    let today = '<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>';
    // 위젯 사이즈별 로드
    function init_listBox708(size) {
        widget708.size = size;
        if (size == "normal"){
            widget708.makeMini();
            widget708.setDataMini();
        } else if (size == ("wide")){
            widget708.makeWide();
            widget708.setDataWide();
        }
    }

    let widget708 = {
        size: null,
        elemId: 'widget708',  // 위젯 엘리면트 id
        $widget: null,
        w708Data: null,  // 예상퇴직금 데이터

        // 작은 위젯 마크업 생성
        makeMini: function(){
            let html =
                '<div class="widget_header">' +
                '  <div class="widget_title">예상퇴직금 조회</div>' +
                '</div>' +
                '<div class="widget_body attendance_contents annual-status retired-pay widget-common" style="margin-top: 20px;">' +
                '  <div class="select-outer" style="justify-content:space-around;">' +
                '    <div class="custom_select no_style">' +
                '       <input class="date2 bbit-dp-input" style="font-size: 13px;" type="text" id="w708SearchYmd" name="w708SearchYmd" value="'+today+'"/>' +
                '    </div>' +
                '    <a href="javascript:widget708.w708Search()" id="btnSearch" class="button">조회</a>'+
                '  </div>' +
                '  <div class="container_info">' +
                '    <div class="info_box center">' +
                '      <div class="toggle-wrap">' +
                '        <span class="toggle-label">예상퇴직금</span>' +
                '        <input type="checkbox" id="toggle4" hidden="">' +
                '        <label for="toggle4" class="toggleSwitch">' +
                '          <span class="toggleButton"></span>' +
                '        </label>' +
                '      </div>' +
                '      <span class="info_title_num" id="w708RetPay" style="font-size: 50px;"><span class="desc">만원</span></span>' +
                '    </div>' +
                '  </div>' +
                '</div>';

            document.getElementById(this.elemId).innerHTML = html;
        },

        // 작은 위젯 데이터 표시
        setDataMini: function(){
        	if (this.w708Data != null ){
                const w708Data = this.w708Data;
                $("#toggle4").prop('checked', true);
                $("#w708RetPay").html(w708Data.earningMon +'<span class="desc">만원</span>');
                $("#w708RetPay").show();
            }else {
                $("#w708RetPay").html("");
                $("#toggle4").prop('checked', false);
                $("#w708RetPay").hide();
            }
        },

        // 와이드 위젯 마크업 생성
        makeWide: function(){
            let html =
                '<div class="widget_header">' +
                '  <div class="widget_title">예상퇴직금 조회</div>' +
                '</div>' +
                '<div class="widget_body attendance_contents annual-status retired-pay widget-common best-top">' +
                '  <div class="select-outer">' +
                '    <div class="custom_select no_style"><span class="label">퇴직예정일</span>'+
                '      <input class="date2 bbit-dp-input" style="font-size: 13px;" type="text" id="w708SearchYmd" name="w708SearchYmd" value="'+today+'"/>'+
                '    </div>' +
                '    <a href="javascript:widget708.w708Search()" id="btnSearch" class="button">조회</a>'+
                '  </div>' +
                '  <div class="container_box">' +
                '    <div class="container_info">' +
                '      <div class="info_box">' +
                '        <span class="info_title"><span class="label">입사일자</span><span class="desc" id="w708EmpYmd"></span></span>' +
                '        <span class="info_title"><span class="label">근속기간</span><span class="desc" id="w708WorkDay"></span></span>' +
                '        <span class="info_title"><span class="label">월평균임금</span><span class="desc" id="w708MonAvgPay"></span></span>' +
                '      </div>' +
                '    </div>' +
                '    <div class="container_info">' +
                '      <div class="info_box center">' +
                '        <div class="toggle-wrap">' +
                '          <span class="toggle-label">예상퇴직금</span>' +
                '          <input type="checkbox" id="toggle4" hidden="">' +
                '          <label for="toggle4" class="toggleSwitch">' +
                '            <span class="toggleButton"></span>' +
                '          </label>' +
                '        </div>' +
                '        <span class="info_title_num" id="w708RetPay"><span class="desc">만원</span></span>' +
                '      </div>' +
                '    </div>' +
                '  </div>' +
                '</div>';

            document.getElementById(this.elemId).innerHTML = html;
        },

        // 와이드 위젯 데이터 표시
        setDataWide: function(){
            if (this.w708Data != null ){
                const w708Data = this.w708Data;
                
                $("#w708EmpYmd").text(w708Data.empYmd);
                $("#w708WorkDay").text(w708Data.wkpDCnt);
                $("#w708MonAvgPay").text(w708Data.avgMon);
                $("#toggle4").prop('checked', true);
                $("#w708RetPay").html(w708Data.earningMon +'<span class="desc">만원</span>');
                $("#w708RetPay").show();
            }else {
                $("#w708EmpYmd").text("");
                $("#w708WorkDay").text("");
                $("#w708MonAvgPay").text("");
                $("#w708RetPay").html("");
                $("#toggle4").prop('checked', false);
                $("#w708RetPay").hide();
            }

        },
        // UI 설정
        setUI: function(){

        },
        // UI 이벤트 설정
        setUIEvent: function(){
        },
        w708Search: function() {
            var ymd =  $("#w708SearchYmd").val().replaceAll('-','');
            this.w708Data = ajaxCall('/getListBox708Map.do', {ymd: ymd}, false).data;
            if(this.size == ("normal")) {
                this.setDataMini();
            } else if (this.size == ("wide")) {
                this.setDataWide();
            }
        }

    };
    

</script>
<div class="widget" id="widget708"></div>

<script>
    // DOM 로드 후에 UI 설정
    $(document).ready(function () {
        widget708.$widget = $('#'+ widget708.elemId);

        widget708.setUI(); // UI생성
        widget708.setUIEvent(); // 이벤트 할당

        $("#w708SearchYmd").datepicker2();

        $("#w708SearchYmd").bind("keyup",function(event){
            if( event.keyCode == 13){
                widget708.w708Search();
            }
        });

        $("#w708SearchYmd").change(function(){
            widget708.w708Search();
        });
        
        $("#toggle4").click(function(){
        	if ( $("#toggle4").is(':checked')){
                $("#w708RetPay").show();
            }else {
            	$("#w708RetPay").hide();
            }
        });
        
    });
</script>