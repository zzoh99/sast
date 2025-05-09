<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
	/*
	 * 월간 사대보험 납부현황
	 */
	
	// 위젯 사이즈별 로드
	function init_listBox709(size) {
		if (size == "normal"){
			widget709.makeMini();
			widget709.setDataMini();
		} else if (size == ("wide")){
			widget709.makeWide();
			widget709.setDataWide();
			widget709.drawChart();
		}
	}

	var widget709 = {
		size: null,

		elemId: 'widget709',  // 위젯 엘리면트 id
		$widget: null,
 
		w709Data: null,  // 총급여 관련 데이터

		// 작은 위젯 마크업 생성
		makeMini: function(){
			var html =
				  '<div class="widget_header toggle-wrap">' +
				  '  <div class="widget_title">월간 사대보험 납부현황</div>' +
				  '</div>' +
				  '<div class="widget_body attendance_contents annual-status salary-average">' +
				  '  <div class="container_box">' +
				  '    <div class="container_left">' +
				  '      <div class="container_info">' +
				  '        <span class="info_title_num" id="total709"></span>' +
				  '        <span class="info_title desc" id="gapRate709"></span>' +
				  '      </div>' +
				  '      <div class="info_box" id="maxRate709">' +
				  '      </div>' +
				  '      <div class="info_box" id="minRate709">' +
				  '      </div>' +
				  '    </div>' +
				  '  </div>' +
				  '</div>';

			document.getElementById(this.elemId).innerHTML = html;
		},

		// 작은 위젯 데이터 표시
		setDataMini: function(){
			var gapRateHtml = this.compareGapRate("10 증가");

			document.getElementById('total709').innerHTML = '1,085/1,120';
			document.getElementById('gapRate709').innerHTML = gapRateHtml;
		},
		
		// 와이드 위젯 마크업 생성
		makeWide: function(){
			var html =
				  '<div class="widget_header">' +
				  '  <div class="widget_title">월간 사대보험 납부현황</div>' +
				  '</div>' +
				  '<div class="widget_body attendance_contents annual-status salary-average">' +
				  '  <div class="container_box">' +
				  '    <div class="container_left">' +
				  '      <div class="container_info">' +
				  '        <span class="info_title unit">총 신고인원</span>'+
				  '        <span class="info_title_num" id="total709"></span>' +
				  '        <span class="info_title desc" id="gapRate709"></span>' +
				  '      </div>' +
				  '    </div>' +
				  '    <div class="container_right">' +
	              '      <div class="bookmarks_title">' +
	              '        <div class="tab_wrap">' +
	              '          <div class="tab_menu active" value="pen">국민연금</div>' +
	              '          <div class="tab_menu" value="healthIns">건강보험</div>' +
	              '          <div class="tab_menu" value="empIns">고용보험</div>' +
	              '        </div>' +
	              '      </div>' +
				  '      <div class="chart-wrap">' +
				  '        <div id="annualChart709"></div>' +
				  '      </div>' +
				  '    </div>' +
				  '  </div>' +
				  '</div>';
					  
			document.getElementById(this.elemId).innerHTML = html;
		},

		// 와이드 위젯 데이터 표시
		setDataWide: function(){
			
			var gapRateHtml = this.compareGapRate("10 증가");

			document.getElementById('total709').innerHTML = '1,085/1,120';
		    document.getElementById('gapRate709').innerHTML = gapRateHtml;
		},

		/**
		 * 필요 내부 함수들 선언
		 */
		compareGapRate: function(gapRate){
			var gapRateHtml = '';
			var increase = gapRate.match(/[ㄱ-ㅎ|가-힣]+/g).join("");
			var increaseNum = gapRate.match(/\d+/g).join("");
			
			if (increase == "증가"){
				gapRateHtml = '작년 근속자 대비<strong class="title_green">' + increaseNum + '%</strong>증가<div class="tag_icon green round"><i class="mdi-ico">trending_up</i></div>';
			} else if (increase == "감소"){
				gapRateHtml = '작년 근속자 대비<strong class="title_red">' + increaseNum + '%</strong>감소<div class="tag_icon red round"><i class="mdi-ico">trending_down</i></div>';
			} else {
				gapRateHtml = '작년 근속자 대비<strong class="title_green">' + increaseNum + '%</strong>';
			}
			
			return gapRateHtml;
		},

		compareMaxMinGapRate: function(gapRate){
			var gapRateHtml = '';
			var increase = gapRate.match(/[ㄱ-ㅎ|가-힣]+/g).join("");
			var increaseNum = gapRate.match(/\d+/g).join("");
			
			if (increase == "증가"){
				gapRateHtml = '<i class="mdi-ico time_plus">arrow_drop_up</i><span class="box_time time_plus">' + increaseNum + '%</span>';
			} else if (increase == "감소"){
				gapRateHtml ='<i class="mdi-ico time_minus">arrow_drop_down</i><span class="box_time time_minus">' + increaseNum + '%</span>';
			} else {
				gapRateHtml = increaseNum + '%';
			}

			return gapRateHtml;
		},

		// UI 설정
		setUI: function(){

		},

		// UI 이벤트 설정
		setUIEvent: function(){
			const $widget = this.$widget;

			// select(드롭다운) 관련
			$widget.on('click', '.tab_menu', function() {
				$('#annualChart709').empty();
			    var tabValue = $(this).attr('value');
			    widget709.drawChart(tabValue); 

			    $('#widget709 .tab_menu.active').removeClass('active');
			    $('#widget709 .tab_menu[value="' + tabValue + '"]').addClass('active');
			}); 
		},

		// 차트 그리기
		drawChart: function(option){
			const nameData = [];
			const valueData = [];
			
		    if (typeof option == "undefined" || option == null || option == ""){
		    	option = "pen";
			}
			
			this.w709Data = ajaxCall('/getListBox709List.do', {option: option}, false).data;
			const w709Data = this.w709Data; 

			for (var i = 0; i < w709Data.length; i++){
				var year = w709Data[i].ym.substr(0,4);
				var mon = w709Data[i].ym.substr(4,2);
				nameData.push(year + "." +  mon);
				valueData.push(w709Data[i].paidCnt);
			}

			var options = {
			 		  series: [{
			 		    data: valueData,
			 		    color: '#2570f9'
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
			 			categories: nameData
			 		  },
			 		  yaxis: {
			 			  show: false,
			 			    tickAmount: 4,
			 	  },
			};
			
			var chart = new ApexCharts(document.querySelector("#annualChart709"), options);
			chart.render();
		}
	};
</script>
<div class="widget" id="widget709"></div>

<script>
	// DOM 로드 후에 UI 설정
	$(document).ready(function () {
		widget709.$widget = $('#'+ widget709.elemId);

		widget709.setUI(); // UI생성
		widget709.setUIEvent(); // 이벤트 할당
	});
</script>