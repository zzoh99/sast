<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
    let widget810 = {
        size: null
    };

    let w810ChartRate = 0;

    /**
     * 파라미터에 따른 메서드 선택
     * size : 사이즈 (값 "wide" -> wide위젯 메서드 호출, "normal" -> 한칸 위젯 메서드 호출)
     */
    function init_listBox810(size) {
        widget810.size = size;

        if (size == "normal"){
            // TODO 디자인 여부 확인 + 수정필요
            createWidgetMini810();
            setDataWidgetMini810();
        } else if (size == ("wide")){
            createWidgetWide810();
            setDataWidgetWide810();
        }
    }

    // 위젯 mini html 코드 생성 
    function createWidgetMini810(){
        let code =
            '<div class="widget_header">' +
            '  <div class="widget_title">휴가 사용 현황</div>' +
            '</div>' +
            '<div class="widget_body vacation_widget_contents vacation_widget">' +
            '  <div class="container_box">' +
            '    <div id="widget810Chart" class="container_"></div>' +
            '    <div class="container_left">' +
            '      <div class="rate_box">' +
            '        <div class="box_time" id="w810_rate">0<div class="box_mark">%</div></div>' +
            '      </div>' +
            '      <div id="widget810Chart"></div>' +
            '    </div>' +
            '  </div>' +
            '</div>';

        document.querySelector('#widget810Element').innerHTML = code;
    }

    // 위젯 mini 데이터 넣기  
    function setDataWidgetMini810(){
        //const leave = ajaxCall('getListBox810List.do', '', false).data.leave;

        // TODO 데이터 셋팅

    }

    // 위젯 wide html 코드 생성 
    function createWidgetWide810() {
        var code =
            '<div class="widget_header">' +
            '     <div class="widget_title">휴가 사용 현황</div>' +
            '</div>' +
            '<div class="widget_body vacation_widget_contents vacation_widget">' +
            '     <div class="container_box">' +
            '         <div class="container_left">' +
            '            <div class="rate_box">' +
            '               <div class="box_time" id="w810_rate">0<div class="box_mark">%</div></div>' +
            '            </div>' +
            '            <div id="widget810Chart"></div>' +
            '         </div>' +
            '         <div class="container_right">' +
            '           <div class="container_info">' +
            '             <div><div class="info_title">발생일수</div><div class="cnt" id="w810CreCnt"></div></div> ' +
            '             <div><div class="info_title">사용일수</div><div class="cnt blue" id="w810UseCnt"></div></div> ' +
            '             <div><div class="info_title">잔여일수</div><div class="cnt green" id="w810RestCnt"></div></div> ' +
            '           </div> ' +
            '         </div>' +
            '       </div>' +
            '</div>';
        document.querySelector('#widget810Element').innerHTML = code;
    }

    // 위젯 wide 데이터 넣기
    function setDataWidgetWide810() {

        ajaxCall2("getListBox810Map.do"
            , ""
            , true
            , null
            , function(data) {
                if (data && data.data) {

                    const info = data.data;

                    if (info != null) {
                        $("#w810CreCnt").text(info.creCnt);   //발생일수
                        $("#w810UseCnt").text(info.usedCnt);  //사용일수
                        $("#w810RestCnt").text(info.restCnt); //잔여일수

                        w810ChartRate = info.usedPer;   //휴가사용율
                        $("#w810_rate").html(w810ChartRate + '<div class="box_mark">%</div>');
                    }
                }
            })
    }
</script>
<div class="widget" id="widget810Element"></div>

<script>
    $(document).ready(function () {
        w810ChartWithData();
    });

    // apexchart 차트 데이터 
    function w810ChartWithData() {

        if (widget810.size == 'wide'){
            var options = {
                series: [w810ChartRate],
                chart: { height: 287, type: 'radialBar' },
                colors: ["#2570f9"],
                plotOptions: {
                    radialBar: { hollow: { size: '70%' } }
                },
                dataLabels: {enabled: false},
                labels: [""]
            }
        }

        var chart = new ApexCharts(document.querySelector("#widget810Chart"), options);
        chart.render();
    }
</script>