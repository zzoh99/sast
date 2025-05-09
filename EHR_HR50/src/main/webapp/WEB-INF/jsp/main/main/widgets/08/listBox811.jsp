<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
    let widget811 = {
        size: null
    };

    let w811ChartAllRate = 0;
    let w811ChartDeptRate = 0;
    let w811ChartSelfRate = 0;

    /**
     * 파라미터에 따른 메서드 선택
     * size : 사이즈 (값 "wide" -> wide위젯 메서드 호출, "normal" -> 한칸 위젯 메서드 호출)
     */
    function init_listBox811(size) {
        widget811.size = size;

        if (size == "normal"){
            // TODO 디자인 여부 확인 + 수정필요
            createWidgetMini811();
            setDataWidgetMini811();
        } else if (size == ("wide")){
            createWidgetWide811();
            setDataWidgetWide811();
        }
    }

    // 위젯 mini html 코드 생성 
    function createWidgetMini811(){
        let code =
            '<div class="widget_header">' +
            '  <div class="widget_title">휴가 소진율</div>' +
            '</div>' +
            '<div class="widget_body vacation_widget_contents vacation_widget">' +
            '  <div class="container_box">' +
            '    <div class="container_left">' +
            '      <div class="rate_box">' +
            '        <div class="box_time" id="w811_rate">0<div class="box_mark">%</div></div>' +
            '      </div>' +
            '      <div id="widget811Chart"></div>' +
            '    </div>' +
            '  </div>' +
            '</div>';

        document.querySelector('#widget811Element').innerHTML = code;
    }

    // 위젯 mini 데이터 넣기  
    function setDataWidgetMini811(){
        //const leave = ajaxCall('/getListBox811List.do', '', false).data.leave;

        // TODO 데이터 셋팅

    }

    // 위젯 wide html 코드 생성 
    function createWidgetWide811() {
        let code =
            '<div class="widget_header">' +
            '     <div class="widget_title">휴가 소진율</div>' +
            '</div>' +
            '<div class="widget_body vacation_widget_contents vacation_widget">' +
            '   <div class="container_box">' +
            '     <div class="container_w30p">' +
            '       <div class="rate_box">' +
            '         <div class="box_time" id="w811AllRate">0<div class="box_mark">%</div></div>' +
            '         <div class="box_label">전사평균</div>' +
            '       </div>' +
            '       <div id="widget811AllChart"></div>' +
            '     </div>' +
            '     <div class="container_w30p">' +
            '       <div class="rate_box">' +
            '         <div class="box_time" id="w811DeptRate">0<div class="box_mark">%</div></div>' +
            '         <div class="box_label">부서평균</div>' +
            '       </div>' +
            '       <div id="widget811DeptChart"></div>' +
            '     </div>' +
            '     <div class="container_w30p">' +
            '       <div class="rate_box">' +
            '         <div class="box_time" id="w811SelfRate">0<div class="box_mark">%</div></div>' +
            '         <div class="box_label">본인</div>' +
            '       </div>' +
            '       <div id="widget811SelfChart"></div>' +
            '     </div>' +
            '   </div>' +
            '</div>';
        document.querySelector('#widget811Element').innerHTML = code;
    }

    // 위젯 wide 데이터 넣기
    function setDataWidgetWide811(){

        ajaxCall2("getListBox811List.do"
            , ""
            , true
            , null
            , function(data) {
                if (data && data.data) {

                    const info = data.data;
                    info.forEach((d,i) => {
                        console.log(d + " " + i);
                        switch (d.cd ){
                            case "ALL" :
                                w811ChartAllRate = d.usedPer;
                            case "DEPT" :
                                w811ChartDeptRate = d.usedPer;
                            case "SELF":
                                w811ChartSelfRate = d.usedPer;
                        }
                    });

                    /*
                    const info =
                        // 전사평균, 부서평균, 본인
                        {allRate: 60, deptRate: 45, selfRate: 70}
                    ;
                        */
                    if (info != null) {
                        //w811ChartAllRate = allRate;
                        //w811ChartDeptRate = deptRate;
                        //w811ChartSelfRate = selfRate;

                        $("#w811AllRate").html(w811ChartAllRate+'<div class="box_mark">%</div>');
                        $("#w811DeptRate").html(w811ChartDeptRate+'<div class="box_mark">%</div>');
                        $("#w811SelfRate").html(w811ChartSelfRate+'<div class="box_mark">%</div>');
                    }
                }
            })
    }
</script>
<div class="widget" id="widget811Element"></div>

<script>
    $(document).ready(function () {
        w811ChartWithData();
    });

    // apexchart 차트 데이터
    function w811ChartWithData() {
        let allChartOptions = '';
        let deptChartOptions = '';
        let selfChartOptions = '';

        if (widget811.size == 'wide'){
            allChartOptions = {
                series: [w811ChartAllRate],
                chart: { height: 230, type: 'radialBar' },
                colors: ["#555"],
                plotOptions: {
                    radialBar: { hollow: { size: '60%' } }
                },
                dataLabels: {enabled: false},
                labels: [""]
            };

            deptChartOptions = {
                series: [w811ChartDeptRate],
                chart: { height: 230, type: 'radialBar' },
                colors: ["#80604d"],
                plotOptions: {
                    radialBar: { hollow: { size: '60%' } }
                },
                dataLabels: {enabled: false},
                labels: [""]
            };

            selfChartOptions = {
                series: [w811ChartSelfRate],
                chart: { height: 230, type: 'radialBar' },
                colors: ["#2570f9"],
                plotOptions: {
                    radialBar: { hollow: { size: '60%' } }
                },
                dataLabels: {enabled: false},
                labels: [""]
            }
        }

        let allChart = new ApexCharts(document.querySelector("#widget811AllChart"), allChartOptions);
        let deptChart = new ApexCharts(document.querySelector("#widget811DeptChart"), deptChartOptions);
        let selfChart = new ApexCharts(document.querySelector("#widget811SelfChart"), selfChartOptions);

        allChart.render();
        deptChart.render();
        selfChart.render();
    }
</script>