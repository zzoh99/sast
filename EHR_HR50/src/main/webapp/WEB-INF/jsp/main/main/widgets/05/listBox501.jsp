<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
	var widget501 = {
		size: null
	};

    var chartRate = 0;

	/**
	 * 파라미터에 따른 메서드 선택 
	 * size : 사이즈 (값 "wide" -> wide위젯 메서드 호출, "normal" -> 한칸 위젯 메서드 호출)
	 */
	function init_listBox501(size) {
		widget501.size = size;
		
		if (size == "normal"){
            // TODO 디자인 여부 확인 + 수정필요
			createWidgetMini501();
			setDataWidgetMini501();
		} else if (size == ("wide")){
			createWidgetWide501();
			setDataWidgetWide501();
		}
	}

	// 위젯 mini html 코드 생성 
	function createWidgetMini501(){
		var code =
			  '<div class="widget_header">' +
			  '  <div class="widget_title">교육이수현황</div>' +
			  '</div>' +
              '<div class="widget_body attendance_contents overtime_attendance">' +
			  '  <div class="container_box">' +
              '    <div id="attendanceOvertime" class="container_"></div>' +
			  '    <div class="container_left">' +
			  '      <div class="container_info">' +
			  '        46<span class="title_kor">시간</span>12<span class="title_kor">분 근무 가능</span>' +
			  '      </div>' +
			  '    </div>' +
			  '  </div>' +
			  '</div>';

		document.querySelector('#widget501Element').innerHTML = code;
	}

	// 위젯 mini 데이터 넣기  
	function setDataWidgetMini501(){
		const leave = ajaxCall('getListBox501List.do', '', false).data.leave;

		// TODO 데이터 셋팅

	}

	// 위젯 wide html 코드 생성 
	function createWidgetWide501(){
		var code =
			  '<div class="widget_header">' +
			  '     <div class="widget_title">교육이수현황</div>' +
			  '</div>' +
			  '<div class="widget_body attendance_contents overtime_attendance">' +
              '     <div class="container_box">' +
              '         <div class="container_left">' +
              '           <div class="container_info" id="w501_total">' +
              '                   0<span class="title_kor">건중</span>0<span class="title_kor">건 이수</span>' +
              '           </div> ' +
              '         </div>' +
              '         <div class="container_right">' +
              '            <div class="overtime_box">' +
              '               <div class="box_time" id="w501_rate">0<div class="box_mark">%</div></div>' +
              // '               <div class="half_line"></div>' +
              // '               <div class="box_title">주 52시간중<span>21%</span>사용</div>' +
              '            </div>' +
              '            <div id="attendanceOvertime"></div>' +
              '         </div>' +
              '       </div>' +
              '</div>';

		document.querySelector('#widget501Element').innerHTML = code;
	}

	// 위젯 wide 데이터 넣기
	function setDataWidgetWide501(){
		const info = ajaxCall('getListBox501List.do', '' , false).data;
        if (info != null) {
            $("#w501_total").html(info.totalCnt+'<span class="title_kor">건중</span>'+info.cmpltCnt+'<span class="title_kor">건 이수</span>');
            chartRate = info.rateCnt;
            $("#w501_rate").html(info.rateCnt+'<div class="box_mark">%</div>');
        }
	}
</script>
<div class="widget" id="widget501Element"></div>

<script>
	$(document).ready(function () {
		leaveChartWithData();
	});

	// apexchart 퇴사자 차트 데이터 
	function leaveChartWithData() {

		if (widget501.size == 'wide'){
			var options = {
                    series: [chartRate],
                    chart: { height: 287, type: 'radialBar' },
                    colors: ["#2570f9"],
                    plotOptions: {
                        radialBar: { hollow: { size: '70%' } }
                    },
                    dataLabels: {enabled: false},
                    labels: [""]
			  }
		}
		
		var chart = new ApexCharts(document.querySelector("#attendanceOvertime"), options);
        chart.render();
	};
</script>