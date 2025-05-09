<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
	/*
	 * 인사 > 전사 인원 추이
	 */

	var widget206 = {
		size: null
	};

	var workForceChartYearData = [];
	var workForceChartMonthData = [];

	/**
	 * 파라미터에 따른 메서드 선택 
	 * size : 사이즈 (값 "wide" -> wide위젯 메서드 호출, "normal" -> 한칸 위젯 메서드 호출)
	 */
	function init_listBox206(size) {
		widget206.size = size;
		
		if (size == "normal"){
			createWidgetMini206();
			setDataWidgetMini206();
		} else if (size == ("wide")){
			createWidgetWide206();
		}
	}

	// 위젯 mini html 코드 생성 
	function createWidgetMini206(){
		var code = 
			'<div class="widget_header">' +
			'  <div class="widget_title">전사 인원 추이</div>' +
			'</div>' +
			'<div class="widget_body attendance_contents annual-status salary-average">' +
			'  <div class="container_box">' +
			'    <div class="container_left">' +
			'      <div class="container_info barChart-wrap">' +
			'        <span class="info_label mt-0">현재 정원 (PO/TO)</span>' +
			'        <span class="info_title_num" id="workForceGoalGapRate"></span>' +
			'        <div class="progress_container" id="barGoalRate">' +
			'        </div>' +
			'      </div>' +
			'      <div class="container_info barChart-wrap">' +
			'        <span class="info_label mt-0">정원율</span>' +
			'        <span class="info_title_num" id="workForceRate"></span>' +
			'        <div class="progress_container" id="barRate">' +
			'        </div>' +
			'      </div>' +
			'    </div>' +
			'  </div>' +
			'</div>';

		document.querySelector('#widget206Element').innerHTML = code;
	}

	// 위젯 mini html 코드 생성 
	function setDataWidgetMini206(){
		const personnelTrend = ajaxCall('getListBox206List.do', '', false).data.personnelTrend;

		if (personnelTrend){
			var Html =
				personnelTrend.cnt + '<span class="info_title data">/' + personnelTrend.goal + '</span><span class="info_title data-unit">명</span>'
	
			document.querySelector('#workForceGoalGapRate').innerHTML = Html;
				
			$('#workForceRate').text(personnelTrend.rate + '%');
			document.querySelector('#barGoalRate').innerHTML = '<div class="progress_bar bar_green" style="width:' + personnelTrend.rate + '%"></div>';
			document.querySelector('#barRate').innerHTML = '<div class="progress_bar bar_blue" style="width:' + personnelTrend.rate + '%"></div>';
		}
	}
	
	// 위젯wide html 코드 + 테이터 넣기 
	function createWidgetWide206(){
		var code =
			'<div class="widget_header">' +
			'  <div class="widget_title">전사 인원 추이</div>' +
			'</div>' +
			'<div class="widget_body attendance_contents annual-status salary-average">' +
			'  <div class="container_box">' +
			'    <div class="container_left">' +
			'      <div class="container_info barChart-wrap">' +
			'        <span class="info_label mt-0">현재 정원 (PO/TO)</span>' +
			'        <span class="info_title_num" id="workForceGoalGapRate"></span>' +
			'        <div class="progress_container" id="barGoalRate">' +
			'        </div>' +
			'      </div>' +
			'      <div class="container_info barChart-wrap">' +
			'        <span class="info_label mt-0">정원율</span>' +
			'        <span class="info_title_num" id="workForceRate"></span>' +
			'        <div class="progress_container" id="barRate">' +
			'        </div>' +
			'      </div>' +
			'    </div>' +
			'    <div class="container_right">' +
			'      <div class="bookmarks_title select-outer">' +
			'        <div class="custom_select no_style">' +
			'          <button class="select_toggle select_toggle206">' +
			'            <span id="workForceOption">연도별</span><i class="mdi-ico">arrow_drop_down</i>' +
			'          </button>' +
			'          <div class="select_options numbers select_options206" style="visibility: hidden;">' +
			'            <div class="option" value="year">연도별</div>' +
			'            <div class="option" value="quarter">분기별</div>' +
			'            <div class="option" value="month">월별</div>' +
			'          </div>' +
			'        </div>' +
			'      </div>' +
			'      <div class="chart-wrap">' +
			'        <div id="workForceChart"></div>' +
			'      </div>' +
			'    </div>' +
			'  </div>' +
			'</div>';

		document.querySelector('#widget206Element').innerHTML = code; 

		const personnelTrend = ajaxCall('getListBox206List.do', '', false).data.personnelTrend;

		if (personnelTrend){
			var Html =
				personnelTrend.cnt + '<span class="info_title data">/' + personnelTrend.goal + '</span><span class="info_title data-unit">명</span>'
	
			document.querySelector('#workForceGoalGapRate').innerHTML = Html;
			document.querySelector('#barGoalRate').innerHTML = '<div class="progress_bar bar_green" style="width:' + personnelTrend.rate + '%"></div>';
			document.querySelector('#barRate').innerHTML = '<div class="progress_bar bar_blue" style="width:' + personnelTrend.rate + '%"></div>';
			$('#workForceRate').text(personnelTrend.rate + '%');   
		}
	}

	// 연도별, 분기별, 월별 클릭 함수 
	$(document).ready(function() {
		var selectToggle = document.querySelector('.select_toggle206');
	    var selectOptions = document.querySelector('.select_options206');

	    $('#widget206Element').on('click', '.select_toggle206', function() {
	    	selectOptions = document.querySelector('.select_options206');
	        if (selectOptions.style.visibility == 'hidden') {
	            selectOptions.style.visibility = 'visible';
	        } else {
	            selectOptions.style.visibility = 'hidden';
	        }
	    });

		$('#widget206Element').on('click', '.option', function() {
			var option = $(this).attr('value');
			switch (option) {
			case 'year':
				$('#workForceOption').text("연도별");
				option = 'year';
				document.getElementById('workForceChart').innerHTML = '';
				workForceWithData(option);
				break;
			case 'quarter':
		        $('#workForceOption').text("분기별");
		        option = 'quarter';
		        document.getElementById('workForceChart').innerHTML = '';
		        workForceWithData(option);
		        break;
			case 'month':
		        $('#workForceOption').text("월별");
		        option = 'month';
		        document.getElementById('workForceChart').innerHTML = '';
		        workForceWithData(option);
		        break;
		    }

		    selectOptions.style.visibility = 'hidden';
		});
	});
</script>
<div class="widget" id="widget206Element"></div>

<script>
	$(document).ready(function () {
		workForceWithData();
	});

	// apexchart 전사 인원 추이 차트 + 데이터 
	function workForceWithData(chartOption) {
		const personnelTrend = ajaxCall('getListBox206List.do', {option: chartOption} , false).data.personnelTrend;

		if (typeof chartOption == "undefined" || chartOption == null || chartOption == ""){
			chartOption = 'year';
		}

		var nowDate = new Date();
		var workForceYear = [];
		
		if (chartOption == "year"){
			
			for (var i = 0; i < 4; i++) {
				workForceYear.push(nowDate.getFullYear() - i);
			}
			
			for (var i = 0; i < 4; i++){
			    workForceChartYearData.push(personnelTrend["year" + (i+1) + "Cnt"]); 
			}
			
		} else if (chartOption == "month" || chartOption == "quarter"){ 
			for (var i = 0; i < 12; i++){
			    workForceChartMonthData.push(personnelTrend["mon" + (i+1) + "Cnt"]); 
			    console.log('workForceChartMonthData[i]asd', workForceChartMonthData[i]);
			}
		}
		
		if (widget206.size == 'wide'){
			var options = {
				  series: [{
					name: '전사 인원',
				    data: (chartOption == 'year')
					  ? [workForceChartYearData[3], workForceChartYearData[2], workForceChartYearData[1], workForceChartYearData[0]]
					  : (chartOption == 'month')
					  ? [workForceChartMonthData[0], workForceChartMonthData[1], workForceChartMonthData[2], workForceChartMonthData[3], workForceChartMonthData[4], workForceChartMonthData[5], workForceChartMonthData[6], workForceChartMonthData[7], workForceChartMonthData[8], workForceChartMonthData[9], workForceChartMonthData[10], workForceChartMonthData[11]]
					  : (chartOption == 'quarter')
					  ? [workForceChartMonthData[0] + workForceChartMonthData[1] + workForceChartMonthData[2], workForceChartMonthData[3] + workForceChartMonthData[4] + workForceChartMonthData[5], workForceChartMonthData[6] + workForceChartMonthData[7] + workForceChartMonthData[8], workForceChartMonthData[9] + workForceChartMonthData[10] + workForceChartMonthData[11]]
					  : [],
					color: '#777777'
				  }],
				  chart: {
				    type: 'bar', 
				    height: 143,
				    width: 238,
				    toolbar: {
			            show: false
			        }
				  },
				  plotOptions: {
				    bar: {
				      horizontal: false, 
				      dataLabels: {
				        position: 'top',
				      },
				      columnWidth: 5, 
				    }
				  },
				  legend: {
			        position: 'top',
			        horizontalAlign: 'right'
			      },
				  dataLabels: {
				    enabled: false,
				    offsetX: -6,
				    style: {
				      fontSize: '12px',
				      colors: ['#fff']
				    }
				  },
				  stroke: {
				    show: true,
				    width: 1,
				    colors: ['#fff']
				  },
				  tooltip: {
				    shared: true,
				    intersect: false
				  },
				  xaxis: {
					categories: (chartOption == 'year')
					  ? [workForceYear[3], workForceYear[2], workForceYear[1], workForceYear[0]]
					  : (chartOption == 'month')
					  ? ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월']
					  : (chartOption == 'quarter')
					  ? ['`' +  + '1분기', '2분기', '3분기', '4분기']
					  : []
				  },
				  yaxis: {
					  show: false,
					    tickAmount: 4,
			  },
		};
		
		var chart = new ApexCharts(document.querySelector("#workForceChart"), options);
			chart.render();
		}	
	};
</script>