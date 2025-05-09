<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
	/*
	 * 인사 > 퇴사율
	 */

	var widget204 = {
		size: null
	};

	var monthIn = [];
	var monthOut = [];
	var yearIn = [];
	var yearOut = [];
	var year = [];
	var monthLeaveOut = [];
	var leaveOption = '';

	/**
	 * 파라미터에 따른 메서드 선택 
	 * size : 사이즈 (값 "wide" -> wide위젯 메서드 호출, "normal" -> 한칸 위젯 메서드 호출)
	 */
	function init_listBox204(size) {
		widget204.size = size;
		
		if (size == "normal"){
			createWidgetMini204();
			setDataWidgetMini204();
		} else if (size == ("wide")){
			createWidgetWide204();
			setDataWidgetWide204();
		}
	}

	// 위젯 mini html 코드 생성 
	function createWidgetMini204(){
		var code =
			  '<div class="widget_header">' +
			  '  <div class="widget_title">퇴사율</div>' +
			  '</div>' +
			  '<div class="widget_body attendance_contents annual-status salary-average">' +
			  '  <div class="container_box">' +
			  '    <div class="container_left">' +
			  '      <div class="container_info">' +
			  '        <span class="info_title label">당해년도 퇴사율</span>' +
			  '        <span class="info_title_num" id="leavePercent"></span>' +
			  '        <span class="info_title desc" id="leaveGap"></span>' +
			  '      </div>' +
			  '      <div class="info_box">' +
			  '        <span class="title_kor">퇴사자 수</span><span class="box_bnum" id="leaveCnt"></span>' +
			  '      </div>' +
			  '    </div>' +
			  '  </div>' +
			  '</div>';

		document.querySelector('#widget204Element').innerHTML = code;	
	}

	// 위젯 mini 데이터 넣기  
	function setDataWidgetMini204(){
		const leave = ajaxCall('getListBox204List.do', '', false).data.leave;
		
		setLeavePercentage(leave.data[0].out,'#leavePercent');
		compareLeaveChange(leave.data[0].gapRateOut,'#leaveGap');
		setLeaveCnt(leave.data[0].outCnt1,'#leaveCnt');
		yearLeave = leave.data[0];
	}

	// 위젯 wide html 코드 생성 
	function createWidgetWide204(){
		for (var i = 0; i < 4; i++) {
			year.push((new Date()).getFullYear() - i);
		}
		
		var code =
			  '<div class="widget_header">' +
			  '  <div class="widget_title">퇴사율</div>' +
			  '</div>' +
			  '<div class="widget_body attendance_contents annual-status salary-average">' +
			  '  <div class="container_box">' +
			  '    <div class="container_left">' +
			  '      <div class="container_info">' +
			  '        <span class="info_title label">당해년도 퇴사율</span>' +
			  '        <span class="info_title_num" id="leavePercentWide"></span>' +
			  '        <span class="info_title desc" id="leaveGapWide"></span>' +
			  '      </div>' +
			  '      <div class="info_box">' +
			  '        <span class="title_kor">퇴사자 수</span><span class="box_bnum" id="leaveCntWide"></span>' +
			  '      </div>' +
			  '    </div>' +
			  '    <div class="container_right">' +
			  '      <div class="bookmarks_title select-outer">' +
			  '        <div class="custom_select no_style">' +
			  '          <button class="select_toggle select_toggle204">' +
			  '            <span id="currentLeaveOption">연도별</span><i class="mdi-ico">arrow_drop_down</i>' +
			  '          </button>' +
			  '          <div class="select_options numbers select_options204" style="visibility: hidden;">' +
			  '            <div class="option" value="year">연도별</div>' +
			  '            <div class="option" value="quarter">분기별</div>' +
			  '            <div class="option" value="month">월별</div>' +
			  '          </div>' +
			  '        </div>' +
			  '        <div class="sub-title" id="leaveDay"></div>' +
			  '      </div>' +
			  '      <div class="chart-wrap">' +
			  '        <div id="leaveChart"></div>' +
			  '      </div>' +
			  '    </div>' +
			  '  </div>' +
			  '</div>';

		document.querySelector('#widget204Element').innerHTML = code;
	}

	// 위젯 wide 데이터 넣기
	function setDataWidgetWide204(wideOption){
		
		if (typeof wideOption == "undefined" || wideOption == null || wideOption == ""){
			leaveOption = 'year';
			wideOption = 'year';
		 }

		var leaveYear = (new Date()).getFullYear(); // 연도
		var leaveMonth = ((new Date()).getMonth() + 1).toString().padStart(2, '0'); // 월 (2자리로 표시)
		var leaveDay = (new Date()).getDate().toString().padStart(2, '0'); // 일 (2자리로 표시)
		document.getElementById('leaveDay').textContent = leaveYear + '년 ' + leaveMonth + '월 ' + leaveDay + '일 기준'; 
		
		const leave = ajaxCall('getListBox204List.do', '' , false).data.leave;

		setLeavePercentage(leave.data[0].out, '#leavePercentWide');
		compareLeaveChange(leave.data[0].gapRateOut, '#leaveGapWide');
		setLeaveCnt(leave.data[0].outCnt1, '#leaveCntWide');

		// 년도별 데이터
		for (var i = 0; i < 4; i++) {
			yearOut.push(leave.data[0]['outCnt' + (i + 1)]);
		}

		// 월별 데이터
		for (var i = 0; i < 12; i++) {
			monthLeaveOut.push(leave.data[0]['leavemonth' + (i+1)]);
		}
	}

	function setLeavePercentage(percent, targetElement){
		var Html = percent + '<span class="info_title_num unit">%</span>';
		document.querySelector(targetElement).innerHTML = Html;
	}

	function setLeaveCnt(cnt, targetElement){
		var Html = cnt + '<span class="info_title unit">명</span>';
		document.querySelector(targetElement).innerHTML = Html;
	}

	function compareLeaveChange(gapRate, targetElement) {
		var gapRateBefore = '';

		if (gapRate > 0) {
	    	gapRateBefore = '<strong class="title_green">' +
	            gapRate + '%' +
	            '전년대비</strong>증가<div class="tag_icon green round"><i class="mdi-ico">trending_up</i></div>';
	    } else if (gapRate < 0) {
	    	gapRateBefore = '<strong class="title_red">' +
	            gapRate + '%' +
	            '전년대비</strong>감소<div class="tag_icon red round"><i class="mdi-ico">trending_down</i></div>';
	    } else {
	    	gapRateBefore = '전년대비<strong class="title_green">' +
	            gapRate + '%';
	    }
		
	    document.querySelector(targetElement).innerHTML = gapRateBefore;
	}

	// 연도별, 분기별, 월별 클릭 함수 
	$(document).ready(function() {
		var selectToggle = document.querySelector('.select_toggle204');
	    var selectOptions = document.querySelector('.select_options204');

	    $('#widget204Element').on('click', '.select_toggle204', function() {
	    	selectOptions = document.querySelector('.select_options204');
	        if (selectOptions.style.visibility == 'hidden') {
	            selectOptions.style.visibility = 'visible';
	        } else {
	            selectOptions.style.visibility = 'hidden';
	        }
	    });

		$('#widget204Element').on('click', '.option', function() {
			var leaveValue = $(this).attr('value');
			switch (leaveValue) {
			case 'year':
				$('#currentLeaveOption').text("연도별");
				leaveOption = 'year';
				setDataWidgetWide204(leaveOption);
				$('#leaveChart').empty();
				leaveChartWithData(leaveOption);
				break;
			case 'quarter':
		        $('#currentLeaveOption').text("분기별");
		        leaveOption = 'quarter';
		        setDataWidgetWide204(leaveOption);
		        $('#leaveChart').empty();
		        leaveChartWithData(leaveOption);
		        break;
			case 'month':
		        $('#currentLeaveOption').text("월별");
		        leaveOption = 'month';
		        setDataWidgetWide204(leaveOption);
		        $('#leaveChart').empty();
		        leaveChartWithData(leaveOption);
		        break;
		    }

		    selectOptions.style.visibility = 'hidden';
		});
	});
</script>
<div class="widget" id="widget204Element"></div>

<script>
	$(document).ready(function () {
		leaveChartWithData();
	});

	// apexchart 퇴사자 차트 데이터 
	function leaveChartWithData(chartStand) {
		if (typeof chartStand == "undefined" || chartStand == null || chartStand == ""){
			leaveOption = 'year';
			chartStand = 'year';
		}

		if (widget204.size == 'wide'){
			var options = {
				  series: [{
					name: '퇴사자',
				    data: (chartStand == 'year')
					  ? [yearOut[3], yearOut[2], yearOut[1], yearOut[0]]
					  : (chartStand == 'month')
					  ? [monthLeaveOut[0], monthLeaveOut[1], monthLeaveOut[2], monthLeaveOut[3], monthLeaveOut[4], monthLeaveOut[5], monthLeaveOut[6], monthLeaveOut[7], monthLeaveOut[8], monthLeaveOut[9], monthLeaveOut[10], monthLeaveOut[11], monthLeaveOut[12]]
					  : (chartStand == 'quarter')
					  ? [monthLeaveOut[0] + monthLeaveOut[1] + monthLeaveOut[2], monthLeaveOut[3] + monthLeaveOut[4] + monthLeaveOut[5], monthLeaveOut[6] + monthLeaveOut[7] + monthLeaveOut[8], monthLeaveOut[9] + monthLeaveOut[10] + monthLeaveOut[11]]
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
					categories: (chartStand == 'year')
					  ? [year[3], year[2], year[1], year[0]]
					  : (chartStand == 'month')
					  ? ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월']
					  : (chartStand == 'quarter')
					  ? ['1분기', '2분기', '3분기', '4분기']
					  : []
				  },
				  yaxis: {
					  show: false,
					    tickAmount: 4,
			  },
		};
		
		var chart = new ApexCharts(document.querySelector("#leaveChart"), options);
			chart.render();
		}	
	};
</script>