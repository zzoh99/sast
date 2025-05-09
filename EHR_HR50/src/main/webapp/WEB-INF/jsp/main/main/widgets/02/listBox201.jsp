<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
	/*
	 * 입/퇴사 추이 
	 */

	var widget201 = {
		size: null
	};

	// 차트데이터 담을 변수
	var now = new Date();
	var monthIn = [];
	var monthOut = [];
	var yearIn = [];
	var yearOut = [];
	var year = [];
	var nowEntryExit = '';
	var entryExitOption = '';

	/*
	 * 파라미터에 따른 메서드 선택 
	 * size : 사이즈 (값 "wide" -> wide위젯 메서드 호출, "normal" -> 한칸 위젯 메서드 호출)
	 */
	function init_listBox201(size){
		widget201.size = size;
		
		if (size == "normal"){
			createWidgetMini201();
			setDataWidgetMini201();
		} else if (size == ("wide")){
			createWidgetWide201();
			setDataWidgetWide201();
		}
	}

	// 위젯 mini html 코드 생성 
	function createWidgetMini201(){	
		if (typeof nowEntryExit == "undefined" || nowEntryExit == null || nowEntryExit == ""){
			nowEntryExit = '입사자'
		}
		
		var html =
		    '<div class="widget_header">' +
		    '  <div class="widget_title">입/퇴사 추이</div>' +
		    '</div>' +
		    '<div class="widget_body widget-common attend-status widget-more">' +
		    '  <div class="bookmarks_title">' +
		    '    <a href="#" class="arrowLeft"><i class="mdi-ico">keyboard_arrow_left</i></a>' +
		    '    <span>' + nowEntryExit +'</span>' +
		    '    <a href="#" class="arrowRight"><i class="mdi-ico">keyboard_arrow_right</i></a>' +
		    '  </div>' +
		    '  <div class="container_info">' +
		    '    <span class="info_label" id="thisYear"></span>' +
		    '    <span class="info_title_num" id="rateEnterExitIn"></span>' +
		    '    <span class="info_title desc" id="gapRateEnterExitIn">전년대비</span>' +
		    '  </div>' +
		    '</div>';

		document.querySelector('#widget201Element').innerHTML = html;
	}

	// 위젯 mini 데이터 넣기  
	function setDataWidgetMini201() {

        ajaxCall2("${ctx}/getListBox201List.do"
            , ""
            , true
            , null
            , function(data) {
                if (data && data.data && data.data.yearlyEnterExitTrend) {

                    const yearlyEnterExitTrend = data.data.yearlyEnterExitTrend;

                    if (!nowEntryExit) {
                        nowEntryExit = '입사자'
                    }

                    $('#thisYear').text(now.getFullYear() + '년도 기준');

                    if (yearlyEnterExitTrend.data){
                        if (nowEntryExit == "입사자"){
                            setEntryExitCnt(yearlyEnterExitTrend.data[0].in, '#rateEnterExitIn');
                            compareEntryExitYear(yearlyEnterExitTrend.data[0].gapRateIn, '#gapRateEnterExitIn');
                        } else if (nowEntryExit == "퇴사자"){
                            setEntryExitCnt(yearlyEnterExitTrend.data[0].out, '#rateEnterExitIn');
                            compareEntryExitYear(yearlyEnterExitTrend.data[0].gapRateOut, '#gapRateEnterExitIn');
                        }
                    }
                }
            })

	}		

	// 위젯 wide html 코드 넣기
	function createWidgetWide201(){
		var html =
		    '<div class="widget_header">' +
		    '  <div class="widget_title">입/퇴사 추이</div>' +
		    '</div>' +
		    '<div class="widget_body attendance_contents annual-status salary-average">' +
		    '  <div class="container_box">' +
		    '    <div class="container_left">' +
		    '      <div class="container_info inOut-wrap">' +
		    '        <div class="info_title" id="thisYear"></div>' +
		    '        <div class="inner-wrap">' +
		    '          <div class="in">' +
		    '            <span class="info_label">입사자</span>' +
		    '            <span class="info_title_num" id="rateEnterExitWideIn"></span>' +
		    '            <div class="info_title desc">전월대비</div>' +
		    '            <div class="info_title desc" id="gapRateEnterExitInWideIn"></div>' +
		    '          </div>' +
		    '          <div class="out">' +
		    '            <span class="info_label">퇴사자</span>' +
		    '            <span class="info_title_num" id="rateEnterExitWideOut"></span>' +
		    '            <div class="info_title desc">전월대비</div>' +
		    '            <div class="info_title desc" id="gapRateEnterExitInWideOut"></div>' +
		    '          </div>' +
		    '        </div>' +
		    '      </div>' +
		    '    </div>' +
		    '    <div class="container_right">' +
		    '      <div class="bookmarks_title select-outer">' +
		    '        <div class="custom_select no_style">' +
		    '          <button class="select_toggle select_toggle201">' +
		    '            <span id="currentOption">연도별</span><i class="mdi-ico">arrow_drop_down</i>' +
		    '          </button>' +
		    '          <div class="select_options numbers select_options201" style="visibility: hidden;">' +
		    '            <div class="option" value="year">연도별</div>' +
		    '            <div class="option" value="quarter">분기별</div>' +
		    '            <div class="option" value="month">월별</div>' +
		    '          </div>' +
		    '        </div>' +
		    '      </div>' +
		    '      <div class="chart-wrap">' +
		    '        <div id="entryExitChart"></div>' +
		    '      </div>' +
		    '    </div>' +
		    '  </div>' +
		    '</div>';

		document.querySelector('#widget201Element').innerHTML = html;
	}	

	function setDataWidgetWide201() {

        ajaxCall2("${ctx}/getListBox201List.do"
            , ""
            , true
            , null
            , function(data) {
                if (data && data.data && data.data.yearlyEnterExitTrend) {

                    const yearlyEnterExitTrend = data.data.yearlyEnterExitTrend;

                    if (yearlyEnterExitTrend.data) {
                        $('#thisYear').text(now.getFullYear() + '년도 기준');
                        setEntryExitCnt(yearlyEnterExitTrend.data[0].in, '#rateEnterExitWideIn');
                        setEntryExitCnt(yearlyEnterExitTrend.data[0].out, '#rateEnterExitWideOut');
                        compareEntryExitYear(yearlyEnterExitTrend.data[0].gapRateIn, '#gapRateEnterExitInWideIn');
                        compareEntryExitYear(yearlyEnterExitTrend.data[0].gapRateOut, '#gapRateEnterExitInWideOut');

                        if (typeof entryExitOption == "undefined" || entryExitOption == null || entryExitOption == "") {
                            entryExitOption = 'year'
                        }

                        // 년도별 데이터
                        if (entryExitOption == 'year') {
                            for (var i = 0; i < 4; i++) {
                                year.push(now.getFullYear() - i);
                                yearIn.push(yearlyEnterExitTrend.data[0]['inCnt' + (i + 1)]);
                                yearOut.push(yearlyEnterExitTrend.data[0]['outCnt' + (i + 1)]);
                            }
                        }

                        // 월별 데이터 + 분기별 데이터
                        if (entryExitOption == 'year' || entryExitOption == 'month') {
                            for (var i = 0; i < 12; i++) {
                                var dataIn = yearlyEnterExitTrend.monthlyData[0][(i + 1).toString()];
                                monthIn.push(dataIn);
                                var dataOut = yearlyEnterExitTrend.monthlyData[0][(i + 1).toString() + '_'];
                                monthOut.push(dataOut);
                            }
                        }

                        entryExitChartWithData();
                    }
                }
            })
	}
	
	// 인원수, html 코드 넣기
	function setEntryExitCnt(cnt, targetElement){
		var Html = cnt + '<span class="info_title unit">명</span>';
		document.querySelector(targetElement).innerHTML = Html;
	}

	/*
	 * TODO : 데이터가 0인 경우 필요
	 * 전년대비 값 비교 후 데이터 넣기
	 * gapRate: 전년대비 비율(플러스: title_green, 마이너스: title_red)
	 * targetElement: 대상 id 
	 */
	function compareEntryExitYear(gapRate, targetElement) {
	    var gapRateBefore = '';

	    if (gapRate > 0) {
	    	gapRateBefore = 
   				'전년대비<strong class="title_green">' + gapRate + '%' +
	            '</strong>증가<div class="tag_icon green round"><i class="mdi-ico">trending_up</i></div>';
	    } else if (gapRate < 0) {
	    	gapRateBefore = 
		    	'전년대비<strong class="title_red">' + gapRate + '%' +
	            '</strong>감소<div class="tag_icon red round"><i class="mdi-ico">trending_down</i></div>';
	    } else {
	    	gapRateBefore = '전년대비<strong class="title_green">' + gapRate + '%';
	    }
		
		document.querySelector(targetElement).innerHTML = gapRateBefore;
	}

	$(document).ready(function() {
		var selectToggle = document.querySelector('.select_toggle201');
		var selectOptions = document.querySelector('.select_options201');

		 $('#widget201Element').on('click', '.select_toggle201', function() {
	         var selectOptions = document.querySelector('.select_options201');
	         if (selectOptions.style.visibility == 'hidden') {
	            selectOptions.style.visibility = 'visible';
	         } else {
	            selectOptions.style.visibility = 'hidden';
	         }
	      });

		$('#widget201Element').on('click', '.option', function() {
			var periodValue = $(this).attr('value');

			switch (periodValue) {
			case 'year':
				$('#currentOption').text("연도별");
				entryExitOption = 'year';
				createWidgetWide201();
				setDataWidgetWide201();
				// entryExitChartWithData();
				break;
			case 'quarter':
		        $('#currentOption').text("분기별");
		        entryExitOption = 'quarter';
		        createWidgetWide201();
		        setDataWidgetWide201();
		        // entryExitChartWithData();
		        break;
			case 'month':
		        $('#currentOption').text("월별");
		        entryExitOption = 'month';
		        createWidgetWide201();
		        setDataWidgetWide201();
		        // entryExitChartWithData();
		        break;
		    }

		    selectOptions.style.visibility = 'hidden';
		  });

		$('#widget201Element').on('click', '.arrowRight', function() {
			if (nowEntryExit == '입사자') {
				nowEntryExit = '퇴사자'
			} else {
				nowEntryExit = '입사자'
			}

			createWidgetMini201();
			setDataWidgetMini201();
		});

		$('#widget201Element').on('click', '.arrowLeft', function() {
			if (nowEntryExit == '입사자') {
				nowEntryExit = '퇴사자'
			} else {
				nowEntryExit = '입사자'
			}

			createWidgetMini201();
			setDataWidgetMini201();
		});
	});
</script>
<div class="widget" id="widget201Element"></div>

<script>
	// $(document).ready(function () {
	// 	entryExitChartWithData();
	// });
	
	function entryExitChartWithData() {
		 if (typeof entryExitOption == "undefined" || entryExitOption == null || entryExitOption == ""){
		 	entryExitOption = 'year'
		 }
		 
		 if (widget201.size == 'wide'){
		 	var options = {
		 		  series: [{
		 			name: '입사자',
		 		    data: (entryExitOption == 'year')
		 			  ? [yearIn[3], yearIn[2], yearIn[1], yearIn[0]]
		 			  : (entryExitOption == 'month')
		 			  ? [monthIn[0], monthIn[1], monthIn[2], monthIn[3], monthIn[4], monthIn[5], monthIn[6], monthIn[7], monthIn[8], monthIn[9], monthIn[10], monthIn[11]]
		 			  : (entryExitOption == 'quarter')
		 			  ? [monthIn[0] + monthIn[1] + monthIn[2], monthIn[3] + monthIn[4] + monthIn[5], monthIn[6] + monthIn[7] + monthIn[8], monthIn[9] + monthIn[10] + monthIn[11]]
		 			  : [],
		 		    color: '#2570f9'
		 		  }, {
		 			name: '퇴사자',
		 		    data: (entryExitOption == 'year')
		 			  ? [yearOut[3], yearOut[2], yearOut[1], yearOut[0]]
		 			  : (entryExitOption == 'month')
		 			  ? [monthOut[0], monthOut[1], monthOut[2], monthOut[3], monthOut[4], monthOut[5], monthOut[6], monthOut[7], monthOut[8], monthOut[9], monthOut[10], monthOut[11]]
		 			  : (entryExitOption == 'quarter')
		 			  ? ['1분기', '2분기', '3분기', '4분기']
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
		 			categories: (entryExitOption == 'year')
		 			  ? [year[3], year[2], year[1], year[0]]
		 			  : (entryExitOption == 'month')
		 			  ? ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월']
		 			  : (entryExitOption == 'quarter')
		 			  ? ['1분기', '2분기', '3분기', '4분기']
		 			  : []
		 		  },
		 		  yaxis: {
		 			  show: false,
		 			    tickAmount: 4,
		 	  },
		 };
		 
		 var chart = new ApexCharts(document.querySelector("#entryExitChart"), options);
		 	chart.render();
		}	
	};
</script>