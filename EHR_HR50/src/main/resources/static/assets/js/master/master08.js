/* 기본근무 차트 옵션 */
var baseOption = {
	  series: [{ data: [] }],
      chart: {
        height: 244,
        type: 'bar'
      },
      stroke: {
        width: 1,
      },
      yaxis: {
        show: false,
        tickAmount: 7,
      },
      colors: ["#2570f9"],
      plotOptions: {
        bar: {
          columnWidth: '4px',
          distributed: true,
        }
      },
      dataLabels: {
        enabled: false
      },
      legend: {
        show: false
      },
      xaxis: {
        categories: [],
        labels: { style: { fontSize: '12px' } }
      }
    };

/* 연장근무 차트 option */
var overTimeOption = {
	    series: [],
	    chart: { height: 287, type: 'radialBar' },
		colors: ["#2570f9"],
		plotOptions: {
			radialBar: { hollow: { size: '84%' } }
		},
		dataLabels: {enabled: false},
		labels: [""],
	};

/* 휴가현황 차트 option */
var vacationOption = {
		series: [ { name: "휴가사용량", data: [] } ],
		chart: {
			type: 'line',
			zoom: { enabled: false },
			height: 110,
			width: 486,
		},
		colors: ["#34c759", "#00ff00"],
	    legend: { show: false, },
		dataLabels: { enabled: false },
		stroke: { curve: 'straight', width: 1 },
		yaxis: { show: false, tickAmount: 2, },
		xaxis: { categories: [] }
	};

function setBase(base) {
	var cTime = base.cmonthTime;
	var maxTime = base.maxTime.time;
	var minTime = base.minTime.time;
	$('#cmonthTime').text(cTime);
	var pmonthRate = 100 - Number(base.pmonthRate);
	if (pmonthRate < 0) {
		$('#pmonthRate').html('전달대비<span class="title_green">' + (base.pmonthRate * -1) + '%</span>증가');
	}  else {
		$('#pmonthRate').html('전달대비<span class="title_red">' + base.pmonthRate + '%</span>감소');
	}
	
	var maxTimeHtml = '<span class="title_kor">최대 근무</span><span class="box_bnum">' + maxTime + '</span><span class="title_kor">시간</span>';
	maxTimeHtml += maxTime - cTime > 0 ? '<i class="mdi-ico time_plus">arrow_drop_up</i><span class="box_time time_plus">' +  (maxTime - cTime) + '</span>'
										:'<i class="mdi-ico time_minus">arrow_drop_down</i><span class="box_time time_minus">' + (cTime - maxTime) + '</span>';
	
	var minTimeHtml = '<span class="title_kor">최소 근무</span><span class="box_bnum">' + minTime + '</span><span class="title_kor">시간</span>';
	minTimeHtml += minTime - cTime > 0 ? '<i class="mdi-ico time_plus">arrow_drop_up</i><span class="box_time time_plus">' +  (minTime - cTime) + '</span>'
										:'<i class="mdi-ico time_minus">arrow_drop_down</i><span class="box_time time_minus">' + (cTime - minTime) + '</span>';
	
	$('#baseToday').text(base.today);
	$('#maxTime').html(maxTimeHtml);
	$('#minTime').html(minTimeHtml);
	
	const bdata = base.chart.map(d => d.time);
	const bcate = base.chart.map(d => d.title);
	
	var baseopt = { ...baseOption
				  	, series: [{ data: bdata }]
				  	, xaxis: { categories: bcate, labels: { style: { fontSize: '12px' } } } 
				  };
	
	if(document.querySelector("#attendanceBasic")) {
	    new ApexCharts(
	      document.querySelector("#attendanceBasic"),
	      baseopt
	    ).render();
	}
}

function setOverTime(overTime) {
	var maxTime = overTime.maxOverTime;
	var minTime = overTime.minOverTime;
	const remainHtml = overTime.remainTime + '<span class="title_kor">시간</span>' + overTime.remainMin + '<span class="title_kor">분 근무 가능</span>';
	$('#remainTime').html(remainHtml);
	
	var maxTimeHtml = '<span class="title_kor">최대 연장</span><span class="box_bnum">' + maxTime + '</span><span class="title_kor">시간</span>';
	maxTimeHtml += overTime.maxCompare > 0 ? '<i class="mdi-ico time_plus">arrow_drop_up</i><span class="box_time time_plus">' +  overTime.maxCompare + '</span>'
										:'<i class="mdi-ico time_minus">arrow_drop_down</i><span class="box_time time_minus">' + overTime.maxCompare + '</span>';
	
	var minTimeHtml = '<span class="title_kor">최소 연장</span><span class="box_bnum">' + minTime + '</span><span class="title_kor">시간</span>';
	minTimeHtml += overTime.minCompare > 0 ? '<i class="mdi-ico time_plus">arrow_drop_up</i><span class="box_time time_plus">' +  overTime.minCompare + '</span>'
										:'<i class="mdi-ico time_minus">arrow_drop_down</i><span class="box_time time_minus">' + overTime.minCompare + '</span>';
	
	$('#maxOverTime').html(maxTimeHtml);
	$('#minOverTime').html(minTimeHtml);
	$('#weekTime').html(overTime.weekTime + '<div class="box_mark">H</div>');
	$('#weekRate').text(overTime.weekTimePer + '%');
	
	var overopt = { ...overTimeOption
				  , series: [overTime.weekTimePer]};
	
	
	if(document.querySelector("#attendanceOvertime")){
	    new ApexCharts(
	      document.querySelector("#attendanceOvertime"),
	      overopt
	    ).render();
	  }
}

function setVacation(vacation) {
	$('#usedCnt').text(vacation.data[0].usedCnt);
	$('#restCnt').text(vacation.data[0].restCnt);
	$('#myVacationProgress').html('<div class="progress_bar bar_blue" style="width:' + vacation.data[0].rate + '%"></div>');
	$('#vacaTotalRate').html(vacation.totals[0].rate + '<span class="box_num">%</span>')
	$('#vacaTotalProgress').html('<div class="progress_bar bar_blue" style="width:' + vacation.totals[0].rate + '%"></div>');
	
	const months = vacation.months;
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
	
	var vacaopt = { ...vacationOption
		  	, series: [{ data: data }]
		  	, xaxis: { categories: categories } 
		  };
	
	if(document.querySelector("#vacationWideChart")){
	    new ApexCharts(
	      document.querySelector("#vacationWideChart"),
	      vacaopt
	    ).render();
	}
}

function goPage(page) {
	if (window.parent.goSubPage) {
		window.parent.goSubPage('08', '', '', '', page);
	}
}

$(document).ready(function () {
	const { base, overTime, vacation, appls } = ajaxCall('/base08Data.do', '', false).data;
	setBase(base);
	setOverTime(overTime);
	setVacation(vacation);
});