<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
	/*
	 * 항목별 퇴사 비율
	 */
	
	// 위젯 사이즈별 로드
	function init_listBox211(size) {
		if (size == "normal"){
			widget211.makeMini();
			widget211.setDataMini();
			widget211.drawChart();
		} else if (size == ("wide")){
			widget211.makeWide();
			widget211.setDataWide();
			widget211.drawChart();
		}
	}

	var widget211 = {
		size: null,

		elemId: 'widget211',  // 위젯 엘리면트 id
		$widget: null,

		leaveInfos: null,  // 퇴사 비율 관련 데이터

		// 내부 변수들
		infoTitles: ['근속연수', '직급별'],
	 	curInfoIdx: 0,
	 	curYear: null,
	 	curYearIdx: 0,

	 	// 작은 위젯 마크업 생성
	 	makeMini: function(){
	 		var html = 
		 		'<div class="widget_header">'
		 	  + '  <div class="widget_title">항목별 퇴사 비율</div>'
		 	  + '</div>'
		 	  + '<div class="widget_body widget-common">'
		 	  + '  <div class="bookmarks_title">'
		 	  + '    <a href="#" class="arrowLeft"><i class="mdi-ico">keyboard_arrow_left</i></a>'
	          + '    <span>근속연수</span>'
	          + '    <a href="#" class="arrowRight"><i class="mdi-ico">keyboard_arrow_right</i></a>'
	          + '  </div>'
	          + '  <div class="container_info">'
	          + '    <div class="custom_select no_style">'
	          + '      <button class="select_toggle">'
	          + '        <span class="selectedValue">2023년</span><i class="mdi-ico">arrow_drop_down</i>'
	          + '      </button>'
	          + '      <!-- 개발 시 참고: numbers 클래스 시 날짜 셀렉트에 쓰임 -->'
	          + '      <div class="select_options numbers select_options211" id="select211Year">'
//	 	      + '            <div class="option">2023년</div>' +
//	 	      + '            <div class="option">2022년</div>' +
//	 	      + '            <div class="option">2021년</div>' +
	          + '      </div>'
	          + '    </div>'
	          + '  </div>'
	          + '  <div class="container_box">'
		      + '    <div class="chart-wrap">'
		      + '      <div id="chart211"></div>'
		      + '    </div>'
	          + '  </div>'
		 	  + '</div>';

 			document.getElementById(this.elemId).innerHTML = html;
	 	},

	 	// 작은 위젯 데이터 표시
		setDataMini: function(){
			/**
			 {
			 	"year": "2023",
			 	"labels": ["1년 미만", "1년~3년", "3년~6년", "6년~10년", "10년 이상"],
			 	"leaveCnts": [12, 28, 27, 23, 10]
			 },
			 */
			if(this.leaveInfo == null) {
				this.leaveInfos = ajaxCall('/getListBox211List.do', '', false).data.leaveInfo.data;
				this.curYear = this.leaveInfos[0].year;
			}

		 	// 함수 내부에서 this 떼고 사용하기 위해 참조함
           	const curInfoIdx = this.curInfoIdx;
           	const curYearIdx = this.curYearIdx;
           	const leaveInfo = this.leaveInfo;

           	if(curInfoIdx == 0){ // 근속연수
// 				const curYearIdx = this.curYearIdx;
// 				this.drawChart();
           	}
           	else if(curInfoIdx == 1){ // 직급별

           	}
			 
	 	},

		// TODO: 와이드 위젯 마크업 생성
		makeWide: function(){
	 		var html = '';

 			document.getElementById(this.elemId).innerHTML = html;

		},

		// TODO: 와이드 위젯 데이터 표시
		setDataWide: function(){
			/**
			 {
			    "year": "2023",
			    "labels": ["1년 미만", "1년~3년", "3년~6년", "6년~10년", "10년 이상"],
			    "leaveCnts": [12, 28, 27, 23, 10]
			  },
			 */
			if(this.leaveInfos == null) {
				this.leaveInfos = ajaxCall('/getListBox211List.do', '', false).data.leaveInfo.data;
				this.curYear = this.leaveInfos[0].year;
			}
		},

		// UI 설정
		setUI: function(){
			// 드롭다운 관련
			const selectOptions = this.leaveInfos.reduce((a, c) => {
				a += '<div class="option" value="'+ c.year +'">'+ c.year +'년</div>\n';
				return a;
			}, '');

			$('#select211Year').html(selectOptions);
			$('#select211Year .selectedValue').text(this.curYear +'년');
		},

		// UI 이벤트 설저
		setUIEvent: function(){
			const _this = this; // scope 저장
			const $widget = this.$widget;

			// wide 일때 탭 클릭 시
			$widget.on("click", '.tab_menu', function () {
				$(this).siblings().removeClass("active");
				$(this).addClass("active");

				_this.curInfoIdx = $(this).index(); // 선택된 탭의 순서 저장

				_this.setDataWide();
				_this.drawChart(); // 차트 그리기
		  	});

			// 좌우 화살표 관련
			$widget.on('click', '.arrowLeft, .arrowRight', function(){
				const className = $(this).attr('class');
				console.log('$widget.on click className', className);

				if(className == 'arrowLeft'){
					_this.curInfoIdx--;
					if(_this.curInfoIdx < 0){
						_this.curInfoIdx = _this.infoTitles.length - 1;
					} 
				}
				else if(className == 'arrowRight'){
					_this.curInfoIdx++;
					if(_this.curInfoIdx > _this.infoTitles.length - 1){
						_this.curInfoIdx = 0;
					}
				}
								
				$(this).siblings('span').text(_this.infoTitles[_this.curInfoIdx]);

				_this.drawChart();
			});
			
			// select(드롭다운) 관련
			$widget.on('click', '.select_options211 > .option', function(){
				var optionValue = $(this).attr('value');
				var optionText = $(this).text();
				console.log('optionValue', optionValue);
				
				_this.curYear = optionValue;
				_this.curYearIdx = $(this).index(); // 선택된 옵션의 순서 저장
				
				$(this).parent().parent().find('.selectedValue').text(optionText);
				$(this).parent().css("visibility", "hidden");

				_this.drawChart();
			});
			
			$widget.on('click', '.select_toggle', function (e) {
			    if ($(this).closest(".custom_select").hasClass("disabled")) return;
			    if ($(this).closest(".custom_select").hasClass("readonly")) return;

			    e.stopPropagation();

			    $(".select_options211").not($(this).next()).css("visibility", "hidden");
			    $(".select_toggle i")
			      .not($(this).find("i"))
			      .each(function () {
			        if ($(this).text() === "keyboard_arrow_up") {
			          $(this).text("keyboard_arrow_down");
			        } else if ($(this).text() === "arrow_drop_up") {
			          $(this).text("arrow_drop_down");
			        }
			      });

			    let optionsVisibility = $(this).next(".select_options211").css("visibility");
			    $(this)
			      .next(".select_options211")
			      .css(
			        "visibility",
			        optionsVisibility === "visible" ? "hidden" : "visible"
			      );

			    let icon = $(this).find("i");
			    switch (icon.text()) {
			      case "keyboard_arrow_down":
			        icon.text("keyboard_arrow_up");
			        break;
			      case "keyboard_arrow_up":
			        icon.text("keyboard_arrow_down");
			        break;
			      case "arrow_drop_down":
			        icon.text("arrow_drop_up");
			        break;
			      case "arrow_drop_up":
			        icon.text("arrow_drop_down");
			        break;
			    }
	  		});

			
		},

		/**
		 * 필요 내부 함수들 선언
		 */
		// 차트 그리기
		drawChart: function(){
			const curInfoIdx = this.curInfoIdx;
			const curYearIdx = this.curYearIdx;
			console.log('drawChart curInfoIdx, curYearIdx', curInfoIdx, curYearIdx);
			const leaveInfos = this.leaveInfos;

			let leaveCnts = [], labels = [];

			if(curInfoIdx == 0){ // 근속연수
				const leaveInfo = leaveInfos[curYearIdx];
				leaveCnts = leaveInfo.leaveCnts;
				console.log('leaveCnts', leaveCnts);
				labels = leaveInfo.labels;
			}
			else if(curInfoIdx == 1){ // TODO: 직급별
				return;
          	}
          	
			var options = {
					series: leaveCnts,
					labels: labels,
					
			    	chart: {
			    		width: 250,
			    		type: 'donut',
			    	},
			        dataLabels: {
			        	enabled: false
			        },
			        responsive: [{
			        	breakpoint: 480,
			          	options: {
			            chart: {
			            	width: 200
			            },
			            legend: {
			            	show: false
			            }
			       	}
				}],
			    legend: {
			    	position: 'right',
			        offsetY: -20,
			        offsetX: -15,
			        height: 200,
			    }
			};

			document.getElementById("chart211").innerHTML = '';
	        var chart = new ApexCharts(document.getElementById("chart211"), options);
	        chart.render();
			      
			      
			function appendData() {
				var arr = chart.w.globals.series.slice()
			    arr.push(Math.floor(secureRandom() * (100 - 1 + 1)) + 1)
			    return arr;
			}
			      
			function removeData() {
				var arr = chart.w.globals.series.slice()
			    arr.pop()
			    return arr;
			}
			      
			function randomize() {
				return chart.w.globals.series.map(function() {
			    	return Math.floor(secureRandom() * (100 - 1 + 1)) + 1
			    })
			}
			      
			function reset() {
				return options.series
			}
			      
// 			document.querySelector("#randomize").addEventListener("click", function() {
// 				chart.updateSeries(randomize())
// 			})
			      
// 			document.querySelector("#add").addEventListener("click", function() {
// 				chart.updateSeries(appendData())
// 			})
			      
// 			document.querySelector("#remove").addEventListener("click", function() {
// 				chart.updateSeries(removeData())
// 			})
			      
// 			document.querySelector("#reset").addEventListener("click", function() {
// 				chart.updateSeries(reset())
// 			})    
			    

		}
		/** */
	}

	
</script>
<div class="widget" id="widget211"></div>

<script>
	// DOM 로드 후에 UI 설정
	$(document).ready(function () {
		widget211.$widget = $('#'+ widget211.elemId);

		widget211.setUI(); // UI생성
		widget211.setUIEvent(); // 이벤트 할당
	});
</script>