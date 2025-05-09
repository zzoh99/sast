<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>임직원 Timeline</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->

<!-- Custom Theme Style -->
<link href="${ ctx }/common/css/cmpEmp/custom.min.css" rel="stylesheet">
<link href="${ ctx }/common/css/cmpEmp/isu_dashboard.css" rel="stylesheet">	

<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="${ctx}/common/plugin/IBLeaders/Chart/js/ibchart.js" type="text/javascript"></script>
<script src="${ctx}/common/plugin/IBLeaders/Chart/js/ibchartinfo.js" type="text/javascript"></script>
<script src="${ctx}/common/plugin/D3/d3.min.js"		type="text/javascript"></script>

<link rel="stylesheet" type="text/css" href="${ ctx }/common/plugin/Blueprints/css/component.css" />

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {
		myChart1.RemoveAll();
		myChart2.RemoveAll();
		
		progressBar(true) ;
		
		$("#searchName").bind("keyup",function(event){
			if( event.keyCode == 13){
				showEmpList();
			}
		});
		
		$("#searchOrgCd").change(function(){
			showEmpList();
		});
		
		
		setOrgCombo();
		$("#searchOrgCd").val("${ssnOrgCd}");
		//$("#searchOrgCd").change();
		
		$(window).smartresize(boxResize);
		boxResize();
		
		$("#searchOrgCd").change();
		progressBar(false) ;		
		
	});
	
	//조직콤보
	function setOrgCombo(){
		var all = "";
		if( "${ ssnSearchType }" != "A" ) {
			all = "전체";
		}
		var orgCd = convCode( ajaxCall("${ctx}/PsnlTimeCalendar.do?cmd=getPsnlTimeCalendarOrgList","searchYmd="+$("#searchYmd").val(),false).DATA, all);
		$("#searchOrgCd").html(orgCd[2]);
	}

	
	// 박스 리사이즈
	function boxResize() {
		var outer_height = getOuterHeight();
		var inner_height = 0;
		var value = 0;
		var box = $("#timelineBox, #timelineBox .list_box");
		
		inner_height = getInnerHeight(box);
		value = ($(window).height() - outer_height) - inner_height- 60;
		if (value < 100) value = 100;
		box.height(value);
		box.css({
			"max-height" : value + "px"
		})
		//alert("window : " + $(window).height() + ", inner_height : " + inner_height + " , outer_height : " + outer_height + ", value : " + value);
		
		clearTimeout(timeout);
		timeout = setTimeout(addTimeOut, 50);
	}

	// 발령내역 자세히 보기
	function showEmpList() {		
		try {
			myChart1.RemoveAll();
			myChart2.RemoveAll();
			progressBar(true);
			var html = "";
			
			$("#detailList").html("");
			var data = ajaxCall("${ctx}/EmpTimelineSrch.do?cmd=getEmpTimelineSrchEmpList", $("#empForm").serialize(), false);
			//console.log('data', data);
			
			var item = null;
			if( data != null && data != undefined && data.DATA != null && data.DATA != undefined ) {
				for( var i = 0; i < data.DATA.length; i++) {
					item = data.DATA[i];
					var keywordList = ajaxCall( "${ctx}/EmpTimelineSrch.do?cmd=getPsnalKeywordList", "&sabun=" + item.sabun , false);
					
					html += "<div class=\'tile-stats card-profile\' sabun='" + item.sabun + "' onclick=\"javascript:showEmpDetailContents('" + item.sabun + "');\">";
					html += "  <div class=\'profile_img \'>";
					html += "    <img src=\'/common/images/common/img_photo.gif\'  id='photo"+i+"\' alt=\'Avatar\' title=\'Change the avatar\'>";
					html += "  </div>";
					html += "  <div class=\'profile_info\'>";
					html += "    <div style=\'height: 20px;\'>";
					html += "      <p class=\'name\' id=\'tdName"+i+"\' style=\'float: left; margin-top: 3px;\'>";
					html += "        <span class=\'gender\' style=\'float: left;\'>(<i class=\'fa fa-male\'></i> 남성)</span>";
					html += "      </p>";
					html += "      <a href=\'javascript:showRd(" + "\""+item.enterCd+ "\", \""+item.sabun+"\");\' class=\'btn\' style=\'border:1px solid #d0d0d0; float: right; height: 20px; padding: 0px 10px; line-height: 20px;\' >Profile Card</a>";
					html += "    </div>";
					html += "   <ul class=\'profile_desc\'>";
					html += "      <li id=\'tdSabun"+i+"\'></li>";
					//html += "      <li id=\'tdEmpYmd"+i+"\'></li>";
					html += "      <li id=\'tdJikweeNm"+i+"\'></li>";
					html += "      <li id=\'tdJikchakNm"+i+"\'></li>";
					html += "      <li id=\'tdOrgNm"+i+"\' class=\'full\'></li>";
					if( keywordList && keywordList != null && keywordList.DATA && keywordList.DATA.length > 0 ) {
						let keywordText = "";
						keywordList.DATA.map(( a, i) => {
							if( i == 0 ) {
								keywordText +=  " #" + a.keyword
							}else {
								keywordText +=  ", #" + a.keyword
							}
						});
						html += "      <li id=\'tdKeywordNm"+i+"\' class=\'full keyword-li\'>Keyword  : "+keywordText+"</li>";
					}
					html += "    </ul>";
					html += "  </div>";
					html += "</div>";
				}
			}
			
			$("#detailList").html(html);
			
			/* 데이터 세팅 */
			if( data != null && data != undefined && data.DATA != null && data.DATA != undefined ) {
				for( var i = 0; i < data.DATA.length; i++) {
					item = data.DATA[i];
					
					setImgFile(item.sabun, i) ;
				 	$("#tdSabun"+i).html("사번 : " + item.sabun) ;
				 	$("#tdName"+i).html(item.name) ;
				 	$("#tdOrgNm"+i).html("소속 : " + item.orgNm) ;
				 	//$("#tdEmpYmd"+i).html("입사일 : " + item.empYmd) ;
				 	$("#tdJikweeNm"+i).html("직위 : " + item.jikweeNm) ;
				 	$("#tdJikgubNm"+i).html(item.jikgubNm) ;
				 	$("#tdJikjongNm"+i).html("직종 : " + item.jikjongNm) ;
				 	$("#tdJikchakNm"+i).html("직책 : " + item.jikchakNm) ;
				}
				
				if(data.DATA.length > 0){
					$(".card-profile").eq(0).trigger("click");
				}else{
					showEmpDetailContents('-1')
				}
			}
		} catch (ex) {
			progressBar(false);
			alert("showEmpList Event Error : " + ex);
		}
	}

	//사진파일 적용 by
	function setImgFile(sabun, i){
		$("#photo"+i).attr("src", "${ctx}/EmpPhotoOut.do?searchKeyword="+sabun);
	}
	
	// 선택 임직원의 상세 컨텐츠 출력
	function showEmpDetailContents(sabun) {
		$(".card-profile").each(function(){
			if( $(this).attr("sabun") == sabun ) {
				$(this).addClass("choose");
			} else {
				$(this).removeClass("choose");
			}
		});
		
		showEmpTimeline(sabun);
		
		callChart(sabun, myChart1, "AREA");
		
		callChart(sabun, myChart2, "LINE");
		
		callGuageChar(sabun, '.graph_circleA');
		
		callCompareBarChar(sabun, '.graph_barA');
		
	}
	
	function showEmpTimeline(sabun) {
		var html = "";
		//$("#timelineBox ul.cbp_tmtimeline").html("");
		try {
			var data = ajaxCall("${ctx}/EmpTimelineSrch.do?cmd=getAppmtTimelineSrchTimelineList", $("#empForm").serialize() + "&searchSabun=" + sabun, false);
			//console.log('data', data);
			
			var item = null;
			if( data != null && data != undefined && data.DATA != null && data.DATA != undefined ) {
				for( var i = 0; i < data.DATA.length; i++) {
					item = data.DATA[i];
					html += "<li>";
					html += "<time class=\"cbp_tmtime\" datetime=\"" + item.monthDay + "\"><span>" + item.year + "</span> <span>" + item.monthDay + "</span></time>";
					html += "<div class=\"cbp_tmicon\"></div>";
					html += "<div class=\"cbp_tmlabel\">";
					html += "<p>" + item.timelineSummary + "</p>";
					html += "</div>";
					html += "</li>";
				}
			}
			
			//if( html != "" ) {
				$("#timelineBox ul.cbp_tmtimeline").html(html);
			//}
			
			boxResize();
		} catch (ex) {
			alert("showEmpTimeline Event Error : " + ex);
		}
	}
	
	function callChart(sabun, chart, chartType) {
		chart.RemoveAll();
		if( chartType == "LINE" ) {
			chart.SetDefaultSeriesType(IBChartType.LINE);
		} else if( chartType == "AREA" ) {
			chart.SetDefaultSeriesType(IBChartType.AREA);
		}
		chart.SetLegend(false);
		//console.log('chart', chart);
		
		var resultStr = "";
		resultStr += "{";
		resultStr += "    IBCHART: {";
		resultStr += "        BACKCOLOR: '#FFFFFF',";
		resultStr += "        BORDERWIDTH: '1',";
		resultStr += "        TITLE: '',";
		resultStr += "        ETCDATA: [";
		resultStr += "            {KEY:'sname', VALUE:'홍길동'},";
		resultStr += "            {KEY:'age',   VALUE:'10'}";
		resultStr += "        ],";
		resultStr += "        DATA: {";
		
		var data = null;
		if( chart.id == "myChart1" ) {
			data = ajaxCall("${ctx}/EmpTimelineSrch.do?cmd=getAppmtTimelineSrchCpnChartList","searchSabun=" + sabun,false);
		} else if( chart.id == "myChart2" ) {
			data = ajaxCall("${ctx}/EmpTimelineSrch.do?cmd=getAppmtTimelineSrchPapChartList","searchSabun=" + sabun,false);
		}
		
		var item = null;
		if( data != null && data != undefined ) {
			var pointSetStr = "";
			pointSetStr += "POINTSET:[";
			for(var i = 0; i < data.DATA.length; i++) {
				item = data.DATA[i];
				
				if( i > 0 ) {
					pointSetStr += ",{";
				} else {
					pointSetStr += "{";
				}
				pointSetStr += "    AXISLABEL:'" + item.label + "',";
				pointSetStr += "    SERIES:[";
				pointSetStr += "        {LEGENDLABEL:'" + item.legendLabel + "', VALUE:'" + item.value + "'}";
				pointSetStr += "    ]";
				pointSetStr += "}";
			}
			pointSetStr += "]";
		}
		
		resultStr += pointSetStr;
		resultStr += "        }";
		resultStr += "    }";
		resultStr += "}";
		
		var interval = -1;
		var $timer = $("#timer");
		drawChartForAnime(chart, resultStr) ;
		
		/*
		interval = setInterval(function() {
			drawChartForAnime(chart, result) ;
			clearInterval(interval);
		},400);
		*/
	}

	function drawChartForAnime(chart, result) {
		//console.log('result', result);

		var Yaxis = chart.GetYAxis(0);
		//Yaxis.SetMin(0);
		//Yaxis.SetMax(10000);
		if( chart.id == "myChart1" ) {
			Yaxis.SetTickInterval(10);
			Yaxis.SetAxisTitle({Enabled:true, Text:"금액(백만원)"});
		} else if( chart.id == "myChart2" ) {
			Yaxis.SetTickInterval(7);
			Yaxis.SetAxisTitle({Enabled:true, Text:"등급"});
		}
		
		//var pieChartTitle = '인원현황' ;
		//var data = "{IBCHART: {BACKCOLOR: '#FFFFFF',BORDERWIDTH: '1',TITLE: '',ETCDATA: [ {KEY:'sname', VALUE:'홍길동'},			{KEY:'age',   VALUE:'20'}		  ],DATA: {		POINTSET:[                 {AXISLABEL:'2012', 					  SERIES:[                 {LEGENDLABEL:'(주)이수시스템', VALUE:'5'}				 			 ]                     }                 , {AXISLABEL:'2013', 					  SERIES:[                 {LEGENDLABEL:'(주)이수시스템', VALUE:'7'}				 			 ]                     }                 , {AXISLABEL:'2014', 					  SERIES:[                 {LEGENDLABEL:'(주)이수시스템', VALUE:'21'}				 			 ]                     }                 , {AXISLABEL:'2015', 					  SERIES:[                 {LEGENDLABEL:'(주)이수시스템', VALUE:'37'}				 			 ]                     }                 , {AXISLABEL:'2016', 					  SERIES:[                 {LEGENDLABEL:'(주)이수시스템', VALUE:'50'}				 			 ]                     }                 , {AXISLABEL:'2017', 					  SERIES:[                 {LEGENDLABEL:'(주)이수시스템', VALUE:'93'}				 			 ]                     }                 , {AXISLABEL:'2018', 					  SERIES:[                 {LEGENDLABEL:'(주)이수시스템', VALUE:'166'}				 			 ]                     }                 , {AXISLABEL:'2019', 					  SERIES:[                 {LEGENDLABEL:'(주)이수시스템', VALUE:'439'}				 			 ]                     }                 , {AXISLABEL:'2020', 					  SERIES:[                 {LEGENDLABEL:'(주)이수시스템', VALUE:'708'}				 			 ]                     }                 , {AXISLABEL:'2021', 					  SERIES:[                 {LEGENDLABEL:'(주)이수시스템', VALUE:'709'}				 			 ]                     } 				 ] 	  }}}";
		//data = "{IBCHART:{BACKCOLOR:'#FFFFFF',BORDERWIDTH:'1',TITLE:'',ETCDATA:[{KEY:'sname', VALUE:'홍길동'},{KEY:'age',   VALUE:'200000'}],DATA:{POINTSET:[{AXISLABEL:'2020',SERIES:[{LEGENDLABEL:'(주)이수시스템', VALUE:'708'}]},{AXISLABEL:'2021',SERIES:[{LEGENDLABEL:'(주)이수시스템', VALUE:'750'}]}]}}}";
		//console.log('data', data);
		//result = data;
		//console.log('JSON.stringify(result)', JSON.stringify(result));
		
		chart.GetDataJsonString(result);
	}
	
	
	function callGuageChar(sabun, targetOrg) {
		
		var data = null;
		if(targetOrg == ".graph_circleA") {
			data = ajaxCall("${ctx}/EmpTimelineSrch.do?cmd=getAppmtTimelineSrchVacationChartList","searchSabun=" + sabun,false);
		}
		//console.log('callGuageChar data', data);
		
		var dataset = null;
		if( data != null && data != undefined && data.DATA != null && data.DATA != undefined ) {
			if( (data.DATA.usedCnt + data.DATA.restCnt) > 0 ) {
				dataset = [
					{ label: 'Dijkstra', count: data.DATA.usedCnt },
					{ label: 'Abulia',   count: data.DATA.restCnt }
				];
			} else {
				dataset = [
					{ label: 'Dijkstra', count: 1 },
					{ label: 'Abulia',   count: 0 }
				];
			}
			
			var html = "";
			if(targetOrg == ".graph_circleA") {
				html += "<span class=\"graph_circle_stitle\">잔여일수</span>";
				html += "<span class=\"graph_circle_type mal5\">" + data.DATA.restCnt + "</span><span class=\"graph_circle_total\">/" + (data.DATA.usedCnt + data.DATA.restCnt) + "</span>";
			}
			$(".graph_circle_txt", $(targetOrg)).html(html);
			
			drawChartGuage(targetOrg, dataset);
		}
	}

	
	function drawChartGuage(targetObj, dataset) {
		if( $("svg", targetObj).length > 0 ) {
			$("svg", targetObj).remove();
		}

		var width = 400;
		var height = 400;
		
		width = parseInt($($(targetObj).parent()).width() * 0.45);
		height = width;
		
		$(targetObj).css({
			"text-align" : "center"
		});
		$(".graph_circle_txt", targetObj).css({
			"width" : "100%",
			"top" : (height/2) + "px"
		});
		
		var radius = Math.min(width, height) / 2;
		var donutWidth = 20;
		var legendRectSize = 6;                                  // NEW
		var legendSpacing = 1;                                    // NEW

		var color = d3.scaleOrdinal(d3.schemeCategory20b);
		var svg = d3.select(targetObj)
					.append('svg')
					.attr('width', width)
					.attr('height', height)
					.append('g')
					.attr('transform', 'translate(' + (width / 2) + ',' + (height / 2) + ')');
		
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
						if ( i == 1 ) {
							return "#018ed4";
						}else {
							return "#f4617c";
						}
					});
		
		$("svg", targetObj).css({
			"position" : "relative",
			"top" : "-20px"
		});
	}
	
	function callCompareBarChar(sabun, targetOrg) {
		
		var data = null;
		if(targetOrg == ".graph_barA") {
			data = ajaxCall("${ctx}/EmpTimelineSrch.do?cmd=getAppmtTimelineSrchWorkYearChartList","searchSabun=" + sabun,false);
		}
		//console.log('callCompareBarChar data', data);
		
		var dataset = null;
		if( data != null && data != undefined && data.DATA != null && data.DATA != undefined ) {
			dataset = { cnt1: data.DATA.cnt1, cnt2: data.DATA.cnt2 };
			
			if(targetOrg == ".graph_barA") {
				$("#empWorkYear").html(data.DATA.cnt1);
				$("#avgWorkYear").html(data.DATA.cnt2);
			}
			
			drawChartCompare(targetOrg, dataset);
		}
		progressBar(false);
	}

	
	function drawChartCompare(targetObj, dataset) {
		var width = 100;
		var chart1 = dataset.cnt1;
		var chart2 = dataset.cnt2;
		var max = (chart1 > chart2) ? chart1 : chart2;
		var min = (chart1 > chart2) ? chart2 : chart1;
		var maxObj = (chart1 > chart2) ? "bar1" : "bar2";
		var minWidth = parseInt(width / max * min);
		
		$("." + maxObj + " rect", $(targetObj)).width(0);
		$("." + maxObj + " rect", $(targetObj)).animate({
			width: width + "%",
			opacity: 1
		}, 1500 );

		if( maxObj == "bar1" ) {
			$(".bar2 rect", $(targetObj)).width(0);
			$(".bar2 rect", $(targetObj)).animate({
				width: minWidth + "%",
				opacity: 1
			}, 1500 );
		} else {
			$(".bar1 rect", $(targetObj)).width(0);
			$(".bar1 rect", $(targetObj)).animate({
				width: minWidth + "%",
				opacity: 1
			}, 1500 );
		}
	}

	function showRd(enterCd, sabun) {
		var enterCdSabun = "";
		var searchSabun = "";
		enterCdSabun += ",('" + enterCd +"','" + sabun + "')";
		searchSabun  += "," + sabun;

		var rdParam ="";

		rdParam += "["+ enterCdSabun +"] "; //회사코드, 사번
		rdParam += "[${baseURL}] ";//이미지위치---3
		rdParam += "[Y] "; //개인정보 마스킹
		rdParam += "[${ssnEnterCd}] ";
		rdParam += "[ '${ssnSabun}' ] ";//rdParam  += "["+searchSabun+"]"; // 사번list->세션사번으로 변경(2016.04.14)
		rdParam += "[${ssnLocaleCd}] ";	// 10.다국어코드
		rdParam += "['"+ searchSabun +"'] "; //사번

		const data = {
			parameters : rdParam
		};
		window.top.showRdLayer('/EmpTimelineSrch.do?cmd=getEncryptRd', data, null, 'Profile Card');

	}
</script>
<style type="text/css">
	.sheet_search, .cbp_tmtimeline * {
		box-sizing:initial;
	}
	
	#detailList {
		background-color:#f7f7f7;
		padding:10px;
		border:1px solid #ebeef3;
		overflow-x:hidden;
		overflow-y:auto;
		min-width:240px;
	}
	
	.tile-stats.card-profile {
		padding:15px;
		cursor:pointer;
	}
	
	.tile-stats.card-profile.choose {
		background-color:#efefef;
	}
	
	
	.tile-stats.card-profile .profile_info .profile_desc {
		width:100%;
	}
	
	.tile-stats.card-profile .profile_info .profile_desc li.full {
		width:100%;
	}

	.tile-stats.card-profile .profile_info .profile_desc li.keyword-li {
		padding-left: 13px;
		text-indent: -13px;
	}

	.tile-stats.card-profile .profile_info .profile_desc li.keyword-li:before {
		text-indent: 0px;
	}
	
	
	/* Timeline */
	.cbp_tmtimeline > li .cbp_tmtime span:first-child {font-size:1em; line-height:1em;}
	.cbp_tmtimeline > li .cbp_tmtime span:last-child  {font-size:1.5em; line-height:1.5em;}
	.cbp_tmtimeline > li .cbp_tmicon {
		width:10px;
		height:10px;
		line-height: 10px;
		left:20%;
		margin-left:-12px;
		box-shadow: 0 0 0 4px var(--bg_color_base);
	}
	.cbp_tmtimeline:before {
		width: 5px;
		left: 20%;
	}
	.cbp_tmtimeline > li .cbp_tmlabel {
		margin-right:5%;
		padding:1.2em;
	}
	@media screen and (-ms-high-contrast: active), (-ms-high-contrast: none) {
		.cbp_tmtimeline > li .cbp_tmtime {
			padding-right: 45px;
		}
	}
	/* Timeline */
	
	.graph_circle_txt {
		position:relative;
		text-align:center;
	}
	
	.graph_barA svg {width:100%; height:20px;}
	.graph_barA svg.bar1 rect { width:10%; fill:#f4617c; }
	.graph_barA svg.bar2 rect { width:10%; fill:#018ed4; }


</style>
</head>
<body class="bodywrap" style="background-color:#fff;">
<div class="wrapper">

	<form id="empForm" name="empForm" >
	<input type="hidden" id="searchYmd" name="searchYmd" value="${ curSysYyyyMMdd }" />
	<div class="sheet_search outer">
		<div>
			<table>
				<tr>
					<th>부서</th>
					<td>
						<select id="searchOrgCd" name="searchOrgCd"></select>
					</td>
					<th><tit:txt mid='104330' mdef='사번/성명'/></th>
					<td>
						<input type="text" id="searchName" name="searchName" class="text"/>
					</td>
					<td><btn:a href="javascript:showEmpList();" css="btn dark" mid='110697' mdef="조회"/></td>
				</tr>
			</table>
		</div>
	</div>
	</form>
	
	<table id="timelineBox" border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<colgroup>
			<col width="30%"/>
			<col width="30%"/>
			<col width="*"/>
		</colgroup>
		<tr>
			<td>
				<div class="sheet_title">
				<ul>
					<li class="txt">임직원</li>
					<li class="btn"></li>
				</ul>
				</div>
				<div id="detailList" class="list_box">
				</div>
			</td>
			<td>
				<div class="sheet_title mal10">
				<ul>
					<li class="txt">Timeline</li>
					<li class="btn"></li>
				</ul>
				</div>
				<div class="list_box mal10" style="border:1px solid #ebeef3; overflow-y:auto;">
					<ul class="cbp_tmtimeline"></ul>
				</div>
			</td>
			<td>
				<div class="list_box mat40 mal10" style="border:1px solid #ebeef3; overflow-y:auto; padding:10px;">
					<div class="sheet_title mal10">
						<ul>
							<li class="txt">연봉 추이</li>
						</ul>
					</div>
					<script type="text/javascript"> createIBChart("myChart1", "100%", "25%"); </script>
					<div class="sheet_title mal10">
						<ul>
							<li class="txt">성과 추이</li>
						</ul>
					</div>
					<script type="text/javascript"> createIBChart("myChart2", "100%", "25%"); </script>
					<div>
						<div class="floatL" style="width:50%;">
							<div class="sheet_title">
								<ul>
									<li class="txt">연차사용현황</li>
								</ul>
							</div>
							<div class="graph_circleA">
								<div class="graph_circle_txt"></div>
							</div>
						</div>
						<div class="floatR" style="width:50%;">
							<div class="sheet_title">
								<ul>
									<li class="txt">근속현황</li>
								</ul>
							</div>
							<div class="graph_barA padl20 padr20">
								<h3 class="mat30">근속년수 : <span id="empWorkYear" class="f_bold f_point f_s25"></span>년</h3>
								<svg class="bar1 mat5">
									<rect x="0" y="0" rx="10" ry="10" width="50%" height="20" />
								</svg>
								<h3 class="mat20">임직원 평균 근속년수 : <span id="avgWorkYear" class=""></span>년</h3>
								<svg class="bar2 mat5">
									<rect x="0" y="0" rx="10" ry="10" width="50%" height="20" />
								</svg>
							</div>
						</div>
					</div>
				</div>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
