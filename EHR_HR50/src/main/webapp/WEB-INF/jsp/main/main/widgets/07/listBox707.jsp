<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
	/*
	 * 전사 월간 급여
	 */
	
	// 위젯 사이즈별 로드
	function init_listBox707(size) {
		if (size == "normal"){
			widget707.makeMini();
			widget707.setDataMini();
		} else if (size == ("wide")){
			widget707.makeWide();
			widget707.setDataWide();
			widget707.drawChart();
		}
	}

	var widget707 = {
		size: null,

		elemId: 'widget707',  // 위젯 엘리면트 id
		$widget: null,
 
		averageSalary: null,  // 총급여 관련 데이터

		// 작은 위젯 마크업 생성
		makeMini: function(){
			var html =
				  '<div class="widget_header toggle-wrap">' +
				  '  <div class="widget_title">전사 연봉 평균</div>' +
				  '</div>' +
				  '<div class="widget_body attendance_contents annual-status salary-average">' +
				  '  <div class="container_box">' +
				  '    <div class="container_left">' +
				  '      <div class="container_info">' +
				  '        <span class="info_title_num" id="totalAverage707"></span>' +
				  '        <span class="info_title desc" id="gapRate707"></span>' +
				  '      </div>' +
				  '      <div class="info_box" id="maxRate707">' +
				  '      </div>' +
				  '      <div class="info_box" id="minRate707">' +
				  '      </div>' +
				  '    </div>' +
				  '  </div>' +
				  '</div>';

			document.getElementById(this.elemId).innerHTML = html;
		},

		// 작은 위젯 데이터 표시
		setDataMini: function() {

            const draw = (averageSalary) => {

                const gapRateHtml = widget707.compareGapRate(averageSalary.gapRate);
                const maxGapRateHtml = widget707.compareMaxMinGapRate(averageSalary.maxGapRate);
                const minGapRateHtml = widget707.compareMaxMinGapRate(averageSalary.minGapRate);

                document.getElementById('totalAverage707').innerHTML =
                    `\${averageSalary.average}<span class="info_title unit">천만원/1인</span>`;
                document.getElementById('gapRate707').innerHTML = gapRateHtml;
                document.getElementById('maxRate707').innerHTML =
                    `<span class="title_kor">최대</span>
                     <span class="box_bnum">\${averageSalary.maxRate}</span>
                     <span class="title_kor">천만원</span>\${maxGapRateHtml}`;
                document.getElementById('minRate707').innerHTML =
                    `<span class="title_kor">최대</span>
                     <span class="box_bnum">\${averageSalary.minRate}</span>
                     <span class="title_kor">천만원</span>\${minGapRateHtml}`;
            }

			if(this.averageSalary == null) {

                ajaxCall2("${ctx}/getListBox707List.do"
                    , ""
                    , true
                    , null
                    , function(data) {
                        if (data && data.data && data.data.averageSalary) {

                            widget707.averageSalary = data.data.averageSalary;
                            const averageSalary = widget707.averageSalary;
                            draw(averageSalary);
                        }
                    })
			} else {
                const averageSalary = this.averageSalary;
                draw(averageSalary);
            }
		},
		
		// 와이드 위젯 마크업 생성
		makeWide: function(){
			var html =
				  '<div class="widget_header">' +
				  '  <div class="widget_title">전사 연봉 평균</div>' +
				  '</div>' +
				  '<div class="widget_body attendance_contents annual-status salary-average">' +
				  '  <div class="container_box">' +
				  '    <div class="container_left">' +
				  '      <div class="container_info">' +
				  '        <span class="info_title_num" id="totalAverage707"></span>' +
				  '        <span class="info_title desc" id="gapRate707"></span>' +
				  '      </div>' +
				  '      <div class="info_box" id="maxRate707">' +
				  '      </div>' +
				  '      <div class="info_box" id="minRate707">' +
				  '      </div>' +
				  '    </div>' +
				  '    <div class="container_right">' +
				  '      <div class="bookmarks_title">' +
				  '        <div class="tab_wrap">' +
				  '          <div class="tab_menu active" value="position">직급별</div>' +
				  '          <div class="tab_menu" value="gender">성별</div>' +
				  '          <div class="tab_menu" value="tenure">근속연수</div>' +
				  '        </div>' +
				  '      </div>' +
				  '      <div class="chart-wrap">' +
				  '        <div id="annualChart707"></div>' +
				  '      </div>' +
				  '    </div>' +
				  '  </div>' +
				  '</div>';
					  
			document.getElementById(this.elemId).innerHTML = html;
		},

		// 와이드 위젯 데이터 표시
		setDataWide: function() {

            const draw = (averageSalary) => {

                var gapRateHtml = widget707.compareGapRate(averageSalary.gapRate);
                var maxGapRateHtml = widget707.compareMaxMinGapRate(averageSalary.maxGapRate);
                var minGapRateHtml = widget707.compareMaxMinGapRate(averageSalary.minGapRate);

                document.getElementById('totalAverage707').innerHTML =
                    `\${averageSalary.average}<span class="info_title unit">천만원/1인</span>`;
                document.getElementById('gapRate707').innerHTML = gapRateHtml;
                document.getElementById('maxRate707').innerHTML =
                    `<span class="title_kor">최대</span>
                     <span class="box_bnum">\${averageSalary.maxRate}</span>
                     <span class="title_kor">천만원</span>\${maxGapRateHtml}`;
                document.getElementById('minRate707').innerHTML =
                    `<span class="title_kor">최대</span>
                     <span class="box_bnum">\${averageSalary.minRate}</span>
                     <span class="title_kor">천만원</span>\${minGapRateHtml}`;
            }

			if(this.averageSalary == null) {

                ajaxCall2("${ctx}/getListBox707List.do"
                    , ""
                    , true
                    , null
                    , function(data) {
                        if (data && data.data && data.data.averageSalary) {

                            widget707.averageSalary = data.data.averageSalary;
                            const averageSalary = widget707.averageSalary;
                            draw(averageSalary);
                        }
                    })
			} else {
                const averageSalary = this.averageSalary;
                draw(averageSalary);
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
			$widget.on('click', '.tab_menu', function() {
				$('#annualChart707').empty();
			    var tabValue = $(this).attr('value');
			    widget707.drawChart(tabValue); 

			    $('#widget707 .tab_menu.active').removeClass('active');
			    $('#widget707 .tab_menu[value="' + tabValue + '"]').addClass('active');
			}); 
		},

		// 차트 그리기
		drawChart: function(option) {
			
		    if (!option) {
		    	option = "position";
			}

            ajaxCall2("${ctx}/getListBox707List.do"
                , {option: option}
                , true
                , null
                , function(data) {
                    if (data && data.data && data.data.averageData) {

                        widget707.averageSalary = data.data.averageData;
                        const averageSalary = widget707.averageSalary;

                        const nameData = [];
                        const valueData = [];
                        for (var i = 0; i < averageSalary.length; i++) {
                            nameData.push(averageSalary[i].averageNm);
                            valueData.push(averageSalary[i].averageNum);
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

                        const chart = new ApexCharts(document.querySelector("#annualChart707"), options);
                        chart.render();
                    }
                })
		}
	};
</script>
<div class="widget" id="widget707"></div>

<script>
	// DOM 로드 후에 UI 설정
	$(document).ready(function () {
		widget707.$widget = $('#'+ widget707.elemId);

		widget707.setUI(); // UI생성
		widget707.setUIEvent(); // 이벤트 할당
	});
</script>