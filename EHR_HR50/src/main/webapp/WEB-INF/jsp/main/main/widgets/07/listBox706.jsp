<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
	/*
	 * 전사 월간 급여
	 */
	
	// 위젯 사이즈별 로드
	function init_listBox706(size) {
		if (size == "normal"){
			widget706.makeMini();
			widget706.setDataMini();
		} else if (size == ("wide")){
			widget706.makeWide();
			widget706.setDataWide();
			widget706.drawChart();
		}
	}

	var widget706 = {
		size: null,

		elemId: 'widget706',  // 위젯 엘리면트 id
		$widget: null,
 
		monthlyPayData: null,  // 총급여 관련 데이터

		// 작은 위젯 마크업 생성
		makeMini: function(){
			var html =
				  '<div class="widget_header toggle-wrap">' +
				  '  <div class="widget_title">전사 월간 급여</div>' +
				  '</div>' +
				  '<div class="widget_body attendance_contents annual-status salary-average">' +
				  '  <div class="container_box">' +
				  '    <div class="container_left">' +
				  '      <div class="container_info">' +
				  '        <span class="info_title_num" id="totalSalary706"></span>' +
				  '        <span class="info_title desc" id="gapRate706"></span>' +
				  '      </div>' +
				  '      <div class="info_box" id="maxRate706">' +
				  '      </div>' +
				  '      <div class="info_box" id="minRate706">' +
				  '      </div>' +
				  '    </div>' +
				  '  </div>' +
				  '</div>';

			document.getElementById(this.elemId).innerHTML = html;
		},

		// 작은 위젯 데이터 표시
		setDataMini: function() {

            const draw = (monthlyPayData) => {
                var gapRateHtml = widget706.compareGapRate(monthlyPayData.gapRate);
                var maxGapRateHtml = widget706.compareMaxMinGapRate(monthlyPayData.maxGapRate);
                var minGapRateHtml = widget706.compareMaxMinGapRate(monthlyPayData.minGapRate);

                document.getElementById('totalSalary706').innerHTML =
                    `\${monthlyPayData.year4}<span class="info_title unit">백만원</span>`;
                document.getElementById('gapRate706').innerHTML = gapRateHtml;
                document.getElementById('maxRate706').innerHTML =
                    `<span class="title_kor">최대</span>
                     <span class="box_bnum">\${monthlyPayData.maxRate}</span>
                     <span class="title_kor">백만원</span>\${maxGapRateHtml}`;
                document.getElementById('minRate706').innerHTML =
                    `<span class="title_kor">최대</span>
                     <span class="box_bnum">\${monthlyPayData.minRate}</span>
                     <span class="title_kor">백만원</span>\${minGapRateHtml}`;
            }

			if(this.monthlyPayData == null) {
                ajaxCall2("${ctx}/getListBox706List.do"
                    , ""
                    , true
                    , null
                    , function(data) {
                        if (data && data.data && data.data.monthlyPayData) {

                            widget706.monthlyPayData = data.data.monthlyPayData;

                            const monthlyPayData = widget706.monthlyPayData;
                            draw(monthlyPayData);
                        }
                    })
			} else {
                const monthlyPayData = this.monthlyPayData;
                draw(monthlyPayData);
            }
		},
		
		// 와이드 위젯 마크업 생성
		makeWide: function(){
			var html =
				  '<div class="widget_header toggle-wrap">' +
				  '  <div class="widget_title">전사 월간 급여</div>' +
				  '</div>' +
				  '<div class="widget_body attendance_contents annual-status salary-average">' +
				  '  <div class="container_box">' +
				  '    <div class="container_left">' +
				  '      <div class="container_info">' +
				  '        <span class="info_title_num" id="totalSalary706"></span>' +
				  '        <span class="info_title desc" id="gapRate706"></span>' +
				  '      </div>' +
				  '      <div class="info_box" id="maxRate706">' +
				  '      </div>' +
				  '      <div class="info_box" id="minRate706">' +
				  '      </div>' +
				  '    </div>' +
				  '    <div class="container_right">' +
				  '      <div class="bookmarks_title select-outer">' +
				  '        <div class="custom_select no_style">' +
				  '          <button class="select_toggle">' +
				  '            <span id="selectedValue706">월별</span><i class="mdi-ico">arrow_drop_down</i>' +
				  '          </button>' +
				  '          <div class="select_options numbers" style="visibility: hidden;">' +
				  '            <div class="option" value="year">연도별</div>' +
				  '            <div class="option" value="month">월별</div>' +
				  '            <div class="option" value="quarter">분기별</div>' +
				  '          </div>' +
				  '        </div>' +
				  '        <div class="sub-title" id="today706"></div>' +
				  '      </div>' +
				  '      <div class="chart-wrap">' +
				  '        <div id="annualChart706"></div>' +
				  '      </div>' +
				  '    </div>' +
				  '  </div>' +
				  '</div>';

			document.getElementById(this.elemId).innerHTML = html;
		},

		// 와이드 위젯 데이터 표시
		setDataWide: function() {

            const draw = (monthlyPayData) => {
                const gapRateHtml = widget706.compareGapRate(monthlyPayData.gapRate);
                const maxGapRateHtml = widget706.compareMaxMinGapRate(monthlyPayData.maxGapRate);
                const minGapRateHtml = widget706.compareMaxMinGapRate(monthlyPayData.minGapRate);
                const now = new Date();
                const year = now.getFullYear();
                const month = (now.getMonth() + 1);
                const day = now.getDate();

                document.getElementById('today706').textContent = `\${year}년 \${month}월 \${day}일`;
                document.getElementById('totalSalary706').innerHTML =
                    `\${monthlyPayData.year4}<span class="info_title unit">백만원</span>`;
                document.getElementById('gapRate706').innerHTML = gapRateHtml;
                document.getElementById('maxRate706').innerHTML =
                    `<span class="title_kor">최대</span>
                     <span class="box_bnum">\${monthlyPayData.maxRate}</span>
                     <span class="title_kor">백만원</span>\${maxGapRateHtml}`;
                document.getElementById('minRate706').innerHTML =
                    `<span class="title_kor">최대</span>
                     <span class="box_bnum">\${monthlyPayData.minRate}</span>
                     <span class="title_kor">백만원</span>\${minGapRateHtml}`;
            }

			if(this.monthlyPayData == null) {
                ajaxCall2("${ctx}/getListBox706List.do"
                    , ""
                    , true
                    , null
                    , function(data) {
                        if (data && data.data && data.data.monthlyPayData) {

                            widget706.monthlyPayData = data.data.monthlyPayData;

                            const monthlyPayData = widget706.monthlyPayData;
                            draw(monthlyPayData);
                        }
                    })
			} else {
                const monthlyPayData = this.monthlyPayData;
                draw(monthlyPayData);
            }
		},

		/**
		 * 필요 내부 함수들 선언
		 */
		compareGapRate: function(gapRate){
			var gapRateHtml = '';
			var increase = gapRate.match(/[ㄱ-ㅎ|가-힣]+/g).join("");
			var increaseNum = gapRate.match(/\d+/g).join("");
			
			if (increase == "증가"){
				gapRateHtml = '전년대비<strong class="title_green">' + increaseNum + '%</strong>증가<div class="tag_icon green round"><i class="mdi-ico">trending_up</i></div>';
			} else if (increase == "감소"){
				gapRateHtml = '전년대비<strong class="title_red">' + increaseNum + '%</strong>감소<div class="tag_icon red round"><i class="mdi-ico">trending_down</i></div>';
			} else {
				gapRateHtml = '전년대비<strong class="title_green">' + increaseNum + '%</strong>';
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
			$widget.on('click', '.select_options > .option', function(){
				var optionValue = $(this).attr('value');
				var optionText = $(this).text();
				
				document.getElementById('selectedValue706').textContent = optionText;
				$('#annualChart706').empty();
				widget706.drawChart(optionValue);

				$('.select_options').css('visibility', 'hidden');
			});

			$widget.on('click', '.select_toggle', function (e) {
			    if ($(this).closest(".custom_select").hasClass("disabled")) return;
			    if ($(this).closest(".custom_select").hasClass("readonly")) return;

			    e.stopPropagation();

			    $(".select_options").not($(this).next()).css("visibility", "hidden");
			    $(".select_toggle i")
			      .not($(this).find("i"))
			      .each(function () {
			        if ($(this).text() === "keyboard_arrow_up") {
			          $(this).text("keyboard_arrow_down");
			        } else if ($(this).text() === "arrow_drop_up") {
			          $(this).text("arrow_drop_down");
			        }
			      });

			    let optionsVisibility = $(this).next(".select_options").css("visibility");
			    $(this)
			      .next(".select_options")
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
			    }
			  });
		},

		// 차트 그리기
		drawChart: function(option){
			const yearData = [];
			const monthData = [];
			const quarterData = [];
			const year = [];
			const now = new Date();

			for (var i = 0; i < 4; i++){
				year.push(now.getFullYear()-i);
			}
			
		    if (typeof option == "undefined" || option == null || option == ""){
		    	option = "year";
			}
			
			this.monthlyPayData = ajaxCall('/getListBox706List.do', {option: option}, false).data.monthlyPayData;
			const monthlyPayData = this.monthlyPayData; 

			if (option == "year"){
				for (var i = 0; i < 4; i++){
					yearData.push(monthlyPayData['year' + (i+1)]);
				}
			} else if (option == "month"){
				for (var i = 0; i < 12; i++){
					monthData.push(monthlyPayData['mon'+(i+1)]);
				}
			} else if (option == "quarter"){
				for (var i = 0; i < 4; i++){
					quarterData.push(monthlyPayData['quarter'+(i+1)]);
				}
			} 

			var options = {
			 		  series: [{
			 			name: '총급여',
			 		    data: (option == 'year')
			 			  ? [yearData[0], yearData[1], yearData[2], yearData[3]]
			 			  : (option == 'month')
			 			  ? [monthData[0], monthData[1], monthData[2], monthData[3], monthData[4], monthData[5], monthData[6], monthData[7], monthData[8], monthData[9], monthData[10], monthData[11]]
			 			  : (option == 'quarter')
			 			  ? [quarterData[0], quarterData[1], quarterData[2], quarterData[3]]
			 			  : [],
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
			 			categories: (option == 'year')
			 			  ? [year[3], year[2], year[1], year[0]]
			 			  : (option == 'month')
			 			  ? ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월']
			 			  : (option == 'quarter')
			 			  ? ['1분기', '2분기', '3분기', '4분기']
			 			  : []
			 		  },
			 		  yaxis: {
			 			  show: false,
			 			    tickAmount: 4,
			 	  },
			};
			
			var chart = new ApexCharts(document.querySelector("#annualChart706"), options);
			chart.render();
		}
	};
</script>
<div class="widget" id="widget706"></div>

<script>
	// DOM 로드 후에 UI 설정
	$(document).ready(function () {
		widget706.$widget = $('#'+ widget706.elemId);

		widget706.setUI(); // UI생성
		widget706.setUIEvent(); // 이벤트 할당
	});
</script>