<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
	/*
	 * 급여 아웃라이어 
	 * 직위 하드코딩, 데이터 우선 넣어놓기
	 */

	var widget703 = {
		size: null
	};

	var currentOutlierCount = 0;
	var chartJikweeCategories = [];
	var chartXCategories = [];

	/**
	 * 파라미터에 따른 메서드 선택 
	 * size : 사이즈 (값 "wide" -> wide위젯 메서드 호출, "normal" -> 한칸 위젯 메서드 호출)
	 */
	function init_listBox703(size) {
		widget703.size = size;
		
		if (size == "normal"){
			createWidgetMini703();
			setDataWidgetMini703();
		} else if (size == ("wide")){
			createWidgetWide703();
		}
	}

	// 위젯 mini html 코드 생성 
	function createWidgetMini703(){
		var html = 
				  '<div class="widget_header toggle-wrap">' +
        		  '  <div class="widget_title">급여 아웃라이어</div>' +
        		  '    </label>' +
        		  '</div>' +
        		  '<div class="widget_body attend-status widget-common widget-more">' +
        		  '  <div class="bookmarks_title">' +
        		  '    <a href="#" class="arrowLeft"><i class="mdi-ico">keyboard_arrow_left</i></a>' +
        		  '    <span id="outlierJikweeName">사원</span>' +
        		  '    <a href="#" class="arrowRight"><i class="mdi-ico">keyboard_arrow_right</i></a>' +
        		  '  </div>' +
        		  '  <div class="container_info">' +
        		  '    <span class="info_title_num" id="outlierJikweeCnt"></span>' +
        		  '    <span class="info_title desc"><span>전년대비</span><strong class="title_green">%</strong>증가<div class="tag_icon green round"><i class="mdi-ico">trending_up</i></div></span>' +
        		  '    <div class="btn-wrap">' +
        		  '      <button class="btn outline_gray btn-more">아웃라이어 더 보기</button>' +
        		  '    </div>' +
        		  '  </div>' +
        		  '</div>';

		document.querySelector('#widget703Element').innerHTML = html;
	}

	// 위젯 mini 데이터 넣기  
	function setDataWidgetMini703(option){
		const salaryOutlier = ajaxCall('getListBox703List.do', '', false).data.salaryOutlier;

	    if (typeof option == "undefined" || option == null || option == ""){
	    	option = 0;
		}

		if (option == salaryOutlier.data.length){
			option = 0;
			currentOutlierCount = 0;
		} else if (currentOutlierCount < 0) {
			option = salaryOutlier.data.length - 1;
		    currentOutlierCount = salaryOutlier.data.length - 1;
		}
		
		$('#outlierJikweeName').text(salaryOutlier.data[option].jikwee);
// 		$('#outlierJikweeCnt').text(salaryOutlier.data[option].jikweeCnt);
		document.querySelector('#outlierJikweeCnt').innerHTML = salaryOutlier.data[option].jikweeCnt + '<span class="info_title unit">명</span>';
	}
	
	// 위젯 wide html 코드 생성 
	function createWidgetWide703(){
		var html = 
				  '<div class="widget_header toggle-wrap">' +
        		  '  <div class="widget_title">급여 아웃라이어</div>' +
        		  '  </label>' +
        		  '</div>' +
        		  '<div class="widget_body chart-full">' +
        		  // '  <div class="btn-wrap">' +
        		  // '    <button class="btn outline_gray btn-more">아웃라이어 더 보기</button>' +
        		  // '  </div>' +
        		  '  <div class="chart-wrap">' +
        		  '    <div id="boxplotChart"></div>' +
        		  '  </div>' +
        		  '</div>';

		document.querySelector('#widget703Element').innerHTML = html;
	}

	/**
	 * TODO: 차장님께 직위 쿼리 받기 
	 * 오른쪽 왼쪽 다른 리스트 출력하는 메서드
	 */	
	$(document).ready(function() {
		$('#widget703Element').on('click', '.arrowRight', function() {
			currentOutlierCount++;
			setDataWidgetMini703(currentOutlierCount);
		});

		$('#widget703Element').on('click', '.arrowLeft', function() {
			currentOutlierCount--;
			setDataWidgetMini703(currentOutlierCount);
		});
	});
	
</script>
<div class="widget" id="widget703Element"></div>

<script> 
	$(document).ready(function () {
		/* 말풍선 */
		$('.avatar-list .name').mouseover(function(event){
			const xpos = $(this).position().left;
			const ypos = -$(this).parent().position().top;
			console.log("xpos:"+xpos+"/ ypos:"+ypos);
			// $(this).parent().parent().next().css( { "display" : 'flex', "margin-left" : xpos + "px", "margin-top" : ypos+"px" });
			$(this).parent().parent().next().css( { "display" : 'flex', "margin-left" : xpos + "px", "margin-top" : ypos+"px" });
		});
		
		$('.avatar-list .name').mouseout(function(event){
			$(this).parent().parent().next().hide();
		});

		/* 말풍선 */
		$('.overtime-work .avatar-list .name').mouseover(function(event){
			const xpos = ($(this).position().left + $(this).width() - 5 );
			const ypos = -($(this).parent().position().top + 33);
			console.log("xpos:"+xpos+"/ ypos:"+ypos);
			// $(this).parent().parent().next().css( { "display" : 'flex', "margin-left" : xpos + "px", "margin-top" : ypos+"px" });
			$(this).parent().parent().next().css( { "display" : 'flex', "margin-left" : xpos + "px", "margin-top" : ypos+"px" });
     	 });
      $('.overtime-work .avatar-list .name').mouseout(function(event){
        $(this).parent().parent().next().hide();
      });

		/*
		 * TODO : 차장님께 직위 쿼리 받기
		 * 위젯 wide 일 때만  차트 출력 
		 */
	if (widget703.size == 'wide'){
	
		var options = {
	          series: [
		          {
			    name: '최소',
			    type: 'scatter',
			    data: [
			    ]
			  },
	          {
	            name: '금액',
	            type: 'boxPlot',
	            data: [
	            ]
	          }
	        ],
	          chart: {
	          type: 'boxPlot',
	          width: 504,
	          height: 200.5,
			    toolbar: {
			        show: false 
			      }
	        	},
			 colors: ['#34c759', '#ffb32e'],
		     xaxis: {
		         type: 'category',
		         categories: chartJikweeCategories,
		         tooltip: {
		             formatter: function (val) {
		                 return val;
		             }
		         }
		     },
		     yaxis: {
		         tickAmount: 4,
		         labels: {
		             style: {
		                 fontSize: '11px'
		             }
		         }
		    },
		     legend: {
		         position: 'top',
		         horizontalAlign: 'right'
		      },
		      plotOptions: {
	                boxPlot: {
	                  colors: {
	                    upper: '#34c759'
	                  }
	                }
	              },
		};   
		
		const salaryOutlier = ajaxCall('getListBox703List.do', '', false).data.salaryOutlier;
	    
	    for (var i = 0; i < salaryOutlier.data.length; i++){

			chartJikweeCategories.push(salaryOutlier.data[i].jikwee);
			
			options.series[0].data.push({
			       x: chartJikweeCategories[i],
			       y: salaryOutlier.data[i].min
			   });
			
			options.series[1].data.push({
			    x: chartJikweeCategories[i],
			    y: [salaryOutlier.data[i].min, salaryOutlier.data[i].bandS, salaryOutlier.data[i].minMaxAvg, salaryOutlier.data[i].bandE, salaryOutlier.data[i].max] 
			});
		}
		
	    var chart = new ApexCharts(document.querySelector("#boxplotChart"), options);
	    chart.render();
	  }
    });
</script>
