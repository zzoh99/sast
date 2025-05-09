<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<style>
      .legend {                                                   /* NEW */
        font-size: 12px;                                          /* NEW */
      }                                                           /* NEW */
      rect {                                                      /* NEW */
        stroke-width: 2;                                          /* NEW */
      }                                                           /* NEW */

.graph_bar01{
	position:relative;
	width:100%;
	height:13px;
	border-radius:5px;
	background-color:#e1e6e8;
}

.chart_01 rect:first-of-type {
  color: #018ed3;
  fill: #e1e6e8;
  stroke-width: 0;
}


.chart_01 rect:nth-of-type(2) {
  color: #fff;
  stroke: transparent;
  fill: #018ed3;
  stroke-width: 0;
}


.chart_02 rect:first-of-type {
  color: #6fbc27;
  fill: #e1e6e8;
  stroke-width: 0;
}


.chart_02 rect:nth-of-type(2) {
  color: #fff;
  stroke: transparent;
  fill: #6fbc27;
  stroke-width: 0;
}

/* 20180329_이수건설(학점취득현황 그래프 2개로 표현) Start */
.box_100> .anchor_of_widget >.graph1_group2 { position:absolute; left:250px; top:20px; margin:0; width:200px; }
.box_100> .anchor_of_widget >.graph1_group2 li { position:relative; padding-top:22px; margin-top:0; }
.box_100> .anchor_of_widget >.graph1_group3 { position:absolute; left:500px; top:20px; margin:0; width:200px; }
.box_100> .anchor_of_widget >.graph1_group3 li { position:relative; padding-top:22px; margin-top:0; }


span.graph_4type { position:absolute; left:0; top:0; display:inline-block; font-size:12px; font-weight:400; text-align:left; width:150px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
span.graph_number2 { position:absolute; right:0; top:0; display:inline-block; color:#96999b; }
span.graph_number3 { position:absolute; right:0; top:0; display:inline-block; color:#96999b; }
.box_100 span.graph_number_one2 { position:absolute; left:210px; top:18px; display:inline-block; color:#96999b; }
.box_100 span.graph_number_one3 { position:absolute; left:210px; top:18px; display:inline-block; color:#96999b; }
span.graph_msg { position:absolute; display:inline-block; font-size:16px; font-weight:400; text-align:center; width:100%; font-weight:bold; margin-top:10px;}
span.graph_msg2 { position:absolute; display:inline-block; font-size:16px; font-weight:400; text-align:center; width:110%; font-weight:bold;}
/* 20180329_이수건설(학점취득현황 그래프 2개로 표현) End */

</style>

<script type="text/javascript">

var classTypeHtml01;


function main_listBox1(title, info , classNm1, seq){

	d3.select("#listBox1 > .anchor_of_widget > ul > li > #graphDraw01 > svg").remove();
	$("#listBox1").attr("seq", seq);

	$.ajax({
		url 		: "${ctx}/getListBox1List.do",
		type 		: "post",
		dataType 	: "json",
		async 		: true,
		data 		: "searchSabun=" + "${ssnSabun}",
		success : function(rv) {
			var eduCompPoint;			// 이수 포인트
			var eduReqPoint;			// 필수 포인트

			//20180329 이수건설일 경우만 사용
			var pPoint;					// 이수 필수 포인트
			var eduPPoint;				// 필수 포인트
			var sPoint;					// 이수 선택 포인트
			var eduSPoint;				// 선택 포인트
			var eduYn;				// 이수완료여부


			try{

				var list1 = rv.DATA;
				eduCompPoint = list1[0].eduCompPoint;
				eduReqPoint = list1[0].eduReqPoint;

				pPoint = list1[0].pPoint;
				eduPPoint = list1[0].eduPPoint;
				sPoint = list1[0].sPoint;
				eduSPoint = list1[0].eduSPoint;
				eduYn = list1[0].eduYn;

			}catch(e){

				eduCompPoint = 0;
				eduReqPoint = 0;

				pPoint = 0;
				eduPPoint = 0;
				sPoint = 0;
				eduSPoint = 0;
				eduYn = "";
			}

			//eduCompPoint = 120;
			//eduReqPoint = 120;

			if ( eduReqPoint <= eduCompPoint ){

			}

			// #99fc3c


			if ( classNm1 == undefined || classNm1== null || classNm1 == "undefined" || classNm1 == "null" || classNm1 == "" ){
				classNm1 = "box_250";
			}

			$("#listBox1").removeClass();


			var titleText = "교육현황";
			var requireText = "필수";

			var ssnEnterCd = "${ssnEnterCd}";
			if ( ssnEnterCd == "ISU_CT"){

				var requirePText = "필수학점";
				var requireSText = "선택학점";

				titleText = "학점취득현황";

				if(eduYn == "Y"){
					eduYn = "완료";
				} else {
					eduYn = "미완료";
				}

				if(classNm1 == "box_100"){

					classTypeHtml01 = '<h3 class="main_title_100 img_100_edu">'+  titleText  + '</h3>'
						+'<ul class="graph1_group2">'
							+'<li>'
							+'<span class="graph_4type">' + requirePText + '</span>'
							+'<span class="graph_number_one2"><span class="f_blue f_bold">0</span>/0</span>'
							+'<div class="graph_bar01" id="graphDraw01">'
							+'<div class="graph_barB"></div>'
							+'</div>'
							+'</li>'
						+'</ul>'
						+'<ul class="graph1_group3">'
							+'<li>'
							+'<span class="graph_4type">' + requireSText + '</span>'
							+'<span class="graph_number_one3"><span class="f_blue f_bold">0</span>/0</span>'
							+'<div class="graph_bar01" id="graphDraw02">'
							+'<div class="graph_barB"></div>'
							+'</div>'
							+'</li>'
						+'</ul>'
						+'<ul>'
						+'<li>'
						+'<span class="graph_msg2">' + eduYn + '</span>'
						+'</li>'
						+'</ul>';

				} else if(classNm1 == "box_250"){

					classTypeHtml01 = '<h3 class="main_title_250">' + titleText + '</h3>'
						+'<a  class="btn_main_more" id="eduWidget" title="더보기">더보기</a>'
						+'<ul class="graph3_group">'
						+'<li>'
						+'<span class="graph_4type">' + requirePText + '</span>'
						+'<span class="graph_number2"><span class="f_blue f_bold">0</span>/0</span>'
						+'<div class="graph_bar01" id="graphDraw01">'
						+'<div class="graph_barB"></div>'
						+'</div>'
						+'</li>'
						+'</ul><p/>'
						+'<ul class="graph3_group">'
						+'<li>'
						+'<span class="graph_4type">' + requireSText + '</span>'
						+'<span class="graph_number3"><span class="f_blue f_bold">0</span>/0</span>'
						+'<div class="graph_bar01" id="graphDraw02">'
						+'<div class="graph_barB"></div>'
						+'</div>'
						+'</li>'
						+'</ul><p/>'
						+'<ul>'
						+'<li>'
						+'<span class="graph_msg">' + eduYn + '</span>'
						+'</li>'
						+'</ul>';

				} else if(classNm1 == "box_400"){

					classTypeHtml01 = '<h3 class="main_title_400">' + titleText + '</h3>'
						+'<a  class="btn_main_more" id="eduWidget" title="더보기">더보기</a>'
						+'<div class="main_img_group">'
						+'<span class="img_400 img_400_edu"></span>'
						+'</div>'
						+'<ul class="graph3_group">'
						+'<li>'
						+'<span class="graph_4type">' + requirePText + '</span>'
						+'<span class="graph_number2"><span class="f_blue f_bold">0</span>/0</span>'
						+'<div class="graph_bar01" id="graphDraw01" >'
						+'<div class="graph_barB"></div>'
						+'</div>'
						+'</li>'
						+'</ul><p/>'
						+'<ul class="graph3_group">'
						+'<li>'
						+'<span class="graph_4type">' + requireSText + '</span>'
						+'<span class="graph_number3"><span class="f_blue f_bold">0</span>/0</span>'
						+'<div class="graph_bar01" id="graphDraw02" >'
						+'<div class="graph_barB"></div>'
						+'</div>'
						+'</li>'
						+'</ul><p/>'
						+'<ul>'
						+'<li>'
						+'<span class="graph_msg">' + eduYn + '</span>'
						+'</li>'
						+'</ul>';
				}

				$("#listBox1").addClass(classNm1);
				$("#listBox1 > .anchor_of_widget").html(classTypeHtml01);

				var isFullClass = "chart_01";

				if ( classNm1 != "box_100"){
					if ( eduPPoint <= pPoint ){
						isFullClass = "chart_02";
						pPoint = eduPPoint;
					}

					if ( eduSPoint <= sPoint ){
						isFullClass = "chart_02";
						sPoint = eduSPoint;
					}

					$("#listBox1 > .anchor_of_widget > ul > li > .graph_number2").html( '<span class="f_blue f_bold">' +  pPoint + '</span>/' + eduPPoint );
					$("#listBox1 > .anchor_of_widget > ul > li > .graph_number3").html( '<span class="f_blue f_bold">' +  sPoint + '</span>/' + eduSPoint );

					var data1 = [eduPPoint, pPoint];
					var data2 = [eduSPoint, sPoint];

					var chart1 = d3.select("#listBox1 > .anchor_of_widget > ul > li > #graphDraw01").append("svg")
								.attr("class", isFullClass)
								.attr("width", 200)
								.attr("height", 13 * data1.length);
					var chart2 = d3.select("#listBox1 > .anchor_of_widget > ul > li > #graphDraw02").append("svg")
								.attr("class", isFullClass)
								.attr("width", 200)
								.attr("height", 13 * data2.length);

					var xa1 = d3.scaleLinear()
							.domain([0, d3.max(data1)])
							.range([0, 200]);
					var xa2 = d3.scaleLinear()
							.domain([0, d3.max(data2)])
							.range([0, 200]);

					chart1.selectAll("rect")
						 .data(data1)
						 .enter().append("rect")
						 .attr("width", xa1)
						 .attr("height", 13)
						 .attr("rx", 5)
						 .attr("ry", 5);
					chart2.selectAll("rect")
						 .data(data2)
						 .enter().append("rect")
						 .attr("width", xa2)
						 .attr("height", 13)
						 .attr("rx", 5)
						 .attr("ry", 5);

				}else{
					if ( eduPPoint <= pPoint ){
						isFullClass = "chart_02";
						pPoint = eduPPoint;
					}

					if ( eduSPoint <= sPoint ){
						isFullClass = "chart_02";
						sPoint = eduSPoint;
					}

					$("#listBox1 > .anchor_of_widget > ul > li > .graph_number_one2").html( '<span class="f_blue f_bold">' +  pPoint + '</span>/' + eduPPoint );
					$("#listBox1 > .anchor_of_widget > ul > li > .graph_number_one3").html( '<span class="f_blue f_bold">' +  sPoint + '</span>/' + eduSPoint );

					var data3 = [eduPPoint, pPoint];
					var data4 = [eduSPoint, sPoint];
					var chart3 = d3.select("#listBox1 > .anchor_of_widget > ul > li > #graphDraw01").append("svg")
								.attr("class", isFullClass)
								.attr("width", 200)
								.attr("height", 13 * data3.length);
					var chart4 = d3.select("#listBox1 > .anchor_of_widget > ul > li > #graphDraw02").append("svg")
								.attr("class", isFullClass)
								.attr("width", 200)
								.attr("height", 13 * data4.length);

					var xb3 = d3.scaleLinear()
							.domain([0, d3.max(data3)])
							.range([0, 200]);
					var xb4 = d3.scaleLinear()
							.domain([0, d3.max(data4)])
							.range([0, 200]);

					chart3.selectAll("rect")
						 .data(data3)
						 .enter().append("rect")
						 .attr("width", xb3)
						 .attr("height", 13)
						 .attr("rx", 5)
						 .attr("ry", 5);
					chart4.selectAll("rect")
						 .data(data4)
						 .enter().append("rect")
						 .attr("width", xb4)
						 .attr("height", 13)
						 .attr("rx", 5)
						 .attr("ry", 5);
				}

			////////////////////////////////////////////////////////////////////////////////////////
			} else {

				if(classNm1 == "box_100"){

					classTypeHtml01 = '<h3 class="main_title_100 img_100_edu">'+  titleText  + '</h3>'
						+'<ul class="graph1_group">'
							+'<li>'
							//+'<span class="graph_3type">필수</span>'
							+'<span class="graph_number_one"><span class="f_blue f_bold">0</span>/0</span>'
							//+'<span class="f_blue f_bold" id="test" >0</span><span id="test01">0</span>'
							+'<div class="graph_bar01" id="graphDraw01">'
							+'<div class="graph_barB"></div>'
							+'</div>'
							+'</li>'
						+'</ul>';

				} else if(classNm1 == "box_250"){

					classTypeHtml01 = '<h3 class="main_title_250">' + titleText + '</h3>'
						+'<a  class="btn_main_more" id="eduWidget" title="더보기">더보기</a>'
						+'<ul class="graph3_group">'
						+'<li>'
						+'<span class="graph_3type">' + requireText + '</span>'
						+'<span class="graph_number"><span class="f_blue f_bold">0</span>/0</span>'
						//+'<span class="f_blue f_bold" id="test" >0</span><span id="test01">0</span>'
						+'<div class="graph_bar01" id="graphDraw01">'
						+'<div class="graph_barB"></div>'
						+'</div>'
						+'</li>'
						+'</ul>';

				} else if(classNm1 == "box_400"){

					classTypeHtml01 = '<h3 class="main_title_400">' + titleText + '</h3>'
						+'<a  class="btn_main_more" id="eduWidget" title="더보기">더보기</a>'
						+'<div class="main_img_group">'
						+'<span class="img_400 img_400_edu"></span>'
						+'</div>'
						+'<ul class="graph3_group">'
						+'<li>'
						+'<span class="graph_3type">' + requireText + '</span>'
						+'<span class="graph_number"><span class="f_blue f_bold">0</span>/0</span>'
						//+'<span class="f_blue f_bold" id="test" >0</span><span id="test01">0</span>'
						+'<div class="graph_bar01" id="graphDraw01" >'
						+'<div class="graph_barB"></div>'
						+'</div>'
						+'</li>'
						+'</ul>';

				}

				$("#listBox1").addClass(classNm1);
				$("#listBox1 > .anchor_of_widget").html(classTypeHtml01);

				var isFullClass = "chart_01";

				if ( classNm1 != "box_100"){

					if ( eduReqPoint <= eduCompPoint ){

						isFullClass = "chart_02";
						eduCompPoint = eduReqPoint;
					}

					$("#listBox1 > .anchor_of_widget > ul > li > .graph_number").html( '<span class="f_blue f_bold">' +  eduCompPoint + '</span>/' + eduReqPoint );

					var data1 = [eduReqPoint, eduCompPoint];

					var chart1 = d3.select("#listBox1 > .anchor_of_widget > ul > li > #graphDraw01").append("svg")
								.attr("class", isFullClass)
								.attr("width", 200)
								.attr("height", 13 * data1.length);

					var xa = d3.scaleLinear()
							.domain([0, d3.max(data1)])
							.range([0, 200]);

					chart1.selectAll("rect")
						 .data(data1)
						 .enter().append("rect")
						 .attr("width", xa)
						 .attr("height", 13)
						 .attr("rx", 5)
						 .attr("ry", 5);

				}else{

					if ( eduReqPoint <= eduCompPoint ){

						isFullClass = "chart_02";
						eduCompPoint = eduReqPoint;
					}

					$("#listBox1 > .anchor_of_widget > ul > li > .graph_number_one").html( '<span class="f_blue f_bold">' +  eduCompPoint + '</span>/' + eduReqPoint );

					//$(".graph_number_one01").html( '<span class="f_blue f_bold">' +  eduCompPoint + '</span>/' + eduReqPoint );
					var data2 = [eduReqPoint, eduCompPoint];
					//alert(d3.max(data2));
					var chart2 = d3.select("#listBox1 > .anchor_of_widget > ul > li > #graphDraw01").append("svg")
								.attr("class", isFullClass)
								.attr("width", 300)
								.attr("height", 13 * data2.length);

					var xb = d3.scaleLinear()
							.domain([0, d3.max(data2)])
							.range([0, 300]);

					chart2.selectAll("rect")
						 .data(data2)
						 .enter().append("rect")
						 .attr("width", xb)
						 .attr("height", 13)
						 .attr("rx", 5)
						 .attr("ry", 5);
				}
			}

			//더보기 링크 클릭 이벤트
			$("#eduWidget").click(function() {

				var goPrgCd = "";

				if ( ssnEnterCd == "ISU_CT"){
					goPrgCd = "EduResultLst.do?cmd=viewEduResultLst";
				} else {
					goPrgCd = "EduApp.do?cmd=viewEduApp";
				}

				goSubPage("05","","","",goPrgCd);
			});

		},
		error : function(jqXHR, ajaxSettings, thrownError) {
			ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
		}

	});
}
</script>


<div id="listBox1" lv="1" class="box_250" class="notice_box">
	<div class="anchor_of_widget">
	</div>
</div>


