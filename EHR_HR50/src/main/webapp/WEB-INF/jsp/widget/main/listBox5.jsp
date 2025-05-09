<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<script type="text/javascript">
var widget5 = {
	size: null,
	chart: null,
	option: {
		series: [ { name: "휴가사용량", data: [] } ],
		chart: {
			type: 'line',
			zoom: { enabled: false },
			height: 110,
			width: 206,
		},
		colors: ["#34c759", "#00ff00"],
	    legend: { show: false, },
		dataLabels: { enabled: false },
		stroke: { curve: 'straight', width: 1 },
		yaxis: { show: false, tickAmount: 2, },
		xaxis: { categories: [] }
	}
};

function init_listBox5(size) {
	widget5.size = size;
	loadWidget5();
}

function loadWidget5() {
	$('#widget5MoreIco').off().click(function() {
		goSubPage("08", "", "", "", "VacationApp.do?cmd=viewVacationApp");
	});
	
	const data = ajaxCall('/getListBox5List.do', '', false).DATA[0];
	const months = ajaxCall('/getListBox5MonthList.do', '', false).DATA;

	var html = '';
	if (widget5.size == 'wide') {
		const totals = ajaxCall('/getListBox5TotalList.do', '', false).DATA[0];
		html += '<div class="container_box">\n'
			 + '	<div class="container_left">'
			 + '		<div class="content_header">\'${sessionScope.ssnName}\' 휴가 현황</div>\n'
			 + '		<div class="content_info">\n'
			 + '			<div class="info_box">\n'
			 + '				<span class="info_title title_vacation">휴가</span>\n'
			 + '				<span class="box_num">' + data.creCnt + '</span>\n'
			 + '			</div>\n'
			 + '			<div class="info_box">\n'
			 + '				<span class="info_title title_leftover">잔여</span>\n'
			 + '				<span class="box_bnum">' + data.restCnt + '</span>\n'
			 + '			</div>\n'
			 + '		</div>\n'
			 + '		<div class="progress_container">\n'
			 + '			<div class="progress_bar bar_blue" style="width:' + data.rate + '%"></div>\n'
			 + '		</div>\n'
			 + '	</div>\n'
			 + '	<div class="container_right">\n'
			 + '		<div class="content_header">전체휴가현황</div>\n'
			 + '		<div class="content_info">\n'
			 + '			<div class="info_box">\n'
			 + '				<div class="content_sub_header"></div>'
			 + '				<div class="info_title">전체 휴가 사용량</div>\n'
			 + '			</div>\n'
			 + '			<div class="info_box total_per">\n'
			 + '				<span class="box_bnum">' + data.rate + '<span class="box_num">%</span></span>\n'
			 + '			</div>\n'
			 + '		</div>\n'
			 + '		<div class="progress_container">\n'
			 + '			<div class="progress_bar bar_blue" style="width: ' + data.rate + '%"></div>\n'
			 + '		</div>\n'
			 + '	</div>\n'
			 + '</div>\n'
			 + '<div class="vacation_chart">\n'
			 + '	<div id="vacationChart"></div>\n'
			 + '</div>';
	} else {
		html += '<div class="content_area">\n'
			 + '	<div class="total_leftover">\n'
			 + '		<span class="info_title leftover">잔여(전체)</span>\n'
			 + '		<span class="info_leftover">' + data.restCnt + '</span>\n'
			 + '		<span class="info_total">/' + data.creCnt + '</span>\n'
			 + '	</div>\n'
			 + '	<div class="total_per">\n'
			 + '		<span class="info_title usage">휴가 사용량</span>\n'
			 + '		<span class="info_per">' + data.rate + '<span class="info_per_no">%</span></span>\n'
			 + '	</div>\n'
			 + '	<div class="progress_container">\n'
			 + '		<div class="progress_bar bar_blue" style="width:' + data.rate + '%"></div>\n'
			 + '	</div>\n'
			 + '</div>'
			 + '<div class="vacation_chart">\n'
			 + '	<div id="vacationChart"></div>\n'
			 + '</div>';
	}
	$('#widget5Body').html(html);
	widget8DrawChart(months);
}

function widget8DrawChart(months) {
	const minM = Math.min(...months.map(d => d.m));
	const maxM = Math.max(...months.map(d => d.m));

	var categories = [];
	var data = [];

	for (var i=minM; i<=maxM; i++) {
		const mname = i + '월';
		categories.push(mname);
		var fdata = months.find(d => d.m == i);
		if (fdata) data.push(fdata.appDay);
		else data.push(0);
	}
	
	widget5.option.chart.width = widget5.size == 'wide' ? 486:206;
	widget5.option.series[0].data = data;
	widget5.option.xaxis.categories = categories;
	widget5.chart = new ApexCharts(document.querySelector("#vacationChart"), widget5.option);
	widget5.chart.render();
}
</script>
<div class="widget_content">
	<div class="widget_header">
		<div class="widget_title">
		  <i class="mdi-ico">flight</i>휴가현황
		</div>
		<i id="widget5MoreIco" class="mdi-ico" style="cursor:pointer;">more_horiz</i>
	</div>
	<div id="widget5Body" class="widget_body widget_vacation">
	</div>
</div>