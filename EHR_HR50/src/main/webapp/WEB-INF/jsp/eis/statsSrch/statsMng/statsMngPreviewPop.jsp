<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>요구사항 팝업</title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
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
	#area_chart {
		display: flex;
		justify-content: center;
		align-content: center;
		min-width: 200px;
		min-height: 200px;
		border-radius: 8px;
		background-color: #fff;
		box-sizing: border-box;
		box-shadow: 0 4px 12px 0 rgba(0,0,0,0.2);
	}
	#area_chart .chart {
		display: flex;
		align-items: center;
	}
</style>
<script type="text/javascript">
	var p = eval("${popUpStatus}");

	$(function() {

		$(".close").click(function(){
			p.self.close();
		});
		
		var arg     = p.window.dialogArguments;
		var searchStatsCd = "";
		var searchStatsNm = "";
		var chartSizeW    = "";
		var chartSizeH    = "";
		var originSizeYn  = "Y";
		
		if( arg != undefined ) {
			searchStatsCd = arg["searchStatsCd"];
			searchStatsNm = arg["searchStatsNm"];
			chartSizeW    = arg["chartSizeW"];
			chartSizeH    = arg["chartSizeH"];
			originSizeYn  = arg["originSizeYn"];
		}else{
			if ( p.popDialogArgument("searchStatsCd") !=null ) { 	searchStatsCd = p.popDialogArgument("searchStatsCd"); }
			if ( p.popDialogArgument("searchStatsNm") !=null ) { 	searchStatsNm = p.popDialogArgument("searchStatsNm"); }
			if ( p.popDialogArgument("chartSizeW")    !=null ) { 	chartSizeW    = p.popDialogArgument("chartSizeW"); }
			if ( p.popDialogArgument("chartSizeH")    !=null ) { 	chartSizeH    = p.popDialogArgument("chartSizeH"); }
			if ( p.popDialogArgument("originSizeYn")  !=null ) { 	originSizeYn  = p.popDialogArgument("originSizeYn"); }
		}

		$("#searchStatsCd").val(searchStatsCd);
		$("#searchStatsNm").val(searchStatsNm);
		$("#chartSizeW").val(chartSizeW);
		$("#chartSizeH").val(chartSizeH);
		
		// 현재작업통계구성명 삽입
		$(".editPresetInfo").html($("<span/>", {
			"class" : ""
		}).text("작업 통계 : "));
		$(".editPresetInfo").append($("<span/>", {
			"class" : "f_point f_bold"
		}).text(searchStatsNm));
		
		var data = ajaxCall("${ctx}/StatsMng.do?cmd=getStatsMngChartDataMap",$("#sendForm").serialize(),false);
		if( data && data != null && data.DATA && data.DATA != null ) {
			// set chart option
			var chartOpt = eval("(" + data.DATA.chartOpt + ")");
			if( chartOpt.chart == undefined ) {
				chartOpt.chart = {};
			}
			
			// set chart size
			var defaultSize = 200;
			if( originSizeYn == "Y" ) {
				chartOpt.chart.width = (parseInt(data.DATA.chartSizeW) * defaultSize);
				chartOpt.chart.height = (parseInt(data.DATA.chartSizeH) * defaultSize);
			} else {
				chartOpt.chart.width = (parseInt(chartSizeW) * defaultSize);
				chartOpt.chart.height = (parseInt(chartSizeH) * defaultSize);
			}
			
			// render chart
			$("#area_chart .chart").css({
				"width" : chartOpt.chart.width + "px",
				"height" : chartOpt.chart.height + "px"
			})
			HR_CHART[data.DATA.pluginObjNm].render("#area_chart .chart", chartOpt, data.LIST);
		}
		
	});
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="popup_title">
		<ul>
			<li id="locationPopup">차트 미리보기</li>
			<li class="close"></li>
		</ul>
	</div>
	<div class="editPresetInfo"></div>
	<div class="popup_main">
		<form id="sendForm" name="sendForm" method="POST">
			<input type="hidden" id="searchStatsCd" name="searchStatsCd" value="" />
			<input type="hidden" id="searchStatsNm" name="searchStatsNm" value="" />
			<input type="hidden" id="chartSizeW"    name="chartSizeW"    value="" />
			<input type="hidden" id="chartSizeH"    name="chartSizeH"    value="" />
			<input type="hidden" id="originSizeYn"  name="originSizeYn"  value="" />
		</form>
		<div id="area_chart">
			<div class="chart"></div>
		</div>
		<div class="popup_button">
			<ul>
				<li>
					<a href="javascript:p.self.close();" class="gray large"><tit:txt mid='104157' mdef='닫기'/></a>
				</li>
			</ul>
		</div>
	</div>
</div>

</body>
</html>