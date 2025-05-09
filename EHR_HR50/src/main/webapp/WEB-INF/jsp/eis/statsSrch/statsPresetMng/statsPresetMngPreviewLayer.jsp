<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html><html class="bodywrap"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>통계구성 미리보기</title>

<link href="${ctx}/common/plugin/EIS/css/chart.css?ver=<%= System.currentTimeMillis()%>" rel="stylesheet" />
<script src="${ctx}/common/plugin/EIS/js/chart.js?ver=<%= System.currentTimeMillis()%>" type="text/javascript" charset="UTF-8"></script>
<style type="text/css">
	.editPresetInfo {
		z-index: 10;
		position: fixed;
		top: 10px;
		right: 50px;
		display: inline-block;
		min-width: 40px;
		text-align: center;
		background-color: #fff;
		height: 28px;
		line-height: 26px;
		border-radius: 14px;
		padding: 0 15px;
	}
	.popup_main {
		min-height: calc(100vh - 88px);
		max-height: calc(100vh - 88px);
		overflow-x: hidden;
		overflow-y: auto;
	}
</style>
<script type="text/javascript">
	var statsPresetMngPreviewLayer = {id:"statsPresetMngPreviewLayer"};
	var g_spaceSize = 30, g_columnCnt = 6, g_defaultSize = 220;
	var g_chartListEle, statsData, showPreloader = false;
	
	$(function() {
		const modal = window.top.document.LayerModalUtility.getModal(statsPresetMngPreviewLayer.id);
		var { searchPresetTypeCd, searchPresetOwner, searchPresetId, searchPresetNm } = modal.parameters;
		$("#searchPresetTypeCd").val(searchPresetTypeCd);
		$("#searchPresetOwner").val(searchPresetOwner);
		$("#searchPresetId").val(searchPresetId);
		$("#searchPresetNm").val(searchPresetNm);
		
		// 현재작업통계구성명 삽입
		$(".editPresetInfo").html($("<span/>", {
			"class" : ""
		}).text("현재 작업중인 통계 구성 : "));
		$(".editPresetInfo").append($("<span/>", {
			"class" : "f_point f_bold"
		}).text(searchPresetNm));
		
		var scrWidth = screen.availWidth;
		if( scrWidth < 1440 ) {
			g_defaultSize = 180;
		} else if( scrWidth < 1024 ) {
			g_defaultSize = 130;
		}
		g_chartListEle = $("#area_chartList");
		
		g_chartListEle.css({
			"width" : ((g_defaultSize * g_columnCnt) + ((g_columnCnt + 1) * g_spaceSize)) + "px"
		});
		
		// show preloader
		progressBar(true);
		showPreloader = true;
		
		// 데이터 조회
		statsData = ajaxCall("${ctx}/StatsPresetMng.do?cmd=getStatsPresetMngUseItemDtlData", $("#sheetForm").serialize(), false);
		
		// 통계 초기화
		initChartDashboard();
	});

	// 통계 초기화
	function initChartDashboard() {
		// 차트 출력 영역 초기화
		g_chartListEle.empty();
		if( statsData != null && statsData.LIST != undefined && statsData.LIST != null && statsData.LIST.length > 0 ) {
			// 1. 차트 박스 레이아웃 추가
			statsData.LIST.forEach(function(item, idx, arr){
				// 차트 레이아웃 추가
				if( item.useYn == "Y" ) {
					addChartLayout(item, idx);
				}
			});
			
			var dataList;
			statsData.LIST.forEach(function(item, idx, arr){
				if( item.useYn == "Y" && item.dummyYn == "N" ) {
					dataList = null;
					if( statsData.DATA && statsData.DATA != null && statsData.DATA[item.statsCd] && statsData.DATA[item.statsCd] != null ) {
						dataList = statsData.DATA[item.statsCd];
					}
					
					// 차트 데이터를 개별로 조회해야 하는 상황이며 데이터 조회 SQL이 존재하는 통계인 경우
					if( statsData.DATA.ajaxCallFlag == "Y" && item.existsSql == "Y" ) {
						drawChartBeforeGetData(item);
					} else {
						// 차트 출력
						drawChart(item, dataList);
					}
				}
				
				// destroy preloader
				if( idx > 3 && showPreloader ) {
					progressBar(false);
					showPreloader = false;
				}
			});
			
			var dashboardHeight = $(".stats-item:last", g_chartListEle).position().top;
			dashboardHeight += $(".stats-item:last", g_chartListEle).outerHeight() + 30;
			g_chartListEle.css({
				"height" : dashboardHeight + "px"
			});
		}
		
		// destroy preloader
		if( showPreloader ) {
			setTimeout(function() {
				progressBar(false);
				showPreloader = false;
			}, 250);
		}
	}
	
	// add layout
	function addChartLayout(item, statsIdx) {
		var top, left, width, height;
		var widgetId, dummyYn, statsCd, statsNm, chartPositionX, chartPositionY, chartSizeW, chartSizeH;
		widgetId = item.widgetId;
		dummyYn = item.dummyYn;
		statsCd = item.statsCd;
		statsNm = item.statsNm;
		chartPositionX = parseInt(item.chartPositionX);
		chartPositionY = parseInt(item.chartPositionY);
		chartSizeW     = parseInt(item.chartSizeW);
		chartSizeH     = parseInt(item.chartSizeH);
		
		top    = (chartPositionY == 0) ? 0 : (g_defaultSize * chartPositionY) + ((chartPositionY - 1) * g_spaceSize);
		left   = (chartPositionX == 0) ? 0 : (g_defaultSize * chartPositionX) + ((chartPositionX - 1) * g_spaceSize);
		width  = (g_defaultSize * chartSizeW) + ((chartSizeW - 1) * g_spaceSize);
		height = (g_defaultSize * chartSizeH) + ((chartSizeH - 1) * g_spaceSize);
		
		if( chartPositionY > 0 ) top += g_spaceSize;
		if( chartPositionX > 0 ) left += g_spaceSize;
		
		var itemEle = $("<div/>", {
			"class"    : "stats-item",
			"id"       : widgetId,
			"statsCd"  : statsCd,
			"dummyYn"  : dummyYn,
			"data-w"   : chartSizeW,
			"data-h"   : chartSizeH,
		});
		itemEle.attr({
			"pos-top"  : top,
			"pos-left" : left,
		}).css({
			"width"    : width + "px",
			"height"   : height + "px",
		});
		itemEle.append($("<div/>", {
			"class"    : "chart",
			"id"       : "chart_"+ widgetId
		}));
		
		// 더미 위젯이 아닌 경우
		if( dummyYn == "N" ) {
			itemEle.find(".chart").append($("<img />", {
				"src"   : "${ctx}/common/images/common/loading_s.gif",
				"style" : "display:flex; align-self: center; height: 32px;"
			}));
		} else {
			itemEle.addClass("dummy");
		}
		
		g_chartListEle.append(itemEle);
	}
	
	// 차트 화면 출력 전 데이터 조회 후 차트 출력 처리
	function drawChartBeforeGetData(statsItem) {
		$.ajax({
			url: "${ctx}/StatsMng.do?cmd=getStatsMngChartDataMap",
			type: "post",
			dataType: "json",
			async: true,
			data: "searchStatsCd=" + statsItem.statsCd,
			success: function(data) {
				if( data && data != null ) {
					var dataList = data.LIST;
					// 차트 화면 출력
					drawChart(statsItem, dataList);
				}
			},
			error: function(jqXHR, ajaxSettings, thrownError) {
				ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
			}
		});
	}
	
	// 차트 화면 출력
	function drawChart(statsItem, dataList) {
		var chartOpt = {}, dataExists = true, rtnChart;
		
		// set chart option
		if( statsItem.chartOpt && statsItem.chartOpt != "" ) {
			chartOpt = eval("(" + statsItem.chartOpt + ")");
		}
		if( chartOpt.chart == undefined ) {
			chartOpt.chart = {};
		}
		
		// 데이터가 존재하지 않는 경우
		if( dataList == undefined || dataList == null ) {
			dataExists = false;
			if( (statsItem.pluginObjNm.indexOf("APEX") > -1)
					&& (chartOpt.series != undefined && chartOpt.series != null) ) {
				dataExists = true;
			}
		}
		
		if( dataExists ) {
			// set chart size
			var chartSizeW = parseInt(statsItem.chartSizeW), chartSizeH = parseInt(statsItem.chartSizeH);
			chartOpt.chart.width  = (g_defaultSize * chartSizeW) + ((chartSizeW - 1) * g_spaceSize) - g_spaceSize;
			chartOpt.chart.height = (g_defaultSize * chartSizeH) + ((chartSizeH - 1) * g_spaceSize) - g_spaceSize;
			if( parseInt(statsItem.chartSizeH) == 1 ) {
				chartOpt.chart.height -= (g_spaceSize/2);
			}
			//console.log('[drawChart] chartOpt', chartOpt);
			
			// put param
			chartOpt.param = $("#sheetForm").serializeObject();
			
			// 차트 출력 영역 초기화
			$("#area_chartList .stats-item[id='" + statsItem.statsCd + "'] .chart").empty();
			// render chart
			rtnChart = HR_CHART[statsItem.pluginObjNm].render("#area_chartList .stats-item[id='" + statsItem.statsCd + "'] .chart", chartOpt, dataList);
		} else {
			$("#area_chartList .stats-item[id='" + statsItem.statsCd + "'] .chart").append(
				$("<ul/>", {
					"class" : "empty"
				}).append(
					$("<li/>", {
						"class" : "f_point f_s14 mar10"
					}).html("[ " + statsItem.statsNm + " ]")
				)
			);
			var msg = "";
			if( !dataExists ) {
				msg = "출력 데이터가 존재하지 않습니다.";
			}
			$("#area_chartList .stats-item[id='" + statsItem.statsCd + "'] .chart .empty").append(
				$("<li/>", {
					"class" : "reason"
				}).html(msg)
			);
		}
	}
</script>

</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="editPresetInfo"></div>
	<div class="popup_main">
		<form id="sheetForm" name="sheetForm" tabindex="1">
			<input id="searchPresetTypeCd" name="searchPresetTypeCd" type="hidden" >
			<input id="searchPresetOwner" name="searchPresetOwner" type="hidden" >
			<input id="searchPresetId" name="searchPresetId" type="hidden" >
			<input id="searchPresetNm" name="searchPresetNm" type="hidden" >
		</form>
		<div id="area_chartWrap">
			<div id="area_chartList"></div>
		</div>
	</div>
</div>
</body>
</html>