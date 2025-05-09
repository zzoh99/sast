<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<style type="text/css">

</style>
<script type="text/javascript">
var g_defaultSize=250;
var widget = {
	size: null
};

/* function init_listBoxStats(size, menuCode, statsCd) {
	$("#statsCd").val(statsCd);
	widget.size = size;
	var header = ajaxCall( "${ctx}/WidgetMgr.do?cmd=getStatsWidgetInfo", $("#sendForm").serialize(), false);

	var widgetChart=new WidgetChart(header.DATA);
	widgetChart.draw();
}

function WidgetChart(header){
	this.header=header;
	this.draw=function(){
		var chartOpt = eval("(" + header.chartOpt + ")");
		try{
			if( chartOpt.chart == undefined ) {
				chartOpt.chart = {};
			}

			var sizeW = (widget.size == "normal"? 1 : 2);
			var sizeH = 1;

			chartOpt.chart.width = (parseInt(header.chartSizeW) * g_defaultSize);
			chartOpt.chart.height = (parseInt(header.chartSizeH) * g_defaultSize);

			let d = new Date();
			let ms = d.getTime();

			var widgetId="widget_listBoxStats_"+ms;
			var chartId="chart_"+ms;
			var areaChartWrapId="area_chartWrap_"+ms
			var chartAreaHtml="";
			chartAreaHtml+="<div id='"+areaChartWrapId+"'>";
			chartAreaHtml+="<div id='"+chartId+"'></div>";
			chartAreaHtml+="</div>";


			$("#widget_listBoxStats").attr("id", widgetId);
			$("#"+widgetId).append(chartAreaHtml);


			var chart = HR_CHART[header.pluginObjNm].render('#'+chartId, chartOpt, header.data);

		}catch(e){
			alert(e.message);
		}
	}
} */


</script>
<!-- <div class="widget_header">
  <div class="widget_title"></div>
</div> -->
<div class="widget_body widget-common">
  	<form id="sendForm" name="sendForm">
		<input type="hidden" id="statsCd" name="statsCd">
  	</form>
	<!-- <div id="area_chartWrap">
		<div class="chart" ></div>
	</div> -->
</div>
