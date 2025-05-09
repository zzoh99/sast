<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<style>
      .legend {                                                   /* NEW */
        font-size: 12px;                                          /* NEW */
      }                                                           /* NEW */
      rect {                                                      /* NEW */
        stroke-width: 2;                                          /* NEW */
      }                                                           /* NEW */


.chart_05 rect:first-of-type {
  color: #018ed3;
  fill: #e1e6e8;
  stroke-width: 0;
}


.chart_05 rect:nth-of-type(2) {
  color: #fff;
  stroke: transparent;
  fill: #018ed3;
  stroke-width: 0;
}

</style>
<script type="text/javascript">

var widgetContent05;

function main_listBox5(title, info , classNm, seq ){

	$("#listBox5").attr("seq", seq);

	d3.select("#listBox5 > .anchor_of_widget > #graphDraw05 > svg").remove();

	$.ajax({
		url 		: "${ctx}/getListBox5List.do",
		type 		: "post",
		dataType 	: "json",
		async 		: true,
		data 		: "",
		success : function(rv) {
			var list = rv.DATA;
			var str = "";

			var creCnt = list[0].creCnt;		//총 휴가
			var usedCnt = list[0].usedCnt;		//사용 휴가
			var restCnt = list[0].restCnt;		//잔여 휴가

			var totCnt = parseFloat(usedCnt,10) + parseFloat(restCnt,10);

			if ( classNm == undefined || classNm == null || classNm == "undefined" || classNm== "null" || classNm == ""){

				classNm = "box_250";
			}

			//$(".graph_circleB").html("");
			//$(".graph_bar").html("");
			$("#listBox5").removeClass();



			// classNm 1. box_250 , box_400 , box_100
			if(classNm == "box_250"){

				widgetContent05 = '<h3 class="main_title_250">잔여휴가(' + restCnt + '개)</h3>'
								+ '<a  class="btn_main_more" title="더보기" id="appWidgetAppl" >더보기</a>'
								+ '<div class="graph_circleB" id="graphDraw05">'
								+ '<div class="graph_circle_txt">'
								+ '<span class="graph_circle_stitle">잔여일수</span>'
								+ '<span class="graph_circle_type">0</span><span class="graph_circle_total">/0</span>'
								+ '</div>'
								+ '</div>'
								+ '<div class="btn_alignC">'
								//+ '<a id="holidayWidget" class="btnW" style="cursor:pointer">휴가신청</a>'
								+ '</div>'
			}else if(classNm == "box_400"){

				widgetContent05 = '<h3 class="main_title_400">잔여휴가(' + restCnt + '개)</h3>'
				 				+ '<a  class="btn_main_more" title="더보기" id="appWidgetAppl" >더보기</a>'
								+ '<div class="graph_circleB" id="graphDraw05">'
								+ '<div class="graph_circle_txt">'
								+ '<span class="graph_circle_stitle">잔여일수</span>'
								+ '<span class="graph_circle_type"></span><span class="graph_circle_total"></span>'
								+ '</div>'
								+ '</div>'
								+ '<div class="graph_circle_conG">'
								+ '<ul class="graph_circle_con">'
								+ '<li id="graphCircleTotal05">'
								+ '<span class="circle_total"></span>'
								+ 'Total (<span class="f_blue"></span>)'
								+ '</li>'
								+ '<li id="graphCircleType05">'
								+ '<span class="circle_type1"></span>'
								+ '사용일수 (<span class="f_red"></span>)'
								+ '</li>'
								+ '</ul>'
								+ '</div>'
								+ '<div class="btn_alignC">'
								//+ '<a id="holidayWidget" class="btnW" style="cursor:pointer">휴가신청</a>'
								+ '</div>'

			}else{

				widgetContent05 = '<h3 class="main_title_100 img_100_holiday">잔여휴가(' + restCnt + '개)</h3>'
				                + '<a  class="btn_main_more" title="더보기" id="appWidgetAppl" >더보기</a>'
								+ '<ul class="graph1_group">'
								+ '<li>'
								+ '<span class="graph_number_one"><span class="f_blue f_bold">60</span>/120</span>'
								+ '<div class="graph_bar05" id="graphDraw05">'
								+ '<div class="graph_barB"></div>'
								+ '</div>'
								+ '</li>'
								+ '</ul>'
								+ '<div class="btn_100_right">'
								//+ '<a id="holidayWidget" class="btnW" style="cursor:pointer">휴가신청</a>'
								+ '</div>';

			}

			//alert("classNm  :" + classNm );


			$("#listBox5").addClass(classNm);

			$("#listBox5 > .anchor_of_widget").html(widgetContent05);

			$("#listBox5 > .anchor_of_widget > .graph_circleB > .graph_circle_txt > .graph_circle_type").text( restCnt );
			$("#listBox5 > .anchor_of_widget > .graph_circleB > .graph_circle_txt > .graph_circle_total").text( "/" + totCnt );
			$("#listBox5 > .anchor_of_widget > .graph_circle_conG > .graph_circle_con > #graphCircleTotal05 > .f_blue").text( totCnt );
			$("#listBox5 > .anchor_of_widget > .graph_circle_conG > .graph_circle_con > #graphCircleType05 > .f_red").text( usedCnt );
			$("#listBox5 > .anchor_of_widget > ul > li > .graph_number_one").html( '<span class="f_blue f_bold">' +  restCnt + '</span>/' + totCnt );

			if ( totCnt == 0 && restCnt== 0  ){

				restCnt = 1;
			}

			if ( classNm != "box_100"){


				 var dataset = [
					 { label: 'Dijkstra', count: usedCnt },
					 { label: 'Abulia', count: restCnt }
			        ];

			        var width = 120;
			        var height = 120;

			        if ( classNm == "box_400"){
			        	width = 140;
			        	height = 140;
			        }

			        var radius = Math.min(width, height) / 2;
			        var donutWidth = 15;
			        var legendRectSize = 6;                                  // NEW
			        var legendSpacing = 1;                                    // NEW

			        var color = d3.scaleOrdinal(d3.schemeCategory20b);

			        var svg = d3.select('.graph_circleB')
			          .append('svg')
			          .attr('width', width)
			          .attr('height', height)
			          .append('g')
			          .attr('transform', 'translate(' + (width / 2) +
			            ',' + (height / 2) + ')');

			        var arc = d3.arc()
			          .innerRadius(radius - donutWidth)
			          .outerRadius(radius);

			        var pie = d3.pie()
			          .value(function(d) { return d.count; })
			          .sort(null);

			        var path = svg.selectAll('path')
			          .data(pie(dataset))
			          .enter()
			          .append('path')
			          .attr('d', arc)
			          .attr('fill', function(d, i) {
			        	  if ( i == 1 ){
								return "#018ed4";
				        	  }else {
				        		  return "#f4617c";
				        	  }
			          });
			} else {

				  var data = [totCnt, restCnt];

				  var chart = d3.select("#listBox5 > .anchor_of_widget > ul > li > #graphDraw05").append("svg")
				    .attr("class", "chart_05")
				    .attr("width", 300)
				    .attr("height", 13 * data.length);

				  var x = d3.scaleLinear()
				    .domain([0, d3.max(data)])
				    .range([0, 300]);

				  chart.selectAll("rect")
				    .data(data)
				  .enter().append("rect")
				    .attr("width", x)
				    .attr("height", 13)
				    .attr("rx", 5)
				    .attr("ry", 5);
			}
			
			//더보기 링크 클릭 이벤트
			$("#appWidgetAppl").off();
			$("#appWidgetAppl").on( "click" , function(e) {
				var goPrgCd = "VacationApp.do?cmd=viewVacationApp";
				goSubPage("08","","","",goPrgCd);
			});

			
		},
		error : function(jqXHR, ajaxSettings, thrownError) {
			ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
		}
	});
}
</script>

<div class="box_250 notice_box" id="listBox5" lv="5" info="휴가사용내역 및 휴가신청 바로가기" >
	<div class="anchor_of_widget">
	</div>
</div>